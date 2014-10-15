/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include <assert.h>
#include "Multicaster.h"

namespace net {

/**
 * Wipe the container (we own the sinks after all) and delete the source.
 */
CMulticaster::~CMulticaster()
{
	for (SinkSet::iterator sink = sinks.begin(); sink != sinks.end(); ++sink)
		delete *sink;
	delete source;
}

/**
 * Register another ISink to this CMulticaster.
 * Afterwards, the sink is owned by this class, ie. in
 * CMulticaster::~CMulticaster() the sink is deleted.
 */
void CMulticaster::RegisterSink(ISink* sink)
{
	assert(sink);
	sinks.insert(sink);
}

/**
 * Unregister a sink.
 */
void CMulticaster::UnregisterSink(ISink* sink)
{
	sinks.erase(sink);
}

/**
 * Implementation of ISource::Read(). This relays the data returned by
 * source->Read() to the caller *and* all registered sinks.
 * \return the return value of source->Read()
 */
bool CMulticaster::Read(const uchar*& data, int& len)
{
	assert(source);
	if (source->Read(data, len)) {
		Write(data, len);
		return true;
	}
	return false;
}

/**
 * Implementation of ISink::Write(). This multicasts the data to all
 * registered sinks.
 * \return true if all registered sinks returned true, false otherwise.
 */
bool CMulticaster::Write(const uchar* data, int len)
{
	bool ret = true;
	for (SinkSet::iterator sink = sinks.begin(); sink != sinks.end(); ++sink) {
		if (!(*sink)->Write(data, len))
			ret = false;
	}
	return ret;
}

}; // end of namespace net
