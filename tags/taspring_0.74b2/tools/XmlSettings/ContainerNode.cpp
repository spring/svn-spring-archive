#include "ContainerNode.h"
#include <commctrl.h>


const char *ContainerNode::Type="Container";
ATOM ContainerNode::WndClass=0;

LRESULT CALLBACK ContainerWindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

ContainerNode::ContainerNode(SettingNode *pParent) : SettingNode(pParent) {
	m_szTitle="No title";
	m_nMargin=8;
	m_hTooltipWnd=0;
}

void ContainerNode::OnNewChild(SettingNode *pChild) {
	SettingNode::OnNewChild(pChild);
	SetChildrenProperty("MinWidth",FromInt(m_nMinWidth-(m_nMargin+m_nMargin)));
}

bool ContainerNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Title")==0) {
		m_szTitle=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Margin")==0) {
		m_nMargin=ToInt(szValue);
		SetChildrenProperty("MinWidth",FromInt(m_nMinWidth-(m_nMargin+m_nMargin)));
		return true;
	}
	if (strcmpi(szProperty.c_str(),"MinWidth")==0) {
		m_nMinWidth=ToInt(szValue);
		SetChildrenProperty(szProperty,FromInt(m_nMinWidth-(m_nMargin+m_nMargin)));
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}

const char *ContainerNode::GetType() {
	return ContainerNode::Type;
}
int ContainerNode::GetHeight() {
	if (m_pParent)
		return SettingNode::GetHeight()+m_nMargin+m_nMargin+m_nLineHeight;
	return SettingNode::GetHeight()+m_nMargin+m_nMargin;
}
int ContainerNode::GetWidth() {
	return SettingNode::GetWidth();
}

ATOM ContainerNode::RegisterClass(HINSTANCE hInstance) {
	if (WndClass!=0)
		return WndClass;
	WNDCLASSEXA wcx;
	ZeroMemory(&wcx,sizeof(WNDCLASSEX));
	wcx.cbSize=sizeof(WNDCLASSEX);
	wcx.lpfnWndProc=(WNDPROC)ContainerWindowProc;
	wcx.hInstance=hInstance;
	wcx.hCursor=LoadCursor(NULL,IDC_ARROW);
	wcx.hbrBackground=(HBRUSH)( COLOR_BTNFACE +1 );
	wcx.lpszClassName="SettingManagerClass";
	WndClass=RegisterClassExA(&wcx);
	return WndClass;
}

HWND ContainerNode::CreateAsWindow(HINSTANCE hInstance) {
	ATOM nClass=RegisterClass(hInstance);
	if (!nClass) {
		MessageBoxA(NULL,"Could not register class!","Error",MB_OK|MB_ICONEXCLAMATION);
		return 0;
	}
	RECT rcClient={0,0,GetWidth(),GetHeight()};
	DWORD dwStyle=WS_TILED|WS_CAPTION|WS_MINIMIZEBOX|WS_SYSMENU;
	DWORD dwExStyle=0;
	AdjustWindowRectEx(&rcClient,dwStyle,false,dwExStyle);
	int nWidth=rcClient.right-rcClient.left;
	int nHeight=rcClient.bottom-rcClient.top;
	m_hWnd=CreateWindowExA(dwExStyle,(LPCSTR)nClass,m_szTitle.c_str(),dwStyle,CW_USEDEFAULT,CW_USEDEFAULT,nWidth,nHeight,0,0,hInstance,0);
	if (m_hWnd) {
		m_hTooltipWnd=CreateWindowExA(WS_EX_TOPMOST,TOOLTIPS_CLASSA,"",WS_POPUP|TTS_NOPREFIX|TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,m_hWnd,0,hInstance,0);
		SetPropA(m_hWnd,"ContainerNode",(HANDLE)this);
		CreateChildNodes(m_hWnd,hInstance,m_nMargin,m_nMargin);
	}
	return m_hWnd;
}

bool ContainerNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	ATOM nClass=RegisterClass(hInstance);
	if (!nClass) {
		MessageBoxA(NULL,"Could not register class!","Error",MB_OK|MB_ICONEXCLAMATION);
		return 0;
	}
	DWORD dwStyle=WS_CHILD|WS_VISIBLE;
	DWORD dwExStyle=0;
	m_hWnd=CreateWindowExA(dwExStyle,(LPCSTR)nClass,m_szTitle.c_str(),dwStyle,x,y,w,h,hParent,0,hInstance,0);
	if (m_hWnd) {
		m_hTooltipWnd=CreateWindowExA(WS_EX_TOPMOST,TOOLTIPS_CLASSA,"",WS_POPUP|TTS_NOPREFIX|TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,m_hWnd,0,hInstance,0);
		SetPropA(m_hWnd,"ContainerNode",(HANDLE)this);
		HWND hLabel=CreateWindowExA(0,"STATIC",m_szTitle.c_str(),WS_CHILD|WS_VISIBLE,0,0,w,m_nLineHeight,m_hWnd,0,hInstance,0);
		if (hLabel)
			SendMessage(hLabel,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		CreateChildNodes(m_hWnd,hInstance,m_nMargin,m_nMargin+m_nLineHeight);
		return true;
	}
	return false;
}

std::string ContainerNode::GetTitle() {
	return m_szTitle;
}

bool ContainerNode::OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval) {
	if (hwnd!=m_hWnd)
		return false;
	if (uMsg==WM_CLOSE)
		OnAction(NULL,"close");
	return SettingNode::OnMessage(hwnd,uMsg,wParam,lParam,pRetval);
}

bool ContainerNode::OnAction(SettingNode *pSource, std::string szAction) {
	if (strcmpi(szAction.c_str(),"cancel")==0 || strcmpi(szAction.c_str(),"close")==0) {
		if (!OnAction(NULL,"haschanged") || MessageBoxA(m_hWnd,"Are you sure you wish to discard all changes?",m_szTitle.c_str(),MB_YESNO)==IDYES)
			PostQuitMessage(0);
		return true;
	}
	if (strcmpi(szAction.c_str(),"ok")==0) {
		bool bRetval=SettingNode::OnAction(pSource,szAction);
		PostQuitMessage(0);
		return bRetval;
	}
	return SettingNode::OnAction(pSource,szAction);
}

LRESULT CALLBACK StaticHookProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg) {
		case WM_NCHITTEST:
			return HTCLIENT;
	}
	WNDPROC pOldProc=(WNDPROC)GetPropA(hwnd,"OriginalStaticProc");
	if (pOldProc)
		CallWindowProcA(pOldProc,hwnd,uMsg,wParam,lParam);
	return DefWindowProcA(hwnd,uMsg,wParam,lParam);
}

void ContainerNode::AddTooltip(HWND hChild, HINSTANCE hInstance, std::string szTip) {
	if (!m_hTooltipWnd)
		return;
	TOOLINFOA ti;
	ZeroMemory(&ti,sizeof(TOOLINFOA));
	ti.cbSize=sizeof(TOOLINFOA);
	ti.uFlags=TTF_SUBCLASS;
	ti.hinst=hInstance;
	ti.uId=GetNextFreeCommand();
	ti.lpszText=(LPSTR)szTip.c_str();
	char szClassName[64];
	if (!GetClassNameA(hChild,szClassName,64))
		strcpy(szClassName,"");
	if (strcmpi(szClassName,"STATIC")==0 && GetPropA(hChild,"OriginalStaticProc")==0) {
		SetPropA(hChild,"OriginalStaticProc",(HANDLE)SetWindowLong(hChild,GWL_WNDPROC,(LONG)StaticHookProc));
	}

	ti.hwnd=hChild;
	RECT rcClient;
	GetClientRect(hChild,&rcClient);
	CopyRect(&ti.rect,&rcClient);
	SendMessage(m_hTooltipWnd,TTM_ADDTOOLA,0,(WPARAM)&ti);
}

HWND ContainerNode::GetTooltipWindow() {
	return m_hTooltipWnd;
}

LRESULT CALLBACK ContainerWindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg) {
		case WM_CREATE:
			return 0;
	}
	ContainerNode *pNode=(ContainerNode *)GetPropA(hwnd,"ContainerNode");
	LRESULT retval=0;
	if (pNode && pNode->OnMessage(hwnd,uMsg,wParam,lParam,&retval))
		return retval;
	return DefWindowProcA(hwnd,uMsg,wParam,lParam);
}