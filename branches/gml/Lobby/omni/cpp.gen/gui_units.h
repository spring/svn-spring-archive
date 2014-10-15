// -*- C++ -*- generated by wxGlade 0.4 on Sat Dec 31 11:17:21 2005

#include <wx/wx.h>
#include <wx/image.h>

#ifndef GUI_UNITS_H
#define GUI_UNITS_H

// begin wxGlade: ::dependencies
#include <wx/listctrl.h>
// end wxGlade


class gui_units: public wxFrame {
public:
    // begin wxGlade: gui_units::ids
    // end wxGlade

    gui_units(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_FRAME_STYLE);

private:
    // begin wxGlade: gui_units::methods
    void set_properties();
    void do_layout();
    // end wxGlade

protected:
    // begin wxGlade: gui_units::attributes
    wxStaticText* label_units_currentName;
    wxStaticBitmap* bitmap_units_currentPreview;
    wxCheckBox* checkbox_units_disabled;
    wxCheckBox* checkbox_units_limit;
    wxTextCtrl* text_units_limitData;
    wxButton* button_units_update;
    wxButton* button_units_done;
    wxButton* button_units_revertToDefaults;
    wxListCtrl* list_units_unitList;
    // end wxGlade
}; // wxGlade: end class


#endif // GUI_UNITS_H