#include "StdAfx.h"
#include "MouseCursor.h"
#include "FileSystem/FileHandler.h"
#include "InfoConsole.h"
#include "Rendering/GL/myGL.h"
#include "myMath.h"
#include "bitops.h"
#include "mmgr.h"

//Would be nice if these were read from a gaf-file instead.
CMouseCursor::CMouseCursor(const string &name, HotSpot hs)
{
	char namebuf[100];
	curFrame = 0;



	if (name.length() > 80) {
		info->AddLine("CMouseCursor: Long name %s", name.c_str());
		return;
	}

	std::size_t maxxsize = 0;
	std::size_t maxysize = 0;

	for (int frameNum = 0; ; ++frameNum) {
                sprintf(namebuf, "Anims/%s_%d.bmp", name.c_str(), frameNum);
		CFileHandler f(namebuf);
		
		if (f.FileExists()) {
			MemTexture mtx = TextureLoader::Instance().LoadMemTexture(namebuf);

			std::size_t origWidth = mtx.Width();
			std::size_t origHeight = mtx.Height();

			mtx = mtxeffect::Flip(mtx);
			mtx = mtxeffect::CreatePow2Aligned(mtx);
			mtxeffect::AlphaWithColorKeyWithoutFix(mtx, 84, 84, 252);

			Texture cursorTex = mtx.CreateTexture(false);

			cursorTex.SetRepeatMode(false, false);

			frames.push_back(cursorTex);
			xsize.push_back(mtx.Width());
			ysize.push_back(mtx.Height());

			maxxsize = max(origWidth, maxxsize);
			maxysize = max(origHeight, maxysize);
		}
		else {
			break;
		}
	}

	if (frames.size() == 0) {
		info->AddLine("No such cursor: %s", name.c_str());
		return;
	}

	switch (hs) {
		case TopLeft:
			xofs = 0; 
			yofs = 0;
			break;
		case Center:
			xofs = maxxsize / 2;
			yofs = maxysize / 2;
			break;
	}

	lastFrameTime = gu->gameTime;
}

void CMouseCursor::Draw(int x, int y)
{
	if (frames.size()==0)
		return;
	//Advance a frame in animated cursors
	if (gu->gameTime - lastFrameTime > 0.1) {
		lastFrameTime = gu->gameTime;
		curFrame++;
		if (curFrame >= (int)frames.size()) 
			curFrame = 0;
	}

	//Center on hotspot
	x -= xofs;
	y -= yofs;

	Texture cursorTex = frames[curFrame];
	int xs = xsize[curFrame];
	int ys = ysize[curFrame];

	glEnable(GL_TEXTURE_2D);
	cursorTex.Bind();
	if (frames.empty())
		return;

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glAlphaFunc(GL_GREATER,0.01f);
	glColor4f(1,1,1,1);

	glViewport(x,gu->screeny - y - ys,xs,ys);

	glBegin(GL_QUADS);

 	glTexCoord2f(0,0);glVertex3f(0,0,0);
 	glTexCoord2f(0,1);glVertex3f(0,1,0);
 	glTexCoord2f(1,1);glVertex3f(1,1,0);
 	glTexCoord2f(1,0);glVertex3f(1,0,0);

	glEnd();

/*	glViewport(x+10,gu->screeny-y-30,60*gu->screenx/gu->screeny,60);
	glScalef(0.2,0.2,0.2);
	font->glPrint("%s",cursorText.c_str());

	glViewport(lastx-20,gu->screeny-lasty-30,60*gu->screenx/gu->screeny,60);
	font->glPrint("%s",cursorTextRight.c_str());
	cursorTextRight=""; */

	glViewport(0,0,gu->screenx,gu->screeny);
}

