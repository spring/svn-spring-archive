#include <windows.h>
#include "tinyxml.h"
#include "SettingNode.h"
#include "ContainerNode.h"
#include "LabelNode.h"
#include "CategoriesNode.h"
#include "CategoryNode.h"
#include "IndentNode.h"
#include "ButtonNode.h"
#include "CheckboxNode.h"
#include "SliderNode.h"
#include "ListboxNode.h"
#include "RowNode.h"
#include "EditboxNode.h"
#include "Main.h"
#include <commctrl.h>

SettingNode *pRootNode=0;
HKEY hBaseKey=0;

#define PE_ELEMENT(x) if (pRetval==0 && strcmpi(pElement->Value(),x::Type)==0) pRetval=new x(pParent)

SettingNode *ParseElement(SettingNode *pParent, TiXmlElement *pElement) {
	if (!pElement->Value())
		return 0;
	if (pParent && !pParent->AllowChild(pElement->Value())) {
		//MessageBoxA(NULL,"Element type not allowed here",pElement->Value(),MB_OK);
		return 0;
	}
	SettingNode *pRetval=0;
	PE_ELEMENT(ContainerNode);
	PE_ELEMENT(LabelNode);
	PE_ELEMENT(CategoriesNode);
	PE_ELEMENT(CategoryNode);
	PE_ELEMENT(IndentNode);
	PE_ELEMENT(ButtonNode);
	PE_ELEMENT(CheckboxNode);
	PE_ELEMENT(RowNode);
	PE_ELEMENT(SliderNode);
	PE_ELEMENT(ListboxNode);
	PE_ELEMENT(ListItemNode);
	PE_ELEMENT(ListItemAssignerNode);
	PE_ELEMENT(EditboxNode);

	if (pRetval) {
		TiXmlAttribute *pAttribute;
		for (pAttribute=pElement->FirstAttribute(); pAttribute; pAttribute=pAttribute->Next()) {
			if (!pRetval->SetProperty(pAttribute->Name(),pAttribute->Value())) {
				//MessageBoxA(NULL,"Invalid attribute",pAttribute->Name(),MB_OK);
			}
		}
	}
	TiXmlElement *pChild;
	for (pChild=pElement->FirstChildElement(); pChild; pChild=pChild->NextSiblingElement())
		ParseElement((pRetval!=0)?pRetval:pParent,pChild);
	return pRetval;
}

SettingNode *ParseTemplate(std::string szFilename) {
	TiXmlDocument xmldoc;
	if (xmldoc.LoadFile(szFilename.c_str()) && !xmldoc.Error()) {
		return ParseElement(0,xmldoc.RootElement());
	} else {
		char szError[1024];
		wsprintfA(szError,"Error on line %d:\r\n%s",xmldoc.ErrorRow(),xmldoc.ErrorDesc());
		MessageBoxA(NULL,szError,"Error",MB_OK);
	}
	return NULL;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	InitCommonControls();
	DWORD dwDisp;
	if (!SUCCEEDED(RegCreateKeyExA(HKEY_CURRENT_USER,"Software\\SJ\\Spring",0,0,0,KEY_QUERY_VALUE|KEY_SET_VALUE,0,&hBaseKey,&dwDisp))) {
		MessageBoxA(NULL,"Could not open registry key","Setting Manager",MB_OK);
		return -1;
	}
	pRootNode=ParseTemplate("settingstemplate.xml");
	if (!pRootNode)
		MessageBoxA(NULL,"Incorrect or missing file: settingstemplate.xml", "Setting Manager:", MB_OK);
	else {
		if (pRootNode->GetType() == ContainerNode::Type) {
			ContainerNode *pContainer=(ContainerNode *)pRootNode;
			HWND hWindow=pContainer->CreateAsWindow(hInstance);
			if (hWindow) {
				ShowWindow(hWindow,SW_SHOWNORMAL);
				MSG msg;
				while (GetMessage(&msg,0,0,0)) {
					TranslateMessage(&msg);
					DispatchMessage(&msg);
				}
				DestroyWindow(hWindow);
			}
		} else MessageBoxA(NULL,"First element should be a Container","Error",MB_OK);
	}
	if (pRootNode)
		delete pRootNode;
	RegCloseKey(hBaseKey);
	return 0;
}