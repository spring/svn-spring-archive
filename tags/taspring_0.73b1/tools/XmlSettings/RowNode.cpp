#include "RowNode.h"

const char *RowNode::Type="Row";

RowNode::RowNode(SettingNode *pParent) : SettingNode(pParent) {
	//Do nothing :)
}
const char *RowNode::GetType() {
	return RowNode::Type;
}

int RowNode::GetHeight() {
	int nHeight=0;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if ((*i)->GetHeight()>nHeight)
			nHeight=(*i)->GetHeight();
	}
	return nHeight;
}

int RowNode::GetWidth() {
	int nWidth=0;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if (nWidth!=0)
			nWidth+=m_nControlSpacing;
		nWidth+=(*i)->GetWidth();
	}
	return nWidth;
}

bool RowNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	CreateChildNodes(hParent,hInstance,x,y);
	return true;
}
void RowNode::OnNewChild(SettingNode *pChild) {
	SettingNode::OnNewChild(pChild);
	int nMinChildWidth=(m_nMinWidth - (m_nControlSpacing*(m_children.size()-1)))/m_children.size();
	SetChildrenProperty("MinWidth",FromInt(nMinChildWidth));
}

bool RowNode::CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y) {
	bool bSucceeded=true;
	bool bFirst=true;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if (!bFirst)
			x+=m_nControlSpacing;
		bFirst=false;
		int nWidth=(*i)->GetWidth();
		int nHeight=(*i)->GetHeight();
		if ((*i)->Create(hParent,hInstance,x,y,nWidth,nHeight)) {
			x+=nWidth;
		} else bSucceeded=false;
	}
	return bSucceeded;
}

bool RowNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"MinWidth")==0 && m_children.size()>0) {
		m_nMinWidth=ToInt(szValue);
		int nMinChildWidth=(m_nMinWidth - (m_nControlSpacing*(m_children.size()-1)))/m_children.size();
		SetChildrenProperty(szProperty,FromInt(nMinChildWidth));
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}