#ifndef CATEGORYNODE_H
#define CATEGORYNODE_H
#include "SettingNode.h"

class CategoryNode : public SettingNode {
public:
	CategoryNode(SettingNode *pParent);
	virtual const char *GetType();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	std::string GetName();
	virtual bool SetProperty(std::string szProperty, std::string szValue);

	static const char *Type;
private:
	std::string m_szName;
};
#endif