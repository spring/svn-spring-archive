#include "StdAfx.h"
#include <SDL.h>
#include "CEGUIConfig.h"
#include <CEGUI.h>
#include <renderers/OpenGLGUIRenderer/openglrenderer.h>
#include <CEGUIXMLParser.h>
#include <CEGUIXMLHandler.h>
#include <CEGUIXMLAttributes.h>
#include "CEConsole.h"
//#include "CConsole.h"
static CEConsole * con;

using namespace CEGUI;
void handle_mouse_up(Uint8 button)
	{
	switch ( button )
		{
		case SDL_BUTTON_LEFT:
			CEGUI::System::getSingleton().injectMouseButtonUp(CEGUI::LeftButton);
			break;
		case SDL_BUTTON_MIDDLE:
			CEGUI::System::getSingleton().injectMouseButtonUp(CEGUI::MiddleButton);
			break;
		case SDL_BUTTON_RIGHT:
			CEGUI::System::getSingleton().injectMouseButtonUp(CEGUI::RightButton);
			break;
		}
	}
void handle_mouse_down(Uint8 button)
	{
	switch ( button )
		{
		// handle real mouse buttons
		case SDL_BUTTON_LEFT:
			CEGUI::System::getSingleton().injectMouseButtonDown(CEGUI::LeftButton);
			break;
		case SDL_BUTTON_MIDDLE:
			CEGUI::System::getSingleton().injectMouseButtonDown(CEGUI::MiddleButton);
			break;
		case SDL_BUTTON_RIGHT:
			CEGUI::System::getSingleton().injectMouseButtonDown(CEGUI::RightButton);
			break;
		
		// handle the mouse wheel
		case SDL_BUTTON_WHEELDOWN:
			CEGUI::System::getSingleton().injectMouseWheelChange( -1 );
			break;
		case SDL_BUTTON_WHEELUP:
			CEGUI::System::getSingleton().injectMouseWheelChange( +1 );
			break;
		}
	}

void inject_input(bool& must_quit)
{
// now built into main lesson2.cpp loop
}
void inject_time_pulse(double& last_time_pulse)
{
	// get current "run-time" in seconds
	double t = 0.001*SDL_GetTicks();

	// inject the time that passed since the last call 
	CEGUI::System::getSingleton().injectTimePulse( float(t-last_time_pulse) );

	// store the new time as the last time
	last_time_pulse = t;
}
void render_gui()
{
	// clear the colour buffer
	//glClear( GL_COLOR_BUFFER_BIT );

	// render the GUI :)
	CEGUI::System::getSingleton().renderGUI();
	// Update the screen
	//
}

CEConsole* initCGC()
{

try
   {

      CEGUI::Renderer* d_renderer = new CEGUI::OpenGLRenderer(1024);
		new CEGUI::System(d_renderer);


      SDL_ShowCursor(SDL_DISABLE);
      SDL_EnableUNICODE(1);
      SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);


      // load in the scheme file, which auto-loads the TaharezLook imageset
	
	CEGUI::SchemeManager::getSingleton().loadScheme("CEdatafiles/schemes/TaharezLook.scheme");
	CEGUI::SchemeManager::getSingleton().loadScheme("CEdatafiles/schemes/VanillaSkin.scheme");
      // load in a font.  The first font loaded automatically becomes the default font.
      CEGUI::FontManager::getSingleton().createFont("CEdatafiles/fonts/Commonwealth-10.font");
      CEGUI::System::getSingleton().setDefaultFont("Commonwealth-10");
      CEGUI::System::getSingleton().setDefaultMouseCursor("TaharezLook", "MouseArrow");
      CEGUI::WindowManager& wmgr = CEGUI::WindowManager::getSingleton();
      CEGUI::Window* myRoot = wmgr.createWindow("DefaultWindow", "root");
      CEGUI::System::getSingleton().setGUISheet(myRoot);
		
      con = new CEConsole("con");
	  myRoot->subscribeEvent(Window::EventKeyDown, Event::Subscriber(&CEConsole::handleRootKeyDown,con));
	  //return con;
   }
   catch (CEGUI::Exception& e)
   {
      fprintf(stderr,"CEGUI Exception occured: \n%s\n", e.getMessage().c_str());
      printf("quiting...\n");
      exit(1);
      // you could quit here
   }
	return con;
}



/* Copied from: http://www.cegui.org.uk/wiki/index.php/SDL_to_CEGUI_keytable */

/************************************************************************
    Translate a SDLKey to the proper CEGUI::Key
*************************************************************************/
CEGUI::uint SDLKeyToCEGUIKey(SDLKey key)
{
	using namespace CEGUI;
	switch (key)
	{
		case SDLK_BACKSPACE:    return Key::Backspace;
		case SDLK_TAB:          return Key::Tab;
		case SDLK_RETURN:       return Key::Return;
		case SDLK_PAUSE:        return Key::Pause;
		case SDLK_ESCAPE:       return Key::Escape;
		case SDLK_SPACE:        return Key::Space;
		case SDLK_COMMA:        return Key::Comma;
		case SDLK_MINUS:        return Key::Minus;
		case SDLK_PERIOD:       return Key::Period;
		case SDLK_SLASH:        return Key::Slash;
		case SDLK_0:            return Key::Zero;
		case SDLK_1:            return Key::One;
		case SDLK_2:            return Key::Two;
		case SDLK_3:            return Key::Three;
		case SDLK_4:            return Key::Four;
		case SDLK_5:            return Key::Five;
		case SDLK_6:            return Key::Six;
		case SDLK_7:            return Key::Seven;
		case SDLK_8:            return Key::Eight;
		case SDLK_9:            return Key::Nine;
		case SDLK_COLON:        return Key::Colon;
		case SDLK_SEMICOLON:    return Key::Semicolon;
		case SDLK_EQUALS:       return Key::Equals;
		case SDLK_LEFTBRACKET:  return Key::LeftBracket;
		case SDLK_BACKSLASH:    return Key::Backslash;
		case SDLK_RIGHTBRACKET: return Key::RightBracket;
		case SDLK_a:            return Key::A;
		case SDLK_b:            return Key::B;
		case SDLK_c:            return Key::C;
		case SDLK_d:            return Key::D;
		case SDLK_e:            return Key::E;
		case SDLK_f:            return Key::F;
		case SDLK_g:            return Key::G;
		case SDLK_h:            return Key::H;
		case SDLK_i:            return Key::I;
		case SDLK_j:            return Key::J;
		case SDLK_k:            return Key::K;
		case SDLK_l:            return Key::L;
		case SDLK_m:            return Key::M;
		case SDLK_n:            return Key::N;
		case SDLK_o:            return Key::O;
		case SDLK_p:            return Key::P;
		case SDLK_q:            return Key::Q;
		case SDLK_r:            return Key::R;
		case SDLK_s:            return Key::S;
		case SDLK_t:            return Key::T;
		case SDLK_u:            return Key::U;
		case SDLK_v:            return Key::V;
		case SDLK_w:            return Key::W;
		case SDLK_x:            return Key::X;
		case SDLK_y:            return Key::Y;
		case SDLK_z:            return Key::Z;
		case SDLK_DELETE:       return Key::Delete;
		case SDLK_KP0:          return Key::Numpad0;
		case SDLK_KP1:          return Key::Numpad1;
		case SDLK_KP2:          return Key::Numpad2;
		case SDLK_KP3:          return Key::Numpad3;
		case SDLK_KP4:          return Key::Numpad4;
		case SDLK_KP5:          return Key::Numpad5;
		case SDLK_KP6:          return Key::Numpad6;
		case SDLK_KP7:          return Key::Numpad7;
		case SDLK_KP8:          return Key::Numpad8;
		case SDLK_KP9:          return Key::Numpad9;
		case SDLK_KP_PERIOD:    return Key::Decimal;
		case SDLK_KP_DIVIDE:    return Key::Divide;
		case SDLK_KP_MULTIPLY:  return Key::Multiply;
		case SDLK_KP_MINUS:     return Key::Subtract;
		case SDLK_KP_PLUS:      return Key::Add;
		case SDLK_KP_ENTER:     return Key::NumpadEnter;
		case SDLK_KP_EQUALS:    return Key::NumpadEquals;
		case SDLK_UP:           return Key::ArrowUp;
		case SDLK_DOWN:         return Key::ArrowDown;
		case SDLK_RIGHT:        return Key::ArrowRight;
		case SDLK_LEFT:         return Key::ArrowLeft;
		case SDLK_INSERT:       return Key::Insert;
		case SDLK_HOME:         return Key::Home;
		case SDLK_END:          return Key::End;
		case SDLK_PAGEUP:       return Key::PageUp;
		case SDLK_PAGEDOWN:     return Key::PageDown;
		case SDLK_F1:           return Key::F1;
		case SDLK_F2:           return Key::F2;
		case SDLK_F3:           return Key::F3;
		case SDLK_F4:           return Key::F4;
		case SDLK_F5:           return Key::F5;
		case SDLK_F6:           return Key::F6;
		case SDLK_F7:           return Key::F7;
		case SDLK_F8:           return Key::F8;
		case SDLK_F9:           return Key::F9;
		case SDLK_F10:          return Key::F10;
		case SDLK_F11:          return Key::F11;
		case SDLK_F12:          return Key::F12;
		case SDLK_F13:          return Key::F13;
		case SDLK_F14:          return Key::F14;
		case SDLK_F15:          return Key::F15;
		case SDLK_NUMLOCK:      return Key::NumLock;
		case SDLK_SCROLLOCK:    return Key::ScrollLock;
		case SDLK_RSHIFT:       return Key::RightShift;
		case SDLK_LSHIFT:       return Key::LeftShift;
		case SDLK_RCTRL:        return Key::RightControl;
		case SDLK_LCTRL:        return Key::LeftControl;
		case SDLK_RALT:         return Key::RightAlt;
		case SDLK_LALT:         return Key::LeftAlt;
		case SDLK_LSUPER:       return Key::LeftWindows;
		case SDLK_RSUPER:       return Key::RightWindows;
		case SDLK_SYSREQ:       return Key::SysRq;
		case SDLK_MENU:         return Key::AppMenu;
		case SDLK_POWER:        return Key::Power;
		default:                return 0;
	}
	return 0;
}

