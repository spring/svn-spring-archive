#include "StdAfx.h"
#include "GameServer.h"
#include "Net.h"
#include "Player.h"
#include "Team.h"
#include "UI/InfoConsole.h"
#include "Game.h"
#include "GameSetup.h"
#include "StartScripts/ScriptHandler.h"
#include "Platform/errorhandler.h"
#include <stdarg.h>
#include <boost/bind.hpp>
#include "SDL_timer.h"

CGameServer* gameServer=0;

extern string stupidGlobalMapname;
extern int stupidGlobalMapId;
extern bool globalQuit;

static Uint32 GameServerThreadProc(void* lpParameter)
{
	((CGameServer*)lpParameter)->UpdateLoop();
	return 0;
}


CGameServer::CGameServer(void)
{
	makeMemDump=true;
	serverframenum=0;
	timeLeft=0;
	gameLoading=true;
	gameEndDetected=false;
	gameEndTime=0;
	outstandingSyncFrame=-1;
	outstandingChecksumFrame = -1;
	lastSyncRequest=0;
	quitServer=false;
	gameClientUpdated=false;
	maxTimeLeft=2;
	terminate = false;

	int port=8452;
	int myPlayer=0;
	if(gameSetup){
		port=gameSetup->hostport;
		myPlayer=gameSetup->myPlayer;
	}
	serverNet=new CNet();
	serverNet->InitServer(port);
	net->InitClient("localhost",port,0,true);
	serverNet->connections[myPlayer].localConnection=&net->connections[0];
	net->connections[0].localConnection=&serverNet->connections[myPlayer];
	serverNet->InitNewConn(&net->connections[0].addr,true,myPlayer);
	net->onlyLocal=true;

	if(gameSetup && gameSetup->hostDemo)
		serverNet->CreateDemoServer(gameSetup->demoName);

	lastframe = SDL_GetTicks();

	exeChecksum=game->CreateExeChecksum();

#ifndef SYNCIFY		//syncify doesnt really support multithreading...
	boost::thread thread(boost::bind(GameServerThreadProc,this));
#endif
}

CGameServer::~CGameServer(void)
{
	delete &gameServerMutex;
	delete serverNet;
	serverNet=0;
}

bool CGameServer::HandleSyncResponses()
{
	//check if last times sync responses is correct
	if (outstandingSyncFrame > 0 && !serverNet->playbackDemo) {
		CChecksum correctSync;
		for(int a = 0; a < gs->activePlayers; ++a) {
			if(gs->players[a]->active) {
				switch (syncResponseState[a]) {
					case SRS_WAITING:
						break;
					case SRS_TBH: // To Be Handled
						if (correctSync) {
							if (correctSync != syncResponses[a]) {
								char buf[10];
								SendSystemMsg("Sync error for %s %i %s",
										gs->players[a]->playerName.c_str(), outstandingSyncFrame, correctSync.diff(buf, syncResponses[a]));
								if (outstandingChecksumFrame <= 0 && (correctSync.x != syncResponses[a].x || correctSync.y != syncResponses[a].y || correctSync.z != syncResponses[a].z)) {
									// try to resync by sending out a CHECKSUMREQUEST (only on XYZ sync errors)
									serverNet->SendData<int>(NETMSG_CHECKSUMREQUEST, serverframenum);
									outstandingChecksumFrame = serverframenum;
									lastChecksumRequest = gu->gameTime;
									for (int b = 0; b < gs->activePlayers; ++b)
										checksumResponses[b].resize(1, 0xFFFF);
								}
								syncResponseState[a] = SRS_WRONG;
							} else
								syncResponseState[a] = SRS_RIGHT;
						} else {
							//this assumes the lowest num player is the correct one, should maybe some sort of majority voting instead
							correctSync = syncResponses[a];
							syncResponseState[a] = SRS_RIGHT;
						}
						break;
					case SRS_WRONG:
						break;
					case SRS_RIGHT:
						correctSync = syncResponses[a];
						break;
				}
			}
		}
	}

	// Every 2 seconds, reset the sync repsonses and push a new SYCNREQUEST out.
	if(lastSyncRequest < gu->gameTime - 2){
		lastSyncRequest = gu->gameTime;

		if (outstandingSyncFrame > 0) {
			for (int a = 0; a < gs->activePlayers; ++a) {
				if (gs->players[a]->active) {
					if (syncResponseState[a] == SRS_WAITING)
						info->AddLine("No sync response from %s", gs->players[a]->playerName.c_str());
				}
			}
			outstandingSyncFrame = -1;
		}
		// wait with pushing a new syncrequest until all resync is finished.
		if (!serverNet->playbackDemo && outstandingChecksumFrame <= 0) {
			// reset
			for (int a = 0; a < gs->activePlayers; ++a) {
				syncResponses[a] = 0;
				syncResponseState[a] = SRS_WAITING;
			}
			//send sync request
			serverNet->SendData<int>(NETMSG_SYNCREQUEST, serverframenum);
			outstandingSyncFrame = serverframenum;
		}
		return true;
	}
	return false;
}

void CGameServer::HandleChecksumResponses()
{
	//check if there's anything received
	if (outstandingChecksumFrame > 0 && !serverNet->playbackDemo) {
		bool gotAll = true;
		for (int a = 0; a < gs->activePlayers; ++a) {
			if (gs->players[a]->active) {
				if (checksumResponses[a].size() == 1) { // size == 1 marks not yet received (normally size is even)
					gotAll = false;
					continue;
				}
			}
		}
		if (gotAll || lastChecksumRequest < gu->gameTime - 3) { // 3 sec timeout

			// Start the Big Comparison :)

			std::map<int, int> checksums[MAX_PLAYERS];

			// map unit IDs to checksums and get them sorted, that's easier in next step
			for (int a = 0; a < gs->activePlayers; ++a) {
				if (gs->players[a]->active) {
					if (checksumResponses[a].size() == 1) {
						info->AddLine("No checksum response from %s", gs->players[a]->playerName.c_str());
						continue;
					}
					for (int b = 0; b < checksumResponses[a].size(); b += 2)
						// add 1 so we can use 0 for unused fields.
						checksums[a][checksumResponses[a][b]] = 1 + checksumResponses[a][b + 1];
				}
			}

			// now walk through all units and find those with different checksums
			std::vector<unsigned short> unitsToResync;
			for (int a = 0; a < MAX_UNITS; ++a) {
				int correctChecksum = 0;
				for (int b = 0; b < gs->activePlayers; ++b) {
					if (gs->players[b]->active) {
						std::map<int, int>::const_iterator ci = checksums[b].find(a);
						if (ci != checksums[b].end()) {
							if (correctChecksum && correctChecksum != ci->second)
								unitsToResync.push_back(a);
							else
								// again, we assume first one is correct one here
								// that makes it easier too to just push the host's version of the game out on resync
								correctChecksum = ci->second;
						} else if (correctChecksum && checksumResponses[b].size() != 1)
							info->AddLine("Missing checksum for unit %d of %s", a, gs->players[b]->playerName.c_str());
					}
				}
			}

			// Send a message which instructs a certain client (we just use the host for now, could use majority voting instead)
			// to send a RESYNCRESPONSE with unit data attached to us, which we'll forward to all clients.
			// TODO majority voting
			// TODO don't send this to all clients but only to the clients needing it
			serverNet->SendSTLData<unsigned char, std::vector<unsigned short> >(NETMSG_RESYNCREQUEST, 0 /* host */, unitsToResync);

			// We're free for a new resync again
			outstandingChecksumFrame = -1;
		}
	}
}

bool CGameServer::Update(void)
{
	if (terminate) {
		delete this;
		return true;
	}

	if (game->playing) {

		HandleChecksumResponses();

		if(HandleSyncResponses()) {

			// Do some more stuff at the same interval syncrequests are pushed out.

			int firstReal=0;
			if(gameSetup)
				firstReal=gameSetup->numDemoPlayers;
			//send info about the players
			for(int a=firstReal;a<gs->activePlayers;++a){
				if(gs->players[a]->active){
					serverNet->SendData<unsigned char, float, int>(
							NETMSG_PLAYERINFO, a, gs->players[a]->cpuUsage, gs->players[a]->ping);
				}
			}

			//decide new internal speed
			float maxCpu=0;
			for(int a=0;a<gs->activePlayers;++a){
				if(gs->players[a]->cpuUsage>maxCpu && gs->players[a]->active){
					maxCpu=gs->players[a]->cpuUsage;
				}
			}

			float wantedCpu=0.35+(1-gs->speedFactor/gs->userSpeedFactor)*0.5;
			//float speedMod=1+wantedCpu-maxCpu;
			float newSpeed=gs->speedFactor*wantedCpu/maxCpu;
			//info->AddLine("Speed %f %f %f %f",maxCpu,wantedCpu,speedMod,newSpeed);
			newSpeed=(newSpeed+gs->speedFactor)*0.5;
			if(newSpeed>gs->userSpeedFactor)
				newSpeed=gs->userSpeedFactor;
			if(newSpeed<0.1)
				newSpeed=0.1;
			if(newSpeed!=gs->speedFactor)
				serverNet->SendData<float>(NETMSG_INTERNAL_SPEED, newSpeed);
		}
	}

	if(!ServerReadNet()){
		info->AddLine("Server read net wanted quit");
		return false;
	}
	if (game->playing && !serverNet->playbackDemo){
		Uint64 currentFrame;
		currentFrame = SDL_GetTicks();
		double timeElapsed=((double)(currentFrame - lastframe))/1000.;
		if(gameEndDetected)
			gameEndTime+=timeElapsed;
//		info->AddLine("float value is %f",timeElapsed);

		if(gameClientUpdated){
			gameClientUpdated=false;
			maxTimeLeft=2;
		}
		if(timeElapsed>maxTimeLeft)
			timeElapsed=maxTimeLeft;
		maxTimeLeft-=timeElapsed;

		timeLeft+=GAME_SPEED*gs->speedFactor*timeElapsed;
		lastframe=currentFrame;
		
		while((timeLeft>0) && (!gs->paused || game->bOneStep)){
			if(!game->creatingVideo){
				game->bOneStep=false;
				CreateNewFrame(true);
			}
			timeLeft--;
		}
	}
	serverNet->Update();

	CheckForGameEnd();
	return true;
}

bool CGameServer::ServerReadNet()
{
	static int lastMsg[MAX_PLAYERS],thisMsg=0;

	for(int a=0;a<gs->activePlayers;a++){
		int inbufpos=0;
		int inbuflength=0;
		if(gs->players[a]->active && (!gameSetup || a>=gameSetup->numDemoPlayers)){
			if((inbuflength=serverNet->GetData(inbuf,NETWORK_BUFFER_SIZE,a))==-1){
				PUSH_CODE_MODE;		//this could lead to some nasty errors if the other thread switches code mode...
				ENTER_MIXED;
				gs->players[a]->active=false;
				POP_CODE_MODE;
				inbuflength=0;
				serverNet->SendData<unsigned char, unsigned char>(NETMSG_PLAYERLEFT, a, 0);
			}
		}
		//		(*info) << serverNet->numConnected << "\n";

		while(inbufpos<inbuflength){
			thisMsg=inbuf[inbufpos];
			int lastLength=0;
			switch (inbuf[inbufpos]){

			case NETMSG_ATTEMPTCONNECT: //handled directly in CNet
				lastLength=3;
				break;

			case NETMSG_HELLO: 
				lastLength=1;
				break;

			case NETMSG_RANDSEED: 
				lastLength=5;
				serverNet->SendData(&inbuf[inbufpos],5); //forward data
				break;

			case NETMSG_NEWFRAME: 
				gs->players[a]->ping=serverframenum-*(int*)&inbuf[inbufpos+1];
				lastLength=5;
				break;

			case NETMSG_PAUSE:
				if(inbuf[inbufpos+2]!=a){
					info->AddLine("Server: Warning got pause msg from %i claiming to be from %i",a,inbuf[inbufpos+2]);
				} else {
					if(game->gamePausable || a==0){
						timeLeft=0;
						serverNet->SendData(&inbuf[inbufpos],3);
					}
				}
				lastLength=3;
				break;

			case NETMSG_INTERNAL_SPEED: 
				info->AddLine("Server shouldnt get internal speed msgs?");
				lastLength=5;
				break;

			case NETMSG_USER_SPEED: {
				float speed=*((float*)&inbuf[inbufpos+1]);
				if(speed>game->maxUserSpeed)
					speed=game->maxUserSpeed;
				if(speed<game->minUserSpeed)
					speed=game->minUserSpeed;
				if(gs->userSpeedFactor!=speed){
					if(gs->speedFactor==gs->userSpeedFactor || gs->speedFactor>speed)
						serverNet->SendData<float>(NETMSG_INTERNAL_SPEED, speed);
					serverNet->SendData(&inbuf[inbufpos],5); //forward data
				}
				lastLength=5;
				break;}

			case NETMSG_CPU_USAGE: 
				ENTER_MIXED;
				gs->players[a]->cpuUsage=*((float*)&inbuf[inbufpos+1]);
				ENTER_UNSYNCED;
				lastLength=5;
				break;

			case NETMSG_EXECHECKSUM: 
				if(exeChecksum!=*((unsigned int*)&inbuf[inbufpos+1])){
					SendSystemMsg("Wrong exe checksum from %i got %X instead of %X",a,*((unsigned int*)&inbuf[inbufpos+1]),exeChecksum);
				}
				lastLength=5;
				break;

			case NETMSG_MAPNAME:
				if(inbuf[inbufpos+1])
					lastLength=inbuf[inbufpos+1];
				break;

			case NETMSG_QUIT:
				ENTER_MIXED;
				gs->players[a]->active=false;
				ENTER_UNSYNCED;
				serverNet->connections[a].active=false;
				serverNet->SendData<unsigned char, unsigned char>(NETMSG_PLAYERLEFT, a, 1);
				lastLength=1;
				break;

			case NETMSG_PLAYERNAME:
				if(inbuf[inbufpos+2]!=a && a!=0){
					SendSystemMsg("Server: Warning got playername msg from %i claiming to be from %i",a,inbuf[inbufpos+2]);
				} else {
					ENTER_MIXED;
					gs->players[inbuf[inbufpos+2]]->playerName=(char*)(&inbuf[inbufpos+3]);
					gs->players[inbuf[inbufpos+2]]->readyToStart=true;
					gs->players[inbuf[inbufpos+2]]->active=true;
					ENTER_UNSYNCED;

					SendSystemMsg("Player %s joined as %i",&inbuf[inbufpos+3],inbuf[inbufpos+2]);
					serverNet->SendData(&inbuf[inbufpos],inbuf[inbufpos+1]); //forward data
				}
				lastLength=inbuf[inbufpos+1];
				break;

			case NETMSG_CHAT:
				if(inbuf[inbufpos+2]!=a){
					SendSystemMsg("Server: Warning got chat msg from %i claiming to be from %i",a,inbuf[inbufpos+2]);
				} else {
					serverNet->SendData(&inbuf[inbufpos],inbuf[inbufpos+1]); //forward data
				}
				lastLength=inbuf[inbufpos+1];
				break;

			case NETMSG_SYSTEMMSG:
				if(inbuf[inbufpos+2]!=a){
					info->AddLine("Server: Warning got system msg from %i claiming to be from %i",a,inbuf[inbufpos+2]);
				} else {
					serverNet->SendData(&inbuf[inbufpos],inbuf[inbufpos+1]); //forward data
				}
				lastLength=inbuf[inbufpos+1];	
				break;

			case NETMSG_STARTPOS:
				if(inbuf[inbufpos+1]!=gs->players[a]->team && a!=0){
					SendSystemMsg("Server: Warning got select msg from %i claiming to be from team %i",a,inbuf[inbufpos+1]);
				} else {
					serverNet->SendData(&inbuf[inbufpos],15); //forward data
				}
				lastLength=15;
				break;

			case NETMSG_COMMAND:
				if(inbuf[inbufpos+3]!=a){
					SendSystemMsg("Server: Warning got command msg from %i claiming to be from %i",a,inbuf[inbufpos+3]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],*((short int*)&inbuf[inbufpos+1])); //forward data
				}
				lastLength=*((short int*)&inbuf[inbufpos+1]);
				break;

			case NETMSG_SELECT:
				if(inbuf[inbufpos+3]!=a){
					SendSystemMsg("Server: Warning got select msg from %i claiming to be from %i",a,inbuf[inbufpos+3]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],*((short int*)&inbuf[inbufpos+1])); //forward data
				}
				lastLength=*((short int*)&inbuf[inbufpos+1]);
				break;

			case NETMSG_AICOMMAND:
				if(inbuf[inbufpos+3]!=a){
					SendSystemMsg("Server: Warning got aicommand msg from %i claiming to be from %i",a,inbuf[inbufpos+3]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],*((short int*)&inbuf[inbufpos+1])); //forward data
				}
				lastLength=*((short int*)&inbuf[inbufpos+1]);
				break;

			case NETMSG_SYNCRESPONSE:{
				if(inbuf[inbufpos+1]!=a){
					SendSystemMsg("Server: Warning got syncresponse msg from %i claiming to be from %i",a,inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo){
						int frame = *(int*)&inbuf[inbufpos+2];
						if(outstandingSyncFrame == frame) {
							syncResponses[inbuf[inbufpos+1]] = *(CChecksum*)&inbuf[inbufpos+6];
							syncResponseState[inbuf[inbufpos+1]] = SRS_TBH;
						} else
							info->AddLine("Delayed sync respone from %s (%i instead of %i)",
										  gs->players[inbuf[inbufpos+1]]->playerName.c_str(), frame, outstandingSyncFrame);
					}
				}
				lastLength=6+sizeof(CChecksum);}
				break;

			case NETMSG_SHARE:
				if(inbuf[inbufpos+1]!=a){
					SendSystemMsg("Server: Warning got share msg from %i claiming to be from %i",a,inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],12); //forward data
				}
				lastLength=12;
				break;

			case NETMSG_SETSHARE:
				if(inbuf[inbufpos+1]!=gs->players[a]->team){
					SendSystemMsg("Server: Warning got setshare msg from player %i claiming to be from team %i",a,inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],10); //forward data
				}
				lastLength=10;
				break;

			case NETMSG_PLAYERSTAT:
				if(inbuf[inbufpos+1]!=a){
					SendSystemMsg("Server: Warning got stat msg from %i claiming to be from %i",a,inbuf[inbufpos+1]);
				} else {
					serverNet->SendData(&inbuf[inbufpos],sizeof(CPlayer::Statistics)+2); //forward data
				}
				lastLength=sizeof(CPlayer::Statistics)+2;
				break;

			case NETMSG_MAPDRAW:
				serverNet->SendData(&inbuf[inbufpos],inbuf[inbufpos+1]); //forward data
				lastLength=inbuf[inbufpos+1];
				break;

#ifdef DIRECT_CONTROL_ALLOWED
			case NETMSG_DIRECT_CONTROL:
				if(inbuf[inbufpos+1]!=a){
					SendSystemMsg("Server: Warning got direct control msg from %i claiming to be from %i",a,inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],2); //forward data
				}
				lastLength=2;
				break;

			case NETMSG_DC_UPDATE:
				if(inbuf[inbufpos+1]!=a){
					SendSystemMsg("Server: Warning got dc update msg from %i claiming to be from %i",a,inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo)
						serverNet->SendData(&inbuf[inbufpos],7); //forward data
				}
				lastLength=7;
				break;
#endif
			case NETMSG_CHECKSUMRESPONSE:
				/*
					unsigned char NETMSG_CHECKSUMRESPONSE @0
					short int     size                    @1
					unsigned char myPlayerNum             @3
					int           frameNum                @4
					std::vector<unsigned short>           @8
				*/
				if(inbuf[inbufpos+3]!=a){
					SendSystemMsg("Server: Warning got checksum response msg from %i claiming to be from %i", a, inbuf[inbufpos+1]);
				} else {
					if(!serverNet->playbackDemo){
						int player = inbuf[inbufpos+3];
						int frame = *(int*)&inbuf[inbufpos+4];
						if(outstandingChecksumFrame == frame) {
							int numelem = (*((short int*)&inbuf[inbufpos+1]) - 8) / sizeof(short);
							const unsigned short* begin = (unsigned short*)&inbuf[inbufpos+8];
							const unsigned short* end = begin + numelem;
							checksumResponses[player].resize(numelem);
							std::copy(begin, end, checksumResponses[player].begin());
						} else
							info->AddLine("Delayed checksum respone from %s (%i instead of %i)",
										  gs->players[player]->playerName.c_str(), frame, outstandingChecksumFrame);
					}
				}
				lastLength=*((short int*)&inbuf[inbufpos+1]);
				assert(lastLength > 0);
				break;

			case NETMSG_RESYNCRESPONSE: {
				/*
					unsigned char NETMSG_RESYNCRESPONSE   @0
					int           frameNum                @1
					CResyncUnit   unit data               @5
				*/
				int* frame = (int*)&inbuf[inbufpos+1];
				// Adjust frame to the right value.
				*frame = serverframenum;
				lastLength=5+sizeof(CResyncUnit);}
				if(!serverNet->playbackDemo)
					serverNet->SendData(&inbuf[inbufpos],lastLength); //forward data to everyone
				break;

			default:
				char txt[200];
				sprintf(txt,"Unknown net msg in server %d from %d pos %d last %d",(int)inbuf[inbufpos],a,inbufpos,lastMsg[a]);
				info->AddLine(txt);
				//handleerror(0,txt,"Network error",0);
				lastLength=1;
				break;
			}
			if(lastLength<=0){
				info->AddLine("Server readnet got packet type %i length %i pos %i from %i??",thisMsg,lastLength,inbufpos,a);
				lastLength=1;
			}
			inbufpos+=lastLength;
			lastMsg[a]=thisMsg;
		}
		if(inbufpos!=inbuflength){
			char txt[200];
			sprintf(txt,"Wrong packet length got %d from %d instead of %d",inbufpos,a,inbuflength);
			info->AddLine(txt);
			handleerror(0,txt,"Server network error",0);
		}
	}
	return true;
}

void CGameServer::StartGame(void)
{
	boost::mutex::scoped_lock scoped_lock(gameServerMutex);
	serverNet->StopListening();

	// This should probably work now that I fixed a bug (netbuf->inbuf)
	// in Game.cpp, in the code receiving NETMSG_RANDSEED. --tvo
	//serverNet->SendData<unsigned int>(NETMSG_RANDSEED, gs->randSeed);

	for(int a=0;a<gs->activePlayers;a++){
		if(!gs->players[a]->active)
			continue;
		serverNet->SendSTLData<unsigned char, std::string>(NETMSG_PLAYERNAME, a, gs->players[a]->playerName);
	}
	if(gameSetup){
		for(int a=0;a<gs->activeTeams;a++){
			serverNet->SendData<unsigned char, unsigned char, float, float, float>(
					NETMSG_STARTPOS, a, 1, gs->Team(a)->startPos.x, gs->Team(a)->startPos.y, gs->Team(a)->startPos.z);
		}
	}
	serverNet->SendData(NETMSG_STARTPLAYING);
	timeLeft=0;
}

void CGameServer::CheckForGameEnd(void)
{
	if(gameEndDetected){
		if(gameEndTime>2 && gameEndTime<500){
			serverNet->SendData(NETMSG_GAMEOVER);
			gameEndTime=600;
		}
		return;
	}

	bool active[MAX_TEAMS];

	for(int a=0;a<MAX_TEAMS;++a)
		active[a]=false;

	for(int a=0;a<gs->activeTeams;++a)
		if(!gs->Team(a)->isDead)
			active[gs->AllyTeam(a)]=true;

	int numActive=0;

	for(int a=0;a<MAX_TEAMS;++a)
		if(active[a])
			numActive++;

	if(numActive<=1){
		gameEndDetected=true;
		gameEndTime=0;
		serverNet->SendData(NETMSG_SENDPLAYERSTAT);
	}
}

void CGameServer::CreateNewFrame(bool fromServerThread)
{
	boost::mutex::scoped_lock scoped_lock(gameServerMutex,!fromServerThread);
	serverframenum++;
	if(serverNet->SendData<int>(NETMSG_NEWFRAME, serverframenum) == -1){
		info->AddLine("Server net couldnt send new frame");
		globalQuit=true;
	}
}

void CGameServer::UpdateLoop(void)
{
	while(gameLoading){		//avoid timing out while loading (esp if calculating path data)
		SDL_Delay(100);
		serverNet->Update();
	}
	SDL_Delay(100);		//we might crash if game hasnt finished initializing within this time
	/*
	 * Need a better solution than this for starvation.
	 * Decreasing thread priority (making it more important)
	 * requires root privileges on POSIX systems
	 */
	//SetThreadPriority(thisThread,THREAD_PRIORITY_ABOVE_NORMAL);		//we want the server to continue running smoothly even if the game client is struggling
	while(!quitServer)
	{
		{
			boost::mutex::scoped_lock scoped_lock(gameServerMutex);
			if(!Update()){
				info->AddLine("Game server experienced an error in update");
				globalQuit=true;
			}
		}
		SDL_Delay(10);
	}
	terminate = true;
}

void CGameServer::SendSystemMsg(const char* fmt,...)
{
	char text[500];
	va_list		ap;										// Pointer To List Of Arguments

	if (fmt == NULL)									// If There's No Text
		return;											// Do Nothing

	va_start(ap, fmt);									// Parses The String For Variables
	VSNPRINTF(text, sizeof(text), fmt, ap);				// And Converts Symbols To Actual Numbers
	va_end(ap);											// Results Are Stored In Text

	std::string msg = text;
	serverNet->SendSTLData<unsigned char, std::string>(NETMSG_SYSTEMMSG, gu->myPlayerNum, msg);
}
