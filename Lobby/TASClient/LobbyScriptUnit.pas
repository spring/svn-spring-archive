unit LobbyScriptUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs,Misc,ExtCtrls, WrapDelphi, WrapDelphiClasses,PythonEngine,
  PythonGUIInputOutput, StrUtils, JclDebug,TntWideStrings,
  OverbyteIcsWSocket,MainUnit, class_TIntegerList, RichEdit2, ExRichEdit,
  SyncObjs,SpTBXItem, TB2Item, JvDesktopAlert, GR32,
  SpTBXControls, SpTBXTabs,Forms, ComCtrls, pngimage,
  Jpeg, Math, Dockpanel, RichEdit, SpTBXSkins,ActiveX,JclUnicode,
  ColorsPreferenceUnit;

type
  TScriptForm = class(TForm)
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TScriptSimpleCallback = record
    func: PPyObject;
    args: PPyObject;
  end;
  PScriptSimpleCallback = ^TScriptSimpleCallback;

  TScriptDownloadCallback = record
    func: PPyObject;
    args: PPyObject;
    form: TForm;
  end;
  PScriptDownloadCallback = ^TScriptDownloadCallback;

  TScriptMenuItemCallBack = record
    func: PPyObject;
    menu: TTBCustomItem;
    args: PPyObject;
  end;
  PScriptMenuItemCallBack = ^TScriptMenuItemCallBack;

  TScriptMenuItem = record
    id : integer;
    item: TTBCustomItem;
  end;
  PScriptMenuItem = ^TScriptMenuItem;

  TScriptEventHandler = class(TObject)
    protected
      Ffunc: PPyObject;
    public
      constructor Create(func: PPyObject);
      function wrapEvent(args: PPyObject): Variant;
  end;

  TScriptEventHandlerDefault = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject);
  end;
  TScriptEventHandlerTMouseEvent = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject;  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;
  TScriptEventHandlerTMouseMoveEvent = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  end;
  TScriptEventHandlerTKeyEvent = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;
  TScriptEventHandlerTKeyPressEvent = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject; var Key: Word);
  end;
  TScriptEventHandlerTWebBrowserBeforeNavigate2 = class(TScriptEventHandler)
    published
      procedure eventHandler(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,  Headers: OleVariant; var Cancel: WordBool);
  end;

  {$METHODINFO ON}

  TGUIUpdateCallback = record
    func: PPyObject;
    args: PPyObject;
  end;
  PGUIUpdateCallback = ^TGUIUpdateCallback;

  TGUI = class(TPersistent)
    protected
      menuIdInc : integer;
      MenuItemList: TList;
      textBoxStringList: TStringList;
      textBoxList: TList;

      ddMenuList: TList;
      ddButtonList: TList;
      ddControlList: TList;

      pyProperties: PPyObject;
      pyTextBoxes: PPyObject;
      pyColors: PPyObject;

      FStackLayoutChanges: boolean;

      function GetMenu(name: string): TTBCustomItem;
      procedure AddSelectionArgs(m: PScriptMenuItemCallBack);
      procedure MenuItemClick(Sender: TObject);
      function GetFreeMenuId: integer;
      procedure SimpleCallbackEvent(Sender: TObject);
      procedure LockGUI;
      procedure UnlockGUI;
      procedure RefreshRichEditLists;
      procedure ClearRefs;
      procedure onDropDownButtonClick(Sender: TObject);
      procedure Print(data : string);
      procedure EventHandler(Sender: TObject);
    public
      constructor Create;
      function AddItemToMenu(menu: string;compName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string;itemCaption: string): Integer;
      function AddItemToMenu2(callbackArgs: Variant; callbackFunction: Variant;menu: string;compName: string; itemCaption: string): Integer;
      function AddSubmenuToMenu(menu: string;compName: string; itemCaption: string): Integer;
      function AddSeparatorToMenu(menu: string;compName: string): Integer;
      procedure SetMenuItemState(id: integer; c: boolean; e: boolean);
      procedure RemoveFromMenu(id: integer);

      procedure DisplaySimpleNotification(title: string; msg: string; displayTime: integer);
      procedure DisplayNotification(title: string; msg: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string; displayTime: integer);
      procedure DisplayNotification2(callbackArgs: Variant; callbackFunction: Variant;title: string; msg: string; displayTime: integer);

      function GetControlProperties(component: string; prop: string): Variant;
      function SetControlProperties(component: string; prop : string; propertiesV : Variant): boolean;
      function AddTab(caption: string;name: string;tabsPanel : string):boolean;
      function AddForm(name: string;caption: string; style: integer; dockableForm: boolean=false):boolean;
      function AddControl(name: string;parent: string; className: string):boolean;
      function AddToRichEdit(richedit : string; msg : string; color : integer): boolean;
      procedure AddEvent(component: string; event: string;moduleName: string; functionName: string);
      procedure AddEvent2(component: string; event: string;callbackFunction: Variant);
      function ExecMethod(component: string;methodName: string; parameters: Variant): integer;
      function GetRichEditList: Variant;
      function GetColors: Variant;
      function AddDropDownButton(caption: string; buttonName: string;menuName: string; parent: string): boolean;
      procedure DeleteControl(name: string);
      procedure StackLayoutChanges(b: boolean);


      procedure AddOrReplaceIconList(iconListName: string; icons: Variant);
      procedure SetPlayerIconId(playerName: string; iconTypeName: string; iconId: integer);


      procedure SetBattleVisible(battleId: integer; bVisible: integer);
      procedure SetUserDisplayName(userId: integer; displayName: string);

      procedure ManualDock(component: string; dockDest: string);

      procedure SynchronizedUpdate(callbackModuleName: string; callbackFunctionName: string;callbackArgs: Variant);
      procedure SynchronizedUpdate2(callbackFunction: Variant;callbackArgs: Variant);
  end;

  TCallback = class(TPersistent)
    private
      userRefCountList: TIntegerList;
      pyUserList: TList;
      pyBattleList: TList;
      pyGroupList: TList;
      pyMods: PPyObject;
      pyMaps: PPyObject;
      pyUsers: PPyObject;
      pyBattles: PPyObject;
      pyReplays: PPyObject;
      pyGroups: PPyObject;
      pyCurrentBattle: PPyObject;
      pyServers: PPyObject;
      CS: TCriticalSection;
      tstate: PPyThreadState;

    protected
      function GetPyBattle(Battle: TBattle): PPyObject;
      function GetPyReplay(Replay: TReplay): PPyObject;
      function GetPyReplayPlayer(ReplayPlayer: TReplayPlayer): PPyObject;
      function GetPyUser(user: TClient): PPyObject;
      function GetPyGroup(group: TClientGroup): PPyObject;
      procedure RefreshPythonLists;
      procedure LockCallback;
      procedure UnlockCallback;



    public
      procedure ClearRefs;
      
      // tasclient special functions
      procedure ShowDebugWindow;
      procedure Print(data : string);
      function GetVersion:String;
      function GetSettings: Variant;
      function SetSettings(newSettings: Variant): Boolean;

      // official api
      procedure ExitLobby;
      procedure SocketConnect(adress: string; port: integer);
      procedure PerformConnected;
      procedure PerformDisconnected;
      procedure Disconnect;
      procedure LoadScripts;
      procedure ReloadScripts;
      procedure ReloadScript(name: WideString);
      procedure SendProtocol(data: WideString);
      procedure HandleProtocol(data: WideString);
      procedure ProcessCommand(command: WideString; fromBattleScreen: Boolean);
      function GetUsers: Variant;
      function GetMyUser: Variant;
      function GetBattles: Variant;
      function GetReplays: Variant;
      function GetGroups: Variant;
      procedure SetGroups(gV : Variant);
      function GetMaps: Variant;
      function GetMods: Variant;
      function HostBattle(nbPlayers: integer; RankLimit: Integer; ModName: string; Description: string; Password: string; UDPHostPort: integer; NatTraversal: integer) : Boolean;
      function HostReplay(replayFile: string; nbPlayers: integer; RankLimit: Integer; Description: string; Password: string; UDPHostPort: integer; NatTraversal: integer) : Boolean;
      function JoinBattle(battleId: integer; Password: String; spectator: Boolean) : Boolean;
      procedure LeaveBattle;
      function StartBattle: Boolean;
      function SetMyReadyStatus(b: Boolean): Boolean;
      procedure SetMyBattleStatus(spec: boolean);
      function GetCurrentBattle: Variant;
      function GetServers: Variant;
      procedure SetServers(sV : Variant);
      function ChangeMap(mapName: string): Boolean;
      function GetSpringExe: String;

      // spring downloader api
      procedure DownloadMap(mapName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
      procedure DownloadMap2(mapName: string; callbackArgs: Variant; callbackFunction: Variant);
      procedure DownloadMod(modName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
      procedure DownloadMod2(modName: string; callbackArgs: Variant; callbackFunction: Variant);
      procedure DownloadRapid(rapidName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
      procedure DownloadRapid2(rapidName: string; callbackArgs: Variant; callbackFunction: Variant);
      procedure DownloadEngine(engineName: string; engineVersion: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
      procedure DownloadEngine2(engineName: string; engineVersion: string; callbackArgs: Variant; callbackFunction: Variant);
      procedure ListRapidTags(callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
      procedure ListRapidTags2(callbackArgs: Variant; callbackFunction: Variant);

      // widget db api
      procedure RefreshWidgetList;
      function GetWidgets: Variant;
      function InstallOrUpdateWidget(id: integer): boolean;
      function UninstallWidget(id: integer): boolean;

      // Must not be called from python
      procedure DownloadCallbackEvent(snc: PScriptDownloadCallback;progress: integer);

      constructor Create;
      destructor Destroy;
  end;

  TFileDownloadInfo = record
    name: string;
    engineName: string;
    engineVersion: string;
    params: PScriptDownloadCallback;
    cb: TCallBack;
  end;
  PFileDownloadInfo = ^TFileDownloadInfo;

  {$METHODINFO OFF}

  TPyCallback = class(TPyDelphiPersistent)
    // Constructors & Destructors
    constructor Create( APythonType : TPythonType ); override;
    constructor CreateWith( PythonType : TPythonType; args : PPyObject ); override;
    // Basic services
    function  Repr : PPyObject; override;

    class function  DelphiObjectClass : TClass; override;
  end;

  TPyGUI = class(TPyDelphiPersistent)
    // Constructors & Destructors
    constructor Create( APythonType : TPythonType ); override;
    constructor CreateWith( PythonType : TPythonType; args : PPyObject ); override;
    // Basic services
    function  Repr : PPyObject; override;

    class function  DelphiObjectClass : TClass; override;
  end;

  TScriptThread = class(TPythonThread)
  private
    functionName: string;
    tuple: TStrings;

  protected
    procedure ExecuteWithPython; override;

  public
    constructor Create(fName: string; tup: Variant);
  end;

  function AcquireMainThread:boolean;
  function ReleaseMainThread: Boolean;
  procedure PyDict_SetItemStringDecRef(dp: PPyObject; Key: PAnsiChar; const V : Variant);
  function PyListFromStrings(sl: TStrings):PPyObject;
  function PyListFromWideStrings(sl: TWideStrings):PPyObject;
  procedure PyDict_SetItemDecRef(dp: PPyObject; Key: PPyObject; const V : Variant);
  procedure PyList_AppendDecRef(list: PPyObject; const item : Variant);
  procedure PyDict_SetItemStringIncRef(dp: PPyObject; Key: PAnsiChar; o : PPyObject);
  procedure PyDict_SetItemIncRef(dp: PPyObject; Key: PPyObject; o : PPyObject);
  function PyDict_GetVariantItemString(dict: PPyObject; key: PAnsiChar; defaultValue: Variant): Variant;
  procedure SafeDecRef(var o : PPyObject);
  procedure PostMsgs;
  procedure HostBattle;
  procedure JoinBattle;
  procedure ChangeMap;
  procedure StartDownloads;
  function GetComponentFromString(component: string): TComponent;
  function GetStringFromComponent(component : TComponent): string;
  procedure DebugPrint(s: string);
  procedure GUISynchronizedUpdate(ucb: PGUIUpdateCallback);
  procedure ExecuteNextWidgetAction;

var
  MainThreadState: PPyThreadState;
  MainInterpreterState: PPyInterpreterState;
  ScriptHostingRunning: Boolean;
  ScriptHostingReplayRunning: Boolean;
  ScriptJoining: Boolean;
  ScriptStart: Boolean;
  StartBattleSuccess: Boolean;
  MsgList: TStringList;
  MsgColor: TIntegerList;
  RichEditList: TList;
  MainThreadFocused: Boolean;
  JoinBattleId: integer;
  JoinBattlePassword: string;
  JoinBattleSpectator: Boolean;
  NotificationTempList: TList;
  ScriptsInitialized: Boolean = False;
  ChangeMapIndex: integer;
  MapDownloadList: TList;
  ModDownloadList: TList;
  RapidDownloadList: TList;
  EngineDownloadList: TList;
  InstallWidgetIds: TIntegerList;
  UninstallWidgetIds: TIntegerList;
  RefreshWidgetListAction: Boolean;
  GUICS: TCriticalSection;
  

  PlayerIconTypeNames: TStringList;
  PlayerIconTypeIcons: TList;
  PlayerIconTypeIconsNames: TList;
implementation

uses PythonScriptDebugFormUnit, Utility, MapListFormUnit, HostBattleFormUnit,
BattleFormUnit, ReplaysUnit, PreferencesFormUnit, CustomizeGUIFormUnit,
TypInfo, SpringDownloaderFormUnit, StdCtrls, SpringSettingsProfileFormUnit,
PerformFormUnit, HighlightingUnit, NotificationsUnit,WidgetDBFormUnit,
gnugettext;


//------------------------------------------------------------------------------------------------------
//    TCallback
//------------------------------------------------------------------------------------------------------

constructor TCallback.Create;
begin
  with GetPythonEngine do
  begin
    {pyGroups := Py_None;
    pyBattles := Py_None;
    pyUsers := Py_None;
    pyMods := Py_None;
    pyMaps := Py_None;
    pyCurrentBattle := Py_None;
    pyReplays := Py_None;
    pyServers := Py_None;}
    pyGroups := nil;
    pyBattles := nil;
    pyUsers := nil;
    pyMods := nil;
    pyMaps := nil;
    pyCurrentBattle := nil;
    pyReplays := nil;
    pyServers := nil;

    pyUserList := TList.Create;
    pyBattleList := TList.Create;
    pyGroupList := TList.Create;
    userRefCountList := TIntegerList.Create;
    CS := TCriticalSection.Create;
  end;
end;

destructor TCallback.Destroy;
var
  i,j: integer;
begin
  with GetPythonEngine do
  begin
    for i:=0 to pyUserList.Count-1 do
      for j:=1 to userRefCountList.Items[i] do
        Py_XDECREF(pyUserList[i]);

    for i:=0 to pyBattleList.Count-1 do
      Py_XDECREF(pyBattleList[i]);

    for i:=0 to pyGroupList.Count-1 do
      Py_XDECREF(pyGroupList[i]);

    pyUserList.Clear;
    pyBattleList.Clear;
    pyGroupList.Clear;
    userRefCountList.Clear;

    ClearRefs;
  end;

  inherited;
end;

procedure TCallback.ShowDebugWindow;
begin
  PythonScriptDebugForm.Show;
end;

function TCallback.GetVersion:String;
begin
  Result := VERSION_NUMBER+'.'+IntToStr(Misc.GetLobbyRevision);
end;

procedure TCallback.ExitLobby;
begin
  try
    MainForm.Close;
  except
    on E:Exception do
      Print(E.Message);
  end;
end;

procedure TCallback.Disconnect;
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  try
    MainForm.TryToDisconnect;
  except
    on E:Exception do
      Print(E.Message);
  end;
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.SocketConnect(adress: string; port: integer);
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  MainForm.TryToConnect(adress,IntToStr(port),true);
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.PerformConnected;
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  MainForm.SocketSessionConnected(nil,0);
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.PerformDisconnected;
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  MainForm.SocketChangeState(nil,wsConnected,wsClosed);
  if mtReleased then
    AcquireMainThread;
end;


procedure TCallback.LoadScripts;
begin
  AcquireMainThread;
  try handlers._load; except end;
  ReleaseMainThread;
end;
procedure TCallback.ReloadScripts;
begin
  AcquireMainThread;
  try handlers._reloadall; except end;
  ReleaseMainThread;
end;
procedure TCallback.ReloadScript(name: WideString);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers._reload(name); except end;
  ReleaseMainThread;
end;
procedure TCallback.SendProtocol(data: WideString);
var
  mtReleased: Boolean;
  i:integer;
begin
  i := Pos(' ',data);
  mtReleased := ReleaseMainThread;
  try
    MainForm.TryToSendCommand(LeftStr(data,i-1),MidStr(data,i+1,9999999));
  except
    on E:Exception do
      Print(E.Message);
  end;
  if mtReleased then
    AcquireMainThread;
end;
procedure TCallback.HandleProtocol(data: WideString);
var
  mtReleased: Boolean;
begin
  if Status.ConnectionState <> Connected then Exit;
  mtReleased := ReleaseMainThread;
  Status.TimeOfLastDataReceived := GetTickCount;
  try
    MainForm.ProcessRemoteCommand(data);
  except
    on E:Exception do
      Print(E.Message);
  end;
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.ProcessCommand(command: WideString; fromBattleScreen: Boolean);
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  try
    MainForm.ProcessCommand(command,fromBattleScreen);
  except
    on E:Exception do
      Print(E.Message);
  end;
  if mtReleased then
    AcquireMainThread; 
end;

{procedure TCallback.NewThread(functionName: String;tuple: Variant);
begin
    TScriptThread.Create(functionName, tuple);
end;}

procedure TCallback.Print(data : string);
begin
  PythonScriptDebugFormUnit.printList.BeginUpdate;
  PythonScriptDebugFormUnit.printList.Add(data);
  PythonScriptDebugFormUnit.printList.EndUpdate;
  PostMessage(PythonScriptDebugForm.Handle, WM_REFRESHOUTPUT, 0, 0);
end;

procedure TCallback.RefreshPythonLists;
var
  i,j,k: integer;
  battleClients: PPyObject;
  groupUsers: PPyObject;
begin
  with GetPythonEngine do
  begin
    // make the python user list
    for i:=0 to AllClients.Count-1 do
    begin
      pyUserList.Add(GetPyUser(TClient(AllClients[i])));
      userRefCountList.Add(1);
    end;

    // make the python battle list
    for i:=0 to Battles.Count-1 do
      pyBattleList.Add(GetPyBattle(TBattle(Battles[i])));

    // make the python group list
    for i:=0 to ClientGroups.Count-1 do
      pyGroupList.Add(GetPyGroup(TClientGroup(ClientGroups[i])));

    // add battle to users
    for i:=0 to pyUserList.Count-1 do
      with TClient(AllClients[i]) do
        if InBattle then
        begin
          j := GetBattleId;

          PyDict_SetItemString(PPyObject(pyUserList[i]),'Battle',PPyObject(pyBattleList[MainForm.GetBattleIndex(j)]));
        end;

    // add groups to users
    for i:=0 to pyUserList.Count-1 do
      with TClient(AllClients[i]) do
        if GetGroup <> nil then
        begin
          j := ClientGroups.IndexOf(GetGroup);

          PyDict_SetItemString(PPyObject(pyUserList[i]),'Group',PPyObject(pyGroupList[j]));
        end;

    // add users to battles
    for i:=0 to pyBattleList.Count-1 do
      with TBattle(Battles[i]) do
      begin
        battleClients := PyDict_New();
        for j:= 0 to Clients.Count-1 do
        begin
          k := MainForm.GetClientIndexEx(TClient(Clients[j]).Name,AllClients);

          PyDict_SetItemString(battleClients,PChar(WideCharToString(PWideChar(TClient(Clients[j]).Name))),PPyObject(pyUserList[k]));
          userRefCountList.Items[k] := userRefCountList.Items[k]+1;
        end;
        PyDict_SetItemString(PPyObject(pyBattleList[i]),'Users',battleClients);
        Py_XDECREF(battleClients);

        k := MainForm.GetClientIndexEx(TClient(Clients[0]).Name,AllClients);
        PyDict_SetItemString(PPyObject(pyBattleList[i]),'Hoster',PPyObject(pyUserList[k]));
        userRefCountList.Items[k] := userRefCountList.Items[k]+1;
      end;

    // add users to groups
    for i:=0 to ClientGroups.Count-1 do
      with TClientGroup(ClientGroups[i]) do
      begin
        groupUsers := PyDict_New();
        for j:= 0 to Clients.Count-1 do
        begin
          k := MainForm.GetClientIndexEx(Clients[j],AllClients);

          if k = -1 then
            PyDict_SetItemStringDecRef(groupUsers,Pchar(Clients[j]),'Not connected')
          else
          begin
            PyDict_SetItemString(groupUsers,Pchar(Clients[j]),PPyObject(pyUserList[k]));
            userRefCountList.Items[k] := userRefCountList.Items[k]+1;
          end;
        end;
        PyDict_SetItemString(PPyObject(pyGroupList[i]),'Users',groupUsers);
        Py_XDECREF(groupUsers);
      end;
  end;
end;

function TCallback.GetMyUser: Variant;
begin
  Result := GetPythonEngine.PyObjectAsVariant(GetPyUser(Status.Me));
end;

function TCallback.GetUsers: Variant;
var
  i: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyUsers := PyDict_New();

    RefreshPythonLists;

    for i:=0 to AllClients.Count-1 do
      PyDict_SetItemString(pyUsers,PChar(String(TClient(AllClients[i]).Name)),PPyObject(pyUserList[i]));

    Result := PyObjectAsVariant(pyUsers);
  end;
  UnlockCallback;
end;

function TCallback.GetCurrentBattle: Variant;
var
  i,j: integer;
  pyO: PPyObject;
  pyO2: PPyObject;
  pyO3: PPyObject;
  pyO4: PPyObject;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    if (BattleState.Status = None) or (not BattleState.JoiningComplete) then
    begin
      UnlockCallback;
      Exit;
    end;
    ClearRefs;
    pyCurrentBattle := PyDict_New();

    RefreshPythonLists;

    PyDict_SetItemString(pyCurrentBattle,'Battle',pyBattleList[MainForm.GetBattleIndex(BattleState.Battle.ID)]);
    PyDict_SetItemStringDecRef(pyCurrentBattle,'GameEndCondition',BattleForm.GameEndRadioGroup.ItemIndex);
    PyDict_SetItemStringDecRef(pyCurrentBattle,'StartPosMode',BattleForm.StartPosRadioGroup.ItemIndex);
    PyDict_SetItemStringDecRef(pyCurrentBattle,'StartMetal',BattleForm.MetalTracker.Position);
    PyDict_SetItemStringDecRef(pyCurrentBattle,'StartEnergy',BattleForm.EnergyTracker.Position);
    PyDict_SetItemStringDecRef(pyCurrentBattle,'MaxUnits',BattleForm.UnitsTracker.Position);

    pyO := StringsToPyList(BattleState.DisabledUnits);
    PyDict_SetItemString(pyCurrentBattle,'DisabledUnits',pyO);
    Py_XDECREF(pyO);

    pyO := PyDict_New();
    for i:=0 to Length(BattleState.StartRects)-1 do
    begin
      pyO2 := PyDict_New();
      PyDict_SetItemStringDecRef(pyO2,'Enabled',BattleState.StartRects[i].Enabled);
      PyDict_SetItemStringDecRef(pyO2,'Left',BattleState.StartRects[i].Rect.Left);
      PyDict_SetItemStringDecRef(pyO2,'Right',BattleState.StartRects[i].Rect.Right);
      PyDict_SetItemStringDecRef(pyO2,'Bottom',BattleState.StartRects[i].Rect.Bottom);
      PyDict_SetItemStringDecRef(pyO2,'Top',BattleState.StartRects[i].Rect.Top);
      PyDict_SetItem(pyO,PyInt_FromLong(i),pyO2);
      Py_XDECREF(pyO2);
    end;
    PyDict_SetItemString(pyCurrentBattle,'Boxes',pyO);
    Py_XDECREF(pyO);

    pyO := PyDict_New();
    for i:=0 to BattleForm.ModOptionsList.Count-1 do
    begin
      pyO2 := PyDict_New();
      PyDict_SetItemStringDecRef(pyO2,'Name',TLuaOption(BattleForm.ModOptionsList[i]).Name);
      PyDict_SetItemStringDecRef(pyO2,'Type',TLuaOption(BattleForm.ModOptionsList[i]).ClassName);
      if TLuaOption(BattleForm.ModOptionsList[i]) is TLuaOptionList then
      begin
        pyO3 := PyDict_New();
        for j:=0 to TLuaOptionList(BattleForm.ModOptionsList[i]).KeyList.Count-1 do
        begin
          pyO4 := PyDict_New();
          PyDict_SetItemStringDecRef(pyO4,'Name',TLuaOptionList(BattleForm.ModOptionsList[i]).NameList[j]);
          PyDict_SetItemStringDecRef(pyO4,'Description',TLuaOptionList(BattleForm.ModOptionsList[i]).DescriptionList[j]);
          PyDict_SetItemString(pyO3,PChar(TLuaOptionList(BattleForm.ModOptionsList[i]).KeyList[j]),pyO4);
          Py_XDECREF(pyO4);
        end;
        PyDict_SetItemString(pyO2,'Items',pyO3);
        Py_XDECREF(pyO3);
      end;
      PyDict_SetItemStringDecRef(pyO2,'Value',TLuaOption(BattleForm.ModOptionsList[i]).Value);
      PyDict_SetItemStringDecRef(pyO2,'DefaultValue',TLuaOption(BattleForm.ModOptionsList[i]).DefaultValue);
      PyDict_SetItemStringDecRef(pyO2,'Description',TLuaOption(BattleForm.ModOptionsList[i]).Description);
      PyDict_SetItemString(pyO,PChar(TLuaOption(BattleForm.ModOptionsList[i]).Key),pyO2);
      Py_XDECREF(pyO2);
    end;
    PyDict_SetItemString(pyCurrentBattle,'ModOptions',pyO);
    Py_XDECREF(pyO);

    pyO := PyDict_New();
    for i:=0 to BattleForm.MapOptionsList.Count-1 do
    begin
      pyO2 := PyDict_New();
      PyDict_SetItemStringDecRef(pyO2,'Name',TLuaOption(BattleForm.MapOptionsList[i]).Name);
      PyDict_SetItemStringDecRef(pyO2,'Type',TLuaOption(BattleForm.MapOptionsList[i]).ClassName);
      if TLuaOption(BattleForm.MapOptionsList[i]) is TLuaOptionList then
      begin
        pyO3 := PyDict_New();
        for j:=0 to TLuaOptionList(BattleForm.MapOptionsList[i]).KeyList.Count-1 do
        begin
          pyO4 := PyDict_New();
          PyDict_SetItemStringDecRef(pyO4,'Name',TLuaOptionList(BattleForm.MapOptionsList[i]).NameList[j]);
          PyDict_SetItemStringDecRef(pyO4,'Description',TLuaOptionList(BattleForm.MapOptionsList[i]).DescriptionList[j]);
          PyDict_SetItemString(pyO3,PChar(TLuaOptionList(BattleForm.MapOptionsList[i]).KeyList[j]),pyO4);
          Py_XDECREF(pyO4);
        end;
        PyDict_SetItemString(pyO2,'Items',pyO3);
        Py_XDECREF(pyO3);
      end;
      PyDict_SetItemStringDecRef(pyO2,'Value',TLuaOption(BattleForm.MapOptionsList[i]).Value);
      PyDict_SetItemStringDecRef(pyO2,'DefaultValue',TLuaOption(BattleForm.MapOptionsList[i]).DefaultValue);
      PyDict_SetItemStringDecRef(pyO2,'Description',TLuaOption(BattleForm.MapOptionsList[i]).Description);
      PyDict_SetItemString(pyO,PChar(TLuaOption(BattleForm.MapOptionsList[i]).Key),pyO2);
      Py_XDECREF(pyO2);
    end;
    PyDict_SetItemString(pyCurrentBattle,'MapOptions',pyO);
    Py_XDECREF(pyO);

    Result := PyObjectAsVariant(pyCurrentBattle);
  end;
  UnlockCallback;
end;

function TCallback.GetPyUser(user: TClient): PPyObject;
var
  pyNameHistory: PPyObject;
begin
  with GetPythonEngine do
  begin
    with user do
    begin
      Result := PyDict_New();

      PyDict_SetItemStringDecRef( Result, 'Id', Id );
      PyDict_SetItemStringDecRef( Result, 'Name', Name );
      PyDict_SetItemStringDecRef( Result, 'DisplayName', DisplayName );
      PyDict_SetItemStringDecRef( Result, 'Status', Status );
      PyDict_SetItemStringDecRef( Result, 'BattleStatus', BattleStatus );
      PyDict_SetItemStringDecRef( Result, 'TeamColor', TeamColor );
      PyDict_SetItemStringDecRef( Result, 'InBattle', InBattle );
      PyDict_SetItemStringDecRef( Result, 'Country', MainForm.GetCountryName(Country) );
      PyDict_SetItemStringDecRef( Result, 'CountryCode', Country );
      PyDict_SetItemStringDecRef( Result, 'CPU', CPU );
      PyDict_SetItemStringDecRef( Result, 'IP', IP );
      PyDict_SetItemStringDecRef( Result, 'PublicPort', PublicPort );
      PyDict_SetItemStringDecRef( Result, 'Rank', GetRank );
      PyDict_SetItemStringDecRef( Result, 'BattleId', GetBattleId );
      PyDict_SetItemStringDecRef( Result, 'TeamNo', GetTeamNo );
      PyDict_SetItemStringDecRef( Result, 'AllyNo', GetAllyNo );
      PyDict_SetItemStringDecRef( Result, 'Mode', GetMode );
      PyDict_SetItemStringDecRef( Result, 'Sync', GetSync );
      PyDict_SetItemStringDecRef( Result, 'Handicap', GetHandicap );
      PyDict_SetItemStringDecRef( Result, 'ReadyStatus', GetReadyStatus );
      PyDict_SetItemStringDecRef( Result, 'Side', GetSide );
      PyDict_SetItemStringDecRef( Result, 'InGameStatus', GetInGameStatus );
      PyDict_SetItemStringDecRef( Result, 'AwayStatus', GetAwayStatus );
      PyDict_SetItemStringDecRef( Result, 'Ignored', isIgnored );
      PyDict_SetItemStringDecRef( Result, 'Renamed', isRenamed );
      pyNameHistory := PyListFromWideStrings(NameHistory);
      PyDict_SetItemString( Result, 'NameHistory', pyNameHistory);
      Py_XDECREF(pyNameHistory);
    end;
  end;
end;

function TCallback.GetPyBattle(Battle: TBattle): PPyObject;
begin
  with GetPythonEngine do
  begin
    with Battle do
    begin
      Result := PyDict_New();

      PyDict_SetItemStringDecRef( Result, 'Id', ID );
      PyDict_SetItemStringDecRef( Result, 'BattleType', BattleType );
      PyDict_SetItemStringDecRef( Result, 'NATType', NATType );
      PyDict_SetItemStringDecRef( Result, 'RankLimit', RankLimit );
      PyDict_SetItemStringDecRef( Result, 'Visible', Visible );
      PyDict_SetItemStringDecRef( Result, 'Description', Description );
      PyDict_SetItemStringDecRef( Result, 'Map', Map );
      PyDict_SetItemStringDecRef( Result, 'MapHash', MapHash );
      PyDict_SetItemStringDecRef( Result, 'SpectatorCount', SpectatorCount );
      PyDict_SetItemStringDecRef( Result, 'Password', Password );
      PyDict_SetItemStringDecRef( Result, 'IP', IP );
      PyDict_SetItemStringDecRef( Result, 'Port', Port );
      PyDict_SetItemStringDecRef( Result, 'MaxPlayers', MaxPlayers );
      PyDict_SetItemStringDecRef( Result, 'ModName', ModName );
      PyDict_SetItemStringDecRef( Result, 'HashCode', HashCode );
      PyDict_SetItemStringDecRef( Result, 'Locked', Locked );
      PyDict_SetItemStringDecRef( Result, 'ScriptVisible', ForcedHidden );
    end;
  end;
end;

function TCallback.GetPyReplay(Replay: TReplay): PPyObject;
var
  scriptPlayer: PPyObject;
  luaoptions: PPyObject;
  sl: TStrings;
  i: integer;
  pyO: PPyObject;
begin
  Result := nil;
  with GetPythonEngine do
  begin
    if not Replay.Script.isCorrupted then
    begin
      with Replay do
      begin
        Result := PyDict_New();

        PyDict_SetItemStringDecRef( Result, 'FileName', FileName );
        PyDict_SetItemStringDecRef( Result, 'Grade', Grade );
        PyDict_SetItemStringDecRef( Result, 'Version', Version );
        PyDict_SetItemStringDecRef( Result, 'SpringVersion', SpringVersion );
        PyDict_SetItemStringDecRef( Result, 'FullFileName', FullFileName );
        PyDict_SetItemStringDecRef( Result, 'Date', Date );
        if Version > 0 then
        begin
          PyDict_SetItemStringDecRef( Result, 'GameLength', demoHeader.gameTime );
          PyDict_SetItemStringDecRef( Result, 'WallclockLength', demoHeader.wallclockTime );
          PyDict_SetItemStringDecRef( Result, 'UnixTime', demoHeader.unixTime );
          PyDict_SetItemStringDecRef( Result, 'MaxPlayers', demoHeader.maxPlayerNum );
          PyDict_SetItemStringDecRef( Result, 'WinningTeam', demoHeader.winningAllyTeam );
        end;
        PyDict_SetItemStringDecRef( Result, 'MapName', Script.ReadMapName );
        PyDict_SetItemStringDecRef( Result, 'ModName', Script.ReadModName );
        PyDict_SetItemStringDecRef( Result, 'StartPosType', Script.ReadStartPosType );
        {PyDict_SetItemStringDecRef( Result, 'GameMode', Script.ReadGameMode );
        PyDict_SetItemStringDecRef( Result, 'StartMetal', Script.ReadStartMetal );
        PyDict_SetItemStringDecRef( Result, 'StartEnergy', Script.ReadStartEnergy );
        PyDict_SetItemStringDecRef( Result, 'MaxUnits', Script.ReadMaxUnits );
        PyDict_SetItemStringDecRef( Result, 'LimitDGun', Script.ReadLimitDGun );
        PyDict_SetItemStringDecRef( Result, 'DiminishingMMs', Script.ReadDiminishingMMs );
        PyDict_SetItemStringDecRef( Result, 'GhostedBuildings', Script.ReadGhostedBuildings ); }

        scriptPlayer := PyDict_New();
        for i:=0 to PlayerList.Count-1 do
        begin
          pyO := GetPyReplayPlayer(TReplayPlayer(PlayerList[i]^));
          PyDict_SetItemString(scriptPlayer, PChar(TReplayPlayer(PlayerList[i]^).UserName), pyO);
          Py_XDECREF(pyO);
        end;
        PyDict_SetItemString( Result, 'Users',  scriptPlayer);
        Py_XDECREF(scriptPlayer);

        luaoptions := PyDict_New();
        sl := Replay.Script.GetSubKeys('GAME/MODOPTIONS');
        for i:=0 to sl.Count-1 do
        begin
          PyDict_SetItemStringDecRef( luaoptions, PChar(sl[i]), Replay.Script.ReadKeyValue('GAME/MODOPTIONS/'+sl[i]) );
        end;
        PyDict_SetItemString( Result, 'ModOptions',  luaoptions);
        Py_XDECREF(luaoptions);

        luaoptions := PyDict_New();
        sl := Replay.Script.GetSubKeys('GAME/MAPOPTIONS');
        for i:=0 to sl.Count-1 do
        begin
          PyDict_SetItemStringDecRef( luaoptions, PChar(sl[i]), Replay.Script.ReadKeyValue('GAME/MAPOPTIONS/'+sl[i]) );
        end;
        PyDict_SetItemString( Result, 'MapOptions',  luaoptions);
        Py_XDECREF(luaoptions);

      end;
    end;
  end;
end;

function TCallback.GetPyReplayPlayer(ReplayPlayer: TReplayPlayer): PPyObject;
begin
  with GetPythonEngine do
  begin
    with ReplayPlayer do
    begin
      Result := PyDict_New();

      PyDict_SetItemStringDecRef( Result, 'UserName', UserName );
      PyDict_SetItemStringDecRef( Result, 'Rank', Rank );
      PyDict_SetItemStringDecRef( Result, 'CountryCode', CountryCode );
      PyDict_SetItemStringDecRef( Result, 'Id', Id );
      PyDict_SetItemStringDecRef( Result, 'Team', Team );
      PyDict_SetItemStringDecRef( Result, 'Color', Color );
      PyDict_SetItemStringDecRef( Result, 'Spectator', Spectator );

      // stats
      PyDict_SetItemStringDecRef( Result, 'MousePixels', Stats.mousePixels );
      PyDict_SetItemStringDecRef( Result, 'MouseClicks', Stats.mouseClicks );
      PyDict_SetItemStringDecRef( Result, 'KeyPresses', Stats.keyPresses );
      PyDict_SetItemStringDecRef( Result, 'NumCommands', Stats.numCommands );
      PyDict_SetItemStringDecRef( Result, 'UnitCommands', Stats.unitCommands );
    end;
  end;
end;

function TCallback.GetPyGroup(group: TClientGroup): PPyObject;
begin
  with GetPythonEngine do
  begin
    with group do
    begin
      Result := PyDict_New();

      PyDict_SetItemStringDecRef( Result, 'Name', Name );
      PyDict_SetItemStringDecRef( Result, 'EnableColor', EnableColor );
      PyDict_SetItemStringDecRef( Result, 'Color', Color );
      PyDict_SetItemStringDecRef( Result, 'AutoKick', AutoKick );
      PyDict_SetItemStringDecRef( Result, 'AutoSpec', AutoSpec );
      PyDict_SetItemStringDecRef( Result, 'NotifyOnHost', NotifyOnHost );
      PyDict_SetItemStringDecRef( Result, 'NotifyOnJoin', NotifyOnJoin );
      PyDict_SetItemStringDecRef( Result, 'NotifyOnBattleEnd', NotifyOnBattleEnd );
      PyDict_SetItemStringDecRef( Result, 'NotifyOnConnect', NotifyOnConnect );
      PyDict_SetItemStringDecRef( Result, 'HighlightBattles', HighlightBattles );
      PyDict_SetItemStringDecRef( Result, 'ChatColor', ChatColor );
      PyDict_SetItemStringDecRef( Result, 'ReplaceRank', ReplaceRank );
      PyDict_SetItemStringDecRef( Result, 'Rank', Rank );
      PyDict_SetItemStringDecRef( Result, 'BalanceInSameTeam', BalanceInSameTeam );
      PyDict_SetItemStringDecRef( Result, 'Ignore', Ignore );
      PyDict_SetItemStringDecRef( Result, 'ExecuteSpecialCommands', ExecuteSpecialCommands );
    end;
  end;
end;

function TCallback.GetReplays: Variant;
var
  i: integer;
  pyO: PPyObject;
begin
  if ReplaysForm.LoadingPanel.Visible then Exit;

  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyReplays := PyDict_New();
    for i:=0 to ReplayList.Count-1 do
    begin
      try
        pyO := GetPyReplay(TReplay(ReplayList[i]));
        if pyO <> nil then
        begin
          PyDict_SetItem(pyReplays,PyInt_FromLong(i),pyO);
          Py_XDECREF(pyO);
        end;
      except
        MainForm.AddMainLog(TReplay(ReplayList[i]).FileName,Colors.Normal);
        pyO := GetPyReplay(TReplay(ReplayList[i]));
      end;
    end;
    Result := PyObjectAsVariant(pyReplays);
  end;
  UnlockCallback;
end;

function TCallback.GetBattles: Variant;
var
  i: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyBattles := PyDict_New();

    RefreshPythonLists;

    for i:=0 to Battles.Count-1 do
      PyDict_SetItem(pyBattles,PyInt_FromLong(TBattle(Battles[i]).Id),PPyObject(pyBattleList[i]));

    Result := PyObjectAsVariant(pyBattles);
  end;
  UnlockCallback;
end;

procedure TCallback.LockCallback;
begin
  CS.Enter;
end;
procedure TCallback.UnlockCallback;
begin
  CS.Leave;
end;

procedure TCallback.DownloadCallbackEvent(snc: PScriptDownloadCallback;progress: integer);
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    PyList_SetItem(snc.args,0,PyLong_FromLong(progress));
    if EvalPyFunction(snc.func,PyList_AsTuple(snc.args)) then
      TSpringDownloaderForm(snc.form).CancelButtonClick(nil);
  end;
  ReleaseMainThread;
end;

procedure TCallback.ClearRefs;
var
  i,j: integer;
begin
  with GetPythonEngine do
  begin
    for i:=0 to pyGroupList.Count-1 do
      Py_XDECREF(pyGroupList[i]);

    for i:=0 to pyBattleList.Count-1 do
      Py_XDECREF(pyBattleList[i]);

    for i:=0 to pyUserList.Count-1 do
      Py_XDECREF(pyUserList[i]);
      //for j:=1 to userRefCountList.Items[i] do
      //  Py_XDECREF(pyUserList[i]);

    pyUserList.Clear;
    pyBattleList.Clear;
    pyGroupList.Clear;
    userRefCountList.Clear;
  end;
  SafeDecRef(pyGroups);
  SafeDecRef(pyBattles);
  SafeDecRef(pyUsers);
  SafeDecRef(pyMods);
  SafeDecRef(pyMaps);
  SafeDecRef(pyCurrentBattle);
  SafeDecRef(pyReplays);
  SafeDecRef(pyServers);
end;

procedure TGUI.ClearRefs;
begin
  SafeDecRef(pyProperties);
  SafeDecRef(pyTextBoxes);
end;

function TCallback.GetGroups: Variant;
var
  i: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyGroups := PyDict_New();

    RefreshPythonLists;

    for i:=0 to pyGroupList.Count-1 do
      PyDict_SetItemString(pyGroups,PChar(TClientGroup(ClientGroups[i]).Name),PPyObject(pyGroupList[i]));

    Result := PyObjectAsVariant(pyGroups);
  end;
  UnlockCallback;
end;

procedure TCallback.SetGroups(gV : Variant);
var
  groupsDict : PPyObject;
  keys : PPyObject;
  key : PPyObject;
  groupName : string;
  i,j: integer;
  group : PPyObject;
  cg : TClientGroup;
  groupUsers : PPyObject;
  groupUsersSL : TStringList;
  tmpCGList : TList;
begin
  with GetPythonEngine do
  begin
    groupsDict := VariantAsPyObject(gV);
    if not PyDict_Check(groupsDict) then
    begin
      Print('SetGroups error : first parameter is not a valid python dictionary.');
      Exit;
    end;

    keys := PyDict_Keys(groupsDict);
    groupUsersSL := TStringList.Create;
    tmpCGList := TList.Create;

    for i:=0 to PyDict_Size(groupsDict)-1 do
    begin
      key := PyList_GetItem(keys,i);
      groupName := PyObjectAsString(key);
      group := PyDict_GetItem(groupsDict,key);
      cg := TClientGroup.Create(groupName,0);

      cg.EnableColor := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('EnableColor'))));
      cg.Color := PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('Color')));
      cg.AutoKick := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('AutoKick'))));
      cg.AutoSpec := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('AutoSpec'))));
      cg.NotifyOnHost := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('NotifyOnHost'))));
      cg.NotifyOnJoin := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('NotifyOnJoin'))));
      cg.NotifyOnBattleEnd := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('NotifyOnBattleEnd'))));
      cg.NotifyOnConnect := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('NotifyOnConnect'))));
      cg.HighlightBattles := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('HighlightBattles'))));
      cg.ChatColor := PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('ChatColor')));
      cg.ReplaceRank := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('ReplaceRank'))));
      cg.Rank := PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('Rank')));
      cg.BalanceInSameTeam := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('BalanceInSameTeam'))));
      cg.Ignore := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('Ignore'))));
      cg.ExecuteSpecialCommands := IntToBool(PyInt_AsLong(PyDict_GetItem(group,PyString_FromString('ExecuteSpecialCommands'))));

      groupUsers := PyDict_GetItem(group,PyString_FromString('Users'));
      if not PyDict_Check(groupUsers) and not PyList_Check(groupUsers) then
      begin
        Print('SetGroups error : '+groupName+'''s ''Users'' is not a valid python dictionary or list.');
        Exit;
      end;
      if PyDict_Check(groupUsers) then
        PyListToStrings(PyDict_Keys(groupUsers),groupUsersSL)
      else
        PyListToStrings(groupUsers,groupUsersSL);

      for j:=0 to groupUsersSL.Count-1 do
        cg.AddClient(groupUsersSL[j]);

      tmpCGList.Add(cg);
    end;

    ClientGroups.Clear;
    ClientGroups.Assign(tmpCGList);
    tmpCGList.Clear;
  end;
end;

function TCallback.GetServers: Variant;
var
  i: integer;
  pyO: PPyObject;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyServers := PyList_New(0);

    for i:=0 to High(ServerList) do
    begin
      pyO := PyDict_New();
      PyDict_SetItemStringDecRef( pyO, 'Name', ServerList[i].Name );
      PyDict_SetItemStringDecRef( pyO, 'Address', ServerList[i].Address );
      PyDict_SetItemStringDecRef( pyO, 'Port', ServerList[i].Port );

      PyList_Append(pyServers,pyO);
      Py_XDECREF(pyO);
    end;

    Result := PyObjectAsVariant(pyServers);
  end;
  UnlockCallback;
end;
procedure TCallback.SetServers(sV : Variant);
var
  serversPyList : PPyObject;
  server: PPyObject;
  keys : PPyObject;
  values : PPyObject;
  addressList : TStringList;
  nameList : TStringList;
  portList: TStringList;
  i : integer;
begin
  with GetPythonEngine do
  begin
    serversPyList := VariantAsPyObject(sV);
    if not PyList_Check(serversPyList) then
    begin
      Print('SetServers error : first parameter is not a valid python list.');
      Exit;
    end;

    nameList := TStringList.Create;
    addressList := TStringList.Create;
    portList := TStringList.Create;

    for i:=0 to PyList_Size(serversPyList)-1 do
    begin
      server := PyList_GetItem(serversPyList,i);

      if not PyDict_Check(server) then
      begin
        Print('SetServers error : server '+IntToStr(i)+' is not a valid dictionary.');
        Exit;
      end;
      try
        nameList.Add(PyString_AsString(PyDict_GetItemString(server,'Name')));
        addressList.Add(PyString_AsString(PyDict_GetItemString(server,'Address')));
        portList.Add(PyString_AsString(PyDict_GetItemString(server,'Port')));
      except
        Print('SetServers error : server '+IntToStr(i)+' does not contain all needed informations.');
        Exit;
      end;
    end;

    SetLength(ServerList,nameList.Count);

    for i:=0 to nameList.Count-1 do
    begin
      ServerList[i].Name := nameList[i];
      ServerList[i].Address := addressList[i];
      ServerList[i].Port := addressList[i];
    end;

    PreferencesForm.PopulateServerListMenu;
  end;
end;

function TCallback.GetSettings: Variant;
var
  i: integer;
  pySettings: PPyObject;
  sl: TStringList;
  l: TList;
  pyHighlights: PPyObject;
  pyHighlight: PPyObject;
  pyPerformCmds: PPyObject;
  nbNotifications: integer;
  pyNotifications: PPyObject;
  pyNotification: PPyObject;
  notificationType: TNotificationType;
  pyNotificationArgs: PPyObject;
  pyColors: PPyObject;
  pyFont: PPyObject;
  pyProfiles: PPyObject;
  pyCustomProfiles: PPyObject;
  pyCustomProfile: PPyObject;
  customProfileName: string;
  customProfileFile: string;
  springProfileMode: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    pySettings := PyDict_New();

    // preferences
    PyDict_SetItemStringDecRef( pySettings, 'ServerIP', Preferences.ServerIP );
    PyDict_SetItemStringDecRef( pySettings, 'ServerPort', Preferences.ServerPort );
    PyDict_SetItemStringDecRef( pySettings, 'TabStyle', Preferences.TabStyle );
    PyDict_SetItemStringDecRef( pySettings, 'TimeStamps', Preferences.TimeStamps );
    PyDict_SetItemStringDecRef( pySettings, 'Username', Preferences.Username );
    PyDict_SetItemStringDecRef( pySettings, 'Password', '' );
    PyDict_SetItemStringDecRef( pySettings, 'RememberPasswords', Preferences.RememberPasswords );
    PyDict_SetItemStringDecRef( pySettings, 'ConnectOnStartup', Preferences.ConnectOnStartup );
    PyDict_SetItemStringDecRef( pySettings, 'FilterJoinLeftMessages', Preferences.FilterJoinLeftMessages );
    PyDict_SetItemStringDecRef( pySettings, 'FilterBattleJoinLeftMessages', Preferences.FilterBattleJoinLeftMessages );
    PyDict_SetItemStringDecRef( pySettings, 'ShowFlags', Preferences.ShowFlags );
    PyDict_SetItemStringDecRef( pySettings, 'MarkUnknownMaps', Preferences.MarkUnknownMaps );
    PyDict_SetItemStringDecRef( pySettings, 'TaskbarButtons', Preferences.TaskbarButtons );
    PyDict_SetItemStringDecRef( pySettings, 'JoinMainChannel', Preferences.JoinMainChannel );
    PyDict_SetItemStringDecRef( pySettings, 'ReconnectToBackup', Preferences.ReconnectToBackup );
    PyDict_SetItemStringDecRef( pySettings, 'SaveLogs', Preferences.SaveLogs );
    PyDict_SetItemStringDecRef( pySettings, 'UseSoundNotifications', Preferences.UseSoundNotifications );
    PyDict_SetItemStringDecRef( pySettings, 'AutoCompletionFromCurrentChannel', Preferences.AutoCompletionFromCurrentChannel );
    PyDict_SetItemStringDecRef( pySettings, 'AutoUpdateToBeta', Preferences.AutoUpdateToBeta );
    PyDict_SetItemStringDecRef( pySettings, 'DisplayUnitsIconsAndNames', Preferences.DisplayUnitsIconsAndNames );
    PyDict_SetItemStringDecRef( pySettings, 'DisplayAutohostInterface', Preferences.DisplayAutohostInterface );
    PyDict_SetItemStringDecRef( pySettings, 'AutoSaveChanSession', Preferences.AutoSaveChanSession );
    PyDict_SetItemStringDecRef( pySettings, 'UseProxy', Preferences.UseProxy );
    PyDict_SetItemStringDecRef( pySettings, 'ProxyAddress', Preferences.ProxyAddress );
    PyDict_SetItemStringDecRef( pySettings, 'ProxyPort', Preferences.ProxyPort );
    PyDict_SetItemStringDecRef( pySettings, 'ProxyUsername', Preferences.ProxyUsername );
    PyDict_SetItemStringDecRef( pySettings, 'ProxyPassword', Preferences.ProxyPassword );
    PyDict_SetItemStringDecRef( pySettings, 'HighlightColor', Preferences.HighlightColor );
    PyDict_SetItemStringDecRef( pySettings, 'UseNotificationsForHighlights', Preferences.UseNotificationsForHighlights );
    PyDict_SetItemStringDecRef( pySettings, 'UseIgnoreList', Preferences.UseIgnoreList );
    PyDict_SetItemStringDecRef( pySettings, 'WarnIfUsingNATTraversing', Preferences.WarnIfUsingNATTraversing );
    PyDict_SetItemStringDecRef( pySettings, 'AutoFocusOnPM', Preferences.AutoFocusOnPM );
    PyDict_SetItemStringDecRef( pySettings, 'ThemeType', Preferences.ThemeType );
    PyDict_SetItemStringDecRef( pySettings, 'Theme', Preferences.Theme );
    PyDict_SetItemStringDecRef( pySettings, 'AdvancedSkinning', Preferences.AdvancedSkinning );
    PyDict_SetItemStringDecRef( pySettings, 'SkinnedTitlebars', Preferences.SkinnedTitlebars );
    PyDict_SetItemStringDecRef( pySettings, 'DisableAllSounds', Preferences.DisableAllSounds );
    PyDict_SetItemStringDecRef( pySettings, 'ShowReplayUploadFormWhenGameEnd', Preferences.UploadReplay );
    PyDict_SetItemStringDecRef( pySettings, 'SortLocal', Preferences.SortLocal );
    PyDict_SetItemStringDecRef( pySettings, 'DisplayQuickJoinPanel', Preferences.DisplayQuickJoinPanel );
    PyDict_SetItemStringDecRef( pySettings, 'LimitChatLogs', Preferences.LimitChatLogs );
    PyDict_SetItemStringDecRef( pySettings, 'ChatLogsLimit', Preferences.ChatLogsLimit );
    PyDict_SetItemStringDecRef( pySettings, 'ChatLogLoadLoading', Preferences.ChatLogLoadLoading );
    PyDict_SetItemStringDecRef( pySettings, 'ChatLogLoadLines', Preferences.ChatLogLoadLines );
    PyDict_SetItemStringDecRef( pySettings, 'SPSkin', Preferences.SPSkin );
    PyDict_SetItemStringDecRef( pySettings, 'EnableScripts', Preferences.EnableScripts );
    PyDict_SetItemStringDecRef( pySettings, 'EnableSpringDownloader', Preferences.EnableSpringDownloader );
    PyDict_SetItemStringDecRef( pySettings, 'UseLogonForm', Preferences.UseLogonForm );
    PyDict_SetItemStringDecRef( pySettings, 'DisableNews', Preferences.DisableNews );
    PyDict_SetItemStringDecRef( pySettings, 'LanguageCode', Preferences.LanguageCode );
    PyDict_SetItemStringDecRef( pySettings, 'DisableMapDetailsLoading', Preferences.DisableMapDetailsLoading );
    PyDict_SetItemStringDecRef( pySettings, 'LoadMetalHeightMinimaps', Preferences.LoadMetalHeightMinimaps );
    PyDict_SetItemStringDecRef( pySettings, 'LoadMetalHeightMinimaps', Preferences.LoadMetalHeightMinimaps );
    PyDict_SetItemStringDecRef( pySettings, 'AutoSaveChanSession', Preferences.AutoSaveChanSession );

    // perform list
    sl := PerformForm.getPerformList();
    pyPerformCmds := StringsToPyList(sl);
    PyDict_SetItemString( pySettings, 'PerformCommands', pyPerformCmds );
    Py_XDECREF(pyPerformCmds);
    sl.Free;

    // highlights
    l := HighlightingForm.getHighlights();
    pyHighlights := PyList_New(0);
    for i:=0 to l.Count-1 do
    begin
      pyHighlight := PyDict_New;

      PyDict_SetItemStringDecRef( pyHighlight, 'Keyword', PHighlight(l[i]).keyword );
      PyDict_SetItemStringDecRef( pyHighlight, 'CaseSensitive', PHighlight(l[i]).caseSensitive );

      PyList_Append(pyHighlights,pyHighlight);
      Py_XDECREF(pyHighlight);

      FreeMem(PHighlight(l[i]));
    end;
    PyDict_SetItemString( pySettings, 'Highlights', pyHighlights );
    Py_XDECREF(pyHighlights);

    // notifications
    sl := TStringList.Create;
    nbNotifications := NotificationsForm.countNotifications;
    pyNotifications := PyList_New(0);
    for i:=0 to nbNotifications-1 do
    begin
      pyNotification := PyDict_New;

      NotificationsForm.getNotification(i,notificationType,sl);
      pyNotificationArgs := StringsToPyList(sl);

      PyDict_SetItemStringDecRef( pyNotification, 'Type', GetEnumName(TypeInfo(TNotificationType),Integer(notificationType)) );
      PyDict_SetItemString( pyNotification, 'Args', pyNotificationArgs );
      Py_XDECREF(pyNotificationArgs);

      PyList_Append(pyNotifications,pyNotification);
      Py_XDECREF(pyNotification);
    end;
    PyDict_SetItemString( pySettings, 'Notifications', pyNotifications );
    Py_XDECREF(pyNotifications);
    sl.Free;

    // ignore list : will be available in a later function : GetUsersData

    // colors
    pyColors := PyDict_New();
    PyDict_SetItemStringDecRef(pyColors,'Normal',Colors.Normal);
    PyDict_SetItemStringDecRef(pyColors,'Data',Colors.Data);
    PyDict_SetItemStringDecRef(pyColors,'Error',Colors.Error);
    PyDict_SetItemStringDecRef(pyColors,'Info',Colors.Info);
    PyDict_SetItemStringDecRef(pyColors,'MinorInfo',Colors.MinorInfo);
    PyDict_SetItemStringDecRef(pyColors,'ChanJoin',Colors.ChanJoin);
    PyDict_SetItemStringDecRef(pyColors,'ChanLeft',Colors.ChanLeft);
    PyDict_SetItemStringDecRef(pyColors,'MOTD',Colors.MOTD);
    PyDict_SetItemStringDecRef(pyColors,'SayEx',Colors.SayEx);
    PyDict_SetItemStringDecRef(pyColors,'Topic',Colors.Topic);
    PyDict_SetItemStringDecRef(pyColors,'ClientAway',Colors.ClientAway);
    PyDict_SetItemStringDecRef(pyColors,'MapModUnavailable',Colors.MapModUnavailable);
    PyDict_SetItemStringDecRef(pyColors,'BotText',Colors.BotText);
    PyDict_SetItemStringDecRef(pyColors,'MyText',Colors.MyText);
    PyDict_SetItemStringDecRef(pyColors,'AdminText',Colors.AdminText);
    PyDict_SetItemStringDecRef(pyColors,'OldMsgs',Colors.OldMsgs);
    PyDict_SetItemStringDecRef(pyColors,'BattleDetailsNonDefault',Colors.BattleDetailsNonDefault);
    PyDict_SetItemStringDecRef(pyColors,'BattleDetailsChanged',Colors.BattleDetailsChanged);
    PyDict_SetItemStringDecRef(pyColors,'ClientIngame',Colors.ClientIngame);
    PyDict_SetItemStringDecRef(pyColors,'ReplayWinningTeam',Colors.ReplayWinningTeam);
    PyDict_SetItemStringDecRef(pyColors,'SkillLowUncertainty',Colors.SkillLowUncertainty);
    PyDict_SetItemStringDecRef(pyColors,'SkillAvgUncertainty',Colors.SkillAvgUncertainty);
    PyDict_SetItemStringDecRef(pyColors,'SkillHighUncertainty',Colors.SkillHighUncertainty);
    PyDict_SetItemStringDecRef(pyColors,'SkillVeryHighUncertainty',Colors.SkillVeryHighUncertainty);
    PyDict_SetItemString( pySettings, 'Colors', pyColors );
    Py_XDECREF(pyColors);

    // font
    pyFont := PyDict_New();
    PyDict_SetItemStringDecRef(pyFont,'Name',CommonFont.Name);
    PyDict_SetItemStringDecRef(pyFont,'Size',CommonFont.Size);
    PyDict_SetItemString( pySettings, 'Font', pyFont );
    Py_XDECREF(pyFont);

    // groups : available with GetGroups

    // profiles
    pyProfiles := PyDict_New();
    PyDict_SetItemStringDecRef(pyProfiles,'Playing',SpringSettingsProfileForm.getPlayingProfile);
    PyDict_SetItemStringDecRef(pyProfiles,'Spectator',SpringSettingsProfileForm.getSpectatorProfile);
    PyDict_SetItemStringDecRef(pyProfiles,'CustomSpringExe',SpringSettingsProfileForm.getCustomSpringExe);
    if BattleForm.sspST.Checked then
      springProfileMode := 0
    else if BattleForm.sspMT.Checked then
      springProfileMode := 1
    else if BattleForm.sspCustomExe.Checked then
      springProfileMode := 2;
    PyDict_SetItemStringDecRef(pyProfiles,'Mode',springProfileMode);
    pyCustomProfiles := PyList_New(0);
    for i:=0 to SpringSettingsProfileForm.countCustomProfile-1 do
    begin
      pyCustomProfile := PyDict_New();

      SpringSettingsProfileForm.getCustomProfile(i, customProfileName, customProfileFile);

      PyDict_SetItemStringDecRef(pyCustomProfile,'Name',customProfileName);
      PyDict_SetItemStringDecRef(pyCustomProfile,'SettingsFile',customProfileFile);

      PyList_Append( pyCustomProfiles, pyCustomProfile );
      Py_XDECREF(pyCustomProfile);
    end;
    PyDict_SetItemString( pyProfiles, 'Custom', pyCustomProfiles );
    Py_XDECREF(pyCustomProfiles);
    PyDict_SetItemString( pySettings, 'SpringProfiles', pyProfiles );
    Py_XDECREF(pyProfiles);

    Result := PyObjectAsVariant(pySettings);
  end;
  UnlockCallback;
end;

function TCallback.SetSettings(newSettings: Variant): Boolean;
var
  i: integer;
  pyNewSettings: PPyObject;
  newPref: TPreferences;
  pyPerformCommands: PPyObject;
  pyHighlights: PPyObject;
  pyHighlight: PPyObject;
  sl: TStringList;
  highlightKeyword: string;
  highlightCaseSensitive: boolean;
  pyNotifications: PPyObject;
  pyNotification: PPyObject;
  pyNotificationArgs: PPyObject;
  notificationArgs: TStringList;
  notificationTypeStr: string;
  notificationTypeInt: integer;
  notificationType: TNotificationType;
  pyColors: PPyObject;
  pyFont: PPyObject;
  pyProfiles: PPyObject;
  pyCustomProfiles: PPyObject;
  pyCustomProfile: PPyObject;
  customProfileName: string;
  customProfilePath: string;
  springProfileMode: integer;
begin
  Result := False;
  with GetPythonEngine do
  begin
    pyNewSettings := VariantAsPyObject(newSettings);
    if not PyDict_Check(pyNewSettings) then
    begin
      Print('SetSettings error : first parameter is not a valid python dict.');
      Exit;
    end;

    // load preferences
    newPref := Preferences;
    newPref.ServerIP := PyDict_GetVariantItemString(pyNewSettings,'ServerIP',newPref.ServerIP);
    newPref.ServerPort := PyDict_GetVariantItemString(pyNewSettings,'ServerPort',newPref.ServerPort);
    newPref.TabStyle := PyDict_GetVariantItemString(pyNewSettings,'TabStyle',newPref.TabStyle);
    newPref.TimeStamps := PyDict_GetVariantItemString(pyNewSettings,'TimeStamps',newPref.TimeStamps);
    newPref.Username := PyDict_GetVariantItemString(pyNewSettings,'Username',newPref.Username);
    newPref.Password := PyDict_GetVariantItemString(pyNewSettings,'Password',newPref.Password);
    newPref.RememberPasswords := PyDict_GetVariantItemString(pyNewSettings,'RememberPasswords',newPref.RememberPasswords);
    newPref.ConnectOnStartup := PyDict_GetVariantItemString(pyNewSettings,'ConnectOnStartup',newPref.ConnectOnStartup);
    newPref.FilterJoinLeftMessages := PyDict_GetVariantItemString(pyNewSettings,'FilterJoinLeftMessages',newPref.FilterJoinLeftMessages);
    newPref.FilterBattleJoinLeftMessages := PyDict_GetVariantItemString(pyNewSettings,'FilterBattleJoinLeftMessages',newPref.FilterBattleJoinLeftMessages);
    newPref.ShowFlags := PyDict_GetVariantItemString(pyNewSettings,'ShowFlags',newPref.ShowFlags);
    newPref.MarkUnknownMaps := PyDict_GetVariantItemString(pyNewSettings,'MarkUnknownMaps',newPref.MarkUnknownMaps);
    newPref.TaskbarButtons := PyDict_GetVariantItemString(pyNewSettings,'TaskbarButtons',newPref.TaskbarButtons);
    newPref.JoinMainChannel := PyDict_GetVariantItemString(pyNewSettings,'JoinMainChannel',newPref.JoinMainChannel);
    newPref.ReconnectToBackup := PyDict_GetVariantItemString(pyNewSettings,'ReconnectToBackup',newPref.ReconnectToBackup);
    newPref.SaveLogs := PyDict_GetVariantItemString(pyNewSettings,'SaveLogs',newPref.SaveLogs);
    newPref.UseSoundNotifications := PyDict_GetVariantItemString(pyNewSettings,'UseSoundNotifications',newPref.UseSoundNotifications);
    newPref.AutoCompletionFromCurrentChannel := PyDict_GetVariantItemString(pyNewSettings,'AutoCompletionFromCurrentChannel',newPref.AutoCompletionFromCurrentChannel);
    newPref.AutoUpdateToBeta := PyDict_GetVariantItemString(pyNewSettings,'AutoUpdateToBeta',newPref.AutoUpdateToBeta);
    newPref.DisplayUnitsIconsAndNames := PyDict_GetVariantItemString(pyNewSettings,'DisplayUnitsIconsAndNames',newPref.DisplayUnitsIconsAndNames);
    newPref.DisplayAutohostInterface := PyDict_GetVariantItemString(pyNewSettings,'DisplayAutohostInterface',newPref.DisplayAutohostInterface);
    newPref.AutoSaveChanSession := PyDict_GetVariantItemString(pyNewSettings,'AutoSaveChanSession',newPref.AutoSaveChanSession);
    newPref.UseProxy := PyDict_GetVariantItemString(pyNewSettings,'UseProxy',newPref.UseProxy);
    newPref.ProxyAddress := PyDict_GetVariantItemString(pyNewSettings,'ProxyAddress',newPref.ProxyAddress);
    newPref.ProxyPort := PyDict_GetVariantItemString(pyNewSettings,'ProxyPort',newPref.ProxyPort);
    newPref.ProxyUsername := PyDict_GetVariantItemString(pyNewSettings,'ProxyUsername',newPref.ProxyUsername);
    newPref.ProxyPassword := PyDict_GetVariantItemString(pyNewSettings,'ProxyPassword',newPref.ProxyPassword);
    newPref.HighlightColor := PyDict_GetVariantItemString(pyNewSettings,'HighlightColor',newPref.HighlightColor);
    newPref.UseNotificationsForHighlights := PyDict_GetVariantItemString(pyNewSettings,'UseNotificationsForHighlights',newPref.UseNotificationsForHighlights);
    newPref.UseIgnoreList := PyDict_GetVariantItemString(pyNewSettings,'UseIgnoreList',newPref.UseIgnoreList);
    newPref.WarnIfUsingNATTraversing := PyDict_GetVariantItemString(pyNewSettings,'WarnIfUsingNATTraversing',newPref.WarnIfUsingNATTraversing);
    newPref.AutoFocusOnPM := PyDict_GetVariantItemString(pyNewSettings,'AutoFocusOnPM',newPref.AutoFocusOnPM);
    newPref.ThemeType := PyDict_GetVariantItemString(pyNewSettings,'ThemeType',newPref.ThemeType);
    newPref.Theme := PyDict_GetVariantItemString(pyNewSettings,'Theme',newPref.Theme);
    newPref.AdvancedSkinning := PyDict_GetVariantItemString(pyNewSettings,'AdvancedSkinning',newPref.AdvancedSkinning);
    newPref.SkinnedTitlebars := PyDict_GetVariantItemString(pyNewSettings,'SkinnedTitlebars',newPref.SkinnedTitlebars);
    newPref.DisableAllSounds := PyDict_GetVariantItemString(pyNewSettings,'DisableAllSounds',newPref.DisableAllSounds);
    newPref.UploadReplay := PyDict_GetVariantItemString(pyNewSettings,'ShowReplayUploadFormWhenGameEnd',newPref.UploadReplay);
    newPref.SortLocal := PyDict_GetVariantItemString(pyNewSettings,'SortLocal',newPref.SortLocal);
    newPref.DisplayQuickJoinPanel := PyDict_GetVariantItemString(pyNewSettings,'DisplayQuickJoinPanel',newPref.DisplayQuickJoinPanel);
    newPref.LimitChatLogs := PyDict_GetVariantItemString(pyNewSettings,'LimitChatLogs',newPref.LimitChatLogs);
    newPref.ChatLogsLimit := PyDict_GetVariantItemString(pyNewSettings,'ChatLogsLimit',newPref.ChatLogsLimit);
    newPref.ChatLogLoadLoading := PyDict_GetVariantItemString(pyNewSettings,'ChatLogLoadLoading',newPref.ChatLogLoadLoading);
    newPref.ChatLogLoadLines := PyDict_GetVariantItemString(pyNewSettings,'ChatLogLoadLines',newPref.ChatLogLoadLines);
    newPref.SPSkin := PyDict_GetVariantItemString(pyNewSettings,'SPSkin',newPref.SPSkin);
    newPref.EnableScripts := PyDict_GetVariantItemString(pyNewSettings,'EnableScripts',newPref.EnableScripts);
    newPref.EnableSpringDownloader := PyDict_GetVariantItemString(pyNewSettings,'EnableSpringDownloader',newPref.EnableSpringDownloader);
    newPref.UseLogonForm := PyDict_GetVariantItemString(pyNewSettings,'UseLogonForm',newPref.UseLogonForm);
    newPref.DisableNews := PyDict_GetVariantItemString(pyNewSettings,'DisableNews',newPref.DisableNews);
    newPref.LanguageCode := PyDict_GetVariantItemString(pyNewSettings,'LanguageCode',newPref.LanguageCode);
    newPref.DisableMapDetailsLoading := PyDict_GetVariantItemString(pyNewSettings,'DisableMapDetailsLoading',newPref.DisableMapDetailsLoading);
    newPref.LoadMetalHeightMinimaps := PyDict_GetVariantItemString(pyNewSettings,'LoadMetalHeightMinimaps',newPref.LoadMetalHeightMinimaps);
    newPref.AutoSaveChanSession := PyDict_GetVariantItemString(pyNewSettings,'AutoSaveChanSession',newPref.AutoSaveChanSession);

    PreferencesForm.applyPreferences(newPref,true);
    try if not Preferences.ScriptsDisabled then handlers.onSettingsChanged(); except end;

    // perform commands
    pyPerformCommands := PyDict_GetItemString(pyNewSettings,'PerformCommands');
    if pyPerformCommands <> nil then
    if not PyList_Check(pyPerformCommands) then
    begin
      Print('SetSettings warning : "PerformCommands" ignored because it is not a valid list');
    end
    else
    begin
      sl := TStringList.Create;
      pyListToStrings(pyPerformCommands,sl);
      PerformForm.setPerformList(sl);
      sl.Free;
    end;

    // highlights
    pyHighlights := PyDict_GetItemString(pyNewSettings,'Highlights');
    if pyHighlights <> nil then
    if not PyList_Check(pyHighlights) then
    begin
      Print('SetSettings warning : "Highlights" ignored because it is not a valid list');
    end
    else
    begin
      HighlightingForm.clearHighlights;
      for i:=0 to PyList_Size(pyHighlights)-1 do
      begin
        pyHighlight := PyList_GetItem(pyHighlights,i);
        if not PyDict_Check(pyHighlight) then
        begin
          Print('SetSettings warning : "Highlights['+IntToStr(i)+']" ignored because it is not a valid dict');
        end
        else
        begin
          highlightKeyword := PyDict_GetVariantItemString(pyHighlight,'Keyword','');
          highlightCaseSensitive := PyDict_GetVariantItemString(pyHighlight,'CaseSensitive',False);
          if highlightKeyword = '' then
          begin
            Print('SetSettings warning : "Highlights['+IntToStr(i)+'][''Keyword'']" not found, highlight ignored');
          end
          else
          begin
            HighlightingForm.addHighlight(highlightKeyword,highlightCaseSensitive);
          end;
        end;
      end;
    end;

    // notifications
    pyNotifications := PyDict_GetItemString(pyNewSettings,'Notifications');
    if pyNotifications <> nil then
    if not PyList_Check(pyNotifications) then
    begin
      Print('SetSettings warning : "Notifications" ignored because it is not a valid list');
    end
    else
    begin
      NotificationsForm.ClearNotifications;
      for i:=0 to PyList_Size(pyNotifications)-1 do
      begin
        pyNotification := PyList_GetItem(pyNotifications,i);
        if not PyDict_Check(pyNotification) then
        begin
          Print('SetSettings warning : "Notifications['+IntToStr(i)+']" ignored because it is not a valid dict');
        end
        else
        begin
          notificationTypeStr := PyDict_GetVariantItemString(pyNotification,'Type','');
          pyNotificationArgs := PyDict_GetItemString(pyNotification,'Args');
          notificationArgs := TStringList.Create;
          PyListToStrings(pyNotificationArgs,notificationArgs);
          if notificationTypeStr = '' then
          begin
            Print('SetSettings warning : "Notifications['+IntToStr(i)+'][''Type'']" not found, notification ignored');
          end
          else
          begin
            notificationTypeInt := GetEnumValue(TypeInfo(TNotificationType),notificationTypeStr);
            if notificationTypeInt = -1 then
            begin
              Print('SetSettings warning : "Notifications['+IntToStr(i)+'][''Type'']" is not a valid notification type, notification ignored');
            end
            else
            begin
              notificationType := TNotificationType(notificationTypeInt);
              if not NotificationsForm.AddNotification(notificationType,notificationArgs) then
              begin
                Print('SetSettings warning : "Notifications['+IntToStr(i)+'][''Args'']" doesn''t fit the notification type, notification ignored');
              end;
            end;
          end;
          notificationArgs.Free;
        end;
      end;
      NotificationsForm.UpdateNotificationList;
    end;

    // colors
    pyColors := PyDict_GetItemString(pyNewSettings,'Colors');
    if pyColors <> nil then
    if not PyDict_Check(pyColors) then
    begin
      Print('SetSettings warning : "Colors" ignored because it is not a valid dict');
    end
    else
    begin
      Colors.Normal := PyDict_GetVariantItemString(pyColors,'Normal',Colors.Normal);
      Colors.Data := PyDict_GetVariantItemString(pyColors,'Data',Colors.Data);
      Colors.Error := PyDict_GetVariantItemString(pyColors,'Error',Colors.Error);
      Colors.Info := PyDict_GetVariantItemString(pyColors,'Info',Colors.Info);
      Colors.MinorInfo := PyDict_GetVariantItemString(pyColors,'MinorInfo',Colors.MinorInfo);
      Colors.ChanJoin := PyDict_GetVariantItemString(pyColors,'ChanJoin',Colors.ChanJoin);
      Colors.ChanLeft := PyDict_GetVariantItemString(pyColors,'ChanLeft',Colors.ChanLeft);
      Colors.MOTD := PyDict_GetVariantItemString(pyColors,'MOTD',Colors.MOTD);
      Colors.SayEx := PyDict_GetVariantItemString(pyColors,'SayEx',Colors.SayEx);
      Colors.Topic := PyDict_GetVariantItemString(pyColors,'Topic',Colors.Topic);
      Colors.ClientAway := PyDict_GetVariantItemString(pyColors,'ClientAway',Colors.ClientAway);
      Colors.MapModUnavailable := PyDict_GetVariantItemString(pyColors,'MapModUnavailable',Colors.MapModUnavailable);
      Colors.BotText := PyDict_GetVariantItemString(pyColors,'BotText',Colors.BotText);
      Colors.MyText := PyDict_GetVariantItemString(pyColors,'MyText',Colors.MyText);
      Colors.AdminText := PyDict_GetVariantItemString(pyColors,'AdminText',Colors.AdminText);
      Colors.OldMsgs := PyDict_GetVariantItemString(pyColors,'OldMsgs',Colors.OldMsgs);
      Colors.BattleDetailsNonDefault := PyDict_GetVariantItemString(pyColors,'BattleDetailsNonDefault',Colors.BattleDetailsNonDefault);
      Colors.BattleDetailsChanged := PyDict_GetVariantItemString(pyColors,'BattleDetailsChanged',Colors.BattleDetailsChanged);
      Colors.ClientIngame := PyDict_GetVariantItemString(pyColors,'ClientIngame',Colors.ClientIngame);
      Colors.ReplayWinningTeam := PyDict_GetVariantItemString(pyColors,'ReplayWinningTeam',Colors.ReplayWinningTeam);
      Colors.SkillLowUncertainty := PyDict_GetVariantItemString(pyColors,'SkillLowUncertainty',Colors.SkillLowUncertainty);
      Colors.SkillAvgUncertainty := PyDict_GetVariantItemString(pyColors,'SkillAvgUncertainty',Colors.SkillAvgUncertainty);
      Colors.SkillHighUncertainty := PyDict_GetVariantItemString(pyColors,'SkillHighUncertainty',Colors.SkillHighUncertainty);
      Colors.SkillVeryHighUncertainty := PyDict_GetVariantItemString(pyColors,'SkillVeryHighUncertainty',Colors.SkillVeryHighUncertainty);
    end;

    // font
    pyFont := PyDict_GetItemString(pyNewSettings,'Font');
    if pyFont <> nil then
    if not PyDict_Check(pyFont) then
    begin
      Print('SetSettings warning : "Font" ignored because it is not a valid dict');
    end
    else
    begin
      CommonFont.Name := PyDict_GetVariantItemString(pyFont,'Name',CommonFont.Name);
      CommonFont.Size := PyDict_GetVariantItemString(pyFont,'Size',CommonFont.Size);
      ColorsPreference.ApplyFont;
    end;

    // groups : available with SetGroups

    // profiles
    pyProfiles := PyDict_GetItemString(pyNewSettings,'SpringProfiles');
    if pyProfiles <> nil then
    if not PyDict_Check(pyProfiles) then
    begin
      Print('SetSettings warning : "SpringProfiles" ignored because it is not a valid dict');
    end
    else
    begin
      SpringSettingsProfileForm.setPlayingProfile(PyDict_GetVariantItemString(pyProfiles,'Playing',SpringSettingsProfileForm.getPlayingProfile));
      SpringSettingsProfileForm.setSpectatorProfile(PyDict_GetVariantItemString(pyProfiles,'Spectator',SpringSettingsProfileForm.getSpectatorProfile));
      SpringSettingsProfileForm.setCustomSpringExe(PyDict_GetVariantItemString(pyProfiles,'CustomSpringExe',SpringSettingsProfileForm.getCustomSpringExe));
      springProfileMode := PyDict_GetVariantItemString(pyProfiles,'Mode',-1);
      if springProfileMode = 0 then
        BattleForm.sspST.Checked := true
      else if springProfileMode = 1 then
        BattleForm.sspMT.Checked := true
      else if springProfileMode = 2 then
        BattleForm.sspCustomExe.Checked := true;

      pyCustomProfiles := PyDict_GetItemString(pyProfiles,'Custom');
      if pyCustomProfiles <> nil then
      if not PyList_Check(pyCustomProfiles) then
      begin
        Print('SetSettings warning : "SpringProfiles[''Custom'']" ignored because it is not a valid list');
      end
      else
      begin
        SpringSettingsProfileForm.clearCustomProfiles;
        for i:=0 to PyList_Size(pyCustomProfiles)-1 do
        begin
          pyCustomProfile := PyList_GetItem(pyCustomProfiles,i);
          if (pyCustomProfile = nil) or not PyDict_Check(pyCustomProfile) then
          begin
            Print('SetSettings warning : "SpringProfiles[''Custom'']['+IntToStr(i)+']" is not a valid dict, custom profile ignored');
          end
          else
          begin
            customProfileName := PyDict_GetVariantItemString(pyCustomProfile,'Name','');
            customProfilePath := PyDict_GetVariantItemString(pyCustomProfile,'SettingsFile','');
            if (customProfileName = '') or (customProfilePath = '') then
            begin
              Print('SetSettings warning : "SpringProfiles[''Custom'']['+IntToStr(i)+'][''Name'' and/or ''SettingsFile'']" is missing, custom profile ignored');
            end
            else
            begin
              SpringSettingsProfileForm.addCustomProfile(customProfileName,customProfilePath);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TCallback.GetMaps: Variant;
var
  pyMap: PPyObject;
  pyPosition: PPyObject;
  pyPositions: PPyObject;
  i,j: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyMaps := PyDict_New();

    for i:=0 to MapListForm.Maps.Count-1 do
      with TMapItem(MapListForm.Maps[i]) do
      begin
        pyMap := PyDict_New();
        if Pos('oasis',LowerCase(TMapItem(MapListForm.Maps[i]).MapName)) > 0 then
          TMapItem(MapListForm.Maps[i]).MapName := TMapItem(MapListForm.Maps[i]).MapName;


        PyDict_SetItemStringDecRef( pyMap, 'Hash', MapHash );
        PyDict_SetItemStringDecRef( pyMap, 'MyGrade', MyGrade );
        PyDict_SetItemStringDecRef( pyMap, 'GlobalGrade', GlobalGrade );
        PyDict_SetItemStringDecRef( pyMap, 'TotalVotes', TotalVotes );
        PyDict_SetItemStringDecRef( pyMap, 'Description', MapInfo.Description );
        PyDict_SetItemStringDecRef( pyMap, 'TidalStrength', MapInfo.TidalStrength );
        PyDict_SetItemStringDecRef( pyMap, 'Gravity', MapInfo.Gravity );
        PyDict_SetItemStringDecRef( pyMap, 'MaxMetal', MapInfo.MaxMetal );
        PyDict_SetItemStringDecRef( pyMap, 'ExtractorRadius', MapInfo.ExtractorRadius );
        PyDict_SetItemStringDecRef( pyMap, 'MinWind', MapInfo.MinWind );
        PyDict_SetItemStringDecRef( pyMap, 'MaxWind', MapInfo.MaxWind );
        PyDict_SetItemStringDecRef( pyMap, 'Width', MapInfo.Width );
        PyDict_SetItemStringDecRef( pyMap, 'Height', MapInfo.Height );

        pyPositions := PyDict_New();
        for j:=0 to MapInfo.PosCount-1 do
        begin
          pyPosition := PyDict_New();

          PyDict_SetItemStringDecRef( pyPosition, 'x', MapInfo.Positions[j].x );
          PyDict_SetItemStringDecRef( pyPosition, 'y', MapInfo.Positions[j].y );

          PyDict_SetItem( pyPositions, PyInt_FromLong(j), pyPosition );
          Py_XDECREF(pyPosition);
        end;
        PyDict_SetItemString( pyMap, 'StartPos', pyPositions );
        Py_XDECREF(pyPositions);

        PyDict_SetItemString(pyMaps,PChar(MapName) ,pyMap);
        Py_XDECREF(pyMap);
      end;

    Result := PyObjectAsVariant(pyMaps);
  end;
  UnlockCallback;
end;

function TCallback.GetMods: Variant;
var
  pyMod: PPyObject;
  i: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyMods := PyDict_New();

    for i:=0 to Utility.ModList.Count-1 do
      begin
        pyMod := PyDict_New();

        PyDict_SetItemStringDecRef( pyMod, 'Archive', Utility.ModArchiveList[i] );

        PyDict_SetItemString(pyMods,PChar(Utility.ModList[i]) ,pyMod);
      end;

    Result := PyObjectAsVariant(pyMods);
  end;
  UnlockCallback;
end;

function TCallback.JoinBattle(battleId: integer; Password: String; spectator: Boolean) : Boolean;
var
  mtReleased: Boolean;
  b : TBattle;
begin
  LockCallback;
  Result := True;

  if ScriptJoining then
  begin
    Result := False;
    UnlockCallback;
    Exit;
  end;

  mtReleased := ReleaseMainThread;
  ScriptJoining := True;
  b := MainForm.GetBattle(battleId);
  if b <> nil then
  begin
    JoinBattleId := battleId;
    JoinBattlePassword := Password;
    JoinBattleSpectator := spectator;
    PostMessage(MainForm.Handle,WM_SCRIPT,2,0);
    Result := True;
  end
  else
    Result := False;
  if mtReleased then
    AcquireMainThread;
  UnlockCallback;
end;

function TCallback.HostReplay(replayFile: string; nbPlayers: integer; RankLimit: Integer; Description: string; Password: string; UDPHostPort: integer; NatTraversal: integer) : Boolean;
var
  mtReleased: Boolean;
begin
  Result := True;

  if ScriptHostingRunning or ScriptHostingReplayRunning or (BattleState.Status <> None) or not MainForm.AreWeLoggedIn then
  begin
    Result := False;
    Exit;
  end;

  ScriptHostingReplayRunning := True;
  ScriptHostingRunning := True;

  mtReleased := ReleaseMainThread;
  with HostBattleForm do
  begin
    try
      HostBattleForm.replay := ReplaysForm.GetReplayFromFileName(replayFile);

      if HostBattleForm.replay = nil then
      begin
        ScriptHostingReplayRunning := false;
        ScriptHostingRunning := false;
        Result := false;
        if mtReleased then
          AcquireMainThread;
        Exit;
      end;

      HostReplay1Click(mnuHostReplay);

      PlayersTracker.Value := nbPlayers;
      RankComboBox.ItemIndex := RankLimit;
      TitleEdit.Text := Description;
      PasswordEdit.Text := Password;
      PortEdit.Text := IntToStr(UDPHostPort);
      NATRadioGroup.ItemIndex := NatTraversal;

      Result := True;
      SendMessage(MainForm.Handle,WM_SCRIPT,4,0);
    except
      Result := false;
    end;
  end;
  if mtReleased then
    AcquireMainThread;
end;

function TCallback.HostBattle(nbPlayers: integer; RankLimit: Integer; ModName: string; Description: string; Password: string; UDPHostPort: integer; NatTraversal: integer) : Boolean;
var
  mtReleased: Boolean;
begin
  Result := True;

  if ScriptHostingRunning or (BattleState.Status <> None) or not MainForm.AreWeLoggedIn then
  begin
    Result := False;
    Exit;
  end;

  ScriptHostingRunning := True;

  mtReleased := ReleaseMainThread;
  with HostBattleForm do
  begin
    try
      Host1Click(mnuHost);

      PlayersTracker.Value := nbPlayers;
      RankComboBox.ItemIndex := RankLimit;
      ModsComboBox.ItemIndex := ModsComboBox.Items.IndexOf(ModName);
      TitleEdit.Text := Description;
      PasswordEdit.Text := Password;
      PortEdit.Text := IntToStr(UDPHostPort);
      NATRadioGroup.ItemIndex := NatTraversal;

      Result := True;
      SendMessage(MainForm.Handle,WM_SCRIPT,4,0);
    except
      Result := false;
    end;
  end;
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.LeaveBattle;
begin
  if BattleState.Status <> None then
  begin
    PostMessage(MainForm.Handle,WM_SCRIPT,1,0);
  end;
end;

function TCallback.ChangeMap(mapName: string): Boolean;
begin
  if BattleState.Status <> Joined then
  begin
    ChangeMapIndex := MapList.IndexOf(mapName);
    Result := ChangeMapIndex > -1;
    if Result then
      SendMessage(MainForm.Handle,WM_SCRIPT,3,0);
  end
  else
    Result := False;
end;

function TCallback.GetSpringExe: String;
begin
  Result := SpringSettingsProfileForm.getSpringExe;
end;

function TCallback.StartBattle: Boolean;
var
  mtReleased: Boolean;
begin
  Result := False;
  if ScriptStart then
    Exit;
  ScriptStart := True;
  StartBattleSuccess := False;
  mtReleased := ReleaseMainThread;
  try
    BattleForm.StartButtonClick(nil);
  except
    on E:Exception do
      Print(E.Message);
  end;
  if mtReleased then
    AcquireMainThread;
  Result := StartBattleSuccess;
  ScriptStart := False;
end;

function TCallback.SetMyReadyStatus(b: Boolean): Boolean;
var
  mtReleased: Boolean;
begin
  Result := False;
  if BattleState.Battle = nil then
    Exit;
  if b = BattleForm.AmIReady then
  begin
    Result := True;
    Exit;
  end;
  mtReleased := ReleaseMainThread;
  BattleForm.ReadyButtonClick(BattleForm.ReadyButton);
  Result := BattleForm.AmIReady;
  if Result then
    Status.Me.SetReadyStatus(Result);
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.SetMyBattleStatus(spec: boolean);
var
  mtReleased: Boolean;
begin
  mtReleased := ReleaseMainThread;
  BattleForm.SpectateCheckBox.Checked := spec;
  BattleForm.ReadyButton.Enabled := ((BattleState.Battle <> nil) and (BattleState.Battle.BattleType = 1)) or not BattleForm.SpectateCheckBox.Checked;
  if mtReleased then
    AcquireMainThread;
end;

procedure TCallback.DownloadMap2(mapName: string; callbackArgs: Variant; callbackFunction: Variant);
var
  snc : PScriptDownloadCallback;
  params: PFileDownloadInfo;
begin
  with GetPythonEngine do
  begin
    if not PyFunction_Check(VariantAsPyObject(callbackFunction)) then
    begin
      Print('Error: Invalid DownloadMap2 callback function.');
      Exit;
    end;
    New(snc);
    snc.func := VariantAsPyObject(callbackFunction);
    snc.args := VariantAsPyObject(callbackArgs);
    PyList_Insert(snc.args,0,PyLong_FromLong(0));
  end;

  try
    New(params);
    params.name := mapName;
    params.params := snc;
    params.cb := Self;

    MapDownloadList.Add(params);

    PostMessage(MainForm.Handle,WM_SCRIPT,5,0);
  except
    on E:Exception do
      Print(E.Message);
  end;
end;

procedure TCallback.DownloadMap(mapName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
begin
  with GetPythonEngine do
    DownloadMap2(mapName,callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)));
end;

procedure TCallback.DownloadRapid(rapidName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
begin
  with GetPythonEngine do
    DownloadRapid2(rapidName,callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)));
end;

procedure TCallback.DownloadRapid2(rapidName: string; callbackArgs: Variant; callbackFunction: Variant);
var
  snc : PScriptDownloadCallback;
  params: PFileDownloadInfo;
begin
  New(snc);
  with GetPythonEngine do
  begin
    if not PyFunction_Check(VariantAsPyObject(callbackFunction)) then
    begin
      Print('Error: Invalid DownloadRapid2 callback function.');
      Exit;
    end;
    snc.func := VariantAsPyObject(callbackFunction);
    snc.args := VariantAsPyObject(callbackArgs);
    PyList_Insert(snc.args,0,PyLong_FromLong(0));
  end;
  try
    New(params);
    params.name := rapidName;
    params.params := snc;
    params.cb := Self;

    RapidDownloadList.Add(params);

    PostMessage(MainForm.Handle,WM_SCRIPT,5,0);
  except
    on E:Exception do
      Print(E.Message);
  end;
end;

procedure TCallback.ListRapidTags(callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
begin
  with GetPythonEngine do
    ListRapidTags2(callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)));
end;

procedure TCallback.ListRapidTags2(callbackArgs: Variant; callbackFunction: Variant);
var
  snc : PScriptSimpleCallback;
begin
  New(snc);
  with GetPythonEngine do
  begin
    if not PyFunction_Check(VariantAsPyObject(callbackFunction)) then
    begin
      Print('Error: Invalid ListRapidTags2 callback function.');
      Exit;
    end;
    snc.func := VariantAsPyObject(callbackFunction);
    snc.args := VariantAsPyObject(callbackArgs);
  end;

  TScriptRapidListThread.Create(false,snc);
end;

procedure TCallback.DownloadMod(modName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
begin
  with GetPythonEngine do
    DownloadMod2(modName,callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)));
end;

procedure TCallback.DownloadMod2(modName: string; callbackArgs: Variant; callbackFunction: Variant);
var
  snc : PScriptDownloadCallback;
  params: PFileDownloadInfo;
begin
  New(snc);
  with GetPythonEngine do
  begin
    snc.func := VariantAsPyObject(callbackFunction);
    snc.args := VariantAsPyObject(callbackArgs);
    PyList_Insert(snc.args,0,PyLong_FromLong(0));
  end;
  try
    New(params);
    params.name := modName;
    params.params := snc;
    params.cb := Self;

    ModDownloadList.Add(params);

    PostMessage(MainForm.Handle,WM_SCRIPT,5,0);
  except
    on E:Exception do
      Print(E.Message);
  end;
end;

procedure TCallback.DownloadEngine(engineName: string; engineVersion: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string);
begin
  with GetPythonEngine do
    DownloadEngine2(engineName, engineVersion, callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)));
end;

procedure TCallback.DownloadEngine2(engineName: string; engineVersion: string; callbackArgs: Variant; callbackFunction: Variant);
var
  snc : PScriptDownloadCallback;
  params: PFileDownloadInfo;
begin
  New(snc);
  with GetPythonEngine do
  begin
    snc.func := VariantAsPyObject(callbackFunction);
    snc.args := VariantAsPyObject(callbackArgs);
    PyList_Insert(snc.args,0,PyLong_FromLong(0));
  end;
  try
    New(params);
    params.engineName := engineName;
    params.engineVersion := engineVersion;
    params.params := snc;
    params.cb := Self;

    EngineDownloadList.Add(params);

    PostMessage(MainForm.Handle,WM_SCRIPT,5,0);
  except
    on E:Exception do
      Print(E.Message);
  end;
end;

procedure TCallback.RefreshWidgetList;
begin
  RefreshWidgetListAction := true;
  ExecuteNextWidgetAction;
end;

function TCallback.GetWidgets: Variant;
var
  pyWidgets: PPyObject;
  pyWidget: PPyObject;
  widget: TWidgetItem;
  i: integer;
begin
  LockCallback;
  with GetPythonEngine do
  begin
    pyWidgets := PyList_New(0);

    for i:=0 to WidgetDBForm.widgetList.Count-1 do
    begin
      widget := TWidgetItem(WidgetDBForm.widgetList[i]);

      pyWidget := PyDict_New();

      PyDict_SetItemStringDecRef( pyWidget, 'Id', widget.Id );
      PyDict_SetItemStringDecRef( pyWidget, 'Name', widget.Name );
      PyDict_SetItemStringDecRef( pyWidget, 'NameId', widget.NameId );
      PyDict_SetItemStringDecRef( pyWidget, 'Downloads', widget.Downloads );
      PyDict_SetItemStringDecRef( pyWidget, 'Games', widget.Games );
      PyDict_SetItemStringDecRef( pyWidget, 'Rating', widget.Rating );
      PyDict_SetItemStringDecRef( pyWidget, 'VoteCount', widget.VoteCount );
      PyDict_SetItemStringDecRef( pyWidget, 'Comments', widget.Comments );
      PyDict_SetItemStringDecRef( pyWidget, 'Author', widget.Author );
      PyDict_SetItemStringDecRef( pyWidget, 'Description', widget.Description );
      PyDict_SetItemStringDecRef( pyWidget, 'Category', widget.Category.Name );
      PyDict_SetItemStringDecRef( pyWidget, 'Entry', widget.Entry );
      PyDict_SetItemStringDecRef( pyWidget, 'Changelog', widget.Changelog );
      PyDict_SetItemStringDecRef( pyWidget, 'Installed', widget.Installed );
      PyDict_SetItemStringDecRef( pyWidget, 'UpToDate', widget.UpToDate );

      PyList_Append(pyWidgets,pyWidget);
      Py_XDECREF(pyWidget);
    end;

    Result := PyObjectAsVariant(pyWidgets);
  end;
end;

function TCallback.InstallOrUpdateWidget(id: integer): boolean;
var
  widget: TWidgetItem;
begin
  widget := WidgetDBForm.GetWidgetById(id);
  Result := widget <> nil;
  if Result then
  begin
    InstallWidgetIds.Add(id);
    ExecuteNextWidgetAction;
  end;
end;

function TCallback.UninstallWidget(id: integer): boolean;
var
  widget: TWidgetItem;
begin
  widget := WidgetDBForm.GetWidgetById(id);
  Result := (widget <> nil) and widget.Installed;
  if Result then
  begin
    UninstallWidgetIds.Add(id);
    ExecuteNextWidgetAction;
  end;
end;

//------------------------------------------------------------------------------------------------------
//    TGUI
//------------------------------------------------------------------------------------------------------

function TGUI.GetColors: Variant;
begin
  Result := GetPythonEngine.PyObjectAsVariant(pyColors);
end;

procedure TGUI.RefreshRichEditLists;
var
  i : integer;
begin
  textBoxStringList.Clear;
  textBoxList.Clear;

  textBoxStringList.Add('$local');
  textBoxList.Add(MainForm.ChatTabs[0]);
  textBoxStringList.Add('$batte');
  textBoxList.Add(nil);
  textBoxStringList.Add('$current');
  if BattleForm.Active or BattleForm.ChatActive then
    textBoxList.Add(nil)
  else
    textBoxList.Add(MainForm.lastActiveTab); //MainForm.PageControl1.ActivePage as TMyTabSheet


  {*for i:=1 to MainForm.PageControl1.PageCount-1 do
  begin
    textBoxStringList.Add(MainForm.PageControl1.Pages[i].Caption);
    textBoxList.Add(MainForm.PageControl1.Pages[i] as TMyTabSheet);
  end; *}
end;

function TGUI.GetRichEditList: Variant;
begin
  LockGUI;
  with GetPythonEngine do
  begin
    ClearRefs;

    RefreshRichEditLists;

    pyTextBoxes := StringsToPyList(textBoxStringList);

    Result := PyObjectAsVariant(pyTextBoxes)
  end;
  UnlockGUI;
end;

function TGUI.AddToRichEdit(richedit : string; msg : string; color : integer): boolean;
var
  i: integer;
  r: TExRichEdit;
begin
  RefreshRichEditLists;

  i := textBoxStringList.IndexOf(richedit);

  if i = -1 then
    try
      r := GetComponentFromString(richedit) as TExRichEdit;
    except
      r := nil;
    end
  else
    r := textBoxList[i];

  Result := (i > -1) or (r <> nil);
  if Result then
  begin
    MsgList.BeginUpdate;
    RichEditList.Add(r);
    MsgList.Add(msg);
    MsgColor.Add(color);
    MsgList.EndUpdate;

    PostMessage(MainForm.Handle,WM_SCRIPT,0,0);
  end;
end;

constructor TGUI.Create;
begin
  menuIdInc :=1;
  FStackLayoutChanges := False;
  MenuItemList := TList.Create;
  textBoxStringList := TStringList.Create;
  textBoxList := TList.Create;
  ddMenuList := TList.Create;
  ddButtonList := TList.Create;
  ddControlList := TList.Create;

  with GetPythonEngine do
  begin
    pyProperties := Py_None;
    pyTextBoxes := Py_None;


    pyColors := PyDict_New();
    PyDict_SetItemStringDecRef(pyColors,'Normal',Colors.Normal);
    PyDict_SetItemStringDecRef(pyColors,'Data',Colors.Data);
    PyDict_SetItemStringDecRef(pyColors,'Error',Colors.Error);
    PyDict_SetItemStringDecRef(pyColors,'Info',Colors.Info);
    PyDict_SetItemStringDecRef(pyColors,'MinorInfo',Colors.MinorInfo);
    PyDict_SetItemStringDecRef(pyColors,'ChanJoin',Colors.ChanJoin);
    PyDict_SetItemStringDecRef(pyColors,'ChanLeft',Colors.ChanLeft);
    PyDict_SetItemStringDecRef(pyColors,'MOTD',Colors.MOTD);
    PyDict_SetItemStringDecRef(pyColors,'SayEx',Colors.SayEx);
    PyDict_SetItemStringDecRef(pyColors,'Topic',Colors.Topic);
    PyDict_SetItemStringDecRef(pyColors,'ClientAway',Colors.ClientAway);
    PyDict_SetItemStringDecRef(pyColors,'MapModUnavailable',Colors.MapModUnavailable);
    PyDict_SetItemStringDecRef(pyColors,'BotText',Colors.BotText);
    PyDict_SetItemStringDecRef(pyColors,'MyText',Colors.MyText);
    PyDict_SetItemStringDecRef(pyColors,'AdminText',Colors.AdminText);
    if SkinManager.GetSkinType=sknSkin then
    begin
      PyDict_SetItemStringDecRef(pyColors,'SkinEditBackground',SkinManager.CurrentSkin.Options(skncEditFrame).Body.Color1);
      PyDict_SetItemStringDecRef(pyColors,'SkinEditText',SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal));
    end
    else
    begin
      PyDict_SetItemStringDecRef(pyColors,'SkinEditBackground',clWindow);
      PyDict_SetItemStringDecRef(pyColors,'SkinEditText',clWindowText);
    end;
  end;
end;

function TGUI.GetFreeMenuId: integer;
begin
  Result := menuIdInc;
  Inc(menuIdInc);
end;

function TGUI.GetMenu(name: string): TTBCustomItem;
var
  i: integer;
  id: integer;
begin
  if name = 'HostBattle' then
    Result := MainForm.HostBattlePopupMenu.Items
  else if name = 'Options' then
    Result := MainForm.OptionsPopupMenu.Items
  else if name = 'Help' then
    Result := MainForm.HelpPopupMenu.Items
  else if name = 'HelpWiki' then
    Result := MainForm.SubMenuWiki
  else if name = 'HelpDownload' then
    Result := MainForm.SubMenuDownload
  else if name = 'BattleItem' then
    Result := MainForm.BattleListPopupMenu.Items
  else if name = 'PlayerItem' then
    Result := MainForm.ClientPopupMenu.LinkSubitems
  else if name = 'PlayerItemModeration' then
    Result := MainForm.ModerationSubmenuItem
  else if name = 'BattlePlayerItem' then
    Result := BattleForm.PlayerControlPopupMenu.Items
  else if name = 'BattleMinimap' then
    Result := BattleForm.AutoStartRectsPopupMenu.Items
  else if name = 'BattleAdmin' then
    Result := BattleForm.AdminPopupMenu.Items
  else if name = 'BattleAdminBalance' then
    Result := BattleForm.mnuBalanceSub
  else if name = 'BattleAdminRankLimit' then
    Result := BattleForm.mnuRankLimit
  else if name = 'ReplayItem' then
    Result := ReplaysForm.ReplayListPopupMenu.Items
  else if name = 'Chat' then
    Result := MainForm.RichEditPopupMenu.Items
  else
  begin
    id := 0;
    try id := StrToInt(name); except end;
    if id <> 0 then
    begin
      for i:=0 to MenuItemList.Count-1 do
        if PScriptMenuItem(MenuItemList[i]).id = id then
        begin
          Result := PScriptMenuItem(MenuItemList[i]).item;
          Exit;
        end;
    end
    else
    begin
      try
        Result := (GetComponentFromString(name) as TSpTBXPopupMenu).Items;
      except
        Result := nil ;
      end;
    end;
  end;
end;

procedure TGUI.AddSelectionArgs(m: PScriptMenuItemCallBack);
var
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  i: integer;
  menu: TTBCustomItem;
  pt: TPoint;
  ci,lix,co: integer;
begin
  with GetPythonEngine do
  begin
    menu := m.menu;
    while True do
      if menu = MainForm.BattleListPopupMenu.Items then
      begin
        if MainUnit.SelectedBattle = nil then
          PyList_SetItem(m.args,0,PyLong_FromLong(-1))
        else
          PyList_SetItem(m.args,0,PyLong_FromLong(MainUnit.SelectedBattle.ID));
        break;
      end
      else if (menu = MainForm.ClientPopupMenu.LinkSubitems) or (m.menu = MainForm.ModerationSubmenuItem) then
      begin
        PyList_SetItem(m.args,0,PyString_FromString(PChar(String(MainUnit.SelectedUserName))));
        break;
      end
      else if menu = BattleForm.PlayerControlPopupMenu.Items then
      begin
        BattleForm.GetNodeClient(BattleForm.VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
        PyList_SetItem(m.args,0,PyString_FromString(PChar(TClient(BattleState.Battle.Clients[RealIndex]).Name)));
        break;
      end
      else if menu = ReplaysForm.ReplayListPopupMenu.Items then
      begin
        PyList_SetItem(m.args,0,PyLong_FromLong(ReplayList.IndexOf(ReplaysForm.GetReplayFromNode(ReplaysForm.VDTReplays.FocusedNode))));
        break;
      end
      else if menu = MainForm.RichEditPopupMenu.Items then
      begin
        GetCursorPos(pt);
        with MainForm.richContextMenu do
        begin
          ci := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@(MainForm.richContextMenuClick))) ;
          if ci > -1 then
          begin
            lix := Perform(EM_EXLINEFROMCHAR, 0, ci) ;
            if lix < Lines.Count then
            begin
              co := ci - Perform(EM_LINEINDEX, lix, 0) ;
              if MainForm.richContextMenu = BattleForm.ChatRichEdit then
                PyList_SetItem(m.args,0,PyString_FromString('$battle'))
              else
                PyList_SetItem(m.args,0,PyString_FromString(PChar(MainForm.lastActiveTab.Caption)));
              PyList_SetItem(m.args,1,PyString_FromString(PChar(UTF8Encode(WideLines[lix]))));
              PyList_SetItem(m.args,2,PyLong_FromLong(co));
            end;
          end;
          PyList_SetItem(m.args,3,PyString_FromString(PChar(UTF8Encode(WideSelText))));
        end;
        break;
      end
      else
        if menu.Parent <> nil then
          menu := menu.Parent
        else
          break;
  end;
end;

procedure TGUI.MenuItemClick(Sender: TObject);
var
  s: string;
  i: integer;
  miCb : PScriptMenuItemCallBack;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    miCb := PScriptMenuItemCallBack(Pointer((Sender as TSpTBXItem).Tag));

    AddSelectionArgs(miCb);

    EvalPyFunction(miCb.func,PyList_AsTuple(miCb.args));
  end;
  ReleaseMainThread;
end;

function TGUI.AddItemToMenu(menu: string;compName: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string;itemCaption: string): Integer;
begin
  with GetPythonEngine do
    Result := AddItemToMenu2(callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)),menu,compName,itemCaption);
end;
function TGUI.AddItemToMenu2(callbackArgs: Variant; callbackFunction: Variant; menu: string;compName: string; itemCaption: string): Integer;
var
  m : TTBCustomItem;
  s: PPyObject;
  itemCb : PScriptMenuItemCallBack;
  item: PScriptMenuItem;
  i:integer;
begin
  Result := 0;
  m := GetMenu(menu);

  if m = nil then
  begin
    Print('AddItemToMenu incorrect `menu` for item : '+itemCaption);
    Exit;
  end;

  with GetPythonEngine do
  begin
    if not PyList_Check(VariantAsPyObject(callbackArgs)) then
    begin
      Print('AddItemToMenu incorrect `callInArgs` for item : '+itemCaption);
      Exit;
    end;

    m.Add(TSpTBXItem.Create(m.Owner));
    with m.Items[m.Count-1] as TSpTBXItem do
    begin
      if Owner.FindComponent(compName) = nil then
        Name := compName;
      Caption := itemCaption;
      OnClick := MenuItemClick;
      New(itemCb);
      itemCb.func := VariantAsPyObject(callbackFunction);
      itemCb.args := VariantAsPyObject(callbackArgs);

      // adding the selection empty args
      if m = MainForm.RichEditPopupMenu.Items then
      begin
        PyList_Insert(itemCb.args,0,PyString_FromString('')); // sel text
        PyList_Insert(itemCb.args,0,PyLong_FromLong(0)); // char pos in line
        PyList_Insert(itemCb.args,0,PyString_FromString('')); // line text
        PyList_Insert(itemCb.args,0,PyString_FromString('')); // chat name
      end
      else
        PyList_Insert(itemCb.args,0,PyLong_FromLong(0)); // item id
      itemCb.menu := m;
      Tag := Longint(itemCb);

      New(item);
      item.id := GetFreeMenuId;
      item.item := m.Items[m.Count-1];
      MenuItemList.Add(item);

      // drop down menu handler
      i := ddMenuList.IndexOf(m);
      if i > -1 then
      begin
        if TSpTBXPopupMenu(ddControlList[i]).Items.Count > 1 then
          TSpTBXButton(ddButtonList[i]).DropDownMenu := TSpTBXPopupMenu(ddControlList[i]);
      end;

      Result := item.id;
    end;
  end;
end;

function TGUI.AddSubmenuToMenu(menu: string; compName: string; itemCaption: string): Integer;
var
  m : TTBCustomItem;
  item: PScriptMenuItem;
begin
  Result := 0;
  m := GetMenu(menu);

  with GetPythonEngine do
  begin

    m.Add(TSpTBXSubmenuItem.Create(m.Owner));
    with m.Items[m.Count-1] as TSpTBXSubmenuItem do
    begin
      if Owner.FindComponent(compName) = nil then
        Name := compName;
      Caption := itemCaption;

      New(item);
      item.id := GetFreeMenuId;
      item.item := m.Items[m.Count-1];
      MenuItemList.Add(item);

      Result := item.id;
    end;
  end;
end;

function TGUI.AddSeparatorToMenu(menu: string;compName: string): Integer;
var
  m : TTBCustomItem;
  item: PScriptMenuItem;
begin
  Result := 0;
  m := GetMenu(menu);

  with GetPythonEngine do
  begin
    m.Add(TSpTBXSeparatorItem.Create(m.Owner));

    New(item);
    item.id := GetFreeMenuId;
    item.item := m.Items[m.Count-1];

    if item.item.Owner.FindComponent(compName) = nil then
      item.item.Name := compName;

    MenuItemList.Add(item);

    Result := item.id;
  end;
end;

procedure TGUI.SetMenuItemState(id: integer; c: boolean; e: boolean);
var
  i: integer;
begin
  for i:=0 to MenuItemList.Count-1 do
    if PScriptMenuItem(MenuItemList[i]).id = id then
    begin
      PScriptMenuItem(MenuItemList[i]).item.Checked := c;
      PScriptMenuItem(MenuItemList[i]).item.Enabled := e;
      Exit;
    end;
end;

procedure TGUI.StackLayoutChanges(b: boolean);
begin
  Self.FStackLayoutChanges := b;
end;

procedure TGUI.SynchronizedUpdate(callbackModuleName: string; callbackFunctionName: string;callbackArgs: Variant);
begin
  with GetPythonEngine do
    SynchronizedUpdate2(PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)),callbackArgs);
end;

procedure TGUI.SynchronizedUpdate2(callbackFunction: Variant;callbackArgs: Variant);
var
  ucb: PGUIUpdateCallback;
begin
  with GetPythonEngine do
  begin
    New(ucb);
    ucb.func := VariantAsPyObject(callbackFunction);
    ucb.args := PyList_AsTuple(VariantAsPyObject(callbackArgs));
    PostMessage(MainForm.Handle,WM_SCRIPT,6,Integer(ucb));
  end;
end;

procedure TGUI.SetBattleVisible(battleId: integer; bVisible: integer);
var
  battle: TBattle;
begin
  battle := MainForm.GetBattle(battleId);
  LockGUI;
  if battle <> nil then
    battle.ForcedHidden := bVisible = 0;
  MainForm.RefreshBattleList;
  UnlockGUI;
end;

procedure TGUI.SetUserDisplayName(userId: integer; displayName: string);
var
  client: TClient;
  i: integer;
begin
  LockGUI;
    client := MainForm.GetClientById(userId);
    if client <> nil then
    begin
      client.DisplayName := displayName;
      MainForm.SortClientInLists(client);
      if Preferences.BattleSortStyle = 5 then
      begin
        MainForm.SortBattleInList(client.GetBattleId,Preferences.BattleSortStyle,Preferences.BattleSortDirection=0);
        MainForm.RefreshBattlesNodes;
      end;
      if client.InBattle and BattleForm.IsBattleActive and (BattleState.Battle.Clients.IndexOf(client) > -1) and (Preferences.BattleClientSortStyle = 0) then
        BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
    end
    else
    begin
      TClient.SetDisplayName(userId,displayName);
    end;

  UnlockGUI;
end;

procedure TGUI.RemoveFromMenu(id: integer);
var
  i: integer;
  j: integer;
begin
  for i:=0 to MenuItemList.Count-1 do
    if PScriptMenuItem(MenuItemList[i]).id = id then
    begin
      // drop down menu handler (if the button's menu is going to have only 1item then we the menu)
      j := ddMenuList.IndexOf(PScriptMenuItemCallBack(Pointer(PScriptMenuItem(MenuItemList[i]).item.Tag)).menu);
      if (j > -1) and (TSpTBXPopupMenu(ddControlList[j]).Items.Count <= 2) then
        TSpTBXButton(ddButtonList[j]).DropDownMenu := nil;

      FreeMemory(PScriptMenuItemCallBack(Pointer(PScriptMenuItem(MenuItemList[i]).item.Tag)));
      PScriptMenuItem(MenuItemList[i]).item.Destroy;
      FreeMemory(PScriptMenuItem(MenuItemList[i]));
      MenuItemList.Delete(i);

      Exit;
    end;
end;

procedure TGUI.DisplaySimpleNotification(title: string; msg: string; displayTime: integer);
var
  N : TJvDesktopAlert;
begin
 N := MainForm.MakeNotification(title,msg,displayTime,False);
 MainForm.ExecuteNotification(N);
end;

procedure TGUI.DisplayNotification(title: string; msg: string; callbackArgs: Variant; callbackModuleName: string; callbackFunctionName: string; displayTime: integer);
begin
  with GetPythonEngine do
    DisplayNotification2(callbackArgs,PyObjectAsVariant(FindFunction(callbackModuleName,callbackFunctionName)),title,msg,displayTime);
end;

procedure TGUI.DisplayNotification2(callbackArgs: Variant; callbackFunction: Variant;title: string; msg: string; displayTime: integer);
var
  snc : PScriptSimpleCallback;
  N : TJvDesktopAlert;
begin
  N := MainForm.MakeNotification(title,msg,displayTime,True);
  N.OnMessageClick := SimpleCallbackEvent;
  New(snc);
  snc.func := GetPythonEngine.VariantAsPyObject(callbackFunction);
  snc.args := GetPythonEngine.VariantAsPyObject(callbackArgs);
  N.Tag := Longint(snc);
  MainForm.ExecuteNotification(N);
end;

procedure TGUI.SimpleCallbackEvent(Sender: TObject);
var
  snc : PScriptSimpleCallback;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    snc := PScriptSimpleCallback(Pointer((Sender as TComponent).Tag));

    EvalPyFunction(snc.func,PyList_AsTuple(snc.args));
  end;
  ReleaseMainThread;
end;

function TGUI.GetControlProperties(component: string; prop: string): Variant;
var
  c : TComponent;
  o: TObject;
  i,j : integer;
  propNames : TStringList;
  propValues : TList;
  propTypes: TStringList;
  propSl: TStringList;
  pyList: PPyObject;
begin
  Result := GetPythonEngine.PyObjectAsVariant(GetPythonEngine.Py_None);
  try
    c := GetComponentFromString(component) as TComponent;
  except
    Exit;
  end;

  if c = nil then Exit;

  LockGUI;
  with GetPythonEngine do
  begin
    ClearRefs;
    pyProperties := PyDict_New();


    propNames := TStringList.Create;
    propValues := TList.Create;
    propTypes := TStringList.Create;
    propSl := TStringList.Create;

    Misc.ParseDelimited(propSl,prop,'.','');

    o := c;
    while (propSl.Count > 0) and (prop <> '') do
    begin
      Misc.GetProperties(o,propNames,propValues,propTypes);
      if (propSl.Count > 0) and (prop <> '') then
      begin
        for i := 0 to propNames.Count-1 do
          if propNames[i] = propSl[0] then
            break;
        if (i >= propNames.Count) and (propNames[i] <> propSl[0]) then
        begin
          UnlockGUI;
          Exit;
        end;

        o := TObject(propValues[i]);
      end;
      propSl.Delete(0);
    end;
    Misc.GetProperties(o,propNames,propValues,propTypes);

    for i := 0 to propNames.Count-1 do
      if propTypes[i] = 'tkClass' then
        if TObject(propValues[i]) is TWideStrings then
        begin
          pyList := PyList_New(TWideStrings(propValues[i]).Count);
          for j:=0 to TWideStrings(propValues[i]).Count-1 do
            PyList_SetItem(pyList,j,PyString_FromString(PChar(String(TWideStrings(propValues[i]).Strings[j]))));
          PyDict_SetItemString(pyProperties,PChar(propNames[i]),pyList);
          Py_XDECREF(pyList);
        end
        else
          PyDict_SetItemStringDecRef(pyProperties,PChar(propNames[i]),TObject(propValues[i]).ClassName)
      else
        PyDict_SetItemStringDecRef(pyProperties,PChar(propNames[i]),Variant(propValues[i]^));

    if c is TControl then
      PyDict_SetItemStringDecRef(pyProperties,'Parent',GetStringFromComponent(c.GetParentComponent));

    Result := PyObjectAsVariant(pyProperties);
  end;
  UnlockGUI;
end;

function TGUI.SetControlProperties(component: string; prop : string; propertiesV : Variant): boolean;
var
  c : TComponent;
  o: TObject;
  properties: PPyObject;
  keys,values : PPyObject;
  key: string;
  value : Variant;
  parent: string;
  i,j: integer;

  propNames : TStringList;
  propValues : TList;
  propTypes: TStringList;
  propSl: TStringList;

  tmpSl: TStringList;

  p: TProperty;

  mtReleased: Boolean;
begin
  Result := False;

  try
    c := GetComponentFromString(component) as TComponent;
  except
    Print('SetControlProperties error : component "'+component+'" not found');
    Exit;
  end;

  if c = nil then
  begin
    Print('SetControlProperties error : component "'+component+'" not found');
    Exit;
  end;
  mtReleased := ReleaseMainThread;
  LockGUI;
  try
    Result := True;
    with GetPythonEngine do
    begin
      properties := VariantAsPyObject(propertiesV);

      if not PyDict_Check(properties) then
      begin
        UnlockGUI;
        AcquireMainThread;
        Exit;
      end;

      keys := PyDict_Keys(properties);
      values := PyDict_Values(properties);

      propNames := TStringList.Create;
      propValues := TList.Create;
      propTypes := TStringList.Create;
      propSl := TStringList.Create;

      Misc.ParseDelimited(propSl,prop,'.','');

      o := c;
      while (propSl.Count > 0) and (prop <> '') do
      begin
        Misc.GetProperties(o,propNames,propValues,propTypes);
        if (propSl.Count > 0) and (prop <> '') then
        begin
          for i := 0 to propNames.Count-1 do
            if propNames[i] = propSl[0] then
              break;
          if (i >= propNames.Count) and (propNames[i] <> propSl[0]) then
          begin
            UnlockGUI;
            AcquireMainThread;
            Exit;
          end;

          o := TObject(propValues[i]);
        end;
        propSl.Delete(0);
      end;
      Misc.GetProperties(o,propNames,propValues,propTypes);

      parent := '';
      for i:=0 to PyList_Size(keys)-1 do
      begin
        key := PyString_AsString(PyList_GetItem(keys,i));
        value := PyObjectAsVariant(PyList_GetItem(values,i));
        j := propNames.IndexOf(key);
        if (LowerCase(key) <> 'parent') and (j > -1) then
        begin
          if (propTypes[j] <> 'tkClass') then
          begin
            p := TProperty.Create(key,Variant(propValues[j]^),o);
            if Self.FStackLayoutChanges and (c is TControl) then
              CustomizeGUIForm.AddToHistory(p,value,prop,TControl(c));
            try
              SetProperty(o,key,value);
            except
              Result := False;
            end;
            p.Free;
          end
          else if propValues[j] <> nil then
          if (propTypes[j] = 'tkClass') and (TObject(propValues[j]).ClassType = TBitmap32) then
          begin
            TBitmap32(propValues[j]).LoadFromFile(value);
          end
          else if (propTypes[j] = 'tkClass') and (TObject(propValues[j]).ClassType = TPicture) then
          begin
            LoadPictureWithDevIL(value,TPicture(propValues[j]));
          end
          else if (propTypes[j] = 'tkClass') and (TObject(propValues[j]).ClassType = TBitmap) then
          begin
            if FileExists(value) then
              LoadPictureWithDevIL(value,TBitmap(propValues[j]));
          end
          else
            if TObject(propValues[j]) is TWideStrings then
              try
                tmpSl := TStringList.Create;
                GetPythonEngine.PyListToStrings(PyList_GetItem(values,i),tmpSl);
                TWideStrings(propValues[j]).Clear;
                TWideStrings(propValues[j]).AddStrings(tmpSl);
                tmpSl.Free;
              except
              end;
        end;
        if (LowerCase(key) = 'parent') then
          parent := String(value);
      end;
    end;

    if (prop = '') and (parent <> '') and (c is TControl) then
    begin
      // special case for pagecontrol
      if TControl(c).Parent.ClassType = TPageControl then
      begin
        if TPageControl(TControl(c).Parent).ActivePage = c then
          TPageControl(TControl(c).Parent).ActivePage := TPageControl(TControl(c).Parent).Pages[0];
      end;

      p := TProperty.Create('Parent',GetStringFromComponent(TControl(c).Parent),o);
      if Self.FStackLayoutChanges then
        CustomizeGUIForm.AddToHistory(p,parent,prop,TControl(c));
      p.Free;
      TControl(c).Parent := GetComponentFromString(parent) as TWinControl;
    end;

    if c is TControl then
      TControl(c).Invalidate;
  except
    Result := False;
  end;
  UnlockGUI;
  if mtReleased then
    AcquireMainThread;
end;


function TGUI.AddControl(name: string;parent: string; className: string):boolean;
var
  classV: TPersistentClass;
  control: TWinControl;
  parentC: TWinControl;
begin
  try
    parentC := GetComponentFromString(parent) as TWinControl;
    classV := GetClass(className);
    control := TWinControlClass(classV).Create(parentC);
    control.Parent := parentC;
    control.Name := name;
    Result := True;
    if Self.FStackLayoutChanges then
      CustomizeGUIForm.history.Add(THistoryItemControl.Create(control));
  except
    Result := False;
  end;
end;

procedure TGUI.DeleteControl(name: string);
var
  c : TWinControl;
begin
  try
    c := GetComponentFromString(name) as TWinControl;
    if c.ClassType = TSpTBXTabSheet then
      TSpTBXTabSheet(c).Item.Destroy;
    c.Destroy;
  except
  end;
end;

function TGUI.AddTab(caption: string;name: string;tabsPanel : string):boolean;
var
  p: TSpTBXTabControl;
begin
  try
    p := GetComponentFromString(tabsPanel) as TSpTBXTabControl;
    p.Add(caption);
    p.Pages[p.PagesCount-1].Name := name;
    Result := True;
    if Self.FStackLayoutChanges then
      CustomizeGUIForm.history.Add(THistoryItemTab.Create( p.Pages[p.PagesCount-1],p));
  except
    Result := False;
  end;
end;

procedure TGUI.ManualDock(component: string; dockDest: string);
begin
  TWinControl(GetComponentFromString(component)).ManualDock(TWinControl(GetComponentFromString(dockDest)),nil,alBottom);
end;

function TGUI.AddForm(name: string;caption: string; style: integer; dockableForm: boolean):boolean;
var
  f1: TScriptForm;
  f2: TDockableForm;
begin
  try
    if dockableForm then
    begin
      f2 := TDockableForm.CreateNew(Application,0);
      f2.Name := name;
      f2.Caption := caption;
      if not MainForm.mnuLockView.Checked then
      begin
        f2.DragKind := dkDock;
        f2.DragMode := dmAutomatic;
      end;

      case style of
        0: f2.BorderStyle := bsNone;
        1: f2.BorderStyle := bsSingle;
        2: f2.BorderStyle := bsSizeable;
        3: f2.BorderStyle := bsDialog;
        4: f2.BorderStyle := bsToolWindow;
        5: f2.BorderStyle := bsSizeToolWin;
      end;
      //f2.Show;
      f2.Visible := False;
      f2.Top := 0;
      f2.Left := 0;
      Result := True;
      if Self.FStackLayoutChanges then
        CustomizeGUIForm.history.Add(THistoryItemForm.Create(f2,dockableForm));
    end
    else
    begin
      f1 := TScriptForm.CreateNew(Application,0);
      f1.Name := name;
      f1.Caption := caption;

      case style of
        0: f1.BorderStyle := bsNone;
        1: f1.BorderStyle := bsSingle;
        2: f1.BorderStyle := bsSizeable;
        3: f1.BorderStyle := bsDialog;
        4: f1.BorderStyle := bsToolWindow;
        5: f1.BorderStyle := bsSizeToolWin;
      end;
      //f1.Show;
      f1.Visible := False;
      f1.Top := 0;
      f1.Left := 0;
      Result := True;
      if Self.FStackLayoutChanges then
        CustomizeGUIForm.history.Add(THistoryItemForm.Create(f1,dockableForm));
    end;
  except
    Result := False;
  end;
end;

function TGUI.AddDropDownButton(caption: string; buttonName: string;menuName: string; parent: string): boolean;
var
  button: TSpTBXButton;
  menu: TSpTBXPopupMenu;
  parentC: TWinControl;
begin
  try
    parentC := GetComponentFromString(parent) as TWinControl;
    button := TSpTBXButton.Create(parentC);
    button.Parent := parentC;
    button.Name := buttonName;
    button.Caption := caption;
    button.OnClick := onDropDownButtonClick;

    menu := TSpTBXPopupMenu.Create(parentC);
    menu.Name := menuName;

    ddMenuList.Add(menu.Items);
    ddButtonList.Add(button);
    ddControlList.Add(menu);

    Result := True;
  except
    Result := False;
  end;
end;
procedure TGUI.onDropDownButtonClick(Sender: TObject);
var
  i:integer;
begin
  i := ddButtonList.IndexOf(Sender);
  if TSpTBXButton(Sender).DropDownMenu = nil then
    if TSpTBXPopupMenu(ddControlList[i]).Items.Count > 0 then
      TSpTBXPopupMenu(ddControlList[i]).Items.Items[0].Click;
end;

procedure TGUI.LockGUI;
begin
  GUICS.Enter;
end;
procedure TGUI.UnlockGUI;
begin
  GUICS.Leave;
end;

procedure TGUI.AddOrReplaceIconList(iconListName: string; icons: Variant);
var
  iconsDict : PPyObject;
  keys : PPyObject;
  keysStr: TStringList;
  key : PPyObject;
  i,j,k: integer;
  iconData : PPyObject;

  lcName: string;

  iconTypeNames: TStringList;

  imgL: TImageList;
  icon: TBitmap;

  JPG: TJPEGImage;
  PNG: TPNGObject;

  ImgExt: string;

  newIconSet: Boolean;
begin
  try
  JPG := TJPEGImage.Create;
  PNG := TPNGObject.Create;
  with GetPythonEngine do
  begin
    iconsDict := VariantAsPyObject(icons);
    if not PyDict_Check(iconsDict) then
    begin
      Print('AddOrReplaceIconList error : second parameter is not a valid python dictionary.');
      Exit;
    end;

    keys := PyDict_Keys(iconsDict);
    keysStr := TStringList.Create;
    PyListToStrings(keys,keysStr);

    newIconSet := False;

    lcName := LowerCase(iconListName);

    if lcName = 'rank' then
     imgL := MainForm.RanksImageList
    else if lcName = 'connectionstate' then
     imgL := MainForm.ConnectionStateImageList
    else if lcName = 'playerstate' then
     imgL := MainForm.PlayerStateImageList
    else if lcName = 'syncstate' then
     imgL := MainForm.SyncImageList
    else if lcName = 'battlestate' then
     imgL := MainForm.BattleStatusImageList
    else if lcName = 'readystate' then
     imgL := MainForm.ReadyStateImageList
    else if lcName = 'arrow' then
     imgL := MainForm.ArrowList
    else
    begin
      newIconSet := True;
      imgL := TImageList.Create(MainForm);
      iconTypeNames := TStringList.Create;
    end;

    imgL.Clear;

    for i:=0 to PyDict_Size(iconsDict)-1 do
    begin
      key := PyList_GetItem(keys,keysStr.IndexOf(IntToStr(i)));;
      iconData := PyDict_GetItem(iconsDict,key);

      icon := TBitmap.Create;
      if FileExists(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File')))) then
      begin
        ImgExt := LowerCase(ExtractFileExt(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File')))));
        if ImgExt = '.png' then
        begin
          PNG.LoadFromFile(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File'))));
          icon.Assign(PNG);
        end
        else if (ImgExt = '.jpg') or (ImgExt = '.jpeg') then
        begin
          JPG.LoadFromFile(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File'))));
          icon.Assign(JPG);
        end
        else
          icon.LoadFromFile(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File'))));
      end
      else
        Print('Icon file "'+PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('File')))+'" not found.');

      imgL.Width := icon.Width;
      imgL.Height := icon.Height;
      imgL.AddMasked(icon,PyLong_AsLong(PyDict_GetItem(iconData,PyString_FromString('MaskColor'))));

      if newIconSet then
        iconTypeNames.Add(PyString_AsString(PyDict_GetItem(iconData,PyString_FromString('Name'))));
    end;
  end;

  if newIconSet then
  begin
    for i:=0 to MainUnit.AllClients.Count-1 do
      TClient(MainUnit.AllClients[i]).AddNewCustomIcon;

    PlayerIconTypeNames.Add(iconListName);
    PlayerIconTypeIconsNames.Add(iconTypeNames);
    PlayerIconTypeIcons.Add(imgL);
  end;
  except
    Print('AddOrReplaceIconList failed.');
  end;
end;
procedure TGUI.SetPlayerIconId(playerName: string; iconTypeName: string; iconId: integer);
begin
  MainForm.GetClient(playerName).SetCustomIconId(PlayerIconTypeNames.IndexOf(iconTypeName),iconId);
end;

procedure TGUI.Print(data : string);
begin
  PythonScriptDebugFormUnit.printList.BeginUpdate;
  PythonScriptDebugFormUnit.printList.Add(data);
  PythonScriptDebugFormUnit.printList.EndUpdate;
  PostMessage(PythonScriptDebugForm.Handle, WM_REFRESHOUTPUT, 0, 0);
end;

procedure TGUI.AddEvent(component: string; event: string;moduleName: string; functionName: string);
begin
  with GetPythonEngine do
    AddEvent2(component,event,PyObjectAsVariant(FindFunction(moduleName,functionName)));
end;

procedure TGUI.AddEvent2(component: string; event: string;callbackFunction: Variant);
var
  comp: TComponent;
  callable: PPyObject;
  eh: ^TScriptEventHandler;
  m: TMethod;
  func: PPyObject;
begin
  comp := GetComponentFromString(component);
  if comp = nil then
  begin
    Print('AddEvent2 error : component "'+component+'" not found');
    Exit;
  end;

  New(eh);
  func := GetPythonEngine.VariantAsPyObject(callbackFunction);
  if GetPerpertyInfo(comp,event).PropType^.Name = 'TWebBrowserBeforeNavigate2' then
  begin
    eh^ := TScriptEventHandlerTWebBrowserBeforeNavigate2.Create(func);
    m.Code := TScriptEventHandlerTWebBrowserBeforeNavigate2(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else if GetPerpertyInfo(comp,event).PropType^.Name = 'TNotifyEvent' then
  begin
    eh^ := TScriptEventHandlerDefault.Create(func);
    m.Code := TScriptEventHandlerDefault(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else if GetPerpertyInfo(comp,event).PropType^.Name = 'TMouseEvent' then
  begin
    eh^ := TScriptEventHandlerTMouseEvent.Create(func);
    m.Code := TScriptEventHandlerTMouseEvent(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else if GetPerpertyInfo(comp,event).PropType^.Name = 'TMouseMoveEvent' then
  begin
    eh^ := TScriptEventHandlerTMouseMoveEvent.Create(func);
    m.Code := TScriptEventHandlerTMouseMoveEvent(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else if GetPerpertyInfo(comp,event).PropType^.Name = 'TKeyEvent' then
  begin
    eh^ := TScriptEventHandlerTKeyEvent.Create(func);
    m.Code := TScriptEventHandlerTKeyEvent(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else if GetPerpertyInfo(comp,event).PropType^.Name = 'TKeyPressEvent' then
  begin
    eh^ := TScriptEventHandlerTKeyPressEvent.Create(func);
    m.Code := TScriptEventHandlerTKeyPressEvent(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end
  else
  begin // default event handler
    eh^ := TScriptEventHandlerDefault.Create(func);
    m.Code := TScriptEventHandlerDefault(eh^).MethodAddress('eventHandler');
    m.Data := Pointer(eh^);
    SetMethodProp(comp,event,m);
  end;
    //raise Exception.Create('That kind of event is not handled: '+GetPerpertyInfo(comp,event).PropType^.Name);
  
end;

function TGUI.ExecMethod(component: string;methodName: string; parameters: Variant): integer;
var
  comp: TComponent;
  paramsPyO: PPyObject;
  paramList: TList;
  item: PPyObject;
  i : integer;
  vI: ^integer;
  vS: ^string;
  vC: TComponent;
  vD: ^double;
  vP: ^Pointer;

  tmpStr: string;

  m: TMethod;
  l: TList;

  freeList: TList;

  mtReleased: Boolean;
begin
  Result := -1;
  comp := GetComponentFromString(component);
  if comp = nil then
    Exit;

  m.Code := comp.MethodAddress(methodName);
  m.Data := comp;

  if m.Code = nil then
    Exit;

  l := TList.Create;
  freeList := TList.Create;

  with GetPythonEngine do
  begin
    paramsPyO := VariantAsPyObject(parameters);
    if not PyList_Check(paramsPyO) then
    begin
      Print('ExecMethod error : parameters is not a valid python list.');
      Exit;
    end;

    for i:=0 to PyList_Size(paramsPyO)-1 do
    begin
      item := PyList_GetItem(paramsPyO,i);
      if PyFloat_Check(item) then
      begin
        New(vD);
        vD^ := PyFloat_AsDouble(item);
        l.Add(vD);
        freeList.Add(vD);
      end
      else if PyNumber_Check(item) <> 0 then
      begin
        New(vI);
        vI^ := PyLong_AsLong(item);
        l.Add(vI);
      end
      else if PyString_Check(item) then
      begin
        tmpStr := PyString_AsString(item);
        vC := GetComponentFromString(tmpStr);
        if vC <> nil then
        begin
          l.Add(@vC);
        end
        else
        begin
          New(vS);
          SetLength(vS^,Length(tmpStr));
          vS^ := Copy(tmpStr,0,Length(tmpStr));
          l.Add(vS);
          freeList.Add(vS);
        end;
      end
      else if item = Py_None then
      begin
        l.Add(nil);
      end;
    end;
  end;

  mtReleased := ReleaseMainThread;
  Result := Misc.CallFunction(m,l);
  if mtReleased then
    AcquireMainThread;

  for i:=0 to freeList.Count-1 do
    Dispose(freeList[i]);

  freeList.Free;
end;

procedure TGUI.EventHandler(Sender: TObject);
begin
  MainForm.AddMainLog('youpie',clBlack);
end;

//------------------------------------------------------------------------------------------------------
//    TPyCallback
//------------------------------------------------------------------------------------------------------

// We override the constructors

constructor TPyCallback.Create( APythonType : TPythonType );
begin
  inherited;

  DelphiObject := TCallback.Create;
  Owned := True; // We own the objects we create
end;

constructor TPyCallback.CreateWith( PythonType : TPythonType; args : PPyObject );
begin
  inherited;
end;

class function TPyCallback.DelphiObjectClass: TClass;
begin
  Result := TCallback;
end;

function  TPyCallback.Repr : PPyObject;
begin
  with GetPythonEngine, DelphiObject as TCallback do
    Result := VariantAsPyObject('Lobby script API');
end;

//------------------------------------------------------------------------------------------------------
//    TPyGUI
//------------------------------------------------------------------------------------------------------

constructor TPyGUI.Create( APythonType : TPythonType );
begin
  inherited;

  DelphiObject := TGUI.Create;
  Owned := True; // We own the objects we create
end;

constructor TPyGUI.CreateWith( PythonType : TPythonType; args : PPyObject );
begin
  inherited;
end;

class function TPyGUI.DelphiObjectClass: TClass;
begin
  Result := TGUI;
end;

function  TPyGUI.Repr : PPyObject;
begin
  with GetPythonEngine, DelphiObject as TGUI do
    Result := VariantAsPyObject('Lobby GUI API');
end;

//------------------------------------------------------------------------------------------------------
//    TScriptThread
//------------------------------------------------------------------------------------------------------

constructor TScriptThread.Create(fName: string; tup: Variant);
begin
  tuple := TStringList.Create;

  functionName := fName;
  with GetPythonEngine do
    PyListToStrings(VariantAsPyObject(tup),tuple);

  InterpreterState := MainInterpreterState;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TScriptThread.ExecuteWithPython;
var
  t: PPyObject;
begin
  try
    with GetPythonEngine do
    begin
      t := StringsToPyTuple(tuple);
      handlers.handleThread(functionName,PyObjectAsVariant(t));
    end;

  except
    on E: Exception do
    begin
      PythonScriptDebugForm.Output.Lines.BeginUpdate;
      PythonScriptDebugForm.Output.Lines.Add('');
      PythonScriptDebugForm.Output.Lines.Add('Error while calling handleThread :'+E.Message);
      PythonScriptDebugForm.Output.Lines.Add('----------------------------------');
      JclLastExceptStackList.AddToStrings(PythonScriptDebugForm.Output.Lines, False, True, True);
      PythonScriptDebugForm.Output.Lines.Add('----------------------------------');
      PythonScriptDebugForm.Output.Lines.Add('');
      PythonScriptDebugForm.Output.Lines.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------------------------------
//    procedures
//------------------------------------------------------------------------------------------------------

procedure DebugPrint(s: string);
begin
  PythonScriptDebugFormUnit.printList.BeginUpdate;
  PythonScriptDebugFormUnit.printList.Add(s);
  PythonScriptDebugFormUnit.printList.EndUpdate;
  PostMessage(PythonScriptDebugForm.Handle, WM_REFRESHOUTPUT, 0, 0);
end;

// i have no idea why this works but it works :D
function AcquireMainThread:boolean;
begin
  Result := False;
  if Preferences.ScriptsDisabled or not ScriptsInitialized then Exit;
  if GetCurrentThreadId <> MainThreadID then Exit;
  Result := True;
  if MainThreadFocused then Exit;
  MainThreadFocused := True;
  GetPythonEngine.PyEval_AcquireThread(MainThreadState);
  Result := True;
end;

procedure PostMsgs;
var
  i : integer;
begin
  for i:=0 to MsgList.Count -1 do
  begin
      if RichEditList[i] = nil then // battleform
        BattleForm.AddTextToChat(MsgList[i],MsgColor.Items[i],0)
      else
        if TObject(RichEditList[i]).ClassType = TExRichEdit then
          Misc.AddTextToRichEdit(TExRichEdit(RichEditList[i]),MsgList[i],MsgColor.Items[i],True,0)
        else
          MainForm.AddTextToChatWindow(TMyTabSheet(RichEditList[i]),MsgList[i],MsgColor.Items[i] );
  end;
  MsgList.BeginUpdate;
  MsgList.Clear;
  RichEditList.Clear;
  MsgColor.Clear;
  MsgList.EndUpdate;
end;

function ReleaseMainThread: Boolean;
var
  i: integer;
begin
  Result := False;
  if Preferences.ScriptsDisabled or not ScriptsInitialized then Exit;
  if GetCurrentThreadId <> MainThreadID then Exit;
  if not MainThreadFocused then Exit;
  GetPythonEngine.PyEval_ReleaseThread(MainThreadState);
  Result := True;
  MainThreadFocused := False;
end;

procedure PyDict_SetItemStringDecRef(dp: PPyObject; Key: PAnsiChar; const V : Variant);
var
  o: PPyObject;
  k: PPyObject;
begin
  with GetPythonEngine do
  begin
    o := VariantAsPyObject(V);
    k := PyString_FromString(Key);
    PyDict_SetItem(dp,k,o);
    Py_XDECREF(o);
    Py_XDECREF(k);
  end;
end;

procedure PyDict_SetItemDecRef(dp: PPyObject; Key: PPyObject; const V : Variant);
var
  o: PPyObject;
begin
  with GetPythonEngine do
  begin
    o := VariantAsPyObject(V);
    PyDict_SetItem(dp,Key,o);
    Py_XDECREF(o);
  end;
end;

procedure PyDict_SetItemStringIncRef(dp: PPyObject; Key: PAnsiChar; o : PPyObject);
begin
  with GetPythonEngine do
  begin
    PyDict_SetItemString(dp,Key,o);
    Py_XINCREF(o);
  end;
end;

procedure PyDict_SetItemIncRef(dp: PPyObject; Key: PPyObject; o : PPyObject);
begin
  with GetPythonEngine do
  begin
    PyDict_SetItem(dp,Key,o);
    Py_XINCREF(o);
  end;
end;

procedure PyList_AppendDecRef(list: PPyObject; const item : Variant);
var
  o: PPyObject;
begin
  with GetPythonEngine do
  begin
    o := VariantAsPyObject(item);
    PyList_Append(list,o);
    Py_XDECREF(o);
  end;
end;

function PyListFromStrings(sl: TStrings):PPyObject;
var
  i:integer;
begin
  with GetPythonEngine do
  begin
    Result := PyList_New(0);
    for i:=0 to sl.Count-1 do
    begin
      PyList_AppendDecRef(Result, sl[i]);
    end;
  end;
end;

function PyListFromWideStrings(sl: TWideStrings):PPyObject;
var
  i:integer;
begin
  with GetPythonEngine do
  begin
    Result := PyList_New(0);
    for i:=0 to sl.Count-1 do
    begin
      PyList_AppendDecRef(Result, sl[i]);
    end;
  end;
end;

procedure SafeDecRef(var o : PPyObject);
begin
  //try
    if (o <> nil) then
    begin
      GetPythonEngine.Py_XDECREF(o);
      o := nil;
    end;
  //except
  //end;
end;

function GetComponentFromString(component: string): TComponent;
var
  c: TComponent;
  componentList: TStringList;
  i: integer;
begin
  Result := nil;
  componentList := TStringList.Create;

  ParseDelimited(componentList,component,'.','');

  if componentList.Count = 0 then
    Exit;

  c := Application;
  for i:=0 to componentList.Count-1 do
    c := c.FindComponent(componentList[i]);

  Result := c;
end;

function GetStringFromComponent(component : TComponent): string;
var
  c : TComponent;
  sl: TStringList;
begin
  if component = nil then
  begin
    Result := '';
    Exit;
  end;
  
  sl := TStringList.Create;
  c := component;

  sl.Add(c.Name);
  while c.Owner.ClassType <> TApplication do
  begin
    sl.Insert(0,c.Owner.Name);
    c := c.Owner;
  end;

  Result := JoinStringList(sl,'.');
end;

procedure JoinBattle;
begin
  MainForm.JoinBattle(MainForm.GetBattle(JoinBattleId),JoinBattleSpectator,JoinBattlePassword);
  ScriptJoining := False;
end;

procedure HostBattle;
begin
  HostBattleForm.HostButtonClick(HostBattleForm.HostButton);
  Misc.ShowAndSetFocus(BattleForm.InputEdit);
  ScriptHostingRunning := False;
  ScriptHostingReplayRunning := False;
end;

procedure ChangeMap;
begin
  BattleForm.ChangeMap(ChangeMapIndex);
  if BattleState.Status = Hosting then
    BattleForm.SendBattleInfoToServer;
end;

procedure StartDownloads;
var
  i: integer;
  dlInfo: PFileDownloadInfo;
begin
  for i:=0 to MapDownloadList.Count-1 do
  begin
    dlInfo := MapDownloadList[i];
    SpringDownloaderFormUnit.DownloadMap(0,dlInfo.name,False,dlInfo.params,dlInfo.cb);
    FreeMemory(dlInfo);
  end;
  MapDownloadList.Clear;
  for i:=0 to ModDownloadList.Count-1 do
  begin
    dlInfo := ModDownloadList[i];
    SpringDownloaderFormUnit.DownloadMod(0,dlInfo.name,false,0,dlInfo.params,dlInfo.cb);
    FreeMemory(dlInfo);
  end;
  ModDownloadList.Clear;
  for i:=0 to RapidDownloadList.Count-1 do
  begin
    dlInfo := RapidDownloadList[i];
    SpringDownloaderFormUnit.DownloadRapid(dlInfo.name,false,'',dlInfo.params,dlInfo.cb);
    FreeMemory(dlInfo);
  end;
  RapidDownloadList.Clear;
  for i:=0 to EngineDownloadList.Count-1 do
  begin
    dlInfo := EngineDownloadList[i];
    SpringDownloaderFormUnit.DownloadEngine(dlInfo.engineName,dlInfo.engineVersion,false,0,dlInfo.params,dlInfo.cb);
    FreeMemory(dlInfo);
  end;
  EngineDownloadList.Clear;
end;

//------------------------------------------------------------------------------------------------------
//    TScriptForm
//------------------------------------------------------------------------------------------------------

procedure TScriptForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;


//------------------------------------------------------------------------------------------------------
//    TScriptEventHandler TScriptEventHandlerDefault TScriptEventHandlerOnBeforeNavigate2
//------------------------------------------------------------------------------------------------------

constructor TScriptEventHandler.Create(func: PPyObject);
begin
  Ffunc := func;
end;
function TScriptEventHandler.wrapEvent(args: PPyObject): Variant;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    Result := False;
    try
      Result := EvalPyFunction(Ffunc,args);
    except
      on E:Exception do
      begin
        PythonScriptDebugFormUnit.printList.BeginUpdate;
        PythonScriptDebugFormUnit.printList.Add(E.Message);
        PythonScriptDebugFormUnit.printList.EndUpdate;
        PostMessage(PythonScriptDebugForm.Handle, WM_REFRESHOUTPUT, 0, 0);
      end;
    end;
  end;
  ReleaseMainThread;
end;
procedure TScriptEventHandlerTWebBrowserBeforeNavigate2.eventHandler(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,  Headers: OleVariant; var Cancel: WordBool);
var
  args: PPyObject;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    args := PyTuple_New(4);
    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));
    PyTuple_SetItem(args,1,PyString_FromString(PChar(Misc.VariantToString(PostData))));
    PyTuple_SetItem(args,2,PyString_FromString(PChar(Misc.VariantToString(TargetFrameName))));
    PyTuple_SetItem(args,3,PyString_FromString(PChar(URLDecode(URL))));

    try
      Cancel := wrapEvent(args);
    except
    end;
  end;
  ReleaseMainThread;
end;
procedure TScriptEventHandlerDefault.eventHandler(Sender: TObject);
var
  args: PPyObject;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    args := PyTuple_New(1);
    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));

    wrapEvent(args);
  end;
  ReleaseMainThread;
end;

procedure TScriptEventHandlerTMouseEvent.eventHandler(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  args: PPyObject;
begin
  with GetPythonEngine do
  begin
    args := PyTuple_New(5);

    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));
    PyTuple_SetItem(args,1,PyLong_FromLong(Integer(Button)));
    PyTuple_SetItem(args,2,ShiftToPython(Shift));
    PyTuple_SetItem(args,3,PyLong_FromLong(X));
    PyTuple_SetItem(args,4,PyLong_FromLong(Y));

    wrapEvent(args);
  end;
end;

procedure TScriptEventHandlerTMouseMoveEvent.eventHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  args: PPyObject;
begin
  with GetPythonEngine do
  begin
    args := PyTuple_New(4);

    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));
    PyTuple_SetItem(args,1,ShiftToPython(Shift));
    PyTuple_SetItem(args,2,PyLong_FromLong(X));
    PyTuple_SetItem(args,3,PyLong_FromLong(Y));

    wrapEvent(args);
  end;
end;

procedure TScriptEventHandlerTKeyEvent.eventHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  args: PPyObject;
begin
  with GetPythonEngine do
  begin
    args := PyTuple_New(3);

    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));
    PyTuple_SetItem(args,1,ShiftToPython(Shift));
    PyTuple_SetItem(args,2,PyLong_FromLong(Key));

    wrapEvent(args);
  end;
end;

procedure TScriptEventHandlerTKeyPressEvent.eventHandler(Sender: TObject; var Key: Word);
var
  args: PPyObject;
begin
  with GetPythonEngine do
  begin
    args := PyTuple_New(2);

    PyTuple_SetItem(args,0,PyString_FromString(PChar(GetStringFromComponent(TComponent(Sender)))));
    PyTuple_SetItem(args,1,PyLong_FromLong(Key));

    wrapEvent(args);
  end;
end;

procedure GUISynchronizedUpdate(ucb: PGUIUpdateCallback);
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    try
      EvalPyFunction(ucb.func,ucb.args);
    except
    end;
    Py_XDECREF(ucb.args);
    FreeMemory(ucb);
  end;
  ReleaseMainThread;
end;

function PyDict_GetVariantItemString(dict: PPyObject; key: PAnsiChar; defaultValue: Variant): Variant;
var
  pyDictValue: PPyObject;
begin
  with GetPythonEngine do
  begin
    Assert(PyDict_Check(dict));
    pyDictValue := PyDict_GetItemString(dict,key);
    if pyDictValue = nil then
      Result := defaultValue
    else
      Result := PyObjectAsVariant(pyDictValue);
  end;
end;

procedure ExecuteNextWidgetAction;
var
  widget: TWidgetItem;
begin
  with WidgetDBForm do
  begin
    if btRefresh.Enabled then
    begin
      if RefreshWidgetListAction then
        btRefreshClick(nil)
      else if InstallWidgetIds.Count > 0 then
      begin
        widget := GetWidgetById(InstallWidgetIds.Items[0]);
        InstallWidgetIds.Delete(0);

        if widget = nil then
        begin
          DebugPrint('InstallOrUpdateWidget fatal error : unknown widget id')
        end
        else
        begin
          btInstall.Enabled := False;
          btRefresh.Enabled := False;
          if widget.Installed then
            btInstall.Caption := _('Updating ...')
          else
            btInstall.Caption := _('Installing ...');

          TInstallWidgetThread.Create(false,widget,false);
        end;
      end
      else if UninstallWidgetIds.Count > 0 then
      begin
        widget := GetWidgetById(UninstallWidgetIds.Items[0]);
        UninstallWidgetIds.Delete(0);

        if widget = nil then
        begin
          DebugPrint('UninstallWidget fatal error : unknown widget id')
        end
        else
        begin
          btInstall.Enabled := False;
          btRefresh.Enabled := False;
          btInstall.Caption := _('Uninstalling ...');

          TInstallWidgetThread.Create(false,widget,true);
        end;
      end;
    end;
  end;
end;

end.
