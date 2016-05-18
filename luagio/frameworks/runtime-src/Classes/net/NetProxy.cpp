#include "NetProxy.h"
using namespace cocos2d;


void NetProxy::NetInit(std::string ip, unsigned int port, std::string domain, LUA_FUNCTION messageHandler)
{
		CCLOG("NetInit:ip:%s port:%d domian:%s messageHandler:",ip.c_str(),port,domain.c_str(),messageHandler);
		SocketListener * singleListener = new SocketListener();
		singleListener->setMessageHandler(messageHandler);
		SocketManager::getInstance()->init(ip.c_str(),port,domain.c_str(),singleListener);
}

void NetProxy::NetReconnect()
{
	    SocketManager::getInstance()->reconnect();
}

void NetProxy::NetSend(const char* value)
{
    SocketManager::getInstance()->addMessageToSendQueue(value);
}

