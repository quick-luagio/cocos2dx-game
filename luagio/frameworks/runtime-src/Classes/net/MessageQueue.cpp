
#include "SocketManager.h"
#include <string>

using namespace std;

//本messagequeu非线程安全
Message MessageQueue::pop()
{ 	
	Message message;
	message.code = MESSAGE_TYPE_NOT_INIT;
	if(this->messageQueue.size()>0)
	{
		message = this->messageQueue.front();
		this->messageQueue.pop();		
	}
	
	return message;
}

void MessageQueue::push(Message m)
{ 
	this->messageQueue.push(m);	
}

MessageQueue::~MessageQueue()
{
}

MessageQueue::MessageQueue()
{

}