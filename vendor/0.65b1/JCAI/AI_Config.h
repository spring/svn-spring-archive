//-------------------------------------------------------------------------
// JCAI version 0.20
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "CfgParser.h"

class MainAI;

class CfgBuildOptions : public CfgValue
{
public:
	struct BuildOpt 
	{
		BuildOpt () { def=0; count=0; info=0; }
		~BuildOpt () { if (info) delete info; }

		UnitDefID def;
		int count;
		string name;
		CfgList *info; // build requirements/conditions
	};
	
	void dbgPrint(int depth);
	bool Parse(CfgBuffer& buf);
	bool InitIDs ();

	vector <BuildOpt*> builds;
	int TotalBuilds ();
};

// Connects the CfgBuildOptions to the config parser
class CfgBuildOptionsType : public CfgValueClass
{
public:
	bool Identify(const CfgBuffer& buf) { return buf.CompareIdent ("buildoptions"); }
	CfgValue* Create() { return new CfgBuildOptions; }
};

extern CfgBuildOptionsType cfg_BuildOptionsType;


struct ForceConfig;
struct ReconConfig;

class UnitGroup;

class AIConfig 
{
public:
	AIConfig ();
	~AIConfig ();

	bool Load (CfgList *root);

	int defmindist,factorymindist;
	bool cacheBuildTable;
	int infoblocksize;
	bool debug, showDebugWindow, showMetalSpots;

	int builderMoveTimeout;
	float builderMoveMinDistance;
	float threatDecay;

	int safeSectorRadius, mexSectorRadius;

	struct UnitTypeInfo {
		vector <UnitDefID> aadefense, gddefense;
	} unitTypesInfo;

	bool LoadUnitTypeInfo (CfgList *root, BuildTable *tbl);
};


extern AIConfig aiConfig; // general config
