#include "SocketManager.h"
#include "ODSocket.h"
#include "TcpMessageBuilder.h"
#include "MessageQueue.h"
#include <string>
#include "cocos2d.h"
using namespace std;
USING_NS_CC;

extern "C"
{

}


//添加message到发送网络请求的队列
void SocketManager::addMessageToSendQueue(string message)
{
	Message m;
	if(!message.empty()){
		m.message = message;
		m.code = MESSAGE_TYPE_SEND_NEW_MESSAGE; 
	}else{
		m.code = MESSAGE_TYPE_SEND_HEART_BEAT;
	}
	

	//pthread_mutex_lock(SocketManager::getInstance()->getReqMutex());//*锁定互斥量*/
	std::mutex * mutexRq = SocketManager::getInstance()->getReqMutex();
	std::condition_variable* conditionRq = SocketManager::getInstance()->getCond();
	std::unique_lock<std::mutex> lck(*mutexRq);
	SocketManager::getInstance()->messageQueue->push(m);
	//pthread_cond_signal(SocketManager::getInstance()->getCond());/*条件改变，发送信号，通知m_sendThread进程*/
	conditionRq->notify_all();
	//pthread_mutex_unlock(SocketManager::getInstance()->getReqMutex());//*解锁互斥量*/


}

void* SocketManager::gstartSendLooper(void* pData)
{
		while (!SocketManager::getInstance()->isSocketClosed)//如果socket已关闭，则退出循环
	{
		//pthread_mutex_lock(SocketManager::getInstance()->getReqMutex());//*锁定互斥量*/
		std::mutex * mutexRq = SocketManager::getInstance()->getReqMutex();
		std::condition_variable* conditionRq = SocketManager::getInstance()->getCond();
		std::unique_lock<std::mutex> lck(*mutexRq);
		
		Message message = SocketManager::getInstance()->messageQueue->pop();
		if (message.code == MESSAGE_TYPE_NOT_INIT) //取到了有效的消息
		{
			conditionRq->wait(lck);
			//pthread_cond_wait(SocketManager::getInstance()->getCond(),SocketManager::getInstance()->getReqMutex());/*等待*/	
			//pthread_mutex_unlock(SocketManager::getInstance()->getReqMutex());//*解锁互斥量*/
		}
		else
		{
			//pthread_mutex_unlock(SocketManager::getInstance()->getReqMutex());//*解锁互斥量*/
			if (message.code == MESSAGE_TYPE_SEND_HEART_BEAT || message.message.empty())//心跳再根据code判断
			{
				SocketManager::getInstance()->sendHeartbeatMessage();//发送心跳包
			}
			else
			{
				SocketManager::getInstance()->sendMessage(message.message);//发送消息
			}
		}
	}
	return 0;
}

void* SocketManager::gstartRecvLooper(void *pData)
{
	TcpMessageBuilder tcpMessageBuilder;

	char recvBuf[SOCKET_RECV_BUF_LEN] = "\0";
	int dataLen = 0;
	while(!SocketManager::getInstance()->isSocketClosed &&
		(dataLen = SocketManager::getInstance()->cSocket->Recv(recvBuf,SOCKET_RECV_BUF_LEN,0)) >0)
	{
		tcpMessageBuilder.putData(recvBuf,dataLen);
		TcpMessage* message = tcpMessageBuilder.buildMessage();
		while(message)
		{
			if(message->length==0){
				SocketManager::getInstance()->listener->onReceiveHeartBeat();
			}else{
				std::string data(message->data);
				SocketManager::getInstance()->listener->onReceiveNewData(data);
			}
			delete message;
			message = NULL;
			message = tcpMessageBuilder.buildMessage();
		}
	}

	CCLOG("\n\n\nsocket closed\n\n\n");
	SocketManager::getInstance()->listener->onClose();
	SocketManager::getInstance()->cSocket->Close();
	SocketManager::getInstance()->isSocketClosed = true;
	return 0;
}

void SocketManager::addMessageToReceiveQueue(Message m){

	std::mutex * mutexResp= SocketManager::getInstance()->getRespMutex();
	std::unique_lock<std::mutex> lck(*mutexResp);
	//pthread_mutex_lock(SocketManager::getInstance()->getRespMutex());//*锁定互斥量*/
	SocketManager::getInstance()->getRespQueue()->push(m);
	//pthread_mutex_unlock(SocketManager::getInstance()->getRespMutex());//*解锁互斥量*/

}

Message SocketManager::getAndRemoveMessageFromReceiveQueue(){


	std::mutex * mutexResp = SocketManager::getInstance()->getRespMutex();
	std::unique_lock<std::mutex> lck(*mutexResp);
	//pthread_mutex_lock(SocketManager::getInstance()->getRespMutex());//*锁定互斥量*/
	Message m = SocketManager::getInstance()->getRespQueue()->pop();
	//pthread_mutex_unlock(SocketManager::getInstance()->getRespMutex());//*解锁互斥量*/
	return m;

}

void* SocketManager::gstartSendHeartbeatLooper(void *pData)
{
	std::condition_variable sleepWaitCondition;
	std::mutex mtx;
	std::unique_lock<std::mutex> lck(mtx);

	int count = 0;
	const int PER_INTERVAL = 1000;
	const int MAX_COUNT = HEART_BEAT_INTERVAL / PER_INTERVAL;
	while (!SocketManager::getInstance()->isSocketClosed)
	{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
		Sleep(PER_INTERVAL);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_WINRT || CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
		while (sleepWaitCondition.wait_for(lck, std::chrono::seconds(1)) == std::cv_status::timeout) 
		{
			break;
		}

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		sleep(PER_INTERVAL / 1000);
#endif

		if (count >= MAX_COUNT)
		{
			addMessageToSendQueue("");
			count = 0;
		}
		else
		{
			count++;
		}
	}
	return 0;
}


//执行消息包发送动作
void SocketManager::sendMessage(string strMessage)
{
	if(strMessage=="")
	{
		CCLOG("Error: SocketManager::sendMessage(string message) -> message = null");
		return;
	}

	const char* data = strMessage.c_str();


//	CCLOG("message body:\n%s\n",data);
	//消息长度
	int dataLen = 0;
	const char* pData = data;
	while(*pData != '\0')
	{
		pData++;
		dataLen++;
	}

	dataLen;
	
	//消息头和消息体合并
	char* tcpMessageData = new char[dataLen+TCP_MESSAGE_HEAD_LEN];
	tcpMessageData[0] = ((dataLen & 0xff000000) >> 24);
	tcpMessageData[1] = ((dataLen & 0xff0000) >> 16);
	tcpMessageData[2] = ((dataLen & 0xff00) >> 8);
	tcpMessageData[3] = (dataLen & 0xff) ;

	pData = data;
	char* pTcpMessageData = tcpMessageData+4;

	for(int i=0;i<dataLen;i++)
	{
		tcpMessageData[i+TCP_MESSAGE_HEAD_LEN] = data[i];
	}

	cSocket->Send(tcpMessageData,dataLen+TCP_MESSAGE_HEAD_LEN,0);
	delete tcpMessageData;
	tcpMessageData = NULL;
}

//执行心跳包的发送动作
void SocketManager::sendHeartbeatMessage()
{
	char* tcpMessageData = new char[TCP_MESSAGE_HEAD_LEN];
	tcpMessageData[0] = 0;
	tcpMessageData[1] = 0;
	tcpMessageData[2] = 0;
	tcpMessageData[3] = 0 ;
	cSocket->Send(tcpMessageData,TCP_MESSAGE_HEAD_LEN,0);
	delete tcpMessageData;
	tcpMessageData = NULL;
	CCLOG("\n..............................................heart beat send\n");
}

std::mutex* SocketManager::getReqMutex()
{
	return &this->socket_req_mutex;
}

std::mutex* SocketManager::getRespMutex()
{
	return &this->socket_resp_mutex;
}

std::condition_variable* SocketManager::getCond()
{
	return &this->socket_manager_cond;
}


bool SocketManager::reconnect()
{
	if(!this->strIp.c_str() || !this->port){
		CCLOG("SocketManager::reconnect -> failed ip or port is null\n");
	}

	CCLOG("SocketManager::reconnect");

	//回收资源
	destoryThread();
	destoryLockAndMessageQueue();
	cSocket->Close();
	cSocket->Clean();
	delete(cSocket);
	cSocket = NULL;
	cSocket = new ODSocket();

	//重新初始socket
	cSocket->Init();

	initLockAndMessageQueue();
	if(cSocket->Create(AF_INET,SOCK_STREAM,0))
	{
		this->isSocketClosed = false;
		this->isReconnect=true;
		//单开线程 socket连接线程
	   // pthread_create(&m_sockConnectThread, NULL, startSocketConnect, this);

		std::thread m_sockConnectThread(startSocketConnect, this);
		m_sockConnectThread.detach();

		return true;
	}else{
		CCLOG("SocketManager::reconnect -> failed ip=%s port=%d\n",strIp.c_str(),port);
		this->listener->onReconnectError(SOCKET_ERROR_RECONNECT_FAILED);
		this->isSocketClosed = true;
		return false;
	}
}


bool SocketManager::init(const char* pIp, unsigned short pPort, const char* domain,SocketListener* pListener)
{
	//创建并初始化socket
	cSocket = new ODSocket();
	cSocket->Init();

	string strIp(pIp);
	unsigned short port = pPort;

	if(!pListener)
	{
		CCLOG("SocketManager::init -> pListener can not be null");
		return false;
	}

	if(strIp.empty())
	{
		//根据域名获取ip
		
		struct hostent *hp;
		struct in_addr in;
		CCLOG("domainName=%s\n",domain);
		hp = gethostbyname(domain);
		if(!hp)
		{
			CCLOG("SocketManager::init -> domain parse failed\n");
			pListener->onError(SOCKET_ERROR_DOMAIN_PARSE_FAILED);
			return false;
		}

		memcpy (&in.s_addr,hp->h_addr,4);
		strIp=inet_ntoa(in);

		CCLOG("ip=%s port=%d\n",strIp.c_str(),port);
	}

	this->listener = pListener;
	pListener->retain();

	if(cSocket->Create(AF_INET,SOCK_STREAM,0))
	{
		this->isSocketClosed = false;

		this->strIp = strIp;
		this->port = port;
		//单开线程 socket连接线程
	   // pthread_create(&m_sockConnectThread, NULL, startSocketConnect, this);
		
			
	    std::thread m_sockConnectThread(startSocketConnect, this);
		m_sockConnectThread.detach();
		return true;
	}else{
		this->isSocketClosed = true;
		CCLOG("SocketManager::init -> failed ip=%s port=%d\n",strIp.c_str(),port);
		pListener->onError(SOCKET_ERROR_CONNECT_FAILED);
		return false;
	}
}


SocketManager::SocketManager()
{
	isReconnect = false;
	initLockAndMessageQueue();
}



MessageQueue* SocketManager::getRespQueue()
{
	return respQueue;
}

void SocketManager::initThread()
{
	
	//单开线程，进入消息接收死循环
	//pthread_create(&m_recvThread, NULL, gstartRecvLooper, this);

	//单开线程，驱动消息发送队列
	//pthread_create(&m_sendThread, NULL, gstartSendLooper, this);

	//单开线程，发送心跳包
	//pthread_create(&m_sendHeartbeatThread, NULL, gstartSendHeartbeatLooper, this);


		//单开线程，进入消息接收死循环
	std::thread m_recvThread(gstartRecvLooper, this);

	m_recvThread.detach();
	//单开线程，驱动消息发送队列
	std::thread m_sendThread(gstartSendLooper, this);

	m_sendThread.detach();
	//单开线程，发送心跳包
	std::thread m_sendHeartbeatThread(gstartSendHeartbeatLooper, this);
	m_sendHeartbeatThread.detach();
}


void* SocketManager::startSocketConnect(void *pData)
{
	SocketManager *sm = SocketManager::getInstance();

	if (sm->cSocket->Connect(sm->strIp.c_str(), sm->port))
	{
		if (sm->isReconnect){
			sm->listener->onReconnectOpen();
			sm->isReconnect = false;
		}
		else {
			sm->listener->onOpen();
		}
		sm->initThread();
		sm->log("SocketManager -> connect succ ip=%s port=%d\n", sm->strIp.c_str(), sm->port);
	}
	else{
		sm->log("SocketManager -> connect fail ip=%s port=%d\n", sm->strIp.c_str(), sm->port);
		sm->isSocketClosed = true;
		if (sm->isReconnect){
			sm->listener->onReconnectError(SOCKET_ERROR_RECONNECT_FAILED);
		}
		else{
			sm->listener->onError(SOCKET_ERROR_CONNECT_FAILED);
		}
	}
	return 0;
}

void SocketManager::log(const char* format, ...)
{
	CCLOG(format,strIp.c_str(),port);
}

void SocketManager::initLockAndMessageQueue()
{


	//socket_req_mutex = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
	//pthread_mutex_init(&socket_req_mutex, NULL);
	//socket_resp_mutex = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
	//pthread_mutex_init(&socket_resp_mutex, NULL);
	//socket_manager_cond = PTHREAD_COND_INITIALIZER;  //初始化条件变量
	//pthread_cond_init(&socket_manager_cond, NULL);
	respQueue = new MessageQueue();
	messageQueue = new MessageQueue();
}



void SocketManager::destoryThread()
{
	//socket标识位置为已关闭
	this->isSocketClosed = true;
	//如果发送线程未关闭，则将发送线程激活，则退出while循环。
	//通过join等待发送线程，及心跳线程退出
	//int status = 0;
   // pthread_kill(m_sockConnectThread,0);
	//if (&m_sendThread == NULL){
	//     return ;
	//}

	//status = pthread_kill(m_sendThread, 0);
	
	//if(status == ESRCH){
    //    CCLOG("\nthe thread m_sendThread has exit...\n");
	//}else if(status == EINVAL){
    //    CCLOG("\nSend signal to thread nm_sendThread fail.\n");
	//}else{
    //    CCLOG("\nthe thread nm_sendThread is still alive.\n");
	//	pthread_mutex_lock(SocketManager::getInstance()->getReqMutex());//*锁定互斥量*/
	//	pthread_cond_signal(SocketManager::getInstance()->getCond());/*条件改变，发送信号，通知m_sendThread进程*/
	//	pthread_mutex_unlock(SocketManager::getInstance()->getReqMutex());//*解锁互斥量*/

	//	pthread_join(m_sendThread, NULL);
	//	CCLOG("\nm_sendThread exit\n");
   // }


	std::condition_variable* conditionRq = SocketManager::getInstance()->getCond();
	conditionRq->notify_all();
	// status = pthread_kill(m_sendHeartbeatThread, 0);
	// if(status == ESRCH){
	// CCLOG("\nthe thread m_sendHeartbeatThread has exit...\n");
	// }else if(status == EINVAL){
	// CCLOG("\nSend signal to thread m_sendHeartbeatThread fail.\n");
	// }else{
	// CCLOG("\nthe thread m_sendHeartbeatThread is still alive.\n");
	// pthread_join(m_sendHeartbeatThread, NULL);
	// CCLOG("\nm_sendHeartbeatThread exit\n");
	// }

}

void SocketManager::destoryLockAndMessageQueue()
{
	//pthread_mutex_destroy(&socket_req_mutex);
	//pthread_mutex_destroy(&socket_resp_mutex);
    //pthread_cond_destroy(&socket_manager_cond);

	delete respQueue;
	respQueue = NULL;
	delete messageQueue;
	messageQueue = NULL;
}

SocketManager::~SocketManager()
{
	destoryThread();
	destoryLockAndMessageQueue();

	if(!cSocket)
	{
		cSocket->Close();
		cSocket->Clean();
		delete cSocket;
	}
	delete listener;
	listener = NULL;
}
