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
#include "IAICheats.h"

#include "AI_Config.h"
#include "BuildHandler.h"
// TaskHandlers!
#include "ForceHandler.h"
#include "ResourceUnitHandler.h"
#include "SupportHandler.h"
#include "ReconHandler.h"

#include "DebugWindow.h"

#include <stdarg.h>
#include <time.h> 
#ifdef _MSC_VER
#include <windows.h> // for OutputDebugString
#endif

CfgList* rootcfg = 0;

// ----------------------------------------------------------------------------------------
// Logfile output
// ----------------------------------------------------------------------------------------


const char *LogFileName = AI_PATH "testai.log";

void logFileOpen ()
{
	remove (LogFileName);

	time_t tval;
	char buf[128];

	/* Get current date and time */
	tval = time(NULL);
	tm* now = localtime(&tval);
	strftime(buf,sizeof(buf),"Log started on: %A, %B %d, day %j of %Y.\nThe time is %I:%M %p.\n",now);

	logPrintf (buf);
}

void logFileClose ()
{}

void logPrintf (const char *fmt, ...)
{
	static char buf[256];
	va_list vl;
	va_start (vl, fmt);
#ifdef _MSC_VER
	_vsnprintf (buf, sizeof(buf), fmt, vl);
#else
	vsnprintf (buf, sizeof(buf), fmt, vl);
#endif

	FILE *file = fopen (LogFileName, "a");
	if (file)
	{
		fputs (buf, file);
		fclose (file);
	}

#ifdef _MSC_VER
	OutputDebugString (buf);
#endif
	va_end (vl);
}



void DebugPrintf (IAICallback *cb, const char *fmt, ...)
{
	static char buf[256];
	
	if (!aiConfig.debug)
		return;

	va_list vl;
	va_start (vl, fmt);
#ifdef _MSC_VER
	_vsnprintf (buf, sizeof(buf), fmt, vl);
#else
	vsnprintf (buf, sizeof(buf), fmt, vl);
#endif
	va_end (vl);

	logPrintf ("%s\n", buf);
}


void ChatDebugPrintf (IAICallback *cb, const char *fmt, ...)
{
	static char buf[256];
	
	if (!aiConfig.debug)
		return;

	va_list vl;
	va_start (vl, fmt);
#ifdef _MSC_VER
	_vsnprintf (buf, sizeof(buf), fmt, vl);
#else
	vsnprintf (buf, sizeof(buf), fmt, vl);
#endif
	va_end (vl);

	logPrintf ("%s\n", buf);

	cb->SendTextMsg (buf,  0);
}



void ChatMsgPrintf (IAICallback *cb, const char *fmt, ...)
{
	static char buf[256];
	va_list vl;
	va_start (vl, fmt);
#ifdef _MSC_VER
	_vsnprintf (buf, sizeof(buf), fmt, vl);
#else
	vsnprintf (buf, sizeof(buf), fmt, vl);
#endif

	logPrintf ("%s\n", buf);

	cb->SendTextMsg (buf,  0);
	va_end (vl);
}

// ----------------------------------------------------------------------------------------
// aiUnit
// ----------------------------------------------------------------------------------------

void aiUnit::DependentDied (aiObject *) {}



// ----------------------------------------------------------------------------------------
// MainAI - Static functions
// ----------------------------------------------------------------------------------------


static bool isCommonDataLoaded = false;

// Loads AI data not depending on side or units
bool MainAI::LoadCommonData(IGlobalAICallback *cb)
{
	if (isCommonDataLoaded)
		return true;

	CfgList *root = LoadConfig (cb);
	if (!root)
		return false;

	IAICallback *aicb = cb->GetAICallback();

	ChatMsgPrintf (aicb, "Running mod %s on map %s%s",  aicb->GetModName (),aicb->GetMapName (), 
#ifdef _DEBUG
		" - debug build"
#else
		""
#endif
		);

	if (!aiConfig.Load (root))
	{
		aicb->SendTextMsg ( "Failed to load AI script. see testai.log for details.",0);
		delete root;
		return false;
	}

	buildTable.Init (aicb, aiConfig.cacheBuildTable);

	GetSearchOffsetTable();

	rootcfg = root;
	isCommonDataLoaded = true;
	return true;
}

void MainAI::FreeCommonData()
{
	if (rootcfg)
		delete rootcfg;
	rootcfg = 0;

	FreeSearchOffsetTable();
}

void ReplaceExtension (const char *n, char *dst,int s, const char *ext)
{
	uint l = strlen (n);

	uint a=l-1;
	while (n[a] && n[a]!='.' && a>0)
		a--;

	strncpy (dst, AI_PATH, s);
	if (a>s-sizeof(AI_PATH)) a=s-sizeof(AI_PATH);
	memcpy (&dst [sizeof (AI_PATH)-1], n, a);
	dst[a+sizeof(AI_PATH)]=0;

	strncat (dst, ".", s);
	strncat (dst, ext, s);
}

CfgList* MainAI::LoadConfig (IGlobalAICallback *cb)
{
	char file[64];

	const char *mod = cb->GetAICallback()->GetModName ();
	ReplaceExtension (mod, file, 64, "cfg");
	
	// register the build options type:
	CfgValue::AddValueClass (&cfg_BuildOptionsType);

	// load config
	CfgList* cfg = CfgValue::LoadFile (file);
	if (!cfg)
	{
		ChatMsgPrintf (cb->GetAICallback(), "Error loading config: %s", file);
		return 0;
	}
//	logPrintf ("Listing config...\n");
//	rootcfg->dbgPrint(0);

	return cfg;
}

// ----------------------------------------------------------------------------------------
// MainAI
// ----------------------------------------------------------------------------------------

MainAI::MainAI(int i)
{
	cb = 0;
	sidecfg = 0;

	cfgLoaded=false;
	skip=false;
	aiIndex=i;
	dbgWindow=0;

	for (int a=0;a<NUM_TASK_TYPES;a++) 
		taskHandlers[a]=0;
	
	buildHandler = 0;

	logFileOpen ();
}

MainAI::~MainAI()
{
	logPrintf ("Closing AI...\n");
	for (HandlerList::iterator a=handlers.begin ();a!=handlers.end();++a)
		delete *a;

	if (dbgWindow) {
		DbgDestroyWindow (dbgWindow);
		dbgWindow=0;
	}

	logFileClose ();
}

void MainAI::AddHandler (aiHandler *h)
{
	h->ai = this;	
	handlers.insert (h);
}

void MainAI::RemoveHandler (aiHandler *h)
{
	handlers.erase (h);

	if (buildHandler == h)
		buildHandler = 0;
}

void MainAI::GotChatMsg (const char *msg, int player)
{
	if (msg[0] != '.')
		return;

	if (!stricmp(".skipai", msg)) {
		skip=true;
		cb->SendTextMsg ("Skip enabled",0);
	} else if (!stricmp(".unskipai", msg)) {
		skip=false;
		cb->SendTextMsg ("Skip disabled",0);
	} else if(!stricmp(".inactives", msg)) {
		for (int a=0;a<buildHandler->builders.size();a++)  {
			BuildUnit *b = buildHandler->builders [a];
			if (b->tasks.empty())
				ChatMsgPrintf (cb, "Inactive: %s\n", b->def->name.c_str());
		}
	} else if(!stricmp(".groupstate",msg))
		forceHandler->ShowGroupStates ();
	else if(!stricmp(".writethreatmap", msg))
		map.WriteThreatMap ("threatmap.tga");
	else if(!stricmp(".writebuildmap", msg))
		buildHandler->buildMap.WriteTGA ("buildmap.tga");
	else if (!stricmp(".debugwindow", msg))
	{
		if (dbgWindow) 
			DbgDestroyWindow(dbgWindow);
		InitDebugWindow();
	}
}

void MainAI::InitDebugWindow()
{
	char name[64];
	sprintf (name, "JCAI Debug Output window - %d", aiIndex);

	dbgWindow = DbgCreateWindow (name, 400, 400);
}

void MainAI::InitAI(IGlobalAICallback* callback, int team)
{
	aicb = callback;
	cb = callback->GetAICallback ();

	if (!LoadCommonData(callback))
		return;

	cfgLoaded=true;

	map.CalculateInfoMap (cb, aiConfig.infoblocksize);

	metalmap.debugShowSpots = aiConfig.showMetalSpots;
	metalmap.Initialize (cb);

	if (aiConfig.showDebugWindow)
		InitDebugWindow();
}


void MainAI::UnitDamaged(int damaged,int attacker,float damage,float3 dir)
{
	map.UpdateDamageMeasuring (damage, damaged,cb);
}

void MainAI::InitUnit (aiUnit *u, int unit)
{
	units[unit] = u;
	u->id = unit;
	u->def = cb->GetUnitDef (unit);
}

void MainAI::Startup (int cmdrid)
{
	if (!cfgLoaded)
		return;

	aiUnit *cmdr = new aiUnit;
	InitUnit (cmdr, cmdrid);

	const UnitDef* cmdrdef = cb->GetUnitDef (cmdrid);

	if (!aiConfig.LoadUnitTypeInfo (rootcfg, &buildTable))
		return;

	sidecfg = dynamic_cast<CfgList*>(rootcfg->GetValue (cmdrdef->name.c_str()));
	if (!sidecfg)
	{
		ChatMsgPrintf (cb, "No info for side of %s\n", cmdrdef->name.c_str());
		cfgLoaded=false;
		skip=true;
		return;
	}

	map.UpdateBaseInfo (cb);

	// Create task-creating handlers:
	try { 
		buildHandler = new BuildHandler (this);
		buildHandler->Init (cmdrid);
		handlers.insert (buildHandler);

		forceHandler = new ForceHandler (this);
		handlers.insert (forceHandler);

		TaskHandler* resUnitHandler = new ResourceUnitHandler (this);
		handlers.insert (resUnitHandler);

		TaskHandler* defenseHandler = new SupportHandler (this);
		handlers.insert (defenseHandler);

		TaskHandler* reconHandler = new ReconHandler (this);
		handlers.insert (reconHandler);

		taskHandlers [0] = resUnitHandler;
		taskHandlers [1] = forceHandler;
		taskHandlers [2] = defenseHandler;
		taskHandlers [3] = reconHandler;
	}
	catch (const char *s)
	{
		ChatMsgPrintf (cb, "Error: %s",s);
		cfgLoaded=false;
	}

	// do a single update of the infomap, so there is correct info even the first frames
	map.UpdateBaseInfo (cb);
	map.UpdateThreatInfo (cb);
}

void MainAI::UnitCreated(int unit)
{
	if (!cfgLoaded)
		return;

	const UnitDef *def = cb->GetUnitDef (unit);

	if (def->isCommander)
	{
		Startup (unit);
		return;
	}

	aiUnit *u = buildHandler->UnitCreated (unit);
	u->id = unit;
	u->def = def;
	units [unit] = u;
}

void MainAI::UnitDestroyed(int unit)
{
	if (!cfgLoaded)
		return;

	UnitIterator u = units.find (unit);

	assert (u != units.end());

	aiUnit *p = u->second;
	//ChatDebugPrintf (cb,"%s lost,agent: %s",p->def->name.c_str(), p->owner ? p->owner->GetName() : "none");

	// the build handler should know it can build on this spot again
	if (p->owner != buildHandler)
	{
		BuildTable::UDef* ud = buildTable.GetCachedDef (p->def->id);
		if (ud->IsBuilding ())
			buildHandler->RemoveUnitBlocking (p->def, cb->GetUnitPos (p->id));
	}

	// let the handler of the unit destroy it
	if (p->owner)
		p->owner->UnitDestroyed (p);
	else {
		ChatMsgPrintf (cb, "Error: %s didn't have handler\n", p->def->name.c_str());
		delete p;
	}
	units.erase (u);
}

void MainAI::UnitFinished (int unit)
{
	if (!cfgLoaded)
		return;

	UnitIterator u = units.find (unit);
	assert (u != units.end());

	aiUnit *p = u->second;
	p->flags |= UNIT_FINISHED;

	if (p->def->isCommander)
		return;

	p->UnitFinished ();
	if (p->owner)
		p->owner->UnitFinished (p);
}

void MainAI::UnitIdle (int unit) {}

void MainAI::EnemyEnterLOS(int enemy) {}
void MainAI::EnemyLeaveLOS(int enemy) {}
void MainAI::EnemyEnterRadar(int enemy) {}
void MainAI::EnemyLeaveRadar(int enemy) {}
void MainAI::EnemyDestroyed (int enemy) {}

void MainAI::Update()
{
	if (!cfgLoaded)
		return;

	int f=cb->GetCurrentFrame ();

	if (skip)
		return;

	if(f%16==0) map.UpdateBaseInfo (cb);
	if(f%16==8) map.UpdateThreatInfo (cb);

	for (HandlerList::iterator i=handlers.begin();i!=handlers.end();++i) 
	{
		const char *n = (*i)->GetName ();
		(*i)->Update ();
	}

	if (dbgWindow)
	{
		if (DbgWindowIsClosed(dbgWindow))
		{
			DbgDestroyWindow (dbgWindow);
			dbgWindow = 0;
		}
		else
		{
			DbgClearWindow(dbgWindow);

			DbgWndPrintf (dbgWindow, 0, 0, "# Force groups: %d", forceHandler->batches.size());
		//	map.DrawThreatMap (dbgWindow);

			buildHandler->ShowDebugInfo (dbgWindow);
			
			DbgWindowUpdate (dbgWindow);
		}
	}
}

float3 MainAI::ClosestBuildSite(const UnitDef* unitdef,float3 pos,int minDist)
{
	return cb->ClosestBuildSite (unitdef, pos,map.mblocksize, minDist);
}

