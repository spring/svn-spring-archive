// PPUnits.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPUnits, CPropertyPage)

CPPUnits::CPPUnits()
	:	CPropertyPage			(CPPUnits::IDD),
		m_pToolTips				(NULL),
		m_iUnitLodDist			(UNITLODDIST_DEF),
		m_iUnitTextureQuality	(UNITTEXTUREQUALITY_DEF)
{
}

CPPUnits::~CPPUnits()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPUnits::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPUnits::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Slider(pDX, IDC_PPUNITS_SCRL_UNITLODDIST, m_iUnitLodDist);

	// Save to variables
	if (pDX->m_bSaveAndValidate)
	{
		if (((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_1))->GetCheck()
			== BST_CHECKED)		m_iUnitTextureQuality = 0;
		else if (((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2SAI))->GetCheck()
			== BST_CHECKED)		m_iUnitTextureQuality = 1;
		else if (((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2HQ))->GetCheck()
			== BST_CHECKED)		m_iUnitTextureQuality = 2;
		else /*if (((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_4HQ))->GetCheck()
			== BST_CHECKED)*/	m_iUnitTextureQuality = 3;
	}
	// Load from variables
	else
	{
		((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_1))->SetCheck(BST_UNCHECKED);
		((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2SAI))->SetCheck(BST_UNCHECKED);
		((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2HQ))->SetCheck(BST_UNCHECKED);
		((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_4HQ))->SetCheck(BST_UNCHECKED);

		switch (m_iUnitTextureQuality)
		{
			case 0:	((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_1))->SetCheck(BST_CHECKED); break;
			case 1:	((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2SAI))->SetCheck(BST_CHECKED); break;
			case 2:	((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_2HQ))->SetCheck(BST_CHECKED); break;
			case 3:	((CButton*)GetDlgItem(IDC_PPUNITS_RADIO_UNITTEXTUREQUALITY_4HQ))->SetCheck(BST_CHECKED); break;
		}
	}
}

BEGIN_MESSAGE_MAP(CPPUnits, CPropertyPage)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPUNITS_SCRL_UNITLODDIST,	OnNMReleasedcaptureScrl)
END_MESSAGE_MAP()

// CPPUnits message handlers
BOOL CPPUnits::OnInitDialog()
{
	((CSliderCtrl*)GetDlgItem(IDC_PPUNITS_SCRL_UNITLODDIST))->SetRange(		UNITLODDIST_MIN,	UNITLODDIST_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPUNITS_SCRL_UNITLODDIST))->SetTicFreq(	UNITLODDIST_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPUNITS_SCRL_UNITLODDIST))->SetPageSize(	UNITLODDIST_PAGE);

	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPUNITS_SCRL_UNITLODDIST);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPUnits::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Next]
		g_pSheet->SetWizardButtons(CPPUnits::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}

void CPPUnits::OnNMReleasedcaptureScrl(NMHDR *pNMHDR, LRESULT *pResult)
{
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, (UINT)pNMHDR->idFrom);

	*pResult = 0;
}
