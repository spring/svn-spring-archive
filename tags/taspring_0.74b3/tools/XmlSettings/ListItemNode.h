
#ifndef LISTITEMNODE_H
#define LISTITEMNODE_H

#include "SettingNode.h"
#include <list>

class ValueNode;

class ListItemAssignerNode : public SettingNode {
public:
	ListItemAssignerNode(SettingNode *pParent);

	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	void Assign();
	std::string GetCurrentDstValue(); // search for the tagged node and return its value
	std::string GetValue() { return m_value; }
	ValueNode* FindDstNode();

	const char *GetType();
	static const char *Type;
private:
	std::string m_dstTag; // tag of setting that has to be assigned
	std::string m_value;
};

class ListItemNode : public SettingNode {
public:
	ListItemNode(SettingNode *pParent);
	virtual const char *GetType();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	std::string GetName();
	std::string GetValue() { return m_value; }
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	bool AllowChild(std::string szType);
	void Select();
	bool IsSelected(); // use the first assigner to see if this node is selected

	static const char *Type;
private:
	std::string m_szName;
	std::string m_value; // as stored in registry
};


#endif
