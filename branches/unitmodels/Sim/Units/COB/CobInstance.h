#ifndef __COB_INSTANCE_H__
#define __COB_INSTANCE_H__

#include <string>
#include <vector>
#include <list>

#define TAANG2RAD 10430.219207445624753419256949178f
#define RAD2TAANG 9.587526207370107576104371709781e-5f

#include "Object.h"

class CCobThread;
class CCobFile;
class CCobInstance;
class CUnit;
class IModelInstance;

typedef void (*CBCobThreadFinish) (int retCode, void *p1, void *p2);

struct PieceInfo {
	int coords[3];
	int rot[3];
	std::string name;
	bool updated;
	bool visible;
	int modelPieceIndex;
};

class CCobInstance : public CObject
{
protected:
	CCobFile &script;
	enum AnimType {ATurn, ASpin, AMove};
	struct AnimInfo {
		AnimType type;
		int axis;
		int piece;
		int speed;
		int dest;		//means final position when turning or moving, final speed when spinning
		int accel;		//used for spinning, can be negative
		bool interpolated;	//true if this animation is a result of interpolating a direct move/turn
		std::list<CCobThread *> listeners;
	};
	std::list<struct AnimInfo *> anims;
	CUnit *unit;
	bool yardOpen;
	void UnblockAll(struct AnimInfo * anim);
	int FindModelPiece(const std::string& name, IModelInstance* inst);
	void UpdatePieceTransform(int mdlPiece);
	bool PieceExists(int piece);

public:
	bool busy;
	std::vector<int> staticVars;
	std::list<CCobThread *> threads;
	std::vector<struct PieceInfo> pieces;	
	std::vector<int> modelPiece2Script;
	bool smoothAnim;
public:
	CCobInstance(CCobFile &script, CUnit *unit);
	~CCobInstance(void);
	void InitVars();
	int Call(const std::string &fname);
	int Call(const std::string &fname, int p1);
	int Call(const std::string &fname, std::vector<int> &args);
	int Call(const std::string &fname, CBCobThreadFinish cb, void *p1, void *p2);
	int Call(const std::string &fname, std::vector<int> &args, CBCobThreadFinish cb, void *p1, void *p2);
	int Call(int id);
	int Call(int id, std::vector<int> &args);
	int Call(int id, int p1);
	int Call(int id, CBCobThreadFinish cb, void *p1, void *p2);
	int Call(int id, std::vector<int> &args, CBCobThreadFinish cb, void *p1, void *p2);
	int RealCall(int functionId, std::vector<int> &args, CBCobThreadFinish cb, void *p1, void *p2);
	int Tick(int deltaTime);
	int MoveToward(int &cur, int dest, int speed);
	int TurnToward(int &cur, int dest, int speed);
	int DoSpin(int &cur, int dest, int &speed, int accel, int divisor);
	void Spin(int piece, int axis, int speed, int accel);
	void StopSpin(int piece, int axis, int decel);
	void Turn(int piece, int axis, int speed, int destination, bool interpolated = false);
	void Move(int piece, int axis, int speed, int destination, bool interpolated = false);
	void MoveNow(int piece, int axis, int destination);
	void TurnNow(int piece, int axis, int destination);
	void SetVisibility(int piece, bool visible);
	void EmitSfx(int type, int piece);
	void AttachUnit(int piece, int unit);
	void DropUnit(int unit);
	struct AnimInfo *FindAnim(AnimType anim, int piece, int axis);
	void RemoveAnim(AnimType anim, int piece, int axis);
	void AddAnim(AnimType type, int piece, int axis, int speed, int dest, int accel, bool interpolated = false);
	int AddTurnListener(int piece, int axis, CCobThread *listener);
	int AddMoveListener(int piece, int axis, CCobThread *listener);
	void Signal(int signal);
	int GetUnitVal(int val, int p1, int p2, int p3, int p4);
	void SetUnitVal(int val, int param);
	void Explode(int piece, int flags);
	void PlayUnitSound(int snr, int attr);
	void ShowFlare(int piece);
	bool HasScriptFunction(int id);
	void MoveSmooth(int piece, int axis, int destination, int delta, int deltaTime);
	void TurnSmooth(int piece, int axis, int destination, int delta, int deltaTime);
	void UpdateModelState();
};

#endif // __COB_INSTANCE_H__
