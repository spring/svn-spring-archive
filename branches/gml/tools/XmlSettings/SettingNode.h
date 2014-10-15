#ifndef SETTINGNODE_H
#define SETTINGNODE_H

#include <windows.h>
#include <string>
#include <vector>

class SettingNode {
public:
	SettingNode(SettingNode *pParent);
	virtual ~SettingNode();
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	SettingNode* GetParentNode();
	virtual const char *GetType();
	virtual int GetHeight();
	virtual int GetWidth();
	virtual bool AllowChild(std::string szType);
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual void Show();
	virtual void Hide();
	virtual bool OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval);
	virtual void OnNewChild(SettingNode *pChild);
	virtual bool OnAction(SettingNode *pSource, std::string szAction);
	virtual void AddTooltip(HWND hChild, HINSTANCE hInstance, std::string szTip);
	virtual HWND GetTooltipWindow();

	SettingNode* FindTaggedChild(std::string tag); // not recursive!
	std::string GetTag();

	static const char *Type;
	static int ToInt(std::string szValue);
	static std::string FromInt(int nValue);
protected:
	int m_nControlSpacing;
	int m_nLineHeight;
	int m_nButtonHeight;
	int m_nMinWidth;
	std::string m_szTag;

	std::vector<SettingNode *> m_children;
	SettingNode *m_pParent;
	HWND m_hWnd;

	virtual bool CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y);
	void SetChildrenProperty(std::string szProperty, std::string szValue);
	int GetNextFreeCommand();
	SettingNode *GetNearestParent(const char *pType);
private:
	int m_nNextFreeCommand;
};
#endif
