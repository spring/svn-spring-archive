/* Author: Tobi Vollebregt */

#ifndef MULTICASTER_H
#define MULTICASTER_H

#include <set>
#include "ISinkSource.h"

namespace net {

/**
 * ISink implementation that can be used to multicast the datastream
 * to multiple different local sinks.
 *
 * Can also be hooked into a source data stream to relay the Read() data
 * to all registered sinks.
 */
class CMulticaster : public ISink, public ISource
{
	public:

		CMulticaster() : source(NULL) {}
		~CMulticaster();

		void RegisterSink(ISink* sink);
		void UnregisterSink(ISink* sink);

		void SetSource(ISource* s) { source = s; }

		virtual bool Read(const uchar*& data, int& len);
		virtual bool Write(const uchar* data, int len);

	private:

		typedef std::set<ISink*> SinkSet;
		SinkSet sinks;   ///< set of owned sinks
		ISource* source; ///< stream source
};

}; // end of namespace net

#endif // !MULTICASTER_H
