// GroupAiCallback.h: interface for the CGroupAICallback class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GROUPAICALLBACK_H__D3CCA6DA_BB40_40E0_A08F_211F4410E6E3__INCLUDED_)
#define AFX_GROUPAICALLBACK_H__D3CCA6DA_BB40_40E0_A08F_211F4410E6E3__INCLUDED_

#pragma warning(disable:4786)

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "IGroupAICallback.h"
#include "AICallback.h"
class CGroup;

class CGroupAICallback : public IGroupAICallback
{
public:
	CGroupAICallback(CGroup* group);
	~CGroupAICallback();

	CGroup* group;
	CAICallback aicb;

	void UpdateIcons();
	const Command* GetOrderPreview();
	bool IsSelected();

	IAICallback *GetAICallback ();
	int GetUnitLastUserOrder (int unitid);
};

#endif // !defined(AFX_GROUPAICALLBACK_H__D3CCA6DA_BB40_40E0_A08F_211F4410E6E3__INCLUDED_)
