//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
struct SupportConfig
{
	struct UnitDefProperty
	{
		UnitDefProperty () { fptr=0; isFloat=true; }

		bool isFloat;
		union {
			float UnitDef::*fptr;
			int UnitDef::*iptr;
		};
	};

	SupportConfig() { mapcover=basecover=0; }

	CfgBuildOptions *mapcover; // mapcover units
	vector <UnitDefProperty> mapcoverProps;  // which property should be used to cover the map?
	CfgBuildOptions *basecover;
	vector <UnitDefProperty> basecoverProps;
	CfgBuildOptions *baseperimeter;
	vector <UnitDefProperty> baseperimeterProps;

	static void MapUDefProperties (CfgBuildOptions *c, vector<UnitDefProperty>& props);
	bool Load (CfgList *sidecfg);
};

class SupportHandler : public TaskHandler
{
public:
	SupportHandler (MainAI *ai);

	void Update ();
	void UnitDestroyed (aiUnit *unit);
	void UnitFinished (aiUnit *unit);

	aiTask* GetNewTask ();

	const char *GetName () { return "Support"; }
	aiUnit* CreateUnit (int id); // should not register the unit - since it's not finished yet

protected:
	SupportConfig config;
};


