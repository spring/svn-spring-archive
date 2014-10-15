// PPEnvironment.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPEnvironment, CPropertyPage)

CPPEnvironment::CPPEnvironment()
	:	CPropertyPage		(CPPEnvironment::IDD),
		m_pToolTips			(NULL),
		m_bAdvSky			(ADVSKY_DEF),
		m_bDynamicSky		(DYNAMICSKY_DEF),
		m_bReflectiveWater	(REFLECTIVEWATER_DEF),
		m_bColorElev		(COLORELEV_DEF),
		m_bShadows			(SHADOWS_DEF),
		m_iShadowMapSize	(SHADOWMAPSIZE_DEF)
{
}

CPPEnvironment::~CPPEnvironment()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPEnvironment::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPEnvironment::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Check(pDX, IDC_PPENVIRONMENT_CHECK_ADVSKY,			m_bAdvSky);
	DDX_Check(pDX, IDC_PPENVIRONMENT_CHECK_DYNAMICSKY,		m_bDynamicSky);
	DDX_Check(pDX, IDC_PPENVIRONMENT_CHECK_REFLECTIVEWATER,	m_bReflectiveWater);
	DDX_Check(pDX, IDC_PPENVIRONMENT_CHECK_COLORELEV,		m_bColorElev);
	DDX_Check(pDX, IDC_PPENVIRONMENT_CHECK_SHADOWS,			m_bShadows);

	// Save to variables
	if (pDX->m_bSaveAndValidate)
	{
		if (((CButton*)GetDlgItem(IDC_PPENVIRONMENT_RADIO_SHADOWMAPSIZE_1048))->GetCheck()
			== BST_CHECKED)	m_iShadowMapSize = 1024;
		else				m_iShadowMapSize = 2048;
	}
	// Load from variables
	else
	{
		if (m_iShadowMapSize == 2048)
		{
			((CButton*)GetDlgItem(IDC_PPENVIRONMENT_RADIO_SHADOWMAPSIZE_1048))->SetCheck(BST_UNCHECKED);
			((CButton*)GetDlgItem(IDC_PPENVIRONMENT_RADIO_SHADOWMAPSIZE_2048))->SetCheck(BST_CHECKED);
		}
		else /*if (m_iShadowMapSize == 1024)*/
		{
			((CButton*)GetDlgItem(IDC_PPENVIRONMENT_RADIO_SHADOWMAPSIZE_1048))->SetCheck(BST_CHECKED);
			((CButton*)GetDlgItem(IDC_PPENVIRONMENT_RADIO_SHADOWMAPSIZE_2048))->SetCheck(BST_UNCHECKED);
		}
	}
}

BEGIN_MESSAGE_MAP(CPPEnvironment, CPropertyPage)
END_MESSAGE_MAP()

// CPPEnvironment message handlers
BOOL CPPEnvironment::OnInitDialog()
{
	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPEnvironment::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Next]
		g_pSheet->SetWizardButtons(CPPEnvironment::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}
