/* Author: Tobi Vollebregt */

#ifndef SYNCEDPRIMITIVEIO_H
#define SYNCEDPRIMITIVEIO_H

#ifdef SYNCDEBUG

#include <iostream>
#include "SyncedPrimitive.h"

/* I put these in a separate header to save the project from
#including the large iostream headers in every file. */

/* interface properly with stream objects in TdfParser etc. */

template<class T> inline std::ostream& operator<<(std::ostream& os, SyncedPrimitive<T>& f)
{
	os << f.x;
	return os;
}

template<class T> inline std::istream& operator>>(std::istream& is, SyncedPrimitive<T>& f)
{
	is >> f.x;
	f.Sync(">>");
	return is;
}

#endif // SYNCDEBUG

#endif // SYNCEDPRIMITIVEIO_H
