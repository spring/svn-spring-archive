#include "LabelNode.h"

const char *LabelNode::Type="Label";

LabelNode::LabelNode(SettingNode *pParent) : SettingNode(pParent) {
	m_szCaption="No title";
}
bool LabelNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Caption")==0) {
		m_szCaption=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}
const char *LabelNode::GetType() {
	return LabelNode::Type;
}
int LabelNode::NumLines() {
	int nNumLines=1;
	std::string::size_type lastfind = 0;
	while ((lastfind=m_szCaption.find('\n', lastfind))!=std::string::npos) {
		nNumLines++;
		lastfind++;
	}
	return nNumLines;
}
int LabelNode::GetHeight() {
	return m_nLineHeight*NumLines();
}

bool LabelNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	m_hWnd=CreateWindowExA(0,"STATIC",m_szCaption.c_str(),WS_CHILD|WS_VISIBLE,x,y,w,h,hParent,0,hInstance,0);
	if (m_hWnd) {
		SendMessage(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		return true;
	}
	return false;
}