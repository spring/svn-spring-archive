// StartDialog.cpp : implementation file
//

#include "stdafx.h"
#include "Lobby.h"
#include "StartDialog.h"
#include ".\startdialog.h"


// StartDialog dialog

IMPLEMENT_DYNAMIC(StartDialog, CDialog)
StartDialog::StartDialog(CWnd* pParent /*=NULL*/)
	: CDialog(StartDialog::IDD, pParent)
	, result(Nothing)
{
}

StartDialog::~StartDialog()
{
}

void StartDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(StartDialog, CDialog)
	ON_BN_CLICKED(IDC_QUIT, OnBnClickedQuit)
	ON_BN_CLICKED(IDC_JOIN, OnBnClickedJoin)
	ON_BN_CLICKED(IDC_NEW_SERVER, OnBnClickedNewServer)
	ON_BN_CLICKED(IDC_OWN_SERVER, OnBnClickedOwnServer)
	ON_WM_CLOSE()
END_MESSAGE_MAP()


// StartDialog message handlers

void StartDialog::OnBnClickedQuit()
{
	exit(0);
}

void StartDialog::OnBnClickedJoin()
{
	result = Join;
	OnOK();
}

void StartDialog::OnBnClickedNewServer()
{
	result = NewServer;
	OnOK();
}

void StartDialog::OnBnClickedOwnServer()
{
	result = OwnServer;
	OnOK();
}

void StartDialog::OnClose()
{
	exit(0);
}

int StartDialog::GetResult(void)
{
	return int(result);
}
