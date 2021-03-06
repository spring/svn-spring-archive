// AirCAI.h: Air command AI
///////////////////////////////////////////////////////////////////////////

#ifndef __AIR_CAI_H__
#define __AIR_CAI_H__

#include "CommandAI.h"

class CAirCAI :
	public CCommandAI
{
public:
	CAirCAI(CUnit* owner);
	~CAirCAI(void);

	int GetDefaultCmd(CUnit* pointed,CFeature* feature);
	void SlowUpdate();
	void GiveCommand(Command &c);
	void DrawCommands(void);
	void AddUnit(CUnit* unit);
	void FinishCommand(void);
	void BuggerOff(float3 pos, float radius);

	float3 goalPos;
	float3 patrolGoal;

	float3 basePos;
	float3 baseDir;

	bool tempOrder;

	int activeCommand;
	int targetAge;
	unsigned int patrolTime;

	float3 commandPos1;		//used to limit how far away stuff can fly from path
	float3 commandPos2;
};

#endif // __AIR_CAI_H__
