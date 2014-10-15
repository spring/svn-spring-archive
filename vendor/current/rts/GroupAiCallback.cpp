// GroupAiCallback.cpp: implementation of the CGroupAICallback class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "GroupAiCallback.h"
#include "net.h"
#include "readmap.h"
#include "loshandler.h"
#include "infoconsole.h"
#include "group.h"
#include "unithandler.h"
#include "unit.h"
#include "team.h"
//#include "multipath.h"
//#include "PathHandler.h"
#include "quadfield.h"
#include "selectedunits.h"
#include "geometricobjects.h"
#include "commandai.h"
#include "gamehelper.h"
#include "unitdefhandler.h"
#include "guihandler.h"		//todo: fix some switch for new gui
#include "newguidefine.h"
#include "guicontroller.h"
#include "grouphandler.h"
#include "globalaihandler.h"
#include "feature.h"
#include "featurehandler.h"
#include "pathmanager.h"
#include "unitdrawer.h"
#include "player.h"
//#include "mmgr.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

using namespace std;


CGroupAICallback::CGroupAICallback(CGroup* group)
: group(group), aicb(group->handler->team, group->handler)
{
	aicb.group = group;
}

CGroupAICallback::~CGroupAICallback()
{}

IAICallback* CGroupAICallback::GetAICallback ()
{
	return &aicb;
}

void CGroupAICallback::UpdateIcons()
{
	selectedUnits.PossibleCommandChange(0);
}

const Command* CGroupAICallback::GetOrderPreview()
{
	static Command tempcmd;
	//todo: need to add support for new gui
#ifdef NEW_GUI
	tempcmd=guicontroller->GetOrderPreview();
#else
	tempcmd=guihandler->GetOrderPreview();
#endif
	return &tempcmd;
}

bool CGroupAICallback::IsSelected()
{
	return selectedUnits.selectedGroup==group->id;
}

int CGroupAICallback::GetUnitLastUserOrder(int unitid)
{
	CUnit *unit = uh->units[unitid];
	if (unit->group == group)
		return uh->units[unitid]->commandAI->lastUserCommand;
	return 0;
}

