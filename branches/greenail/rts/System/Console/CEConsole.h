#ifndef CECONSOLE_H
#define CECONSOLE_H
#include "CEGUIConfig.h"
#include <CEGUI.h>
#include "CConsole.h"

class CEConsole
{
public:
    CEConsole(const CEGUI::String& id_name, CEGUI::Window* parent = 0);
    ~CEConsole();
	void toggleVisibility();

    bool isVisible() const;
	bool CEConsole::handleRootKeyDown(const CEGUI::EventArgs& args);
	

private:
    // these must match the IDs assigned in the layout
    static const unsigned int SubmitButtonID;
    static const unsigned int EntryBoxID;
    static const unsigned int HistoryID;

    bool handleSubmit(const CEGUI::EventArgs& args);
    bool handleKeyDown(const CEGUI::EventArgs& args);

    CEGUI::Window* d_root;
    int d_historyPos;
    std::vector<CEGUI::String> d_history;
	CConsole *con;
};
#endif
