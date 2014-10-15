#include "EditboxNode.h"	
#include <cassert>

const char *EditboxNode::Type="Editbox";

EditboxNode::EditboxNode(SettingNode *pParent) : ValueNode(pParent,true) {
	m_szCaption="";
	m_szHint="";
	m_isNumber=false;
}
bool EditboxNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Caption")==0) {
		m_szCaption=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Hint")==0) {
		m_szHint=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"IsNumber")==0) {
		m_isNumber=!!atoi(szValue.c_str());
		return true;
	}
	return ValueNode::SetProperty(szProperty,szValue);
}
const char *EditboxNode::GetType() {
	return EditboxNode::Type;
}
int EditboxNode::GetHeight() {
	return 22;
}
bool EditboxNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	if ((m_hWnd=CreateWindowExA(WS_EX_STATICEDGE, "EDIT",0,WS_CHILD|WS_VISIBLE|(m_isNumber ? ES_NUMBER : 0),x,y,w,h,hParent,0,hInstance,0))!=0) {
		std::string curval = GetCurrentValue();
		if (!curval.empty()) SetWindowTextA(m_hWnd, curval.c_str());
		SendMessageA(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		if (m_szHint.length()>0)
			AddTooltip(m_hWnd,hInstance,m_szHint);
		return true;
	}
	return false;
}

std::string EditboxNode::GetControlValue() {
	if (!m_hWnd)
		return "";
	char ret[64];
	GetWindowTextA(m_hWnd, ret, 64);
	return ret;
}

void EditboxNode::SetControlValue(std::string szValue) {
	SetWindowTextA(m_hWnd, szValue.c_str());
}
