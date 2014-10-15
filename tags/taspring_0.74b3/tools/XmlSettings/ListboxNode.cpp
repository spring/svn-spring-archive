
#include "ListboxNode.h"
#include <cassert>

const char *ListboxNode::Type="Listbox";

ListboxNode::ListboxNode(SettingNode *pParent) : ValueNode(pParent,false) {
	m_szHint="";
}
bool ListboxNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"Hint")==0) {
		m_szHint=szValue;
		return true;
	}
	if (strcmpi(szProperty.c_str(),"IsNumber")==0) {
		m_bIsNumber = !!atoi(szValue.c_str());
		return true;
	}
	return ValueNode::SetProperty(szProperty,szValue);
}
const char *ListboxNode::GetType() {
	return ListboxNode::Type;
}
int ListboxNode::GetHeight() {
	return 26;
}
bool ListboxNode::AllowChild(std::string szType) {
	return !stricmp(szType.c_str(),ListItemNode::Type);
}
bool ListboxNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	if ((m_hWnd=CreateWindowA("COMBOBOX",0,WS_CHILD|WS_VISIBLE|CBS_DROPDOWNLIST,x,y,w,800,hParent,0,hInstance,0))!=0) {
		SendMessageA(m_hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
		if (m_szHint.length()>0)
			AddTooltip(m_hWnd,hInstance,m_szHint);

		std::string curVal = m_szProperty.empty() ? "" : GetCurrentValue();
		int index = 0, current = -1;
		for (std::vector<SettingNode*>::iterator i=m_children.begin();i!=m_children.end();++i) {
			assert ((*i)->GetType() == ListItemNode::Type);
			std::string itemName = ((ListItemNode*)(*i))->GetName();
			SendMessageA(m_hWnd, CB_ADDSTRING, 0, (LPARAM)(LPCTSTR)itemName.c_str());
			if (!m_szProperty.empty()) {
				if (curVal == ((ListItemNode*)(*i))->GetValue())
					current = index;
			} 
			else { // list doesnt have a direct property attached
				if (((ListItemNode*)(*i))->IsSelected())
					current = index;
			}
			index ++;
		}
		if (current >= 0)
			SendMessageA(m_hWnd, CB_SETCURSEL,(WPARAM)current, 0);

		return true;
	}
	return false;
}

bool ListboxNode::OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval) {
	if(uMsg==WM_COMMAND && HIWORD(wParam)==CBN_SELCHANGE && (HWND)lParam == m_hWnd) {
		int index = SendMessageA(m_hWnd,CB_GETCURSEL,0,0);
		if (index >= 0)
			((ListItemNode*)m_children[index])->Select();
	}
	return SettingNode::OnMessage(hwnd, uMsg, wParam, lParam, pRetval);
}

std::string ListboxNode::GetControlValue() {
	if (!m_hWnd)
		return "";
	int index = SendMessageA(m_hWnd,CB_GETCURSEL,0,0);
	if (index >= 0) {
		int ii = 0;
		for (std::vector<SettingNode*>::iterator i=m_children.begin();i!=m_children.end();++i) {
			if (ii == index)
				return ((ListItemNode*)(*i))->GetValue();
			ii ++;
		}
	}
	return "";
}
