#include "stdafx.h"
#include ".\globalaicallback.h"
#include "net.h"
#include "globalai.h"
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
#include "grouphandler.h"
#include "globalaihandler.h"
#include "feature.h"
#include "featurehandler.h"
#include "igroupai.h"
#include "pathmanager.h"
#include "aicheats.h"
#include "gamesetup.h"
#include "smfreadmap.h"
#include "wind.h"
#include "unitdrawer.h"
#include "player.h"
//#include "mmgr.h"

CGlobalAICallback::CGlobalAICallback(CGlobalAI* ai)
: ai(ai),
	cheats(0), 
	scb(ai->team, ai->gh)
{
}

CGlobalAICallback::~CGlobalAICallback(void)
{
	delete cheats;
}

IAICheats* CGlobalAICallback::GetCheatInterface()
{
	if(cheats)
		return cheats;

	if(!gs->cheatEnabled)
		return 0;

	cheats=new CAICheats(ai);
	return cheats;
}

IAICallback *CGlobalAICallback::GetAICallback ()
{
	return &scb;
}

