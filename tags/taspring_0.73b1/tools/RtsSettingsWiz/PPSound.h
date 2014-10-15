#pragma once

// CPPSound  dialog
class CPPSound : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPSound)

public:
	CPPSound();
	virtual ~CPPSound();

// Dialog Data
public:
	enum { IDD = IDD_PPSOUND };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_NEXT) };

	// Variables
	INT	m_iMaxSounds;

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
