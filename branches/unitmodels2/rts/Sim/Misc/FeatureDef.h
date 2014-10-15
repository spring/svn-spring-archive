#ifndef FEATURE_DEF_H
#define FEATURE_DEF_H

#define DRAWTYPE_3DO 0
#define DRAWTYPE_TREE 1
#define DRAWTYPE_NONE -1

class CModel;

struct FeatureDef
{
	CR_DECLARE(FeatureDef);
	virtual ~FeatureDef();

	FeatureDef():upright(false),floating(false),geoThermal(0){};

	std::string myName;
	std::string description;

	float metal;
	float energy;
	float maxHealth;

	float radius;
	float mass;									//used to see if the object can be overrun

	bool upright;
	int drawType;
	CModel* model;						//used by 3do obects
	std::string modelname;			//used by 3do obects
	int modelType;							//used by tree etc

	bool destructable;
	bool blocking;
	bool burnable;
	bool floating;

	bool geoThermal;

	std::string deathFeature;		//name of feature that this turn into when killed (not reclaimed)

	int xsize;									//each size is 8 units
	int ysize;									//each size is 8 units
};

#endif