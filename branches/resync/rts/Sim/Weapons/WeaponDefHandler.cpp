#include <stdexcept>
#include "StdAfx.h"
#include "WeaponDefHandler.h"
#include "Rendering/GL/myGL.h"
#include "TdfParser.h"
#include "FileSystem/FileHandler.h"
#include "Rendering/Textures/TAPalette.h"
#include "LogOutput.h"
#include <algorithm>
#include <cctype>
#include "Sound.h"
#include "Sim/Misc/DamageArrayHandler.h"
#include "Sim/Misc/CategoryHandler.h"
#include "Sim/Projectiles/ExplosionGenerator.h"
#include "mmgr.h"
#include <iostream>
#include "Sim/Projectiles/ProjectileHandler.h"
#include "Sim/Projectiles/Projectile.h"
#include "Rendering/Textures/ColorMap.h"

using namespace std;

CR_BIND(WeaponDef, );

CWeaponDefHandler* weaponDefHandler;

CWeaponDefHandler::CWeaponDefHandler()
{
	std::vector<std::string> tafiles = CFileHandler::FindFiles("weapons/", "*.tdf");
	//std::cout << " getting files from weapons/*.tdf ... " << std::endl;

	TdfParser tasunparser;

	for(unsigned int i=0; i<tafiles.size(); i++)
	{
		try {
			tasunparser.LoadFile(tafiles[i]);
		}catch( TdfParser::parse_error const& e) {
			std::cout << "Exception:"  << e.what() << std::endl; 
		} catch(...) {
			std::cout << "Unknown exception in parse process of " << tafiles[i] <<" caught." << std::endl; 
		}
	}

	std::vector<std::string> weaponlist = tasunparser.GetSectionList("");

	weaponDefs = SAFE_NEW WeaponDef[weaponlist.size()+1];
	for(std::size_t taid=0; taid<weaponlist.size(); taid++)
	{
		ParseTAWeapon(&tasunparser, weaponlist[taid], taid);
	}
}

CWeaponDefHandler::~CWeaponDefHandler()
{
	delete[] weaponDefs;
}

void CWeaponDefHandler::ParseTAWeapon(TdfParser *sunparser, std::string weaponname, int id)
{
	weaponDefs[id].name = weaponname;

	bool lineofsight;
	bool balistic;
	//bool twophase;
	bool beamweapon;
	//bool guided;
	//bool vlaunch;
	int rendertype;
	int color;
	int beamlaser;
	//bool tracking;
	//bool selfprop;
	//bool turret;
	//bool smokeTrail;
	//std::string modelName;

	sunparser->GetDef(weaponDefs[id].avoidFriendly, "1", weaponname + "\\AvoidFriendly");
	weaponDefs[id].collisionFlags=0;
	bool collideFriendly, collideFeature;
	sunparser->GetDef(collideFriendly, "1", weaponname + "\\CollideFriendly");
	sunparser->GetDef(collideFeature, "1", weaponname + "\\CollideFeature");
	if(!collideFriendly)
		weaponDefs[id].collisionFlags+=COLLISION_NOFRIENDLY;
	if(!collideFeature)
		weaponDefs[id].collisionFlags+=COLLISION_NOFEATURE;

	sunparser->GetDef(weaponDefs[id].dropped, "0", weaponname + "\\dropped");
	sunparser->GetDef(lineofsight, "0", weaponname + "\\lineofsight");
	sunparser->GetDef(balistic, "0", weaponname + "\\balistic");
	sunparser->GetDef(weaponDefs[id].twophase, "0", weaponname + "\\twophase");
	sunparser->GetDef(beamweapon, "0", weaponname + "\\beamweapon");
	sunparser->GetDef(weaponDefs[id].guided, "0", weaponname + "\\guidance");
	sunparser->GetDef(rendertype, "0", weaponname + "\\rendertype");
	sunparser->GetDef(color, "0", weaponname + "\\color");
	sunparser->GetDef(beamlaser, "0", weaponname + "\\beamlaser");
	sunparser->GetDef(weaponDefs[id].vlaunch, "0", weaponname + "\\vlaunch");
	sunparser->GetDef(weaponDefs[id].selfprop, "0", weaponname + "\\selfprop");
	sunparser->GetDef(weaponDefs[id].turret, "0", weaponname + "\\turret");
	sunparser->GetDef(weaponDefs[id].visuals.modelName, "", weaponname + "\\model");
	sunparser->GetDef(weaponDefs[id].visuals.smokeTrail, "0", weaponname + "\\smoketrail");
	sunparser->GetDef(weaponDefs[id].noSelfDamage, "0", weaponname + "\\NoSelfDamage");
	
	sunparser->GetDef(weaponDefs[id].waterweapon, "0", weaponname + "\\waterweapon");
	sunparser->GetDef(weaponDefs[id].tracks, "0", weaponname + "\\tracks");
	sunparser->GetDef(weaponDefs[id].noExplode, "0", weaponname + "\\NoExplode");
	sunparser->GetDef(weaponDefs[id].maxvelocity, "0", weaponname + "\\weaponvelocity");
	sunparser->GetDef(weaponDefs[id].isShield, "0", weaponname + "\\IsShield");
	sunparser->GetDef(weaponDefs[id].beamtime, "1", weaponname + "\\beamtime");

	sunparser->GetDef(weaponDefs[id].thickness, "2", weaponname + "\\thickness");
	sunparser->GetDef(weaponDefs[id].corethickness, "0.25", weaponname + "\\corethickness");
	sunparser->GetDef(weaponDefs[id].laserflaresize, "15", weaponname + "\\laserflaresize");
	sunparser->GetDef(weaponDefs[id].intensity, "0.9", weaponname + "\\intensity");
	sunparser->GetDef(weaponDefs[id].duration, "0.05", weaponname + "\\duration");

	if(weaponDefs[id].name.find("disintegrator")!=string::npos){	//fulhack
		weaponDefs[id].visuals.renderType = WEAPON_RENDERTYPE_FIREBALL;}
	else if(weaponDefs[id].visuals.modelName.compare("")!=0){
		weaponDefs[id].visuals.renderType = WEAPON_RENDERTYPE_MODEL;}
	else if(beamweapon){
		weaponDefs[id].visuals.renderType = WEAPON_RENDERTYPE_LASER;}
	else{
		weaponDefs[id].visuals.renderType = WEAPON_RENDERTYPE_PLASMA;}
	//else
	//	weaponDefs[id].visuals.hasmodel = true;

	weaponDefs[id].gravityAffected = false;
	if(weaponDefs[id].dropped || balistic)
		weaponDefs[id].gravityAffected = true;

	if(weaponDefs[id].dropped)	{
		weaponDefs[id].type = "AircraftBomb";

	}	else if(weaponDefs[id].vlaunch){
		weaponDefs[id].type = "StarburstLauncher";

	}	else if(beamlaser){
		weaponDefs[id].type = "BeamLaser";

	}	else if(weaponDefs[id].isShield){
		weaponDefs[id].type = "Shield";

	} else if(weaponDefs[id].waterweapon) {
		weaponDefs[id].type = "TorpedoLauncher";

	} else if(weaponDefs[id].name.find("disintegrator")!=string::npos) {
		weaponDefs[id].type = "DGun";

	} else if(lineofsight) {
		if(rendertype==7)
			weaponDefs[id].type = "LightingCannon";
		else if(beamweapon)
			weaponDefs[id].type = "LaserCannon";
		else if(weaponDefs[id].visuals.modelName.find("laser")!=std::string::npos)
			weaponDefs[id].type = "LaserCannon";		//swta fix
		else if(/*selfprop && */weaponDefs[id].visuals.smokeTrail)
			weaponDefs[id].type = "MissileLauncher";
		else if(rendertype == 4 && color == 2)
			weaponDefs[id].type = "EmgCannon";
		else if(rendertype == 5)
			weaponDefs[id].type = "Flame";
	//	else if(rendertype == 1)
	//		weaponDefs[id].type = "MissileLauncher";
		else
			weaponDefs[id].type = "Cannon";
	}
	else
		weaponDefs[id].type = "Cannon";

	std::string ttype;
	sunparser->GetDef(ttype, "", weaponname + "\\WeaponType");
	if(ttype!="")
		weaponDefs[id].type = ttype;

//	logOutput.Print("%s as %s",weaponname.c_str(),weaponDefs[id].type.c_str());

	sunparser->GetDef(weaponDefs[id].firesound.name, "", weaponname + "\\soundstart");
	sunparser->GetDef(weaponDefs[id].soundhit.name, "", weaponname + "\\soundhit");
	sunparser->GetDef(weaponDefs[id].firesound.volume, "-1", weaponname + "\\soundstartvolume");
	sunparser->GetDef(weaponDefs[id].soundhit.volume, "-1", weaponname + "\\soundhitvolume");

	/*if(weaponDefs[id].firesound.name.find(".wav") == -1)
		weaponDefs[id].firesound.name = weaponDefs[id].firesound.name + ".wav";
	if(weaponDefs[id].soundhit.name.find(".wav") == -1)
		weaponDefs[id].soundhit.name = weaponDefs[id].soundhit.name + ".wav";*/

	//weaponDefs[id].firesoundVolume = 5.0f;
	//weaponDefs[id].soundhitVolume = 5.0f;

	weaponDefs[id].range = atof(sunparser->SGetValueDef("10", weaponname + "\\range").c_str());
	float accuracy,sprayangle,movingAccuracy;
	sunparser->GetDef(accuracy, "0", weaponname + "\\accuracy");
	sunparser->GetDef(sprayangle, "0", weaponname + "\\sprayangle");
	sunparser->GetDef(movingAccuracy, "-1", weaponname + "\\movingaccuracy");
	if(movingAccuracy==-1)
		movingAccuracy=accuracy;
	weaponDefs[id].accuracy=sin((accuracy) * PI / 0xafff);		//should really be tan but TA seem to cap it somehow
	weaponDefs[id].sprayangle=sin((sprayangle) * PI / 0xafff);		//should also be 7fff or ffff theoretically but neither seems good
	weaponDefs[id].movingAccuracy=sin((movingAccuracy) * PI / 0xafff);

	sunparser->GetDef(weaponDefs[id].targetMoveError, "0", weaponname + "\\targetMoveError");

	for(int a=0;a<damageArrayHandler->numTypes;++a)
	{
		sunparser->GetDef(weaponDefs[id].damages[a], "0", weaponname + "\\DAMAGE\\default");
		if(weaponDefs[id].damages[a]==0)		//avoid division by zeroes
			weaponDefs[id].damages[a]=1;
	}
	const std::map<std::string, std::string>& damages=sunparser->GetAllValues(weaponname + "\\DAMAGE");
	for(std::map<std::string, std::string>::const_iterator di=damages.begin();di!=damages.end();++di){
		int type=damageArrayHandler->GetTypeFromName(di->first);
		float damage=atof(di->second.c_str());
		if(damage==0)
			damage=1;
		if(type!=0){
			weaponDefs[id].damages[type]=damage;
//			logOutput.Print("Weapon %s has damage %f against type %i",weaponname.c_str(),damage,type);
		}
	}

	weaponDefs[id].damages.impulseFactor=atof(sunparser->SGetValueDef("1", weaponname + "\\impulsefactor").c_str());
	weaponDefs[id].damages.impulseBoost=atof(sunparser->SGetValueDef("0", weaponname + "\\impulseboost").c_str());
	std::string craterMult;
	if (!sunparser->SGetValue(craterMult, weaponname + "\\cratermult")){
		/* No entry given. Default: old behaviour. */
		weaponDefs[id].damages.craterMult=weaponDefs[id].damages.impulseFactor;
	} else {
		weaponDefs[id].damages.craterMult=atof(craterMult.c_str());
	}
	weaponDefs[id].damages.craterBoost=atof(sunparser->SGetValueDef("0", weaponname + "\\craterboost").c_str());

	weaponDefs[id].areaOfEffect=atof(sunparser->SGetValueDef("8", weaponname + "\\areaofeffect").c_str())*0.5f;
	weaponDefs[id].edgeEffectiveness=atof(sunparser->SGetValueDef("0", weaponname + "\\edgeEffectiveness").c_str());
	// prevent 0/0 division in CGameHelper::Explosion
	if (weaponDefs[id].edgeEffectiveness > 0.999f)
		weaponDefs[id].edgeEffectiveness = 0.999f;
	weaponDefs[id].projectilespeed = atof(sunparser->SGetValueDef("0", weaponname + "\\weaponvelocity").c_str())/GAME_SPEED;
	weaponDefs[id].startvelocity = max(0.01f,(float)atof(sunparser->SGetValueDef("0", weaponname + "\\startvelocity").c_str())/GAME_SPEED);
	weaponDefs[id].weaponacceleration = atof(sunparser->SGetValueDef("0", weaponname + "\\weaponacceleration").c_str())/GAME_SPEED/GAME_SPEED;
	weaponDefs[id].reload = atof(sunparser->SGetValueDef("1", weaponname + "\\reloadtime").c_str());
	weaponDefs[id].salvodelay = atof(sunparser->SGetValueDef("0.1", weaponname + "\\burstrate").c_str());
	sunparser->GetDef(weaponDefs[id].salvosize, "1", weaponname + "\\burst");
	weaponDefs[id].maxAngle = atof(sunparser->SGetValueDef("3000", weaponname + "\\tolerance").c_str()) * 180.0f / 0x7fff;
	weaponDefs[id].restTime = 0.0f;
	sunparser->GetDef(weaponDefs[id].metalcost, "0", weaponname + "\\metalpershot");
	sunparser->GetDef(weaponDefs[id].energycost, "0", weaponname + "\\energypershot");
	sunparser->GetDef(weaponDefs[id].selfExplode, "0", weaponname + "\\burnblow");
	weaponDefs[id].fireStarter=atof(sunparser->SGetValueDef("0", weaponname + "\\firestarter").c_str())*0.01f;
	weaponDefs[id].paralyzer=!!atoi(sunparser->SGetValueDef("0", weaponname + "\\paralyzer").c_str());
	if(weaponDefs[id].paralyzer)
		weaponDefs[id].damages.paralyzeDamageTime=atoi(sunparser->SGetValueDef("10", weaponname + "\\paralyzetime").c_str());
	else
		weaponDefs[id].damages.paralyzeDamageTime=0;
	weaponDefs[id].soundTrigger=!!atoi(sunparser->SGetValueDef("0", weaponname + "\\SoundTrigger").c_str());

	//sunparser->GetDef(weaponDefs[id].highTrajectory, "0", weaponname + "\\minbarrelangle");
	sunparser->GetDef(weaponDefs[id].stockpile, "0", weaponname + "\\stockpile");
	sunparser->GetDef(weaponDefs[id].interceptor, "0", weaponname + "\\interceptor");
	sunparser->GetDef(weaponDefs[id].targetable, "0", weaponname + "\\targetable");
	sunparser->GetDef(weaponDefs[id].manualfire, "0", weaponname + "\\commandfire");
	sunparser->GetDef(weaponDefs[id].coverageRange, "0", weaponname + "\\coverage");

	sunparser->GetDef(weaponDefs[id].shieldRepulser, "0", weaponname + "\\shieldrepulser");
	sunparser->GetDef(weaponDefs[id].smartShield, "0", weaponname + "\\smartshield");
	sunparser->GetDef(weaponDefs[id].exteriorShield, "0", weaponname + "\\exteriorshield");
	sunparser->GetDef(weaponDefs[id].visibleShield, "0", weaponname + "\\visibleshield");
	sunparser->GetDef(weaponDefs[id].visibleShieldRepulse, "0", weaponname + "\\visibleshieldrepulse");
	sunparser->GetDef(weaponDefs[id].shieldEnergyUse, "0", weaponname + "\\shieldenergyuse");
	sunparser->GetDef(weaponDefs[id].shieldForce, "0", weaponname + "\\shieldforce");
	sunparser->GetDef(weaponDefs[id].shieldRadius, "0", weaponname + "\\shieldradius");
	sunparser->GetDef(weaponDefs[id].shieldMaxSpeed, "0", weaponname + "\\shieldmaxspeed");
	sunparser->GetDef(weaponDefs[id].shieldPower, "0", weaponname + "\\shieldpower");
	sunparser->GetDef(weaponDefs[id].shieldPowerRegen, "0", weaponname + "\\shieldpowerregen");
	sunparser->GetDef(weaponDefs[id].shieldPowerRegenEnergy, "0", weaponname + "\\shieldpowerregenenergy");
	sunparser->GetDef(weaponDefs[id].shieldInterceptType, "0", weaponname + "\\shieldintercepttype");
	weaponDefs[id].shieldGoodColor=sunparser->GetFloat3(float3(0.5f,0.5f,1),weaponname + "\\shieldgoodcolor");
	weaponDefs[id].shieldBadColor=sunparser->GetFloat3(float3(1,0.5f,0.5f),weaponname + "\\shieldbadcolor");
	sunparser->GetDef(weaponDefs[id].shieldAlpha, "0.2", weaponname + "\\shieldalpha");

	int defInterceptType=0;
	if(weaponDefs[id].type == "Cannon")
		defInterceptType=1;
	else if(weaponDefs[id].type == "LaserCannon" || weaponDefs[id].type == "BeamLaser")
		defInterceptType=2;
	else if(weaponDefs[id].type == "StarburstLauncher" || weaponDefs[id].type == "MissileLauncher")
		defInterceptType=4;
	char interceptChar[100];
	sprintf(interceptChar,"%i",defInterceptType);
	sunparser->GetDef(weaponDefs[id].interceptedByShieldType, interceptChar, weaponname + "\\interceptedbyshieldtype");

	weaponDefs[id].wobble = atof(sunparser->SGetValueDef("0", weaponname + "\\wobble").c_str()) * PI / 0x7fff /30.0f;
	sunparser->GetDef(weaponDefs[id].trajectoryHeight, "0", weaponname + "\\trajectoryheight");

	weaponDefs[id].noAutoTarget= (weaponDefs[id].manualfire || weaponDefs[id].interceptor || weaponDefs[id].isShield);

	weaponDefs[id].onlyTargetCategory=0xffffffff;
	if(atoi(sunparser->SGetValueDef("0", weaponname + "\\toairweapon").c_str())){
		weaponDefs[id].onlyTargetCategory=CCategoryHandler::Instance()->GetCategories("VTOL");	//fix if we sometime call aircrafts otherwise
//		logOutput.Print("air only weapon %s %i",weaponname.c_str(),weaponDefs[id].onlyTargetCategory);
	}


	sunparser->GetDef(weaponDefs[id].visuals.tilelength, "200", weaponname + "\\tilelength");
	sunparser->GetDef(weaponDefs[id].visuals.scrollspeed, "5", weaponname + "\\scrollspeed");
	sunparser->GetDef(weaponDefs[id].visuals.pulseSpeed, "1", weaponname + "\\pulseSpeed");
	sunparser->GetDef(weaponDefs[id].largeBeamLaser, "0", weaponname + "\\largeBeamLaser");

	weaponDefs[id].heightmod = 0.2f;
	if(weaponDefs[id].type == "Cannon")
		weaponDefs[id].heightmod = 0.8f;

	weaponDefs[id].supplycost = 0.0f;

	weaponDefs[id].onlyForward=!weaponDefs[id].turret && weaponDefs[id].type != "StarburstLauncher";

	int color2;
	sunparser->GetDef(color2, "0", weaponname + "\\color2");

	float3 rgbcol = hs2rgb(color/float(255), color2/float(255));
	weaponDefs[id].visuals.color = rgbcol;
	weaponDefs[id].visuals.color2=sunparser->GetFloat3(float3(1,1.0f,1.0f),weaponname + "\\rgbcolor2");

	float3 tempCol=sunparser->GetFloat3(float3(-1,-1,-1),weaponname + "\\rgbcolor");
	if(tempCol!=float3(-1,-1,-1))
		weaponDefs[id].visuals.color = tempCol;

	weaponDefs[id].uptime = atof(sunparser->SGetValueDef("0", weaponname + "\\weapontimer").c_str());

	weaponDefs[id].turnrate = atof(sunparser->SGetValueDef("0", weaponname + "\\turnrate").c_str()) * PI / 0x7fff /30.0f;

	if(weaponDefs[id].type=="AircraftBomb"){
		if(weaponDefs[id].reload<0.5f){
			weaponDefs[id].salvodelay=min(0.2f,weaponDefs[id].reload);
			weaponDefs[id].salvosize=(int)(1/weaponDefs[id].salvodelay)+1;
			weaponDefs[id].reload=5;
		} else {
			weaponDefs[id].salvodelay=min(0.4f,weaponDefs[id].reload);
			weaponDefs[id].salvosize=2;			
		}
	}
//	if(!weaponDefs[id].turret && weaponDefs[id].type!="TorpedoLauncher")
//		weaponDefs[id].maxAngle*=0.4f;

	//2+min(damages[0]*0.0025f,weaponDef->areaOfEffect*0.1f)
	float tempsize = 2.0f+min(weaponDefs[id].damages[0]*0.0025f,weaponDefs[id].areaOfEffect*0.1f);
	sunparser->GetTDef(weaponDefs[id].size, tempsize , weaponname + "\\size");
	sunparser->GetDef(weaponDefs[id].sizeGrowth, "0.2", weaponname + "\\sizeGrowth");
	sunparser->GetDef(weaponDefs[id].collisionSize, "0.05", weaponname + "\\CollisionSize");
	
	weaponDefs[id].visuals.colorMap = 0;
	std::string colormap;
	colormap = sunparser->SGetValueDef("", weaponname + "\\colormap");
	if(colormap!="")
	{
		weaponDefs[id].visuals.colorMap = CColorMap::LoadFromDefString(colormap);
	}

	//get some weapon specific defaults
	if(weaponDefs[id].type=="Cannon"){
		//CExplosiveProjectile
		weaponDefs[id].visuals.texture1 = &ph->circularthingytex;
		weaponDefs[id].visuals.color=sunparser->GetFloat3(float3(1.0f,0.5f,0.0f),weaponname + "\\rgbcolor");
		sunparser->GetDef(weaponDefs[id].intensity, "0.2", weaponname + "\\intensity");
	} else if(weaponDefs[id].type=="Rifle"){
		//...
	} else if(weaponDefs[id].type=="Melee"){
		//...
	} else if(weaponDefs[id].type=="AircraftBomb"){
		//CExplosiveProjectile or CTorpedoProjectile
		weaponDefs[id].visuals.texture1 = &ph->circularthingytex;
	} else if(weaponDefs[id].type=="Shield"){
		weaponDefs[id].visuals.texture1 = &ph->perlintex;
	} else if(weaponDefs[id].type=="Flame"){
		//CFlameProjectile
		weaponDefs[id].visuals.texture1 = &ph->flametex;
		sunparser->GetTDef(weaponDefs[id].size, tempsize , weaponname + "\\size");
		sunparser->GetDef(weaponDefs[id].sizeGrowth, "0.5", weaponname + "\\sizeGrowth");
		sunparser->GetDef(weaponDefs[id].collisionSize, "0.5", weaponname + "\\CollisionSize");

		sunparser->GetDef(weaponDefs[id].duration, "1.2", weaponname + "\\flamegfxtime");

		if(weaponDefs[id].visuals.colorMap==0)
		{
			weaponDefs[id].visuals.colorMap = CColorMap::Load12f(1.0,1.0,1,0.1,
													0.025,0.025,0.025,0.1,
													0.00,0.00,0.0,0.0);
		}

	} else if(weaponDefs[id].type=="MissileLauncher"){
		//CMissileProjectile
		weaponDefs[id].visuals.texture1 = &ph->flaretex;
		weaponDefs[id].visuals.texture2 = &ph->smoketrailtex;
	} else if(weaponDefs[id].type=="TorpedoLauncher"){
		//CExplosiveProjectile or CTorpedoProjectile
		weaponDefs[id].visuals.texture1 = &ph->circularthingytex;
	} else if(weaponDefs[id].type=="LaserCannon"){
		//CLaserProjectile
		weaponDefs[id].visuals.texture1 = &ph->laserfallofftex;
		weaponDefs[id].visuals.texture2 = &ph->laserendtex;	
		sunparser->GetDef(weaponDefs[id].collisionSize, "0.5", weaponname + "\\CollisionSize");
	} else if(weaponDefs[id].type=="BeamLaser"){
		if(weaponDefs[id].largeBeamLaser)
		{
			weaponDefs[id].visuals.texture1 = ph->textureAtlas->GetTexturePtr("largebeam");
			weaponDefs[id].visuals.texture2 = &ph->laserendtex;
			weaponDefs[id].visuals.texture3 = ph->textureAtlas->GetTexturePtr("muzzleside");
			weaponDefs[id].visuals.texture4 = &ph->flaretex;
		}
		else
		{
			weaponDefs[id].visuals.texture1 = &ph->laserfallofftex;
			weaponDefs[id].visuals.texture2 = &ph->laserendtex;
			weaponDefs[id].visuals.texture3 = &ph->flaretex;
		}
	} else if(weaponDefs[id].type=="LightingCannon"){
		weaponDefs[id].visuals.texture1 = &ph->laserfallofftex;
		sunparser->GetDef(weaponDefs[id].thickness, "0.8", weaponname + "\\thickness");
	} else if(weaponDefs[id].type=="EmgCannon"){
		//CEmgProjectile
		weaponDefs[id].visuals.texture1 = &ph->circularthingytex;
		weaponDefs[id].visuals.color=sunparser->GetFloat3(float3(0.9f,0.9f,0.2f),weaponname + "\\rgbcolor");
		sunparser->GetDef(weaponDefs[id].size, "3", weaponname + "\\size");
	} else if(weaponDefs[id].type=="DGun"){
		//CFireBallProjectile
		sunparser->GetDef(weaponDefs[id].collisionSize, "10", weaponname + "\\CollisionSize");
	} else if(weaponDefs[id].type=="StarburstLauncher"){
		//CStarburstProjectile
		weaponDefs[id].visuals.texture1 = &ph->flaretex;
		weaponDefs[id].visuals.texture2 = &ph->smoketrailtex;
		weaponDefs[id].visuals.texture3 = &ph->explotex;
	}else {
		weaponDefs[id].visuals.texture1 = &ph->circularthingytex;
		weaponDefs[id].visuals.texture2 = &ph->circularthingytex;
	}
	std::string tmp;
	sunparser->GetDef(tmp, "", weaponname + "\\texture1");
	if(tmp != "")
		weaponDefs[id].visuals.texture1 = ph->textureAtlas->GetTexturePtr(tmp);
	sunparser->GetDef(tmp, "", weaponname + "\\texture2");
	if(tmp != "")
		weaponDefs[id].visuals.texture2 = ph->textureAtlas->GetTexturePtr(tmp);
	sunparser->GetDef(tmp, "", weaponname + "\\texture3");
	if(tmp != "")
		weaponDefs[id].visuals.texture3 = ph->textureAtlas->GetTexturePtr(tmp);
	sunparser->GetDef(tmp, "", weaponname + "\\texture4");
	if(tmp != "")
		weaponDefs[id].visuals.texture4 = ph->textureAtlas->GetTexturePtr(tmp);

	std::string explgentag = sunparser->SGetValueDef(std::string(), weaponname + "\\explosiongenerator");
	weaponDefs[id].explosionGenerator = explgentag.empty() ? 0 : explGenHandler->LoadGenerator(explgentag);

	float gd=max(30.f,weaponDefs[id].damages[0]/20);
	//weaponDefs[id].explosionSpeed = (8+gd*2.5f)/(9+sqrtf(gd)*0.7f)*0.5f;
	sunparser->GetTDef(weaponDefs[id].explosionSpeed, (8+gd*2.5f)/(9+sqrtf(gd)*0.7f)*0.5f , weaponname + "\\explosionSpeed");


	weaponDefs[id].id = id;
	weaponID[weaponname] = id;
}

void CWeaponDefHandler::LoadSound(GuiSound &gsound)
{
	// gsound.volume = 5.0f;
	if (gsound.name.compare("") == 0) {
		gsound.id = 0;
		return;
	}

	if (gsound.name.find(".wav") == -1) {
		gsound.name = gsound.name + ".wav";
	}

	const string soundPath = "sounds/" + gsound.name;
	CFileHandler sfile(soundPath);
	if (!sfile.FileExists()) {
		gsound.id = 0;
		return;
	}
	PUSH_CODE_MODE;
	ENTER_UNSYNCED;
	int id = sound->GetWaveId(soundPath);
	POP_CODE_MODE;
	gsound.id = id;
}


WeaponDef *CWeaponDefHandler::GetWeapon(const std::string weaponname2)
{
	std::string weaponname(StringToLower(weaponname2));

	std::map<std::string,int>::iterator ii=weaponID.find(weaponname);
	if(ii == weaponID.end())
		return NULL;

	return &weaponDefs[ii->second];
}

float3 CWeaponDefHandler::hs2rgb(float h, float s)
{
	if(h>0.5f)
		h+=0.1f;
	if(h>1)
		h-=1;

	s=1;
	float invSat=1-s;
	float3 col(invSat/2,invSat/2,invSat/2);

	if(h<1/6.0f){
		col.x+=s;
		col.y+=s*(h*6);
	} else if(h<1/3.0f){
		col.y+=s;
		col.x+=s*((1/3.0f-h)*6);

	} else if(h<1/2.0f){
		col.y+=s;
		col.z+=s*((h-1/3.0f)*6);

	} else if(h<2/3.0f){
		col.z+=s;
		col.y+=s*((2/3.0f-h)*6);

	} else if(h<5/6.0f){
		col.z+=s;
		col.x+=s*((h-2/3.0f)*6);

	} else {
		col.x+=s;
		col.z+=s*((3/3.0f-h)*6);
	}
	return col;
}

WeaponDef::~WeaponDef() {
}
