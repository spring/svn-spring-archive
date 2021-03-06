#include "stdafx.h"
#include ".\spawnscript.h"
#include <fstream>
#include "sunparser.h"
#include "unitloader.h"
#include "unit.h"
#include "unithandler.h"
#include "team.h"
#include <set>
#include "command.h"
#include "commandai.h"
//#include "mmgr.h"

static CSpawnScript sps;
extern std::string stupidGlobalMapname;

CSpawnScript::CSpawnScript(void)
: CScript(std::string("Random enemies"))
{
	frameOffset=0;
}

CSpawnScript::~CSpawnScript(void)
{
}

void CSpawnScript::Update(void)
{
	switch(gs->frameNum){
	case 0:
		LoadSpawns();

		CSunParser p;
		p.LoadFile("gamedata\\sidedata.tdf");
		string s0=p.SGetValueDef("armcom","side0\\commander");
		string s1=p.SGetValueDef("corcom","side1\\commander");

		CSunParser p2;
		p2.LoadFile(string("maps\\")+stupidGlobalMapname.substr(0,stupidGlobalMapname.find('.'))+".smd");

		float x0,z0;
		p2.GetDef(x0,"1000","MAP\\TEAM0\\StartPosX");
		p2.GetDef(z0,"1000","MAP\\TEAM0\\StartPosZ");

		unitLoader.LoadUnit(s0,float3(x0,80,z0),0,false);

		p2.GetDef(x0,"1000","MAP\\TEAM1\\StartPosX");
		p2.GetDef(z0,"1000","MAP\\TEAM1\\StartPosZ");		
		spawnPos.push_back(float3(x0,80,z0));

		p2.GetDef(x0,"1000","MAP\\TEAM2\\StartPosX");
		p2.GetDef(z0,"1000","MAP\\TEAM2\\StartPosZ");		
		spawnPos.push_back(float3(x0,80,z0));

		p2.GetDef(x0,"1000","MAP\\TEAM3\\StartPosX");
		p2.GetDef(z0,"1000","MAP\\TEAM3\\StartPosZ");		
		spawnPos.push_back(float3(x0,80,z0));
	}

	if(!spawns.empty()){
		while(curSpawn->frame+frameOffset<gs->frameNum){
			int num=spawnPos.size()*0.99*gs->randFloat();

			CUnit* u=unitLoader.LoadUnit(curSpawn->name,spawnPos[num]+gs->randVector()*200,1,false);

			Unit unit;
			unit.id=u->id;
			unit.target=-1;
			myUnits.push_back(unit);
			if(myUnits.size()==1)
				curUnit=myUnits.begin();

			++curSpawn;
			if(curSpawn==spawns.end()){
				curSpawn=spawns.begin();
				frameOffset+=spawns.back().frame;
			}
		}
	}
	
	if(!myUnits.empty() && !gs->teams[0]->units.empty()){
		if(uh->units[curUnit->id]){
			if(curUnit->target<0 || uh->units[curUnit->target]==0){
				int num=gs->randFloat()*0.99*gs->teams[0]->units.size();
				std::set<CUnit*>::iterator tu=gs->teams[0]->units.begin();
				for(int a=0;a<num;++a)
					++tu;
				curUnit->target=(*tu)->id;
				curUnit->lastTargetPos.x=-500;
			}
			float3 pos=uh->units[curUnit->target]->pos;
			if(pos.distance2D(curUnit->lastTargetPos)>100){
				curUnit->lastTargetPos=pos;
				Command c;
				c.id=CMD_PATROL;
				c.options=0;
				c.params.push_back(pos.x);
				c.params.push_back(pos.y);
				c.params.push_back(pos.z);
				uh->units[curUnit->id]->commandAI->GiveCommand(c);
			}
			curUnit++;
		} else {
			curUnit=myUnits.erase(curUnit);
		}
		if(curUnit==myUnits.end())
			curUnit=myUnits.begin();
	}
}

void CSpawnScript::LoadSpawns(void)
{
	CFileHandler file("spawn.txt");

	while(file.FileExists() && !file.Eof()){

		Spawn s;
		s.frame=atof(LoadToken(file).c_str());
		s.name=LoadToken(file).c_str();

		if(s.name.empty())
			break;

		spawns.push_back(s);
	}
	curSpawn=spawns.begin();
}

std::string CSpawnScript::LoadToken(CFileHandler& file)
{
	string s;
	char c;

	while (!file.Eof()) {
		file.Read(&c,1);
		if(c>='0' && c<='z')
			break;
	}

	while (!file.Eof()) {
		if(c<'0' || c>'z')
			return s;
		s+=c;
		file.Read(&c,1);
	}
	return s;
}
