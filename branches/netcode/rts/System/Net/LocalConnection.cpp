/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include <string.h>
#include "LocalConnection.h"

namespace net {

/**
 * Construct a local packet by copying the passed data.
 */
CLocalPacket::CLocalPacket(const uchar* p, int len) :
		length(len), data(NULL)
{
	memcpy((data = new uchar[len]), p, len);
}

/**
 * Delete the data associated with this packet.
 */
CLocalPacket::~CLocalPacket()
{
	delete[] data;
}

/**
 * Construct a local thread safe connection.
 */
CLocalConnection::CLocalConnection() :
		readPacket(NULL)
{
}

/**
 * Cleanup.
 */
CLocalConnection::~CLocalConnection()
{
	delete readPacket;
}

/**
 * Read the next packet from the queue by setting data and len.
 *
 * Invalidates the data returned by the previous call.
 * The caller must manually copy the data if it must persist.
 *
 * \return true if there was data available, false otherwise
 */
bool CLocalConnection::Read(const uchar*& data, int& len)
{
	boost::mutex::scoped_lock scoped_lock(mutex);

	if (readyPackets.empty()) {
		data = NULL;
		len = 0;
		return false;
	}

	delete readPacket;
	readPacket = readyPackets.front();
	readyPackets.pop_front();

	data = readPacket->GetData();
	len = readPacket->GetLength();
	return true;
}

/**
 * Write a chunk of data to the connection. This makes a copy of the data and
 * stores it on a queue for later reading.
 */
bool CLocalConnection::Write(const uchar* data, int len)
{
	boost::mutex::scoped_lock scoped_lock(mutex);

	readyPackets.push_back(new CLocalPacket(data, len));
	return true;
}

}; // end of namespace net
