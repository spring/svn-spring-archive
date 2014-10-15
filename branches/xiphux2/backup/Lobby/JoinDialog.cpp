// JoinDialog.cpp : implementation file
//

#include "stdafx.h"
#include "Lobby.h"
#include "JoinDialog.h"
#include ".\joindialog.h"


// JoinDialog dialog

IMPLEMENT_DYNAMIC(JoinDialog, CDialog)
JoinDialog::JoinDialog(CWnd* pParent /*=NULL*/)
	: CDialog(JoinDialog::IDD, pParent), result(""), inputWindow(JOIN_RETURNPRESSED)
{
}

JoinDialog::~JoinDialog()
{
}

void JoinDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(JoinDialog, CDialog)
	ON_BN_CLICKED(IDCANCEL, OnBnClickedCancel)
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
	ON_MESSAGE(JOIN_RETURNPRESSED, OnReturn)
	ON_WM_CREATE()
END_MESSAGE_MAP()


// JoinDialog message handlers

void JoinDialog::OnBnClickedCancel()
{
	exit(0);
}

void JoinDialog::OnBnClickedOk()
{
	GetDlgItemText(IDC_JOINEDIT, result);
	OnOK();
}

CString JoinDialog::GetResult()
{
	return result;
}

LRESULT JoinDialog::OnReturn(WPARAM, LPARAM)
{
	OnBnClickedOk();
	return 0;
}

int JoinDialog::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;

	if( !inputWindow.Create(WS_CHILD|WS_VISIBLE|ES_SUNKEN|ES_WANTRETURN|ES_MULTILINE|ES_AUTOHSCROLL, CRect(), this, IDC_RICHEDIT) )
		return -1;
	inputWindow.ModifyStyleEx(0, WS_EX_CLIENTEDGE);

	return 0;
}
