#include "CheckboxNode.h"	

const char *CheckboxNode::Type="Checkbox";

CheckboxNode::CheckboxNode(SettingNode *pParent) : ValueNode(pParent,true) {
	m_szCaption="";
	m_szHint="";
}
bool CheckboxNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Caption")==0) {
		m_szCaption=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Hint")==0) {
		m_szHint=szValue;
		return true;
	}
	return ValueNode::SetProperty(szProperty,szValue);
}
const char *CheckboxNode::GetType() {
	return CheckboxNode::Type;
}
int CheckboxNode::GetHeight() {
	return m_nLineHeight;
}
bool CheckboxNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	if ((m_hWnd=CreateWindowExA(0,"BUTTON",m_szCaption.c_str(),WS_CHILD|WS_VISIBLE|BS_AUTOCHECKBOX,x,y,w,h,hParent,0,hInstance,0))!=0) {
		SendMessage(m_hWnd,BM_SETCHECK,(ToInt(GetCurrentValue())>0)?BST_CHECKED:BST_UNCHECKED,0);
		SendMessage(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		if (m_szHint.length()>0)
			AddTooltip(m_hWnd,hInstance,m_szHint);
		return true;
	}
	return false;
}

std::string CheckboxNode::GetControlValue() {
	if (!m_hWnd)
		return "";
	return (SendMessage(m_hWnd,BM_GETCHECK,0,0)==BST_CHECKED)?"1":"0";
}