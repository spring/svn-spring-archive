// Generalized callback interface - shared between global AI and group AI
#ifndef IAICALLBACK_H
#define IAICALLBACK_H
#include <vector>
#include <deque>
#include "aibase.h"
#include "float3.h"
#include "Sim/Units/CommandAI/Command.h"
#include "Sim/Units/CommandAI/CommandQueue.h"
struct UnitDef;
struct FeatureDef;
struct WeaponDef;
class CCommandQueue;

// GetProperty() constants ------------ data type that buffer will be filled with:
#define AIVAL_UNITDEF					1 // const UnitDef*
#define AIVAL_CURRENT_FUEL				2 // float
#define AIVAL_STOCKPILED				3 // int
#define AIVAL_STOCKPILE_QUED			4 // int
#define AIVAL_UNIT_MAXSPEED				5 // float

// GetValue() constants
#define AIVAL_NUMDAMAGETYPES			1 // int
#define AIVAL_EXCEPTION_HANDLING		2 // bool
#define AIVAL_MAP_CHECKSUM				3 // unsinged int
#define AIVAL_DEBUG_MODE				4 // bool
#define AIVAL_GAME_MODE					5 // int
#define AIVAL_GAME_PAUSED				6 // bool
#define AIVAL_GAME_SPEED_FACTOR			7 // float
#define AIVAL_GUI_VIEW_RANGE			8 // float
#define AIVAL_GUI_SCREENX				9 // float
#define AIVAL_GUI_SCREENY				10 // float
#define AIVAL_GUI_CAMERA_DIR			11 // float3
#define AIVAL_GUI_CAMERA_POS			12 // float3
#define AIVAL_LOCATE_FILE_R				15 // char*
#define AIVAL_LOCATE_FILE_W				16 // char*
#define AIVAL_UNIT_LIMIT				17 // int
#define AIVAL_SCRIPT					18 // const char* - buffer for pointer to char

struct UnitResourceInfo
{
	float metalUse;
	float energyUse;
	float metalMake;
	float energyMake;
};

struct PointMarker
{
	float3 pos;
	unsigned char* color;
	// don't store this pointer anywhere, it may become
	// invalid at any time after GetMapPoints()
	const char* label;
};

struct LineMarker {
	float3 pos;
	float3 pos2;
	unsigned char* color;
};

// HandleCommand structs:

#define AIHCQuerySubVersionId 0
#define AIHCAddMapPointId 1
#define AIHCAddMapLineId 2
#define AIHCRemoveMapPointId 3
#define AIHCSendStartPosId 4

struct AIHCAddMapPoint ///< result of HandleCommand is 1 - ok supported
{
	float3 pos; ///< on this position, only x and z matter
	char* label; ///< create this text on pos in my team color
};

struct AIHCAddMapLine ///< result of HandleCommand is 1 - ok supported
{
	float3 posfrom; ///< draw line from this pos
	float3 posto; ///< to this pos, again only x and z matter
};

struct AIHCRemoveMapPoint ///< result of HandleCommand is 1 - ok supported
{
	float3 pos; ///< remove map points and lines near this point (100 distance)
};

struct AIHCSendStartPos ///< result of HandleCommand is 1 - ok supported
{
	bool ready;
	float3 pos;
};


class SPRING_API IAICallback
{
public:
	virtual void SendTextMsg(const char* text, int zone) = 0;
	virtual void SetLastMsgPos(float3 pos) = 0;
	virtual void AddNotification(float3 pos, float3 color, float alpha) = 0;

	// give <mAmount> of metal and <eAmount> of energy to <receivingTeam>
	// * the amounts are capped to the AI team's resource levels
	// * does not check for alliance with <receivingTeam>
	// * LuaRules might not allow resource transfers, AI's must verify the deduction
	virtual bool SendResources(float mAmount, float eAmount, int receivingTeam) = 0;
	// give units to <receivingTeam>, the return value represents how many
	// actually were transferred (make sure this always matches the size of
	// the vector you pass in, if not then some unitID's were filtered out)
	// * does not check for alliance with <receivingTeam>
	// * AI's should check each unit if it is still under control of their
	//   team after the transaction via UnitTaken() and UnitGiven(), since
	//   LuaRules might block part of it
	virtual int SendUnits(const std::vector<int>& unitIDs, int receivingTeam) = 0;

	// checks if pos is within view of the current camera, using radius as a margin
	virtual bool PosInCamera(float3 pos, float radius) = 0;

	// get the current game time measured in frames (the
	// simulation runs at 30 frames per second at normal
	// speed)
	virtual int GetCurrentFrame() = 0;

	virtual int GetMyTeam() = 0;
	virtual int GetMyAllyTeam() = 0;
	virtual int GetPlayerTeam(int player) = 0;
	virtual const char* GetTeamSide(int team) = 0;

	// returns the size of the created area, this is initialized to all 0 if not previously created
	// set something to !0 to tell other AI's that the area is already initialized when they try to
	// create it (the exact internal format of the memory areas is up to the AI's to keep consistent)
	virtual void* CreateSharedMemArea(char* name, int size) = 0;
	// release your reference to a memory area
	virtual void ReleasedSharedMemArea(char* name) = 0;

	virtual int CreateGroup(char* dll, unsigned aiNumber) = 0;							// creates a group and return the id it was given, return -1 on
																						// failure (dll didn't exist, etc)
	virtual void EraseGroup(int groupid) = 0;											// erases a specified group
	virtual bool AddUnitToGroup(int unitid, int groupid) = 0;							// adds a unit to a specific group, if it was previously in a group
																						// it is removed from that, return false if the group didn't exist
																						// or didn't accept the unit
	virtual bool RemoveUnitFromGroup(int unitid) = 0;									// removes a unit from its group
	virtual int GetUnitGroup(int unitid) = 0;											// returns the group a unit belongs to, -1 if none
	virtual const std::vector<CommandDescription>* GetGroupCommands(int unitid) = 0;	// the commands that this unit can understand, other commands will be ignored
	virtual int GiveGroupOrder(int unitid, Command* c) = 0;

	virtual int GiveOrder(int unitid, Command* c) = 0;

	virtual const std::vector<CommandDescription>* GetUnitCommands(int unitid) = 0;
	virtual const CCommandQueue* GetCurrentUnitCommands(int unitid) = 0;

	// these functions always work on allied units, but for
	// enemies only when you have LOS on them (so watch out
	// when calling GetUnitDef)
	virtual int GetUnitAiHint(int unitid) = 0;				// integer telling something about the units main function, not implemented yet
	virtual int GetUnitTeam(int unitid) = 0;
	virtual int GetUnitAllyTeam(int unitid) = 0;
	virtual float GetUnitHealth(int unitid) = 0;			// the unit's current health
	virtual float GetUnitMaxHealth(int unitid) = 0;			// the unit's max health
	virtual float GetUnitSpeed(int unitid) = 0;				// the unit's max speed
	virtual float GetUnitPower(int unitid) = 0;				// sort of the measure of the units overall power
	virtual float GetUnitExperience(int unitid) = 0;		// how experienced the unit is (0.0f-1.0f)
	virtual float GetUnitMaxRange(int unitid) = 0;			// the furthest any weapon of the unit can fire
	virtual bool IsUnitActivated (int unitid) = 0;
	virtual bool UnitBeingBuilt(int unitid) = 0;			// true if the unit is currently being built
	virtual const UnitDef* GetUnitDef(int unitid) = 0;		// returns the unit's unitdef struct from which you can read all the
															// statistics of the unit, do NOT try to change any values in it
	virtual float3 GetUnitPos(int unitid) = 0;
	virtual int GetBuildingFacing(int unitid) = 0;			// returns the unit's build facing (0-3)
	virtual bool IsUnitCloaked(int unitid) = 0;
	virtual bool IsUnitParalyzed(int unitid) = 0;
	virtual bool IsUnitNeutral(int unitid) = 0;
	virtual bool GetUnitResourceInfo(int unitid, UnitResourceInfo* resourceInfo) = 0;

	virtual const UnitDef* GetUnitDef(const char* unitName) = 0;

	// the following functions allow the dll to use the built-in pathfinder
	// * call InitPath and you get a pathid back
	// * use this to call GetNextWaypoint to get subsequent waypoints, the waypoints are centered on 8*8 squares
	// * note that the pathfinder calculates the waypoints as needed so don't retrieve them until they are needed
	// * the waypoint's x and z coordinates are returned in x and z while y is used for error codes
	//   y >= 0: worked ok, y = -2: still thinking call again, y = -1: end of path reached or invalid path
	virtual int InitPath(float3 start, float3 end, int pathType) = 0;
	virtual float3 GetNextWaypoint(int pathid) = 0;
	virtual void FreePath(int pathid) = 0;

	// returns the approximate path cost between two points(note that
	// it needs to calculate the complete path so somewhat expensive)
	// note: currently disabled, always returns 0
	virtual float GetPathLength(float3 start, float3 end, int pathType) = 0;

	// the following function return the units into arrays that must be allocated by the dll
	// * 10000 is currently the max amount of units so that should be a safe size for the array
	// * the return value indicates how many units were returned, the rest of the array is unchanged
	// * all forms of GetEnemyUnits and GetFriendlyUnits filter out any neutrals, use the GetNeutral
	//   callbacks to retrieve them
	virtual int GetEnemyUnits(int* units) = 0;										// returns all known (in LOS) enemy units
	virtual int GetEnemyUnits(int* units, const float3& pos, float radius) = 0;		// returns all known enemy units within radius from pos
	virtual int GetEnemyUnitsInRadarAndLos(int* units) = 0;							// returns all enemy units in radar and los
	virtual int GetFriendlyUnits(int* units) = 0;									// returns all friendly units
	virtual int GetFriendlyUnits(int* units, const float3& pos, float radius) = 0;	// returns all friendly units within radius from pos
	virtual int GetNeutralUnits(int* units) = 0;									// returns all known (in LOS) neutral units
	virtual int GetNeutralUnits(int* units, const float3& pos, float radius) = 0;	// returns all known neutral units within radius from pos

	// the following functions are used to get information about the map
	// * do NOT modify or delete any of the pointers returned
	// * the maps are stored from top left and each data position is 8*8 in size
	// * to get info about a position (x, y) look at location (int(y / 8)) * GetMapWidth() + (int(x / 8))
	// * note that some of the type-maps are stored in a lower resolution than this
	virtual int GetMapWidth() = 0;
	virtual int GetMapHeight() = 0;
	virtual const float* GetHeightMap() = 0;			// this is the height for the center of the squares, this differs slightly from the drawn map since it uses the height at the corners
	virtual float GetMinHeight() = 0;					// readmap->minHeight
	virtual float GetMaxHeight() = 0;					// readmap->maxHeight
	virtual const float* GetSlopeMap() = 0;				// slopemap, half the resolution of the standard map (values are 1
														// minus the y-component of the (average) facenormal of the square)
	virtual const unsigned short* GetLosMap() = 0;		// a square with value zero means you don't have LOS coverage on it, half the resolution of the standard map
	virtual const unsigned short* GetRadarMap() = 0;	// a square with value zero means you don't have radar coverage on it, 1/8 the resolution of the standard map
	virtual const unsigned short* GetJammerMap() = 0;	// a square with value zero means you don't have radar jamming coverage on it, 1/8 the resolution of the standard map
	virtual const unsigned char* GetMetalMap() = 0;		// this map shows the metal density on the map, half the resolution of the standard map
	virtual const char* GetMapName() = 0;
	virtual const char* GetModName() = 0;

	virtual float GetElevation(float x, float z) = 0;	// gets the elevation of the map at position (x, z)

	virtual float GetMaxMetal() = 0;					// returns what metal value 255 in the metal map is worth
	virtual float GetExtractorRadius() = 0;				// returns extraction radius for metal extractors
	virtual float GetMinWind() = 0;
	virtual float GetMaxWind() = 0;
	virtual float GetTidalStrength() = 0;
	virtual float GetGravity() = 0;

	// linedrawer interface functions
	// * these allow you to draw command-like lines and figures
	// * use these only from within CGroupAI::DrawCommands()
	virtual void LineDrawerStartPath(const float3& pos, const float* color) = 0;
	virtual void LineDrawerFinishPath() = 0;
	virtual void LineDrawerDrawLine(const float3& endPos, const float* color) = 0;
	virtual void LineDrawerDrawLineAndIcon(int cmdID, const float3& endPos, const float* color) = 0;
	virtual void LineDrawerDrawIconAtLastPos(int cmdID) = 0;
	virtual void LineDrawerBreak(const float3& endPos, const float* color) = 0;
	virtual void LineDrawerRestart() = 0;
	virtual void LineDrawerRestartSameColor() = 0;

	// the following functions allow the AI to draw figures in the world
	// * each figure is part of a group
	// * when creating figures use 0 as group to get a new one, the return value is the new group
	// * the lifetime is how many frames a figure should live before being autoremoved, 0 means no removal
	// * arrow != 0 means that the figure will get an arrow at the end
	//
	// creates a cubic Bezier spline figure (from pos1 to pos4 with control points pos2 and pos3)
	virtual int CreateSplineFigure(float3 pos1, float3 pos2, float3 pos3, float3 pos4, float width, int arrow, int lifetime, int group) = 0;
	virtual int CreateLineFigure(float3 pos1, float3 pos2, float width, int arrow, int lifetime, int group) = 0;
	virtual void SetFigureColor(int group, float red, float green, float blue, float alpha) = 0;
	virtual void DeleteFigureGroup(int group) = 0;

	// this function allows you to draw units in the map
	// * they only show up on the local player's screen
	// * they will be drawn in the "standard pose" (as if before any COB scripts are run)
	// * the rotation is in radians, team affects the color of the unit
	virtual void DrawUnit(const char* name, float3 pos, float rotation, int lifetime, int team, bool transparent, bool drawBorder, int facing = 0) = 0;

	virtual bool CanBuildAt(const UnitDef* unitDef, float3 pos, int facing = 0) = 0;
	// returns the closest position from a given position that the building can be built at
	// minDist is the distance in squares that the building must keep to other buildings (to
	// make it easier to create paths through a base)
	virtual float3 ClosestBuildSite(const UnitDef* unitdef, float3 pos, float searchRadius, int minDist, int facing = 0) = 0;

	// for certain future callback extensions
	virtual bool GetProperty(int id, int property, void* dst) = 0;
	virtual bool GetValue(int id, void* dst) = 0;
	virtual int HandleCommand(int commandId, void* data) = 0;

	virtual int GetFileSize(const char* name) = 0;								// return -1 when the file doesn't exist
	virtual bool ReadFile(const char* name, void* buffer, int bufferLen) = 0;	// returns false when file doesn't exist or buffer is too small

	// added by alik
	virtual int GetSelectedUnits(int* units) = 0;
	virtual float3 GetMousePos() = 0;
	virtual int GetMapPoints(PointMarker* pm, int maxPoints) = 0;
	virtual int GetMapLines(LineMarker* lm, int maxLines) = 0;

	virtual float GetMetal() = 0;					// current metal level for team
	virtual float GetMetalIncome() = 0;				// current metal income for team
	virtual float GetMetalUsage() = 0;				// current metal usage for team
	virtual float GetMetalStorage() = 0;			// curent metal storage capacity for team

	virtual float GetEnergy() = 0;					// current energy level for team
	virtual float GetEnergyIncome() = 0;			// current energy income for team
	virtual float GetEnergyUsage() = 0;				// current energy usage for team
	virtual float GetEnergyStorage() = 0;			// curent energy storage capacity for team

	virtual int GetFeatures(int *features, int max) = 0;
	virtual int GetFeatures(int *features, int max, const float3& pos, float radius) = 0;
	virtual const FeatureDef* GetFeatureDef(int feature) = 0;
	virtual float GetFeatureHealth(int feature) = 0;
	virtual float GetFeatureReclaimLeft(int feature) = 0;
	virtual float3 GetFeaturePos(int feature) = 0;

	virtual int GetNumUnitDefs() = 0;
	virtual void GetUnitDefList(const UnitDef** list) = 0;
	virtual float GetUnitDefHeight(int def) = 0;	// forces loading of the unit model
	virtual float GetUnitDefRadius(int def) = 0;	// forces loading of the unit model

	virtual const WeaponDef* GetWeapon(const char* weaponname) = 0;

	virtual const float3* GetStartPos() = 0;

	// NOTES:
	// 1. 'data' can be setup to NULL to skip passing in a string
	// 2. if inSize is less than 0, the data size is calculated using strlen()
	// 3. the return data is subject to lua garbage collection,
	//    copy it if you wish to continue using it
	virtual const char* CallLuaRules(const char* data, int inSize = -1, int* outSize = NULL) = 0;

	DECLARE_PURE_VIRTUAL(~IAICallback())
};

#endif /* IAICALLBACK_H */
