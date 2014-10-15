#ifndef INDENTNODE_H
#define INDENTNODE_H
#include "SettingNode.h"

class IndentNode : public SettingNode {
public:
	IndentNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetWidth();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual void OnNewChild(SettingNode *pChild);

	static const char *Type;
private:
	int m_nIndent;
};
#endif
