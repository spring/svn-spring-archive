// LobbyDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Lobby.h"
#include "LobbyDlg.h"
#include "irc.h"
#include "lobbydlg.h"
#include "ListHdr.h"
#include "StartDialog.h"
#include <sstream>
#include <time.h>
#include "JoinDialog.h"
#include ".\lobbydlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

using namespace irc;
using namespace std;

// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// LobbyDlg dialog

LobbyDlg::LobbyDlg(CWnd* pParent /*=NULL*/)
	: CIrcDefaultMonitor(ircSession), CDialog(LobbyDlg::IDD, pParent),
	  readyButton(0), quitButton(0), inputWindow(IRCEDN_RETURNPRESSED),
	  nameWindow(NAME_RETURNPRESSED), server(false), connected(true)
{
	srand ( u_int( time(NULL) ) );

	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	nick = "TestTisten";

	IRC_MAP_ENTRY(LobbyDlg, "JOIN", OnIrc_JOIN)
	IRC_MAP_ENTRY(LobbyDlg, "KICK", OnIrc_KICK)
	IRC_MAP_ENTRY(LobbyDlg, "MODE", OnIrc_MODE)
	IRC_MAP_ENTRY(LobbyDlg, "NICK", OnIrc_NICK)
	IRC_MAP_ENTRY(LobbyDlg, "PART", OnIrc_PART)
	IRC_MAP_ENTRY(LobbyDlg, "PRIVMSG", OnIrc_PRIVMSG)
	IRC_MAP_ENTRY(LobbyDlg, "TOPIC", OnIrc_TOPIC)
	IRC_MAP_ENTRY(LobbyDlg, "NAMES", OnIrc_PRIVMSG)
	IRC_MAP_ENTRY(LobbyDlg, "002", OnIrc_YOURHOST)

	strItem1 = _T("Player");
	strItem2 = _T("Faction, race or something");

	players.insert(pair<int, PlayerInfo>(0, PlayerInfo("Olle", 0)));
	players.insert(pair<int, PlayerInfo>(1, PlayerInfo("Kalle", 1)));
	faction[0] = "Human";
	faction[1] = "Technocrate";
}

void LobbyDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST2, playerList);
	DDX_Control(pDX, IDC_OUTPUT, outWindow);
	DDX_Control(pDX, IDC_RICHEDIT, inputWindow);
	DDX_Control(pDX, IDC_NAMEEDIT, nameWindow);
	DDX_Control(pDX, IDC_NAMETAG, nameTag);
}

BEGIN_MESSAGE_MAP(LobbyDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_WM_SIZE()
	ON_WM_CREATE()
	ON_BN_CLICKED(IDC_READY_BUTTON, OnBnClickedReadyButton)
	ON_MESSAGE(IRCEDN_RETURNPRESSED, OnIrcMessageEdited)
	ON_MESSAGE(NAME_RETURNPRESSED, OnNameEdited)
END_MESSAGE_MAP()


// LobbyDlg message handlers

BOOL LobbyDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	CIrcSessionInfo si;
	ircSession.AddMonitor(this);

	si.sServer = "ludd.se.quakenet.org";
	si.iPort = 6667;
	si.sNick = nick;
	si.sUserID = nick;
	si.sFullName = "Spring Player";
	si.bIdentServer = true;
	si.iIdentServerPort = 113;
	si.sIdentServerType = "UNIX";

	bool connected = ircSession.Connect(si);

	StartDialog dialog(this);
	dialog.DoModal();
	switch ( dialog.GetResult() )
	{
	case(Join):
		{
			JoinDialog join(this);
			join.DoModal();
			channel = join.GetResult();
			if (connected)
			{
				CString s("/join " + channel);
				ircSession << CIrcMessage(s.Mid(1));
			}
			break;
		}
	case(NewServer):
		{
			server = true;
			stringstream stream(stringstream::in | stringstream::out);
			stream << "#spring" << rand() % 10000;
			channel = (stream.str()).c_str();
			if (connected)
			{
				CString s("/join " + channel);
				ircSession << CIrcMessage(s.Mid(1));
			}
			break;
		}
	case(OwnServer):
		{
			server = true;
			JoinDialog join(this);
			join.DoModal();
			channel = join.GetResult();
			if (connected)
			{
				CString s("/join " + channel);
				ircSession << CIrcMessage(s.Mid(1));
			}
			break;
		}
	default:
		exit(0);
	}

	readyButton = (CButton*)GetDlgItem(IDC_READY_BUTTON);
	quitButton = (CButton*)GetDlgItem(IDC_QUIT_BUTTON);

	ShowWindow(SW_MAXIMIZE);

	outWindow.SetSel(-1, 0);
	outWindow.SendMessage(EM_SCROLLCARET);

	CRichEditFormat f;
	f.dwMask = CFM_COLOR;
	f.crTextColor = RGB(0, 0, 0);
	outWindow.SendMessage(EM_SETCHARFORMAT, SCF_SELECTION, (LPARAM)&f);

	inputWindow.SetSel(-1, 0);
	inputWindow.SendMessage(EM_SCROLLCARET);

	inputWindow.SendMessage(EM_SETCHARFORMAT, SCF_SELECTION, (LPARAM)&f);

	outWindow.Invalidate();
	inputWindow.Invalidate();

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void LobbyDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void LobbyDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR LobbyDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

bool LobbyDlg::OnIrc_YOURHOST(const CIrcMessage* pmsg)
{
	CIrcDefaultMonitor::OnIrc_YOURHOST(pmsg);

	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
	{
		string server = str.substr(1, str.find_first_of(" ") - 1);
		printString(CString("You are now connected to server ") + server.c_str() + "\r\n");
		connected = true;
	}

	return false;
}

bool LobbyDlg::OnIrc_NICK(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
		printString(str.substr(1, str.find_first_of("!") - 1).c_str() + CString(" is now known as " + CString(str.substr(str.find_last_of(":") + 1).c_str())));

	return false;
}

bool LobbyDlg::OnIrc_TOPIC(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
		printString(str.substr(1, str.find_first_of("!") - 1).c_str() + CString(" changed topic to " + CString(str.substr(str.find_first_of(" ", str.find_first_of("#"))+2).c_str())));

	return false;
}

bool LobbyDlg::OnIrc_PRIVMSG(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
		printString(CString("<") + str.substr(1, str.find_first_of("!") - 1).c_str() + CString("> "));
	else
		printString(CString("<") + nick.c_str() + CString("> "));
	
	printString(str.substr(str.find_first_of(" ", str.find_first_of("#"))+2).c_str());

	return true;
}

bool LobbyDlg::OnIrc_JOIN(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
	{
		string user = str.substr(1, str.find_first_of("!") - 1);
		string channel = str.substr(str.find_first_of("#"), str.find_first_of("!") - 1);
		printString(user.c_str() + CString(" has joined ") + channel.c_str());
		if (user == nick && server)
		{
			CString s("TOPIC ");
			s += CString(channel.c_str()) + " Hepp";
			ircSession << CIrcMessage(s);
		}
	}
	else
		printString(CString("Trying to join channel ") + (str.substr(6)).c_str());

	return true;
}

bool LobbyDlg::OnIrc_PART(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	if (str.c_str()[0] == ':')
	{
		string user = str.substr(1, str.find_first_of("!") - 1);
		string channel = str.substr(str.find_first_of("#"), str.find_first_of("!") - 1);
		printString(user.c_str() + CString(" left ") + channel.c_str());
	}

	return true;
}

bool LobbyDlg::OnIrc_KICK(const CIrcMessage* pmsg)
{
	printString(CString("6") + pmsg->AsString().c_str() + CString("\r\n"));

	return true;
}

bool LobbyDlg::OnIrc_MODE(const CIrcMessage* pmsg)
{
	string str = string(pmsg->AsString().c_str());
	
	if (str.c_str()[0] == ':')
	{
		string user1 = str.substr(1, str.find_first_of("!") - 1);
		string user2 = str.substr(1, str.find_last_of(":") + 1);

		size_t delimPos = str.find(" +");
		if (delimPos == string::npos)
			delimPos = str.find(" -");

		char mode = str[delimPos + 1];
		switch(mode)
		{
		case('v'):
			if (str[delimPos] == '-')
				printString(user1.c_str() + CString(" removed voice from ") + user2.c_str());
			else
				printString(user1.c_str() + CString(" gave voice to ") + user2.c_str());
			break;
		case('o'):
			if (str[delimPos] == '-')
				printString(user1.c_str() + CString(" removed op status from ") + user2.c_str());
			else
				printString(user1.c_str() + CString(" gave op status to ") + user2.c_str());
			break;
		default:
			printString(CString("7") + pmsg->AsString().c_str() + CString("\r\n"));
		}
	}
	// 7:LM-sensei\DND!Stulles82@Gu|Stulle.users.quakenet.org MODE #knas +v :Tisten

	return true;
}

void LobbyDlg::OnSize(UINT nType, int cx, int cy)
{
	__super::OnSize(nType, cx, cy);
	
	outWindow.MoveWindow(5, 5, cx / 2 - 8, cy - 35);
	inputWindow.MoveWindow(5, cy - 25, cx / 2 - 8, 20);
	nameWindow.MoveWindow(cx / 2 + 48, 5, cx / 2 - 58, 20);
	playerList.MoveWindow(cx / 2 + 3, 30, cx / 2 - 8, cy / 2 - 15);
	nameTag.MoveWindow(cx / 2 + 3, 7, 40, 20);

	readyButton ? readyButton->MoveWindow(cx / 2 + 10, cy - 25, 50, 21) : 0;
	quitButton ? quitButton->MoveWindow(cx / 2 + 70, cy - 25, 50, 21) : 0;
}

void LobbyDlg::printString(CString str)
{
	outWindow.SetSel(-1, 0);
	outWindow.SendMessage(EM_SCROLLCARET);
	outWindow.ReplaceSel(str);
}

int LobbyDlg::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (__super::OnCreate(lpCreateStruct) == -1)
		return -1;

	if( !outWindow.Create(WS_CHILD|WS_VISIBLE|ES_SUNKEN|ES_READONLY|WS_BORDER|ES_MULTILINE|ES_AUTOHSCROLL|ES_AUTOVSCROLL|WS_HSCROLL|WS_VSCROLL, CRect(), this, IDC_OUTPUT) )
		return -1;

	if( !inputWindow.Create(WS_CHILD|WS_VISIBLE|ES_SUNKEN|ES_WANTRETURN|ES_MULTILINE|ES_AUTOHSCROLL, CRect(), this, IDC_RICHEDIT) )
		return -1;
	inputWindow.ModifyStyleEx(0,WS_EX_CLIENTEDGE);
	
	if( !nameWindow.Create(WS_CHILD|WS_VISIBLE|ES_SUNKEN|ES_WANTRETURN|ES_MULTILINE|ES_AUTOHSCROLL, CRect(), this, IDC_NAMEEDIT) )
		return -1;
	nameWindow.ModifyStyleEx(0,WS_EX_CLIENTEDGE);

	playerList.Create(WS_CHILD|WS_VISIBLE|ES_SUNKEN|WS_BORDER|LVS_REPORT|LVS_NOSORTHEADER|LVS_SINGLESEL, CRect(), this, IDC_LIST2);

	DWORD dwStyleOld = GetWindowLong(playerList.m_hWnd, GWL_STYLE);
	dwStyleOld &= ~LVS_NOCOLUMNHEADER;  // turn off bits specified by caller.

	playerList.DestroyWindow();
	playerList.Create(dwStyleOld, CRect(), this, IDC_LIST2);
	playerList.ModifyStyleEx(0,WS_EX_CLIENTEDGE); // renew the 3D border of the control

	{
		int             iItem = 0;

		CListHdrApp* pApp = (CListHdrApp *)AfxGetApp();

		// insert two columns (REPORT mode) and modify the new header items
		CRect           rect;
		playerList.GetWindowRect(&rect);
		playerList.InsertColumn(0, strItem1, LVCFMT_LEFT, 60, 0);
		playerList.InsertColumn(1, strItem2, LVCFMT_LEFT, 150, 1);

		LV_ITEM         lvitem;
		for (map<int, PlayerInfo>::iterator it = players.begin(); it != players.end(); ++it)
		{
			lvitem.mask = LVIF_TEXT;
			lvitem.iItem = iItem;
			lvitem.iSubItem = 0;
			lvitem.pszText = it->second.name.GetBuffer();

			lvitem.iItem = playerList.InsertItem(&lvitem); // insert new item
			
			lvitem.iSubItem = 1;
			lvitem.pszText = LPSTR(faction.find(it->second.faction)->second.c_str());

			playerList.SetItem(&lvitem);
		}
	}

	if( !nameTag.Create("Name", WS_CHILD|WS_VISIBLE, CRect(), this, IDC_NAMETAG) )
		return -1;

	return 0;
}

void LobbyDlg::OnBnClickedReadyButton()
{
	// TODO: Add your control notification handler code here
}

LRESULT LobbyDlg::OnIrcMessageEdited(WPARAM, LPARAM)
{
	CString s;

	inputWindow.GetWindowText(s);
	if( s.GetLength() == 0 )
		return 0;

	if( s[0] != '/' )
		s = "PRIVMSG " + channel + " :" + s;
	else
		s = s.Mid(1);

	if( ircSession )
		ircSession << CIrcMessage(s);

	inputWindow.SetWindowText(_T(""));

	return 0;
}

LRESULT LobbyDlg::OnNameEdited(WPARAM, LPARAM)
{
	CString s;

	nameWindow.GetWindowText(s);

	nick = string(s);

	if( s.GetLength() == 0 )
		return 0;

	if( s[0] != '/' )
		s = "NICK " + s;
	else
		s = s.Mid(1);

	if( ircSession )
		ircSession << CIrcMessage(s);

	nameWindow.SetWindowText(_T(""));

	return 0;
}
