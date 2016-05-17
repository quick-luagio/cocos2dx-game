#ifndef __SOCKET_LISTENER_H__
#define __SOCKET_LISTENER_H__

#include <string>
#include "cocos2d.h"

using namespace std;
USING_NS_CC;
class SocketListener:public CCObject
{
public:
	SocketListener();
	virtual ~SocketListener();
	virtual void onOpen();
	virtual void onReconnectOpen();
	virtual void onReceiveNewData(string data);
	virtual void onReceiveHeartBeat();
	virtual void onError(int errorCode);
	virtual void onReconnectError(int errorCode);
	virtual void onClose();
	void callbackLua(int code,string data);
	void registerScriptHandler(int funcID);
	int getScriptHandler();
	void dispatchResponseCallbacks(float delta);
private:
	
	int funcID;
};

#endif