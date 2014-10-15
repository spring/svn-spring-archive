//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "BaseAIDef.h"
#include "MetalSpotMap.h"
#include "InfoMap.h"

// note that currently, the metal map info caching is disabled because it takes very little time to generate

#define MMAPCACHE_VERSION 1

// TODO:
// - Make the best spot mark the keepmap, not the first


const struct Offset_t { int x,y; } static OffsetTbl[8] = {
	{ -1,-1 }, { 0, -1 }, { 1, -1 }, { -1, 0 }, { 1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 }
};


MetalSpotMap::MetalSpotMap()
{
	w=h=0;
	spotmap=0;
	metalblockw = 0;
	blockw=0;
	debugShowSpots=0;
}

MetalSpotMap::~MetalSpotMap()
{
	if (spotmap)
		delete[] spotmap;
	spotmap=0;
}

int2 MetalSpotMap::GetFrom3D (const float3& pos)
{
	int2 r;

	r.x = pos.x / (blockw*SQUARE_SIZE);
	r.y = pos.z / (blockw*SQUARE_SIZE);

	if (r.x < 0) r.x=0;
	if (r.y < 0) r.y=0;
	if (r.x >= w) r.x=w-1;
	if (r.y >= h) r.y=h-1;

	return r;
}

#define METAL_MAP_SQUARE_SIZE (SQUARE_SIZE*2)

void MetalSpotMap::Initialize (IAICallback *cb)
{
	const float* hm = cb->GetHeightMap();
	int hmw = cb->GetMapWidth ();
	int hmh = cb->GetMapHeight ();

	float exRadius = cb->GetExtractorRadius () / METAL_MAP_SQUARE_SIZE;
	bool isMetalMap = false;

	metalblockw = exRadius*2;
	/*if (metalblockw < 3) {
		metalblockw = 3; // to support metal maps
		isMetalMap = true; // kinda hackish, but who cares if it works :)
	}*/
	if (metalblockw < 6) { // putting it on 6 means a temporary optimization, otherwise GetEmptySpot() will just slow things down too much
		metalblockw = 6;
		isMetalMap = true;
	}
	blockw = metalblockw*2;

	w = 1 + hmw / blockw;
	h = 1 + hmh / blockw;

	logPrintf ("Extractor Radius: %f, w=%d, h=%d, blockw=%d, metalblockw=%d\n", exRadius, w,h,blockw,metalblockw);

	spotmap = new MetalSpotInfo [w*h];

	const unsigned char* metalmap=cb->GetMetalMap ();

	uchar bestspot=0;
	ulong totalMetal=0;

	for (const uchar *mm = metalmap; mm < metalmap + (hmw*hmh/4); mm++)
		totalMetal += *mm;

	averageMetal = 4 * totalMetal / (hmw * hmh);
	int minMetalOnSpot = averageMetal;

	for (int my=0;my<h;my++)
	{
		for (int mx=0;mx<w;mx++)
		{
			MetalSpotInfo *spot = &spotmap [my*w+mx];

			float minh,maxh;
			double sum=0.0;

			int endy = std::min(blockw*(my+1), hmh);
			int endx = std::min(blockw*(mx+1), hmw);

			minh=maxh=hm[(endy-1)*hmw+endx-1];

			for (int y=blockw*my;y<endy;y++)
				for (int x=blockw*mx;x<endx;x++)
				{
					float h = hm [hmw * y + x];
					sum += h;

					if (h < minh) minh=h;
					if (h > maxh) maxh=h;
					sum += hm [hmw * y + x];
				}

			unsigned char bestm=0;
			int2 best;

			endx = std::min(metalblockw*(mx+1), hmw/2);
			endy = std::min(metalblockw*(my+1), hmh/2);

			for (int y=metalblockw*my;y<endy;y++)
				for (int x=metalblockw*mx;x<endx;x++)
				{
					unsigned char m=metalmap[hmw/2*y+x];
					if (bestm < m) {
						bestm = m;
						best=int2(x,y);
					}
				}

			if (bestm >= minMetalOnSpot) {
				spot->metalvalue = bestm;
				spot->spotpos = int2 (best.x * 2 + 3, best.y * 2 + 3);
			} else
				spot->metalvalue = 0;

			spot->height = sum / (blockw*blockw);
			spot->heightDif = std::max (spot->height - minh, maxh - spot->height);

			if (bestspot < bestm)
				bestspot = bestm;
		}
	}

	if (!isMetalMap) {
		bool *keepmap = new bool [w*h];
		memset (keepmap,0,sizeof(bool)*w*h);

		for (int my=0;my<h;my++)
			for (int mx=0;mx<w;mx++)
			{
				MetalSpotInfo &blk = spotmap [my*w+mx];
				bool keep=true;

				if (!blk.metalvalue)
					continue;

				for (int a=0;a<8;a++)
				{
					Offset_t ofs = OffsetTbl [a];
					int dx=mx+ofs.x,dy=my+ofs.y;
					if (dx<0 || dx>=w || dy<0 || dy>=h) 
						continue;
					MetalSpotInfo *n = Get(dx,dy);

					if (n->metalvalue < minMetalOnSpot) 
						continue;

					int px=blk.spotpos.x - n->spotpos.x;
					int py=blk.spotpos.y - n->spotpos.y;
					int blockingRadius = metalblockw;

					if (px*px+py*py < blockingRadius*blockingRadius)
						if (keepmap [dy*w+dx]) keep=false; // its already taken
				}

				keepmap [my*w+mx] = keep;
			}

		for (int my=0;my<h;my++)
			for (int mx=0;mx<w;mx++)
				if (!keepmap [my*w+mx])	Get(mx,my)->metalvalue=0;

		delete [] keepmap;
	}

	// Calculate metal production constants
	float extractionRange = cb->GetExtractorRadius ();
	float metalFactor = cb->GetMaxMetal ();
	int numspots=0;

	averageProduction = 0.0f;
	for (int my=0;my<h;my++)
		for (int mx=0;mx<w;mx++)
		{
			MetalSpotInfo *b = Get(mx,my);

			if (!b->metalvalue)
				continue;

			b->metalProduction = 0.0f;

	///		logPrintf ("Metal spot: %dx%d\n", b->spotpos.x, b->spotpos.y);

			int xBegin = max(0,(int)((b->spotpos.x * SQUARE_SIZE - extractionRange) / METAL_MAP_SQUARE_SIZE));
			int xEnd = min(hmw/2-1,(int)((b->spotpos.x * SQUARE_SIZE + extractionRange) / METAL_MAP_SQUARE_SIZE));
			int zBegin = max(0,(int)((b->spotpos.y * SQUARE_SIZE - extractionRange) / METAL_MAP_SQUARE_SIZE));
			int zEnd = min(hmh/2-1,(int)((b->spotpos.y * SQUARE_SIZE + extractionRange) / METAL_MAP_SQUARE_SIZE));
			for (int z=zBegin;z<=zEnd;z++)
				for (int x=xBegin;x<=xEnd;x++)
				{
					int dx=x-b->spotpos.x/2;
					int dz=z-b->spotpos.y/2;

					if (dx*dx+dz*dz < exRadius * exRadius) //METAL_MAP_SQUARE_SIZE*METAL_MAP_SQUARE_SIZE) 
						b->metalProduction += metalmap [z*hmh/2 + x] * metalFactor;
				}

			numspots++;
			averageProduction += b->metalProduction;
		}

	if (numspots>0.0f)
		averageProduction /= numspots;

	if (debugShowSpots)
	{
		for (int y=0;y<h;y++)
			for (int x=0;x<w;x++) {
				MetalSpotInfo *b = Get (x,y);
				if (b->metalvalue>0.0f) {
					float3 pos (SQUARE_SIZE*b->spotpos.x,cb->GetElevation(b->spotpos.x*SQUARE_SIZE,b->spotpos.y*SQUARE_SIZE), b->spotpos.y*SQUARE_SIZE);
					cb->DrawUnit ("CORMEX", pos, 0.0f, 200000, cb->GetMyAllyTeam(), true, true);
				}
			}
	}

	ChatMsgPrintf (cb, "Metal info map calculated: Highest metal val=%d, Number of spots: %d, Average production/spot: %f", bestspot, numspots, averageProduction);
	//SaveCache (cb->GetMapName ());
}



int2 MetalSpotMap::GetEmptySpot (const float3& startpos, InfoMap *infoMap, bool water)
{
	const int maxTests=200;
	SearchOffset *tbl = GetSearchOffsetTable ();
	int2 sector = GetFrom3D (startpos);
	int tests=0;

	int bestscore;
	int2 bestsector (-1,0);

	for (int a=0;a<numSearchOffsets;a++)
	{
		SearchOffset& ofs = tbl [a];

		int x = ofs.dx + sector.x;
		int y = ofs.dy + sector.y;

		if (x >= w || y >= h || x < 0 || y < 0)
			continue;

		MetalSpotInfo& blk = spotmap [y*w+x];

		if (blk.taken || !blk.metalvalue)
			continue;

		if ( (water && blk.height > 0) || (!water && blk.height < 0.0f) )
			continue;
		
		// lower score mean better sector
		int score = sqrtf (ofs.qdist) * 50 - blk.metalvalue;

		GameInfo *gi = infoMap->GetGameInfoFromMapSquare (y*blockw, x*blockw);
		score += gi->threat*200;
		score += blk.heightDif;

		if (bestsector.x < 0 || bestscore > score)
		{
			bestscore = score;
			bestsector = int2 (x,y);
		}

		tests++;

		if (tests == maxTests)
			break;
	}

	if (bestsector.x >= 0)
	{
		logPrintf ("GetEmptySpot(): (%d,%d)\n", bestsector.x, bestsector.y);
	}
	else {
		logPrintf ("GetEmptySpot(): No good metal spot found.\n");
	}

	return bestsector;
}


void MetalSpotMap::MarkSpot (int2 pos, bool marked)
{
	assert (pos.x >= 0);

	Get(pos.x,pos.y)->taken=marked;

	logPrintf ("Marked metal spot: %d,%d = %s\n", pos.x,pos.y,marked ? "taken" : "empty");
}

#define METAL_CACHE_EXT "mmapcache"

string MetalSpotMap::GetMapCacheName (const char *mapname)
{
	string s = AI_PATH;
	s += mapname;
	const char *ext = "." METAL_CACHE_EXT;
	s.replace (s.begin() + s.rfind ('.'), s.end(), ext, ext+strlen(ext));
	return s;
}

bool MetalSpotMap::LoadCache (const char *mapname)
{
	string fn = GetMapCacheName (mapname);
	return false;
}

bool MetalSpotMap::SaveCache (const char *mapname)
{
	string fn = GetMapCacheName (mapname);
	FILE *f = fopen (fn.c_str(), "wb");

	if (!f) {
		logPrintf ("Error: Failed to save metal spot cache: %s.\n", fn.c_str());
		return false;
	}

	char t = MMAPCACHE_VERSION;
	fputc (t, f);
	fwrite (&metalblockw, sizeof(int), 1, f);
	fwrite (&blockw, sizeof(int), 1, f);
	fwrite (&w, sizeof(int),1,f);
	fwrite (&h, sizeof(int),1,f);
	fwrite (spotmap, sizeof(MetalSpotInfo), w*h, f);

	if (ferror(f))
	{
		logPrintf ("Error while writing metal map cache to %s\n", fn.c_str());
		fclose (f);
		remove (fn.c_str());
		return false;
	}

	fclose (f);

	return true;
}

