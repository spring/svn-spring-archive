UPDATED: 13 May 2006

*** In order to compile the sources, you'll have to install some free 3rd-party components: ***

- TjanTracker (Included with these sources - just install janTracker.pas)
- Virtual TreeView component: http://www.lischke-online.de/VirtualTreeview/
- TWSocket (ICS): http://www.overbyte.be/frame_index.html?redirTo=/ssl.html
- GraphicEx: http://www.soft-gems.net/Graphics.php
- RichEditURL (Included with these sources - just install RichEditURL.pas)
- JVCL (http://homepages.borland.com/jedi/jvcl/) - download JVCL+JCL bundle

To enable theme support, you'll have to download several components
(you won't be able to compile the program withouth them). It is 
important that you download exactly the same version of these
components as listed here, since some of them are not compatible with 
newer versions:

- Toolbar2000 2.1.8 (http://www.jrsoftware.org/tb2k.php, download from http://files.jrsoftware.org/tb2k/)
- Patch for TB2K 2.1.8 (http://club.telepolis.com/silverpointdev/sptbxlib/tbxpatch218.zip)
- TBX 2.1 Beta 1 (http://www.g32.org/tbx/index.html)
- TntWare Delphi Unicode Controls 2.2.3 or above (http://www.tntware.com/delphicontrols/unicode/)
- SpTBXLib 1.6 (http://club.telepolis.com/silverpointdev/sptbxlib/index.htm)
- Additional TBX themes (http://www.rmklever.com/zipfiles/TBXThemes21.zip)

To install these components, you should use Silverpoint MultiInstaller
(http://club.telepolis.com/silverpointdev/multiinstaller/index.htm),
instructions on how to install them are on the same page.

*** List of 3rd-party libraries included (no need to install or download): ***

- GpTimeZone (http://17slon.com/gp/gp/gptimezone.htm)
- ESBDates (http://www.softpile.com/Development/Source_Code/Review_08509_index.html)

*** Important notes: ***

- I use Delphi 7 to compile the program (it compiles with any newer Delphi as well, haven't
  tested it with older ones though)

- You should disable all compiler warnings or simply ignore them (in Delphi 7, go to
  Tools->Debugger options->Language Exceptions->Stop on Delphi Exceptions (there should be
  no tick here - it should be disabled).

*** Credits for various graphics: ***

- Neuralize (most buttons, client status symbols and battle icons)
- RuneCrafter (splash screen and other stuff) 
- Maelstrom (NAT warning icon)
- IceXuick (map grade icons, some popup menu icons)