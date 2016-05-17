#include "TcpMessageBuilder.h"
#include <string>
#include "cocos2d.h"
USING_NS_CC;

bool TcpMessageBuilder::putData(char* data, int dataLen)
{
	int tcpMessageLen = 0;
	//TODO 判断缓冲区是否被填满，是则扩容
	if( (this->m_currentLen + dataLen) > m_bufLen )
	{
		printf("消息太长，超过缓存区大小");
		//TODO 扩容
	}

	//将新接收的数据写入缓存区
	for(int i=0;i<dataLen;i++)
	{
		//缓冲区为循环使用，故需 %this->m_bufLen
		this->m_buf[ (this->m_startPosition + this->m_currentLen)%this->m_bufLen] = data[i];
		this->m_currentLen++;
	}
	return true;
}

TcpMessage* TcpMessageBuilder::buildMessage()
{

	if( this->m_currentLen < TCP_MESSAGE_HEAD_LEN )
	{
		return NULL;
	}

	int tcpMessageDataLen = this->m_buf[this->m_startPosition+3] & 0xff ;
	tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+2] << 8) & 0xff00);
	tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+1] << 16) & 0xff0000);
	tcpMessageDataLen |= ((this->m_buf[this->m_startPosition] << 24) & 0xff000000);

	if(tcpMessageDataLen==0)//如果是空消息。空消息则是心跳包
	{
		m_startPosition += TCP_MESSAGE_HEAD_LEN;
		this->m_currentLen -= TCP_MESSAGE_HEAD_LEN;
		return new TcpMessage(0,NULL);
	}else{
		if(this->m_currentLen - TCP_MESSAGE_HEAD_LEN >= tcpMessageDataLen)//如果缓冲区中有一条完整的消息
		{
			char* messageBody = new char[tcpMessageDataLen+1];
			messageBody[tcpMessageDataLen] = '\0';
			for(int i=0;i<tcpMessageDataLen;i++)
			{
				messageBody[i] = m_buf[ (this->m_startPosition + i + TCP_MESSAGE_HEAD_LEN) % this->m_bufLen];
			}

			m_startPosition += (TCP_MESSAGE_HEAD_LEN + tcpMessageDataLen);
			this->m_currentLen -= (TCP_MESSAGE_HEAD_LEN + tcpMessageDataLen);

			return new TcpMessage(tcpMessageDataLen,messageBody);
		}
	}
	return NULL;
}


TcpMessageBuilder::TcpMessageBuilder()
{
	this->m_bufLen = BUF_LEN;
	this->m_buf = new char[m_bufLen];
	this->m_startPosition = 0;
	this->m_currentLen = 0;
}

TcpMessageBuilder::~TcpMessageBuilder()
{
	delete m_buf;
	m_buf = NULL;
}