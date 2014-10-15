// PPMap.cpp : implementation file
#include "stdafx.h"
#include "RtsSettingsWiz.h"

IMPLEMENT_DYNAMIC(CPPMap, CPropertyPage)

CPPMap::CPPMap()
	:	CPropertyPage		(CPPMap::IDD),
		m_pToolTips			(NULL),
		m_i3DTrees			(T3DTREES_DEF),
		m_iTreeRadius		(0),
		m_iGrassDetail		(GRASSDETAIL_DEF),
		m_iGroundDetail	(GROUNDDETAIL_DEF),
		m_iGroundDecals	(GROUNDDECALS_DEF),
		m_iMaxParticles	(MAXPARTICLES_DEF)
{
}

CPPMap::~CPPMap()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CPPMap::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertyPage::PreTranslateMessage(pMsg);
}

void CPPMap::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);

	DDX_Check(pDX,	IDC_PPMAP_CHECK_3DTREES,		m_i3DTrees);
	DDX_Slider(pDX, IDC_PPMAP_SCRL_TREERADIUS,		m_iTreeRadius);
	DDX_Slider(pDX, IDC_PPMAP_SCRL_GRASSDETAIL,		m_iGrassDetail);
	DDX_Slider(pDX, IDC_PPMAP_SCRL_GROUNDDETAIL,	m_iGroundDetail);
	DDX_Slider(pDX, IDC_PPMAP_SCRL_GROUNDDECALS,	m_iGroundDecals);
	DDX_Slider(pDX, IDC_PPMAP_SCRL_MAXPARTICLES,	m_iMaxParticles);
}

BEGIN_MESSAGE_MAP(CPPMap, CPropertyPage)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_CHECK_3DTREES,		OnNMReleasedcaptureScrl)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_SCRL_TREERADIUS,	OnNMReleasedcaptureScrl)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_SCRL_GRASSDETAIL,	OnNMReleasedcaptureScrl)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_SCRL_GROUNDDETAIL,	OnNMReleasedcaptureScrl)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_SCRL_GROUNDDECALS,	OnNMReleasedcaptureScrl)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PPMAP_SCRL_MAXPARTICLES,	OnNMReleasedcaptureScrl)
END_MESSAGE_MAP()

// CPPMap message handlers
BOOL CPPMap::OnInitDialog()
{
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_TREERADIUS))->SetRange(		TREERADIUS_MIN,		TREERADIUS_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_TREERADIUS))->SetTicFreq(		TREERADIUS_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_TREERADIUS))->SetPageSize(		TREERADIUS_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GRASSDETAIL))->SetRange(		GRASSDETAIL_MIN,	GRASSDETAIL_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GRASSDETAIL))->SetTicFreq(		GRASSDETAIL_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GRASSDETAIL))->SetPageSize(	GRASSDETAIL_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDETAIL))->SetRange(		GROUNDDETAIL_MIN,	GROUNDDETAIL_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDETAIL))->SetTicFreq(	GROUNDDETAIL_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDETAIL))->SetPageSize(	GROUNDDETAIL_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDECALS))->SetRange(		GROUNDDECALS_MIN,	GROUNDDECALS_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDECALS))->SetTicFreq(	GROUNDDECALS_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_GROUNDDECALS))->SetPageSize(	GROUNDDECALS_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_MAXPARTICLES))->SetRange(		MAXPARTICLES_MIN,	MAXPARTICLES_MAX);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_MAXPARTICLES))->SetTicFreq(	MAXPARTICLES_PAGE);
	((CSliderCtrl*)GetDlgItem(IDC_PPMAP_SCRL_MAXPARTICLES))->SetPageSize(	MAXPARTICLES_PAGE);

	// Do this after grabing values, and setting up controls (ie: combo box text)
	CPropertyPage::OnInitDialog();

	// Init the tool tips
	CRtsSettingsWizDlg::InitToolTips(this, m_pToolTips);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPMAP_SCRL_TREERADIUS);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPMAP_SCRL_GRASSDETAIL);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPMAP_SCRL_GROUNDDETAIL);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPMAP_SCRL_GROUNDDECALS);
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, IDC_PPMAP_SCRL_MAXPARTICLES);

	return TRUE; // return TRUE unless you set the focus to a control
}

// Used to configure wizard buttons
BOOL CPPMap::OnSetActive() 
{
 	if (g_bFirstRun)
	{
		// Set the buttons to [Back] [Next]
		g_pSheet->SetWizardButtons(CPPMap::WIZARDBUTTONS);
	}

	return CPropertyPage::OnSetActive();
}

void CPPMap::OnNMReleasedcaptureScrl(NMHDR *pNMHDR, LRESULT *pResult)
{
	g_pSheet->UpdateScrlToolTip(this, m_pToolTips, (UINT)pNMHDR->idFrom);

	*pResult = 0;
}
