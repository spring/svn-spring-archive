// PPSound.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPSound, CPropertyPage)

CPPSound::CPPSound()
	:	CPropertyPage	(CPPSound::IDD),
		m_pToolTips		(NULL),
		m_iMaxSounds	(MAXSOUNDS_DEF)
{
}

CPPSound::~CPPSound()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPSound::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPSound::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Slider(pDX, IDC_PPSOUND_SCRL_MAXSOUNDS, m_iMaxSounds);
}

BEGIN_MESSAGE_MAP(CPPSound, CPropertyPage)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPSOUND_SCRL_MAXSOUNDS,		OnNMReleasedcaptureScrl)
END_MESSAGE_MAP()

// CPPSound message handlers
BOOL CPPSound::OnInitDialog()
{
	((CSliderCtrl*)GetDlgItem(IDC_PPSOUND_SCRL_MAXSOUNDS))->SetRange(		MAXSOUNDS_MIN,	MAXSOUNDS_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPSOUND_SCRL_MAXSOUNDS))->SetTicFreq(		MAXSOUNDS_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPSOUND_SCRL_MAXSOUNDS))->SetPageSize(	MAXSOUNDS_PAGE);

	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPSOUND_SCRL_MAXSOUNDS);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPSound::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Finished]
		g_pSheet->SetWizardButtons(CPPSound::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}

void CPPSound::OnNMReleasedcaptureScrl(NMHDR *pNMHDR, LRESULT *pResult)
{
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, (UINT)pNMHDR->idFrom);

	*pResult = 0;
}
