#pragma once

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

// Meh, less thinking this way :)
#include "resource.h"			// main symbols
#include "RegHandler.h"			// reg/file writing

// Property Pages
#include "PPGeneral.h"			// General page
#include "PPMap.h"				// Map page
#include "PPUnits.h"			// So on...
#include "PPEnvironment.h"
#include "PPSound.h"
#include "PPTweaks.h"
#include "PPTemplate.h"

#include "RtsSettingsWizDlg.h"	// The property sheet

// General
#define PLAYERNAME_DEF	(_T("No Name"))
#define FULLSCREEN_DEF	(TRUE)
#define XRESOLUTION_DEF	(640)
#define YRESOLUTION_DEF	(480)
#define INVERTMOUSE_DEF	(FALSE)

// Map
#define T3DTREES_DEF		(TRUE)
#define TREERADIUS_MIN		(600)
#define TREERADIUS_DEF		((int)(5.5 * 256))
#define TREERADIUS_MAX		(3000)
#define TREERADIUS_PAGE		(300)
#define GRASSDETAIL_MIN		(0)
#define GRASSDETAIL_DEF		(3)
#define GRASSDETAIL_MAX		(10)
#define GRASSDETAIL_PAGE	(1)
#define GROUNDDETAIL_MIN	(20)
#define GROUNDDETAIL_DEF	(60)
#define GROUNDDETAIL_MAX	(120)
#define GROUNDDETAIL_PAGE	(10)
#define GROUNDDECALS_MIN	(0)
#define GROUNDDECALS_DEF	(0)
#define GROUNDDECALS_MAX	(5)
#define GROUNDDECALS_PAGE	(1)
#define MAXPARTICLES_MIN	(1000)
#define MAXPARTICLES_DEF	(4000)
#define MAXPARTICLES_MAX	(20000)
#define MAXPARTICLES_PAGE	(1000)

// Environment
#define ADVSKY_DEF			(TRUE)
#define DYNAMICSKY_DEF		(FALSE)
#define REFLECTIVEWATER_DEF	(FALSE)
#define COLORELEV_DEF		(TRUE)
#define SHADOWS_DEF			(FALSE)
#define SHADOWMAPSIZE_DEF	(2048)

// Units
#define UNITLODDIST_MIN			(100)
#define UNITLODDIST_DEF			(200)
#define UNITLODDIST_MAX			(600)
#define UNITLODDIST_PAGE		(50)
#define UNITTEXTUREQUALITY_DEF	(0)

// Sound
#define MAXSOUNDS_MIN	(8)
#define MAXSOUNDS_DEF	(16)
#define MAXSOUNDS_MAX	(128)
#define MAXSOUNDS_PAGE	(16)

// Tweaks
#define SHOWCLOCK_DEF		(FALSE)
#define SHOWPLAYERINFO_DEF	(FALSE)
#define USEREGISTRY_DEF		(TRUE)

// CRtsSettingsApp:
class CRtsSettingsWizApp : public CWinApp
{
public:
	virtual BOOL InitInstance();
};

extern CRtsSettingsWizApp	theApp;
extern CRtsSettingsWizDlg*	g_pSheet;
extern BOOL					g_bFirstRun;
extern INT					g_iCurPropertyPage;
