#pragma once

class CInfoConsole
{
public:
	CInfoConsole(void);
	~CInfoConsole(void);
	void AddLine(char const *, ...);
};

extern CInfoConsole *info;