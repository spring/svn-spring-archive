#ifndef __GAME_SERVER_H__
#define __GAME_SERVER_H__

#include <boost/thread/recursive_mutex.hpp>
#include <boost/thread/thread.hpp>
#include <boost/scoped_ptr.hpp>
#include <string>
#include <map>
#include <deque>
#include <set>
#include <vector>

#include "Console.h"
#include "GameData.h"
#include "PlayerBase.h"
#include "Sim/Misc/GlobalConstants.h"
#include "UnsyncedRNG.h"
#include "SFloat3.h"

class CBaseNetProtocol;
namespace netcode
{
	class RawPacket;
	class CConnection;
	class UDPListener;
}
class CDemoReader;
class AutohostInterface;
class CGameSetup;
class LocalSetup;
class ChatMessage;

const unsigned SERVER_PLAYER = 255; //server generated message which needs a playernumber

class GameParticipant : public PlayerBase
{
public:
	GameParticipant();
	
	void operator=(const PlayerBase& base) { PlayerBase::operator=(base); };

	enum State
	{
		UNCONNECTED,
		CONNECTED,
		INGAME,
		DISCONNECTED
	};
	State myState;
	
	float cpuUsage;
	int ping;

	bool isLocal;
	boost::shared_ptr<netcode::CConnection> link;
#ifdef SYNCCHECK
	std::map<int, unsigned> syncResponse; // syncResponse[frameNum] = checksum
#endif
};

class GameTeam
{
public:
	SFloat3 startpos;
	bool readyToStart;
	int allyTeam;
};

/**
@brief Server class for game handling
This class represents a gameserver. It is responsible for recieving, checking and forwarding gamedata to the clients. It keeps track of the sync, cpu and other stats and informs all clients about events.
*/
class CGameServer : public CommandReceiver
{
	friend class CLoadSaveHandler;     //For initialize server state after load
public:
	CGameServer(const LocalSetup* settings, bool onlyLocal, const GameData* const gameData, const CGameSetup* const setup);
	virtual ~CGameServer();

	void AddLocalClient(const std::string& myName, const std::string& myVersion);

	void AddAutohostInterface(const int remotePort);

	/**
	@brief Set frame after loading
	WARNING! No checks are done, so be carefull
	*/
	void PostLoad(unsigned lastTick, int serverframenum);

	void CreateNewFrame(bool fromServerThread, bool fixedFrameTime);

	bool WaitsOnCon() const;
	bool GameHasStarted() const;

	void SetGamePausable(const bool arg);

	virtual void PushAction(const Action& action);

	/// Is the server still running?
	bool HasFinished() const;

#ifdef DEBUG
	bool gameClientUpdated;			//used to prevent the server part to update to fast when the client is mega slow (running some sort of debug mode)
#endif

private:
	/**
	@brief catch commands from chat messages and handle them
	Insert chat messages here. If it contains a command (e.g. .nopause) usefull for the server it get filtered out, otherwise it will forwarded to all clients.
	@param msg The whole message
	@param player The playernumber which sent the message
	*/
	void GotChatMessage(const ChatMessage& msg);

	/**
	@brief kick the specified player from the battle
	*/
	void KickPlayer(const int playerNum);

	unsigned BindConnection(const std::string& name, const std::string& version, bool isLocal, boost::shared_ptr<netcode::CConnection> link);

	void CheckForGameStart(bool forced=false);
	void StartGame();
	void UpdateLoop();
	void Update();
	void ProcessPacket(const unsigned playernum, boost::shared_ptr<const netcode::RawPacket> packet);
	void CheckSync();
	void ServerReadNet();
	void CheckForGameEnd();

	void GenerateAndSendGameID();
	std::string GetPlayerNames(const std::vector<int>& indices) const;

	/// read data from demo and send it to clients
	void SendDemoData(const bool skipping=false);

	void Broadcast(boost::shared_ptr<const netcode::RawPacket> packet);

	/**
	@brief skip frames

	If you are watching a demo, this will push out all data until targetframe to all clients
	*/
	void SkipTo(int targetframe);

	void Message(const std::string& message);
	void Warning(const std::string& message);

	/////////////////// game status variables ///////////////////

	volatile bool quitServer;
	int serverframenum;

	unsigned serverStartTime;
	unsigned readyTime;
	unsigned gameStartTime;
	unsigned gameEndTime;	//Tick when game end was detected
	bool sentGameOverMsg;
	unsigned lastTick;
	float timeLeft;
	unsigned lastPlayerInfo;
	unsigned lastUpdate;
	float modGameTime;

	bool isPaused;
	float userSpeedFactor;
	float internalSpeed;
	bool cheating;

	std::vector<GameParticipant> players;
	boost::scoped_ptr<GameTeam> teams[MAX_TEAMS];

	float medianCpu;
	int medianPing;
	int enforceSpeed;
	/////////////////// game settings ///////////////////
	boost::scoped_ptr<const CGameSetup> setup;
	boost::scoped_ptr<const GameData> gameData;
	/// Wheter the game is pausable for others than the host
	bool gamePausable;

	/// The maximum speed users are allowed to set
	float maxUserSpeed;

	/// The minimum speed users are allowed to set (actual speed can be lower due to high cpu usage)
	float minUserSpeed;

	bool noHelperAIs;

	/////////////////// sync stuff ///////////////////
#ifdef SYNCCHECK
	std::deque<int> outstandingSyncFrames;
#endif
	int syncErrorFrame;
	int syncWarningFrame;
	int delayedSyncResponseFrame;

	///////////////// internal stuff //////////////////
	void InternalSpeedChange(float newSpeed);
	void UserSpeedChange(float newSpeed, int player);

	bool hasLocalClient;
	unsigned localClientNumber;

	void RestrictedAction(const std::string& action);

	/// If the server recieves a command, it will forward it to clients if it is not in this set
	std::set<std::string> commandBlacklist;
	boost::scoped_ptr<netcode::UDPListener> UDPNet;
	boost::scoped_ptr<CDemoReader> demoReader;
	boost::scoped_ptr<AutohostInterface> hostif;
	UnsyncedRNG rng;
	boost::thread* thread;
	mutable boost::recursive_mutex gameServerMutex;
};

extern CGameServer* gameServer;

#endif // __GAME_SERVER_H__
