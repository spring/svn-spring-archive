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
#include "CfgParser.h"
#include "ResourceUnitHandler.h"
#include "BuildHandler.h"
#include "AI_Config.h"

void RUHandlerConfig::EnergyBuildHeuristicConfig::Load (CfgList *c)
{
	BuildTime = c->GetNumeric ("BuildTime");
	EnergyCost = c->GetNumeric ("EnergyCost");
	MetalCost = c->GetNumeric ("MetalCost");
	MaxUpscale = c->GetNumeric ("MaxUpscale", 1.8f);
}

void RUHandlerConfig::MetalBuildHeuristicConfig::Load (CfgList *c)
{
	PaybackTimeFactor = c->GetNumeric ("PaybackTimeFactor");
	EnergyUsageFactor = c->GetNumeric ("EnergyUsageFactor");
	ThreatConversionFactor = c->GetNumeric ("ThreatConversionFactor");
	PrefUpscale = c->GetNumeric ("PrefUpscale", 2);
	UpscaleOvershootFactor = c->GetNumeric ("UpscaleOvershootFactor", -50);
}

static bool ParseDefList (CfgValue *val, vector<UnitDefID>& v, BuildTable* tbl)
{
	CfgList *l = dynamic_cast <CfgList *> (val);

	if (l) {
		for (list<CfgListElem>::iterator i=l->childs.begin();i!=l->childs.end();++i)
		{
			UnitDefID id = tbl->GetDefID (i->name.c_str());
			if (id) v.push_back (id);
			else return false;
		}
	} else {
		CfgLiteral *s = dynamic_cast <CfgLiteral *> (val);

		UnitDefID id = tbl->GetDefID (s->value.c_str());
		if (id) v.push_back (id);
		else return false;
	}

	return true;
}

bool RUHandlerConfig::Load (CfgList *sidecfg)
{
	CfgList *c = dynamic_cast<CfgList*>(sidecfg->GetValue ("ResourceInfo"));
	BuildTable *tbl = &buildTable;

	if (c)
	{
		EnergyBuildRatio = c->GetNumeric ("EnergyBuildRatio", 1.4);
		MetalBuildRatio = c->GetNumeric ("MetalBuildRatio", 0.8);

		CfgList *ebh = dynamic_cast<CfgList*>(c->GetValue ("EnergyBuildHeuristic"));
		if (ebh)
			EnergyHeuristic.Load (ebh);

		CfgList *mbh = dynamic_cast<CfgList*>(c->GetValue ("MetalBuildHeuristic"));
		if (mbh)
			MetalHeuristic.Load (mbh);

		if (!ParseDefList (c->GetValue ("EnergyMakers"), EnergyMakers, tbl))
			return false;

		if (!ParseDefList (c->GetValue ("MetalMakers"), MetalMakers, tbl))
			return false;

		if (!ParseDefList (c->GetValue ("MetalExtracters"), MetalExtracters, tbl))
			return false;

		// Read storage config
		CfgList *st = dynamic_cast<CfgList*>(c->GetValue("Storage"));
		if (st)
		{
			if (!ParseDefList (st->GetValue ("MetalStorage"), StorageConfig.MetalStorage, tbl))
				return false;
			if (StorageConfig.MetalStorage.empty ()) {
				logPrintf ("Error: No metal storage unit type given");
				return false;
			}
			if (!ParseDefList (st->GetValue ("EnergyStorage"), StorageConfig.EnergyStorage, tbl))
				return false;
			if (StorageConfig.EnergyStorage.empty ()) {
				logPrintf ("Error: No energy storage unit type given");
				return false;
			}
		
			StorageConfig.MaxRatio = st->GetNumeric ("MaxRatio", 0.9);
			StorageConfig.MinEnergyIncome = st->GetNumeric ("MinEnergyIncome", 60);
			StorageConfig.MinMetalIncome = st->GetNumeric ("MinMetalIncome", 5);
			StorageConfig.MaxEnergyFactor = st->GetNumeric ("MaxEnergyStorageFactor", 20);
			StorageConfig.MaxMetalFactor = st->GetNumeric ("MaxMetalStorageFactor", 20);
		}

		CfgList *ep = dynamic_cast<CfgList*>(c->GetValue("EnablePolicy"));
		if (ep)
		{
			EnablePolicy.MaxEnergy = ep->GetNumeric ("MaxEnergy");
			EnablePolicy.MinEnergy = ep->GetNumeric ("MinEnergy");
			EnablePolicy.MinUnitEnergyUsage = ep->GetNumeric ("MinUnitEnergyUsage");
		}

		InitialBuildOrders = dynamic_cast<CfgBuildOptions*>(c->GetValue ("InitialBuildOrders"));
		if (InitialBuildOrders && !InitialBuildOrders->InitIDs ())
			return false;
	}
	else {
		logPrintf ("Error: No list node named \'ResourceInfo\' was found.\n");
		return false;
	}

	return true;
}

ResourceUnitHandler::ResourceUnitHandler(MainAI *AI) : TaskHandler (AI)
{
	if (!config.Load (ai->sidecfg))
		throw "Failed to load resource config";

	lastEnergy = 0.0f;
	lastUpdate = 0;
}

BuildTask* ResourceUnitHandler::CreateMetalExtractorTask (const UnitDef* def)
{
	return new BuildTask (def, this);
}

BuildTask* ResourceUnitHandler::CreateStorageTask (UnitDefID id)
{
	const UnitDef* def = buildTable.GetDef (id);

	// See if this storage task is already being made
	for (int a=0;a<activeTasks.size();a++)
	{
		if (activeTasks[a]->def == def)
			return 0;
	}

	return new BuildTask (def, this);
}

BuildTask *ResourceUnitHandler::GetNewTask ()
{
	// task for metal or energy?
	BuildHandler *bhd = ai->buildHandler;
	BuildTable *tbl = &buildTable;
	ResourceInfo bM = bhd->buildMultiplier;

    // initial build orders completed?
	if (config.InitialBuildOrders)
	{
		for (int a=0;a<config.InitialBuildOrders->builds.size();a++)
		{
			int count = 0;
			CfgBuildOptions::BuildOpt* type = config.InitialBuildOrders->builds [a];

			for (int b=0;b<units.size();b++)
			{
				if (units [b]->def->id == type->def)
					count ++;
			}

			if (count + bhd->currentUnitBuilds[type->def-1] < type->count)
			{
				const UnitDef* def = buildTable.GetDef (type->def);
				if (def->extractsMetal) return CreateMetalExtractorTask (def);
				else return new BuildTask (def, this);
			}
		}
	}

	IAICallback *cb = ai->cb;

	// check if storage has to be build
	if (cb->GetMetal () > cb->GetMetalStorage () * config.StorageConfig.MaxRatio &&
		cb->GetMetalStorage() <= bhd->averageProd.metal * config.StorageConfig.MaxMetalFactor)
	{
		BuildTask *t = CreateStorageTask (config.StorageConfig.MetalStorage.front());
		if (t) return t;
	}

	if (cb->GetEnergy () > cb->GetEnergyStorage () * config.StorageConfig.MaxRatio &&
		cb->GetEnergyStorage() <= bhd->averageProd.energy * config.StorageConfig.MaxEnergyFactor)
	{
		BuildTask *t = CreateStorageTask (config.StorageConfig.EnergyStorage.front());
		if (t) return t;
	}

	//if (bM.energy / config.EnergyBuildRatio < bM.metal / config.MetalBuildRatio)
	if (bM.energy * config.MetalBuildRatio < bM.metal * config.EnergyBuildRatio)
	{
		// pick an energy producing unit to build

        // find the unit type that has the highest energyMake/ResourceValue(buildcost) ratio and
		// does not  with MaxResourceUpscale

		int best = -1;
		float bestRatio;
		float minWind = ai->cb->GetMinWind ();
		float maxWind = ai->cb->GetMaxWind ();

		for (int a=0;a<config.EnergyMakers.size();a++)
		{
			BuildTable::UDef*d = tbl->GetCachedDef (config.EnergyMakers[a]);

			if (bhd->averageProd.energy + d->make.energy > config.EnergyHeuristic.MaxUpscale * bhd->averageProd.energy)
				continue;

			// calculate costs based on the heuristic parameters
			float cost = 
				d->buildTime * config.EnergyHeuristic.BuildTime +
				d->cost.metal * config.EnergyHeuristic.MetalCost +
				d->cost.energy * config.EnergyHeuristic.EnergyCost;

			float energyProduction = d->make.energy;

			if (d->flags & CUD_WindGen)
				energyProduction += 0.5f * (minWind + maxWind);

			float ratio = energyProduction / cost;

			if (best < 0 || ratio > bestRatio)
			{
				best = config.EnergyMakers[a];
				bestRatio = ratio;
			}
		}

		if (best >= 0)
		{
			return new BuildTask (tbl->GetDef (best), this);
		}
	}
	else
	{
		// pick a metal producing unit to build
		float3 st (ai->map.baseCenter.x, 0.0f, ai->map.baseCenter.y);
		int2 msect = ai->metalmap.GetEmptySpot (st, &ai->map, false);

		MetalSpotInfo *info=0;
		int best=0;
		float bestScore;

		if (msect.x >= 0)
		{
			info = ai->metalmap.Get (msect.x,msect.y);
			assert (!info->taken);

			// get threat info
			GameInfo *gi = ai->map.GetGameInfoFromMapSquare (info->spotpos.x, info->spotpos.y);

			// sector has been found, now calculate the best suitable metal extractor
			for (int a=0;a<config.MetalExtracters.size();a++)
			{
				BuildTable::UDef *d = tbl->GetCachedDef (config.MetalExtracters[a]);

		/*		PaybackTime = (MetalCost + MetalSpotThreatValue * ThreatConversionFactor) / MetalMake
				score = PaybackTimeFactor * PaybackTime + 
					(EnergyIncome - EnergyUsage - ResourceUnitUsage) * ExcessEnergyFactor*/

				float metalMake = info->metalProduction * d->metalExtractDepth;

				float PaybackTime = d->cost.metal + gi->threat * config.MetalHeuristic.ThreatConversionFactor;
				PaybackTime /= metalMake;

				float score = config.MetalHeuristic.PaybackTimeFactor * PaybackTime + 
					d->energyUse * config.MetalHeuristic.EnergyUsageFactor;

				float upscale = 1.0f + metalMake / (1.0f + bhd->averageProd.metal);

				if (upscale > config.MetalHeuristic.PrefUpscale)
					score += config.MetalHeuristic.UpscaleOvershootFactor * (upscale - config.MetalHeuristic.PrefUpscale);

				if (!best || bestScore < score)
				{
					bestScore = score;
					best = config.MetalExtracters[a];
				}
			}
		}

		// compare the best extractor with the metal makers
		for (int a=0;a<config.MetalMakers.size();a++)
		{
			BuildTable::UDef *d = tbl->GetCachedDef (config.MetalMakers[a]);

			const UnitDef* def = tbl->GetDef (config.MetalMakers[a]);

			float PaybackTime = d->cost.metal / d->make.metal;
			float score = config.MetalHeuristic.PaybackTimeFactor * PaybackTime + 
				d->energyUse * config.MetalHeuristic.EnergyUsageFactor;

			// calculate upscale and use it in the score
			float upscale = 1.0f + d->make.metal / bhd->averageProd.metal;

			if (upscale > config.MetalHeuristic.PrefUpscale)
				score += config.MetalHeuristic.UpscaleOvershootFactor * (upscale - config.MetalHeuristic.PrefUpscale);

			if (!best || bestScore < score)
			{
				bestScore = score;
				best = config.MetalMakers[a];
			}
		}

		if (best)
		{
			const UnitDef *def = tbl->GetDef (best);
			BuildTask *task = new BuildTask (def, this);
			assert(!def->extractsMetal || info);
			return task;
		}
	}

	return 0;
}

aiUnit* ResourceUnitHandler::CreateUnit (int id)
{
	const UnitDef *d = ai->cb->GetUnitDef (id);
	ResourceUnit *u;

	if (d->extractsMetal > 0.0f) {
		ExtractorUnit *ex = new ExtractorUnit;
		float3 pos = ai->cb->GetUnitPos (id);

		ex->mexSpot = ai->metalmap.GetFrom3D (pos);
		u=ex;
	}else
		u = new ResourceUnit;

	u->id = id;
	u->def = d;

	return u;
}


void ResourceUnitHandler::UnitFinished (aiUnit *unit)
{
	ResourceUnit* ru = dynamic_cast<ResourceUnit*>(unit);

	assert (ru);
	units.add (ru);
}

void ResourceUnitHandler::UnitDestroyed (aiUnit *unit)
{
	ResourceUnit* ru = dynamic_cast<ResourceUnit*>(unit);
	assert(ru);

	if (ru->def->extractsMetal > 0.0f)
	{
		ExtractorUnit *ex = (ExtractorUnit *)ru;
		if (ex->mexSpot.x >= 0)
			ai->metalmap.MarkSpot ( ex->mexSpot, false );
	}

	units.del(ru);
}

const char* ResourceUnitHandler::GetName ()
{
	return "ResourceUnitHandler";
}

void ResourceUnitHandler::Update()
{
	int frameNum=ai->cb->GetCurrentFrame();

	if (lastUpdate <= frameNum - 32)
	{
		lastUpdate=frameNum;

		Command c;
		c.params.resize(1);
		c.id=CMD_ONOFF;

		float energy=ai->cb->GetEnergy();
		float estore=ai->cb->GetEnergyStorage();
		float dif=energy-lastEnergy;
		lastEnergy=energy;

		//how much energy we need to save to turn positive
		if(energy<estore*config.EnablePolicy.MinEnergy)
		{
			float needed=-dif+5;
			for (int a=0;a<units.size();a++) {
				if(needed<0)
					break;

				ResourceUnit *u = units[a];
				if (u->def->isMetalMaker || u->def->extractsMetal)
				{
					if(u->def->energyUpkeep < config.EnablePolicy.MinUnitEnergyUsage)
						continue;

					if(u->turnedOn)
					{
						needed-=u->def->energyUpkeep;
						c.id=CMD_ONOFF;
						c.params[0] = 0;
						ai->cb->GiveOrder(u->id,&c);
						u->turnedOn=false;
					}
				}
			}
		} 
		else if(energy>estore*config.EnablePolicy.MaxEnergy)
		{
			float needed=dif+5;		//how much energy we need to start using to turn negative
			for(int a=0;a<units.size();a++) {
				if(needed<0)
					break;
				ResourceUnit *u=units[a];
				if (u->def->isMetalMaker || u->def->extractsMetal)
				{
					if(u->def->energyUpkeep < config.EnablePolicy.MinUnitEnergyUsage)
						continue;
					if (!u->turnedOn)
					{
						needed-=u->def->energyUpkeep;
						c.params[0]=1;
						ai->cb->GiveOrder(u->id,&c);
						u->turnedOn=true;
					}
				}
			}
		}
	}
}

