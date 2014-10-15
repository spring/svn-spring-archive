#pragma once

// CPPUnits  dialog
class CPPUnits : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPUnits)

public:
	CPPUnits();
	virtual ~CPPUnits();

// Dialog Data
public:
	enum { IDD = IDD_PPUNITS };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_NEXT) };

	// Variables
	INT	m_iUnitLodDist;
	INT m_iUnitTextureQuality;

protected:
// Tool tips
	CToolTipCtrl*	m_pToolTips;

// DDX/DDV support
protected:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Generated message map functions
protected:
	DECLARE_MESSAGE_MAP()
	afx_msg BOOL OnInitDialog();
	virtual BOOL OnSetActive();
	afx_msg void OnNMReleasedcaptureScrl(NMHDR *pNMHDR, LRESULT *pResult);
};
