#pragma once


// CPPMisc dialog

class CPPMisc : public CPropertyPage
{
	DECLARE_DYNAMIC(CPPMisc)

public:
	CPPMisc();
	virtual ~CPPMisc();

// Dialog Data
	enum { IDD = IDD_PPMISC };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
};
