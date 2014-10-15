#ifndef EDITBOXNODE_H
#define EDITBOXNODE_H
#include "ValueNode.h"

class EditboxNode : public ValueNode {
public:
	EditboxNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual std::string GetControlValue();
	virtual void SetControlValue(std::string szValue);

	static const char *Type;
private:
	std::string m_szCaption;
	std::string m_szHint;
	bool m_isNumber;

};
#endif
