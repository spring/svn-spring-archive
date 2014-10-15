#include "SettingNode.h"

const char *SettingNode::Type="SettingNode";

SettingNode::SettingNode(SettingNode *pParent) {
	m_pParent=pParent;
	if (m_pParent) {
		m_pParent->OnNewChild(this);
	} else {
		m_nControlSpacing=8;
		m_nMinWidth=512;
		m_nLineHeight=18;
		m_nButtonHeight=24;
	}
	m_nNextFreeCommand=1;
	m_hWnd=0;
}

void SettingNode::OnNewChild(SettingNode *pChild) {
	m_children.push_back(pChild);
	pChild->SetProperty("ControlSpacing",FromInt(m_nControlSpacing));
	pChild->SetProperty("LineHeight",FromInt(m_nLineHeight));
	pChild->SetProperty("MinWidth",FromInt(m_nMinWidth));
	pChild->SetProperty("ButtonHeight",FromInt(m_nButtonHeight));
}

SettingNode::~SettingNode() {
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		(*i)->m_pParent=0;
		delete (*i);
	}
	if (m_pParent) {
		for (i=m_pParent->m_children.begin(); i!=m_pParent->m_children.end(); i++) {
			if ((*i)==this) {
				m_pParent->m_children.erase(i);
				break;
			}
		}
	}
}

SettingNode* SettingNode::GetParentNode() {
	return m_pParent;
}
bool SettingNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"ControlSpacing")==0) {
		m_nControlSpacing=ToInt(szValue);
		SetChildrenProperty(szProperty,szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"LineHeight")==0) {
		m_nLineHeight=ToInt(szValue);
		SetChildrenProperty(szProperty,szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"MinWidth")==0) {
		m_nMinWidth=ToInt(szValue);
		SetChildrenProperty(szProperty,szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"ButtonHeight")==0) {
		m_nButtonHeight=ToInt(szValue);
		SetChildrenProperty(szProperty,szValue);
		return true;
	}
	return false;
}

void SettingNode::SetChildrenProperty(std::string szProperty, std::string szValue) {
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++)
		(*i)->SetProperty(szProperty,szValue);
}

const char *SettingNode::GetType() {
	return SettingNode::Type;
}

int SettingNode::GetHeight() {
	int nHeight=0;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if (nHeight!=0)
			nHeight+=m_nControlSpacing;
		nHeight+=(*i)->GetHeight();
	}
	return nHeight;
}

int SettingNode::GetWidth() {
	int nWidth=m_nMinWidth;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if ((*i)->GetWidth()>nWidth)
			nWidth=(*i)->GetWidth();
	}
	return nWidth;
}

int SettingNode::ToInt(std::string szValue) {
	if (szValue[0]=='-')
		return 0-ToInt(szValue.substr(1));
	int nValue=0;
	std::string::iterator i;
	for (i=szValue.begin(); i!=szValue.end(); i++) {
		if ((*i)>='0' && (*i)<='9') {
			nValue*=10;
			nValue+=(*i)-'0';
		} else break;
	}
	return nValue;
}

std::string SettingNode::FromInt(int nValue) {
	char szTemp[64];
	wsprintfA(szTemp,"%d",nValue);
	return szTemp;
}

bool SettingNode::AllowChild(std::string szType) {
	return true;
}

bool SettingNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	return false;
}
bool SettingNode::CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y) {
	bool bSucceeded=true;
	bool bFirst=true;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if (!bFirst)
			y+=m_nControlSpacing;
		bFirst=false;
		int nWidth=(*i)->GetWidth();
		int nHeight=(*i)->GetHeight();
		if ((*i)->Create(hParent,hInstance,x,y,nWidth,nHeight)) {
			y+=nHeight;
		} else bSucceeded=false;
	}
	return bSucceeded;
}

void SettingNode::Show() {
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++)
		(*i)->Show();
	if (m_hWnd)
		ShowWindow(m_hWnd,SW_SHOWNORMAL);
}
void SettingNode::Hide() {
	if (m_hWnd)
		ShowWindow(m_hWnd,SW_HIDE);
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++)
		(*i)->Hide();
}

bool SettingNode::OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval) {
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if ((*i)->OnMessage(hwnd,uMsg,wParam,lParam,pRetval))
			return true;
	}
	return false;
}

int SettingNode::GetNextFreeCommand() {
	int nNextFree;
	if (m_pParent)
		nNextFree=m_pParent->GetNextFreeCommand();
	else
		nNextFree=m_nNextFreeCommand;
	m_nNextFreeCommand=nNextFree+1;
	return nNextFree;
}

SettingNode *SettingNode::GetNearestParent(const char *pType) {
	if (GetType() == pType)
		return this;
	if (m_pParent)
		return m_pParent->GetNearestParent(pType);
	return 0;
}

bool SettingNode::OnAction(SettingNode *pSource, std::string szAction) {
	if (m_pParent && m_pParent!=pSource)
		if (m_pParent->OnAction(this,szAction))
			return true;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++)
		if ((*i)!=pSource && (*i)->OnAction(this,szAction))
			return true;
	return false;
}

void SettingNode::AddTooltip(HWND hChild, HINSTANCE hInstance, std::string szTip) {
	if (m_pParent)
		m_pParent->AddTooltip(hChild,hInstance,szTip);
}

HWND SettingNode::GetTooltipWindow() {
	if (m_pParent)
		return m_pParent->GetTooltipWindow();
	return 0;
}