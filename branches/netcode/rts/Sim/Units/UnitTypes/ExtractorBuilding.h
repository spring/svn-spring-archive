#ifndef __EXTRACTOR_BUILDING_H__
#define __EXTRACTOR_BUILDING_H__

#include "Building.h"

class CExtractorBuilding : public CBuilding {
public:
	CR_DECLARE(CExtractorBuilding);

	CExtractorBuilding();
	virtual ~CExtractorBuilding();

	void ResetExtraction();
	void SetExtractionRangeAndDepth(float range, float depth);
	void ReCalculateMetalExtraction();
	void AddNeighboor(CExtractorBuilding* neighboor);
	void RemoveNeighboor(CExtractorBuilding* neighboor);

	float GetExtractionRange() const { return extractionRange; }
	float GetExtractionDepth() const { return extractionDepth; }

	virtual void FinishedBuilding();

protected:
	struct MetalSquareOfControl {
		int x;
		int z;
		float extractionDepth;
	};

	float extractionRange, extractionDepth;
	std::list<MetalSquareOfControl*> metalAreaOfControl;
	std::list<CExtractorBuilding*> neighbours;

	static float maxExtractionRange;
};

#endif // __EXTRACTOR_BUILDING_H__
