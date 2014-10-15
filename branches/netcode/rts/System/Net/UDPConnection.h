/* Author: Tobi Vollebregt */

#ifndef UDPCONNECTION_H
#define UDPCONNECTION_H

#include <deque>
#include <map>
#include "ISinkSource.h"
#include "UDPSocket.h"

namespace net {


/**
 * Represents a raw network packet.
 * (ie. the data written in one Write() call and read in one Read() call)
 *
 * Packets have a simple 20 byte header consisting of big endian integers:
 *    @0  id       (24 bits)
 *    @3  length   (24 bits)
 *    @6  ack      (24 bits)   Acknowledges all packets with id <= ack.
 *    @9  nack     (24 bits)   If nonzero, (ack, nack) exclusive range is missing.
 *    @12 sendtime (24 bits)   These 2 fields are used for accurate ping calculation.
 *    @16 recvtime (24 bits)
 *
 * The ping calculation works as follows: on each sent packet, sendtime is set
 * to the current time and recvtime is set to max(sendtime of received packets).
 *
 * This way ping is currentTime minus mostRecentlyReceivedPacket.recvtime.
 */
class CUDPPacket
{
	public:

		enum {
			PACKET_HEADER_SIZE = 20
		};

		CUDPPacket(const uchar* p);
		CUDPPacket(int id, const uchar* p, int len);
		~CUDPPacket();

		/// Return the length of the packet.
		int GetLength() const { return length; }

		/// Return the data of the packet.
		const uchar* GetData() const { return data; }

		/// Packet identification number.
		int GetId() const { return Read24(data); }

		/// Acknowledge all packets with id <= ack.
		int GetAcknowledgedId() const { return Read24(data + 6); }

		/// If nonzero, (ack,nack) (exclusive range) needs to be resend.
		int GetNotAcknowledgedId() const { return Read24(data + 9); }

		/// For ping calculation. See class comment.
		int GetSendTime() const { return Read32(data + 12); }

		/// For ping calculation. See class comment.
		int GetReceiveTime() const { return Read32(data + 16); }

		/// Prepare for send, by filling in ack, nack and recvtime header fields.
		void PreSend(int ack, int nack, int recvtime)
		{
			assert(Read24(data + 3) == length);
			Write24(data + 6, ack);
			Write24(data + 9, nack);
			Write32(data + 12, GetTime());
			Write32(data + 16, recvtime);
		}

	private:

		int length;  ///< Packet length.
		uchar* data; ///< Contents (including headers).
};


/**
 * A UDP network connection.
 */
class CUDPConnection : public IConnection
{
	public:

		enum {
			// Buffer size for sending, must be less then buffer size for
			// receiving to be able to correctly trash long packets.
			BUFFER_SIZE = CUDPSocket::BUFFER_SIZE - CUDPPacket::PACKET_HEADER_SIZE - 1,
			MIN_PACKETS_PER_SECOND = 1,
			MAX_PACKETS_PER_SECOND = 50,
			NETWORK_TIMEOUT = 30000,     // milliseconds
			RESEND_TIMEOUT_FACTOR = 200, // % of averagePing
			RESEND_TIMEOUT = 500         // milliseconds (added to averagePing * RESEND_TIMEOUT_FACTOR / 100)
		};

		CUDPConnection(CUDPSocket* sock, const sockaddr_in& dest);
		~CUDPConnection();

		virtual bool Read(const uchar*& data, int& len);
		virtual bool Write(const uchar* data, int len);

		void Update();
		bool Flush();

		// interface to CUDPDispatcher
		void ReceiveRawPacket(uchar* data, int len);
		Address GetRemoteAddress() const { return Address(dest.sin_addr.s_addr, dest.sin_port); }

		// useful stuff for UI
		int GetPing() const;
		int GetNumberOfReadyPackets() const { return readyPackets.size(); }
		int GetNumberOfWaitingPackets() const { return waitingPackets.size(); }
		int GetNumberOfUnacknowledgedPackets() const { return unackedPackets.size(); }
		int GetNumberOfSendQuePackets() const { return sendQue.size(); }

		std::string GetWaitingPackets() const;
		std::string GetUnacknowledgedPackets() const;

	private:

		typedef std::map<int, CUDPPacket*> PacketsMap;
		typedef std::deque<CUDPPacket*> PacketsQue;

		bool SendPacket(CUDPPacket* p);

		CUDPSocket* sock; ///< Socket used to Send() data.
		sockaddr_in dest; ///< Destination address.

		int averagePing;  ///< Exponential decaying average ping (50% decay).

		// receiving
		CUDPPacket* readPacket;    ///< Packet currently being read.
		PacketsQue readyPackets;   ///< Packets waiting to be read.
		PacketsMap waitingPackets; ///< Packets waiting for earlier packets to arrive.
		int lastInOrderPacket;     ///< Last packet received in order.
		int lastReceiveTime;       ///< as returned by GetTime().
		int lastRemoteTime;        ///< Max received sendtime field of packet.

		// sending
		int packetNum;             ///< Id to assign to new packets.
		int lastSendTime;          ///< as returned by GetTime(), excludes resends.
		int lastResendTime;        ///< Last time a range of packets was resend.
		int lastAckedPacket;       ///< Id of last acknowledged packet.
		int lastNackedPacket;      ///< Last packet id that was resend (don't resend same range twice)
		PacketsQue unackedPackets; ///< Packets still waiting for an acknowledgement.
		PacketsQue sendQue;        ///< Stores packets when sending fails.
		int outbuflen;             ///< Size of outbuf.
		uchar outbuf[BUFFER_SIZE]; ///< Output buffer. Write() puts stuff here until Flush() sends it.
};

}; // end of namespace net

#endif // !UDPCONNECTION_H
