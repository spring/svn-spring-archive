#include "CategoriesNode.h"
#include "CategoryNode.h"

const char *CategoriesNode::Type="Categories";

CategoriesNode::CategoriesNode(SettingNode *pParent) : SettingNode(pParent) {
	m_nTabHeight=24;
	m_nTopSpacing=8;
	m_nSelected=0;
	m_bHidden=false;
}
const char *CategoriesNode::GetType() {
	return CategoriesNode::Type;
}
int CategoriesNode::GetHeight() {
	int nHeight=0;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		if ((*i)->GetHeight()>nHeight)
			nHeight=(*i)->GetHeight();
	}
	return nHeight+m_nTabHeight+m_nTopSpacing;
}

bool CategoriesNode::AllowChild(std::string szType) {
	return strcmpi(szType.c_str(),CategoryNode::Type)==0;
}

bool CategoriesNode::Create(HWND hParent, HINSTANCE hInstance, int x, int y, int w, int h) {
	int nCount=m_children.size();
	if (nCount>0) {
		int nButtonSize=w/nCount;
		int i;
		for (i=0; i<nCount; i++) {
			int nCmd=GetNextFreeCommand();
			std::string szTitle="*error*";
			if (m_children[i]->GetType()==CategoryNode::Type)
				szTitle=((CategoryNode*)m_children[i])->GetName();
			HWND hWnd=CreateWindowExA(0,"BUTTON",szTitle.c_str(),WS_CHILD|WS_VISIBLE|BS_3STATE|BS_PUSHLIKE|BS_PUSHBUTTON,x+(nButtonSize*i),y,nButtonSize,m_nTabHeight,hParent,(HMENU)nCmd,hInstance,0);
			if (hWnd) {
				SendMessage(hWnd,WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),0);
				SendMessage(hWnd,BM_SETCHECK,(i==m_nSelected)?BST_CHECKED:BST_UNCHECKED,0);
			}
			m_commands[nCmd]=i;
			m_buttons.push_back(hWnd);
		}
	}
	return CreateChildNodes(hParent,hInstance,x,y+m_nTabHeight+m_nTopSpacing);
}

bool CategoriesNode::CreateChildNodes(HWND hParent, HINSTANCE hInstance, int x, int y) {
	bool bSucceeded=true;
	bool bFirst=true;
	std::vector<SettingNode*>::iterator i;
	for (i=m_children.begin(); i!=m_children.end(); i++) {
		int nWidth=(*i)->GetWidth();
		int nHeight=(*i)->GetHeight();
		if ((*i)->Create(hParent,hInstance,x,y,nWidth,nHeight)) {
			if (!bFirst)
				(*i)->Hide();
		} else {
			bSucceeded=false;
		}
		bFirst=false;
	}
	return bSucceeded;
}

bool CategoriesNode::SetProperty(std::string szProperty, std::string szValue) {
	if (strcmpi(szProperty.c_str(),"TabHeight")==0) {
		m_nTabHeight=ToInt(szValue);
		return true;
	}
	if (strcmpi(szProperty.c_str(),"TopSpacing")==0) {
		m_nTopSpacing=ToInt(szValue);
		return true;
	}
	return SettingNode::SetProperty(szProperty,szValue);
}

bool CategoriesNode::OnMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam, LRESULT *pRetval) {
	if (uMsg==WM_COMMAND) {
		std::map<int,int>::iterator cmd;
		if ((cmd=m_commands.find(LOWORD(wParam)))!=m_commands.end()) {
			int nOldSelected=m_nSelected;
			m_nSelected=cmd->second;
			if (nOldSelected!=m_nSelected) {
				int nCount=m_children.size();
				if (m_nSelected<nCount) {
					SendMessage(m_buttons[m_nSelected],BM_SETCHECK,BST_CHECKED,0);
					if (!m_bHidden)
						m_children[m_nSelected]->Show();
				}
				if (nOldSelected<nCount) {
					SendMessage(m_buttons[nOldSelected],BM_SETCHECK,BST_UNCHECKED,0);
					m_children[nOldSelected]->Hide();
				}
			}
			return true;
		}
	}
	return SettingNode::OnMessage(hwnd,uMsg,wParam,lParam,pRetval);
}

void CategoriesNode::Show() {
	m_bHidden=false;
	if (m_children.size()>m_nSelected)
		m_children[m_nSelected]->Show();
}
void CategoriesNode::Hide() {
	m_bHidden=true;
	SettingNode::Hide();
}