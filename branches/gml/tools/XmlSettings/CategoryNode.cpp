#include "CategoryNode.h"

const char *CategoryNode::Type="Category";

const char *CategoryNode::GetType() {
	return "Category";
}
bool CategoryNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	CreateChildNodes(hParent,hInstance,x,y);
	return true;
}

CategoryNode::CategoryNode(SettingNode *pParent) : SettingNode(pParent) {
	m_szName="noname";
}

std::string CategoryNode::GetName() {
	return m_szName;
}

bool CategoryNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Name")==0) {
		m_szName=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}