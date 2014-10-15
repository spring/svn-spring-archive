// RtsSettingsDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RtsSettings.h"
#include "RtsSettingsDlg.h"
#include "reghandler.h"
#include ".\rtssettingsdlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CRtsSettingsDlg dialog



CRtsSettingsDlg::CRtsSettingsDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CRtsSettingsDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRtsSettingsDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_TreeDist, TreeDist);
	DDX_Control(pDX, IDC_TerrLod, TerrainLod);
	DDX_Control(pDX, IDC_UnitDist, UnitLodDist);
	DDX_Control(pDX, IDC_VERBOSELEVEL, VerboseLevel);
	DDX_Control(pDX, IDC_ScreenRes, ScreenRes);
	DDX_Control(pDX, IDC_AdvTree, AdvTree);
	DDX_Control(pDX, IDC_AdvCloud, AdvCloud);
	DDX_Control(pDX, IDC_DynCloud, DynCloud);
	DDX_Control(pDX, IDC_AdvWater, RefWater);
	DDX_Control(pDX, IDC_Fullscreen, Fullscreen);
	DDX_Control(pDX, IDC_EDIT1, PlayerName);
	DDX_Control(pDX, IDC_ColorizedElevationMap, ColorElev);
	DDX_Control(pDX, IDC_GrassDetail, GrassDetail);
	DDX_Control(pDX, IDC_MaxParticles, Particles);
	DDX_Control(pDX, IDC_Shadows, shadows);
	DDX_Control(pDX, IDC_ShadowMapSize, shadowMapSize);
	DDX_Control(pDX, IDC_MaxSounds, maxSounds);
	DDX_Control(pDX, IDC_InvertMouse, invertMouse);
	DDX_Control(pDX, IDC_EDIT2, xres);
	DDX_Control(pDX, IDC_EDIT3, yres);
	DDX_Control(pDX, IDC_GroundDecals, GroundDecals);
	DDX_Control(pDX, IDC_SimplifiedMinimapColors, simpleColors);
	DDX_Control(pDX, IDC_CATCH_AI_EXCEPTIONS, CatchAIExceptions);
	DDX_Control(pDX, IDC_SoundVolume, SoundVolume);
	DDX_Control(pDX, IDC_UnitReplySoundVolume, UnitReplySoundVolume);
	DDX_Control(pDX, IDC_AdvUnitRendering, AdvUnitRendering);
	DDX_Control(pDX, IDC_Water0, Water0);
	DDX_Control(pDX, IDC_Water1, Water1);
	DDX_Control(pDX, IDC_Water2, Water2);
	DDX_Control(pDX, IDC_FSAASamplesDisp, FSAASamplesDisp);
	DDX_Control(pDX, IDC_FSAA, FSAASamples);
	DDX_Control(pDX, IDC_VSYNC, vsync);
	DDX_Control(pDX, IDC_16BITZBUF, zbits16);
	DDX_Control(pDX, IDC_32BITZBUF, zbits32);
}

BEGIN_MESSAGE_MAP(CRtsSettingsDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
	ON_CBN_SELCHANGE(IDC_ScreenRes, OnCbnSelchangeScreenres)
	ON_WM_HSCROLL()
END_MESSAGE_MAP()


// CRtsSettingsDlg message handlers

BOOL CRtsSettingsDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	TreeDist.SetRange(600,3000);
	TreeDist.SetPos(regHandler.GetInt("TreeRadius",5.5f*256));
	TerrainLod.SetRange(20,120);
	TerrainLod.SetPos(regHandler.GetInt("GroundDetail",60));
	UnitLodDist.SetRange(100,600);
	UnitLodDist.SetPos(regHandler.GetInt("UnitLodDist",200));
	VerboseLevel.SetRange(0,10);
	VerboseLevel.SetPos(regHandler.GetInt("VerboseLevel",0));
	FSAASamples.SetRange(1,8);
	int fsaaLevel;
	if (regHandler.GetInt ("FSAA", 0) != 0) {
		fsaaLevel = regHandler.GetInt ("FSAALevel", 2);
		FSAASamples.SetPos(fsaaLevel);
	} else
		FSAASamples.SetPos(1);
	UpdateFSAAText();

	GrassDetail.SetRange(0,10);
	GrassDetail.SetPos(regHandler.GetInt("GrassDetail",3));
	Particles.SetRange(1000,20000);
	Particles.SetPos(regHandler.GetInt("MaxParticles",4000));
	shadowMapSize.SetRange(1,2);
	shadowMapSize.SetPos(regHandler.GetInt("ShadowMapSize",2048)/1024);
	maxSounds.SetRange(8,128);
	maxSounds.SetPos(regHandler.GetInt("MaxSounds",16));
	SoundVolume.SetRange (0,100);
	SoundVolume.SetPos(regHandler.GetInt("SoundVolume",60));
	UnitReplySoundVolume.SetRange (0,100);
	UnitReplySoundVolume.SetPos (regHandler.GetInt ("UnitReplySoundVolume", 80));
	GroundDecals.SetRange(0,5);
	GroundDecals.SetPos(regHandler.GetInt("GroundDecals",0));
	zbits16.SetCheck(regHandler.GetInt ("DepthBufferBits",32)==16);
	zbits32.SetCheck(!zbits16.GetCheck());
	ScreenRes.AddString("640x480");
	ScreenRes.AddString("800x600");
	ScreenRes.AddString("1024x768");
	ScreenRes.AddString("1280x1024");
	ScreenRes.AddString("1600x1200");
	int xr=regHandler.GetInt("XResolution",640);
	char text[500];
	sprintf(text,"%i",xr);
	xres.SetWindowText(text);
	int yr=regHandler.GetInt("YResolution",480);
	sprintf(text,"%i",yr);
	yres.SetWindowText(text);

	switch(xr){
	case 800:
		ScreenRes.SetCurSel(1);
		break;
	case 1024:
		ScreenRes.SetCurSel(2);
		break;
	case 1280:
		ScreenRes.SetCurSel(3);
		break;
	case 1600:
		ScreenRes.SetCurSel(4);
		break;
	default:
		ScreenRes.SetCurSel(0);
		break;
	}
	AdvTree.SetCheck(regHandler.GetInt("3DTrees",1));
	AdvCloud.SetCheck(regHandler.GetInt("AdvSky",1));
	DynCloud.SetCheck(regHandler.GetInt("DynamicSky",0));
//	RefWater.SetCheck(regHandler.GetInt("ReflectiveWater",0));
	AdvUnitRendering.SetCheck(regHandler.GetInt("AdvUnitShading",0));
	Fullscreen.SetCheck(regHandler.GetInt("Fullscreen",1));
	ColorElev.SetCheck(regHandler.GetInt("ColorElev",1));
	invertMouse.SetCheck(regHandler.GetInt("InvertMouse",1));
	shadows.SetCheck(regHandler.GetInt("Shadows",0));
	simpleColors.SetCheck(regHandler.GetInt("SimpleMinimapColors",0));
	CatchAIExceptions.SetCheck(regHandler.GetInt("CatchAIExceptions",1));
	vsync.SetCheck(regHandler.GetInt("VSync",0));

	PlayerName.SetWindowText(regHandler.GetString("name","no name").c_str());

	int water = regHandler.GetInt("ReflectiveWater",0);

	if(water==2)
		Water2.SetCheck(true);
	else if(water==1)
		Water1.SetCheck(true);
	else
		Water0.SetCheck(true);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CRtsSettingsDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

void CRtsSettingsDlg::UpdateFSAAText()
{
	char text[32];
	sprintf (text, "%d", FSAASamples.GetPos());
	FSAASamplesDisp.SetWindowText (text);
}

void CRtsSettingsDlg::OnHScroll (UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	if ((CSliderCtrl *)pScrollBar == &FSAASamples) 
		UpdateFSAAText();
}


// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CRtsSettingsDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CRtsSettingsDlg::OnBnClickedOk()
{
	regHandler.SetInt("TreeRadius",TreeDist.GetPos());
	regHandler.SetInt("GroundDetail",TerrainLod.GetPos());
	regHandler.SetInt("UnitLodDist",UnitLodDist.GetPos());
	regHandler.SetInt("GrassDetail",GrassDetail.GetPos());
	regHandler.SetInt("MaxParticles",Particles.GetPos());
	regHandler.SetInt("ShadowMapSize",shadowMapSize.GetPos()*1024);
	regHandler.SetInt("MaxSounds",maxSounds.GetPos());
	regHandler.SetInt("GroundDecals",GroundDecals.GetPos());
	regHandler.SetInt("VerboseLevel",VerboseLevel.GetPos());
	regHandler.SetInt("SoundVolume",SoundVolume.GetPos());
	regHandler.SetInt("UnitReplySoundVolume",UnitReplySoundVolume.GetPos());

	char text[500];
	xres.GetWindowText(text,500);
	regHandler.SetInt("XResolution",atoi(text));
	yres.GetWindowText(text,500);
	regHandler.SetInt("YResolution",atoi(text));

	regHandler.SetInt("3DTrees",AdvTree.GetCheck());
	regHandler.SetInt("AdvSky",AdvCloud.GetCheck());
	regHandler.SetInt("DynamicSky",DynCloud.GetCheck());
//	regHandler.SetInt("ReflectiveWater",RefWater.GetCheck());
	regHandler.SetInt("Fullscreen",Fullscreen.GetCheck());
	regHandler.SetInt("ColorElev",ColorElev.GetCheck());
	regHandler.SetInt("InvertMouse",invertMouse.GetCheck());
	regHandler.SetInt("Shadows",shadows.GetCheck());
	regHandler.SetInt("SimpleMiniMapColors",simpleColors.GetCheck());
	regHandler.SetInt("CatchAIExceptions",CatchAIExceptions.GetCheck());
	regHandler.SetInt("AdvUnitShading",AdvUnitRendering.GetCheck());
	regHandler.SetInt("VSync", vsync.GetCheck());
	regHandler.SetInt("DepthBufferBits", zbits16.GetCheck() ? 16 : 32);

	int fsaaLevel=FSAASamples.GetPos();
	if (fsaaLevel>1) {
		regHandler.SetInt("FSAALevel", fsaaLevel);
		regHandler.SetInt("FSAA", 1);
	} else
		regHandler.SetInt("FSAA", 0);

	if(Water2.GetCheck())
		regHandler.SetInt("ReflectiveWater",2);
	if(Water1.GetCheck())
		regHandler.SetInt("ReflectiveWater",1);
	if(Water0.GetCheck())
		regHandler.SetInt("ReflectiveWater",0);

	CString s;
	PlayerName.GetWindowText(s);
	regHandler.SetString("name",s.GetString());

	OnOK();
}

void CRtsSettingsDlg::OnCbnSelchangeScreenres()
{
	int res=ScreenRes.GetCurSel();
	switch(res){
	case 0:
		xres.SetWindowText("640");
		yres.SetWindowText("480");
		break;
	case 1:
		xres.SetWindowText("800");
		yres.SetWindowText("600");
		break;
	case 2:
		xres.SetWindowText("1024");
		yres.SetWindowText("768");
		break;
	case 3:
		xres.SetWindowText("1280");
		yres.SetWindowText("1024");
		break;
	case 4:
		xres.SetWindowText("1600");
		yres.SetWindowText("1200");
		break;
	default:
		break;
	}
}



