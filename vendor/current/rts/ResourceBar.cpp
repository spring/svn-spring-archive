#include "StdAfx.h"
#include ".\resourcebar.h"
#include "mousehandler.h"
#include "mygl.h"
#include "team.h"
#include "glfont.h"
#include "net.h"
//#include "mmgr.h"

extern CResourceBar* resourceBar=0;

CResourceBar::CResourceBar(void)
{
	box.x1 = 0.26f;
	box.y1 = 0.96f;
	box.x2 = 0.98f;
	box.y2 = 0.99f;

	metalBox.x1 = 0.09f;
	metalBox.y1 = 0.01f;
	metalBox.x2 = (box.x2-box.x1)/2.0-.03f;
	metalBox.y2 = 0.024f;

	energyBox.x1 = 0.45f;
	energyBox.y1 = 0.01f;
	energyBox.x2 = box.x2-0.03f-box.x1;
	energyBox.y2 = 0.024f;
}

CResourceBar::~CResourceBar(void)
{
}

static string FloatToSmallString(float num,float mul=1){
	char c[50];

	if(num==0)
		return "0";
	if(fabs(num)<10*mul){
		sprintf(c,"%.1f",num);
	} else if(fabs(num)<10000*mul){
		sprintf(c,"%.0f",num);
	} else if(fabs(num)<10000000*mul){
		sprintf(c,"%.0fk",num/1000);
	} else {
		sprintf(c,"%.0fM",num/1000000);
	}
	return c;
};

void CResourceBar::Draw(void)
{
	float mx=float(mouse->lastx)/gu->screenx;
	float my=(gu->screeny-float(mouse->lasty))/gu->screeny;

	GLfloat x1,y1,x2,y2,x;

	// Box
	glDisable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glDisable(GL_ALPHA_TEST);
	glColor4f(0.2f,0.2f,0.2f,0.4f);

	glBegin(GL_QUADS);
	glVertex2f(box.x1, box.y1);
	glVertex2f(box.x1, box.y2);
	glVertex2f(box.x2, box.y2);
	glVertex2f(box.x2, box.y1);
	glVertex2f(box.x1, box.y1);
	glEnd();

	//layout metal in box
	GLfloat metalx = box.x1+.01f;
	GLfloat metaly = box.y1+.002;

	GLfloat metalbarx1 = metalx+.08f;
	GLfloat metalbarx2 = box.x1+(box.x2-box.x1)/2.0-.03f;

	//metal layout
	GLfloat metalbarlen = metalbarx2-metalbarx1;
	x1=metalbarx1;
	y1=metaly+.014f;
	x2=metalbarx2;
	y2=metaly+.020f;
	x=(1.0*gs->teams[gu->myTeam]->metal/gs->teams[gu->myTeam]->metalStorage)*metalbarlen;
	
	glEnable(GL_TEXTURE_2D);
	glColor4f(1,1,1,0.8f);
	font->glPrintAt(metalx,metaly+.005f,0.7f,"");
	glDisable(GL_TEXTURE_2D);

	//metal draw
	glColor4f(0.8f,0.8f,0.8f,0.2f);
	glBegin(GL_QUADS);
	glVertex2f(x1, y1);
	glVertex2f(x1, y2);
	glVertex2f(x2, y2);
	glVertex2f(x2, y1);
	glEnd();

	glColor4f(1.0f,1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glVertex2f(x1, y1);
	glVertex2f(x1, y2);
	glVertex2f(x1+x, y2);
	glVertex2f(x1+x, y1);
	glEnd();

	x=gs->teams[gu->myTeam]->metalShare*metalbarlen;
	glColor4f(0.9f,0.2f,0.2f,0.7f);
	glBegin(GL_QUADS);
	glVertex2f(x1+x+0.003, y1-0.003);
	glVertex2f(x1+x+0.003, y2+0.003);
	glVertex2f(x1+x-0.003, y2+0.003);
	glVertex2f(x1+x-0.003, y1-0.003);
	glEnd();

	glEnable(GL_TEXTURE_2D);
	glColor4f(1,1,1,0.8f);
	
	font->glPrintAt(metalx-0.004,metaly+.005f,0.7f,"Metal");

	font->glPrintAt(metalbarx2-.01f,metaly,0.5,"%s",FloatToSmallString(gs->teams[gu->myTeam]->metalStorage).c_str());
	font->glPrintAt(metalbarx1+metalbarlen/2.0,metaly/*+.02f*/,0.5,"%s",FloatToSmallString(gs->teams[gu->myTeam]->metal).c_str());

	glColor4f(1.0f,.4f,.4f,1.0f); // Expenses
	font->glPrintAt(metalx+.044f,metaly-0.002f,0.5,"-%s(-%s)",FloatToSmallString(fabs(gs->teams[gu->myTeam]->oldMetalExpense)).c_str(),FloatToSmallString(fabs(gs->teams[gu->myTeam]->oldMetalUpkeep)).c_str());

	glColor4f(.6f,1.0f,.6f,.95f); // Income
	font->glPrintAt(metalx+.044f,metaly+.01f,0.5,"+%s",FloatToSmallString(gs->teams[gu->myTeam]->oldMetalIncome).c_str());

	// Energy
	glDisable(GL_TEXTURE_2D);

	//layout energy in box
	GLfloat energyx = box.x1+0.37f;
	GLfloat energyy = box.y1+0.002;

	GLfloat energybarx1 = energyx+.08f;
	GLfloat energybarx2 = box.x2-0.03f;

	//energy layout
	GLfloat energybarlen = energybarx2-energybarx1;
	x1=energybarx1;
	y1=energyy+.014f;
	x2=energybarx2;
	y2=energyy+.020f;
	x=(1.0*gs->teams[gu->myTeam]->energy/gs->teams[gu->myTeam]->energyStorage)*energybarlen;
	
	glEnable(GL_TEXTURE_2D);
	glColor4f(1,1,1,0.8f);
	font->glPrintAt(energyx,energyy+.005f,0.7f,"");
	glDisable(GL_TEXTURE_2D);

	//energy draw
	glColor4f(0.8f,0.8f,0.2f,0.2f);
	glBegin(GL_QUADS);
	glVertex2f(x1, y1);
	glVertex2f(x1, y2);
	glVertex2f(x2, y2);
	glVertex2f(x2, y1);
	glEnd();

	glColor4f(1.0f,1.0f,0.2f,1.0f);
	glBegin(GL_QUADS);
	glVertex2f(x1, y1);
	glVertex2f(x1, y2);
	glVertex2f(x1+x, y2);
	glVertex2f(x1+x, y1);
	glEnd();

	x=gs->teams[gu->myTeam]->energyShare*energybarlen;
	glColor4f(0.9f,0.2f,0.2f,0.7f);
	glBegin(GL_QUADS);
	glVertex2f(x1+x+0.003, y1-0.003);
	glVertex2f(x1+x+0.003, y2+0.003);
	glVertex2f(x1+x-0.003, y2+0.003);
	glVertex2f(x1+x-0.003, y1-0.003);
	glEnd();

	glEnable(GL_TEXTURE_2D);
	glColor4f(1,1,0.4,0.8f);
	
	font->glPrintAt(energyx-0.018,energyy+.005f,0.7f,"Energy");

	glColor4f(1,1,1,0.8f);
	font->glPrintAt(energybarx2-.01f,energyy,0.5,"%s",FloatToSmallString(gs->teams[gu->myTeam]->energyStorage).c_str());
	font->glPrintAt(energybarx1+energybarlen/2.0,energyy/*+.02f*/,0.5,"%s",FloatToSmallString(gs->teams[gu->myTeam]->energy).c_str());

	glColor4f(1.0f,.4f,.4f,1.0f); // Expenses
	font->glPrintAt(energyx+.044f,energyy-0.002f,0.5,"-%s(-%s)",FloatToSmallString(fabs(gs->teams[gu->myTeam]->oldEnergyExpense)).c_str(),FloatToSmallString(fabs(gs->teams[gu->myTeam]->oldEnergyUpkeep)).c_str());

	glColor4f(.6f,1.0f,.6f,.95f); // Income
	font->glPrintAt(energyx+.044f,energyy+.01f,0.5,"+%s",FloatToSmallString(gs->teams[gu->myTeam]->oldEnergyIncome).c_str());

	glDisable(GL_TEXTURE_2D);

	glLoadIdentity();
}

bool CResourceBar::IsAbove(int x, int y)
{
	float mx=float(x)/gu->screenx;
	float my=(gu->screeny-float(y))/gu->screeny;
	if(InBox(mx,my,box))
		return true;
	return false;
}

std::string CResourceBar::GetTooltip(int x, int y)
{
	float mx=float(x)/gu->screenx;
	float my=(gu->screeny-float(y))/gu->screeny;

	if(mx<box.x1+0.36)
		return "Shows your stored metal as well as\nincome(green) and expidentures (red)\nClick in the bar to select your\nauto share level";

	return "Shows your stored energy as well as\nincome(green) and expidentures (red)\nClick in the bar to select your\nauto share level";

	return "";
}

bool CResourceBar::MousePress(int x, int y, int button)
{
	float mx=float(x)/gu->screenx;
	float my=(gu->screeny-float(y))/gu->screeny;
	if(InBox(mx,my,box)){
		moveBox=true;
		if(!gu->spectating){
			if(InBox(mx,my,box+metalBox)){
				moveBox=false;
				float metalShare=max(0,min(1,(mx-(box.x1+metalBox.x1))/(metalBox.x2-metalBox.x1)));
				netbuf[0]=NETMSG_SETSHARE;
				netbuf[1]=gu->myTeam;
				*(float*)&netbuf[2]=metalShare;
				*(float*)&netbuf[6]=gs->teams[gu->myTeam]->energyShare;
				net->SendData(netbuf,10);
			}
			if(InBox(mx,my,box+energyBox)){
				moveBox=false;
				float energyShare=max(0,min(1,(mx-(box.x1+energyBox.x1))/(energyBox.x2-energyBox.x1)));
				netbuf[0]=NETMSG_SETSHARE;
				netbuf[1]=gu->myTeam;
				*(float*)&netbuf[2]=gs->teams[gu->myTeam]->metalShare;
				*(float*)&netbuf[6]=energyShare;
				net->SendData(netbuf,10);
			}
		}
		return true;
	}
	return false;
}

void CResourceBar::MouseMove(int x, int y, int dx,int dy, int button)
{
	if(moveBox){
		box.x1+=float(dx)/gu->screenx;
		box.x2+=float(dx)/gu->screenx;
		box.y1-=float(dy)/gu->screeny;
		box.y2-=float(dy)/gu->screeny;
	}
}
