//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "EditorIncl.h"
#include "EditorDef.h"

#include "Util.h"
#include "Model.h"
#include "View.h"
#include "Texture.h"

#include "creg/Serializer.h"
#include "creg/VarTypes.h"
#include <fstream>
#include <stdexcept>

// ------------------------------------------------------------------------------------------------
// Register model types
// ------------------------------------------------------------------------------------------------

// Simple structures
CR_BIND_STRUCT(Vertex);
CR_REG_METADATA(Vertex, 
(
	CR_MEMBER(pos), 
	CR_MEMBER(normal), 
	CR_MEMBER(tc))
);

CR_BIND_STRUCT(Triangle);
CR_REG_METADATA(Triangle, (CR_MEMBER(vrt)));

// Joints
CR_BIND_DERIVED(BaseJoint, creg::BaseObject);

CR_BIND_DERIVED(HingeJoint, BaseJoint);
CR_REG_METADATA(HingeJoint, CR_MEMBER(axis));

CR_BIND_DERIVED(UniversalJoint, BaseJoint);
CR_REG_METADATA(UniversalJoint, CR_MEMBER(axis));

// IK info
CR_BIND(IKinfo);
CR_REG_METADATA(IKinfo, (CR_MEMBER(joint), CR_ENUM_MEMBER(jointType)));

// Poly
CR_BIND_DERIVED(Poly, creg::BaseObject);
CR_REG_METADATA(Poly, (
	CR_MEMBER(verts), 
	CR_MEMBER(texname), 
	CR_MEMBER(color), 
	CR_MEMBER(taColor),
	CR_MEMBER(texture),
	CR_MEMBER_SETFLAG(texture, CM_NoSerialize), // the texture shouldn't be serialized
	CR_MEMBER(isSelected))
);

CR_BIND(Rotator);
CR_REG_METADATA(Rotator, 
(
	CR_MEMBER(q),
	CR_MEMBER(eulerInterp))
);

// MdlObject
CR_BIND_DERIVED(MdlObject, creg::BaseObject);
CR_REG_METADATA(MdlObject,
(
	CR_MEMBER(poly),
	CR_MEMBER(verts),
	CR_MEMBER(childs),

	// Orientation
	CR_MEMBER(position),
	CR_MEMBER(scale),
	CR_MEMBER(rotation),

	CR_MEMBER(name),
	CR_MEMBER(isSelected),
	CR_MEMBER(isOpen),
	CR_MEMBER(parent),
	CR_MEMBER(ikInfo),

	CR_MEMBER(animInfo)
))

// Model
CR_BIND_DERIVED(Model, creg::BaseObject);
CR_REG_METADATA(Model,
(
	CR_MEMBER(radius),
	CR_MEMBER(height),
	CR_MEMBER(mid),

	CR_MEMBER(textureNames),
	CR_MEMBER(mapping),
	CR_MEMBER(textures),
	CR_MEMBER_SETFLAG(textures,CM_NoSerialize),  // only texture names are stored
	CR_MEMBER(root),
	CR_POSTLOAD(PostLoad)
))

// ------------------------------------------------------------------------------------------------
// Polygon
// ------------------------------------------------------------------------------------------------

float Poly::Selector::Score(Vector3 &pos, float camdis)
{
	assert (object);
	const vector<Vertex>& v=object->verts;
	Plane plane;

	Vector3 vrt[3];
	Matrix transform;
	object->GetFullTransform(transform);
	for (int a=0;a<3;a++) 
		transform.apply(&v[poly->verts[a]].pos, &vrt[a]);
    
	plane.MakePlane (vrt[0],vrt[1],vrt[2]);
	float dis = plane.Dis (&pos);
	return fabs (dis);
}
void Poly::Selector::Toggle (Vector3 &pos, bool bSel) {
	poly->isSelected = bSel;
}
bool Poly::Selector::IsSelected () { 
	return poly->isSelected; 
}

Poly::Poly() {
	selector=new Selector (this);
	isSelected=false;
	texture = 0;
	color.set(1,1,1);
	taColor=-1;
}

Poly::~Poly() {
	SAFE_DELETE(selector);
}

Poly* Poly::Clone()
{
	Poly *pl = new Poly;
	pl->verts=verts;
	pl->texname=texname;
	pl->color= color;
	pl->taColor = taColor;
	pl->texture = texture;
	return pl;
}

void Poly::Flip()
{
	vector<int> nv;
	nv.resize(verts.size());
	for (int a=0;a<verts.size();a++)
		nv[verts.size()-a-1]=verts[a];
	verts=nv;
}

Plane Poly::CalcPlane (const vector<Vertex>& vrt) {
	Plane plane;
	plane.MakePlane (vrt[verts[0]].pos,vrt[verts[1]].pos,vrt[verts[2]].pos);
	return plane;
}

void Poly::RotateVerts ()
{
	vector<int> n(verts.size());
	for (int a=0;a<verts.size();a++)
		n[(a+1)%n.size()]=verts[a];
	verts=n;
}

// ------------------------------------------------------------------------------------------------
// Rotator
// ------------------------------------------------------------------------------------------------

Rotator::Rotator() {
	eulerInterp = false;
}

Vector3 Rotator::GetEuler() 
{
	Matrix m;
	q.makematrix(&m);
	return m.calcEulerYXZ();
}

void Rotator::SetEuler(Vector3 euler)
{
	Matrix m;
	m.eulerYXZ(euler);
	m.makequat(&q);
	q.normalize();
}

void Rotator::AddEulerAbsolute(const Vector3& rot)
{
	Matrix m;
	m.eulerYXZ(rot);

	Quaternion tq;
	m.makequat(&tq);

	q *= tq;
	q.normalize();
}


void Rotator::AddEulerRelative(const Vector3& rot)
{
	Matrix m;
	m.eulerYXZ(rot);

	Quaternion tq;
	m.makequat(&tq);

	q = tq * q;
	q.normalize();
}

void Rotator::ToMatrix(Matrix& o) 
{
	q.makematrix(&o);
}

void Rotator::FromMatrix(const Matrix&r )
{
	r.makequat(&q);
	q.normalize();
}

// ------------------------------------------------------------------------------------------------
// MdlObject
// ------------------------------------------------------------------------------------------------

// Is pos contained by this object?
float MdlObject::Selector::Score (Vector3 &pos, float camdis)
{
	// it it close to the center?
	Vector3 center;
	Matrix transform;
	obj->GetFullTransform(transform);
	transform.apply(&Vector3(), &center);
	float best=(pos-center).length();
	// it it close to a polygon?
	for (int a=0;a<obj->poly.size();a++) {
		obj->poly[a]->selector->object = obj;
		float polyscore=obj->poly[a]->selector->Score(pos, camdis);
		if (polyscore < best) best=polyscore;
	}
	return best;
}
void MdlObject::Selector::Toggle (Vector3 &pos, bool bSel) { 
	obj->isSelected = bSel; 
}
bool MdlObject::Selector::IsSelected () { 
	return obj->isSelected; 
}


MdlObject::MdlObject ()
{
	selector = new Selector (this);
	isSelected=false;
	isOpen=true;
	parent=0;
	scale.set(1,1,1);
	bTexturesLoaded=false;
	renderData=0;

	InitAnimationInfo ();
}


MdlObject::~MdlObject()
{ 
	for(int a=0;a<poly.size();a++) 
		if (poly[a]) delete poly[a]; 
	poly.clear();

	for(int a=0;a<childs.size();a++)
		if (childs[a]) delete childs[a];
	childs.clear();

	SAFE_DELETE(selector);
	SAFE_DELETE(renderData);
}

void MdlObject::InvalidateRenderData ()
{
	CalculateNormals ();

	if(renderData)
		renderData->Invalidate ();
}

bool MdlObject::IsEmpty ()
{
	for (int a=0;a<childs.size();a++)
		if (!childs[a]->IsEmpty())
			return false;
	return poly.empty ();
}

vector<Triangle> MdlObject::MakeTris ()
{
	vector<Triangle> tris;

	for (int a=0;a<poly.size();a++) {
		Poly *p = poly[a];
		for (int b=2;b<p->verts.size();b++)
		{
			Triangle t;

			t.vrt[0] = p->verts[0];
			t.vrt[1] = p->verts[b-1];
			t.vrt[2] = p->verts[b];

			tris.push_back (t);
		}
	}
	return tris;
}

void MdlObject::Dump (int r)
{
	for (int a=0;a<r;a++)
		logger.Print ("  ");
	logger.Trace (NL_Debug, "MdlObject \'%s\'\n", name.c_str());

	for (int a=0;a<childs.size();a++)
		childs[a]->Dump(r+1);
}


void MdlObject::GetTransform(Matrix& mat)
{
	Matrix scaling;
	scaling.scale(scale);

	Matrix rotationMatrix;
	rotation.ToMatrix(rotationMatrix);

	mat = scaling * rotationMatrix;
	mat.t(0) = position.x;
	mat.t(1) = position.y;
	mat.t(2) = position.z;
}

void MdlObject::GetFullTransform(Matrix& tr)
{
	GetTransform (tr);

	if (parent) {
		Matrix parentTransform;
		parent->GetFullTransform(parentTransform);

		tr = parentTransform * tr;
	}
}

void MdlObject::SetPropertiesFromMatrix(Matrix& transform)
{
	position.x = transform.t(0);
	position.y = transform.t(1);
	position.z = transform.t(2);

	// extract scale and create a rotation matrix
	Vector3 cx,cy,cz; // columns
	transform.getcx(cx);
	transform.getcy(cy);
	transform.getcz(cz);

	scale.x = cx.length();
	scale.y = cy.length();
	scale.z = cz.length();

	Matrix rotationMatrix;
	rotationMatrix.identity();
	rotationMatrix.setcx (cx / scale.x);
	rotationMatrix.setcy (cy / scale.y);
	rotationMatrix.setcz (cz / scale.z);
	rotation.FromMatrix(rotationMatrix);
}

void MdlObject::Load3DOTextures (TextureHandler *th)
{
	if (!bTexturesLoaded) {
		for (int a=0;a<poly.size();a++) 
		{
			Poly *p=poly[a];
			if (!p->texture && !p->texname.empty()) {
				p->texture = th->GetTexture (p->texname.c_str());
				if (p->texture) 
					p->texture->VideoInit();
				else
					p->texname.clear();
			}
		}
		bTexturesLoaded=true;
	}

	for (int a=0;a<childs.size();a++)
		childs[a]->Load3DOTextures (th);
}

void MdlObject::ApplyTransform (bool removeRotation, bool removeScaling, bool removePosition)
{
	Matrix mat;
	mat.identity();
	if (removeScaling) {
		Matrix scaling;
		scaling.scale(scale);
		scale.set(1,1,1);
		mat = scaling;
	}
	if (removeRotation) {
		Matrix rotationMatrix;
		rotation.ToMatrix(rotationMatrix);
		mat *= rotationMatrix;
		rotation = Rotator();
	}
	
	if (removePosition) {
		mat.t(0) = position.x;
		mat.t(1) = position.y;
		mat.t(2) = position.z;
		position=Vector3();
	}
	Transform(mat);
}

void MdlObject::NormalizeNormals ()
{
	for (int a=0;a<verts.size();a++)
		verts[a].normal.normalize();
	for (int a=0;a<childs.size();a++)
		childs[a]->NormalizeNormals ();

	InvalidateRenderData();
}

void MdlObject::TransformVertices (const Matrix& transform)
{
	Matrix normalTransform = Math::CreateNormalTransform (transform);

	// transform and add the child vertices to the parent vertices list
	for (int a=0;a<verts.size();a++) 
	{
		Vertex&v = verts[a];
		Vector3 tpos, tnormal;
		
		transform.apply (&v.pos, &tpos);
		v.pos = tpos;
		normalTransform.apply (&v.normal, &tnormal);
		v.normal = tnormal;
	}
	InvalidateRenderData();
}


void MdlObject::Transform (const Matrix& transform)
{
	TransformVertices (transform);
	
	for (vector<MdlObject*>::iterator i=childs.begin();i!=childs.end();++i) {
		Matrix subObjTr;
		(*i)->GetTransform (subObjTr);
		subObjTr *= transform;
		(*i)->SetPropertiesFromMatrix(subObjTr);
	}
}

MdlObject* MdlObject::Clone()
{
	MdlObject *cp = new MdlObject;

	cp->verts=verts;

	for (int a=0;a<childs.size();a++) {
		MdlObject *ch = childs[a]->Clone();
		cp->childs.push_back(ch);
		ch->parent = cp;
	}

	for (int a=0;a<poly.size();a++) 
		cp->poly.push_back(poly[a]->Clone());

	cp->position=position;
	cp->rotation=rotation;
	cp->scale=scale;
	cp->name=name;

	return cp;
}

bool MdlObject::HasSelectedParent ()
{
	MdlObject *c = parent;
	while (c) {
		if (c->isSelected) 
			return true;
		c = c->parent;
	}
	return false;
}

void MdlObject::ApproximateOffset()
{
	Vector3 mid;
	for (int a=0;a<verts.size();a++)
		mid += verts[a].pos;

	if (!verts.empty())
		mid/=(float)verts.size();

	position += mid;
	for (int a=0;a<verts.size();a++)
		verts[a].pos -= mid;
}


void MdlObject::OptimizeVertices ()
{
	vector <int> old2new;
	vector <int> usage;
	vector <Vertex> nv;

	old2new.resize(verts.size());
	usage.resize (verts.size());
	fill(usage.begin(),usage.end(),0);

	for (int a=0;a<poly.size();a++) 
	{
		Poly *pl=poly[a];
		for (int b=0;b<pl->verts.size();b++) 
			usage[pl->verts[b]]++;
	}

	for (int a=0;a<verts.size();a++) {
		bool matched=false;

		if (!usage[a])
			continue;

		for (int b=0;b<nv.size();b++) {
			Vertex *va = &verts[a];
			Vertex *vb = &nv[b];

			if (va->pos.epsilon_compare (&vb->pos, 0.001f) && 
				va->tc[0].x == vb->tc[0].x && va->tc[0].y == vb->tc[0].y) {
				matched=true;
				old2new[a] = b;
				break;
			}
		}

		if (!matched) {
			old2new[a] = nv.size();
			nv.push_back (verts[a]);
		}
	}

	verts = nv;

	// map the poly vertex-indices to the new set of vertices
	for (int a=0;a<poly.size();a++) 
	{
		Poly *pl=poly[a];
		for (int b=0;b<pl->verts.size();b++) 
			pl->verts[b] = old2new[pl->verts[b]];
	}
}

void MdlObject::Optimize ()
{
	OptimizeVertices();

	// remove double linked vertices
	vector<Poly*> npl;
	for (int a=0;a<poly.size();a++) {
		Poly *pl=poly[a];

		bool finished;
		do {
			finished=true;
			for (int i=0,j=(int)pl->verts.size()-1;i<pl->verts.size();j=i++) 
				if (pl->verts[i] == pl->verts[j]) {
					pl->verts.erase (pl->verts.begin()+i);
					finished=false;
					break;
				}
		} while (!finished);

		if (pl->verts.size()>=3)
			npl.push_back(pl);
		else
			delete pl;
	}
	poly=npl;

	InvalidateRenderData();
}


void MdlObject::CalculateNormals()
{
	vector<Vector3> normals;
	normals.resize(verts.size());

	for (int a=0;a<poly.size();a++) {
		Poly *pl = poly[a];
		Plane plane;
		
		plane.MakePlane(verts[pl->verts [0]].pos,verts[pl->verts[1]].pos,verts[pl->verts[2]].pos);
		for (int b=0;b<pl->verts.size();b++)
			normals[pl->verts[b]] += plane.GetVector ();
	}

	for (int a=0;a<verts.size();a++) {
		if (normals[a].length()>0.0f)
			normals[a].normalize ();
		verts[a].normal=normals[a];
	}
}

void MdlObject::UnlinkFromParent ()
{
	if (parent) {
		parent->childs.erase (find(parent->childs.begin(),parent->childs.end(),this));
		parent = 0;
	}
}

void MdlObject::LinkToParent(MdlObject *p)
{
	if (parent) UnlinkFromParent();
	p->childs.push_back(this);
	parent = p;
}

void MdlObject::FullMerge ()
{
	vector <MdlObject *> ch=childs;
	for (int a=0;a<ch.size();a++) {
		ch[a]->FullMerge ();
		MergeChild (ch[a]);
	}
}


void MdlObject::MoveGeometry (MdlObject *dst)
{
	// offset the vertex indices and move polygons
	for (int a=0;a<poly.size();a++)
	{
		Poly *pl = poly[a];

		for (int b=0;b<pl->verts.size();b++) 
			pl->verts [b] += (int)dst->verts.size();
	}
	dst->poly.insert (dst->poly.end(), poly.begin(),poly.end());
	poly.clear ();

	// insert the child vertices
	dst->verts.insert (dst->verts.end(),verts.begin(),verts.end());
	verts.clear ();

	InvalidateRenderData();
}

void MdlObject::MergeChild (MdlObject *ch)
{
	ch->ApplyTransform(true,true,true);
	ch->MoveGeometry (this);

	// move the childs
	for (int a=0;a<ch->childs.size();a++) ch->childs[a]->parent = this;
	childs.insert (childs.end(), ch->childs.begin(),ch->childs.end());
	ch->childs.clear();

	// delete the child
	childs.erase (find(childs.begin(),childs.end(),ch));
	delete ch;
}

void MdlObject::UpdateAnimation(float time)
{
	animInfo.Evaluate (this, time);

	for (int a=0;a<childs.size();a++)
		childs[a]->UpdateAnimation (time);
}

void MdlObject::InitAnimationInfo ()
{
	animInfo.AddProperty (AnimController::GetStructController (AnimController::GetFloatController(), 
		Vector3::StaticClass()), "position", (int)&((MdlObject*)0)->position);
	animInfo.AddProperty (AnimController::GetQuaternionController(),
		"rotation", (int)&((MdlObject*)0)->rotation.q);
//	animInfo.AddProperty (AnimController::GetStructController (AnimController::GetEulerAngleController(), 
//		Vector3::StaticClass()), "rotation", (int)&((MdlObject*)0)->rotation);
	animInfo.AddProperty (AnimController::GetStructController (AnimController::GetFloatController(), 
		Vector3::StaticClass()), "scale", (int)&((MdlObject*)0)->scale);
}

// ------------------------------------------------------------------------------------------------
// Model
// ------------------------------------------------------------------------------------------------

Model::Model ()
{
	for (int a=0;a<NUM_TEX;a++)
		textures[a] = 0;

	root=0;
	mapping=MAPPING_S3O;
	height=radius=0.0f;
}

Model::~Model()
{
	if (root) 
		delete root;

	for (int a=0;a<NUM_TEX;a++) 
		SAFE_DELETE(textures[a]);
}

void Model::InsertModel (MdlObject *obj, Model *sub)
{
	if(!sub->root)
		return;

	obj->childs.push_back (sub->root);
	sub->root->parent = obj;
	sub->root = 0;
}

static void InitObject(MdlObject *o) { 
	o->Optimize();
	o->CalculateNormals();
}

// TODO: Abstract file formats
Model* Model::Load (const char *fn, bool Optimize, IProgressCtl& progctl)
{
	const char *ext=fltk::filename_ext(fn);
	Model *mdl = 0;

	try {
		if (!STRCASECMP(ext, ".opk")) 
			mdl = Model::LoadOPK (fn, progctl);
		else {
			bool r;
			mdl = new Model;

			if ( !STRCASECMP(ext, ".3do") )
				r = mdl->Load3DO (fn, progctl);
			else if( !STRCASECMP(ext, ".s3o" ))
				r = mdl->LoadS3O (fn, progctl);
			else if(!STRCASECMP(ext, ".3ds"))
				r = (mdl->root = Load3DSObject (fn, progctl)) != 0;
			else if (!STRCASECMP(ext, ".obj")) 
				r = (mdl->root = LoadWavefrontObject (fn, progctl)) != 0;
			else if (!STRCASECMP(ext, ".c3o"))
				r = mdl->LoadC3O (fn, progctl);
			else {
				fltk::message ("Unknown extension %s\n", fltk::filename_ext(fn));
				delete mdl;
				return false;
			}
			if (!r) {
				delete mdl;
				mdl = 0;
			}
		}
	}
	catch (std::runtime_error err)
	{
		fltk::message (err.what());
		return false;
	}
	if (mdl) {
		if (mdl->root && Optimize) IterateObjects (mdl->root, InitObject);
		return mdl;
	} else {
		fltk::message ("Failed to read file %s:\n",fn);
		return 0;
	}
}

bool Model::Save(Model* mdl, const char *fn, IProgressCtl& progctl)
{
	bool r = false;
	const char *ext=fltk::filename_ext(fn);

	if (!mdl->root) {
		fltk::message ("No objects");
		return false;
	}

	assert (fn&&fn[0]);
	if ( !STRCASECMP(ext, ".3do") )
		r = mdl->Save3DO (fn,progctl);
	else if( !STRCASECMP(ext, ".s3o" )) {
		r = mdl->SaveS3O (fn,progctl);
	} else if( !STRCASECMP(ext, ".3ds"))
		r = Save3DSObject(fn,mdl->root,progctl);
	else if( !STRCASECMP(ext, ".obj"))
		r = SaveWavefrontObject (fn,mdl->root,progctl);
	else if( !STRCASECMP(ext, ".c3o"))
		r = mdl->SaveC3O (fn,progctl);
	else if (!STRCASECMP(ext, ".opk"))
		r = Model::SaveOPK (mdl, fn,progctl);
	else 
		fltk::message ("Unknown extension %s\n", fltk::filename_ext(fn));
	if (!r) {
		fltk::message ("Failed to save file %s\n", fn);
	}
	return r;
}

static void GetSelectedObjectsHelper( MdlObject *obj, vector<MdlObject*>& sel)
{
	if (obj->isSelected)
		sel.push_back (obj);

	for (int a=0;a<obj->childs.size();a++)
		GetSelectedObjectsHelper(obj->childs[a],sel);
}

vector <MdlObject*> Model::GetSelectedObjects ()
{
	vector<MdlObject*> sel;
	if (root)
		GetSelectedObjectsHelper (root,sel);
	return sel;
}

void Model::DeleteObject(MdlObject *obj)
{
	if (obj->parent) {
		vector<MdlObject*>::iterator i=find (obj->parent->childs.begin(),obj->parent->childs.end(), obj);
		if (i != obj->parent->childs.end()) obj->parent->childs.erase (i);
	} else {
		assert (obj == root);
		root = 0;
	}

	delete obj;
}

void Model::SwapObjects (MdlObject *a, MdlObject *b)
{
	MdlObject *ap = a->parent, *bp = b->parent;
	
	// Unlink both objects from their parents 
	// (this will also fix problems if b is a child of a or vice versa)
	a->UnlinkFromParent();
	b->UnlinkFromParent();

	// Swap childs
	swap(a->childs,b->childs);
	// assign parents again on the swapped childs
	for (vector<MdlObject*>::iterator ci=a->childs.begin();ci!=a->childs.end();ci++)
		(*ci)->parent = a;
	for (vector<MdlObject*>::iterator ci=b->childs.begin();ci!=b->childs.end();ci++)
		(*ci)->parent = b;

	if (b == ap) { // was b originally the parent of a?
		b->LinkToParent(a);
		if (bp) a->LinkToParent(bp);
	} else if(a == bp) { // or was a originally the parent of b
		a->LinkToParent(b);
		if (ap) b->LinkToParent(ap);
	} else { // no parents of eachother at all
		if (bp) a->LinkToParent(bp);
		if (ap) b->LinkToParent(ap);
	}

	if (a == root) root = b;
	else if (b == root) root = a;
}

void Model::ReplaceObject (MdlObject *old, MdlObject *_new)
{
	// Insert the old childs into the new object
	_new->childs.insert (_new->childs.end(), old->childs.begin(),old->childs.end());
	old->childs.clear();
	
	// Delete the old object
	MdlObject *parent = old->parent;
	DeleteObject (old);

	// Insert the new object
	if (parent) parent->childs.push_back (_new);
	else root = _new;
}

static void AddPositions (MdlObject *o, Vector3& p,int &count) {
	Matrix transform;
	o->GetTransform(transform);

	for (int a=0;a<o->verts.size();a++) {
		Vector3 temp;
		transform.apply (&o->verts[a].pos, &temp);
		p += temp;
	}
	count += (int)o->verts.size();
	for (int a=0;a<o->childs.size();a++)
		AddPositions (o->childs[a], p, count);
}


void Model::EstimateMidPosition ()
{
	Vector3 total;
	int count=0;
	if (root) 
		AddPositions (root, total, count);

	if (count) {
		mid = total / count;
	} else mid=Vector3();
}

void Model::CalculateRadius ()
{
	vector<MdlObject*> objs = GetObjectList();
	radius=0.0f;
	for (int o=0;o<objs.size();o++) {
		MdlObject *obj = objs[o];
		Matrix objTransform;
		obj->GetFullTransform(objTransform);
		for(int v=0;v<obj->verts.size();v++){
			Vector3 tpos;
			objTransform.apply(&obj->verts[v].pos,&tpos);
			float r= (tpos-mid).length();
			if (radius < r) radius=r;
		}
	}
}


bool Model::ExportUVMesh (const char *fn)
{
	// create a cloned model
	MdlObject *cloned = root->Clone ();
	Model mdl;
	mdl.root = cloned;

	// merge all objects in the clone
	while (!mdl.root->childs.empty()) {
		vector<MdlObject*> childs=mdl.root->childs;

		for (vector<MdlObject*>::iterator ci=childs.begin(); ci!=childs.end(); ++ci)
			mdl.root->MergeChild(*ci);
	}

	return Model::Save(&mdl, fn);
}

bool Model::ImportUVMesh (const char *fn, IProgressCtl& progctl) 
{
	Model mdl;
	if (!mdl.Load (fn, false))// an unoptimized mesh so the vertices are not merged
		return false;

	if (!ImportUVCoords (&mdl, progctl)) {
		return false;
	}
	return true;
}


int MatchPolygon (MdlObject *root, vector<Vector3>& pverts, int& startVertex)
{
	for (int a=0;a<root->poly.size();a++) {
		Poly *pl = root->poly[a];

		if (pl->verts.size() != pverts.size())
			continue;

		// An early out plane comparision, will also make sure that "double-sided" polgyon pairs
		// are handled correctly
		Plane plane = pl->CalcPlane (root->verts);
		Plane tplane;
		tplane.MakePlane (pverts[0],pverts[1],pverts[2]);
		
		if (!plane.EpsilonCompare(tplane, EPSILON))
			continue;

		// in case the polygon vertices have been reordered, 
		// this takes care of finding "the first" vertex again
		int startv = 0;
		for (;startv < pverts.size();startv++) {
			if ((root->verts[pl->verts [0]].pos-pverts[startv]).length () < EPSILON)
				break;
		}
		// no start vertex has been found
		if (startv == pverts.size())
			continue;

		// compare the polygon vertices with eachother... 
		int v = 0;
		for (;v<pverts.size();v++) {
			if ((root->verts[pl->verts[v]].pos - pverts[(v+startv)%pverts.size()]).length () >= EPSILON)
				break;
		}
		if (v==pverts.size()) {
			startVertex=startv;
			return a;
		}
	}
	return -1;
}

bool Model::ImportUVCoords (Model* other, IProgressCtl &progctl)
{
	vector <MdlObject*> objects=GetObjectList ();
	MdlObject *srcobj = other->root;

	vector <Vector3> pverts;

	int numPl = 0, curPl=0;
	for (int a=0;a<objects.size();a++)
		numPl += objects[a]->poly.size();
	
	for (int a=0;a<objects.size();a++) {
		MdlObject *obj = objects[a];
		Matrix objTransform;
		obj->GetFullTransform(objTransform);

		// give each polygon an independent set of vertices, this will be optimized back to normal later
		vector <Vertex> nverts;
		for (int b=0;b<obj->poly.size();b++) {
			Poly *pl = obj->poly[b];
			for (int v=0;v<pl->verts.size();v++) {
				nverts.push_back (obj->verts[pl->verts[v]]);
				pl->verts[v]=nverts.size()-1;
			}
		}
		obj->verts=nverts;

		// match our polygons with the ones of the other model
		for (int b=0;b<obj->poly.size();b++) {
			Poly *pl = obj->poly[b];

			pverts.clear();
			for (int pv=0;pv<pl->verts.size();pv++) {
				Vector3 tpos;
				objTransform.apply (&obj->verts [pl->verts[pv]].pos, &tpos);
				pverts.push_back (tpos);
			}

			int startVertex;
			int bestpl = MatchPolygon (srcobj,pverts,startVertex);
			if (bestpl >= 0) {
				// copy texture coordinates from rt->poly[bestpl] to pl
				Poly *src = srcobj->poly [bestpl];
				for (int v=0;v<src->verts.size();v++) {
					Vertex &dstvrt = obj->verts[pl->verts[(v + startVertex)%pl->verts.size()]];
					dstvrt.tc[0] = srcobj->verts[src->verts[v]].tc[0];
				}
			}

			progctl.Update ((float)(curPl++) / numPl);
		}
		obj->Optimize ();
		obj->InvalidateRenderData();
	}

	return true;
}

static void GetObjectListHelper (MdlObject *obj, vector<MdlObject*>& list) {
	list.push_back (obj);
	for (int a=0;a<obj->childs.size();a++)
		GetObjectListHelper (obj->childs [a], list);
}

vector<MdlObject*> Model::GetObjectList ()
{
	vector<MdlObject*> objlist;
	if (root)
		GetObjectListHelper (root, objlist);
	return objlist;
}


Model* Model::LoadOPK (const char *filename, IProgressCtl& progctl)
{
	creg::CInputStreamSerializer s;
	Model *mdl = 0;
	creg::Class *cls = 0;

	std::ifstream f (filename, ios::in|ios::binary);
	if (!f.is_open ())
		return 0;

	void *root = 0;
	s.LoadPackage (&f, root, cls);

	mdl = (Model *)root;
	if (cls != Model::StaticClass())
	{
		cls->DeleteInstance (mdl);
		return 0;
	}

    return mdl;
}

bool Model::SaveOPK (Model* mdl, const char *filename, IProgressCtl& progctl)
{
	creg::COutputStreamSerializer s;

	std::ofstream f (filename, ios::out|ios::binary);
	if (!f.is_open ())
		return false;

	s.SavePackage (&f, mdl, mdl->GetClass());
	return true;
}

void Model::PostLoad()
{
	// load textures
	for (int tex=0;tex<2;tex++)
	{
		if (textureNames[tex].empty())
			continue;

		textures[tex] = new Texture (textureNames[tex]);
		if (!textures[tex]->IsLoaded ())
		{
			delete textures[tex];
			textures[tex] = 0;
		}
	}
}

