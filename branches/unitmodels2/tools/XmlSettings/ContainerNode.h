#ifndef CONTAINERNODE_H
#define CONTAINERNODE_H
#include "SettingNode.h"

class ContainerNode : public SettingNode {
public:
	ContainerNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual int GetWidth();
	HWND CreateAsWindow(HINSTANCE hInstance);
	std::string GetTitle();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual bool OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval);
	virtual void OnNewChild(SettingNode *pChild);
	virtual bool OnAction(SettingNode *pSource, std::string szAction);

	virtual void AddTooltip(HWND hChild, HINSTANCE hInstance, std::string szTip);
	virtual HWND GetTooltipWindow();

	static const char *Type;
private:
	static ATOM WndClass;

	ATOM RegisterClass(HINSTANCE hInstance);

	int m_nMargin;
	std::string m_szTitle;
	HWND m_hTooltipWnd;
};
#endif