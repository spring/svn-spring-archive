// PPPreGameGUI.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPTemplate, CPropertyPage)

CPPTemplate::CPPTemplate()
	:	CPropertyPage	(CPPTemplate::IDD),
		m_pToolTips		(NULL)
{
}

CPPTemplate::~CPPTemplate()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPTemplate::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPTemplate::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CPPTemplate, CPropertyPage)
END_MESSAGE_MAP()

// CPPTemplate message handlers
BOOL CPPTemplate::OnInitDialog()
{
	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPTemplate::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Next]
		g_pSheet->SetWizardButtons(CPPTemplate::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}
