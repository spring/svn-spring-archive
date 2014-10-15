// RtsSettingsMain.cpp : implementation file

#include "stdafx.h"
#include "RtsSettingsWiz.h"

// CRtsSettingsWizDlg
IMPLEMENT_DYNAMIC(CRtsSettingsWizDlg, CPropertySheet)

CRtsSettingsWizDlg::CRtsSettingsWizDlg(UINT iSelectPage, CWnd* pParentWnd)
	:	CPropertySheet	(IDS_APP_TITLE, pParentWnd, iSelectPage),
		m_hIcon			(NULL),
		m_pToolTips		(NULL)
{
	// Add pages (first added is first page, last added is last page
	AddPage(&m_PPGeneral);
	AddPage(&m_PPMap);
	AddPage(&m_PPEnvironment);
	AddPage(&m_PPUnits);
	AddPage(&m_PPSound);
	AddPage(&m_PPTweaks);
	//AddPage(&m_PPTemplate);

	// Is this first run?
	if (g_bFirstRun)
	{
		SetWizardMode();
	}
}

CRtsSettingsWizDlg::~CRtsSettingsWizDlg()
{
	if (m_pToolTips)
	{
		delete m_pToolTips;
		m_pToolTips = NULL;
	}
}

// Used to enable tool tips
BOOL CRtsSettingsWizDlg::PreTranslateMessage(MSG* pMsg)
{
	if (m_pToolTips != NULL)
		m_pToolTips->RelayEvent(pMsg);

	return CPropertySheet::PreTranslateMessage(pMsg);
}

void CRtsSettingsWizDlg::DoDataExchange(CDataExchange* pDX)
{
	CPropertySheet::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CRtsSettingsWizDlg, CPropertySheet)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/*static*/ BOOL CRtsSettingsWizDlg::InitToolTips(CWnd* pParentWnd, CToolTipCtrl*& hpToolTips)
{
	if (! pParentWnd)
		return TRUE;

	// Load up all the tool tips
	if (! hpToolTips)
		hpToolTips = new CToolTipCtrl;

	if(! hpToolTips->Create(pParentWnd))
	{
		AfxMessageBox(_T("Unable to load tool tips."), MB_OK | MB_ICONERROR);
		return TRUE;
	}
	// Tool tips are ready to be added
	else
	{
		// Get first child window
		CWnd* pChildWnd = pParentWnd->GetWindow(GW_CHILD);

		while (pChildWnd != NULL)
		{
			// Grab the string with that res ID
			CString csTip;

			// If the string resource DNE
			if (! csTip.LoadString(pChildWnd->GetDlgCtrlID()))
			{
				// Get the next child window in the list
				pChildWnd = pChildWnd->GetWindow(GW_HWNDNEXT);
				continue;
			}
			// If the resource exists
			else
			{
				// Remove up to first new line
				int iOffset = csTip.Find(_T("\n"));
				if (iOffset < 0)
				{
					// Get the next child window in the list
					pChildWnd = pChildWnd->GetWindow(GW_HWNDNEXT);
					continue;
				}
				iOffset = csTip.GetLength() - (iOffset + 1);

				csTip.SetString( csTip.Right(iOffset) );

				// Remove after second new line
				iOffset = csTip.Find(_T("\n"));
				if (iOffset >= 0)
				{
					csTip.SetString( csTip.Left(iOffset) );
				}
			}

			// Add the tool tip
			hpToolTips->AddTool(pChildWnd, csTip);

			// Get the next child window in the list
			pChildWnd = pChildWnd->GetWindow(GW_HWNDNEXT);
		}

		// Set the "max number of pixels" per line
		// (if a line doesn't contain spaces, it may be larger then this number
		hpToolTips->SetMaxTipWidth(300);

		// Set the length of time the tool tip window remains visible if the
		// pointer is stationary within a tool's bounding rectangle.
		hpToolTips->SetDelayTime(TTDT_AUTOPOP, 15/*s*/ * 1000/*milliseconds*/);

		// Set the length of time the pointer must remain stationary within a
		// tool's bounding rectangle before the tool tip window appears
		hpToolTips->SetDelayTime(TTDT_INITIAL, 50);

		// Set the length of time it takes for subsequent tool tip windows to
		// appear as the pointer moves from one tool to another. 
		hpToolTips->SetDelayTime(TTDT_RESHOW, 50);

		// Turn the tips on
		hpToolTips->Activate(TRUE);
	}

	return 0;
}

/*static*/ void CRtsSettingsWizDlg::UpdateScrlToolTip(CWnd* pParentWnd, CToolTipCtrl* pToolTips, UINT idFrom)
{
	// Grab the string with that res ID
	CString csTip;

	if (! pToolTips) return;

	// If the string resource DNE
	if (! csTip.LoadString(idFrom))
	{
		csTip.SetString(_T(""));
	}
	else
	{
		// Remove up to first new line
		int iOffset = csTip.Find(_T("\n"));
		if (iOffset < 0)
		{
			csTip.SetString(_T(""));
		}
		else
		{
			iOffset = csTip.GetLength() - (iOffset + 1);

			csTip.SetString( csTip.Right(iOffset) );

			// Remove after second new line
			iOffset = csTip.Find(_T("\n"));
			if (iOffset >= 0)
			{
				csTip.SetString( csTip.Left(iOffset) );
			}
		}
	}

	// Now add in the current value
	char cCurValue[500];
	_itot(((CSliderCtrl*)pParentWnd->GetDlgItem(idFrom))->GetPos(), cCurValue, 10);

	csTip += _T(" (");
	csTip += cCurValue;
	csTip += _T(")");

	// Now insert the new text
	pToolTips->UpdateTipText(csTip, pParentWnd->GetDlgItem(idFrom));
	pToolTips->Update();
}

// CRtsSettingsWizDlg message handlers
BOOL CRtsSettingsWizDlg::OnInitDialog()
{
	if (! g_bFirstRun)
	{
		// Hide "apply" button
		GetDlgItem(ID_APPLY_NOW)->ShowWindow(SW_HIDE);

		// Move "ok" button to "cancel"
		RECT rect;

		GetDlgItem(IDCANCEL)->GetWindowRect(&rect);
		ScreenToClient(&rect);
		GetDlgItem(IDOK)->MoveWindow(&rect, TRUE);

		GetDlgItem(ID_APPLY_NOW)->GetWindowRect(&rect);
		ScreenToClient(&rect);
		GetDlgItem(IDCANCEL)->MoveWindow(&rect, TRUE);
	}
	/* Block the cancel button
	else
	{
		GetDlgItem(IDCANCEL)->EnableWindow(FALSE);
		// Also need to remove the "close" button and system menu command
	}*/

	CPropertySheet::OnInitDialog();
	
	m_hIcon = AfxGetApp()->LoadIcon(IDI_MAIN);
	if (m_hIcon == NULL)
	{
		AfxMessageBox(_T("Unabled To Load Icon."), MB_OK | MB_ICONERROR);
	}
	else
	{
		// Set the icon for this dialog.  The framework does this automatically
		//  when the application's main window is not a dialog
		SetIcon(m_hIcon, TRUE);			// Set big icon
		SetIcon(m_hIcon, FALSE);		// Set small icon
	}
	
	// Init tool tips
	InitToolTips(this, m_pToolTips);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.
void CRtsSettingsWizDlg::OnPaint() 
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
		CPropertySheet::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CRtsSettingsWizDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

BOOL CRtsSettingsWizDlg::OnCommand(WPARAM wParam, LPARAM lParam)
{
	if ((LOWORD(wParam) == IDOK) || (LOWORD(wParam) == IDCANCEL))
	{
		// Store the last open page to a variable, for later storage
		g_iCurPropertyPage = GetPageIndex(GetActivePage());
	}

	return CPropertySheet::OnCommand(wParam, lParam);
}
