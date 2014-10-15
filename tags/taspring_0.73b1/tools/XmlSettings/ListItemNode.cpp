#include "ListItemNode.h"
#include "ValueNode.h"

const char *ListItemAssignerNode::Type="ListItemSettingAssigner";

ListItemAssignerNode::ListItemAssignerNode(SettingNode *pParent) : SettingNode(pParent) {
	m_nMinWidth = m_nButtonHeight = m_nLineHeight = 0;
}

const char *ListItemAssignerNode::GetType() {
	return Type;
}

bool ListItemAssignerNode::SetProperty(std::string szProperty, std::string szValue) {
	if(!stricmp(szProperty.c_str(),"AssignTo")) {
		m_dstTag=szValue;
		return true;
	}
	if(!stricmp(szProperty.c_str(),"Value")) {
		m_value=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty, szValue);
}

ValueNode* ListItemAssignerNode::FindDstNode() {
	// Find root
	SettingNode *root = this;
	while (root->GetParentNode()) 
		root = root->GetParentNode();
	
	SettingNode *node = root->FindTaggedChild(m_dstTag);
	if (node) 
		return dynamic_cast<ValueNode*>(node);
	return 0;
}

void ListItemAssignerNode::Assign() {
	ValueNode *vn = FindDstNode ();
	if (vn) vn->SetControlValue(m_value);
}

std::string ListItemAssignerNode::GetCurrentDstValue() {
	ValueNode *vn = FindDstNode();
	return vn ? vn->GetCurrentValue() : "";
}

bool ListItemAssignerNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	return true;
}

const char *ListItemNode::Type="ListItem";

const char *ListItemNode::GetType() {
	return Type;
}
bool ListItemNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	return true;
}

ListItemNode::ListItemNode(SettingNode *pParent) : SettingNode(pParent) {
	m_szName="noname";
}

std::string ListItemNode::GetName() {
	return m_szName;
}

void ListItemNode::Select() {
	for (std::vector<SettingNode*>::iterator si=m_children.begin();si!=m_children.end();++si)
		((ListItemAssignerNode*)*si)->Assign();
}

bool ListItemNode::IsSelected() {
	if (m_children.empty())
		return false;

	ListItemAssignerNode *an = (ListItemAssignerNode*)m_children.front();
	return an->GetCurrentDstValue() == an->GetValue();
}

bool ListItemNode::AllowChild(std::string szType) {
	return !stricmp(szType.c_str(), ListItemAssignerNode::Type);
}

bool ListItemNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Name")==0) {
		m_szName=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Value")==0) {
		m_value=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}
