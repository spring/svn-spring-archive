//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#ifndef JC_MODEL_H
#define JC_MODEL_H
#include "IView.h"
#include "Animation.h"

#define MAPPING_S3O 0
#define MAPPING_3DO 1

using namespace std;

class Texture;

struct Poly;
struct Vertex;
struct MdlObject;
struct Model;
struct IKinfo;

struct Triangle
{
	CR_DECLARE_STRUCT(Triangle);

	Triangle(){vrt[0]=vrt[1]=vrt[2]=0;}
	int vrt[3];
};


struct Vertex
{
	CR_DECLARE_STRUCT(Vertex);

	Vector3 pos, normal;
	Vector2 tc[1];
};

struct Poly : public creg::BaseObject
{
	CR_DECLARE(Poly);

	Poly ();
	~Poly ();

	Plane CalcPlane(const vector<Vertex>& verts);
	void Flip();
	Poly* Clone();
	void RotateVerts();

	vector <int> verts;
	string texname;
	Vector3 color;
	int taColor; // TA indexed color
	Texture *texture;

	bool isSelected;

#ifndef SWIG
	struct Selector : ViewSelector {
		Selector(Poly *poly) : poly(poly),object(0) {}
		float Score(Vector3 &pos, float camdis);
		void Toggle (Vector3 &pos, bool bSel);
		bool IsSelected ();
		Poly *poly;
		MdlObject *object;
	};

	Selector *selector;
#endif
};

// Inverse Kinematics joint types - these use the same naming as ODE
enum IKJointType
{
	IKJT_Fixed=0,
	IKJT_Hinge=1,  // rotation around an axis
	IKJT_Universal=2,  // 2 axis
};

struct BaseJoint : public creg::BaseObject
{
	CR_DECLARE(BaseJoint);

	virtual ~BaseJoint() {}
};

struct HingeJoint : public BaseJoint
{
	CR_DECLARE(HingeJoint);

	Vector3 axis;
};

struct UniversalJoint : public BaseJoint
{
	CR_DECLARE(UniversalJoint);

	Vector3 axis[2];
};

struct IKinfo
{
	CR_DECLARE(IKinfo);

	IKinfo();
	~IKinfo();

	IKJointType jointType;
	BaseJoint* joint;
};

struct IRenderData
{
	virtual ~IRenderData() {}
	virtual void Invalidate () = 0;
};

class Rotator
{
public:
	CR_DECLARE(Rotator);

	Rotator();
	void AddEulerAbsolute(const Vector3& rot);
	void AddEulerRelative(const Vector3& rot);
	Vector3 GetEuler();
	void SetEuler(Vector3 euler);
	void ToMatrix(Matrix& o);
	void FromMatrix(const Matrix& r);

	Quaternion q;
	bool eulerInterp; // Use euler angles to interpolate
};

struct MdlObject : public creg::BaseObject
{
	CR_DECLARE(MdlObject);

	MdlObject ();
	virtual ~MdlObject ();

	bool IsEmpty ();
	void Dump (int r=0);
	vector<Triangle> MakeTris();
	void MergeChild (MdlObject *ch);
	void FullMerge (); // merge all childs and their subchilds
	void GetTransform (Matrix& tr); // calculates the object space -> parent space transform
	void GetFullTransform (Matrix& tr); // object space -> world space
	void MoveGeometry (MdlObject *dst);

	void UnlinkFromParent ();
	void LinkToParent (MdlObject *p);

	void Load3DOTextures(TextureHandler *th);

	bool HasSelectedParent ();
	
	void ApplyTransform (bool rotation, bool scaling, bool position);

	void TransformVertices (const Matrix& transform);
	void ApproximateOffset ();
	void CalculateNormals();
	void SetPropertiesFromMatrix(Matrix& transform);
	// Apply transform to contents of object, 
	// does not touch the properties such as position/scale/rotation
	void Transform(const Matrix& matrix);

	// deletes redundant vertices
	void OptimizeVertices ();
	void Optimize();

	void InvalidateRenderData ();
	void NormalizeNormals ();

	virtual void InitAnimationInfo ();
	void UpdateAnimation (float time);

	MdlObject *Clone();

	vector <Poly*> poly;
	vector <Vertex> verts;
	vector <MdlObject*> childs;

	// Orientation
    Vector3 position;
	Rotator rotation;
	Vector3 scale;

	AnimationInfo animInfo;

	string name;
	bool isSelected;
	bool isOpen; // childs visible in object browser
	MdlObject *parent;
	IKinfo ikInfo;

#ifndef SWIG
	struct Selector : ViewSelector
	{
		Selector(MdlObject *obj) : obj(obj) {}
		// Is pos contained by this object?
		float Score (Vector3 &pos, float camdis);
		void Toggle (Vector3 &pos, bool bSel);
		bool IsSelected ();
		MdlObject *obj;
	};
	Selector *selector;

	IRenderData *renderData;
	bool bTexturesLoaded;
#endif
};


static inline void IterateObjects(MdlObject *obj, void (*fn)(MdlObject *obj))
{
	fn (obj);
	for (int a=0;a<obj->childs.size();a++)
		IterateObjects (obj->childs[a], fn);
}

// allows a GUI component to plug in and show the progress
struct IProgressCtl {
	IProgressCtl() { data=0; cb=0; }
	virtual void Update(float v) { if (cb) cb(v, data); }
	void (*cb)(float part, void *data);
	void *data;
};

struct Model : public creg::BaseObject
{
	CR_DECLARE(Model);

	Model ();
	~Model ();

	void PostLoad();
	
	bool Load3DO (const char *filename, IProgressCtl& progctl=IProgressCtl());
	bool Save3DO (const char *filename, IProgressCtl& progctl=IProgressCtl());

	bool LoadS3O (const char *filename, IProgressCtl& progctl=IProgressCtl());
	bool SaveS3O (const char *filename, IProgressCtl& progctl=IProgressCtl());

	// Common 3D MdlObject (chunk based format)
	bool LoadC3O (const char *filename, IProgressCtl& progctl=IProgressCtl());
	bool SaveC3O (const char *filename, IProgressCtl& progctl=IProgressCtl());

	// Memory dump using creg
	static Model* LoadOPK (const char *filename, IProgressCtl& progctl=IProgressCtl());
	static bool SaveOPK (Model *mdl, const char *filename, IProgressCtl& progctl=IProgressCtl());

	static Model* Load (const char *fn, bool Optimize=true, IProgressCtl& progctl=IProgressCtl());
	static bool Save (Model *mdl, const char *fn, IProgressCtl& progctl=IProgressCtl());

	// exports merged version of the model
	bool ExportUVMesh (const char *fn);
	// copies the UV coords of the single piece exported by ExportUVMesh back to the model
	bool ImportUVMesh (const char *fn, IProgressCtl& progctl=IProgressCtl());
	bool ImportUVCoords (Model* other, IProgressCtl& progctl=IProgressCtl());

	void InsertModel (MdlObject *obj, Model *sub);
	vector<MdlObject*> GetSelectedObjects ();
	vector<MdlObject*> GetObjectList (); // returns all objects
	void DeleteObject (MdlObject *obj);
	void ReplaceObject (MdlObject *oldObj, MdlObject *newObj);
	void EstimateMidPosition ();
	void CalculateRadius ();
	void SwapObjects (MdlObject *a, MdlObject *b);

	float radius;		//radius of collision sphere
	float height;		//height of whole object
	Vector3 mid;//these give the offset from origin(which is supposed to lay in the ground plane) to the middle of the unit collision sphere

#define NUM_TEX 3
	string textureNames[NUM_TEX]; // the names that are saved.
	Texture* textures[NUM_TEX]; // S3O textures
	int mapping;

	MdlObject *root;

private:
	Model(const Model& c) {}
	void operator=(const Model& c) {}
};

MdlObject* Load3DSObject (const char *filename, IProgressCtl& progctl);
bool Save3DSObject (const char *filename, MdlObject *obj, IProgressCtl& progctl);
MdlObject* LoadWavefrontObject(const char *fn, IProgressCtl& progctl);
bool SaveWavefrontObject (const char *fn, MdlObject *obj, IProgressCtl& progctl);

#endif
