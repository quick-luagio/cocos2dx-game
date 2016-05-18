#ifndef _NET_PROXY_H
#define _NET_PROXY_H
#include "SocketManager.h"
#include "SocketListener.h"
typedef int LUA_FUNCTION;
using namespace std;

class NetProxy
{
public:
	static void NetInit(std::string ip, unsigned int port, std::string domian, LUA_FUNCTION messageHandler);
  
    static void NetReconnect();
 
    static void NetSend(const char* value);
};
#endif