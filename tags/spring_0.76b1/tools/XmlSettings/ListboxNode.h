
#ifndef LISTBOXNODE_H
#define LISTBOXNODE_H

#include "ValueNode.h"
#include "ListItemNode.h"

class ListboxNode : public ValueNode {
public:
	ListboxNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual std::string GetControlValue();
	virtual bool AllowChild(std::string szType);
	virtual bool OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval);

	static const char *Type;
private:
	std::string m_szHint;
};

#endif
