#pragma once
#include "script.h"

class CGlobalAITestScript :
	public CScript
{
protected:
	std::string dllName;
	std::string baseDir;
public:
	CGlobalAITestScript(std::string dll, std::string base);
	~CGlobalAITestScript(void);

	void Update(void);
};
