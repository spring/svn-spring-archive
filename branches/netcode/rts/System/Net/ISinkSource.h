/* Author: Tobi Vollebregt */

#ifndef ISINKSOURCE_H
#define ISINKSOURCE_H

namespace net {

typedef unsigned char uchar;

/**
 * Interface for classes which act as a data source for the application.
 * e.g. a network receiver
 */
struct ISource {
	virtual bool Read(const uchar*& data, int& len) = 0;
	virtual ~ISource() {}
};

/**
 * Interface for classes which act as a data sink for the application.
 * e.g. a network transmitter
 */
struct ISink {
	virtual bool Write(const uchar* data, int len) = 0;
	virtual ~ISink() {}
};

}; // end of namespace net

#endif // !ISINKSOURCE_H
