#include "StdAfx.h"
#include "StartPosSelecter.h"
#include "MouseHandler.h"
#include "Rendering/GL/myGL.h"
#include "Rendering/glFont.h"
#include "Game/GameSetup.h"
#include "Game/Team.h"
#include "NetProtocol.h"
#include "Map/Ground.h"
#include "Game/Camera.h"
#include "Rendering/InMapDraw.h"


CStartPosSelecter* CStartPosSelecter::selector = NULL;


CStartPosSelecter::CStartPosSelecter(void) : CInputReceiver(BACK)
{
	showReady = true;
	startPosSet = false;
	selector = this;
	readyBox.x1 = 0.71f;
	readyBox.y1 = 0.72f;
	readyBox.x2 = 0.81f;
	readyBox.y2 = 0.76f;
}


CStartPosSelecter::~CStartPosSelecter(void)
{
	selector = NULL;
}


bool CStartPosSelecter::Ready()
{
	if (!startPosSet) // Player doesn't set startpos yet, so don't let him ready up
		return false;

	net->Send(CBaseNetProtocol::Get().SendStartPos(gu->myPlayerNum, gu->myTeam, 1, startPos.x, startPos.y, startPos.z));

	delete this;
	return true;
}


bool CStartPosSelecter::MousePress(int x, int y, int button)
{
	float mx = MouseX(x);
	float my = MouseY(y);
	if (showReady && InBox(mx, my, readyBox)) {
		return !Ready();
	}

	float dist=ground->LineGroundCol(camera->pos,camera->pos+mouse->dir*gu->viewRange*1.4f);
	if(dist<0)
		return true;

	startPosSet = true;
	inMapDrawer->SendErase(startPos);
	startPos = camera->pos + mouse->dir * dist;

	if(startPos.z<gameSetup->startRectTop[gu->myAllyTeam]*gs->mapy*8)
		startPos.z=gameSetup->startRectTop[gu->myAllyTeam]*gs->mapy*8;

	if(startPos.z>gameSetup->startRectBottom[gu->myAllyTeam]*gs->mapy*8)
		startPos.z=gameSetup->startRectBottom[gu->myAllyTeam]*gs->mapy*8;

	if(startPos.x<gameSetup->startRectLeft[gu->myAllyTeam]*gs->mapx*8)
		startPos.x=gameSetup->startRectLeft[gu->myAllyTeam]*gs->mapx*8;

	if(startPos.x>gameSetup->startRectRight[gu->myAllyTeam]*gs->mapx*8)
		startPos.x=gameSetup->startRectRight[gu->myAllyTeam]*gs->mapx*8;

	net->Send(CBaseNetProtocol::Get().SendStartPos(gu->myPlayerNum, gu->myTeam, 0, startPos.x, startPos.y, startPos.z));

	return true;
}

void CStartPosSelecter::Draw()
{
	if(gu->spectating){
		delete this;
		return;
	}

	glPushMatrix();
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glMatrixMode(GL_MODELVIEW);

	glColor4f(0.2f,0.8f,0.2f,0.5f);
	glDisable(GL_TEXTURE_2D);
	glEnable(GL_DEPTH_TEST);
	glBegin(GL_QUADS);
	float by=gameSetup->startRectTop[gu->myAllyTeam]*gs->mapy*8;
	float bx=gameSetup->startRectLeft[gu->myAllyTeam]*gs->mapx*8;

	float dy=(gameSetup->startRectBottom[gu->myAllyTeam]-gameSetup->startRectTop[gu->myAllyTeam])*gs->mapy*8/10;
	float dx=(gameSetup->startRectRight[gu->myAllyTeam]-gameSetup->startRectLeft[gu->myAllyTeam])*gs->mapx*8/10;

	for(int a=0;a<10;++a){	//draw start rect restrictions
		float3 pos1(bx+a*dx,0,by);
		pos1.y=ground->GetHeight(pos1.x,pos1.z);
		float3 pos2(bx+(a+1)*dx,0,by);
		pos2.y=ground->GetHeight(pos2.x,pos2.z);

		glVertexf3(pos1);
		glVertexf3(pos2);
		glVertexf3(pos2+UpVector*100);
		glVertexf3(pos1+UpVector*100);

		pos1=float3(bx+a*dx,0,by+dy*10);
		pos1.y=ground->GetHeight(pos1.x,pos1.z);
		pos2=float3(bx+(a+1)*dx,0,by+dy*10);
		pos2.y=ground->GetHeight(pos2.x,pos2.z);

		glVertexf3(pos1);
		glVertexf3(pos2);
		glVertexf3(pos2+UpVector*100);
		glVertexf3(pos1+UpVector*100);

		pos1=float3(bx,0,by+dy*a);
		pos1.y=ground->GetHeight(pos1.x,pos1.z);
		pos2=float3(bx,0,by+dy*(a+1));
		pos2.y=ground->GetHeight(pos2.x,pos2.z);

		glVertexf3(pos1);
		glVertexf3(pos2);
		glVertexf3(pos2+UpVector*100);
		glVertexf3(pos1+UpVector*100);

		pos1=float3(bx+dx*10,0,by+dy*a);
		pos1.y=ground->GetHeight(pos1.x,pos1.z);
		pos2=float3(bx+dx*10,0,by+dy*(a+1));
		pos2.y=ground->GetHeight(pos2.x,pos2.z);

		glVertexf3(pos1);
		glVertexf3(pos2);
		glVertexf3(pos2+UpVector*100);
		glVertexf3(pos1+UpVector*100);
	}
	glEnd();

	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
	glDisable(GL_DEPTH_TEST);

	float mx=float(mouse->lastx)/gu->viewSizeX;
	float my=(gu->viewSizeY-float(mouse->lasty))/gu->viewSizeY;

	glDisable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glDisable(GL_ALPHA_TEST);

	if (!showReady) {
		return;
	}

	if (InBox(mx, my, readyBox)) {
		glColor4f(0.7f, 0.2f, 0.2f, guiAlpha);
	} else {
		glColor4f(0.7f, 0.7f, 0.2f, guiAlpha);
	}
	DrawBox(readyBox);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	if (InBox(mx, my, readyBox)) {
		glColor4f(0.7f, 0.2f, 0.2f, guiAlpha);
	} else {
		glColor4f(0.7f, 0.7f, 0.2f, guiAlpha);
	}
	DrawBox(readyBox);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// fit text into box
	const float unitWidth = font->CalcTextWidth("Ready");
	const float unitHeight = font->GetHeight();

	const float ySize = (readyBox.y2 - readyBox.y1);
	const float xSize = (readyBox.x2 - readyBox.x1);

	const float fontScale = 0.9f * std::min(xSize/unitWidth, ySize/unitHeight);
	const float yPos = readyBox.y1 + (0.1f * ySize);
	const float xPos = 0.5f * (readyBox.x1 + readyBox.x2);

	const float white[4]  = { 1.0f, 1.0f, 1.0f, 1.0f };
	font->glPrintOutlinedCentered(xPos, yPos, fontScale, "Ready", white);
}
