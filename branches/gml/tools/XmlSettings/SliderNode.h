#ifndef SLIDERNODE_H
#define SLIDERNODE_H
#include "ValueNode.h"

class SliderNode : public ValueNode {
public:
	SliderNode(SettingNode *pParent);
	virtual bool SetProperty(std::string szProperty, std::string szValue);
	virtual const char *GetType();
	virtual int GetHeight();
	virtual bool Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h);
	virtual std::string GetControlValue();
	virtual void SetControlValue(std::string szValue);

	virtual void Show();
	virtual void Hide();

	static const char *Type;
private:
	std::string m_szCaption;
	std::string m_szHint;
	int m_nMin;
	int m_nMax;
	int m_nTickFreq;
	std::string m_szMin;
	std::string m_szMax;
	std::vector<HWND> m_labels;

};
#endif
