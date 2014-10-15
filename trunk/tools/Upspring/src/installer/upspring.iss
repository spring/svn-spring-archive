; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
SourceDir=..\..\
OutputBaseFilename=UpspringInstaller-1.54
OutputDir=src\installer\
AppName=Upspring 1.54
AppVerName=Upspring 1.54
DefaultDirName={pf}\Upspring
DefaultGroupName=Upspring
UninstallDisplayIcon={app}\upspring.exe
Compression=lzma
SolidCompression=yes

[Dirs]
Name: "{app}\shaders"
Name: "{app}\src"; Components: src
Name: "{app}\jit"
Name: "{app}\scripts"
Name: "{app}\examples"; Components: examples

[Types]
Name: "small"; Description: "Only Upspring base files"
Name: "full"; Description: "Full: Everything you need to use Upspring"
Name: "fullsrc"; Description: "Full + Source code (C++)"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "main"; Description: "Upspring base files"; Types: small full fullsrc custom; Flags: fixed
Name: "examples"; Description: "Example Spring models"; Types: full fullsrc
Name: "tatex"; Description: "TA texture pack, for use with 3DO models"; Types: full fullsrc
Name: "src"; Description: "C++ source files"; Types: fullsrc;

[Files]
Source: "upspring.exe"; DestDir: "{app}"; Components: main
Source: "DevIL.dll"; DestDir: "{app}"; Components: main
Source: "glew32.dll"; DestDir: "{app}"; Components: main
Source: "ILU.dll"; DestDir: "{app}"; Components: main
Source: "ILUT.dll"; DestDir: "{app}"; Components: main
;Source: "MSVCP71.dll"; DestDir: "{app}"; Components: main
;Source: "msvcr71.dll"; DestDir: "{app}"; Components: main
Source: "PALETTE.PAL"; DestDir: "{app}"; Components: main
Source: "skybox.dds"; DestDir: "{app}"; Components: main
Source: "views.cfg"; DestDir: "{app}"; Components: main
Source: "zlibwapi.dll"; DestDir: "{app}"; Components: main
Source: "readme.txt"; DestDir: "{app}"; Components: main
Source: "shaders\*"; DestDir: "{app}\shaders"; Components: main
Source: "scripts\*"; DestDir: "{app}\scripts"; Components: main; Flags: recursesubdirs
Source: "jit\*"; DestDir: "{app}\jit"; Components: main
Source: "data.ups"; DestDir: "{app}"; Components: main

Source: "src\*"; Excludes: "*.ncb,*.suo,*.user,*.aps,*.exe"; DestDir: "{app}\src"; Components: src; Flags: recursesubdirs

Source: "examples\*"; DestDir: "{app}\examples"; Components: examples

Source: "src\installer\texgroups.cfg"; DestDir: "{app}"; Components: tatex
Source: "src\installer\archives.cfg"; DestDir: "{app}"; Components: tatex
Source: "src\installer\Cavedog_Textures.zip"; DestDir: "{app}"; Components: tatex; Flags: nocompression

[Icons]
Name: "{group}\Upspring"; Filename: "{app}\Upspring.exe"; WorkingDir: "{app}"
Name: "{group}\Readme"; Filename: "{app}\readme.txt"
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"


