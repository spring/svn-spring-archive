#ifndef LABELNODE_H
#define LABELNODE_H
#include "SettingNode.h"

class LabelNode : public SettingNode {
public:
	LabelNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	int NumLines();

	static const char *Type;
private:
	std::string m_szCaption;
};
#endif