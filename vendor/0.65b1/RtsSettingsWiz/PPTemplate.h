#pragma once

// CPPTemplate  dialog
class CPPTemplate : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPTemplate)

public:
	CPPTemplate();
	virtual ~CPPTemplate();

// Dialog Data
public:
	enum { IDD = IDD_PPTEMPLATE };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_NEXT) };

	// Variables
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
};
