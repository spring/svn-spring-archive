#include "ButtonNode.h"

const char *ButtonNode::Type="Button";

ButtonNode::ButtonNode(SettingNode *pParent) : SettingNode(pParent) {
	m_szCaption="No title";
	m_szAction="";
}
bool ButtonNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Caption")==0) {
		m_szCaption=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Action")==0) {
		m_szAction=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}
const char *ButtonNode::GetType() {
	return ButtonNode::Type;
}

int ButtonNode::GetHeight() {
	return m_nButtonHeight;
}

bool ButtonNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	m_nCommand=GetNextFreeCommand();
	m_hWnd=CreateWindowExA(0,"BUTTON",m_szCaption.c_str(),WS_CHILD|WS_VISIBLE,x,y,w,h,hParent,(HMENU)m_nCommand,hInstance,0);
	if (m_hWnd) {
		SendMessage(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		return true;
	}
	return false;
}

bool ButtonNode::OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval) {
	if (uMsg==WM_COMMAND && LOWORD(wParam)==m_nCommand && m_szAction.length()>0) {
		OnAction(NULL,m_szAction);
	}
	return SettingNode::OnMessage(hwnd,uMsg,wParam,lParam,pRetval);
}