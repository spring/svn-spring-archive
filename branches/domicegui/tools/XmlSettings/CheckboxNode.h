#ifndef CHECKBOXNODE_H
#define CHECKBOXNODE_H
#include "ValueNode.h"

class CheckboxNode : public ValueNode {
public:
	CheckboxNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual std::string GetControlValue();

	static const char *Type;
private:
	std::string m_szCaption;
	std::string m_szHint;
};
#endif