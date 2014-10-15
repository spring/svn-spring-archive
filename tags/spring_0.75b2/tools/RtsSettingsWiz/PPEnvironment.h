#pragma once

// CPPEnvironment  dialog
class CPPEnvironment : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPEnvironment)

public:
	CPPEnvironment();
	virtual ~CPPEnvironment();

// Dialog Data
public:
	enum { IDD = IDD_PPENVIRONMENT };
	enum { WIZARDBUTTONS = (PSWIZB_BACK | PSWIZB_NEXT) };

	// Variables
	BOOL	m_bAdvSky;
	BOOL	m_bDynamicSky;
	BOOL	m_bReflectiveWater;
	BOOL	m_bColorElev;
	BOOL	m_bShadows;
	INT		m_iShadowMapSize;

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
