/* Author: Tobi Vollebregt */

#ifndef UDPSOCKET_H
#define UDPSOCKET_H

#include <map>
#include <vector>
#include "internal.h"
#include "Socket.h"

namespace net {

class CUDPConnection;


/**
 * Dispatches UDP packets to registered UDP connections.
 *
 * For this it maintains a map of associations to CUDPConnection.
 * It doesn't own those connections, the user is responsible for cleaning
 * those up.
 */
class CUDPSocket : public CSocketObservable
{
	public:

		enum {
			BUFFER_SIZE = 16000 // buffer size for receiving
		};

		CUDPSocket(int port = 0) : sock(-1) { Bind(port); }
		~CUDPSocket() { Close(); }

		void RegisterConnection(CUDPConnection* conn);
		void UnregisterConnection(CUDPConnection* conn);

		void Bind(int port);
		void Close();
		void Update();

		bool SendRawPacket(const uchar* data, int len, const sockaddr_in& dest);

	private:

		typedef std::map<Address, CUDPConnection*> ConnectionMap;

		CUDPSocket(const CUDPSocket&);
		CUDPSocket& operator=(const CUDPSocket&);

		int sock;                    ///< Low level socket descriptor.
		ConnectionMap connections;   ///< Associates remote addresses with connections.
		uchar incoming[BUFFER_SIZE]; ///< Buffer for recvfrom().
};

}; // end of namespace net

#endif // !UDPSOCKET_H
