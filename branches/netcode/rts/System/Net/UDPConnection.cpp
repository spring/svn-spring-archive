/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include <sstream>
#include "UDPConnection.h"
#include "UDPSocket.h"

namespace net {

/**
 * Construct an UDP packet by copying the passed data.
 * This is used to construct a remote packet: this reads the packet header
 * to determine the size. The code creating packets using this function
 * MUST make sure it has manually checked the size in the packet header,
 * otherwise DOS attacks are trivial.
 */
CUDPPacket::CUDPPacket(const uchar* p):
		length(Read24(p + 3)),
		data(NULL)
{
	assert(length >= PACKET_HEADER_SIZE);
	data = new uchar[length];
	memcpy(data, p, length);
}

/**
 * Construct an UDP packet by copying the passed data.
 * This is used to construct a local packet, which has yet to be send.
 */
CUDPPacket::CUDPPacket(int id, const uchar* p, int len) :
		length(len + PACKET_HEADER_SIZE),
		data(NULL)
{
	data = new uchar[length];
	memcpy(data + PACKET_HEADER_SIZE, p, len);
	Write24(data, id);
	Write24(data + 3, length);
}

/**
 * Delete the data associated with this packet.
 */
CUDPPacket::~CUDPPacket()
{
	delete[] data;
}

/**
 * Construct an UDP network connection. This should normally be done by a
 * CUDPSocket that's accepting connections (via the events in CSocketObservable).
 */
CUDPConnection::CUDPConnection(CUDPSocket* sock, const sockaddr_in& dest) :
		sock(sock),
		dest(dest),
		averagePing(0),
		readPacket(NULL),
		lastInOrderPacket(0),
		lastReceiveTime(0),
		lastRemoteTime(0),
		packetNum(0),
		lastSendTime(0),
		lastResendTime(0),
		lastAckedPacket(0),
		lastNackedPacket(0),
		outbuflen(0)
{
	sock->RegisterConnection(this);
}

/**
 * Cleanup.
 */
CUDPConnection::~CUDPConnection()
{
	// TODO wipe containers
	sock->UnregisterConnection(this);
	delete readPacket;
}

/**
 * Called by the higher layer to receive the next in-order packet.
 * This points data and len to the first ready packet.
 *
 * Invalidates the data returned by the previous call.
 * The caller must manually copy the data if it must persist.
 *
 * \return true if there was data available, false otherwise
 */
bool CUDPConnection::Read(const uchar*& data, int& len)
{
	do {
		if (readyPackets.empty()) {
			data = NULL;
			len = 0;
			return false;
		}

		delete readPacket;
		readPacket = readyPackets.front();
		readyPackets.pop_front();

		data = readPacket->GetData() + CUDPPacket::PACKET_HEADER_SIZE;
		len = readPacket->GetLength() - CUDPPacket::PACKET_HEADER_SIZE;

	} while (len == 0); // ignore ping/pong empty packets

	return true;
}

/**
 * Called by the higher layer to put some data in the send buffer.
 * If the send buffer is full, it is flushed.
 *
 * \return true if the packet was succesfully sent, false otherwise.
 * (This does not mean it has succesfully arrived on the other end.)
 * If it returns false this only means the packet couldn't be sent right away:
 * the data has still been stored in some buffer and will be sent later.
 */
bool CUDPConnection::Write(const uchar* data, int len)
{
	bool ret = true;

	if (outbuflen + len > (int)sizeof(outbuf)) {
		ret = Flush();

		if (outbuflen + len > (int)sizeof(outbuf))
			throw OverflowError(this);
	}

	memcpy(&outbuf[outbuflen], data, len);
	outbuflen += len;
	return ret;
}

/**
 * Called by CUDPSocket whenever a packet is received.
 * It handles acking / retransmitting and more bookkeeping stuff.
 */
void CUDPConnection::ReceiveRawPacket(uchar* data, int len)
{
	if (Read24(data+3) != len) {
		LOG("Dropping packet with invalid length field %d instead of %d.\n", Read24(data+3), len);
		return;
	}

	int curTime = GetTime();
	CUDPPacket* p = new CUDPPacket(data);

	lastReceiveTime = curTime;
	lastAckedPacket = std::max(lastAckedPacket, p->GetAcknowledgedId());
	lastRemoteTime = std::max(lastRemoteTime, p->GetSendTime());

	// Calculate ping.
	int lastPing = curTime - p->GetReceiveTime();

	// Without the last term averagePing can never reach lastPing if lastPing is higher (due to rounding)
	averagePing = (9 * averagePing + lastPing) / 10 + (lastPing > averagePing ? 1 : 0);

	// Remove unacked packets that are now acked.
	while (!unackedPackets.empty() && unackedPackets.front()->GetId() <= lastAckedPacket) {
		delete unackedPackets.front();
		unackedPackets.pop_front();
	}

	// Take appropriate action to handle the packet.
	// Depends on whether it's a duplicate and whether it's in order or out of order.
	// We need nack later on when p may have been deleted.
	int nack = p->GetNotAcknowledgedId();

	if (p->GetId() <= lastInOrderPacket || waitingPackets.find(p->GetId()) != waitingPackets.end()) {

		// We already received this packet, drop it.
		// No need for reply either since we already replied to the packet when it first arrived.
		LOG("Dropping duplicate packet %d.\n", p->GetId());
		delete p;
		p = NULL;

	} else if (p->GetId() == lastInOrderPacket + 1) {

		// This is the expected packet: put it in readyPackets.
		readyPackets.push_back(p);
		++lastInOrderPacket;

		// We may already have received future packets, ready them until the first gap.
		PacketsMap::iterator it;
		while ((it = waitingPackets.find(lastInOrderPacket + 1)) != waitingPackets.end()) {
			readyPackets.push_back(it->second);
			waitingPackets.erase(it);
			++lastInOrderPacket;
		}

	} else {

		// It is received out of order.
		waitingPackets[p->GetId()] = p;
	}

	// Resend missing packets (according to nack field in the packet)
	// This must be done after inserting the packet in the appropriate queues etc.,
	// because only then vars like lastInOrderPacket are up to date.
	// Dont resend if the peer hasn't had time to reply to the previous resend
	// of this packet or if the same range is to be nacked again.
	if (nack != 0 && (nack != lastNackedPacket || lastResendTime + 100 < curTime)) {
		int prevId = 0;
		PacketsQue::iterator u;

		for (u = unackedPackets.begin(); u != unackedPackets.end() && (*u)->GetId() < nack; ++u) {
			assert ((*u)->GetId() > lastAckedPacket && "Packet should already have been removed from unackedPackets");
			assert ((prevId == 0 || (*u)->GetId() > prevId) && "unackedPackets must contain an ordered range");

			bool ret = SendPacket(*u);
			LOG("Resending packet %d (unacked): %d\n", (*u)->GetId(), ret);
		}

		// We can ack nack now. (because of the loop u == nack if nack hasn't been acked before)
		// After all nack is set by remote side to a packet ID that is in remote
		// waitingPackets, so it has definitely been received.
		//if ((*u)->GetId() == nack) {
		//	delete *u;
		//	unackedPackets.erase(u);
		//}

		lastResendTime = curTime;
		lastNackedPacket = nack;
	}

	// Immediately send a packet back.
	// This keeps client and server "in sync", meaning the lowest possible pings
	// and hence the possibility to perform more aggressive resend algorithm.

	// Note that with this algorithm the send rate will only decrease if we
	// don't have any more data to send (which won't happen because of NEW_FRAME
	// messages).

	// Since lastSendTime is updated with all sends (including resends), the
	// (new) packet rate will also decrease if packets are lost / out of order.

	//if (p /*&& outbuflen > CUDPPacket::PACKET_HEADER_SIZE*/ && curTime > lastSendTime + (1000 / MAX_PACKETS_PER_SECOND))
	//	Flush();
}

/**
 * Fill in packet header and send it over our socket.
 */
bool CUDPConnection::SendPacket(CUDPPacket* p)
{
	p->PreSend(lastInOrderPacket, waitingPackets.empty() ? 0 : waitingPackets.begin()->first, lastRemoteTime);

	/*
	// Fake a send() function which fails 25% of the time.
	if ((rand() & 3) == 0)
		return false;

	// Fake 25% packet loss.
	if ((rand() & 3) == 0)
		return true;
	*/

	if (sock->SendRawPacket(p->GetData(), p->GetLength(), dest))
		return true;

	return false;
}

/**
 * Flush the connection.
 * \return true if it succesfully flushed the connection to the network,
 * false if it just flushed the buffer to the send queue because
 */
bool CUDPConnection::Flush()
{
	CUDPPacket* p = new CUDPPacket(++packetNum, outbuf, outbuflen);

	outbuflen = 0;

	// Don't even bother sending it if there are still packets in the sendQue.
	if (sendQue.empty() && SendPacket(p)) {
		//LOG("Sent packet %d size %d.  data: \"%.30s\"\n", p->GetId(), p->GetLength(), p->GetLength() > CUDPPacket::PACKET_HEADER_SIZE ? (const char*)p->GetData() + CUDPPacket::PACKET_HEADER_SIZE : "");
		lastSendTime = GetTime();
		unackedPackets.push_back(p);
		return true;
	} else {
		//LOG("Putting packet %d size %d in sendQue.  data: \"%.30s\"\n", p->GetId(), p->GetLength(), p->GetLength() > CUDPPacket::PACKET_HEADER_SIZE ? (const char*)p->GetData() + CUDPPacket::PACKET_HEADER_SIZE : "");
		LOG("Putting packet %d size %d in sendQue.\n", p->GetId(), p->GetLength());
		sendQue.push_back(p);
		return false;
	}
}

/**
 * Updates the connection
 */
void CUDPConnection::Update()
{
	int curTime = GetTime();

	if (curTime > lastReceiveTime + NETWORK_TIMEOUT)
		throw TimeoutError(this);

	if (curTime > lastSendTime + NETWORK_TIMEOUT)
		throw TimeoutError(this);

	// Resend packets if we didn't get an acknowledgement on time.
// 	for (PacketsQue::iterator u = unackedPackets.begin(); u != unackedPackets.end(); ++u) {
// 		// Dont resend if the peer hasn't had time to reply on the previous transmission of this packet.
// 		if (curTime > (*u)->GetLastResendTime() + averagePing * RESEND_TIMEOUT_FACTOR / 100 + RESEND_TIMEOUT) {
// 			LOG("Resending packet %d (ack timeout).\n", (*u)->GetId());
// 			SendPacket(*u);
// 		}
// 	}

	// Attempt to flush the sendQue.
	while (!sendQue.empty() && SendPacket(sendQue.front())) {
		LOG("Removing packet %d from sendQue.\n", sendQue.front()->GetId());
		lastSendTime = GetTime();
		unackedPackets.push_back(sendQue.front());
		sendQue.pop_front();
	}

	// Send something if we haven't sent anything in a while or if we missed
	// at least one incoming packet.
	if ((curTime > lastSendTime + (1000 / MIN_PACKETS_PER_SECOND)) ||
			 (!waitingPackets.empty() && (curTime > lastSendTime + (1000 / MAX_PACKETS_PER_SECOND))))
		Flush();
}

/**
 * Calculate ping to show in user interface.
 */
int CUDPConnection::GetPing() const
{
	int ping = GetTime() - lastReceiveTime;
	// This gives an ever increasing ping when conn is timing out
	// (and CUDPConnection::Update() is resending already)
	if (ping > averagePing * 2)
		return ping;
	return averagePing;
}

std::string CUDPConnection::GetWaitingPackets() const
{
	std::stringstream stream;

	for (PacketsMap::const_iterator it = waitingPackets.begin(); it != waitingPackets.end(); ++it) {
		assert(it->first == it->second->GetId());
		stream << it->first << " ";
	}

	return stream.str();
}

std::string CUDPConnection::GetUnacknowledgedPackets() const
{
	std::stringstream stream;

	for (PacketsQue::const_iterator it = unackedPackets.begin(); it != unackedPackets.end(); ++it)
		stream << (*it)->GetId() << " ";

	return stream.str();
}

}; // end of namespace net
