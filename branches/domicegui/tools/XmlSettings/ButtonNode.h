#ifndef BUTTONNODE_H
#define BUTTONNODE_H
#include "SettingNode.h"

class ButtonNode : public SettingNode {
public:
	ButtonNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual bool OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval);

	static const char *Type;
private:
	std::string m_szCaption;
	std::string m_szAction;
	int m_nCommand;
};
#endif