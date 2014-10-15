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
	CSliderCtrl TextureQuality;
	CSliderCtrl SoundVolume;
	CSliderCtrl UnitReplySoundVolume;
	CEdit xres;
	CEdit yres;
	afx_msg void OnCbnSelchangeScreenres();
	CSliderCtrl GroundDecals;
	CSliderCtrl FSAASamples;
	CStatic FSAASamplesDisp;
	CButton vsync;
	CButton simpleColors;
	afx_msg void OnEnChangeVerboselevel();
	CButton Water0;
	CButton Water1;
	CButton Water2;

	CButton zbits16, zbits24;

	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar *pScrollBar);

	void UpdateFSAAText();
	afx_msg void OnBnClicked16bitzbuf();
	afx_msg void OnBnClickedButton1();
};
