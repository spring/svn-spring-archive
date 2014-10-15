#if !defined(AFX_EDITIRCMESSAGELINE_H__DA43599D_1B9A_4617_AC7E_F508963352A4__INCLUDED_)
#define AFX_EDITIRCMESSAGELINE_H__DA43599D_1B9A_4617_AC7E_F508963352A4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// EditIrcMessageLine.h : header file
//

#define	IRCEDN_RETURNPRESSED	(WM_USER+1001)
#define	NAME_RETURNPRESSED		(WM_USER+1002)
#define	JOIN_RETURNPRESSED		(WM_USER+1003)

/////////////////////////////////////////////////////////////////////////////
// SendMessageOnReturn window

class SendMessageOnReturn : public CEdit
{
// Construction
public:
	SendMessageOnReturn(UINT message);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(SendMessageOnReturn)
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~SendMessageOnReturn();

	// Generated message map functions
protected:
	//{{AFX_MSG(SendMessageOnReturn)
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	//}}AFX_MSG

	UINT mess;

	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EDITIRCMESSAGELINE_H__DA43599D_1B9A_4617_AC7E_F508963352A4__INCLUDED_)
