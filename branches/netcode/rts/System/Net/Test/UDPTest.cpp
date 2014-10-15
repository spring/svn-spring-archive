#include "../Multicaster.h"
#include "../UDPConnection.h"

// bytes per second
#define BYTERATE (30*1024)

using namespace net;

class CConnectionPool : public ISocketObserver
{
	public:

		CUDPConnection* connection;

		CConnectionPool() : connection(NULL) {}

		virtual bool AcceptConnection(uchar* data, int length)
		{
			LOG("Accept connection?\n");
			return connection == NULL;
		}

		virtual void ConnectionAccepted(IConnection* conn)
		{
			LOG("Connection accepted.\n");
			connection = dynamic_cast<CUDPConnection*>(conn);
		}
};

void msleep(int ms)
{
	struct timespec requested, remaining;

	requested.tv_sec = ms / 1000;
	requested.tv_nsec = (ms % 1000) * 1000000;

	nanosleep(&requested, &remaining);
}

int server()
{
	LOG("Server started.\n");

	CUDPSocket socket(8452);
	CConnectionPool pool;
	CUDPConnection* udp;

	socket.RegisterObserver(&pool);

	uchar data[15000];
	int sizeof_data;
	int count = 0;
	int length = 0;

	//fcntl(fileno(stdin), F_SETFL, O_NONBLOCK);

	while (pool.connection == NULL) {
		socket.Update();
		msleep(10);
	}

	udp = pool.connection;

	int start = GetTime(), end;
	do {
		sizeof_data = 30 + rand() % (sizeof(data) - 29);
		length = fread(data, 1, sizeof_data, stdin);
		if (length > 0) {
			count += length;
			udp->Write(data, length);
			//fwrite(data, 1, length, stdout);
			//fflush(stdout);
		}
		try {
			socket.Update();
		} catch (const TimeoutError &e) {
			delete e.connection;
			LOG("Closing connection.\n");
			return 1;
		}
		end = GetTime();
		fprintf(stderr, "\t\t\t\t\t[ %dk %dk/s %d ms ready:%d waiting:%d unacked:%d sendque:%d ] \r",
		        count/1024, count / (1 + end - start), udp->GetPing(),
		        udp->GetNumberOfReadyPackets(), udp->GetNumberOfWaitingPackets(),
		        udp->GetNumberOfUnacknowledgedPackets(), udp->GetNumberOfSendQuePackets());
		int startdelay = GetTime();
		while (GetTime() < startdelay + sizeof_data * 1000 / BYTERATE) {
			try {
				socket.Update();
			} catch (const TimeoutError &e) {
				delete e.connection;
				LOG("Closing connection.\n");
				return 1;
			}
			msleep(1);
		}
	} while (length == sizeof_data);

	const char* endmsg = "``` END OF TRANSFER ```";
	udp->Flush(); // must be here otherwise end of xfer msg may be split over two packets
	udp->Write((unsigned char*)endmsg, strlen(endmsg) + 1);
	udp->Flush();
	fprintf(stderr, "\n");
	LOG("Finished transfer, please wait for client to finish receiving.\n");

	bool done = false;
	const uchar* recvbuf;
	while (!udp->Read(recvbuf, length) || length < 21 || memcmp(recvbuf, "``` ACKNOWLEDGED ```", 21) != 0) {
		try {
			socket.Update();
		} catch (const TimeoutError &e) {
			delete e.connection;
			LOG("Closing connection.\n");
			return 1;
		}
		fprintf(stderr, "\t\t\t\t\t[ %dk %dk/s %d ms ready:%d waiting:%d unacked:%d sendque:%d ] \r",
		        count/1024, count / (1 + end - start), udp->GetPing(),
		        udp->GetNumberOfReadyPackets(), udp->GetNumberOfWaitingPackets(),
		        udp->GetNumberOfUnacknowledgedPackets(), udp->GetNumberOfSendQuePackets());
		msleep(10);
	}
	fprintf(stderr, "\n");
	LOG("Server stopped.\n");

	return 0;
}

int client(const char* hostname, int port)
{
	LOG("Client connecting to %s:%d.\n", hostname, port);

	struct hostent* host = gethostbyname(hostname);
	sockaddr_in dest;

	if (!host) {
		LOG("gethostbyname(\"%s\") failed.", hostname);
		return 1;
	}

	memset(&dest, 0, sizeof(dest));
	dest.sin_family = AF_INET;
	dest.sin_port = htons(port);
	dest.sin_addr = *((struct in_addr*)*host->h_addr_list);

	CUDPSocket socket(0);
	CUDPConnection conn(&socket, dest);

	bool done = false;
	while (!done) {
		const uchar* data = NULL;
		int length = 0;
		while (conn.Read(data, length)) {
			if (length >= 24 && memcmp((const char*)data + length - 24, "``` END OF TRANSFER ```", 24) == 0) {
				done = true;
				fwrite(data, 1, length - 24, stdout);
			} else {
				fwrite(data, 1, length, stdout);
			}
		}
		fflush(stdout);
		socket.Update();
		msleep(10);
	}
	const char* ackmsg = "``` ACKNOWLEDGED ```";
	conn.Flush();
	conn.Write((unsigned char*)ackmsg, strlen(ackmsg) + 1);
	conn.Flush();
	for (int i = 0; i < 100; ++i) {
		socket.Update();
		msleep(10);
	}
	LOG("Client stopped.  unacked: %d\n", conn.GetNumberOfUnacknowledgedPackets());
	return 0;
}

int main(int argc, char** argv)
{
	//srand(time(NULL));
	srand(1);
	SDL_Init(SDL_INIT_TIMER);
	try {
		if (argc == 3)
			return client(argv[1], atoi(argv[2]));
		else
			return server();
	} catch (std::runtime_error& e) {
		LOG("Caught exception: %s\n", e.what());
		return 1;
	}
}
