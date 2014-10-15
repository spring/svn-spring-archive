#ifndef __COB_INSTANCE_H__
#define __COB_INSTANCE_H__

#include <string>
#include <vector>
#include <list>

#define TAANG2RAD 10430.219207445624753419256949178f
#define RAD2TAANG 9.587526207370107576104371709781e-5f

#include "Object.h"
#include "Rendering/UnitModels/IModelAnimator.h"

class CCobThread;
class CCobFile;
class CCobInstance;
class CUnit;
class CModel;

using namespace std;

struct ModelPieceInfo;

struct CobPieceInfo {
	CobPieceInfo() { }
	int coords[3];
	int rot[3];
	bool updated;
	bool visible;
	int scriptIndex;
	ModelPieceInfo *mpi;
};

class CCobInstance : public CObject, public IModelAnimator
{
protected:
	CCobFile &script;
	enum AnimType {ATurn, ASpin, AMove};
	struct AnimInfo {
		AnimType type;
		int axis;
		int piece; // script piece index
		int speed;
		int dest;		//means final position when turning or moving, final speed when spinning
		int accel;		//used for spinning, can be negative
		bool interpolated;	//true if this animation is a result of interpolating a direct move/turn
		list<CCobThread *> listeners;
	};
	list<struct AnimInfo *> anims;
	CUnit *unit;
	bool yardOpen;
	void UnblockAll(struct AnimInfo * anim);
	int FindScriptPiece(const std::string& name);
	bool PieceExists(int piece);
	int NumScriptPieces() { return (int)scriptToModelIndex.size(); }

	// IModelAnimator interface
	void GetNodeTransform(int modelPiece, CMatrix44f& transform);
	void GetAbsoluteNodeTransform(int modelPiece, CMatrix44f& transform);
	bool IsNodeVisible(int node);
	// Play/activate certain animations
	void AnimAction(AnimActionType actionType, std::vector<int>& args);
	// Play/activate certain animations - single parameter.
	void AnimAction(AnimActionType actionType, int param);
	// Play/activate certain animations - parameterless.
	void AnimAction(AnimActionType actionType);
	// Play/activate certain animations - with finish callback.
	void AnimAction(AnimActionType actionType, std::vector<int>& args, CBAnimFinished cb, void *p1, void *p2);
	bool IsBusy();
	bool SupportsAction(AnimActionType actionType);
	AnimActionType GetActionType(const char *name);

/*
As a convention: parameters called "modelPiece" are model piece indices,
 all indices named otherwise are script piece indices
*/
	vector<int> scriptToModelIndex; // script index -> model index
	CobPieceInfo& PieceByScriptIndex(int scriptPiece) { return pieces[scriptToModelIndex[scriptPiece]]; }

public:
	bool busy;
	vector<int> staticVars;
	list<CCobThread *> threads;
	vector<CobPieceInfo> pieces; // indexed by model indices

	bool smoothAnim;
public:
	CCobInstance(CCobFile &script, CUnit *unit);
	~CCobInstance(void);
	void InitVars();
	int Call(const string &fname);
	int Call(const string &fname, int p1);
	int Call(const string &fname, vector<int> &args);
	int Call(const string &fname, CBAnimFinished cb, void *p1, void *p2);
	int Call(const string &fname, vector<int> &args, CBAnimFinished cb, void *p1, void *p2);
	int Call(int id);
	int Call(int id, vector<int> &args);
	int Call(int id, int p1);
	int Call(int id, CBAnimFinished cb, void *p1, void *p2);
	int Call(int id, vector<int> &args, CBAnimFinished cb, void *p1, void *p2);
	int RealCall(int functionId, vector<int> &args, CBAnimFinished cb, void *p1, void *p2);
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
	void MoveSmooth(int piece, int axis, int destination, int delta, int deltaTime);
	void TurnSmooth(int piece, int axis, int destination, int delta, int deltaTime);
};

#endif // __COB_INSTANCE_H__
