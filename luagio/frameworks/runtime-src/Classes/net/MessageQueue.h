#ifndef __MESSAGE_QUEUE_H__
#define __MESSAGE_QUEUE_H__

#define MESSAGE_TYPE_NOT_INIT (0)				//未初始化的包
#define MESSAGE_TYPE_SOCKET_OPEN  (1)			//socket连接成功
#define MESSAGE_TYPE_RECEIVE_NEW_MESSAGE (2)	//接收到的数据包
#define MESSAGE_TYPE_SOCKET_ERROR (3)			//socket异常
#define MESSAGE_TYPE_SOCKET_CLOSE (4)			//socket关闭
#define MESSAGE_TYPE_SEND_NEW_MESSAGE (5)		//待发送的数据包
#define MESSAGE_TYPE_SOCKET_RECONNECT_OPEN  (6)	//socket重连成功
#define MESSAGE_TYPE_SOCKET_RECONNECT_ERROR (7) //socket重连失败
#define MESSAGE_TYPE_RECEIVE_HEART_BEAT (100)	//接收到的心跳包
#define MESSAGE_TYPE_SEND_HEART_BEAT (101)		//待发送的心跳包

#include <queue> 
#include <string>



typedef struct _message{
	int code;
	string message;
}Message;

class MessageQueue
{
public:
	void push(Message message);
	Message pop();
	MessageQueue();
	~MessageQueue();
	

public:
	std::queue<Message> messageQueue;
	
};

#endif