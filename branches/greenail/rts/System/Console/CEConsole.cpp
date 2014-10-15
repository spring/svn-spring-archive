//////////////////////////////////////////////////////////////////////////
/*************************************************************************

    CEConsole class

*************************************************************************/
//////////////////////////////////////////////////////////////////////////
// these must match the IDs assigned in the layout
#include "StdAfx.h"
#include "CEConsole.h"
//#include "CConsole.h"


const unsigned int CEConsole::SubmitButtonID = 1;
const unsigned int CEConsole::EntryBoxID     = 2;
const unsigned int CEConsole::HistoryID      = 3;
static std::string user_name;
static bool bool_test;

CEConsole::CEConsole(const CEGUI::String& id_name, CEGUI::Window* parent) :
    d_root(CEGUI::WindowManager::getSingleton().loadWindowLayout("CEdatafiles/layouts/VanillaConsole.layout", id_name)),
	//d_root(CEGUI::SchemeManager::getSingleton().loadScheme("CEdatafiles/schemes/TaharezLook.scheme", id_name)),
	d_historyPos(0), con(NULL)
{
    using namespace CEGUI;
	con = new CConsole();
	user_name = "test";
	bool_test = false;
	// add commands 
	CEGUI::Logger::getSingleton().logEvent("Adding commands:");
	con->addItem("user_name", &user_name, CTYPE_STRING);
	con->addItem("bool_test", &bool_test, CTYPE_BOOL);
	CEGUI::Logger::getSingleton().logEvent("Creating window:");
    // we will destroy the console box windows ourselves
    d_root->setDestroyedByParent(false);

    // Do events wire-up
    d_root->subscribeEvent(Window::EventKeyDown, Event::Subscriber(&CEConsole::handleKeyDown, this));

    d_root->getChild(SubmitButtonID)->
        subscribeEvent(PushButton::EventClicked, Event::Subscriber(&CEConsole::handleSubmit, this));

    d_root->getChild(EntryBoxID)->
        subscribeEvent(Editbox::EventTextAccepted, Event::Subscriber(&CEConsole::handleSubmit, this));

    // decide where to attach the console main window
    parent = parent ? parent : CEGUI::System::getSingleton().getGUISheet();

    // attach this window if parent is valid
    if (parent)
        parent->addChildWindow(d_root);
    CEGUI::Logger::getSingleton().logEvent("CEConsole init complete:");
}

CEConsole::~CEConsole()
{
    // destroy the windows that we loaded earlier
    CEGUI::WindowManager::getSingleton().destroyWindow(d_root);
	delete con;
	CEGUI::Logger::getSingleton().logEvent("CEConsole destroyed in deconstructor:");
}

void CEConsole::toggleVisibility()
{
    d_root->isVisible(true) ? d_root->hide() : d_root->show();
	//demo->isVisible(true) ? demo->hide() : demo->show();
}

bool CEConsole::handleRootKeyDown(const CEGUI::EventArgs& args)
{
    using namespace CEGUI;

    const KeyEventArgs& keyArgs = static_cast<const KeyEventArgs&>(args);
	//std::string key = Key::Scan[keyArgs.scancode];
	printf("Keypress: %i\n", keyArgs.scancode);
    switch (keyArgs.scancode)
    {
    case Key::F12:
		printf("Toggling visibiility\n");
        this->toggleVisibility();
        break;
	case Key::Backspace:
		con->passBackspace();
		break;
		

    default:
		con->passKey(keyArgs.codepoint);
        return false;
    }

    return true;
}
bool CEConsole::isVisible() const
{
    return d_root->isVisible();
}

bool CEConsole::handleSubmit(const CEGUI::EventArgs& args)
{
    using namespace CEGUI;

    // get the text entry editbox
    Editbox* editbox = static_cast<Editbox*>(d_root->getChild(EntryBoxID));
    // get text out of the editbox
	std::string edit_text = editbox->getText().c_str();
    // if the string is not empty
    if (!edit_text.empty())
    {
		CEGUI::Logger::getSingleton().logEvent("Pushing in command "+edit_text);
		std::string command_feedback;
		command_feedback = con->parseCommandLine(edit_text);
        // add this entry to the command history buffer
		d_history.push_back(edit_text);
        // reset history position
        d_historyPos = d_history.size();
        // append newline to this entry
        edit_text += '\n';
        // get history window
        MultiLineEditbox* history = static_cast<MultiLineEditbox*>(d_root->getChild(HistoryID));
        // append new text to history output
        history->setText(history->getText() + edit_text +command_feedback);
        // scroll to bottom of history output
        history->setCaratIndex(static_cast<size_t>(-1));
        // erase text in text entry box.
        editbox->setText("");
    }

    // re-activate the text entry box
    editbox->activate();

    return true;
}

bool CEConsole::handleKeyDown(const CEGUI::EventArgs& args)
{
    using namespace CEGUI;

    // get the text entry editbox
    Editbox* editbox = static_cast<Editbox*>(d_root->getChild(EntryBoxID));

    switch (static_cast<const KeyEventArgs&>(args).scancode)
    {
    case Key::ArrowUp:
        d_historyPos = ceguimax(d_historyPos - 1, -1);
        if (d_historyPos >= 0)
        {
            editbox->setText(d_history[d_historyPos]);
            editbox->setCaratIndex(static_cast<size_t>(-1));
        }
        else
        {
            editbox->setText("");
        }

        editbox->activate();
        break;

    case Key::ArrowDown:
        d_historyPos = ceguimin(d_historyPos + 1, static_cast<int>(d_history.size()));
        if (d_historyPos < static_cast<int>(d_history.size()))
        {
            editbox->setText(d_history[d_historyPos]);
            editbox->setCaratIndex(static_cast<size_t>(-1));
        }
        else
        {
            editbox->setText("");
        }

        editbox->activate();
        break;

    default:
        return false;
    }

    return true;
}
