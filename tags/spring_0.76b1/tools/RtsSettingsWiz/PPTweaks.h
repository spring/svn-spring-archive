#pragma once

// CPPTweaks  dialog
class CPPTweaks : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPTweaks)

public:
	CPPTweaks();
	virtual ~CPPTweaks();

// Dialog Data
public:
	enum { IDD = IDD_PPTWEAKS };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_FINISH) };

	// Variables
	BOOL	m_bShowClock;
	BOOL	m_bShowPlayerInfo;
	//BOOL	m_bUseRegistry;

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
