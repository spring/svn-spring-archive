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
	DDX_Control(pDX, IDC_ScreenRes, ScreenRes);
	DDX_Control(pDX, IDC_AdvTree, AdvTree);
	DDX_Control(pDX, IDC_AdvCloud, AdvCloud);
	DDX_Control(pDX, IDC_DynCloud, DynCloud);
	DDX_Control(pDX, IDC_AdvWater, RefWater);
	DDX_Control(pDX, IDC_AdvWater3, Fullscreen);
	DDX_Control(pDX, IDC_EDIT1, PlayerName);
	DDX_Control(pDX, IDC_AdvWater4, ColorElev);
	DDX_Control(pDX, IDC_UnitDist2, GrassDetail);
	DDX_Control(pDX, IDC_UnitDist3, Particles);
	DDX_Control(pDX, IDC_AdvWater5, shadows);
	DDX_Control(pDX, IDC_UnitDist4, shadowMapSize);
	DDX_Control(pDX, IDC_UnitDist5, maxSounds);
	DDX_Control(pDX, IDC_AdvWater6, invertMouse);
	DDX_Control(pDX, IDC_EDIT2, xres);
	DDX_Control(pDX, IDC_EDIT3, yres);
	DDX_Control(pDX, IDC_UnitDist6, GroundDecals);
	DDX_Control(pDX, IDC_EDIT4, frequency);
	DDX_Control(pDX, IDC_AdvWater7, simpleColors);
}

BEGIN_MESSAGE_MAP(CRtsSettingsDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
	ON_CBN_SELCHANGE(IDC_ScreenRes, OnCbnSelchangeScreenres)
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
	GrassDetail.SetRange(0,10);
	GrassDetail.SetPos(regHandler.GetInt("GrassDetail",3));
	Particles.SetRange(1000,20000);
	Particles.SetPos(regHandler.GetInt("MaxParticles",4000));
	shadowMapSize.SetRange(1,2);
	shadowMapSize.SetPos(regHandler.GetInt("ShadowMapSize",2048)/1024);
	maxSounds.SetRange(8,128);
	maxSounds.SetPos(regHandler.GetInt("MaxSounds",16));
	GroundDecals.SetRange(0,5);
	GroundDecals.SetPos(regHandler.GetInt("GroundDecals",0));
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
	RefWater.SetCheck(regHandler.GetInt("ReflectiveWater",0));
	Fullscreen.SetCheck(regHandler.GetInt("Fullscreen",1));
	ColorElev.SetCheck(regHandler.GetInt("ColorElev",1));
	invertMouse.SetCheck(regHandler.GetInt("InvertMouse",1));
	shadows.SetCheck(regHandler.GetInt("Shadows",0));
	simpleColors.SetCheck(regHandler.GetInt("SimpleMinimapColors",0));

	PlayerName.SetWindowText(regHandler.GetString("name","no name").c_str());

	int freq=regHandler.GetInt("DisplayFrequency",0);
	sprintf(text,"%i",freq);
	frequency.SetWindowText(text);

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

	char text[500];
	xres.GetWindowText(text,500);
	regHandler.SetInt("XResolution",atoi(text));
	yres.GetWindowText(text,500);
	regHandler.SetInt("YResolution",atoi(text));
	frequency.GetWindowText(text,500);
	regHandler.SetInt("DisplayFrequency",atoi(text));

	regHandler.SetInt("3DTrees",AdvTree.GetCheck());
	regHandler.SetInt("AdvSky",AdvCloud.GetCheck());
	regHandler.SetInt("DynamicSky",DynCloud.GetCheck());
	regHandler.SetInt("ReflectiveWater",RefWater.GetCheck());
	regHandler.SetInt("Fullscreen",Fullscreen.GetCheck());
	regHandler.SetInt("ColorElev",ColorElev.GetCheck());
	regHandler.SetInt("InvertMouse",invertMouse.GetCheck());
	regHandler.SetInt("Shadows",shadows.GetCheck());
	regHandler.SetInt("SimpleMiniMapColors",simpleColors.GetCheck());

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
