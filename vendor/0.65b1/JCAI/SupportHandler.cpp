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
#include "SupportHandler.h"

//-------------------------------------------------------------------------
// Support Handler Config
//-------------------------------------------------------------------------

struct UnitDefProperty
{
	const char *name;
	float UnitDef::*fptr;
	int UnitDef::*iptr;
}
static UDefPropertyList [] =
{
	{ "radar", 0, &UnitDef::radarRadius },
	{ "los", &UnitDef::losRadius },
	{ "airlos", &UnitDef::airLosRadius },
	{ "control", &UnitDef::controlRadius },
	{ "jammer", 0, &UnitDef::jammerRadius },
	{ "sonar", 0, &UnitDef::sonarRadius },
	{ 0 }
};

void SupportConfig::MapUDefProperties (CfgBuildOptions *c, vector<UnitDefProperty>& props)
{
	props.resize (c->builds.size());

	for (int a=0;a<c->builds.size();a++)
	{
		CfgBuildOptions::BuildOpt *opt = c->builds [a];

		if (opt->info)
		{
			const char *coverprop = opt->info->GetLiteral ("coverproperty");
			if (coverprop)
			{
				for (int b=0;UDefPropertyList[b].name;a++) 
					if (!stricmp (UDefPropertyList[b].name, coverprop))
					{
						props[a].isFloat = UDefPropertyList[b].fptr != 0;
						if (props[a].isFloat) props[a].fptr = UDefPropertyList[b].fptr;
						else props[a].iptr = UDefPropertyList[b].iptr;
						break;
					}
			}
		}
	}
}

bool SupportConfig::Load (CfgList *sidecfg)
{
	CfgList *scfg = dynamic_cast <CfgList*> (sidecfg->GetValue ("supportinfo"));

	if (scfg)
	{
		basecover = dynamic_cast<CfgBuildOptions*> (scfg->GetValue ("basecover"));
		mapcover = dynamic_cast<CfgBuildOptions*> (scfg->GetValue ("mapcover"));

		if (basecover) 
		{
			MapUDefProperties (basecover, basecoverProps);

			if (!basecover->InitIDs ())
				return false;
		}
		if (mapcover)
		{
			MapUDefProperties (mapcover, mapcoverProps);
			
			if (!mapcover->InitIDs ())
				return false;
		}
	}

	return true;
}

//-------------------------------------------------------------------------
// Support Handler
//-------------------------------------------------------------------------

SupportHandler::SupportHandler (MainAI *AI) : TaskHandler (AI)
{
	if (!config.Load (ai->sidecfg))
		throw "Failed to load support handler config";
}

void SupportHandler::Update ()
{
}

void SupportHandler::UnitDestroyed (aiUnit *unit)
{
}

void SupportHandler::UnitFinished (aiUnit *unit)
{
}

aiUnit* SupportHandler::CreateUnit (int id)
{
	return 0;
}

BuildTask* SupportHandler::GetNewTask ()
{
	return 0;
}

