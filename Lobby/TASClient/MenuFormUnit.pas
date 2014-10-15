unit MenuFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw,UWebBrowserWrapper,UContainer, StdCtrls,StrUtils,
  ExtCtrls,class_TIntegerList, MPlayer,MainUnit, SevenZipVCL,Contnrs,IniFiles,
  BotOptionsFormUnit;

const
  LUAOPTIONS_ID_MAX = 200;

type
  TPageType = (Main, ModMain, CampaignsMenu, Campaign, CampaignMission, MissionsMenu, Mission, Skirmish, Loading);

  TCampaign = class
  protected
    FLuaFileName: string;
    FLuaFile: string;
    FName: string;
    FShortDesc: string;
    FIncrustedHtml: boolean;
    FLinearCampaign: boolean;
    FIsCampaign: boolean;
    FCampaignProgressDir: string;
    FCurrentReturnLua: string;
    FWarmapPath: string;

    FNextMissionsName: TStringList;
    FNextMissionsScriptPath: TStringList;

    FTemplateVarName: TStringList;
    FTemplateVarValue: TStringList;
  public
    constructor Create(luaFileName: string);

    procedure LoadNextMission;
    procedure GetCurrentLuaFile;
    procedure LoadReturnFile;
    procedure StartMission(missionName: string);
    //procedure ResetCampaign;

    property CampaignName: string read FName;
    property ShortDesc: string read FShortDesc;
    property IncrustedHtml: boolean read FIncrustedHtml;
    property IsCampaign: boolean read FIsCampaign;
    property LinearCampaign: boolean read FLinearCampaign;
    property WarmapPath: string read FWarmapPath;
    property TemplateVarName: TStringList read FTemplateVarName;
    property TemplateVarValue: TStringList read FTemplateVarValue;
  end;

  TSPAIItem =
  record
    AIType: string;
    Id: integer;
    Team: integer;
    Side: integer;
    StartPosX: double;
    StartPosY: double;
    Handicap: integer;
    Name: string;
    UniqueId: integer;
    OptionsList: TList;
    OptionsForm: TBotOptionsForm;
  end;

  TBrowsePage =
  record
    PageName: string;
    PageType: TPageType;
  end;

  TMenuForm = class(TForm)
    Minimap: TImage;
    GameTimer: TTimer;
    MP1: TMediaPlayer;
    MP2: TMediaPlayer;
    tmrMusic: TTimer;
    SevenZip1: TSevenZip;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure htmlBrowserControlBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure htmlBrowserControlNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure GameTimerTimer(Sender: TObject);
    procedure tmrMusicTimer(Sender: TObject);
    procedure htmlBrowserControlNewWindow2(Sender: TObject;
      var ppDisp: IDispatch; var Cancel: WordBool);
    procedure htmlBrowserControlDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    HookID: THandle;
    AutorisedURLFiles: TStringList;
    MenuCurrentPath: String;
    ModMenuPath : String;
    LoadMenuFromMod: Boolean;
    CurrentPath: string;
    CurrentCampaignIndex: integer;
    CurrentWinStep: string;
    CurrentLostStep: string;
    BrowseHistory: TStack;
    soundValue: string;
    skinList: TStringList;
    currentProfileName: string;

    springExeVersion: string;
    mapListHtmlCode: string;
    selectedMap: integer;
    mapWidthPercent: integer;
    mapHeightPercent: integer;
    minimapFixedStartSize: integer;
    paramNames: TStringList;
    paramValues: TStringList;
    settingsNames: TStringList;
    settingsValues: TStringList;
    ColorsList: TStringList;
    idBots: integer;
    freeIds: TIntegerList;

    StartMetal: integer;
    StartEnergy: integer;
    MaxUnits: integer;
    GameMode: integer;
    GameType: integer;
    LimitDGun: Boolean;
    GhostedB: Boolean;
    DiminishMM: Boolean;
    LoadingMessage: string;
    DisabledUnitList: TStringList;
    
    CampaignList: TList;

    AIPlayerList: TList;

    Process: // we need this information when we launch game exe
    record
      proc_info: TProcessInformation;
      startinfo: TStartupInfo;
      ExitCode: LongWord;
    end;

    MenuLoaded: Boolean;

    procedure SaveIERegistry;
    function LoadMapListHtmlCode: string;
    function GetLuaHtmlCode(options: TList;idStart: integer): String;
    procedure ColorCallBack(const AName: String);
    function getBotIndex(id: integer): integer;
    procedure LoadCampaigns;
  public
    MePlayer:
    record
      Id: integer;
      Name: string;
      Team: integer;
      Side: integer;
      StartPosX: double;
      StartPosY: double;
      Handicap: integer;
    end;
    
    htmlBrowser: TWebBrowserWrapper;
    htmlContainer: TWBContainer;

    procedure LoadMenu(fileName: string;pageType: TPageType);
    function replaceParams(code: string;fileName: string;htmlTag: string;names: TStrings; values: TStrings):string;
    procedure SaveMinimapToFile;
    procedure StartSkirmish;
    function GenerateScript(FileName: string):boolean;
    function playerHasWon(scriptFileName: string): boolean;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure ListSkins;
    procedure LoadSkin(skinFile: string);
    procedure OnUnlockMessage(var Msg: TMessage); message WM_UNLOCK_WINDOW;
    procedure LoadMod(modName: string);
  end;

var
  MenuForm: TMenuForm;

implementation

uses PreferencesFormUnit,Utility,Misc,MapListFormUnit,Registry,
  BattleFormUnit, MinimapZoomedFormUnit, AddBotUnit, Math,gnugettext;

{$R *.dfm}

// disable the refresh on F5 on the webbrowser
function KeyProc(nCode: Integer; wParam, lParam: Longint): Longint; stdcall;
begin
  case nCode < 0 of
    True:
      Result := CallNextHookEx(MenuForm.HookID, nCode, wParam, lParam)
      else
        case wParam of
          VK_F5:
            begin
              if MenuForm.Active and (MenuForm.ActiveControl = MenuForm.htmlBrowser) then
                Result := HC_SKIP
              else
                Result := CallNextHookEx(MenuForm.HookID, nCode, wParam, lParam);
            end
            else
              Result := CallNextHookEx(MenuForm.HookID, nCode, wParam, lParam);
        end;
  end;
end;

constructor TCampaign.Create(luaFileName: string);
var
  fileHnd : integer;
  size: integer;
  sl: TStringList;
begin
  FNextMissionsName := TStringList.Create;
  FNextMissionsScriptPath := TStringList.Create;
  FTemplateVarName := TStringList.Create;
  FTemplateVarValue := TStringList.Create;

  FLuaFileName := luaFileName;
  fileHnd := Utility.OpenFileVFS(PChar(luaFileName));
  if fileHnd = 0 then
    Raise Exception.Create('Lua file not found : '+luaFileName);
  size := Utility.FileSizeVFS(fileHnd);
  SetLength(FLuaFile,size);
  Utility.ReadFileVFS(fileHnd,PChar(FLuaFile),size);
  Utility.CloseFileVFS(fileHnd);

  lpOpenSource(PChar(FLuaFile),'r');

  if Utility.lpExecute = 0 then
    Raise Exception.Create(_('Invalid lua file : ')+luaFileName);

  if Utility.lpGetKeyExistsStr('name') = 0 then
    Raise Exception.Create(_('Campaign doesn''''t have a name : ')+luaFileName);

  FName := Utility.lpGetStrKeyStrVal('name','');
  FShortDesc := Utility.lpGetStrKeyStrVal('shortdesc','');
  FIncrustedHtml := IntToBool(Utility.lpGetStrKeyBoolVal('incrustedhtml',1));
  FIsCampaign := IntToBool(Utility.lpGetStrKeyBoolVal('iscampaign',1));
  FLinearCampaign := False;

  Utility.lpClose;

  // constructing the progress dir (adding the profile name to the path)
  FCampaignProgressDir := ExtractBeforeLastSlash(luaFileName);
  sl := TStringList.Create;
  ParseDelimited(sl,FCampaignProgressDir,'/','');
  sl.Insert(1,MenuForm.currentProfileName);
  FCampaignProgressDir := JoinStringList(sl,'/');
  
  // get the latest mission accomplished return file
  self.GetCurrentLuaFile;
end;

procedure TCampaign.GetCurrentLuaFile;
var
  missionsAccomplishedList: TStringList;
  fileHnd,size,res: integer;
  luaContent: string;
  progressPath: string;
  i: integer;
  tmpStr: string;
begin
  missionsAccomplishedList := TStringList.Create;

  // open the progress.lua
  progressPath := FCampaignProgressDir+'/progress.lua';
  fileHnd := Utility.OpenFileVFS(PChar(progressPath));
  if fileHnd <> 0 then
  begin
    size := Utility.FileSizeVFS(fileHnd);
    SetLength(luaContent,size);
    Utility.ReadFileVFS(fileHnd,PChar(luaContent),size);
    Utility.CloseFileVFS(fileHnd);

    // parse the progress.lua file
    Utility.lpOpenSource(PChar(luaContent),'r');

    if Utility.lpExecute = 0 then
      Raise Exception.Create('Invalid lua file : '+progressPath);

    for i:=1 to Utility.lpGetIntKeyListCount do
    begin
      if not IntToBool(Utility.lpGetKeyExistsInt(i)) then
        Raise Exception.Create(_('Invalid progress.lua file (keys) : ')+progressPath);
      tmpStr := Utility.lpGetIntKeyStrVal(i,'');
      if tmpStr = '' then
        Raise Exception.Create(_('Invalid progress.lua file (values) : ')+progressPath);
      missionsAccomplishedList.Add(tmpStr);
    end;
  end;

  if missionsAccomplishedList.Count > 0 then
    FCurrentReturnLua := FCampaignProgressDir + '/' + missionsAccomplishedList[missionsAccomplishedList.Count-1] + '/return.lua'
  else
    FCurrentReturnLua := FLuaFileName;
end;

procedure TCampaign.LoadReturnFile;
var
  fileHnd,size: integer;
  content : string;
  i: integer;
  tmpStr: string;
begin
  fileHnd := Utility.OpenFileVFS(PChar(FCurrentReturnLua));
  if fileHnd = 0 then
    Raise Exception.Create(_('Lua file not found : ')+FCurrentReturnLua);
  size := Utility.FileSizeVFS(fileHnd);
  SetLength(content,size);
  Utility.ReadFileVFS(fileHnd,PChar(content),size);
  Utility.CloseFileVFS(fileHnd);

  lpOpenSource(PChar(content),'r');

  if Utility.lpExecute = 0 then
    Raise Exception.Create(_('Invalid lua file : ')+FCurrentReturnLua);

  if Utility.lpGetKeyExistsStr('nextmissionlist') = 0 then
    Raise Exception.Create(_('Campaign doesn''''t have a nextmissionlist : ')+FCurrentReturnLua);

  Utility.lpSubTableStr('nextmissionlist');

  if Utility.lpGetKeyExistsStr('warmap') = 0 then
    Raise Exception.Create(_('Campaign doesn''''t have a warmap : ')+FCurrentReturnLua);

  FWarmapPath := Utility.lpGetStrKeyStrVal('warmap','');

  if FWarmapPath = '' then
    Raise Exception.Create(_('Campaign doesn''''t have a valid warmap : ')+FCurrentReturnLua);

  for i:=1 to Utility.lpGetIntKeyListCount do
  begin
    if not IntToBool(Utility.lpGetKeyExistsInt(i)) then
      Raise Exception.Create(_('Invalid next missions (keys) : ')+FCurrentReturnLua);
    Utility.lpSubTableInt(i);
    tmpStr := Utility.lpGetStrKeyStrVal('name','');
    if tmpStr = '' then
      Raise Exception.Create(_('Mission name empty : ')+FCurrentReturnLua);
    FNextMissionsName.Add(tmpStr);
    tmpStr := Utility.lpGetStrKeyStrVal('script','');
    if tmpStr = '' then
      Raise Exception.Create(_('Mission script empty : ')+FCurrentReturnLua);
    FNextMissionsScriptPath.Add(tmpStr);
    Utility.lpPopTable;
  end;
  Utility.lpPopTable;

  if Utility.lpGetKeyExistsStr('template') <> 0 then
  begin
    Utility.lpSubTableStr('template');

    for i:=0 to Utility.lpGetStrKeyListCount-1 do
    begin
      tmpStr := Utility.lpGetStrKeyListEntry(i);

      FTemplateVarName.Add(tmpStr);
      FTemplateVarValue.Add(Utility.lpGetStrKeyStrVal(PChar(tmpStr),''));
    end;

    Utility.lpPopTable;
  end;


  Utility.lpClose;
end;

procedure TCampaign.LoadNextMission;
begin
  Self.GetCurrentLuaFile;
  Self.LoadReturnFile;
  if FIsCampaign then
    MenuForm.LoadMenu(StringReplace(FWarmapPath,'/','\',[rfReplaceAll]),Campaign)
  else
    MenuForm.LoadMenu(StringReplace(FWarmapPath,'/','\',[rfReplaceAll]),Mission);

end;


procedure TCampaign.StartMission(missionName: string);
var
  missionId: integer;
  s: TScript;
  tryToRewriteScript: boolean;
  f: TextFile;
  scriptWritten: boolean;
begin
  // get the mission information
  if (missionName = '') and not FIsCampaign then
    missionId := 0
  else
  begin
    missionId := FNextMissionsName.IndexOf(missionName);
    if missionId = -1 then
      Raise Exception.Create(_('Mission name incorrect.'));
  end;

  s := TScript.Create(ReadVFSFile(FNextMissionsScriptPath[missionId]));

  // check the map and maphash
  if Utility.MapList.IndexOf(s.ReadMapName) = -1 then
  begin
    MessageDlg(Format(_('You need the map "%s" to play this mission.'),[s.ReadMapName]),mtWarning,[mbOk],0);
    s.Destroy;
    Exit;
  end;
  {*if Utility.MapChecksums.IndexOf(s.ReadMaphash) = -1 then
  begin
    MessageDlg('Your map differs with the one needed by the mission. Please redownload the map to play this mission.',mtWarning,[mbOk],0);
    s.Destroy;
    Exit;
  end;*}


  // make the directory of mission return file and add the path to the script
  MakePath(StringReplace(ExtractFilePath(Application.ExeName) + FCampaignProgressDir,'/','\',[rfReplaceAll])+'\'+missionName);
  s.AddOrChangeKeyValue('GAME/ReturnPath',FCampaignProgressDir+'/'+missionName);
  s.AddOrChangeKeyValue('GAME/ProgressPath',FCampaignProgressDir+'/progress.lua');

  // write down the script
  repeat
  try
    AssignFile(f, ExtractFilePath(Application.ExeName)+'script.txt');
    Rewrite(f);
    Write(f, s.Script);
    CloseFile(f);
    tryToRewriteScript := False;
    scriptWritten := True;
  except
    scriptWritten := False;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg(CANT_WRITE_SCRIPT_MSG,mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;
  s.Free;

  if not scriptWritten then
    Exit;

  // launch spring
  FillChar(MenuForm.Process.proc_info, sizeof(TProcessInformation), 0);
  FillChar(MenuForm.Process.startinfo, sizeof(TStartupInfo), 0);
  MenuForm.Process.startinfo.cb := sizeof(TStartupInfo);
  MenuForm.Process.startinfo.dwFlags := STARTF_USESHOWWINDOW;
  MenuForm.Process.startinfo.wShowWindow := SW_SHOWMAXIMIZED;

  try
    if CreateProcess(nil, PChar(ExtractFilePath(Application.ExeName) + 'spring.exe script.txt'), nil, nil, false, CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS + SYNCHRONIZE,
                   nil, PChar(ExtractFilePath(Application.ExeName)), MenuForm.Process.startinfo, MenuForm.Process.proc_info) then
    begin
      MenuForm.tmrMusic.Enabled := false;
      if MenuForm.MP1.Mode = mpPlaying then
        MenuForm.MP1.Pause;
      MenuForm.GameTimer.Enabled := True;
    end
    else
    begin
      CloseHandle(MenuForm.Process.proc_info.hProcess);
      Application.MessageBox(PChar(_('Couldn''t execute the application')), PChar(_('Error')), MB_ICONEXCLAMATION);
    end;
  except
    Application.MessageBox(PChar(_('An error occured while starting the mission.')), PChar(_('Error')), MB_ICONEXCLAMATION);
  end;
end;


procedure TMenuForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TMenuForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToRegOnExit := true;
  MainForm.Close;
end;

procedure TMenuForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  paramNames := TStringList.Create;
  paramValues := TStringList.Create;
  settingsNames := TStringList.Create;
  settingsValues := TStringList.Create;
  ColorsList := TStringList.Create;
  AIPlayerList := TList.Create;
  DisabledUnitList := TStringList.Create;
  freeIds := TIntegerList.Create;
  CampaignList := TList.Create;
  BrowseHistory := TStack.Create;
  skinList := TStringList.Create;
  MenuLoaded := False;
  MePlayer.Name := _('Me');

  GameMode := -1;

  GetColorValues(ColorCallBack);

  SaveIERegistry;

  AddBotForm.ReloadButtonClick(nil);

  try
    soundValue := Misc.GetRegistryData(HKEY_CURRENT_USER,'AppEvents\Schemes\Apps\Explorer\Navigating\.Current','');
  except
  end;

  htmlBrowser := TWebBrowserWrapper.Create(MenuForm);
  TWinControl(htmlBrowser).Parent := MenuForm;
  TWinControl(htmlBrowser).Name := 'htmlBrowser';
  TWinControl(htmlBrowser).Visible := True;
  TWinControl(htmlBrowser).Align := alClient;
  htmlBrowser.OnNavigateComplete2 := htmlBrowserControlNavigateComplete2;
  htmlBrowser.OnDocumentComplete := htmlBrowserControlDocumentComplete;
  htmlBrowser.OnBeforeNavigate2 := htmlBrowserControlBeforeNavigate2;
  htmlBrowser.OnNewWindow2 := htmlBrowserControlNewWindow2;

  htmlBrowser.Show3DBorder := false;
  htmlBrowser.AllowTextSelection := RunningWithMainMenuDev;
  htmlBrowser.UseCustomCtxMenu := not RunningWithMainMenuDev;
  htmlBrowser.ShowScrollBars := false;
  htmlBrowser.Silent := not RunningWithMainMenuDev;
  htmlBrowser.Offline := true;
  minimapFixedStartSize := 10;
  StartMetal := 1000;
  StartEnergy := 1000;
  MaxUnits := 5000;
  currentProfileName := 'default';

  LoadSettings;

  if MainUnit.RunningWithMainMenuDev then
    MenuCurrentPath := ExtractFilePath(Application.ExeName) + 'Interface\'
  else
    MenuCurrentPath := GetLongPathName(GetEnvironmentVariable('TEMP'))+'\tasclientgui\';

  ModMenuPath := GetLongPathName(GetEnvironmentVariable('TEMP'))+'\tasclientmodgui\';

  AutorisedURLFiles := TStringList.Create;

  if not MainUnit.RunningWithMainMenuDev then
    MenuForm.HookID := SetWindowsHookEx(WH_KEYBOARD, KeyProc, 0, GetCurrentThreadId());
end;

procedure TMenuForm.SaveIERegistry;
begin
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','Disable Script Debugger',rdString,'yes');
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','DisableScriptDebuggerIE',rdString,'yes');
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','Display Inline Images',rdString,'yes');
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','Play_Animations',rdString,'yes');
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','SmoothScroll',rdInteger,1);
  Misc.SetRegistryData(HKEY_CURRENT_USER,'\Software\TASClient\IE\Main','UseClearType',rdString,'no');
end;

function TMenuForm.LoadMapListHtmlCode: string;
var
  templateStr,tmp: string;
  i: integer;
begin
    Result := '';
    templateStr := ReadFile2(MenuCurrentPath+'mapItem.html');
    for i := 0 to MapListForm.SortedMaps.Count -1  do
    begin
      tmp := templateStr;
      with TMapItem(MapListForm.SortedMaps[i]) do
      begin
        tmp := StringReplace(tmp,'[MapID]',IntToStr(Index),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapMiniMapUrl]',ExtractFilePath(Application.ExeName)+MAPS_CACHE_FOLDER+'\'+IntToStr(MapHash)+'.mini',[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapName]',MapName,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapDescription]',MapInfo.Description,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapTidalStrength]',IntToStr(MapInfo.TidalStrength),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapGravity]',IntToStr(MapInfo.Gravity),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapExtractorRadius]',IntToStr(MapInfo.ExtractorRadius),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapMinWind]',IntToStr(MapInfo.MinWind),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapMaxWind]',IntToStr(MapInfo.MaxWind),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapWidth]',IntToStr(Round(MapInfo.Width/64)),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapHeight]',IntToStr(Round(MapInfo.Height/64)),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MapPosCount]',IntToStr(MapInfo.PosCount),[rfReplaceAll,rfIgnoreCase]);
      end;
      Result := Result + tmp;
    end;
end;

function TMenuForm.GetLuaHtmlCode(options: TList;idStart: integer): String;
var
  tmpStr,tmp,varHtmlCode3,tmp2: string;
  i,j: integer;
begin
    Result := '';
    for i := 0 to options.Count-1  do
    begin
      tmpStr := TLuaOption(options[i]).ClassName;
      tmp := '';
      if tmpStr = 'TLuaOptionBool' then
      begin
        tmp := ReadFile2(MenuCurrentPath+'luaBoolOption.html');
        tmp := StringReplace(tmp,'[luaOptionId]',IntToStr(idStart+i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionName]',TLuaOptionBool(options[i]).Name,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionDescription]',TLuaOptionBool(options[i]).Description,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionValue]',IfThen(TLuaOptionBool(options[i]).toString <> '0','checked',''),[rfReplaceAll,rfIgnoreCase]);
      end;
      if tmpStr = 'TLuaOptionString' then
      begin
        tmp := ReadFile2(MenuCurrentPath+'luaStringOption.html');
        tmp := StringReplace(tmp,'[luaOptionId]',IntToStr(idStart+i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionName]',TLuaOptionString(options[i]).Name,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionDescription]',TLuaOptionString(options[i]).Description,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionValue]',TLuaOptionString(options[i]).toString,[rfReplaceAll,rfIgnoreCase]);
      end;
      if tmpStr = 'TLuaOptionNumber' then
      begin
        tmp := ReadFile2(MenuCurrentPath+'luaNumberOption.html');
        tmp := StringReplace(tmp,'[luaOptionId]',IntToStr(idStart+i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionName]',TLuaOptionNumber(options[i]).Name,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionDescription]',TLuaOptionNumber(options[i]).Description,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionValue]',TLuaOptionNumber(options[i]).toString,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionMinValue]',FloatToStr(TLuaOptionNumber(options[i]).MinValue),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionMaxValue]',FloatToStr(TLuaOptionNumber(options[i]).MaxValue),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionStep]',FloatToStr(TLuaOptionNumber(options[i]).StepValue),[rfReplaceAll,rfIgnoreCase]);
      end;
      if tmpStr = 'TLuaOptionList' then
      begin
        tmp := ReadFile2(MenuCurrentPath+'luaListOption.html');
        varHtmlCode3 := '';
        for j := 0 to TLuaOptionList(options[i]).NameList.Count-1 do
        begin
          tmp2 := ReadFile2(MenuCurrentPath+'luaListItem.html');
          tmp2 := StringReplace(tmp2,'[luaOptionItemId]',IntToStr(j),[rfReplaceAll,rfIgnoreCase]);
          tmp2 := StringReplace(tmp2,'[luaOptionItemName]',TLuaOptionList(options[i]).NameList[j],[rfReplaceAll,rfIgnoreCase]);
          tmp2 := StringReplace(tmp2,'[luaOptionItemKey]',TLuaOptionList(options[i]).KeyList[j],[rfReplaceAll,rfIgnoreCase]);
          tmp2 := StringReplace(tmp2,'[luaOptionItemDescription]',TLuaOptionList(options[i]).DescriptionList[j],[rfReplaceAll,rfIgnoreCase]);
          varHtmlCode3 := varHtmlCode3 + tmp2;
        end;
        tmp := StringReplace(tmp,'[luaOptionList]',varHtmlCode3,[rfReplaceAll,rfIgnoreCase]);

        tmp := StringReplace(tmp,'[luaOptionId]',IntToStr(idStart+i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionName]',TLuaOptionList(options[i]).Name,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionDescription]',TLuaOptionList(options[i]).Description,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[luaOptionValue]',TLuaOptionList(options[i]).toString,[rfReplaceAll,rfIgnoreCase]);
      end;
      Result := Result + tmp;
    end;
end;

procedure TMenuForm.ColorCallBack(const AName: String);
begin
  ColorsList.Add(AName);
end;

procedure TMenuForm.LoadMenu(fileName: string;pageType: TPageType);
var
  htmlCode: string;
  varHtmlCode,varHtmlCode2,varHtmlCode3,tmp,tmp2: string;
  i,j: integer;
  tmpStr: string;
  templateStr: string;
  sl: TStringList;
  browsepage: ^TBrowsePage;
begin
  sl := TStringList.Create;

  New(browsepage);
  browsepage^.PageName := fileName;
  browsepage^.PageType := pageType;
  BrowseHistory.Push(browsepage);


  if LoadMenuFromMod then
    CurrentPath := ModMenuPath
  else
    CurrentPath := MenuCurrentPath;

  // get the html code
  htmlCode := Misc.ReadFile2(CurrentPath+fileName);

  htmlCode := StringReplace(htmlCode,'[SpringVersion]',springExeVersion,[rfIgnoreCase,rfReplaceAll]);
  htmlCode := StringReplace(htmlCode,'[PlayerName]',MePlayer.Name,[rfIgnoreCase,rfReplaceAll]);

  if pageType = Main then // [SKINLIST]
  begin
    varHtmlCode := '';
    templateStr := ReadFile2(CurrentPath+'skinItem.html');
    for i := 0 to skinList.Count-1 do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[skinId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[skinName]',skinList[i],[rfReplaceAll,rfIgnoreCase]);

      varHtmlCode := varHtmlCode + tmp;
    end;

    htmlCode := StringReplace(htmlCode,'[SelectedSKIN]',IntToStr(skinList.IndexOf(LeftStr(Preferences.SPSkin,Length(Preferences.SPSkin)-4))),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[SKINLIST]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Loading) then // [MSG]
  begin
    htmlCode := StringReplace(htmlCode,'[MSG]',LoadingMessage,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = CampaignsMenu) then // [CampaignList]
  begin
    templateStr := ReadFile2(CurrentPath+'campaignItem.html');
    varHtmlCode := '';
    for i := 0 to CampaignList.Count-1  do
    begin
      if TCampaign(CampaignList[i]).IsCampaign then
      begin
        tmp := templateStr;
        tmp := StringReplace(tmp,'[CampaignId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[CampaignName]',TCampaign(CampaignList[i]).CampaignName,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[CampaignDescription]',TCampaign(CampaignList[i]).ShortDesc,[rfReplaceAll,rfIgnoreCase]);
        varHtmlCode := varHtmlCode + tmp;
      end;
    end;
    htmlCode := StringReplace(htmlCode,'[CampaignList]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = MissionsMenu) then // [MissionList]
  begin
    templateStr := ReadFile2(CurrentPath+'missionItem.html');
    varHtmlCode := '';
    for i := 0 to CampaignList.Count-1  do
    begin
      if not TCampaign(CampaignList[i]).IsCampaign then
      begin
        tmp := templateStr;
        tmp := StringReplace(tmp,'[MissionId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MissionName]',TCampaign(CampaignList[i]).CampaignName,[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[MissionDescription]',TCampaign(CampaignList[i]).ShortDesc,[rfReplaceAll,rfIgnoreCase]);
        varHtmlCode := varHtmlCode + tmp;
      end;
    end;
    htmlCode := StringReplace(htmlCode,'[MissionList]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Skirmish) then // [GameEndCond] [MetalVisible] [MaxMetal] [EnergyVisible] [MaxEnergy] [UnitsVisible] [MaxUnits] [MinMetal] [MinEnergy] [MinUnits]
  begin
    // metal
    htmlCode := StringReplace(htmlCode,'[MetalCaption]',BattleForm.lblMetal.Caption,[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MaxMetal]',IntToStr(BattleForm.MetalTracker.Max),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MinMetal]',IntToStr(BattleForm.MetalTracker.Min),[rfIgnoreCase,rfReplaceAll]);
    if BattleForm.MetalTracker.Visible then
      htmlCode := StringReplace(htmlCode,'[MetalVisible]','block',[rfIgnoreCase,rfReplaceAll])
    else
      htmlCode := StringReplace(htmlCode,'[MetalVisible]','none',[rfIgnoreCase,rfReplaceAll]);

    // energy
    htmlCode := StringReplace(htmlCode,'[EnergyCaption]',BattleForm.lblEnergy.Caption,[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MaxEnergy]',IntToStr(BattleForm.EnergyTracker.Max),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MinEnergy]',IntToStr(BattleForm.EnergyTracker.Min),[rfIgnoreCase,rfReplaceAll]);
    if BattleForm.EnergyTracker.Visible then
      htmlCode := StringReplace(htmlCode,'[EnergyVisible]','block',[rfIgnoreCase,rfReplaceAll])
    else
      htmlCode := StringReplace(htmlCode,'[EnergyVisible]','none',[rfIgnoreCase,rfReplaceAll]);

    // maxunits
    htmlCode := StringReplace(htmlCode,'[UnitsCaption]',BattleForm.lblUnits.Caption,[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MaxUnits]',IntToStr(BattleForm.UnitsTracker.Max),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MinUnits]',IntToStr(BattleForm.UnitsTracker.Min),[rfIgnoreCase,rfReplaceAll]);
    if BattleForm.UnitsTracker.Visible then
      htmlCode := StringReplace(htmlCode,'[UnitsVisible]','block',[rfIgnoreCase,rfReplaceAll])
    else
      htmlCode := StringReplace(htmlCode,'[UnitsVisible]','none',[rfIgnoreCase,rfReplaceAll]);

    // game end condition
    if BattleForm.GameEndRadioGroup.Visible then
    begin
      templateStr := ReadFile2(CurrentPath+'gameEndCondItem.html');
      varHtmlCode := '';
      for i:=0 to BattleForm.GameEndRadioGroup.Items.Count-1 do
      begin
        tmp := templateStr;
        tmp := StringReplace(tmp,'[GameEndCondId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[GameEndCondName]',BattleForm.GameEndRadioGroup.Items[i],[rfReplaceAll,rfIgnoreCase]);
        varHtmlCode := varHtmlCode + tmp;
      end;
      htmlCode := StringReplace(htmlCode,'[GameEndCond]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
    end
    else
      htmlCode := StringReplace(htmlCode,'[GameEndCond]','',[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Skirmish) then // [MAPLIST]
  begin
    // map html code is cached and refreshed only when needed to save cpu time
    htmlCode := StringReplace(htmlCode,'[MAPLIST]',mapListHtmlCode,[rfIgnoreCase,rfReplaceAll]);
    if Preferences.MapSortStyle = 1 then
      htmlCode := StringReplace(htmlCode,'[MAPSORT]','name',[rfIgnoreCase,rfReplaceAll])
    else
      htmlCode := StringReplace(htmlCode,'[MAPSORT]','size',[rfIgnoreCase,rfReplaceAll])
  end;
  if (pageType = Skirmish) then // [SELECTEDMAPNAME] [MAP%WIDTH] [MAP%HEIGHT]
  begin
    templateStr := ReadFile2(CurrentPath+'mapItem.html');
    varHtmlCode := '';

    if BattleForm.CurrentMapIndex >= 0 then
      htmlCode := StringReplace(htmlCode,'[SELECTEDMAPNAME]',TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapName,[rfIgnoreCase,rfReplaceAll])
    else
      htmlCode := StringReplace(htmlCode,'[SELECTEDMAPNAME]','No map',[rfIgnoreCase,rfReplaceAll]);

    if (BattleForm.CurrentMapIndex < 0) or (TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Width = 0) or (TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Height = 0) then
    begin
      htmlCode := StringReplace(htmlCode,'[MAP%WIDTH]','100',[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAP%HEIGHT]','100',[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAPWIDTH]','?',[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAPHEIGHT]','?',[rfIgnoreCase,rfReplaceAll]);
    end
    else
    begin
      htmlCode := StringReplace(htmlCode,'[MAP%WIDTH]',IntToStr(mapWidthPercent),[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAP%HEIGHT]',IntToStr(mapHeightPercent),[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAPWIDTH]',IntToStr(Round(TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Width/64)),[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[MAPHEIGHT]',IntToStr(Round(TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Height/64)),[rfIgnoreCase,rfReplaceAll]);
    end;
    htmlCode := StringReplace(htmlCode,'[STARTMETAL]',IntToStr(StartMetal),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[STARTENERGY]',IntToStr(StartEnergy),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MAXUNITS]',IntToStr(MaxUnits),[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Main) then // [MODLIST]
  begin
    templateStr := ReadFile2(CurrentPath+'modItem.html');
    varHtmlCode := '';
    for i := 0 to Utility.ModList.Count-1  do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[modId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[modName]',Utility.ModList[i],[rfReplaceAll,rfIgnoreCase]);
      varHtmlCode := varHtmlCode + tmp;
    end;
    htmlCode := StringReplace(htmlCode,'[MODLIST]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;
  if pageType <> Main then
  begin
    htmlCode := StringReplace(htmlCode,'[SelectedModId]',IntToStr(Utility.ModList.IndexOf(BattleForm.CurrentModName)),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[SelectedModName]',BattleForm.CurrentModName,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Skirmish) then // [MODOPTIONLIST] [MAPOPTIONLIST]
  begin
    htmlCode := StringReplace(htmlCode,'[MODOPTIONLIST]',GetLuaHtmlCode(BattleForm.ModOptionsList,0),[rfIgnoreCase,rfReplaceAll]);
    htmlCode := StringReplace(htmlCode,'[MAPOPTIONLIST]',GetLuaHtmlCode(BattleForm.MapOptionsList,LUAOPTIONS_ID_MAX),[rfIgnoreCase,rfReplaceAll]);

    templateStr := ReadFile2(CurrentPath+'aisOptions.html');
    for i:=0 to AIPlayerList.Count-1 do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[AIName]',TSPAIItem(AIPlayerList[i]^).Name,[rfReplaceAll,rfIgnoreCase]);
      // 2*LUAOPTIONS_ID_MAX = map options + mod options
      tmp := StringReplace(tmp,'[AIOptions]',GetLuaHtmlCode(TSPAIItem(AIPlayerList[i]^).OptionsList,i*LUAOPTIONS_ID_MAX+2*LUAOPTIONS_ID_MAX),[rfReplaceAll,rfIgnoreCase]);
      varHtmlCode := varHtmlCode + tmp;
    end;
    htmlCode := StringReplace(htmlCode,'[AISOPTIONLIST]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Skirmish) then // [AILIST]
  begin

    varHtmlCode := '';
    templateStr := ReadFile2(CurrentPath+'aiItem.html');
    for i := 0 to AddBotForm.aiList.Count-1 do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[aiName]',PAIItem(AddBotForm.aiList[i]).values[PAIItem(AddBotForm.aiList[i]).keys.IndexOf('shortname')],[rfReplaceAll,rfIgnoreCase]);

      varHtmlCode := varHtmlCode + tmp;
    end;

    htmlCode := StringReplace(htmlCode,'[AILIST]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Skirmish) then // [UNITLIST]
  begin
    varHtmlCode := '';
    templateStr := ReadFile2(CurrentPath+'unitItem.html');
    sl.Clear;
    sl.AddStrings(Utility.UnitNames);
    sl.Sort;
    for i := 0 to sl.Count-1 do
    begin
      tmp := templateStr;
      j := Utility.UnitNames.IndexOf(sl[i]);
      tmp := StringReplace(tmp,'[unitId]',IntToStr(j),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[unitName]',sl[i],[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[unitDisabled]',IfThen(DisabledUnitList.IndexOf(Utility.UnitList[j]) <> -1,'checked',''),[rfReplaceAll,rfIgnoreCase]);
      varHtmlCode := varHtmlCode + tmp;
    end;

    htmlCode := StringReplace(htmlCode,'[UNITLIST]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
  end;
  
  if (pageType = Skirmish) then // [PlayerList] [PlayerBoxList] [NbPlayers]
  begin
    // sides
    varHtmlCode2 := '';
    if BattleForm.CurrentModName <> '' then
    begin
      templateStr := ReadFile2(CurrentPath+'sideItem.html');
      for i := 0 to Utility.SideList.Count-1 do
      begin
        tmp := templateStr;
        tmp := StringReplace(tmp,'[SideId]',IntToStr(i),[rfReplaceAll,rfIgnoreCase]);
        tmp := StringReplace(tmp,'[SideName]',Utility.SideList[i],[rfReplaceAll,rfIgnoreCase]);
        varHtmlCode2 := varHtmlCode2 + tmp;
      end;
    end;

    varHtmlCode := '';

    //me
    templateStr := ReadFile2(CurrentPath+'playerItemBox.html');
    tmp := templateStr;
    tmp := StringReplace(tmp,'[SideList]',varHtmlCode2,[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerName]',MePlayer.Name,[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerId]','1',[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerUniqueId]','0',[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedSide]',IntToStr(MePlayer.Side),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedId]',IntToStr(MePlayer.Id),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedTeam]',IntToStr(MePlayer.Team),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[Handicap]',IntToStr(MePlayer.Handicap),[rfReplaceAll,rfIgnoreCase]);
    varHtmlCode := varHtmlCode + tmp;

    //AIs
    templateStr := ReadFile2(CurrentPath+'botItemBox.html');
    for i := 0 to AIPlayerList.Count-1 do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[SideList]',varHtmlCode2,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerId]',IntToStr(i+2),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerUniqueId]',IntToStr(TSPAIItem(AIPlayerList[i]^).UniqueId),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerName]',TSPAIItem(AIPlayerList[i]^).Name,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[AIType]',TSPAIItem(AIPlayerList[i]^).AIType,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedSide]',IntToStr(TSPAIItem(AIPlayerList[i]^).Side),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedId]',IntToStr(TSPAIItem(AIPlayerList[i]^).Id),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedTeam]',IntToStr(TSPAIItem(AIPlayerList[i]^).Team),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[Handicap]',IntToStr(TSPAIItem(AIPlayerList[i]^).Handicap),[rfReplaceAll,rfIgnoreCase]);
      varHtmlCode := varHtmlCode + tmp;
    end;

    htmlCode := StringReplace(htmlCode,'[PlayerBoxList]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);

    varHtmlCode := '';

    //me
    templateStr := ReadFile2(CurrentPath+'playerItem.html');
    tmp := templateStr;
    tmp := StringReplace(tmp,'[SideList]',varHtmlCode2,[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerId]','1',[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerUniqueId]','0',[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[PlayerName]',MePlayer.Name,[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedSide]',IntToStr(MePlayer.Side),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedId]',IntToStr(MePlayer.Id),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[SelectedTeam]',IntToStr(MePlayer.Team),[rfReplaceAll,rfIgnoreCase]);
    tmp := StringReplace(tmp,'[Handicap]',IntToStr(MePlayer.Handicap),[rfReplaceAll,rfIgnoreCase]);
    varHtmlCode := varHtmlCode + tmp;

    //AIs
    templateStr := ReadFile2(CurrentPath+'botItem.html');
    for i := 0 to AIPlayerList.Count-1 do
    begin
      tmp := templateStr;
      tmp := StringReplace(tmp,'[SideList]',varHtmlCode2,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerId]',IntToStr(i+2),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerUniqueId]',IntToStr(TSPAIItem(AIPlayerList[i]^).UniqueId),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[PlayerName]',TSPAIItem(AIPlayerList[i]^).Name,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[AIType]',TSPAIItem(AIPlayerList[i]^).AIType,[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedSide]',IntToStr(TSPAIItem(AIPlayerList[i]^).Side),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedId]',IntToStr(TSPAIItem(AIPlayerList[i]^).Id),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[SelectedTeam]',IntToStr(TSPAIItem(AIPlayerList[i]^).Team),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[Handicap]',IntToStr(TSPAIItem(AIPlayerList[i]^).Handicap),[rfReplaceAll,rfIgnoreCase]);
      tmp := StringReplace(tmp,'[AIOptions]',GetLuaHtmlCode(TSPAIItem(AIPlayerList[i]^).OptionsList,i*LUAOPTIONS_ID_MAX+2*LUAOPTIONS_ID_MAX),[rfReplaceAll,rfIgnoreCase]);
      varHtmlCode := varHtmlCode + tmp;
    end;

    htmlCode := StringReplace(htmlCode,'[PlayerList]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);

    htmlCode := StringReplace(htmlCode,'[NbPlayers]',IntToStr(1+AIPlayerList.Count),[rfIgnoreCase,rfReplaceAll]);
  end;

  if (pageType = Campaign) or (pageType = Mission) then
  begin
    with TCampaign(CampaignList[CurrentCampaignIndex]) do
    begin
      htmlCode := StringReplace(htmlCode,'[CampaignId]',IntToStr(CurrentCampaignIndex),[rfIgnoreCase,rfReplaceAll]);
      htmlCode := StringReplace(htmlCode,'[CampaignName]',CampaignName,[rfIgnoreCase,rfReplaceAll]);

      for i:=0 to TemplateVarName.Count-1 do
        htmlCode := StringReplace(htmlCode,'['+TemplateVarName[i]+']',TemplateVarValue[i],[rfIgnoreCase,rfReplaceAll]);

      if IncrustedHtml then
      begin
        varHtmlCode := htmlCode;

        if pageType = Mission then
          htmlCode := Misc.ReadFile2(CurrentPath+'defaultMissionSkin.html')
        else
          htmlCode := Misc.ReadFile2(CurrentPath+'defaultCampaignSkin.html');

        htmlCode := StringReplace(htmlCode,'[CampaignContent]',varHtmlCode,[rfIgnoreCase,rfReplaceAll]);
      end;
    end;
  end;


  for i:=0 to ColorsList.Count-1 do
    htmlCode := StringReplace(htmlCode,'['+ColorsList[i]+']',IntToHex(Misc.ColorToStandardRGB(ColorToRGB(StringToColor(ColorsList[i]))),6),[rfIgnoreCase,rfReplaceAll]);

  htmlCode := replaceParams(htmlCode,fileName,'LOBBY:LOADPARAM',paramNames,paramValues);
  htmlCode := replaceParams(htmlCode,fileName,'LOBBY:LOADSETTINGS',settingsNames,settingsValues);

  // make sure the file can be loaded
  if AutorisedURLFiles.IndexOf(StringReplace(ExtractFilePath(CurrentPath+fileName)+'temp654dsq.html','\','/',[rfReplaceAll])) = -1 then
    AutorisedURLFiles.Add(StringReplace(LowerCase(ExtractFilePath(CurrentPath+fileName)+'temp654dsq.html'),'\','/',[rfReplaceAll]));
    
  // save new html file and open it
  SaveFile(ExtractFilePath(CurrentPath+fileName)+'temp654dsq.html',htmlCode);
  //Sleep(100); // to fix some loading bugs
  htmlBrowser.NavigateToLocalFile(ExtractFilePath(CurrentPath+fileName)+'temp654dsq.html');

  sl.Free;
end;

// replace [LOBBY:LOADPARAM:id:default] or [LOBBY:LOADSETTINGS:id:default]
function TMenuForm.replaceParams(code: string;fileName: string;htmlTag: string;names: TStrings; values: TStrings):string;
var
    pos1,pos2,pos3,pos4: integer;
    tmpInt: integer;
    sl: TStringList;
    defaultValue: string;
    paramNameExtracted: string;
    arrayId: integer;
    varHtmlCode,tmpStr: string;
    lengthHtmlTag: integer;
begin
    sl := TStringList.Create;

    varHtmlCode := code;
    Result := '';
    lengthHtmlTag := Length(htmlTag)+2;
    htmlTag := LowerCase(htmlTag);
    pos1 := Pos('['+htmlTag+':',LowerCase(varHtmlCode));
    while pos1 <> 0 do
    begin
      // extract the param name and its default value
      pos2 := PosEx(']',varHtmlCode,pos1+lengthHtmlTag);
      tmpStr := MidStr(varHtmlCode,pos1+lengthHtmlTag,pos2-pos1-lengthHtmlTag);

      // check if there an array id
      pos3 := Pos(':',tmpStr);

      if pos3 = -1 then
      begin
        MessageDlg(Format(_('(1) En error occured while parsing ''%s'' at char %d%sUsage : [%s:paramName:index:default(Optional)]'),[fileName,pos1,EOL,htmlTag]),mtError,[mbOk],0);
        Break;
      end;

      // check if there is a default value
      pos4 := PosEx(':',tmpStr,pos3+1);

      try
        if pos4 > 0 then // if there is a default value : extract it
        begin
          defaultValue := MidStr(tmpStr,pos4+1,999999);
          arrayId := StrToInt(MidStr(tmpStr,pos3+1,pos4-pos3-1));
          paramNameExtracted := LeftStr(tmpStr,pos3-1);
        end
        else
        begin
          defaultValue := '';
          paramNameExtracted := LeftStr(tmpStr,pos3-1);
          arrayId := StrToInt(MidStr(tmpStr,pos3+1,999999));
        end;
      except
        MessageDlg(Format(_('(2) En error occured while parsing ''%s'' at char %d%sUsage : [Lobby:LoadParam:paramName:index:default(Optional)]'),[fileName,pos1,EOL]),mtError,[mbOk],0);
        Break;
      end;

      tmpInt := names.IndexOf(paramNameExtracted);
      if tmpInt = -1 then
        Result := Result + LeftStr(varHtmlCode,pos1-1)+defaultValue
      else
      begin
        Misc.ParseDelimited(sl,values[tmpInt],':','');
        if sl.Count-1 < arrayId then
        begin
          Result := Result + LeftStr(varHtmlCode,pos1-1)+'';
          //MessageDlg('(3) En error occured while parsing ''' + fileName + ''' at char ' + IntToStr(pos1)+EOL+'Array id incorrect: '+IntToStr(arrayId),mtError,[mbOk],0);
          //Break;
        end
        else
          Result := Result + LeftStr(varHtmlCode,pos1-1)+sl[arrayId];
      end;
      varHtmlCode := MidStr(varHtmlCode,pos2+1,MaxInt);

      pos1 := Pos('['+htmlTag+':',LowerCase(varHtmlCode));
    end;

    Result := Result + varHtmlCode;

    sl.Free;
end;

procedure TMenuForm.SaveMinimapToFile;
var
  newWidth,newHeight: integer;
begin
  if BattleForm.CurrentMapIndex < 0 then
  begin
    Minimap.Picture.Bitmap.Width := BattleForm.NoMapImage.Picture.Width;
    Minimap.Picture.Bitmap.Height := BattleForm.NoMapImage.Picture.Height;
    Minimap.Canvas.StretchDraw(Rect(0,0,BattleForm.NoMapImage.Picture.Width,BattleForm.NoMapImage.Picture.Height),BattleForm.NoMapImage.Picture.Bitmap);
    Minimap.Picture.SaveToFile(MenuCurrentPath+'minimap.bmp');
    Exit;
  end;

  with TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]) do
  begin
    try
      if MapInfo.Width > MapInfo.Height then
      begin
        newWidth := 1024;
        newHeight := Round(1024*MapInfo.Height/MapInfo.Width);
        mapWidthPercent := 100;
        mapHeightPercent := Round(100*MapInfo.Height/MapInfo.Width);
      end
      else
      begin
        newHeight := 1024;
        newWidth := Round(1024*MapInfo.Width/MapInfo.Height);
        mapHeightPercent := 100;
        mapWidthPercent := Round(100*MapInfo.Width/MapInfo.Height);
      end;
    except
      newWidth := 1024;
      newHeight := 1024;
    end;

    if (newWidth = 0) or (newHeight = 0) then
    begin
      newWidth := 1024;
      newHeight := 1024;
    end;

    Minimap.Picture.Bitmap.Width := newWidth;
    Minimap.Picture.Bitmap.Height := newHeight;
    Minimap.Canvas.StretchDraw(Rect(0,0,newWidth,newHeight),BattleForm.MapImage.Picture.Bitmap);
    MinimapZoomedForm.DrawStartPositions(MapInfo,Minimap,minimapFixedStartSize);
    Minimap.Picture.SaveToFile(MenuCurrentPath+'minimap.bmp');
  end;
end;

procedure TMenuForm.FormShow(Sender: TObject);
begin
  if not MenuLoaded and not RunningWithMainMenuDev then
  begin
    MessageDlg(_('An error occured during the Single Player skin loading. Program will now exit ...'),mtError,[mbOk],0);
    Application.Terminate;
    Exit;
  end;

  LockWindowUpdate(MenuForm.Handle);

  tmrMusic.Enabled := true;
  SaveIERegistry;
  springExeVersion := Utility.AcquireSpringVersion;

  //AutorisedURLFiles.Add(LowerCase(MenuCurrentPath+'main.html'));
  AutorisedURLFiles.Add(StringReplace(LowerCase(MenuCurrentPath+'temp654dsq.html'),'\','/',[rfReplaceAll]));
  AutorisedURLFiles.Add(StringReplace(LowerCase(ModMenuPath+'temp654dsq.html'),'\','/',[rfReplaceAll]));

  ListSkins;

  if (Preferences.MapSortStyle <> 1) and (Preferences.MapSortStyle <> 2) then
  begin
    Preferences.MapSortStyle := 1;
    MapListForm.SortMapList(1);
  end;

  mapListHtmlCode := LoadMapListHtmlCode;
  SaveMinimapToFile;
  htmlBrowser.NavigateToURL(MenuCurrentPath+'main.html');
  LoadMenu('main.html',Main);
end;

procedure TMenuForm.StartSkirmish;
begin
  if BattleForm.CurrentMapIndex < 0 then
  begin
    MessageDlg(_('You need to select a map first.'),mtInformation,[mbOk],0);
    Exit;
  end;

  if not GenerateScript(ExtractFilePath(Application.ExeName)+'script.txt') then
    Exit;

  FillChar(Process.proc_info, sizeof(TProcessInformation), 0);
  FillChar(Process.startinfo, sizeof(TStartupInfo), 0);
  Process.startinfo.cb := sizeof(TStartupInfo);
  Process.startinfo.dwFlags := STARTF_USESHOWWINDOW;
  Process.startinfo.wShowWindow := SW_SHOWMAXIMIZED;

  if CreateProcess(nil, PChar(ExtractFilePath(Application.ExeName) + 'spring.exe script.txt'), nil, nil, false, CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS + SYNCHRONIZE,
                   nil, PChar(ExtractFilePath(Application.ExeName)), Process.startinfo, Process.proc_info) then
  begin
    tmrMusic.Enabled := false;
    if MP1.Mode = mpPlaying then
        MP1.Pause;
    GameTimer.Enabled := True;
  end
  else
  begin
    CloseHandle(Process.proc_info.hProcess);
    Application.MessageBox(PChar(_('Couldn''t execute the application')), 'Error', MB_ICONEXCLAMATION);
  end;
end;

function TMenuForm.GenerateScript(FileName: string):boolean;
var
  script: TScript;
  i,j: integer;
  tmpInt: integer;
  il: TIntegerList;
  TeamAllyCounter: TIntegerList;
  Colors: TStringList;
  tryToRewriteScript: boolean;
  f: TextFile;
begin
  il := TIntegerList.Create;
  TeamAllyCounter := TIntegerList.Create;
  Colors := TStringList.Create;
  script := TScript.Create('');

  script.AddOrChangeKeyValue('GAME/Mapname',Utility.MapList[BattleForm.CurrentMapIndex]);
  Script.AddOrChangeKeyValue('GAME/Maphash',IntToStr(Utility.MapChecksums.Items[BattleForm.CurrentMapIndex]));
  if BattleForm.CurrentModName = '' then
  begin
    MessageDlg(_('You must select a mod first.'),mtWarning,[mbOk],0);
    Script.Free;
    il.Free;
    Exit;
  end;
  script.AddOrChangeKeyValue('GAME/GameType',BattleForm.CurrentModName);
  script.AddOrChangeKeyValue('GAME/ModHash',IntToStr(Utility.GetModHash(BattleForm.CurrentModName)));
  if BattleForm.GameEndRadioGroup.Visible then
    script.AddOrChangeKeyValue('GAME/modoptions/gamemode',IntToStr(GameType));
  script.AddOrChangeKeyValue('GAME/startpostype',IntToStr(GameMode));
  if BattleForm.UnitsTracker.Visible then
    script.AddOrChangeKeyValue('GAME/modoptions/maxunits',IntToStr(MaxUnits));
  if BattleForm.EnergyTracker.Visible then
    script.AddOrChangeKeyValue('GAME/modoptions/startenergy',IntToStr(StartEnergy));
  if BattleForm.MetalTracker.Visible then
    script.AddOrChangeKeyValue('GAME/modoptions/startmetal',IntToStr(StartMetal));
  script.AddOrChangeKeyValue('GAME/HostIP','localhost');
  script.AddOrChangeKeyValue('GAME/HostPort','8452');
  script.AddOrChangeKeyValue('GAME/MyPlayerName','Me');
  script.AddOrChangeKeyValue('GAME/IsHost','1');
  script.AddOrChangeKeyValue('GAME/NumPlayers','1');
  script.AddOrChangeKeyValue('GAME/NumUsers','1');

  il.Clear;
  il.Add(MePlayer.Id);
  for i:=0 to AIPlayerList.Count-1 do
    if il.IndexOf(TSPAIItem(AIPlayerList[i]^).Id) = -1 then
      il.Add(TSPAIItem(AIPlayerList[i]^).Id);
  script.AddOrChangeKeyValue('GAME/NumTeams',IntToStr(il.Count));

  if il.Count < AIPlayerList.Count then
  begin
    MessageDlg(_('Two or more bots share the same id, please change that.'),mtWarning,[mbOk],0);
    Script.Free;
    il.Free;
    Exit;
  end;

  il.Clear;
  il.Add(MePlayer.Team);
  for i:=0 to AIPlayerList.Count-1 do
    if il.IndexOf(TSPAIItem(AIPlayerList[i]^).Team) = -1 then
      il.Add(TSPAIItem(AIPlayerList[i]^).Team);
  //script.AddOrChangeKeyValue('GAME/NumAllyTeams',IntToStr(il.Count));

  script.AddOrChangeKeyValue('GAME/PLAYER0/name','Me');
  script.AddOrChangeKeyValue('GAME/PLAYER0/Spectator','0');
  script.AddOrChangeKeyValue('GAME/PLAYER0/team',IntToStr(MePlayer.Id));

  Colors.Add(ColorToScriptString(clBlue));
  Colors.Add(ColorToScriptString(clBlack));
  Colors.Add(ColorToScriptString(clWhite));
  Colors.Add(ColorToScriptString(clGreen));
  Colors.Add(ColorToScriptString(clGray));
  Colors.Add(ColorToScriptString(clYellow));
  Colors.Add(ColorToScriptString(clRed));
  Colors.Add(ColorToScriptString(clPurple));
  Colors.Add(ColorToScriptString(clMaroon));
  Colors.Add(ColorToScriptString(PackRGB(255,186,0))); // orange
  Colors.Add(ColorToScriptString(PackRGB(255,187,227))); // pink
  Colors.Add(ColorToScriptString(PackRGB(140,0,0))); // dark red
  Colors.Add(ColorToScriptString(PackRGB(112,255,173))); // light blue green
  Colors.Add(ColorToScriptString(PackRGB(106,0,97))); // dark purple
  Colors.Add(ColorToScriptString(PackRGB(0,21,151))); // dark blue
  Colors.Add(ColorToScriptString(PackRGB(0,115,115))); // dark cyan ?

  for i:=0 to 15 do
    TeamAllyCounter.Add(0);

  script.AddOrChangeKeyValue('GAME/TEAM0/TeamLeader','0');
  script.AddOrChangeKeyValue('GAME/TEAM0/AllyTeam',IntToStr(MePlayer.Team));
  tmpInt := RandomRange(0,Colors.Count-1);
  script.AddOrChangeKeyValue('GAME/TEAM0/RGBColor',Colors[tmpInt]);
  Colors.Delete(tmpInt);
  script.AddOrChangeKeyValue('GAME/TEAM0/Side',Utility.SideList[MePlayer.Side]);
  script.AddOrChangeKeyValue('GAME/TEAM0/Handicap',IntToStr(MePlayer.Handicap));
  //if GameMode = 3 then
  //begin
    script.AddOrChangeKeyValue('GAME/TEAM0/StartPosX',IntToStr(Round(MePlayer.StartPosX*TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Width*8)));
    script.AddOrChangeKeyValue('GAME/TEAM0/StartPosZ',IntToStr(Round(MePlayer.StartPosY*TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Height*8)));
  //end;

  TeamAllyCounter.Items[MePlayer.Id] := 1;

  for i:=0 to AIPlayerList.Count-1 do
  begin
    if TSPAIItem(AIPlayerList[i]^).Id <> MePlayer.Id then
    begin
      script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Name','AI_'+IntToStr(i+1));
      script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/ShortName',TSPAIItem(AIPlayerList[i]^).AIType);
      script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Team',IntToStr(i+1));
      script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Host','0');

      script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/TeamLeader','0');
      script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/AllyTeam',IntToStr(TSPAIItem(AIPlayerList[i]^).Team));
      tmpInt := RandomRange(0,Colors.Count-1);
      script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/RGBColor',Colors[tmpInt]);
      Colors.Delete(tmpInt);
      script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/Side',Utility.SideList[TSPAIItem(AIPlayerList[i]^).Side]);
      script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/Handicap',IntToStr(TSPAIItem(AIPlayerList[i]^).Handicap));

      //if GameMode = 3 then
      //begin
        script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/StartPosX',IntToStr(Round(TSPAIItem(AIPlayerList[i]^).StartPosX*TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Width*8)));
        script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i+1)+'/StartPosZ',IntToStr(Round(TSPAIItem(AIPlayerList[i]^).StartPosY*TMapItem(MapListForm.Maps[BattleForm.CurrentMapIndex]).MapInfo.Height*8)));
      //end;

      TeamAllyCounter.Items[TSPAIItem(AIPlayerList[i]^).Team] := TeamAllyCounter.Items[TSPAIItem(AIPlayerList[i]^).Team]+1;
    end;

  end;

  for i:=0 to TeamAllyCounter.Count-1 do
    if TeamAllyCounter.Items[i] > 0 then
      script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/NumAllies','0');  //IntToStr(TeamAllyCounter.Items[i]-1)

  script.AddOrChangeKeyValue('GAME/NumRestrictions',IntToStr(DisabledUnitList.Count));
  for i:=0 to DisabledUnitList.Count-1 do
  begin
    script.AddOrChangeKeyValue('GAME/RESTRICT/Unit'+IntToStr(i),DisabledUnitList[i]);
    script.AddOrChangeKeyValue('GAME/RESTRICT/Limit'+IntToStr(i),'0');
  end;

  with BattleForm do
  begin
     // mod options:
     for i:=0 to ModOptionsList.Count -1 do
      if TLuaOption(ModOptionsList[i]).ClassType <> TLuaOptionSection then
        script.AddOrChangeKeyValue(TLuaOption(ModOptionsList[i]).KeyPrefix + TLuaOption(ModOptionsList[i]).Key,TLuaOption(ModOptionsList[i]).toString);

     // map options:
     for i:=0 to MapOptionsList.Count -1 do
      if TLuaOption(MapOptionsList[i]).ClassType <> TLuaOptionSection then
        script.AddOrChangeKeyValue(TLuaOption(MapOptionsList[i]).KeyPrefix + TLuaOption(MapOptionsList[i]).Key,TLuaOption(MapOptionsList[i]).toString);
  end;

  // bot options:
  for j:=0 to AIPlayerList.Count-1 do
    for i:=0 to TSPAIItem(AIPlayerList[j]^).OptionsList.Count -1 do
      if TLuaOption(TSPAIItem(AIPlayerList[j]^).OptionsList[i]).ClassType <> TLuaOptionSection then
        Script.AddOrChangeKeyValue(TLuaOption(TSPAIItem(AIPlayerList[j]^).OptionsList[i]).KeyPrefix + TLuaOption(TSPAIItem(AIPlayerList[j]^).OptionsList[i]).Key,TLuaOption(TSPAIItem(AIPlayerList[j]^).OptionsList[i]).toString);

  il.Free;

  // write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    Write(f, script.Script);
    CloseFile(f);
    tryToRewriteScript := False;
    Result := True;
  except
    Result := False;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg(CANT_WRITE_SCRIPT_MSG,mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;

  script.Free;
end;

function TMenuForm.getBotIndex(id: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i:=0 to AIPlayerList.Count-1 do
    if TSPAIItem(AIPlayerList[i]^).Id = id then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TMenuForm.htmlBrowserControlBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  command: String;
  localFile: String;
  i:integer;
  tmp: integer;
  tmpStr: string;
  sl: TStringList;
  sl2: TStringList;
  bot: ^TSPAIItem;
  browsePage: ^TBrowsePage;
  luaOptionList: TList;
begin
  URL := StringReplace(URL,'file:///','',[rfReplaceAll]);
  URL := StringReplace(URL,'file://','',[rfReplaceAll]);
  URL := StringReplace(URL,'\','/',[rfReplaceAll]);
  if RightStr(URL,1) = '#' then
    URL := LeftStr(URL,Length(URL)-1);
  if Debug.Enabled then
  begin
    MainForm.AddMainLog('SP URL Change : '+URL,Colors.Normal);
    for i:=0 to AutorisedURLFiles.Count-1 do
      MainForm.AddMainLog('Authorized URLs : '+AutorisedURLFiles[i],Colors.Normal);
  end;

  if AutorisedURLFiles.IndexOf(LowerCase(URL)) >= 0 then
  begin
    // to avoid white flashes
    LockWindowUpdate(Handle);
    Exit;
  end;

  sl := TStringList.Create;
  sl2 := TStringList.Create;

  Cancel := true;
  // disable the click sound
  Misc.SetRegistryData(HKEY_CURRENT_USER,'AppEvents\Schemes\Apps\Explorer\Navigating\.Current','',rdExpandString,'');

  URL := URLDecode(URL);

  if Pos('lobby:',URL) <> 0 then
    command := MidStr(URL,Pos('lobby:',URL)+6,99999);
  if command <> '' then
  begin
    if LowerCase(command) = 'quit' then
    begin
      SaveToRegOnExit := true;
      SaveLayoutOnClose := false;
      MainForm.Close;
      Exit;
    end;
    if LowerCase(command) = 'showmultiplayerlobby' then
    begin
      if MP1.Mode = mpPlaying then
      begin
        MP1.Stop;
        MP1.Close;
      end;
      if MP2.Mode = mpPlaying then
      begin
        MP2.Stop;
        MP2.Close;
      end;
      tmrMusic.Enabled := false;
      BattleForm.ResetBattleScreen;
      MainForm.Show;
      MainForm.FinaliseStart;
      MenuForm.Hide;
      if Preferences.ConnectOnStartup then PostMessage(MainForm.Handle, WM_CONNECT, 0, 0);
      Exit;
    end;
    if LowerCase(command) = 'gamesettings' then
    begin
      PreferencesForm.GameSettingsButtonClick(nil);
      Exit;
    end;
    if LowerCase(command) = 'main' then
    begin
      LoadMenuFromMod := False;
      LoadMenu('main.html',Main);
      Exit;
    end;
    if LowerCase(command) = 'modmain' then
    begin
      if BattleForm.CurrentModName = '' then Exit;
      LoadMenu('modmain.html',ModMain);
      Exit;
    end;
    if LowerCase(command) = 'campaigns' then
    begin
      LoadMenu('campaigns.html',CampaignsMenu);
      Exit;
    end;
    if LowerCase(command) = 'missions' then
    begin
      LoadMenu('missions.html',MissionsMenu);
      Exit;
    end;
    if LowerCase(command) = 'skirmish' then
    begin
      AIPlayerList.Clear;
      MePlayer.Id := 0;
      MePlayer.Team := 0;
      MePlayer.Side := 0;
      MePlayer.Handicap :=  0;
      idBots := 1;
      freeIds.Clear;
      for i:=1 to 15 do
        freeIds.Add(i);
      LoadMenu('skirmish.html',Skirmish);
      Exit;
    end;
    if LowerCase(command) = 'back' then
    begin
      browsePage := BrowseHistory.Pop;
      browsePage := BrowseHistory.Pop;
      LoadMenu(browsePage^.PageName,browsePage^.PageType);
      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'playsound:' then
    begin
      tmpStr := MidStr(command,11,99999);
      MP2.FileName := MenuCurrentPath + tmpStr;
      try
        MP2.Open;
        MP2.Play;
      except
        // nothing
      end;
      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'playmusic:' then
    begin
      tmpStr := MidStr(command,11,99999);
      if (MP1.FileName = MenuCurrentPath + tmpStr) and (MP1.Mode = mpPlaying) then // already playing the music
        Exit;
      MP1.FileName := MenuCurrentPath + tmpStr;
      try
        MP1.Open;
        MP1.Play;
      except
         // nothing
      end;
      Exit;
    end;
    if LowerCase(command) = 'stopmusic' then
    begin
      if MP1.FileName = '' then Exit;
      MP1.FileName := '';
      MP1.Stop;
      MP1.Close;
      Exit;
    end;
    if LeftStr(LowerCase(command),11) = 'changeskin:' then
    begin
      tmp := StrToInt(MidStr(command,12,99999));
      if LowerCase(skinList[tmp])+'.ssk' = LowerCase(Preferences.SPSkin) then Exit;
      LoadSkin(skinList[tmp]+'.ssk');
      paramNames.Clear;
      paramValues.Clear;
      LoadMenu('main.html',Main);
      Exit;
    end;
    if LeftStr(LowerCase(command),14) = 'selectmission:' then
    begin
      tmp := StrToInt(MidStr(command,15,99999));
      CurrentCampaignIndex := tmp;
      TCampaign(CampaignList[CurrentCampaignIndex]).LoadNextMission;

      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'selectcampaign:' then
    begin
      tmp := StrToInt(MidStr(command,16,99999));
      CurrentCampaignIndex := tmp;
      TCampaign(CampaignList[CurrentCampaignIndex]).LoadNextMission;
      Exit;
    end;
    if LeftStr(LowerCase(command),13) = 'startmission:' then
    begin
      tmpStr := MidStr(command,14,99999);

      TCampaign(CampaignList[CurrentCampaignIndex]).StartMission(tmpStr);

      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'selectmap:' then
    begin
      tmpStr := MidStr(command,11,99999);
      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg('Invalid selectmap usage : '+command,mtError,[mbOk],0);
        Exit;
      end;
      BattleForm.ChangeMap(StrToInt(sl[0]));
      SaveMinimapToFile;
      if sl[1] = '1' then
      begin
        browsePage := BrowseHistory.Peek;
        LoadMenu(TBrowsePage(browsePage^).PageName,TBrowsePage(browsePage^).PageType);
      end;
      Exit;
    end;
    if LeftStr(LowerCase(command),11) = 'sortmapsby:' then
    begin
      tmpStr := MidStr(command,12,99999);
      if LowerCase(tmpStr) = 'size' then
      begin
        MapListForm.SortMapList(2);
        Preferences.MapSortStyle := 2;
        mapListHtmlCode := LoadMapListHtmlCode;
      end
      else if LowerCase(tmpStr) = 'name' then
      begin
        MapListForm.SortMapList(1);
        Preferences.MapSortStyle := 1;
        mapListHtmlCode := LoadMapListHtmlCode;
      end
      else
      begin
        MessageDlg(_('Invalid sortmapsby usage : ')+command,mtError,[mbOk],0);
        Exit
      end;
      browsePage := BrowseHistory.Peek;
      LoadMenu(TBrowsePage(browsePage^).PageName,TBrowsePage(browsePage^).PageType);
      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'selectmod:' then
    begin
      browsePage := BrowseHistory.Peek;
      if MidStr(command,11,99999) = '' then Exit;
      tmp := StrToInt(MidStr(command,11,99999));
      LoadingMessage := Format(_('Loading mod ''%s'', please wait ...'),[Utility.ModList[tmp]]);

      LoadMenu('loading.html',Loading);
      BrowseHistory.Pop;
      LoadMod(Utility.ModList[tmp]);
      LoadMenu('modMain.html',ModMain);
      Exit;
    end;
    if LeftStr(LowerCase(command),17) = 'saveparambyindex:' then
    begin
      tmpStr := MidStr(command,18,99999);
      Misc.ParseDelimited(sl,tmpStr,':','');
      if sl.Count <> 3 then
      begin
        MessageDlg(_('Invalid saveparambyindex usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;
      tmp := paramNames.IndexOf(sl[0]);
      if tmp = -1 then
      begin
        paramNames.Add(sl[0]);
        paramValues.Add(StringNChar(':',StrToInt(sl[1]))+sl[2]);
      end
      else
      begin
        Misc.ParseDelimited(sl2,paramValues[tmp],':','');
        if sl2.Count <= StrToInt(sl[1]) then
          for i:=0 to StrToInt(sl[1])-sl2.Count do
            sl2.Add('');
        sl2[StrToInt(sl[1])] := sl[2];
        paramValues[tmp] := Misc.JoinStringList(sl2,':');
      end;
      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'saveparam:' then
    begin
      tmpStr := MidStr(command,11,99999);
      Misc.ParseDelimited(sl,tmpStr,':','');
      if sl.Count < 2 then
      begin
        MessageDlg(_('Invalid saveparam usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;
      tmp := paramNames.IndexOf(sl[0]);
      if tmp = -1 then
      begin
        paramNames.Add(sl[0]);
        paramValues.Add(Misc.JoinStringList(sl,':',1));
      end
      else
        paramValues[tmp] := Misc.JoinStringList(sl,':',1);
      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),13) = 'savesettings:' then
    begin
      tmpStr := MidStr(command,14,99999);
      Misc.ParseDelimited(sl,tmpStr,':','');
      if sl.Count < 2 then
      begin
        MessageDlg(_('Invalid savesettings usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;
      tmp := settingsNames.IndexOf(sl[0]);
      if tmp = -1 then
      begin
        settingsNames.Add(sl[0]);
        settingsValues.Add(Misc.JoinStringList(sl,':',1));
      end
      else
        settingsValues[tmp] := Misc.JoinStringList(sl,':',1);
      sl.Free;
      Exit;
    end;
    if LowerCase(command) = 'resetparams' then
    begin
      paramNames.Clear;
      paramValues.Clear;
      Exit;
    end;
    if LeftStr(LowerCase(command),12) = 'changemetal:' then
    begin
      tmpStr := MidStr(command,13,99999);
      StartMetal := StrToInt(tmpStr);
      Exit;
    end;
    if LeftStr(LowerCase(command),13) = 'changeenergy:' then
    begin
      tmpStr := MidStr(command,14,99999);
      StartEnergy := StrToInt(tmpStr);
      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'changemaxunits:' then
    begin
      tmpStr := MidStr(command,16,99999);
      MaxUnits := StrToInt(tmpStr);
      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'changegametype:' then
    begin
      tmpStr := MidStr(command,16,99999);
      GameType := StrToInt(tmpStr);
      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'changegamemode:' then
    begin
      tmpStr := MidStr(command,16,99999);
      GameMode := StrToInt(tmpStr);
      Exit;
    end;
    if LeftStr(LowerCase(command),26) = 'changeminimapstartpossize:' then
    begin
      tmpStr := MidStr(command,27,99999);
      minimapFixedStartSize := StrToInt(tmpStr);
      SaveMinimapToFile;
      Exit;
    end;
    if LeftStr(LowerCase(command),12) = 'disableunit:' then
    begin
      tmpStr := MidStr(command,13,99999);
      tmp := StrToInt(tmpstr);

      if DisabledUnitList.IndexOf(Utility.UnitList[tmp]) < 0 then
        DisabledUnitList.Add(Utility.UnitList[tmp]);
      Exit;
    end;
    if LeftStr(LowerCase(command),11) = 'enableunit:' then
    begin
      tmpStr := MidStr(command,12,99999);
      tmp := StrToInt(tmpstr);

      tmp := DisabledUnitList.IndexOf(Utility.UnitList[tmp]);
      if tmp >= 0 then
        DisabledUnitList.Delete(tmp);
      Exit;
    end;
    if LeftStr(LowerCase(command),16) = 'changeluaoption:' then
    begin
      tmpStr := MidStr(command,17,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg(_('Invalid changeluaoption usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        case tmp div LUAOPTIONS_ID_MAX of
          0:luaOptionList := BattleForm.ModOptionsList;
          1:luaOptionList := BattleForm.MapOptionsList;
        else
          luaOptionList := TSPAIItem(AIPlayerList[tmp div LUAOPTIONS_ID_MAX-2]^).OptionsList;
        end;

        TLuaOption(luaOptionList[tmp mod LUAOPTIONS_ID_MAX]).SetValue(sl[1]);
      except
        MessageDlg(_('Invalid changeluaoption usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),13) = 'changemyname:' then
    begin
      MePlayer.Name := MidStr(command,14,99999);
      Exit;
    end;
    if LeftStr(LowerCase(command),7) = 'addbot:' then
    begin
      if freeIds.Count = 0 then Exit; // 16 players/bots max
      tmpStr := MidStr(command,8,99999);

      New(bot);

      bot^.AIType := tmpStr;
      bot^.Id := freeIds.Items[0];
      freeIds.Delete(0);
      bot^.Team := AIPlayerList.Count+1;
      bot^.Side := 0;
      bot^.Handicap := 0;
      bot^.UniqueId := idBots;
      idBots := idBots + 1;
      bot^.Name := 'T'+IntToStr(idBots);
      bot^.OptionsList := TList.Create;
      Utility.LoadLuaOptions(bot^.OptionsList,Utility.LoadSkirmishAI(tmpStr),'GAME/AI'+IntToStr(bot^.Id-1)+'/OPTIONS/',False);
      Application.CreateForm(TBotOptionsForm, bot^.OptionsForm);
      Utility.DisplayLuaOptions(bot^.OptionsList,bot^.OptionsForm.AIOptionsScrollBox);

      AIPlayerList.Add(bot);

      browsePage := BrowseHistory.Peek;
      LoadMenu(TBrowsePage(browsePage^).PageName,TBrowsePage(browsePage^).PageType);
      Exit;
    end;
    if LeftStr(LowerCase(command),10) = 'removebot:' then
    begin
      tmp := StrToInt(MidStr(command,11,99999));

      freeIds.Add(TSPAIItem(AIPlayerList[tmp-2]^).Id);
      AIPlayerList.Delete(tmp-2);

      browsePage := BrowseHistory.Peek;
      LoadMenu(TBrowsePage(browsePage^).PageName,TBrowsePage(browsePage^).PageType);
      Exit;
    end;
    if LeftStr(LowerCase(command),11) = 'changeside:' then
    begin
      tmpStr := MidStr(command,12,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg(_('Invalid changeside usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        if tmp = 1 then
        begin
          MePlayer.Side := StrToInt(sl[1]);
        end
        else
        begin
          TSPAIItem(AIPlayerList[tmp-2]^).Side := StrToInt(sl[1]);
        end;
      except
        MessageDlg(_('Invalid changeside usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),9) = 'changeid:' then
    begin
      tmpStr := MidStr(command,10,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg(_('Invalid changeid usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        if tmp = 1 then
        begin
          MePlayer.Id := StrToInt(sl[1]);
        end
        else
        begin
          TSPAIItem(AIPlayerList[tmp-2]^).Id := StrToInt(sl[1]);
        end;
      except
        MessageDlg(_('Invalid changeid usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),11) = 'changeteam:' then
    begin
      tmpStr := MidStr(command,12,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg(_('Invalid changeally usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        if tmp = 1 then
        begin
          MePlayer.Team := StrToInt(sl[1]);
        end
        else
        begin
          TSPAIItem(AIPlayerList[tmp-2]^).Team := StrToInt(sl[1]);
        end;
      except
        MessageDlg(_('Invalid changeally usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'changehandicap:' then
    begin
      tmpStr := MidStr(command,16,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 2) then
      begin
        MessageDlg(_('Invalid changehandicap usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        if tmp = 1 then
        begin
          MePlayer.Handicap := StrToInt(sl[1]);
        end
        else
        begin
          TSPAIItem(AIPlayerList[tmp-2]^).Handicap := StrToInt(sl[1]);
        end;
      except
        MessageDlg(_('Invalid changehandicap usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LeftStr(LowerCase(command),15) = 'changestartpos:' then
    begin
      tmpStr := MidStr(command,16,99999);

      Misc.ParseDelimited(sl,tmpStr,':','');

      if (sl.Count <> 3) then
      begin
        MessageDlg(_('Invalid changestartpos usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      try
        tmp := StrToInt(sl[0]);
        if tmp = 1 then
        begin
          MePlayer.StartPosX := StrToFloat(sl[1]);
          MePlayer.StartPosY := StrToFloat(sl[2]);
        end
        else
        begin
          TSPAIItem(AIPlayerList[tmp-2]^).StartPosX := StrToFloat(sl[1]);
          TSPAIItem(AIPlayerList[tmp-2]^).StartPosY := StrToFloat(sl[2]);
        end;
      except
        MessageDlg(_('Invalid changestartpos usage : ')+command,mtError,[mbOk],0);
        sl.Free;
        Exit;
      end;

      sl.Free;
      Exit;
    end;
    if LowerCase(command) = 'start' then
    begin
      StartSkirmish;
      //Misc.VariantToString(PostData)
      Exit;
    end;

    if LeftStr(LowerCase(command),10) = 'localfile:' then
    begin
      //MessageDlg(Misc.VariantToString(PostData),mtInformation,[mbOk],0);
      localFile := MidStr(command,11,99999);
      browsePage := BrowseHistory.Peek;
      LoadMenu(localFile,TBrowsePage(browsePage^).PageType);
      Exit;
    end;

    MessageDlg(_('Unknown lobby command : ''') + command + '''',mtError,[mbOk],0);
    Exit;
  end;

  if LeftStr(LowerCase(URL),7) = 'http://' then
    Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TMenuForm.LoadCampaigns;
var
  c: TCampaign;
  res : integer;
  s, modShortName: string;
begin
  CampaignList.Clear;

  modShortName := GetModShortName;

  res := InitSubDirsVFS(PChar('Campaign/'+modShortName),'*',nil);
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);
  while res <> 0 do
  begin
    Delete(s,Pos(#0,s),255);
    c := TCampaign.Create(s+modShortName+'.lua');
    CampaignList.Add(c);
    SetLength(s, 255);
    res := FindFilesVFS(res, PChar(s), 255);
  end;
end;

procedure TMenuForm.htmlBrowserControlNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Misc.SetRegistryData(HKEY_CURRENT_USER,'AppEvents\Schemes\Apps\Explorer\Navigating\.Current','',rdExpandString,soundValue);
end;

procedure TMenuForm.GameTimerTimer(Sender: TObject);
var
  browsePage: ^TBrowsePage;
begin
  GameTimer.Enabled := False;
  if GetExitCodeProcess(Process.proc_info.hProcess, Process.ExitCode)
  then
    if Process.ExitCode = STILL_ACTIVE then
      GameTimer.Enabled := True
    else
    begin
      LockWindowUpdate(Handle);
      MenuForm.WindowState := wsNormal;
      MenuForm.WindowState := wsMaximized;
      LockWindowUpdate(0);
      CloseHandle(Process.proc_info.hProcess);
      tmrMusic.Enabled := true;
      if MP1.Mode = mpPaused then
        MP1.Resume;
      browsePage := BrowseHistory.Peek;
      if (browsePage^.PageType = Campaign) or (browsePage^.PageType = Mission) then
      begin
        TCampaign(CampaignList[CurrentCampaignIndex]).LoadNextMission;
      end;
    end
  else
  begin
    TerminateProcess(Process.proc_info.hProcess, 0);
    CloseHandle(Process.proc_info.hProcess);
    tmrMusic.Enabled := true;
    if MP1.Mode = mpPaused then
        MP1.Resume;
    browsePage := BrowseHistory.Peek;
    if (browsePage^.PageType = Campaign) or (browsePage^.PageType = Mission) then
    begin
      TCampaign(CampaignList[CurrentCampaignIndex]).LoadNextMission;
    end;
  end;
end;

procedure TMenuForm.tmrMusicTimer(Sender: TObject);
begin
  if (MP1.FileName <> '') and not (MP1.Mode = mpPlaying) then
    try
      MP1.Play;
    except
    end;

end;

procedure TMenuForm.htmlBrowserControlNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel := true;
end;

procedure TMenuForm.htmlBrowserControlDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  // to avoid white flashes
  PostMessage(MenuForm.Handle,WM_UNLOCK_WINDOW,0,0);
end;

procedure TMenuForm.OnUnlockMessage(var Msg: TMessage);
begin
  LockWindowUpdate(0);
end;

function TMenuForm.playerHasWon(scriptFileName: string): boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.Text := ReadFile2(scriptFileName);

  Result := sl.IndexOf('You win!') <> -1;

  sl.Free;
end;

procedure TMenuForm.SaveSettings;
var
  Ini : TIniFile;
  i: integer;
  FileName: String;
begin
  FileName := ExtractFilePath(Application.ExeName) + MENU_SETTINGS_FILE;
  if FileExists(FileName) then
    DeleteFile(MENU_SETTINGS_FILE);
  Ini := TIniFile.Create(FileName);
  for i:=0 to settingsNames.Count-1 do
    Ini.WriteString('MenuSettings', settingsNames[i], settingsValues[i]);
  Ini.Free;
end;

procedure TMenuForm.LoadSettings;
var
  Ini : TIniFile;
  i: integer;
  pos: integer;
  FileName: String;
begin
  FileName := ExtractFilePath(Application.ExeName) + MENU_SETTINGS_FILE;
  Ini := TIniFile.Create(FileName);

  settingsNames.Clear;
  ini.ReadSection('MenuSettings',settingsNames);
  for i:=0 to settingsNames.Count-1 do
  begin
    settingsValues.Add(Ini.ReadString('MenuSettings', settingsNames[i], ''));
  end;
  Ini.Free;
end;

procedure TMenuForm.ListSkins;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
  skinList.Clear;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + SPSKIN_FOLDER + '\*.ssk', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        skinList.Add(LeftStr(sr.Name,Length(sr.Name)-4));
      end
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMenuForm.LoadSkin(skinFile: string);
begin
  try MP1.Stop; except end;
  try MP1.Close; except end;
  try MP2.Stop; except end;
  try MP2.Close; except end;

  if not FileExists(ExtractFilePath(Application.ExeName) + SPSKIN_FOLDER + '\' + skinFile) then
  begin
    MessageDlg(Format(_('Single Player skin file ''%s\%s'' not found.'),[ExtractFilePath(Application.ExeName) + SPSKIN_FOLDER,skinFile]),mtWarning,[mbOK],0);
    MenuLoaded := False;
    Exit;
  end;

  DelTree(GetEnvironmentVariable('TEMP')+'\tasclientgui\');
  SevenZip1.SZFileName := ExtractFilePath(Application.ExeName) + SPSKIN_FOLDER + '\' + skinFile;
  SevenZip1.ExtrBaseDir := GetEnvironmentVariable('TEMP')+'\tasclientgui';
  SevenZip1.Extract(false);

  Preferences.SPSkin := skinFile;
  PreferencesForm.WritePreferencesToRegistry;
  MenuLoaded := True;
end;

procedure TMenuForm.LoadMod(modName: string);
var
  i: integer;
begin
  BattleForm.ChangeCurrentMod(modName);
  DelTree(ModMenuPath);
  CopyTree(MenuCurrentPath,ModMenuPath);
  LoadMenuFromMod := ExtractVFSDir('SPTheme/IE',ModMenuPath);
  Utility.ReloadUnitList;
  LoadCampaigns;

  // reload bot list
  AddBotForm.ReloadButtonClick(nil);

  MePlayer.Side := 0;
  for i:=0 to AIPlayerList.Count-1 do
     TSPAIItem(AIPlayerList[i]^).Side := 0;
end;

end.
