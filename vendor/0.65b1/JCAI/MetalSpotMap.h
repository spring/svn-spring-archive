//-------------------------------------------------------------------------
// JCAI version 0.20
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
class InfoMap;

struct MetalSpotInfo
{
	MetalSpotInfo() { metalvalue=0; taken=false; }

	int2 spotpos;
	uchar metalvalue;
	float height, heightDif;
	float metalProduction;
	bool taken;
};

class MetalSpotMap
{
public:
	MetalSpotMap();
	~MetalSpotMap();

	void Initialize(IAICallback *cb);
	MetalSpotInfo* Get (int x,int y) { return &spotmap[y*w+x]; }
	int2 GetFrom3D (const float3& pos);
	// find a spot to build a mex on, and marks it "taken"
	int2 GetEmptySpot (const float3& startpos, InfoMap* infoMap, bool water=false); 
	// unmarks the spot
	void MarkSpot (int2 pos, bool mark);

	bool LoadCache (const char *mapname);
	bool SaveCache (const char *mapname);
	string GetMapCacheName (const char *mapname);

	float GetAverageProduction () { return averageProduction; }
	float GetAverageMetalDensity () { return averageMetal; }

	bool debugShowSpots;

protected:
	int metalblockw, blockw;
	int w,h;
	MetalSpotInfo* spotmap;
	float averageProduction;
	float averageMetal;
};


