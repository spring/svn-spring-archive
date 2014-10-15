// RtsSettingsDlg.h : header file
//

#pragma once
#include "afxcmn.h"
#include "afxwin.h"


// CRtsSettingsDlg dialog
class CRtsSettingsDlg : public CDialog
{
// Construction
public:
	CRtsSettingsDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_RTSSETTINGS_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CSliderCtrl TreeDist;
	CSliderCtrl TerrainLod;
	CSliderCtrl UnitLodDist;
	CComboBox ScreenRes;
	CButton AdvTree;
	CButton AdvCloud;
	CButton DynCloud;
	CButton RefWater;
	CButton Fullscreen;
	afx_msg void OnBnClickedOk();
	CEdit PlayerName;
	CButton ColorElev;
	CSliderCtrl GrassDetail;
	CSliderCtrl Particles;
	CButton shadows;
	CSliderCtrl shadowMapSize;
	CSliderCtrl maxSounds;
	CButton invertMouse;
	CSliderCtrl TextureQuality;
	CEdit xres;
	CEdit yres;
	afx_msg void OnCbnSelchangeScreenres();
	CSliderCtrl GroundDecals;
	CEdit frequency;
	CButton simpleColors;
};
