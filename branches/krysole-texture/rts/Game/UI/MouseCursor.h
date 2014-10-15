#ifndef MOUSECURSOR_H
#define MOUSECURSOR_H

#include <string>
#include <vector>

using namespace std;

#include "Rendering/Textures.h"

class CMouseCursor
{
	vector<Texture> frames;
	vector<int> xsize;
	vector<int> ysize;
	double lastFrameTime;
	int curFrame;
	int xofs, yofs;			//Describes where the center of the cursor is. Calculated after the largest cursor if animated
public:
	enum HotSpot {TopLeft, Center};
	CMouseCursor(const string &name, HotSpot hs);
	void Draw(int x, int y);
};


#endif /* MOUSECURSOR_H */
