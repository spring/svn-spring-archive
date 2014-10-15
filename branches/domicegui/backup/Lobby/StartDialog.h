#pragma once


// StartDialog dialog

enum RESULT {Nothing = 0, Join = 1, NewServer = 2, OwnServer = 3};

class StartDialog : public CDialog
{
	DECLARE_DYNAMIC(StartDialog)

public:
	StartDialog(CWnd* pParent = NULL);   // standard constructor
	virtual ~StartDialog();

// Dialog Data
	enum { IDD = IDD_START };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedQuit();
	afx_msg void OnBnClickedJoin();
	afx_msg void OnBnClickedNewServer();
	afx_msg void OnBnClickedOwnServer();
	afx_msg void OnClose();
	int GetResult(void);
	RESULT result;
};
