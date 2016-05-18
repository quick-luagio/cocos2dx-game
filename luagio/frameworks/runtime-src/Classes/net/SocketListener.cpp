
#include "SocketListener.h"
#include "SocketManager.h"
#include <string>
#include <sstream>
#include <ctime>
using namespace std;
#include "CCLuaEngine.h"
#include "TcpMessageBuilder.h"
USING_NS_CC;

void SocketListener::onOpen()
{
	callbackLua(MESSAGE_TYPE_SOCKET_OPEN,"open");
}


void SocketListener::onReconnectOpen()
{
	callbackLua(MESSAGE_TYPE_SOCKET_RECONNECT_OPEN,"reconnectOpen");
}

void SocketListener::onReceiveHeartBeat()
{
	CCLOG("\n..............................................heart beat recv\n");
	callbackLua(MESSAGE_TYPE_RECEIVE_HEART_BEAT,"heart beat");	
}

void SocketListener::onReceiveNewData(std::string data)
{
	//printf("\n[c++]%s\n\n",data.c_str());
	callbackLua(MESSAGE_TYPE_RECEIVE_NEW_MESSAGE,data);		
}

void SocketListener::onError(int errorCode)
{
	stringstream ss;
	ss << "onError code=" << errorCode;
	callbackLua(MESSAGE_TYPE_SOCKET_ERROR,ss.str());
}

void SocketListener::onReconnectError(int errorCode)
{
	stringstream ss;
	ss << "onReconnectError code=" << errorCode;
	callbackLua(MESSAGE_TYPE_SOCKET_RECONNECT_ERROR,ss.str());
}

void SocketListener::onClose()
{
	callbackLua(MESSAGE_TYPE_SOCKET_CLOSE,"onClose");
}

void SocketListener::callbackLua(int code,string data)
{	
	Message m;
	m.code = code;
	m.message = data;
	SocketManager::getInstance()->addMessageToReceiveQueue(m);//将消息放到待处理队列
}

void SocketListener::dispatchResponseCallbacks(float delta)
{ 
	Message m = SocketManager::getInstance()->getAndRemoveMessageFromReceiveQueue();//Scheduler回调本方法，从待处理队列取出消息
	
	if(!m.message.empty())
	{
		int code = m.code;
		string data = m.message;

		cocos2d::LuaEngine* pEngine = (cocos2d::LuaEngine*)cocos2d::ScriptEngineManager::getInstance()->getScriptEngine();
		cocos2d::LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(code);
		luaStack->pushString(data.c_str());
		luaStack->executeFunctionByHandler(this->messageHandler, 2);
	}
}

void SocketListener::setMessageHandler(int messageHandler)
{
	this->messageHandler = messageHandler;
}

int SocketListener::getMessageHandler()
{
	return this->messageHandler;
}


//构造时，开始定时器
//在界面每一次刷新时，调用dispatchResponseCallbacks方法，读取并处理消息
SocketListener::SocketListener(){
    Director::getInstance()->getScheduler()->scheduleSelector(schedule_selector(SocketListener::dispatchResponseCallbacks), this, 0, false);
}

//销毁时，关闭定时器
SocketListener::~SocketListener(){
	Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
}
