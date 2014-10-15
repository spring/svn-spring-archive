// MouseDialog.cpp : implementation file
//

#include "stdafx.h"
#include "RtsSettings.h"
#include "MouseDialog.h"
#include "reghandler.h"
#include ".\mousedialog.h"

// CMouseDialog dialog

IMPLEMENT_DYNAMIC(CMouseDialog, CDialog)
CMouseDialog::CMouseDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CMouseDialog::IDD, pParent)
{
}

CMouseDialog::~CMouseDialog()
{
}

void CMouseDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_FPSSPEED, FpsSpeed);
	DDX_Control(pDX, IDC_OVERHEADSPEED, OverheadSpeed);
	DDX_Control(pDX, IDC_ROTOVERHEADSPEED, RotOverheadSpeed);
	DDX_Control(pDX, IDC_TWSPEED, TWSpeed);
	DDX_Control(pDX, IDC_INVMOUSE, invertMouse);
	DDX_Control(pDX, IDC_DEFAULTMODE, DefaultMode);
	DDX_Control(pDX, IDC_FPSENABLED, FpsEnabled);
	DDX_Control(pDX, IDC_OVERHEADENABLED, OverheadEnabled);
	DDX_Control(pDX, IDC_ROTOVERHEADENABLED, RotOverheadEnabled);
	DDX_Control(pDX, IDC_TWENABLED, TWEnabled);
}


BEGIN_MESSAGE_MAP(CMouseDialog, CDialog)
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()


// CMouseDialog message handlers

BOOL CMouseDialog::OnInitDialog()
{
	CDialog::OnInitDialog();

	FpsSpeed.SetRange(1,100);
	FpsSpeed.SetPos(	regHandler.GetInt("FPSScrollSpeed",10));
	OverheadSpeed.SetRange(1,100);
	OverheadSpeed.SetPos(	regHandler.GetInt("OverheadScrollSpeed",10));
	RotOverheadSpeed.SetRange(1,100);
	RotOverheadSpeed.SetPos(	regHandler.GetInt("RotOverheadScrollSpeed",10));
	TWSpeed.SetRange(1,100);
	TWSpeed.SetPos(	regHandler.GetInt("TWScrollSpeed",10));

	invertMouse.SetCheck(regHandler.GetInt("InvertMouse",1));
	FpsEnabled.SetCheck(regHandler.GetInt("FPSEnabled",1));
	OverheadEnabled.SetCheck(regHandler.GetInt("OverheadEnabled",1));
	RotOverheadEnabled.SetCheck(regHandler.GetInt("RotOverheadEnabled",1));
	TWEnabled.SetCheck(regHandler.GetInt("TWEnabled",1));

	DefaultMode.AddString("FPS");
	DefaultMode.AddString("Overhead");
	DefaultMode.AddString("Total war");
	DefaultMode.AddString("RotOverhead");

	int mode=regHandler.GetInt("CamMode",1);
	switch(mode){
	case 0:
		DefaultMode.SetCurSel(0);
		break;
	case 1:
		DefaultMode.SetCurSel(1);
		break;
	case 2:
		DefaultMode.SetCurSel(2);
		break;
	case 3:
	default:
		DefaultMode.SetCurSel(3);
		break;
	}
	return true;
}
void CMouseDialog::OnBnClickedOk()
{
	regHandler.SetInt("FPSScrollSpeed",FpsSpeed.GetPos());
	regHandler.SetInt("OverheadScrollSpeed",OverheadSpeed.GetPos());
	regHandler.SetInt("RotOverheadScrollSpeed",RotOverheadSpeed.GetPos());
	regHandler.SetInt("TWScrollSpeed",TWSpeed.GetPos());

	regHandler.SetInt("InvertMouse",invertMouse.GetCheck());

	regHandler.SetInt("FPSEnabled",FpsEnabled.GetCheck());
	regHandler.SetInt("OverheadEnabled",OverheadEnabled.GetCheck());
	regHandler.SetInt("RotOverheadEnabled",RotOverheadEnabled.GetCheck());
	regHandler.SetInt("TWEnabled",TWEnabled.GetCheck());

	int mode=DefaultMode.GetCurSel();
	regHandler.SetInt("CamMode",mode);

	OnOK();
}
