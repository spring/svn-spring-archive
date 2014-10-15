/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include "Socket.h"

namespace net {

/**
 * Register an observer for this socket.
 */
void CSocketObservable::RegisterObserver(ISocketObserver* ob)
{
	observers.insert(ob);
}

/**
 * Unregister an observer for this socket.
 */
void CSocketObservable::UnregisterObserver(ISocketObserver* ob)
{
	observers.erase(ob);
}

/**
 * Proxy to emit ISocketObserver::AcceptConnection() signal.
 */
bool CSocketObservable::AcceptConnection(uchar* data, int length)
{
	bool ret = false;
	for (ObserverSet::iterator ob = observers.begin(); ob != observers.end(); ++ob) {
		if ((*ob)->AcceptConnection(data, length))
			ret = true;
	}
	return ret;
}

/**
 * Proxy to emit ISocketObserver::ConnectionAccepted() signal.
 */
void CSocketObservable::ConnectionAccepted(IConnection* conn)
{
	for (ObserverSet::iterator ob = observers.begin(); ob != observers.end(); ++ob) {
		(*ob)->ConnectionAccepted(conn);
	}
}

}; // end of namespace net
