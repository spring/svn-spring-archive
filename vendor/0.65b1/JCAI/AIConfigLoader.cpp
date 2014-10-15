//-------------------------------------------------------------------------
// JCAI version 0.20
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "BaseAIDef.h"
#include "CfgParser.h"
#include "GlobalAI.h"
#include "AI_Config.h"
#include "ForceHandler.h"
#include "ReconHandler.h"

AIConfig aiConfig;

//-------------------------------------------------------------------------
// Build options config
//-------------------------------------------------------------------------
CfgBuildOptionsType cfg_BuildOptionsType;

int CfgBuildOptions::TotalBuilds ()
{
	int count=0;
	for (vector <BuildOpt*>::iterator t=builds.begin();t!=builds.end();++t)
		count+=(*t)->count;
	return count;
}

void CfgBuildOptions::dbgPrint(int depth)
{
	if (depth) 
		logPrintf ("build option list of %d elements\n", builds.size());

	for (int i=0;i<builds.size();i++)
	{
		for (int a=0;a<depth;a++) 
			logPrintf ("  ");

		logPrintf ("Build option(%d): %s * %d", i, builds[i]->name.c_str(), builds[i]->count);
		if (builds[i]->info) {
			logPrintf ("Extra info = ");
			builds[i]->info->dbgPrint (depth+1);
		} else
			logPrintf ("\n");
	}
}

bool CfgBuildOptions::Parse (CfgBuffer& buf)
{
	if (!SkipKeyword (buf, "buildoptions"))
		return false;

	if (SkipWhitespace (buf) || *buf != '{') 
	{
		Expecting (buf, "token {");
		return false;
	}

	++buf;

	while (!SkipWhitespace (buf))
	{
		BuildOpt *opt = new BuildOpt;

		if (*buf == '}')
		{
			++buf;
			break;
		}

		if (!ParseIdent (buf, opt->name))
		{
			delete opt;
			return false;
		}

		builds.push_back (opt);

		opt->count = 1;

		while (!SkipWhitespace (buf))
		{
			if (*buf == '*') // its a multiplier
			{
				++buf;

				CfgNumeric val;
				if (!val.Parse (buf))
					return false;

				opt->count = val.value;
			}
			else if (*buf == '{') // its a set of conditions
			{
				opt->info = new CfgList;

				if (!opt->info->Parse (buf))
					return false;
			}
			else break;
		}
	}

	return true;
}

bool CfgBuildOptions::InitIDs ()
{
	for (int a=0;a<builds.size();a++)
	{
		builds[a]->def = buildTable.GetDefID (builds[a]->name.c_str());

		if (!builds[a]->def) 
		{
			logPrintf ("UnitDef %s not found: Wrong name or modcache outdated.\n", builds[a]->name.c_str());
			return false;
		}
	}

	return true;
}

// ----------------------------------------------------------------------------------------
// AI Config
// ----------------------------------------------------------------------------------------

AIConfig::AIConfig () : 
	infoblocksize(0), defmindist(2), factorymindist(6),
	safeSectorRadius (0), mexSectorRadius(0), builderMoveTimeout(0)
{}

AIConfig::~AIConfig ()
{}


bool AIConfig::Load (CfgList *root)
{
	CfgList *info; // info node

	info = dynamic_cast<CfgList*> (root->GetValue ("info"));

	if (info) 
	{
		infoblocksize=info->GetInt ("infoblocksize", -1);

		if (infoblocksize < 8)
		{
			logPrintf ("AIConfig: invalid infoblocksize: %d\n", infoblocksize);
			return false;
		}

		defmindist = info->GetInt ("defaultmindist", 2);
		factorymindist = info->GetInt ("factorymindist", 6);
		debug = info->GetInt ("debug",0)!=0;
		showDebugWindow = info->GetInt ("showdebugwindow",0) != 0;
		showMetalSpots=info->GetInt ("showmetalspots", 0)!=0;
		safeSectorRadius = info->GetInt ("safesectorradius", 15);
		mexSectorRadius = info->GetInt ("mexsectorradius", 15);
		cacheBuildTable = !!info->GetInt ("cachebuildtable", 1);
		builderMoveTimeout = info->GetInt ("buildermovetimeout", 200);
		builderMoveMinDistance = info->GetNumeric("buildermovemindistance", 100);
		threatDecay = info->GetNumeric ("threatdecay", 0.1f);
	}
	else {
		logPrintf ("No info node found\n");
		return false;
	}

	return true;
}


bool AIConfig::LoadUnitTypeInfo (CfgList *root, BuildTable *tbl)
{
	CfgList *sideinfo = dynamic_cast <CfgList*> (root->GetValue ("sideinfo"));

	if (!sideinfo)
	{
		logPrintf ("No sideinfo node found in config file\n");
		return false;
	}

	CfgList *l = dynamic_cast <CfgList*> (sideinfo->GetValue ("aadefense"));

	for (list<CfgListElem>::iterator i=l->childs.begin();i!=l->childs.end();++i)
	{
		UnitDefID id = tbl->GetDefID (i->name.c_str());
		if (id)
		{
			unitTypesInfo.aadefense.push_back (id);
			BuildTable::UDef* cd = tbl->GetCachedDef (id);
			cd->flags |= CUD_AADefense;
		}
	}

	l = dynamic_cast <CfgList*> (sideinfo->GetValue ("gddefense"));

	for (list<CfgListElem>::iterator i=l->childs.begin();i!=l->childs.end();++i)
	{
		UnitDefID id = tbl->GetDefID (i->name.c_str());
		if (id) {
			unitTypesInfo.gddefense.push_back (id);
			BuildTable::UDef* cd = tbl->GetCachedDef (id);
			cd->flags |= CUD_GroundDefense;
		}
	}

	return true;
}
