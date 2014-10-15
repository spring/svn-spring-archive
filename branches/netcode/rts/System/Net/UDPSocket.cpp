/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include "UDPConnection.h"
#include "UDPSocket.h"
#include "internal.h"

namespace net {

/**
 * Register a new UDP connection to the listener.
 * Caller must make sure there's a socket bound to that port (using Bind()).
 */
void CUDPSocket::RegisterConnection(CUDPConnection* conn)
{
	connections.insert(ConnectionMap::value_type(conn->GetRemoteAddress(), conn));
}

/**
 * Unregister an UDP connection. Should be called when closing the connection.
 */
void CUDPSocket::UnregisterConnection(CUDPConnection* conn)
{
	connections.erase(conn->GetRemoteAddress());
}

/**
 * Initialize a socket and bind it to a port.
 */
void CUDPSocket::Bind(int port)
{
	Close();

	// Create socket.
	sock = socket(PF_INET, SOCK_DGRAM, 0);
	if (sock < 0)
		throw SocketError(GetLastError());

	// Bind it to port.
	struct sockaddr_in name;

	memset(&name, 0, sizeof(name));
	name.sin_family = AF_INET;
	name.sin_port = htons(port);
	name.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(sock, (struct sockaddr*) &name, sizeof(name)) < 0)
		throw BindError(GetLastError());

	// Set it to nonblocking.
#ifdef WIN32
	unsigned long mode = 1;
	ioctlsocket(sock, FIONBIO, &mode);
#else
	fcntl(sock, F_SETFL, O_NONBLOCK);
#endif
}

/**
 * Close the socket.
 * Caller must make sure there are no connections active over the socket.
 */
void CUDPSocket::Close()
{
	if (sock >= 0) {
		closesocket(sock);
		sock = -1;
	}
}

/**
 * Receive new packets from the socket and dispatch them to the appropriate
 * CUDPConnection instances (based on packet source address).
 *
 * Should be called regularly, i.e. in an update loop.
 */
void CUDPSocket::Update()
{
	sockaddr_in source;
	socklen_t sourcelen = sizeof(source);
	int packetlen;

	while ((packetlen = recvfrom(sock, incoming, sizeof(incoming), 0, (struct sockaddr*) &source, &sourcelen)) >= 0) {

		// We can't do anything with possibly truncated packets.
		//if (packetlen >= sizeof(incoming))
		//	continue;

		assert(packetlen != sizeof(incoming));
		assert(sourcelen == sizeof(source));

		ConnectionMap::iterator conn = connections.find(Address(source.sin_addr.s_addr, source.sin_port));
		if (conn != connections.end()) {
			conn->second->ReceiveRawPacket(incoming, packetlen);
		} else if (AcceptConnection(incoming, packetlen)) {
			CUDPConnection* c = new CUDPConnection(this, source);
			ConnectionAccepted(c);
			c->ReceiveRawPacket(incoming, packetlen);
		}
	}

	int err = GetLastError();
	if (!IsFakeError(err))
		throw ReceiveError(err);

	for (ConnectionMap::iterator conn = connections.begin(); conn != connections.end(); ++conn)
		conn->second->Update();
}

/**
 * Send a raw UDP packet over this socket to the specified destination.
 */
bool CUDPSocket::SendRawPacket(const uchar* data, int len, const sockaddr_in& dest)
{
	if (sendto(sock, data, len, 0, (const struct sockaddr*) &dest, sizeof(dest)) != len) {
		int err = GetLastError();
		if (IsFakeError(err))
			return false;
		throw SendError(err);
	}
	return true;
}

}; // end of namespace net
