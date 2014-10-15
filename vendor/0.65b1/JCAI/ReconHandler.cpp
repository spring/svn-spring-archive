//-------------------------------------------------------------------------
// JCAI version 0.20
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "BaseAIDef.h"

#include "GlobalAI.h"
#include "AI_Config.h"
#include "ReconHandler.h"
#include "BuildHandler.h"

using namespace boost;


// ----------------------------------------------------------------------------------------
// Recon config
// ----------------------------------------------------------------------------------------

bool ReconConfig::Load (CfgList *rootcfg)
{
	CfgList *rinfo = dynamic_cast<CfgList*> (rootcfg->GetValue ("reconinfo"));

	if (rinfo)
	{
		scouts = dynamic_cast<CfgBuildOptions*> (rinfo->GetValue ("scouts"));
		if (scouts)
		{
			if (!scouts->InitIDs ())
				return false;
		}

		updateInterval = rinfo->GetInt ("updateinterval", 4);
		maxForce = rinfo->GetInt ("maxforce", 5);

		CfgList* hcfg = dynamic_cast<CfgList*> (rinfo->GetValue ("SearchHeuristic"));
		if (hcfg)
		{
			searchHeuristic.DistanceFactor = hcfg->GetNumeric ("DistanceFactor");
			searchHeuristic.ThreatFactor = hcfg->GetNumeric ("ThreatFactor");
			searchHeuristic.TimeFactor = hcfg->GetNumeric ("TimeFactor");
			searchHeuristic.SpreadFactor = hcfg->GetNumeric ("SpreadFactor");
		}
		else {
			logPrintf ("Error: No search heuristic info in recon config node.\n");
			return false;
		}

		return true;
	}
	return false;
}

// ----------------------------------------------------------------------------------------
// Recon handling
// ----------------------------------------------------------------------------------------

ReconHandler::ReconHandler (MainAI *Ai) : TaskHandler (Ai)
{
	if (!config.Load (ai->sidecfg))
		throw "Failed to load recon info block";
}

ReconHandler::~ReconHandler()
{
	units.vec.clear();
}

ReconHandler::Unit::~Unit()
{
}

float inline SectorScore (int x,int y, const GameInfo& i,const int2& sp,ReconHandler* h, int frame, ReconHandler::Unit* unit)
{
	ScoutSectorHeuristic& cfg = h->config.searchHeuristic;

	float score = (frame - i.lastLosFrame) * cfg.TimeFactor; // older is better 
	score += i.losThreat * cfg.ThreatFactor; // higher threat is worse

	if (cfg.SpreadFactor!=0.0f)
	{
		int dis2 = 1<<30;
		for (int a=0;a<h->units.size();a++)
		{
			ReconHandler::Unit *u = h->units[a];
			if(u==unit || u->goal.x<0) continue;
			int dx = int(u->goal.x - x*h->ai->map.gblocksize) / 128;
			int dy = int(u->goal.y - y*h->ai->map.gblocksize) / 128;
			dx = dx*dx+dy*dy;
			if (dx < dis2) dis2 = dx;
		}
		dis2+=1;
		score -= 1.0f / sqrtf (dis2) * cfg.SpreadFactor;
	}

	int dx=x-sp.x,dy=y-sp.y;
	dx=dx*dx+dy*dy;
	return score + sqrtf (dx)*cfg.DistanceFactor; // longer distance is worse
}

void ReconHandler::Update ()
{
	if(ai->cb->GetCurrentFrame() % config.updateInterval != 1)
		return;

	// give the new order
	Command c;
	c.id = CMD_MOVE;

	c.params.push_back (0.0f);
	c.params.push_back (0.0f);
	c.params.push_back (0.0f);

	for (ptrvec<Unit>::iterator i=units.begin();i!=units.end();++i)
	{
		int2 pgoal=i->goal;

		// use the forces to scout sectors which have not been 
		float3 pos = ai->cb->GetUnitPos (i->id);
		// convert SectorScore(x,y,i,sp,frame) to HF(x,y,i) and use it in SelectGameInfoSector
		int2 ngoal = ai->map.SelectGameInfoSector (bind (SectorScore, _1,_2,_3,
				ai->map.GetGameInfoCoords(pos), this,ai->cb->GetCurrentFrame(),&*i));
		//int2 ngoal = ai->map.FindScoutSector (ai->cb, ai->map.GetGameInfoCoords (pos), config.searchHeuristic);
		if (ngoal.x >= 0)
		{
			i->goal.x = (ngoal.x + 0.5f) * ai->map.gblocksize;
			i->goal.y = (ngoal.y + 0.5f) * ai->map.gblocksize;
		}

		if (pgoal.x!=i->goal.x || pgoal.y!=i->goal.y)
		{
			c.params [0] = i->goal.x;
			c.params [2] = i->goal.y;

			ai->cb->GiveOrder (i->id, &c);
		}
	}
}

void ReconHandler::UnitDestroyed (aiUnit *unit)
{
	Unit* u = dynamic_cast <Unit*> (unit);
	assert(u);

	units.del (u);
}

void ReconHandler::UnitFinished (aiUnit *unit)
{
	Unit* u = dynamic_cast <Unit*> (unit);
	assert(u);

	units.add (u);
}

aiUnit* ReconHandler::CreateUnit (int id)
{
	aiUnit *u = new Unit;
	u->owner = this;
	return u;
}

BuildTask* ReconHandler::GetNewTask ()
{
	int counts[50];
	int a,total=0;

	if (!config.scouts || config.scouts->builds.empty () || units.size () >= config.maxForce)
		return 0;

	for (a=0;a<config.scouts->builds.size ();a++)
	{
		int def = config.scouts->builds [a]->def;
		counts[a]=0;
		for (ptrvec<Unit>::iterator f=units.begin();f!=units.end();++f)
			if( f->def->id == def ) counts[a] ++;
		total += counts[a];
	}

	int totalBuilds=config.scouts->TotalBuilds();
	for (a=0;a<config.scouts->builds.size();a++)
	{
		if (counts[a]*totalBuilds <= units.size())
			break;
	}

	// indecisive, so just pick the first
	if (a==config.scouts->builds.size())
		a=0;

	return new BuildTask (buildTable.GetDef (config.scouts->builds [a]->def), this);
}
