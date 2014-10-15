#ifndef CREATECONSOLE_H
#define CREATECONSOLE_H
#include "CEConsole.h"

CEConsole* initCGC();
void handle_mouse_up(Uint8 button);
void handle_mouse_down(Uint8 button);
void inject_input(bool& must_quit);
void inject_time_pulse(double& last_time_pulse);
void render_gui();
CEGUI::uint SDLKeyToCEGUIKey(SDLKey key);

#endif
