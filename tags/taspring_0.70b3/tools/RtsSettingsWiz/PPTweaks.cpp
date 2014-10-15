// PPTweaks.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPTweaks, CPropertyPage)

CPPTweaks::CPPTweaks()
	:	CPropertyPage	(CPPTweaks::IDD),
		m_pToolTips		(NULL)
{
}

CPPTweaks::~CPPTweaks()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPTweaks::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPTweaks::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Check(pDX, IDC_PPTWEAKS_CHECK_SHOWCLOCK, m_bShowClock);
	DDX_Check(pDX, IDC_PPTWEAKS_CHECK_SHOWPLAYERINFO, m_bShowPlayerInfo);

	// Meh, I know, cheap, but whatever :D
	//DDX_Check(pDX, IDC_PPTWEAKS_RADIO_USEREGISTRY, m_bUseRegistry);
	//BOOL bUseFile = (! m_bUseRegistry);
	//DDX_Check(pDX, IDC_PPTWEAKS_RADIO_USEFILE, bUseFile);
}

BEGIN_MESSAGE_MAP(CPPTweaks, CPropertyPage)
END_MESSAGE_MAP()

// CPPTweaks message handlers
BOOL CPPTweaks::OnInitDialog()
{
	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPTweaks::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Next]
		g_pSheet->SetWizardButtons(CPPTweaks::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}
