// LobbyDlg.h : header file
//

#pragma once

#include "irc.h"
#include "afxwin.h"
#include "SendMessageOnReturn.h"
#include "afxcmn.h"

struct PlayerInfo
{
public:
	PlayerInfo() { }

	PlayerInfo(const CString& n, int f)
		: name(n), faction(f) { }

	CString name;
	int		faction;
};

// LobbyDlg dialog
class LobbyDlg : public CDialog, public irc::CIrcDefaultMonitor
{
// Construction
public:
	LobbyDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_LOBBY_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	bool OnIrc_YOURHOST(const irc::CIrcMessage* pmsg);
	bool OnIrc_NICK(const irc::CIrcMessage* pmsg);
	bool OnIrc_PRIVMSG(const irc::CIrcMessage* pmsg);
	bool OnIrc_JOIN(const irc::CIrcMessage* pmsg);
	bool OnIrc_PART(const irc::CIrcMessage* pmsg);
	bool OnIrc_KICK(const irc::CIrcMessage* pmsg);
	bool OnIrc_MODE(const irc::CIrcMessage* pmsg);
	bool OnIrc_TOPIC(const irc::CIrcMessage* pmsg);

// Implementation
protected:
	HICON m_hIcon;

	// Visual controls
	CRichEditCtrl outWindow;
	SendMessageOnReturn inputWindow;
	SendMessageOnReturn nameWindow;
	CListCtrl playerList;
	CStatic nameTag;
	CButton* readyButton;
	CButton* quitButton;

	irc::CIrcSession ircSession;
	CString channel;
	std::string nick;
	std::map<int, PlayerInfo> players;
	std::map<int, std::string> faction;

	bool server;
	bool connected;

	CString strItem1;
	CString strItem2;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnSize(UINT nType, int cx, int cy);
	void printString(CString str);
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnBnClickedReadyButton();
	afx_msg LRESULT OnIrcMessageEdited(WPARAM, LPARAM);
	afx_msg LRESULT OnNameEdited(WPARAM, LPARAM);

	struct CRichEditFormat : public CHARFORMAT
	{
		CRichEditFormat()
		{
			memset(this, 0, sizeof(CHARFORMAT));
			cbSize = sizeof(CHARFORMAT);
		}
	};
};
