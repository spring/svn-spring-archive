#pragma once

#include "RtsSettingsWiz.h"

// CRtsSettingsWizDlg
class CRtsSettingsWizDlg : public CPropertySheet
{
	DECLARE_DYNAMIC(CRtsSettingsWizDlg)

public:
	CRtsSettingsWizDlg(UINT iSelectPage = 0, CWnd* pParentWnd = NULL);
	virtual ~CRtsSettingsWizDlg();

protected:
	HICON			m_hIcon;
	
// Tool tips
	CToolTipCtrl*	m_pToolTips;

// Pages
public:
	CPPGeneral		m_PPGeneral;
	CPPMap			m_PPMap;
	CPPEnvironment	m_PPEnvironment;
	CPPUnits		m_PPUnits;
	CPPSound		m_PPSound;
	CPPTweaks		m_PPTweaks;
	CPPTemplate		m_PPTemplate;
	
// DDX/DDV support
protected:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	virtual void DoDataExchange(CDataExchange* pDX);

// General methods
public:
	static BOOL InitToolTips(CWnd* pParentWnd, CToolTipCtrl*& hpToolTips);
	static void UpdateScrlToolTip(CWnd* pParentWnd, CToolTipCtrl* pToolTips, UINT idFrom);

// Generated message map functions
protected:
	afx_msg BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	DECLARE_MESSAGE_MAP()
};


