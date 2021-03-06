#ifndef MOUSEHANDLER_H
#define MOUSEHANDLER_H
// MouseHandler.h: interface for the CMouseHandler class.
//
//////////////////////////////////////////////////////////////////////

#include <string>
#include <vector>
#include <map>

#include "MouseCursor.h"

#define NUM_BUTTONS 5

class CInputReceiver;
class CCameraController;

class CMouseHandler  
{
public:
	void UpdateCam();
	void UpdateCursors();
	void SetCameraMode(int mode);
	void ToggleState(bool shift);
	void ToggleOverviewCamera(void);
	void HideMouse();
	void ShowMouse();
	void Draw();
	void MouseRelease(int x,int y,int button);
	void MousePress(int x,int y,int button);
	void MouseMove(int x,int y);
	CMouseHandler();
	virtual ~CMouseHandler();

	void SaveView(const std::string& name);
	bool LoadView(const std::string& name);

	int lastx;  
	int lasty;  
	bool hide;
	bool locked;
	bool invertMouse;
	float doubleClickTime;
	
	void CameraTransition(float time);
	float cameraTime;
	float cameraTimeLeft;
	float cameraTimeFactor;
	float cameraTimeExponent;

	struct ButtonPress {
		bool pressed;
		bool chorded;
		int x;
		int y;
		float3 camPos;
		float3 dir;
		float time;
		float lastRelease;
		int movement;
	};

	ButtonPress buttons[NUM_BUTTONS + 1]; /* One-bottomed. */
	float3 dir;

	CInputReceiver* activeReceiver;
	int activeButton;

	unsigned int cursorTex;
	std::string cursorText;
	std::string cursorTextRight;
	float cursorScale;	
	void DrawCursor(void);
	std::string GetCurrentTooltip(void);

	std::map<std::string, CMouseCursor*> cursorFileMap;
	std::map<std::string, CMouseCursor*> cursorCommandMap;
	//CMouseCursor *mc;

	CCameraController* currentCamController;
	std::vector<CCameraController*> camControllers;
	int currentCamControllerNum;
	CCameraController* overviewController;
	struct ViewData {
		bool operator==(const ViewData& vd) const {
			return (mode == vd.mode) && (state == vd.state);
		}
		int mode;
		std::vector<float> state;
	};
	ViewData tmpView;
	std::map<std::string, ViewData> views;

	int soundMultiselID;

protected:
	void LoadCursorFile(const std::string& filename, CMouseCursor::HotSpot);
	void AttachCursorCommand(const std::string& commandName,
	                         const std::string& filename);
	void AttachCursorCommand(const std::string& commandName,
	                         const std::string& filename1,
	                         const std::string& filename2);
public:
	void EmptyMsgQueUpdate(void);

#ifdef DIRECT_CONTROL_ALLOWED
	/* Stores if the mouse was locked or not before going into direct control,
	   so we can restore it when we return to normal. */
	bool wasLocked;
#endif
};

extern CMouseHandler* mouse;

#endif /* MOUSEHANDLER_H */
