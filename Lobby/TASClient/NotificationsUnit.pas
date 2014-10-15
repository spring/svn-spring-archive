unit NotificationsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, SpTBXControls, TntStdCtrls,
  SpTBXEditors, SpTBXItem,Misc;

type

  TNotificationType = (nfJoinedChannel, nfJoinedBattle,nfJoinedMyHostedBattle, nfStatusInBattle, nfModHosted);
  {
    Notification types:

    nfJoinedChannel - when <player> joins <channel>
    nfJoinedBattle - when a player joins battle user is participating in
    nfStatusInBattle - when <player> changes his status from normal to in-battle
    nfModHosted - when battle opens using specified mod
  }

const
  NotificationInfo: array[TNotificationType] of string = (
  'Player <%s> joins channel <%s>',
  'Player joins a battle user is participating in',
  'Player joins battle user is hosting',
  'Player <%s> joins a battle',
  'Battle opens using <%s> as a mod'
  );

type

  TNotificationsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    SpeedButton1: TSpTBXSpeedButton;
    SpeedButton2: TSpTBXSpeedButton;
    SpeedButton3: TSpTBXSpeedButton;
    Button1: TSpTBXButton;
    NotificationListBox: TSpTBXListBox;
    CheckBox1: TSpTBXCheckBox;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
  
    function AddNotification(NfType: TNotificationType; const Args: array of const): Boolean; overload;
    function AddNotification(NfType: TNotificationType; const Args: TStringList): Boolean; overload;
    function FindNotification(NfType: TNotificationType; const Args: array of const): Boolean; overload;
    function FindNotification(NfType: TNotificationType; const Args: TStringList): Boolean; overload;
    function countNotifications: integer;
    function getNotification(index: integer; var NfType: TNotificationType; var Args: TStringList): Boolean;
    procedure UpdateNotificationList;
    procedure SaveNotificationListToFile(FileName: string);
    procedure LoadNotificationListFromFile(FileName: string);
    procedure ClearNotifications;
  end;


var
  NotificationsForm: TNotificationsForm;

implementation

uses MainUnit, PreferencesFormUnit, StringParser, AddNotificationFormUnit, gnugettext;

var
  Notifications: array[TNotificationType] of TStringList; // for each notification type, store one list of notifications

{$R *.dfm}

procedure TNotificationsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopwindow;
  end;
end;

function TNotificationsForm.AddNotification(NfType: TNotificationType; const Args: TStringList): Boolean;
var
  Name1, Name2: string;
begin
  Result := False;

  if FindNotification(NfType, Args) then Exit; // no need to add it, since equivalent notification already exists

  try
    case NfType of
      nfJoinedChannel:
      begin
        if Args.Count <> 2 then Exit;
        Name1 := Args[0]; // player
        Name2 := Args[1]; // channel
      end;

      nfJoinedBattle:
      begin
        if Args.Count <> 0 then Exit;
      end;

      nfJoinedMyHostedBattle:
      begin
        if Args.Count <> 0 then Exit;
      end;

      nfStatusInBattle:
      begin
        if Args.Count <> 1 then Exit;
        Name1 := Args[0]; // player
      end;

      nfModHosted:
      begin
        if Args.Count <> 1 then Exit;
        Name1 := Args[0]; // mod
      end;
    end; // of case sentence
  except
    Exit;
  end;

  // add it:
  case NfType of
    nfJoinedChannel: Notifications[NfType].Add(Name1 + '|' + Name2);
    nfJoinedBattle: Notifications[NfType].Add('');
    nfJoinedMyHostedBattle: Notifications[NfType].Add('');
    nfStatusInBattle: Notifications[NfType].Add(Name1);
    nfModHosted: Notifications[NfType].Add(Name1);
  end;

  Result := True;
end;

// returns True if notification exists
function TNotificationsForm.AddNotification(NfType: TNotificationType; const Args: array of const): Boolean;
var
  Name1, Name2: string;
begin
  Result := False;

  if FindNotification(NfType, Args) then Exit; // no need to add it, since equivalent notification already exists

  try
    case NfType of
      nfJoinedChannel:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // player
        if Args[1].VType <> vtAnsiString then Exit;
        Name2 := AnsiString(Args[1].VAnsiString); // channel
      end;

      nfJoinedBattle:
      begin
      end;

      nfJoinedMyHostedBattle:
      begin
      end;

      nfStatusInBattle:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // player
      end;

      nfModHosted:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // mod
      end;
    end; // of case sentence
  except
    Exit;
  end;

  // add it:
  case NfType of
    nfJoinedChannel: Notifications[NfType].Add(Name1 + '|' + Name2);
    nfJoinedBattle: Notifications[NfType].Add('');
    nfJoinedMyHostedBattle: Notifications[NfType].Add('');
    nfStatusInBattle: Notifications[NfType].Add(Name1);
    nfModHosted: Notifications[NfType].Add(Name1);
  end;

  Result := True;
end;

function TNotificationsForm.FindNotification(NfType: TNotificationType; const Args: TStringList): Boolean;
var
  i: Integer;
  Name1, Name2: string;
  sl: TStringList;
begin
  Result := False;

  try
    case NfType of
      nfJoinedChannel:
      begin
        if sl.Count <> 2 then Exit;
        Name1 := Args[0]; // player
        Name2 := Args[1]; // channel
      end;

      nfJoinedBattle:
      begin
        if sl.Count <> 0 then Exit;
      end;

      nfJoinedMyHostedBattle:
      begin
        if sl.Count <> 0 then Exit;
      end;

      nfStatusInBattle:
      begin
        if sl.Count <> 1 then Exit;
        Name1 := Args[0]; // player
      end;

      nfModHosted:
      begin
        if sl.Count <> 1 then Exit;
        Name1 := Args[0]; // player
      end;
    end; // of case sentence
  except
    Exit;
  end;

  for i := 0 to Notifications[NfType].Count-1 do
  try
    try
      sl := ParseString(Notifications[NfType][i], '|');

      case NfType of
        nfJoinedChannel:
        begin
          if sl.Count <> 2 then Exit;
          if sl[0] <> Name1 then Continue;
          if sl[1] <> Name2 then Continue;
          // else:
          Result := True;
          Exit;
        end;

        nfJoinedBattle:
        begin
          if sl.Count <> 0 then Exit;
          // else:
          Result := True;
          Exit;
        end;

        nfJoinedMyHostedBattle:
        begin
          if sl.Count <> 0 then Exit;
          // else:
          Result := True;
          Exit;
        end;

        nfStatusInBattle:
        begin
          if sl.Count <> 1 then Exit;
          if sl[0] <> Name1 then Continue;
          // else:
          Result := True;
          Exit;
        end;

        nfModHosted:
        begin
          if sl.Count <> 1 then Exit;
          if Pos(UpperCase(sl[0]),UpperCase(Name1)) = 0 then Continue;
          // else:
          Result := True;
          Exit;
        end;
      end; // of case sentence
    except
      Exit;
    end;
  finally
    sl.Free;
  end;
end;

// returns True if notification exists
function TNotificationsForm.FindNotification(NfType: TNotificationType; const Args: array of const): Boolean;
var
  i: Integer;
  Name1, Name2: string;
  sl: TStringList;
begin
  Result := False;

  try
    case NfType of
      nfJoinedChannel:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // player
        if Args[1].VType <> vtAnsiString then Exit;
        Name2 := AnsiString(Args[1].VAnsiString); // channel
      end;

      nfJoinedBattle:
      begin
      end;

      nfJoinedMyHostedBattle:
      begin
      end;

      nfStatusInBattle:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // player
      end;

      nfModHosted:
      begin
        if Args[0].VType <> vtAnsiString then Exit;
        Name1 := AnsiString(Args[0].VAnsiString); // player
      end;
    end; // of case sentence
  except
    Exit;
  end;

  for i := 0 to Notifications[NfType].Count-1 do
  try
    try
      sl := ParseString(Notifications[NfType][i], '|');

      case NfType of
        nfJoinedChannel:
        begin
          if sl.Count <> 2 then Exit;
          if sl[0] <> Name1 then Continue;
          if sl[1] <> Name2 then Continue;
          // else:
          Result := True;
          Exit;
        end;

        nfJoinedBattle:
        begin
          if sl.Count <> 0 then Exit;
          // else:
          Result := True;
          Exit;
        end;

        nfJoinedMyHostedBattle:
        begin
          if sl.Count <> 0 then Exit;
          // else:
          Result := True;
          Exit;
        end;

        nfStatusInBattle:
        begin
          if sl.Count <> 1 then Exit;
          if sl[0] <> Name1 then Continue;
          // else:
          Result := True;
          Exit;
        end;

        nfModHosted:
        begin
          if sl.Count <> 1 then Exit;
          if Pos(UpperCase(sl[0]),UpperCase(Name1)) = 0 then Continue;
          // else:
          Result := True;
          Exit;
        end;
      end; // of case sentence
    except
      Exit;
    end;
  finally
    sl.Free;
  end;

end;

function TNotificationsForm.countNotifications: integer;
var
  i: integer;
begin
  Result := 0;
  for i:=0 to Length(Notifications)-1 do
  begin
    Result := Result + Notifications[TNotificationType(i)].Count;
  end;
end;

function TNotificationsForm.getNotification(index: integer; var NfType: TNotificationType; var Args: TStringList): Boolean;
var
  i: integer;
  count: integer;
  notificationTypeIndex: integer;
begin
  Result := False;

  count := 0;
  for i:=0 to Length(Notifications)-1 do
  begin
    if index < count + Notifications[TNotificationType(i)].Count then
      break;
    count := count + Notifications[TNotificationType(i)].Count;
  end;
  if i >= Length(Notifications) then
    Exit;

  notificationTypeIndex := index-count;

  NfType := TNotificationType(i);
  Args.Clear;
  ParseDelimited(Args,Notifications[TNotificationType(i)][notificationTypeIndex],'|','');
  Result := True;
end;

// updates visual notification list
procedure TNotificationsForm.UpdateNotificationList;
var
  i, j: Integer;
  sl: TStringList;
begin
  NotificationListBox.Clear;

  for i := 0 to Length(Notifications)-1 do for j := 0 to Notifications[TNotificationType(i)].Count-1 do
  try
    try
      sl := ParseString(Notifications[TNotificationType(i)][j], '|');
      case TNotificationType(i) of
        nfJoinedChannel: NotificationListBox.Items.Add(Format(NotificationInfo[TNotificationType(i)], [sl[0], sl[1]]));
        nfJoinedBattle: NotificationListBox.Items.Add(Format(NotificationInfo[TNotificationType(i)], []));
        nfJoinedMyHostedBattle: NotificationListBox.Items.Add(Format(NotificationInfo[TNotificationType(i)], []));
        nfStatusInBattle: NotificationListBox.Items.Add(Format(NotificationInfo[TNotificationType(i)], [sl[0]]));
        nfModHosted: NotificationListBox.Items.Add(Format(NotificationInfo[TNotificationType(i)], [sl[0]]));
      end; // of case sentence
    except
      MessageDlg(_('Error: invalid notification syntax. Please report this error!'), mtError, [mbOK], 0);
      Exit;
    end;
  finally
    sl.Free;
  end;

end;

procedure TNotificationsForm.SaveNotificationListToFile(FileName: string);
var
  f: TextFile;
  i, j: Integer;
begin

  {$I+}
  try
    AssignFile(f, FileName);
    Rewrite(f);

    for i := 0 to Length(Notifications)-1 do for j := 0 to Notifications[TNotificationType(i)].Count-1 do
      Writeln(f, Chr(i) + Notifications[TNotificationType(i)][j]);

    CloseFile(f);
  except
    Exit;
  end;

end;

procedure TNotificationsForm.LoadNotificationListFromFile(FileName: string);
var
  f: TextFile;
  s: string;
  i: Integer;
  index: Integer;
begin

  // clear notification list:
  for i := 0 to Length(Notifications)-1 do Notifications[TNotificationType(i)].Clear;

  {$I+}
  try
    AssignFile(f, FileName);
    Reset(f);

    while not Eof(f) do
    begin
      Readln(f, s);
      if s = '' then Continue; // skip empty lines
      if s[1] = '#' then Continue; // skip comments

      index := Ord(s[1]);

      if index > Length(Notifications)-1 then
      begin
        MessageDlg(_('Error: notification list file seems to be currupt. Try deleting it!'), mtError, [mbOK], 0);
        Exit;
      end;

      s := Copy(s, 2, Length(s)-1);
      Notifications[TNotificationType(index)].Add(s);
    end;

    CloseFile(f);
  except
    Exit;
  end;

end;

procedure TNotificationsForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TNotificationsForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  TranslateComponent(self);
  
  for i := 0 to Length(Notifications)-1 do
    Notifications[TNotificationType(i)] := TStringList.Create;
end;

procedure TNotificationsForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Length(Notifications)-1 do Notifications[TNotificationType(i)].Free;
end;

procedure TNotificationsForm.SpeedButton1Click(Sender: TObject);
begin
  if AddNotificationForm.ShowModal = mrOK then
  begin
    UpdateNotificationList;
  end;
end;

procedure TNotificationsForm.SpeedButton3Click(Sender: TObject);
var
  i: Integer;
begin
  // clear notification list:
  for i := 0 to Length(Notifications)-1 do Notifications[TNotificationType(i)].Clear;

  UpdateNotificationList;
end;

procedure TNotificationsForm.SpeedButton2Click(Sender: TObject);
var
  i, j, n: Integer;
begin
  if NotificationListBox.ItemIndex = -1 then
  begin
    MessageDlg('No entry selected.', mtWarning, [mbOK], 0);
    Exit;
  end;

  // find first notification:
  n := NotificationListBox.ItemIndex;
  i := 0;
  j := 0;
  while Notifications[TNotificationType(i)].Count = 0 do Inc(i);
  // now locate n-th notification:
  while n > 0 do
  begin
    Inc(j);
    if j > Notifications[TNotificationType(i)].Count-1 then
    begin
      Inc(i);
      while Notifications[TNotificationType(i)].Count = 0 do Inc(i);
      j := 0;
    end;
    Dec(n);
  end;

  // delete n-th notification:
  Notifications[TNotificationType(i)].Delete(j);

  // update changes:
  UpdateNotificationList;
end;

procedure TNotificationsForm.ClearNotifications;
var
  i: integer;
begin
  for i := 0 to Length(Notifications)-1 do
    Notifications[TNotificationType(i)].Clear;
end;

end.
