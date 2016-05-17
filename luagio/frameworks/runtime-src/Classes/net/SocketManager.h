#ifndef __SOCKET_MANAGER_H__
#define __SOCKET_MANAGER_H__
#include <string>
#include "Singleton.h"
#include "SocketListener.h"
#include "ODSocket.h"
#include "MessageQueue.h"
#include "signal.h"
#include "stdio.h"


#include <thread>
#include <mutex>
#include <condition_variable>


#define SOCKET_RECV_BUF_LEN (1024)		//socket数据接收缓存大小
#define SOCKET_ERROR_CONNECT_FAILED (1) //socket连接失败
#define SOCKET_ERROR_RECONNECT_FAILED (3) //socket重连失败
#define SOCKET_ERROR_DOMAIN_PARSE_FAILED (2) //域名解析错误，无法获得服务器ip

#define HEART_BEAT_INTERVAL (1000*60*1)		//心跳时间间隔

class SocketManager : public Singleton<SocketManager>
{
public:
	static void* gstartRecvLooper(void *pData);//单开线程，接收消息
	static void* gstartSendLooper(void *pData);//单开线程，驱动消息发送队列
	static void* gstartSendHeartbeatLooper(void *pData);//单开线程，发送心跳包
	static void* startSocketConnect(void *pData);//开始连接
	static void addMessageToSendQueue(std::string message);
	static Message getAndRemoveMessageFromReceiveQueue();
	static void addMessageToReceiveQueue(Message m);
	SocketManager();
	virtual ~SocketManager();
	bool init(const char* ip, unsigned short port,const char* domain,SocketListener* listener);//初始化socketManager
	bool reconnect();//socket重连
	//pthread_mutex_t* getReqMutex();
	//pthread_mutex_t* getRespMutex();
	//pthread_cond_t* getCond();

	std::mutex* getReqMutex();
	std::mutex* getRespMutex();
	std::condition_variable* getCond();

	ODSocket* cSocket;
	SocketListener* listener;
	bool isReconnect;
	MessageQueue* getRespQueue();

private:
	void initLockAndMessageQueue();//初始化线程锁 及 消息队列
	void destoryLockAndMessageQueue();//收回 线程锁 及 消息队列
	void initThread();//初始化所有线程
	void destoryThread();//回收所有线程
	void log(const char* format, ...);
	bool isSocketClosed; //socket状态
	std::string strIp;// socket  ip
	unsigned short port;// socket 端口号
	//pthread_mutex_t socket_req_mutex; /*初始化请求互斥锁*/
	//pthread_mutex_t socket_resp_mutex; /*初始化响应互斥锁*/
	//pthread_cond_t socket_manager_cond;  //初始化条件变量 
	std::mutex socket_req_mutex; /*初始化请求互斥锁*/
	std::mutex socket_resp_mutex; /*初始化响应互斥锁*/
	std::condition_variable socket_manager_cond;  //初始化条件变量 
	void sendMessage(std::string message);
	void sendHeartbeatMessage();
	MessageQueue* messageQueue;
	MessageQueue* respQueue;
	//pthread_t m_sockConnectThread;	
	//pthread_t m_recvThread;	
	//pthread_t m_sendThread;
	//pthread_t m_sendHeartbeatThread;

	std::thread m_sockConnectThread;
    std::thread m_recvThread;
	std::thread m_sendThread;
	std::thread m_sendHeartbeatThread;
	
};

#endif