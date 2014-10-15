
#define SCRIPT_GETNAME 1
#define SCRIPT_SHOWHELP 2
#define SCRIPT_EXEC 3

#ifndef SWIG
class Script
{
public:
	std::string funcName, name;
};
#endif

IEditor* upsGetEditor();
void upsAddScript(const char *name);
