#pragma once

// CPPGeneral  dialog
class CPPGeneral : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPGeneral)

public:
	CPPGeneral();
	virtual ~CPPGeneral();

// Dialog Data
public:
	enum { IDD = IDD_PPGENERAL };
	enum { WIZARDBUTTONS = (PSWIZB_NEXT) };

	CString	m_csPlayerName;
	UINT	m_uiXResolution;
	UINT	m_uiYResolution;
	BOOL	m_bFullscreen;
	BOOL	m_bInvertMouse;

protected:
// Tool tips
	CToolTipCtrl*	m_pToolTips;

// DDX/DDV support
protected:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// General funcs
	void SetupComboResSelection(void);

// Generated message map functions
protected:
	DECLARE_MESSAGE_MAP()
	afx_msg BOOL OnInitDialog();
	virtual BOOL OnSetActive();
public:
	afx_msg void OnCbnSelchangePpgeneralComboRes();
	afx_msg void OnEnChangePpgeneralEdit();
};
