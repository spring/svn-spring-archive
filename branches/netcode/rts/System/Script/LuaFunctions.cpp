// This file contains implementations of various functions exposed through lua
// The goal is to include as few headers in LuaBinder.cpp as possible, and include
// them here instead to avoid recompiling LuaBinder too often.

#include "StdAfx.h"
#include "LuaFunctions.h"
#include "GlobalStuff.h"
#include "float3.h"
#include "LogOutput.h"
#include "TdfParser.h"
#include "ExternalAI/GlobalAIHandler.h"
#include "Game/command.h"
#include "Game/Game.h"
#include "Game/SelectedUnits.h"
#include "Game/StartScripts/Script.h"
#include "Game/UI/EndGameBox.h"
#include "Lua/LuaCallInHandler.h"
#include "Map/ReadMap.h"
#include "Sim/Misc/FeatureDef.h"
#include "Sim/Misc/Feature.h"
#include "Sim/Misc/FeatureHandler.h"
#include "Sim/Misc/QuadField.h"
#include "Sim/Units/CommandAI/CommandAI.h"
#include "Sim/Units/UnitDefHandler.h"
#include "Sim/Units/Unit.h"
#include "Sim/Units/UnitHandler.h"
#include "Sim/Units/UnitLoader.h"
#include "Sim/Units/UnitTypes/TransportUnit.h"

using namespace std;
using namespace luabind;

extern std::string stupidGlobalMapname;

namespace luafunctions
{

	// This should use net stuff instead of duplicating code here
	void EndGame()
	{
		SAFE_NEW CEndGameBox();
		game->gameOver = true;
		luaCallIns.GameOver();
	}

    void CreateGlobalAI( int teamnumber, std::string dllname )
    {
        globalAI->CreateGlobalAI( teamnumber, dllname.c_str() );
    }

	void UnitGiveCommand(CObject_pointer<CUnit>* u, Command* c)
	{
		if (!u->held)
			return;

		u->held->commandAI->GiveCommand(*c);
	}

	void CommandAddParam(Command* c, float p)
	{
		c->params.push_back(p);
	}

	CObject_pointer<CUnit>* UnitLoaderLoadUnit(string name, float3 pos, int team, bool buil)
	{
		CUnit* x = unitLoader.LoadUnit(name, pos, team, buil, 0, NULL);
		return SAFE_NEW CObject_pointer<CUnit>(x);
	}

	CObject_pointer<CFeature>* FeatureLoaderLoadFeature( string name, float3 pos, int team )
	{
		FeatureDef *def = featureHandler->GetFeatureDef(name);
		CFeature* feature = SAFE_NEW CFeature();
		feature->Initialize( pos,def,0, 0, team,"" );
		return SAFE_NEW CObject_pointer<CFeature>(feature);
	}

	CObject_pointer<CUnit>* UnitGetTransporter(CObject_pointer<CUnit>* u)
	{
		CUnit* x = u->held;
		if (x->transporter)
			return SAFE_NEW CObject_pointer<CUnit>(x->transporter);
		else
			return NULL;
	}

	//	vector<CUnit*> GetUnits(const float3& pos,float radius);
	//	vector<CUnit*> GetUnitsExact(const float3& pos,float radius);

	int GetNumUnitsAt(const float3& pos, float radius)
	{
		vector<CUnit*> x = qf->GetUnits(pos, radius);
		return x.size();
	}

	object GetUnitsAt(lua_State* L, const float3& pos, float radius)
	{
		vector<CUnit*> x = qf->GetUnits(pos, radius);
		object o = newtable(L);

		int count = 1;
		for (vector<CUnit*>::iterator i = x.begin(); i != x.end(); ++i)
			o[count++] = SAFE_NEW CObject_pointer<CUnit>(*i);

		return o;
	}

	object GetFeaturesAt(lua_State* L, const float3& pos, float radius)
	{
		vector<CFeature*> ft = qf->GetFeaturesExact (pos, radius);

		object o = newtable(L);

		int count = 1;
		for (int a=0;a<ft.size();a++)
		{
			CFeature *f = ft[a];
			o[count++] = SAFE_NEW CObject_pointer<CFeature>(f);
		}

		return o;
	}

	int GetNumUnitDefs()
	{
		return unitDefHandler->numUnits;
	}

	// This doesnt work, not sure why; Spring crashes
	// It crashes because UnitDef doesn't inherit CObject
	// even with boost::shared_ptr I can't get it to work though... -- Tobi
	//CObject_pointer<UnitDef>* GetUnitDefById( int id )
	//{
	//	UnitDef *def = unitDefHandler->GetUnitByID (id);
	//	return SAFE_NEW CObject_pointer<UnitDef>(def);
	//}

	/* This doesnt work, not sure why; Spring crashes
	object GetUnitDefList( lua_State* L )
	{
		object o = newtable(L);
		//UnitDef *def = unitDefHandler->GetUnitByID (1);
		UnitDef *def = unitDefHandler->GetUnitByName ("ARMCOM");
		o[1] = SAFE_NEW CObject_pointer<UnitDef>(def);
		return o;

		int count = 1;
		for (int a=0;a<unitDefHandler->numUnits && a < 10;a++)
		{
			UnitDef *def = unitDefHandler->GetUnitByID (a+1);
			o[count++] = SAFE_NEW CObject_pointer<UnitDef>(def);
		}

		return o;
	}
	*/

	object GetSelectedUnits(lua_State* L, int player)
	{
		object o = newtable(L);

		for (int i = 0; i < selectedUnits.netSelected[player].size(); ++i)
			o[i+1] = SAFE_NEW CObject_pointer<CUnit>(uh->units[selectedUnits.netSelected[player][i]]);

		return o;
	}

	void SendSelectedUnits()
	{
		if (selectedUnits.selectionChanged)
			selectedUnits.SendSelection();
	}

	string MapGetTDFName()
	{
		return CReadMap::GetTDFName(stupidGlobalMapname);
	}
}
