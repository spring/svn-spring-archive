// Building.h: interface for the CBuilding class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __BUILDING_H__
#define __BUILDING_H__

#include "Sim/Units/Unit.h"

class CBuilding : public CUnit  
{
public:
	CR_DECLARE(CBuilding);

	CBuilding();
	virtual ~CBuilding();

	void Init(void);
};

#endif // __BUILDING_H__
