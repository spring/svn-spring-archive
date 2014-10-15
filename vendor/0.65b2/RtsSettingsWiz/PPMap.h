#pragma once

// CPPMap  dialog
class CPPMap : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPMap)

public:
	CPPMap();
	virtual ~CPPMap();

// Dialog Data
public:
	enum { IDD = IDD_PPMAP };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_NEXT) };

	BOOL	m_i3DTrees;
	INT		m_iTreeRadius;
	INT		m_iGrassDetail;
	INT		m_iGroundDetail;
	INT		m_iGroundDecals;
	INT		m_iMaxParticles;

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
