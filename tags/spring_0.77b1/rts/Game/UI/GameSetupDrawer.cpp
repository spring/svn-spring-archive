#include "StdAfx.h"
#include "Rendering/GL/myGL.h"
#include <assert.h>
#include <string>
#include <map>
#include <SDL_timer.h>
#include <SDL_keysym.h>

#include "mmgr.h"

#include "GameSetupDrawer.h"

#include "NetProtocol.h"
#include "Platform/ConfigHandler.h"
#include "../CameraHandler.h"
#include "../Player.h"
#include "../Team.h"
#include "../GameSetup.h"
#include "StartPosSelecter.h"
#include "Rendering/glFont.h"
#include "System/EventHandler.h"

extern Uint8 *keys;


GameSetupDrawer* GameSetupDrawer::instance = NULL;


void GameSetupDrawer::Enable()
{
	assert(instance == NULL);
	assert(gameSetup);

	instance = new GameSetupDrawer();
}


void GameSetupDrawer::Disable()
{
	if (instance) {
		delete instance;
		instance = NULL;
	}
}


void GameSetupDrawer::StartCountdown(unsigned time)
{
	if (instance) {
		instance->lastTick = SDL_GetTicks();
		instance->readyCountdown = (int)time;
		const std::string modeName = configHandler.GetString("CamModeName", "");
		if (!modeName.empty()) {
			camHandler->SetCameraMode(modeName);
		} else {
			const int modeIndex = configHandler.GetInt("CamMode", 1);
			camHandler->SetCameraMode(modeIndex);
		}
	}
}


GameSetupDrawer::GameSetupDrawer()
{
	readyCountdown = 0;
	lastTick = 0;
	if (gameSetup->startPosType == CGameSetup::StartPos_ChooseInGame && !gameSetup->hostDemo) {
		new CStartPosSelecter();
	}
	lctrl_pressed = false;
}

GameSetupDrawer::~GameSetupDrawer()
{
}


void GameSetupDrawer::Draw()
{
	if (readyCountdown > 0) {
		readyCountdown -= (SDL_GetTicks() - lastTick);
		lastTick = SDL_GetTicks();
	}
	else if (readyCountdown < 0) {
		GameSetupDrawer::Disable();
	}

	std::string state = "Unknown state.";
	if (readyCountdown > 0) {
		char buf[64];
		sprintf(buf, "Starting in %i", readyCountdown / 1000);
		state = buf;
	} else if (!gs->Team(gu->myTeam)->IsReadyToStart()) {
		state = "Choose start pos";
	} else if (gu->myPlayerNum==0) {
		state = "Waiting for players, Ctrl+Return to force start";
	} else {
		state = "Waiting for players";
	}

	// not the most efficent way to do this, but who cares?
	std::map<int, std::string> playerStates;
	for (int a = 0; a < gameSetup->numPlayers; a++) {
		if (!gs->players[a]->readyToStart) {
			playerStates[a] = "missing";
		} else if (!gs->Team(gs->players[a]->team)->IsReadyToStart()) {
			playerStates[a] = "notready";
		} else {
			playerStates[a] = "ready";
		}
	}

	CStartPosSelecter* selector = CStartPosSelecter::selector;
	bool ready = (selector == NULL);
	if (eventHandler.GameSetup(state, ready, playerStates)) {
		if (selector) {
			selector->ShowReady(false);
			if (ready) {
				selector->Ready();
			}
		}
		return; // LuaUI says it will do the rendering
	}
	if (selector) {
		selector->ShowReady(true);
	}

	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	font->glPrintAt(0.3f, 0.7f, 1.0f, state.c_str());

	for (int a = 0; a <= gameSetup->numPlayers; a++) {
		const float* color;
		const float    red[4] = { 1.0f, 0.2f, 0.2f, 1.0f };
		const float  green[4] = { 0.2f, 1.0f, 0.2f, 1.0f };
		const float yellow[4] = { 0.8f, 0.8f, 0.2f, 1.0f };
		const float  white[4] = { 1.0f, 1.0f, 1.0f, 1.0f };
		if (a == gameSetup->numPlayers) {
			color = white; //blue;
		} else if (!gs->players[a]->readyToStart) {
			color = red;
		} else if (!gs->Team(gs->players[a]->team)->IsReadyToStart()) {
			color = yellow;
		} else {
			color = green;
		}

		const char* name;
		if (a == gameSetup->numPlayers) {
			name = "Players:";
		} else {
			name = gs->players[a]->name.c_str();
		}
		const float fontScale = 1.0f;
		const float yScale = fontScale * font->GetHeight();
		const float yPos = 0.5f - (0.5f * yScale * gameSetup->numPlayers) + (yScale * (float)a);
		const float xPos = 10.0f * gu->pixelX;
		font->glPrintOutlinedAt(xPos, yPos, fontScale, name, color);
	}
}


bool GameSetupDrawer::KeyPressed(unsigned short key, bool isRepeat)
{
	if (keys[SDLK_LCTRL] && (key == SDLK_RETURN)) {
		// tell the server to force-start the game
		net->Send(CBaseNetProtocol::Get().SendStartPlaying(0));
	}
	return false;
}





