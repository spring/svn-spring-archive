// RtsSettingsWiz.cpp : Defines the class behaviors for the application.
/*******************************************
 *
 * TODO:
 *
 *******************************************
 *
 * 1) Fix the "Video Details" page, so that
 * changes to the slider controls with the
 * keyboard cause the "apply" button to
 * enable.
 *
 *******************************************/

#include "stdafx.h"
#include "RtsSettingsWiz.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// The one and only CRtsSettingsApp object
CRtsSettingsWizApp	theApp;
CRtsSettingsWizDlg*	g_pSheet;			// The main dialog window
BOOL				g_bFirstRun;		// Set in contructor of g_pSheet
BOOL				g_bOrigUseRegistry;		// Set in contructor of g_pSheet
INT					g_iCurPropertyPage;	// Set on exit of g_pSheet

// CRtsSettingsApp initialization
BOOL CRtsSettingsWizApp::InitInstance()
{
	// InitCommonControls() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	InitCommonControls();

	CWinApp::InitInstance();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored

	// Get if this is a first run (g_bFirstRun can double as a "settings version" later on)
	g_bFirstRun = (regHandler.GetInt("bRtsSettings", 0) == 0);

	// Just incase... you never know...
	if (g_bFirstRun)
		regHandler.SetInt("iCurPropertyPage", 0);

	// Load this property sheet, grabing the current page from the registry
	g_pSheet = new CRtsSettingsWizDlg(regHandler.GetInt("iCurPropertyPage", 0));
	if (! g_pSheet)
	{
		AfxMessageBox(_T("Error loading the settings sheet."), MB_OK | MB_ICONERROR);
		return FALSE;
	}

	// Load values
		// General page
		g_pSheet->m_PPGeneral.m_csPlayerName.SetString(	regHandler.GetString	("name",		PLAYERNAME_DEF).c_str());
		g_pSheet->m_PPGeneral.m_uiXResolution =			regHandler.GetInt		("XResolution",	XRESOLUTION_DEF);
		g_pSheet->m_PPGeneral.m_uiYResolution =			regHandler.GetInt		("YResolution",	YRESOLUTION_DEF);
		g_pSheet->m_PPGeneral.m_bFullscreen =			regHandler.GetInt		("Fullscreen",	FULLSCREEN_DEF);
		g_pSheet->m_PPGeneral.m_bInvertMouse =			regHandler.GetInt		("InvertMouse",	INVERTMOUSE_DEF);

		// Map page
		g_pSheet->m_PPMap.m_i3DTrees =		regHandler.GetInt	("3DTrees",			T3DTREES_DEF);
		g_pSheet->m_PPMap.m_iTreeRadius =	regHandler.GetInt	("TreeRadius",		TREERADIUS_DEF);
		g_pSheet->m_PPMap.m_iGrassDetail =	regHandler.GetInt	("GrassDetail",		GRASSDETAIL_DEF);
		g_pSheet->m_PPMap.m_iGroundDetail =	regHandler.GetInt	("GroundDetail",	GROUNDDETAIL_DEF);
		g_pSheet->m_PPMap.m_iGroundDecals =	regHandler.GetInt	("GroundDecals",	GROUNDDECALS_DEF);
		g_pSheet->m_PPMap.m_iMaxParticles =	regHandler.GetInt	("MaxParticles",	MAXPARTICLES_DEF);

		// Environment Page
		g_pSheet->m_PPEnvironment.m_bAdvSky =			regHandler.GetInt	("AdvSky",			ADVSKY_DEF);
		g_pSheet->m_PPEnvironment.m_bDynamicSky =		regHandler.GetInt	("DynamicSky",		DYNAMICSKY_DEF);
		g_pSheet->m_PPEnvironment.m_bReflectiveWater =	regHandler.GetInt	("ReflectiveWater",	REFLECTIVEWATER_DEF);
		g_pSheet->m_PPEnvironment.m_bColorElev =		regHandler.GetInt	("ColorElev",		COLORELEV_DEF);
		g_pSheet->m_PPEnvironment.m_bShadows =			regHandler.GetInt	("Shadows",			SHADOWS_DEF);
		g_pSheet->m_PPEnvironment.m_iShadowMapSize =	regHandler.GetInt	("ShadowMapSize",	SHADOWMAPSIZE_DEF);

		// Unit Page
		g_pSheet->m_PPUnits.m_iUnitLodDist =		regHandler.GetInt		("UnitLodDist",			UNITLODDIST_DEF);
		g_pSheet->m_PPUnits.m_iUnitTextureQuality =	regHandler.GetInt		("UnitTextureQuality",	UNITTEXTUREQUALITY_DEF);

		// Sound Page
		g_pSheet->m_PPSound.m_iMaxSounds =	regHandler.GetInt	("MaxSounds",	MAXSOUNDS_DEF);

		// Tweaks Page
		g_pSheet->m_PPTweaks.m_bShowClock =		regHandler.GetInt	("ShowClock",		SHOWCLOCK_DEF);
		g_pSheet->m_PPTweaks.m_bShowPlayerInfo =	regHandler.GetInt	("ShowPlayerInfo",	SHOWPLAYERINFO_DEF);

		// Tweaks Page, special variable :D
		//g_pSheet->m_PPTweaks.m_bUseRegistry =		regHandler.GetInt	("bUseRegistry",	USEREGISTRY_DEF, TRUE);	// Force getting this value from registry
		//g_bOrigUseRegistry = g_pSheet->m_PPTweaks.m_bUseRegistry;	// This is use to see if we're changing from registry to file, file to registry

	// Did we decide to save the settings?
	INT_PTR ret = g_pSheet->DoModal();
	if ((ret == IDOK) || (ret == ID_WIZFINISH))
	{
		// Set this to say "we're been run"
		regHandler.SetInt("bRtsSettings",		1);

		// Store the last used "page" (If we didn't just run the wizard)
		if (! g_bFirstRun)
			regHandler.SetInt("iCurPropertyPage",	g_iCurPropertyPage);

		// General page
		regHandler.SetString("name",			g_pSheet->m_PPGeneral.m_csPlayerName.GetString());
		regHandler.SetInt("XResolution",		g_pSheet->m_PPGeneral.m_uiXResolution);
		regHandler.SetInt("YResolution",		g_pSheet->m_PPGeneral.m_uiYResolution);
		regHandler.SetInt("Fullscreen",			g_pSheet->m_PPGeneral.m_bFullscreen);
		regHandler.SetInt("InvertMouse",		g_pSheet->m_PPGeneral.m_bInvertMouse);

		// Map page
		regHandler.SetInt("3DTrees",			g_pSheet->m_PPMap.m_i3DTrees);
		regHandler.SetInt("TreeRadius",			g_pSheet->m_PPMap.m_iTreeRadius);
		regHandler.SetInt("GroundDetail",		g_pSheet->m_PPMap.m_iGroundDetail);
		regHandler.SetInt("GroundDecals",		g_pSheet->m_PPMap.m_iGroundDecals);
		regHandler.SetInt("GrassDetail",		g_pSheet->m_PPMap.m_iGrassDetail);
		regHandler.SetInt("MaxParticles",		g_pSheet->m_PPMap.m_iMaxParticles);

		// Environment Page
		regHandler.SetInt("AdvSky",				g_pSheet->m_PPEnvironment.m_bAdvSky);
		regHandler.SetInt("DynamicSky",			g_pSheet->m_PPEnvironment.m_bDynamicSky);
		regHandler.SetInt("ReflectiveWater",	g_pSheet->m_PPEnvironment.m_bReflectiveWater);
		regHandler.SetInt("ColorElev",			g_pSheet->m_PPEnvironment.m_bColorElev);
		regHandler.SetInt("Shadows",			g_pSheet->m_PPEnvironment.m_bShadows);
		regHandler.SetInt("ShadowMapSize",		g_pSheet->m_PPEnvironment.m_iShadowMapSize);

		// Unit Page
		regHandler.SetInt("UnitLodDist",		g_pSheet->m_PPUnits.m_iUnitLodDist);
		regHandler.SetInt("UnitTextureQuality",	g_pSheet->m_PPUnits.m_iUnitTextureQuality);

		// Sound Page
		regHandler.SetInt("MaxSounds",			g_pSheet->m_PPSound.m_iMaxSounds);

		// Tweaks Page
		regHandler.SetInt("ShowClock",			g_pSheet->m_PPTweaks.m_bShowClock);
		regHandler.SetInt("ShowPlayerInfo",		g_pSheet->m_PPTweaks.m_bShowPlayerInfo);

		/* Tweaks Page, special variable :D */
		// Are we changing the settings location?
		/*if (g_pSheet->m_PPTweaks.m_bUseRegistry != g_bOrigUseRegistry)
		{
			// We're changing from file, to registry
			if (g_pSheet->m_PPTweaks.m_bUseRegistry)
			{
				regHandler.CopyFileToRegistry();
			}
			// We're changing from registry, to file
			else
			{
				regHandler.CopyRegistryToFile();
			}
		}

		// Do this last, since "bUseRegistry" could be copied from the file to the registry
		regHandler.SetInt("bUseRegistry",		g_pSheet->m_PPTweaks.m_bUseRegistry, TRUE);	// Force this value into the registry
		*/
	}
	/* else if (ret == IDCANCEL) */

	delete g_pSheet;
	g_pSheet = NULL;

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
