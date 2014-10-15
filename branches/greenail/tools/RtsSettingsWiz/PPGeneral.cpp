// PPGeneral.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPGeneral, CPropertyPage)

CPPGeneral::CPPGeneral()
	:	CPropertyPage	(CPPGeneral::IDD),
		m_pToolTips		(NULL),
		m_csPlayerName	(PLAYERNAME_DEF),
		m_uiXResolution	(XRESOLUTION_DEF),
		m_uiYResolution	(YRESOLUTION_DEF),
		m_bFullscreen	(FULLSCREEN_DEF),
		m_bInvertMouse	(INVERTMOUSE_DEF)
{
}

CPPGeneral::~CPPGeneral()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPGeneral::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPGeneral::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Text(pDX,	IDC_PPGENERAL_EDIT_PLAYERNAME,			m_csPlayerName);
	DDX_Text(pDX,	IDC_PPGENERAL_EDIT_XRESOLUTION,			m_uiXResolution);
	DDX_Text(pDX,	IDC_PPGENERAL_EDIT_YRESOLUTION,			m_uiYResolution);
	DDX_Check(pDX,	IDC_PPGENERAL_CHECK_FULLSCREEN,			m_bFullscreen);
	DDX_Check(pDX,	IDC_PPGENERAL_CHECK_INVERTMOUSE,		m_bInvertMouse);
}

BEGIN_MESSAGE_MAP(CPPGeneral, CPropertyPage)
	ON_CBN_SELCHANGE(IDC_PPGENERAL_COMBO_RES, OnCbnSelchangePpgeneralComboRes)
	ON_EN_CHANGE(IDC_PPGENERAL_EDIT_XRESOLUTION, OnEnChangePpgeneralEdit)
	ON_EN_CHANGE(IDC_PPGENERAL_EDIT_YRESOLUTION, OnEnChangePpgeneralEdit)
END_MESSAGE_MAP()

void CPPGeneral::SetupComboResSelection(void)
{
	CString csXResolution, csYResolution;
	((CEdit*)GetDlgItem(IDC_PPGENERAL_EDIT_XRESOLUTION))->GetWindowText(csXResolution);
	((CEdit*)GetDlgItem(IDC_PPGENERAL_EDIT_YRESOLUTION))->GetWindowText(csYResolution);

	UINT uiXResolution = _ttoi(csXResolution);
	UINT uiYResolution = _ttoi(csYResolution);

	if ((uiXResolution == 640) && (uiYResolution == 480))
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(1);
	else if ((uiXResolution == 800) && (uiYResolution == 600))
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(2);
	else if ((uiXResolution == 1024) && (uiYResolution == 768))
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(3);
	else if ((uiXResolution == 1280) && (uiYResolution == 1024))
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(4);
	else if ((uiXResolution == 1600) && (uiYResolution == 1200))
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(5);
	// Meh, set to custom, looks neat that way XD
	else
		((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->SetCurSel(0);
}

// CPPGeneral message handlers
BOOL CPPGeneral::OnInitDialog()
{
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("Custom"));
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("640x480"));
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("800x600"));
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("1024x768"));
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("1280x1024"));
	((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->AddString(_T("1600x1200"));

	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	SetupComboResSelection();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPGeneral::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back:disabled] [Next]
		g_pSheet->SetWizardButtons(CPPGeneral::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}

void CPPGeneral::OnCbnSelchangePpgeneralComboRes()
{
	switch (((CComboBox*)GetDlgItem(IDC_PPGENERAL_COMBO_RES))->GetCurSel())
	{
		// On case 0, recheck which item should be selected
		case 0: SetupComboResSelection(); return;

		// Set them values
		case 1:	m_uiXResolution = 640;	m_uiYResolution = 480;	break;
		case 2:	m_uiXResolution = 800;	m_uiYResolution = 600;	break;
		case 3:	m_uiXResolution = 1024;	m_uiYResolution = 768;	break;
		case 4:	m_uiXResolution = 1280;	m_uiYResolution = 1024;	break;
		case 5:	m_uiXResolution = 1600;	m_uiYResolution = 1200;	break;
	}

	// Reload new data
	UpdateData(FALSE);
}

void CPPGeneral::OnEnChangePpgeneralEdit()
{
	SetupComboResSelection();
}
