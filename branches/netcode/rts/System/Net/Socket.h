/* Author: Tobi Vollebregt */

#ifndef SOCKET_H
#define SOCKET_H

#include <set>
#include "ISinkSource.h"

namespace net {

typedef unsigned char uchar;
typedef std::pair<uint, int> Address;


/**
 * Empty base class so the observer code can be reused.
 */
struct IConnection: public ISink, public ISource
{
	virtual ~IConnection() {}
};


/**
 * Inherit this to observe a CUDPSocket.
 *
 * CUDPSocket asks this class whether a new connection should be accepted,
 * based on the received packet, and if it's accepted the CUDPSocket tells
 * this observer about the new CUDPConnection.
 *
 * Only one of the observers need to accept the connection for it to be
 * accepted. All observers get the ConnectionAccepted() call afterwards,
 * it's up to the observers themselves to figure out who is going to use
 * the connection...
 */
class ISocketObserver
{
	public:

		/// Returns true if the packet is a valid attemptconnect packet.
		virtual bool AcceptConnection(uchar* data, int length) = 0;
		/// Invoked when a new connection is created.
		virtual void ConnectionAccepted(IConnection* conn) = 0;
};


/**
 * Base class for CUDPSocket implementing the observer pattern.
 */
class CSocketObservable
{
	public:

		void RegisterObserver(ISocketObserver* ob);
		void UnregisterObserver(ISocketObserver* ob);

	protected:

		bool AcceptConnection(uchar* data, int length);
		void ConnectionAccepted(IConnection* conn);

	private:

		typedef std::set<ISocketObserver*> ObserverSet;
		ObserverSet observers;
};

}; // end of namespace net

#endif // !SOCKET_H
