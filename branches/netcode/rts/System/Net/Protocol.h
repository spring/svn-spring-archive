/* Author: Tobi Vollebregt */

#ifndef PROTOCOL_H
#define PROTOCOL_H

// based on old Spring netcode

namespace net {

/*
	ideas:

	look up tables:

	int message_size[];
		gives message size for NETMSG_* constant
		negative size would mean: variable size stored in -message_size[n] bytes.

	bool relay_message[]
		specifies whether the server should relay this message in replay mode
		could also be done by setting a bit in the NETMSG_* constant
		speed / pause messages would have this bit set
*/

typedef unsigned char uchar;
typedef unsigned short ushort;

#pragma push(pack, 1)

struct MsgHello
{
};

struct MsgQuit
{
};

struct MsgNewFrame()
{
};

#pragma pop

}; // end of namespace net

#endif // !PROTOCOL_H
