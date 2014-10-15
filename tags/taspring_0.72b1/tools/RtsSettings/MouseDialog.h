#pragma once
#include "afxcmn.h"
#include "afxwin.h"


// CMouseDialog dialog

class CMouseDialog : public CDialog
{
	DECLARE_DYNAMIC(CMouseDialog)

public:
	CMouseDialog(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMouseDialog();

// Dialog Data
	enum { IDD = IDD_DIALOG1 };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	virtual BOOL OnInitDialog();

	DECLARE_MESSAGE_MAP()
public:
	CSliderCtrl FpsSpeed;
	CSliderCtrl OverheadSpeed;
	CSliderCtrl RotOverheadSpeed;
	CSliderCtrl TWSpeed;
	afx_msg void OnBnClickedOk();
	CButton invertMouse;
	CComboBox DefaultMode;
	CButton FpsEnabled;
	CButton OverheadEnabled;
	CButton RotOverheadEnabled;
	CButton TWEnabled;
	afx_msg void OnCbnSelchangeDefaultmode();
};
