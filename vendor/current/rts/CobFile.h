#pragma once

#include <iostream>
#include <vector>
#include <string>
#include <map>

//0 = none
//1 = script calls
//2 = show every instruction
#define COB_DEBUG	0

// Should return true for scripts that should have debug output. 
#define COB_DEBUG_FILTER (script.name == "scripts\\ARMJETH.cob")

using namespace std;

class CFileHandler;

//These are mapped by the CCobFile at startup to make common function calls faster
const COBFN_Create = 0;
const COBFN_StartMoving = 1;
const COBFN_StopMoving = 2;
const COBFN_Activate = 3;
const COBFN_Killed = 4;
const COBFN_Deactivate = 5;
const COBFN_SetDirection = 6;
const COBFN_SetSpeed = 7;
const COBFN_RockUnit = 8;
const COBFN_HitByWeapon = 9;
const COBFN_MoveRate0 = 10;
const COBFN_MoveRate1 = 11;
const COBFN_MoveRate2 = 12;
const COBFN_MoveRate3 = 13;
const COBFN_SetSFXOccupy = 14;
const COBFN_Last = 15;					//Make sure to update this, so the array will be sized properly

// These are special (they need space for MaxWeapons of each)
const COB_MaxWeapons = 16;
const COBFN_QueryPrimary = COBFN_Last;
const COBFN_AimPrimary = COBFN_QueryPrimary + COB_MaxWeapons;
const COBFN_AimFromPrimary = COBFN_AimPrimary + COB_MaxWeapons;
const COBFN_FirePrimary = COBFN_AimFromPrimary + COB_MaxWeapons;
const COBFN_EndBurst = COBFN_FirePrimary + COB_MaxWeapons;

class CCobFile
{
public:
	vector<string> scriptNames;
	vector<long> scriptOffsets;
	vector<long> scriptLengths;			//Assumes that the scripts are sorted by offset in the file
	vector<string> pieceNames;
	vector<int> scriptIndex;
	vector<int> sounds;
	map<string, int> scriptMap;
	long* code;
	int numStaticVars;
	string name;
public:
	CCobFile(CFileHandler &in, string name);
	~CCobFile(void);
	int getFunctionId(const string &name);
};
