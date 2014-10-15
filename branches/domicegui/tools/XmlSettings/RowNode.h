#ifndef ROWNODE_H
#define ROWNODE_H
#include "SettingNode.h"

class RowNode : public SettingNode {
public:
	RowNode(SettingNode *pParent);
	virtual const char *GetType();
	virtual int GetWidth();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual void OnNewChild(SettingNode *pChild);
	virtual bool CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y);
	virtual bool SetProperty(std::string szProperty, std::string szValue);

	static const char *Type;
private:
};
#endif