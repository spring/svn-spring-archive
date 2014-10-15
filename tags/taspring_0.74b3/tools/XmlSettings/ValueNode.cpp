#include "ValueNode.h"
#include "Main.h"


const char *ValueNode::Type="ValueNodeType";

ValueNode::ValueNode(SettingNode *pParent, bool bIsNumber) : SettingNode(pParent) {
	m_bIsNumber=bIsNumber;
	m_szProperty="";
	m_szDefault="";
}
bool ValueNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Property")==0) {
		m_szProperty=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"Default")==0) {
		m_szDefault=szValue;
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}
const char *ValueNode::GetType() {
	return ValueNode::Type;
}
bool ValueNode::OnAction(SettingNode *pSource, std::string szAction) {
	if (strcmpi(szAction.c_str(),"ok")==0 || strcmpi(szAction.c_str(),"apply")==0) {
		SetCurrentValue(GetControlValue());
	}
	if (strcmpi(szAction.c_str(),"haschanged")==0) {
		if (GetControlValue() != GetCurrentValue())
			return true;
	}
	return SettingNode::OnAction(pSource,szAction);
}
std::string ValueNode::GetControlValue() {
	//Control should do this
	return "";
}
std::string ValueNode::GetCurrentValue() {
	if (m_szProperty.length()<1)
		return m_szDefault;
	std::string szRetval=m_szDefault;
	if (m_bIsNumber) {
		DWORD dwValue;
		DWORD dwType=REG_DWORD;
		DWORD dwLength=sizeof(DWORD);
		if (SUCCEEDED(RegQueryValueExA(hBaseKey,m_szProperty.c_str(),0,&dwType,(BYTE *)&dwValue,&dwLength)) && dwType==REG_DWORD && dwLength==sizeof(DWORD))
			szRetval=FromInt(dwValue);
	} else {
		DWORD dwRes;
		DWORD dwType;
		DWORD dwSize=1024;
		char *szOutput=new char[dwSize+1];
		while ((dwRes=RegQueryValueExA(hBaseKey,m_szProperty.c_str(),0,&dwType,(BYTE *)szOutput,&dwSize))==ERROR_MORE_DATA) {
			dwSize+=1024;
			delete[] szOutput;
			szOutput=new char[dwSize+1];
		}
		if (SUCCEEDED(dwRes) && dwType==REG_SZ) {
			szOutput[dwSize]='\0';
			szRetval=szOutput;
		}
		delete[] szOutput;
	}
	return szRetval;
}

void ValueNode::SetCurrentValue(std::string szValue) {
	if (m_szProperty.length()<1)
		return;
	if (m_bIsNumber) {
		DWORD dwValue=ToInt(szValue);
		RegSetValueExA(hBaseKey,m_szProperty.c_str(),0,REG_DWORD,(BYTE *)&dwValue,sizeof(DWORD));
	} else {
		RegSetValueExA(hBaseKey,m_szProperty.c_str(),0,REG_SZ,(BYTE *)szValue.c_str(),szValue.length()+1);
	}
}