using System;
using System.Collections.Generic;
using System.Globalization;
using System.Net;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Timers;
using Microsoft.Win32;
using Springie.SpringNamespace;
using Timer=System.Timers.Timer;

namespace Springie.Client
{
  public partial class TasClient
  {
    // server info

    #region SayPlace enum
    public enum SayPlace
    {
      Channel,
      Battle,
      User
    } ;
    #endregion

    public const int MaxRank = 4;
    public const int MinRank = 0;
    private Battle battle = null;
    private int battleID = 0;

    private ServerConnection con = null;
    private Dictionary<string, ExistingChannel> existingChannels = new Dictionary<string, ExistingChannel>();
    private Dictionary<string, User> existingUsers = new Dictionary<string, User>();
    private bool isChanScanning = false;
    private bool isConnected = false;
    private bool isLoggedIn = false;
    private Dictionary<string, Channel> joinedChannels = new Dictionary<string, Channel>();
    private int lastSpectatorCount;
    private int lastUdpSourcePort = 0;
    private bool lockToChangeTo;
    private MapInfo mapToChangeTo;
    private int pingInterval = 10; // how often to ping server (in seconds)
    private Timer pingTimer;

    private string serverHost = "";
    private IPAddress serverIp;
    private int serverPort = 0;
    private int serverUdpHolePunchingPort = 0;
    private string serverVersion = "";
    private bool startingAfterUdpPunch = false;
    private Timer udpPunchingTimer = new Timer(400);

    // user info 
    private string username = "";

    public TasClient()
    {
      pingTimer = new Timer(pingInterval*1000);
      pingTimer.AutoReset = true;
      pingTimer.Elapsed += OnPingTimer;
      pingTimer.Start();

      udpPunchingTimer.Elapsed += new ElapsedEventHandler(udpPunchingTimer_Elapsed);
      udpPunchingTimer.AutoReset = true;

      ConnectionLost += RaiseFailure;
      LoginDenied += RaiseFailure;
      ChannelJoinFailed += RaiseFailure;
      BattleOpenFailed += RaiseFailure;
    }

    public string UserName
    {
      get { return username; }
    }

    public bool IsLoggedIn
    {
      get { return isLoggedIn; }
    }

    public int PingInterval
    {
      get { return pingInterval; }
      set
      {
        pingInterval = value;
        pingTimer.Interval = pingInterval*1000;
      }
    }

    public bool IsConnected
    {
      get { return isConnected; }
    }

    // group events
    public event EventHandler<TasEventArgs> Failure; //this event is fired whenever any failure events fire
    public event EventHandler<TasSayEventArgs> Said; // this is fired when any kind of say message is recieved


    // invidivudal events
    public event EventHandler<TasEventArgs> Connected;
    public event EventHandler<TasEventArgs> ConnectionLost;

    public event EventHandler<TasEventArgs> LoginAccepted;
    public event EventHandler<TasEventArgs> LoginDenied;

    public event EventHandler<TasEventArgs> ChannelJoined;
    public event EventHandler<TasEventArgs> ChannelLeft;
    public event EventHandler<TasEventArgs> ChannelJoinFailed;

    public event EventHandler<TasEventArgs> ChannelListDone;

    public event EventHandler<TasEventArgs> UserAdded;
    public event EventHandler<TasEventArgs> UserRemoved;

    public event EventHandler<TasEventArgs> BattleOpenFailed;
    public event EventHandler<TasEventArgs> BattleOpened;
    public event EventHandler<TasEventArgs> BattleClosed;
    public event EventHandler<TasEventArgs> BattleUserJoined;
    public event EventHandler<TasEventArgs> BattleUserLeft;
    public event EventHandler<TasEventArgs> BattleUserStatusChanged;
    public event EventHandler<TasEventArgs> BattleUserIpRecieved;
    public event EventHandler<TasEventArgs> BattleMapChanged;
    public event EventHandler<TasEventArgs> BattleLockChanged;
    public event EventHandler<TasEventArgs> BattleDisabledUnitsChanged;
    public event EventHandler<TasEventArgs> BattleDetailsChanged;

    public event EventHandler<TasEventArgs> BattleFound;


    public event EventHandler<TasEventArgs> ChannelUserAdded;
    public event EventHandler<TasEventArgs> ChannelUserRemoved;
    public event EventHandler<TasEventArgs> ChannelTopicChanged;

    public event EventHandler<TasEventArgs> UserStatusChanged;

    public event EventHandler<TasEventArgs> MyStatusChangedToInGame;


    public Dictionary<string, Channel> GetJoinedChannels()
    {
      return new Dictionary<string, Channel>(joinedChannels);
    }


    public bool GetExistingUser(string name, out User u)
    {
      return existingUsers.TryGetValue(name, out u);
    }

    public void Connect(string host, int port)
    {
      serverHost = host;
      serverIp = Dns.GetHostAddresses(host)[0];
      serverPort = port;
      battle = null;
      battleID = 0;
      existingUsers = new Dictionary<string, User>();
      existingChannels = new Dictionary<string, ExistingChannel>();
      joinedChannels = new Dictionary<string, Channel>();
      isChanScanning = false;
      isLoggedIn = false;
      isConnected = false;
      username = "";
      try {
        con = new ServerConnection();
        con.Connect(host, port);
        con.ConnectionClosed += OnConnectionClosed;
        con.CommandRecieved += OnCommandRecieved;
      } catch {
        con = null;
        if (ConnectionLost != null) ConnectionLost(this, new TasEventArgs("Cannot connect to remote machine"));
      }
    }

    public void Disconnect()
    {
      if (con != null && isConnected) con.Close();
      //con.CommandRecieved 
      existingUsers = new Dictionary<string, User>();
      existingChannels = new Dictionary<string, ExistingChannel>();
      joinedChannels = new Dictionary<string, Channel>();
      battle = null;
      battleID = 0;
      username = "";
      isLoggedIn = false;
      isConnected = false;
      isChanScanning = false;
    }

    private void OnPingTimer(object sender, EventArgs args)
    {
      if (isConnected && con != null) con.SendCommand(0, "PING");
    }


    public void Login(string login, string password, string appinfo)
    {
      if (con == null) throw new TasClientException("Not connected");

      string localIp = Dns.GetHostAddresses(Dns.GetHostName())[0].ToString();

      string mhz = Registry.GetValue("HKEY_LOCAL_MACHINE\\HARDWARE\\DESCRIPTION\\SYSTEM\\CentralProcessor\\0", "~MHz", 0).ToString();

      string mhz2 = "";

      if (Registry.GetValue("HKEY_LOCAL_MACHINE\\HARDWARE\\DESCRIPTION\\SYSTEM\\CentralProcessor\\0", "VendorIdentifier", 0).ToString().Contains("AMD")) {
        Match m = Regex.Match(Registry.GetValue("HKEY_LOCAL_MACHINE\\HARDWARE\\DESCRIPTION\\SYSTEM\\CentralProcessor\\0", "ProcessorNameString", 0).ToString(), "[^0-9]*([0-9]*)");
        if (m.Groups.Count > 1) mhz2 = m.Groups[1].Value;

        int i, o;
        int.TryParse(mhz2, out o);
        int.TryParse(mhz, out i);
        if (o > i) mhz = o.ToString();
      }

      con.SendCommand(0, "LOGIN", login, HashPassword(password), mhz, localIp, appinfo);
    }


    public void ListChannels()
    {
      isChanScanning = true;
      existingChannels.Clear();
      con.SendCommand(0, "CHANNELS");
    }

    public Battle GetBattle()
    {
      if (battle != null) return (Battle)battle.Clone();
      else return null;
    }

    public Dictionary<string, ExistingChannel> GetExistingChannels()
    {
      if (isChanScanning) throw new TasClientException("Channel scan operation in progress");
      return new Dictionary<string, ExistingChannel>(existingChannels);
    }


    public void JoinChannel(string channelName)
    {
      JoinChannel(channelName, null);
    }


    public void JoinChannel(string channelName, string key)
    {
      if (con == null) throw new TasClientException("Not connected");

      if (!String.IsNullOrEmpty(key)) con.SendCommand(0, "JOIN", channelName, HashPassword(key));
      else con.SendCommand(0, "JOIN", channelName);
    }


    public void LeaveChannel(string channelName)
    {
      con.SendCommand(0, "LEAVE", channelName);
      joinedChannels.Remove(channelName);
      if (ChannelLeft != null) ChannelLeft(this, new TasEventArgs(channelName));
    }


    public void ChangeMyStatus(bool isAway, bool isInGame)
    {
      User u = new User();
      u.isAway = isAway;
      u.isInGame = isInGame;
      con.SendCommand(0, "MYSTATUS", u.ToInt());
    }


    /// <summary>
    /// Starts game and automatically does hole punching if necessary
    /// </summary>
    public void StartGame()
    {
      if (battle != null) {
        if (battle.Nat == Battle.NatMode.HolePunching) {
          startingAfterUdpPunch = true;
          SendUdpPacket(0, serverIp, serverUdpHolePunchingPort);
          udpPunchingTimer.Start();
        } else ChangeMyStatus(false, true);
      }
    }

    private void udpPunchingTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
      SendUdpPacket(lastUdpSourcePort, serverIp, serverUdpHolePunchingPort);
    }

    private void SendUdpPacket(int sourcePort, IPAddress targetIp, int targetPort)
    {
      IPAddress[] ret = Dns.GetHostAddresses(serverHost);

      Socket s = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);

      IPEndPoint local = new IPEndPoint(IPAddress.Any, sourcePort);
      s.Bind(local);
      //s.ExclusiveAddressUse = false;
      lastUdpSourcePort = ((IPEndPoint)s.LocalEndPoint).Port;

      s.Connect(targetIp, targetPort);
      s.Send(ASCIIEncoding.ASCII.GetBytes(UserName));
      s.Close();
    }


    /// <summary>
    /// Say something through chat system
    /// </summary>
    /// <param name="place">Pick user (private message) channel or battle</param>
    /// <param name="channel">Channel or User name</param>
    /// <param name="text">chat text</param>
    /// <param name="isEmote">is message emote? (channel or battle only)</param>
    public void Say(SayPlace place, string channel, string text, bool isEmote)
    {
      if (String.IsNullOrEmpty(text)) return;
      switch (place) {
        case SayPlace.Channel:
          if (isEmote) con.SendCommand(0, "SAYEX", channel, text);
          else con.SendCommand(0, "SAY", channel, text);
          break;

        case SayPlace.User:
          con.SendCommand(0, "SAYPRIVATE", channel, text);
          break;

        case SayPlace.Battle:
          if (isEmote) con.SendCommand(0, "SAYBATTLEEX", text);
          else con.SendCommand(0, "SAYBATTLE", text);
          break;
      }
    }


    public void GameSaid(string username, string text)
    {
      if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Game, "", username, text, false));
    }


    public void OpenBattle(Battle nbattle)
    {
      LeaveBattle(); // leave current battle
      battleID = -1;
      battle = (Battle)nbattle.Clone();

      List<Object> objList = new List<object>();
      objList.Add(0); // type = normal
      objList.Add((int)battle.Nat);
      objList.Add(battle.Password);
      objList.Add(battle.HostPort);
      objList.Add(battle.MaxPlayers);
      ;
      //battle.Details.AddToParamList(objList);
      objList.Add(battle.Mod.Checksum);
      objList.Add(battle.Rank);
      objList.Add(battle.Map.Checksum);
      objList.Add(battle.Map.Name);
      objList.Add('\t' + battle.Title);
      objList.Add('\t' + battle.Mod.Name);

      mapToChangeTo = battle.Map;
      lockToChangeTo = false;

      con.SendCommand(0, "OPENBATTLE", objList.ToArray());

      lastSpectatorCount = -1;

      // send predefined starting rectangles
      foreach (KeyValuePair<int, BattleRect> v in battle.Rectangles) con.SendCommand(0, "ADDSTARTRECT", v.Key, v.Value.Left, v.Value.Top, v.Value.Right, v.Value.Bottom);
    }

    public void LeaveBattle()
    {
      if (battle != null) {
        con.SendCommand(0, "LEAVEBATTLE");
        battle = null;
        battleID = 0;
        if (BattleClosed != null) BattleClosed(this, new TasEventArgs());
      }
    }


    public void AddBattleRectangle(int allyno, BattleRect rect)
    {
      if (battle != null) {
        if (allyno < Spring.MaxAllies && allyno >= 0) {
          RemoveBattleRectangle(allyno);
          battle.Rectangles.Add(allyno, rect);
          con.SendCommand(0, "ADDSTARTRECT", allyno, rect.Left, rect.Top, rect.Right, rect.Bottom);
        }
      }
    }

    public void RemoveBattleRectangle(int allyno)
    {
      if (battle != null) {
        if (battle.Rectangles.ContainsKey(allyno)) {
          battle.Rectangles.Remove(allyno);
          con.SendCommand(0, "REMOVESTARTRECT", allyno);
        }
      }
    }


    public void DisableUnits(params string[] units)
    {
      if (battle != null) {
        List<string> tmp = new List<string>(units);
        foreach (string s in tmp) {
          if (!battle.DisabledUnits.Contains(s)) {
            UnitInfo u;
            if (battle.Mod.GetUnitInfo(s, out u)) battle.DisabledUnits.Add(s);
          }
        }
        if (battle.DisabledUnits.Count > 0) {
          con.SendCommand(0, "DISABLEUNITS", battle.DisabledUnits.ToArray());
          if (BattleDisabledUnitsChanged != null) BattleDisabledUnitsChanged(this, new TasEventArgs(battle.DisabledUnits.ToArray()));
        }
      }
    }

    public void EnableAllUnits()
    {
      if (battle != null) {
        battle.DisabledUnits.Clear();
        con.SendCommand(0, "ENABLEALLUNITS");
        if (BattleDisabledUnitsChanged != null) BattleDisabledUnitsChanged(this, new TasEventArgs(battle.DisabledUnits.ToArray()));
      }
    }


    private void UpdateBattleInfo(bool lck, MapInfo mapname)
    {
      if (battle != null) {
        lockToChangeTo = lck;
        con.SendCommand(0, "UPDATEBATTLEINFO", battle.CountSpectators(), (int)(lck ? 1 : 0), mapname.Checksum, mapname.Name);
      }
    }


    public void ChangeLock(bool lck)
    {
      if (battle != null && lck != lockToChangeTo) UpdateBattleInfo(lck, mapToChangeTo);
    }

    private void UpdateSpectators()
    {
      if (battle != null) {
        int n = battle.CountSpectators();
        if (n != lastSpectatorCount) {
          lastSpectatorCount = n;
          con.SendCommand(0, "UPDATEBATTLEINFO", n, (int)(battle.IsLocked ? 1 : 0), battle.Map.Checksum, battle.Map.Name);
        }
      }
    }

    public void ChangeMap(MapInfo nmap)
    {
      if (battle != null) {
        mapToChangeTo = nmap;
        UpdateBattleInfo(lockToChangeTo, nmap);
      }
    }

    public void UpdateBattleDetails(BattleDetails bd)
    {
      if (battle != null) {
        List<object> objList = new List<object>();
        con.SendCommand(0, "SETSCRIPTTAGS", bd.GetParamList());
      }
    }

    public void SetScriptTag(string data)
    {
      con.SendCommand(0, "SETSCRIPTTAGS", data);
    }


    private void OnConnectionClosed(object sender, EventArgs args)
    {
      if (sender == con) {
        isConnected = false;
        if (ConnectionLost != null) ConnectionLost(this, new TasEventArgs("Connection was closed"));
        Disconnect();
      }
    }

    private void OnCommandRecieved(object sender, ServerConnectionEventArgs args)
    {
      if (sender == con) DispatchServerCommand(args.Command, (string[])args.Parameters);
    }

    /// <summary>
    /// purpose of this event handler is to redirect "fail" events to failure event too
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="args"></param>
    private void RaiseFailure(object sender, TasEventArgs args)
    {
      if (Failure != null) Failure(this, args);
    }


    /// <summary>
    /// Hash password with default hash used by remote server
    /// </summary>
    /// <param name="pass">string with password</param>
    /// <returns>hash string</returns>
    public static string HashPassword(string pass)
    {
      MD5 md5 = (MD5)HashAlgorithm.Create("MD5");
      md5.Initialize();
      byte[] hashed = md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(pass));
      return Convert.ToBase64String(hashed);
    }


    public void Ring(string username)
    {
      con.SendCommand(0, "RING", username);
    }


    public void Kick(string username)
    {
      con.SendCommand(0, "KICKFROMBATTLE", username);
    }

    public void ForceTeam(string username, int team)
    {
      con.SendCommand(0, "FORCETEAMNO", username, team);
    }

    public void ForceAlly(string username, int ally)
    {
      con.SendCommand(0, "FORCEALLYNO", username, ally);
    }

    public void ForceSpectator(string username)
    {
      con.SendCommand(0, "FORCESPECTATORMODE", username);
    }


    public void ForceColor(string username, int color)
    {
      con.SendCommand(0, "FORCETEAMCOLOR", username, color);
    }

    /// <summary>
    /// Primary method - processes commands from server
    /// </summary>
    /// <param name="command">command name</param>
    /// <param name="args">command arguments</param>
    private void DispatchServerCommand(string command, string[] args)
    {
      Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
      try {
        switch (command) {
          case "TASServer": // happens after connecting to server
            serverVersion = args[0];
            int.TryParse(args[2], out serverUdpHolePunchingPort);
            isConnected = true;
            if (Connected != null) Connected(this, new TasEventArgs());
            break;

          case "ACCEPTED": // Login accepted
            username = args[0];
            isLoggedIn = true;
            if (LoginAccepted != null) LoginAccepted(this, new TasEventArgs());
            break;

          case "DENIED": // login denied
            isLoggedIn = false;
            if (LoginDenied != null) LoginDenied(this, new TasEventArgs(Utils.Glue(args)));
            break;

          case "JOIN": // channel joined
            if (!joinedChannels.ContainsKey(args[0])) joinedChannels.Add(args[0], Channel.Create(args[0]));
            if (ChannelJoined != null) ChannelJoined(this, new TasEventArgs(args));
            break;

          case "JOINFAILED": // channel join failed
            if (ChannelJoinFailed != null) ChannelJoinFailed(this, new TasEventArgs(Utils.Glue(args)));
            break;

          case "CHANNEL": // iterating channels
            {
              ExistingChannel c = new ExistingChannel();
              c.name = args[0];
              int.TryParse(args[1], out c.userCount);
              if (args.Length >= 3) c.topic = Utils.Glue(args, 2);
              existingChannels.Add(c.name, c);
            }
            break;

          case "ENDOFCHANNELS": // end of channel list iteration
            isChanScanning = false;
            if (ChannelListDone != null) ChannelListDone(this, new TasEventArgs());
            break;

          case "ADDUSER": // new user joined ta server
            {
              User u = User.Create(args[0]);
              u.country = args[1];
              int.TryParse(args[2], out u.cpu);
              //IPAddress.TryParse(args[3], out u.ip);
              existingUsers.Add(u.name, u);
              if (UserAdded != null) UserAdded(this, new TasEventArgs(args));
            }
            break;

          case "REMOVEUSER": // user left ta server
            existingUsers.Remove(args[0]);
            if (UserRemoved != null) UserRemoved(this, new TasEventArgs(args));
            break;

          case "MOTD": // server motd
            if (Said != null && args.Length > 0) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Server, TasSayEventArgs.Places.Motd, "", "", Utils.Glue(args, 0), false));
            break;

          case "SERVERMSG": // server message
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Server, TasSayEventArgs.Places.Normal, "", "", Utils.Glue(args, 0), false));
            break;

          case "SERVERMSGBOX": // server messagebox
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Server, TasSayEventArgs.Places.MessageBox, "", "", Utils.Glue(args, 0), false));
            break;

          case "CHANNELMESSAGE": // server broadcast to channel
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Server, TasSayEventArgs.Places.Channel, args[0], "", Utils.Glue(args, 1), false));
            break;

          case "SAID": // someone said something in channel
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Channel, args[0], args[1], Utils.Glue(args, 2), false));
            break;

          case "SAIDEX": // someone said something with emote in channel
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Channel, args[0], args[1], Utils.Glue(args, 2), true));
            break;

          case "SAYPRIVATE": // sent back from sever when user sends private message
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Normal, args[0], username, Utils.Glue(args, 1), false)); // channel = char partner name
            break;

          case "SAIDPRIVATE": // someone said something to me
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Normal, args[0], args[0], Utils.Glue(args, 1), false));
            break;

          case "SAIDBATTLE": // someone said something in battle
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Battle, "", args[0], Utils.Glue(args, 1), false));
            break;

          case "SAIDBATTLEEX": // someone said in battle with emote
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Battle, "", args[0], Utils.Glue(args, 1), true));
            break;

          case "BROADCAST": // server sends urgent broadcast
            if (Said != null) Said(this, new TasSayEventArgs(TasSayEventArgs.Origins.Server, TasSayEventArgs.Places.Broadcast, "", "", Utils.Glue(args, 0), false));
            break;

          case "REDIRECT": // server sends backup IP
            // removed due to bugs         
            break;

          case "CLIENTSTATUS": // client's status changed
            {
              int status = 0;
              int.TryParse(args[1], out status);
              User u = existingUsers[args[0]];
              u.FromInt(status);

              if (u.name == UserName && (u.isInGame == true && existingUsers[args[0]].isInGame == false)) {
                existingUsers[args[0]] = u;
                if (MyStatusChangedToInGame != null) MyStatusChangedToInGame(this, new TasEventArgs());
              }

              existingUsers[args[0]] = u;
              if (UserStatusChanged != null) UserStatusChanged(this, new TasEventArgs(args));
            }
            break;

          case "CLIENTS": // client list sent after channel join
            string[] usrs = Utils.Glue(args, 1).Split(' ');
            foreach (string s in usrs) joinedChannels[args[0]].channelUsers.Add(s);
            if (ChannelUserAdded != null) ChannelUserAdded(this, new TasEventArgs(args[0]));
            break;

          case "JOINED": // user joined one of my channels
            joinedChannels[args[0]].channelUsers.Add(args[1]);
            if (ChannelUserAdded != null) ChannelUserAdded(this, new TasEventArgs(args[0]));
            break;

          case "LEFT": // user left one of my channels
            joinedChannels[args[0]].channelUsers.Remove(args[1]);
            if (ChannelUserRemoved != null) ChannelUserRemoved(this, new TasEventArgs(args[0], args[1], Utils.Glue(args, 2)));
            break;

          case "CHANNELTOPIC": // channel topic update (after joining a channel)
            {
              Channel c = joinedChannels[args[0]];
              c.topicSetBy = args[1];
              c.topicSetDate = ConvertMilisecondTime(args[2]);
              c.topic = Utils.Glue(args, 3);
              if (ChannelTopicChanged != null) ChannelTopicChanged(this, new TasEventArgs(args[0]));
            }
            break;

          case "OPENBATTLEFAILED": // opening new battle has failed
            if (BattleOpenFailed != null) BattleOpenFailed(this, new TasEventArgs(Utils.Glue(args)));
            break;

          case "OPENBATTLE": // openbattle ok
            {
              battleID = int.Parse(args[0]);
              UserBattleStatus self = new UserBattleStatus(username);
              self.IsSpectator = true;
              battle.Users.Add(self); // add self
              UpdateBattleDetails(battle.Details);
              if (BattleOpened != null) BattleOpened(this, new TasEventArgs(args[0]));
            }
            break;

          case "REQUESTBATTLESTATUS": // server asks us to update our status
            con.SendCommand(0, "MYBATTLESTATUS", 1 << 22, 0); // tell server that we are synchronized  spectators
            break;

          case "JOINEDBATTLE": // user joined the battle
            if (battle != null && int.Parse(args[0]) == battleID) {
              battle.Users.Add(new UserBattleStatus(args[1]));
              if (BattleUserJoined != null) BattleUserJoined(this, new TasEventArgs(args[1]));
            }
            break;

          case "LEFTBATTLE": // user left the battle
            if (battle != null && int.Parse(args[0]) == battleID) {
              battle.RemoveUser(args[1]);
              UpdateSpectators();
              if (BattleUserLeft != null) BattleUserLeft(this, new TasEventArgs(args[1]));
              if (args[1] == username) {
                battle = null;
                battleID = 0;
                if (BattleClosed != null) BattleClosed(this, new TasEventArgs());
              }
            }
            break;

          case "CLIENTBATTLESTATUS": // player battle status has changed
            if (battle != null) {
              int uindex = battle.GetUserIndex(args[0]);
              if (uindex != -1) {
                UserBattleStatus bs = battle.Users[uindex];
                bs.SetFrom(int.Parse(args[1]), int.Parse(args[2]));
                battle.Users[uindex] = bs;
                UpdateSpectators();
                if (BattleUserStatusChanged != null) BattleUserStatusChanged(this, new TasEventArgs(args[0]));
              }
            }
            break;

          case "UPDATEBATTLEINFO": // update external battle info (lock and map)
            if (battle != null && int.Parse(args[0]) == battleID) {
              string mapname = Utils.Glue(args, 4);
              if (battle.Map.Name != mapname) {
                if (mapToChangeTo != null && mapToChangeTo.Name == mapname) {
                  // if we changed to known requested map, use it
                  battle.Map = mapToChangeTo;
                } else battle.Map = Program.main.Spring.UnitSync.MapList[mapname]; //otherwise find this map using unitsync
                if (BattleMapChanged != null) BattleMapChanged(this, new TasEventArgs(mapname));
              }

              if (battle.IsLocked != int.Parse(args[2]) > 0) {
                battle.IsLocked = int.Parse(args[2]) > 0;
                if (BattleLockChanged != null) BattleLockChanged(this, new TasEventArgs(args[2]));
              }
            }
            break;

          case "BATTLEOPENED":
            {
              if (BattleFound != null) BattleFound(this, new TasEventArgs(args));
              break;
            }

          case "CLIENTIPPORT":
            if (battle != null) {
              int idx = battle.GetUserIndex(args[0]);
              if (idx != -1) {
                UserBattleStatus bs = battle.Users[idx];
                bs.ip = IPAddress.Parse(args[1]);
                bs.port = int.Parse(args[2]);
                battle.Users[idx] = bs;
                if (BattleUserIpRecieved != null) BattleUserIpRecieved(this, new TasEventArgs(args));
              }
            }
            break;

          case "SETSCRIPTTAGS": // updates internal battle details
            if (battle != null) {
              BattleDetails bd = new BattleDetails();
              bd.Parse(Utils.Glue(args), battle.ModOptions);
              battle.Details = bd;
              if (BattleDetailsChanged != null) BattleDetailsChanged(this, new TasEventArgs(args));
            }
            break;

          case "UDPSOURCEPORT":
            udpPunchingTimer.Stop();
            if (startingAfterUdpPunch) {
              startingAfterUdpPunch = false;
              if (battle != null) {
                // send UDP packets to client (2x to be sure)
                foreach (UserBattleStatus ubs in battle.Users) if (ubs.ip != IPAddress.None && ubs.port != 0) SendUdpPacket(lastUdpSourcePort, ubs.ip, ubs.port);
                foreach (UserBattleStatus ubs in battle.Users) if (ubs.ip != IPAddress.None && ubs.port != 0) SendUdpPacket(lastUdpSourcePort, ubs.ip, ubs.port);

                battle.HostPort = lastUdpSourcePort; // update source port for hosting and start it
                ChangeMyStatus(false, true);
              }
            }
            break;
        }
      } catch (Exception e) {
        if (!ErrorHandling.HandleException(e, "Exception while dispatching " + command + " " + Utils.Glue(args))) throw e;
      }
      ;
    }


    public static DateTime ConvertMilisecondTime(string arg)
    {
      return (new DateTime(1970, 1, 1, 0, 0, 0)).AddMilliseconds(long.Parse(arg));
    }
  }
}