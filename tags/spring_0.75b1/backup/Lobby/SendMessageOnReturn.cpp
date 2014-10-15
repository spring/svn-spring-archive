// EditIrcMessageLine.cpp : implementation file
//

#include "stdafx.h"
#include "SendMessageOnReturn.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// SendMessageOnReturn

SendMessageOnReturn::SendMessageOnReturn(UINT message)
: mess(message)
{
}

SendMessageOnReturn::~SendMessageOnReturn()
{
}


BEGIN_MESSAGE_MAP(SendMessageOnReturn, CEdit)
	//{{AFX_MSG_MAP(SendMessageOnReturn)
	ON_WM_KEYDOWN()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// SendMessageOnReturn message handlers

void SendMessageOnReturn::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
	CEdit::OnKeyDown(nChar, nRepCnt, nFlags);

	if( nChar == VK_RETURN )
	{
		GetParent()->PostMessage(mess);
	}
}
