#ifndef CATEGORIESNODE_H
#define CATEGORIESNODE_H
#include "SettingNode.h"
#include <map>

class CategoriesNode : public SettingNode {
public:
	CategoriesNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool AllowChild(std::string szType);
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual bool OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval);
	virtual void Show();
	virtual void Hide();

	static const char *Type;
protected:
	virtual bool CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y);
	int m_nTabHeight;
	int m_nTopSpacing;
	int m_nSelected;
	bool m_bHidden;
	std::map<int,int> m_commands;
	std::vector<HWND> m_buttons;
};
#endif
