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
	CSliderCtrl VerboseLevel;
	CComboBox ScreenRes;
	CButton AdvUnitRendering;
	CButton AdvTree;
	CButton AdvCloud;
	CButton DynCloud;
	CButton RefWater;
	CButton Fullscreen;
	CButton CatchAIExceptions;
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
	CSliderCtrl SoundVolume;
	CEdit xres;
	CEdit yres;
	afx_msg void OnCbnSelchangeScreenres();
	CSliderCtrl GroundDecals;
	CEdit frequency;
	CButton simpleColors;
	afx_msg void OnBnClickedAdvwater8();
	afx_msg void OnEnChangeVerboselevel();
	afx_msg void OnNMCustomdrawSlider2(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnBnClickedAdvwater7();
};
