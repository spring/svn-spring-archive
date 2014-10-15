%module upspring
%{
#include "EditorIncl.h"
#include "EditorDef.h"

#include "ScriptInterface.h"
#include "../Model.h"
#include "DebugTrace.h"
%}

%ignore CR_DECLARE;
%ignore CR_DECLARE_STRUCT;
%ignore NO_SCRIPT;

%include "vector.i"
%rename(cppstring) string;
%include "std_string.i"
%include "list.i"
namespace std{ 
	%template(IntArray) vector<int>; 
	%template(FloatArray) vector<float>;
	%template(CharArray) vector<char>;
	%template(ShortArray) vector<short>;
}

namespace creg { class BaseObject {}; }

%include "../DebugTrace.h"
%include "../math/Mathlib.h"
%include "../Model.h"
%include "../Animation.h"
%include "../IEditor.h"
%include "ScriptInterface.h"

namespace std{
	%template(PolyRefArray) vector<Poly*>;
	%template(VertexArray) vector<Vertex>;
	%template(ObjectRefArray) vector<MdlObject*>;
	%template(AnimationInfoRefArray) vector<AnimationInfo*>;
	%template(AnimationInfoList) list<AnimationInfo>;
	%template(AnimInfoListIt)  list_iterator<AnimationInfo>;
	%template(AnimInfoListRevIt)  list_reverse_iterator<AnimationInfo>;
	%template(AnimPropertyList) list<AnimProperty>;
	%template(AnimPropListIt) list_iterator<AnimProperty>;
	%template(AnimPropListRevIt) list_reverse_iterator<AnimProperty>;
	%template(AnimPropertyRefArray) vector<AnimProperty*>;
}

namespace fltk{
void message(const char *fmt, ...);
}

// ---------------------------------------------------------------
// Script util functions
// ---------------------------------------------------------------

%inline %{
Model* upsGetModel() { return upsGetEditor()->GetMdl(); }
MdlObject* upsGetRootObj() { return upsGetEditor()->GetMdl()->root; }
void upsUpdateViews() { upsGetEditor()->Update(); }
bool _upsFileSaveDlg (const char *msg, const char *pattern, string& fn) { return FileSaveDlg(msg, pattern, fn); }
bool _upsFileOpenDlg (const char *msg, const char *pattern, string& fn) { return FileOpenDlg(msg, pattern, fn); }
%}

// ---------------------------------------------------------------
// Animation reading helpers
// ---------------------------------------------------------------

%inline %{
#define ANIMTYPE_FLOAT 0
#define ANIMTYPE_VECTOR3 1
#define ANIMTYPE_ROTATION 2
#define ANIMTYPE_OTHER 3

int upsAnimGetType(AnimProperty& prop) {
	switch(prop.controller->GetType()) {
	case AnimController::ANIMKEY_Float: return ANIMTYPE_FLOAT;
	case AnimController::ANIMKEY_Vector3: return ANIMTYPE_VECTOR3;
	case AnimController::ANIMKEY_Quat: return ANIMTYPE_ROTATION;
	case AnimController::ANIMKEY_Other: return ANIMTYPE_OTHER;
	}
	return -1;
}

int upsAnimGetKeyIndex(AnimProperty& prop, float time) {
	return prop.GetKeyIndex(time);
}

int upsAnimGetNumKeys(AnimProperty& prop) {
	return prop.NumKeys();
}

float upsAnimGetKeyTime(AnimProperty& prop, int key) {
	if(key<0) key=0;
	if(key>=prop.NumKeys()) key=prop.NumKeys()-1;
	return prop.GetKeyTime(key);
}

float upsAnimGetFloatKey(AnimProperty& prop, int key) {
	if(key<0) key=0;
	if(key>=prop.NumKeys()) key=prop.NumKeys()-1;
	if (prop.controller->GetType() == AnimController::ANIMKEY_Float)
		return *(float*)prop.GetKeyData(key);
	return 0.0f;
}

Vector3 upsAnimGetVector3Key(AnimProperty& prop, int key) {
	if(key<0) key=0;
	if(key>=prop.NumKeys()) key=prop.NumKeys()-1;
	if (prop.controller->GetType() == AnimController::ANIMKEY_Vector3)
		return *(Vector3*)prop.GetKeyData(key);
	return Vector3();
}

Vector3 upsAnimGetRotationKey(AnimProperty& prop, int key) {
	if(key<0) key=0;
	if(key>=prop.NumKeys()) key=prop.NumKeys()-1;
	if (prop.controller->GetType() == AnimController::ANIMKEY_Quat) {
		Quaternion q = *(Quaternion*)prop.GetKeyData(key);
		Rotator rot;
		rot.q = q;
		return rot.GetEuler();
	}
	return Vector3();
}

%}

