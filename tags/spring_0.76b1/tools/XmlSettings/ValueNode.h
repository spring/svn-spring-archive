#ifndef VALUENODE_H
#define VALUENODE_H
#include "SettingNode.h"

class ValueNode : public SettingNode {
public:
	ValueNode(SettingNode *pParent, bool bIsNumber);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual bool OnAction(SettingNode *pSource, std::string szAction);

	virtual std::string GetControlValue(); //Get value from control
	virtual void SetControlValue(std::string szValue) {}
	std::string GetCurrentValue(); //Get value from registry
	void SetCurrentValue(std::string szValue); //Set value in registry

	static const char *Type;
protected:
	std::string m_szProperty;
	std::string m_szDefault;
	bool m_bIsNumber;
};
#endif
