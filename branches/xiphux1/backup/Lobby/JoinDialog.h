#pragma once

#include "SendMessageOnReturn.h"

// JoinDialog dialog

class JoinDialog : public CDialog
{
	DECLARE_DYNAMIC(JoinDialog)

public:
	JoinDialog(CWnd* pParent = NULL);   // standard constructor
	virtual ~JoinDialog();

// Dialog Data
	enum { IDD = IDD_JOIN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	SendMessageOnReturn inputWindow;
	CString result;

	DECLARE_MESSAGE_MAP()
public:
	afx_msg LRESULT OnReturn(WPARAM, LPARAM);
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedOk();
	CString GetResult(void);
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
};
