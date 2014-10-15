/* Author: Tobi Vollebregt */

#ifndef LOCALCONNECTION_H
#define LOCALCONNECTION_H

#include <boost/thread/mutex.hpp>
#include <deque>
#include "Socket.h"

namespace net {


/**
 * Represents a raw network packet.
 * (ie. the data written in one Write() call and read in one Read() call)
 */
class CLocalPacket
{
	public:

		CLocalPacket(const uchar* p, int len);
		~CLocalPacket();

		int  GetLength() const { return length; }
		uchar* GetData() const { return data; }

	private:

		int length;  ///< Packet length.
		uchar* data; ///< Contents (including protocol headers).
};


/**
 * Thread safe local connection.
 */
class CLocalConnection: public IConnection
{
	public:

		CLocalConnection();
		~CLocalConnection();

		virtual bool Read(const uchar*& data, int& len);
		virtual bool Write(const uchar* data, int len);

	private:

		typedef std::deque<CLocalPacket*> PacketsQue;

		boost::mutex mutex;        ///< Thread safety.
		CLocalPacket* readPacket;  ///< Packet currently being read.
		PacketsQue readyPackets;   ///< Packets waiting to be read.
};

}; // end of namespace net

#endif // !LOCALCONNECTION_H
