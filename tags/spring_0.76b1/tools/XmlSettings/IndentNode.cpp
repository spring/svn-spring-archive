#include "IndentNode.h"

#include "ContainerNode.h"


const char *IndentNode::Type="Indent";

IndentNode::IndentNode(SettingNode *pParent) : SettingNode(pParent) {
	m_nIndent=8;
}

void IndentNode::OnNewChild(SettingNode *pChild) {
	SettingNode::OnNewChild(pChild);
	SetChildrenProperty("MinWidth",FromInt(m_nMinWidth-m_nIndent));
}
bool IndentNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Indent")==0) {
		m_nIndent=ToInt(szValue);
		SetChildrenProperty("MinWidth",FromInt(m_nMinWidth-m_nIndent));
		return true;
	}
	if (strcmpi(szProperty.c_str(),"MinWidth")==0) {
		m_nMinWidth=ToInt(szValue);
		SetChildrenProperty(szProperty,FromInt(m_nMinWidth-m_nIndent));
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}
const char *IndentNode::GetType() {
	return IndentNode::Type;
}
int IndentNode::GetWidth() {
	return SettingNode::GetWidth()+m_nIndent;
}
bool IndentNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	SettingNode::CreateChildNodes(hParent,hInstance,x+m_nIndent,y);
	return true;
}