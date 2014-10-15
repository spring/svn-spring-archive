#include "SliderNode.h"
#include <commctrl.h>

const char *SliderNode::Type="Slider";

SliderNode::SliderNode(SettingNode *pParent) : ValueNode(pParent,true) {
	m_szCaption="";
	m_szHint="";
	m_nMin=0;
	m_nMax=100;
	m_szMin="";
	m_szMax="";
	m_nTickFreq=0;
}
bool SliderNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Caption")==0) {
		m_szCaption=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Hint")==0) {
		m_szHint=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Min")==0) {
		m_nMin=ToInt(szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Max")==0) {
		m_nMax=ToInt(szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"MinTxt")==0) {
		m_szMin=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"MaxTxt")==0) {
		m_szMax=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"TickFreq")==0) {
		m_nTickFreq=ToInt(szValue);
		return true;
	}
	return ValueNode::SetProperty(szProperty,szValue);
}
const char *SliderNode::GetType() {
	return SliderNode::Type;
}
int SliderNode::GetHeight() {
	int nHeight=m_nLineHeight+m_nLineHeight;
	if (m_szCaption.length()>0)
		nHeight+=m_nLineHeight;
	return nHeight;
}
bool SliderNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	if (m_szCaption.length()>0) {
		HWND hLabel=CreateWindowExA(0,"STATIC",m_szCaption.c_str(),WS_CHILD|WS_VISIBLE,x,y,w,m_nLineHeight,hParent,0,hInstance,0);
		if (hLabel) {
			SendMessage(hLabel,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
			m_labels.push_back(hLabel);
			if (m_szHint.length()>0)
				AddTooltip(hLabel,hInstance,m_szHint);
		}
		y+=m_nLineHeight;
	}

	if ((m_hWnd=CreateWindowExA(0,TRACKBAR_CLASSA,m_szCaption.c_str(),WS_CHILD|WS_VISIBLE|TBS_AUTOTICKS|TBS_TOOLTIPS,x,y,w,m_nLineHeight,hParent,0,hInstance,0))!=0) {
		SendMessage(m_hWnd,TBM_SETRANGE,(WPARAM)true,(LPARAM) MAKELONG(m_nMin,m_nMax));
		SendMessage(m_hWnd,TBM_SETTICFREQ,m_nTickFreq,0);
		SendMessage(m_hWnd,TBM_SETPOS,(WPARAM)true,(LPARAM)ToInt(GetCurrentValue()));
		//SendMessage(m_hWnd,TBM_SETTOOLTIPS,(WPARAM)GetTooltipWindow(),0);
		SendMessage(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);

		std::string szMin=m_szMin;
		std::string szMax=m_szMax;
		if (szMin.length()<1) szMin=FromInt(m_nMin);
		if (szMax.length()<1) szMax=FromInt(m_nMax);
		y+=m_nLineHeight;
		HWND hLabel;
		hLabel=CreateWindowExA(0,"STATIC",szMin.c_str(),WS_CHILD|WS_VISIBLE|SS_LEFT,x,y,w/2,m_nLineHeight,hParent,0,hInstance,0);
		if (hLabel) {
			SendMessage(hLabel,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
			m_labels.push_back(hLabel);
			if (m_szHint.length()>0)
				AddTooltip(hLabel,hInstance,m_szHint);
		}
		hLabel=CreateWindowExA(0,"STATIC",szMax.c_str(),WS_CHILD|WS_VISIBLE|SS_RIGHT,x+(w/2),y,w/2,m_nLineHeight,hParent,0,hInstance,0);
		if (hLabel) {
			SendMessage(hLabel,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
			m_labels.push_back(hLabel);
			if (m_szHint.length()>0)
				AddTooltip(hLabel,hInstance,m_szHint);
		}
		return true;
	}
	return false;
}

std::string SliderNode::GetControlValue() {
	if (!m_hWnd)
		return "";
	return FromInt(SendMessage(m_hWnd,TBM_GETPOS,0,0));
}

void SliderNode::SetControlValue(std::string szValue) {
	SendMessage(m_hWnd,TBM_SETPOS,(WPARAM)true,(LPARAM)ToInt(szValue));
}

void SliderNode::Show() {
	std::vector<HWND>::iterator i;
	for (i=m_labels.begin(); i!=m_labels.end(); i++)
		ShowWindow((*i),SW_SHOWNORMAL);
	SettingNode::Show();
}
void SliderNode::Hide() {
	SettingNode::Hide();
	std::vector<HWND>::iterator i;
	for (i=m_labels.begin(); i!=m_labels.end(); i++)
		ShowWindow((*i),SW_HIDE);
}