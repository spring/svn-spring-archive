using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;
using System.IO;
using System.Timers;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.AutoHostNamespace
{

  public partial class AutoHost
  {
    public const string ConfigName = "autohost.xml";
    public const string PresetsName = "presets.xml";

    public const int PollTimeout = 60;

    public AutoHostConfig config = new AutoHostConfig();

    public List<Preset> presets = new List<Preset>();


    TasClient tas;
    Spring spring;
    UnknownFilesLinker linker;
    IVotable activePoll = null;
    Timer pollTimer = null;
    string tempAdminName = "";
    public string TempAdminName
    {
      get { return tempAdminName; }
      set { tempAdminName = value; }
    }


    MapDownloader mapDownloader;
    ModDownloader modDownloader;
    BanList banList;

    int mapCycleIndex = 0;

    bool kickSpectators = false;
    bool lockedByKickSpec = false;
    int autoLock = 0;
    public bool KickSpectators { get { return kickSpectators; } }



    double minCpuSpeed = 0;
    public double MinCpuSpeed { get { return minCpuSpeed; } }

    public AutoHost(TasClient tas, Spring spring, AutoHostConfig conf)
    {
      banList = new BanList(this, tas);

      if (conf == null) LoadConfig(); else config = conf;
      SaveConfig();

      this.tas = tas;
      this.spring = spring;

      tas.Said += new EventHandler<TasSayEventArgs>(tas_Said);

      pollTimer = new Timer(PollTimeout * 1000);
      pollTimer.Enabled = false;
      pollTimer.AutoReset = false;
      pollTimer.Elapsed += new ElapsedEventHandler(pollTimer_Elapsed);

      spring.SpringExited += new EventHandler(spring_SpringExited);
      spring.GameOver += new EventHandler<SpringLogEventArgs>(spring_GameOver);

      tas.BattleUserLeft += new EventHandler<TasEventArgs>(tas_BattleUserLeft);
      tas.UserStatusChanged += new EventHandler<TasEventArgs>(tas_UserStatusChanged);
      tas.BattleUserJoined += new EventHandler<TasEventArgs>(tas_BattleUserJoined);
      tas.BattleMapChanged += new EventHandler<TasEventArgs>(tas_BattleMapChanged);
      tas.BattleUserStatusChanged += new EventHandler<TasEventArgs>(tas_BattleUserStatusChanged);
      tas.BattleLockChanged += new EventHandler<TasEventArgs>(tas_BattleLockChanged);
      tas.BattleOpened += new EventHandler<TasEventArgs>(tas_BattleOpened);

      linker = new UnknownFilesLinker(spring);
      mapDownloader = new MapDownloader(spring);
      mapDownloader.DownloadCompleted += new EventHandler<TasEventArgs>(mapDownloader_DownloadCompleted);
      mapDownloader.DownloadProgressChanged += new EventHandler<TasEventArgs>(mapDownloader_DownloadProgressChanged);

      modDownloader = new ModDownloader(spring);
      modDownloader.DownloadCompleted += new EventHandler<TasEventArgs>(modDownloader_DownloadCompleted);
      modDownloader.DownloadProgressChanged += new EventHandler<TasEventArgs>(mapDownloader_DownloadProgressChanged);


      tas.BattleFound += new EventHandler<TasEventArgs>(tas_BattleFound);

    }


    void tas_BattleOpened(object sender, TasEventArgs e)
    {
      tas.DisableUnits(UnitInfo.ToStringList(config.DisabledUnits));
    }

    void tas_BattleFound(object sender, TasEventArgs e)
    {
      string map = Utils.Glue(e.ServerParams.ToArray(), 10).Split('\t')[0];
      if (config.AutoDownloadNewMaps && !spring.IsRunning && !spring.UnitSync.MapList.ContainsKey(map)) {
        mapDownloader.DownloadMap(map);
      }
    }


    void mapDownloader_DownloadProgressChanged(object sender, TasEventArgs e)
    {
      if (tas.IsConnected) {
        SayBattle(e.ServerParams[0] + " " + e.ServerParams[1] + "% done");
      }
    }


    void mapDownloader_DownloadCompleted(object sender, TasEventArgs e)
    {
      string mes;
      if (e.ServerParams.Count > 1 && e.ServerParams[1] != "") {
        mes = e.ServerParams[0] + " download failed: " + e.ServerParams[1];
      } else {
        mes = e.ServerParams[0] + " download finished!";
        spring.Reload(false, true);
      }
      if (tas.IsConnected) SayBattle(mes);
    }

    void modDownloader_DownloadCompleted(object sender, TasEventArgs e)
    {
      string mes;
      if (e.ServerParams.Count > 1 && e.ServerParams[1] != "") {
        mes = e.ServerParams[0] + " download failed: " + e.ServerParams[1];
      } else {
        mes = e.ServerParams[0] + " download finished!";
        spring.Reload(true, false);
      }
      if (tas.IsConnected) SayBattle(mes);
    }


    void spring_GameOver(object sender, SpringLogEventArgs e)
    {
      System.Threading.Thread.Sleep(3000); // wait for stats
      SayBattle("Game over, exiting");
      spring.ExitGame();

      if (config.MapCycle.Length > 0) {
        mapCycleIndex = mapCycleIndex % config.MapCycle.Length;
        SayBattle("changing to another map in mapcycle");
        ComMap(TasSayEventArgs.Default, config.MapCycle[mapCycleIndex].Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries));
        mapCycleIndex++;
      }
    }

    public void LoadConfig()
    {
      if (File.Exists(ConfigName)) {
        XmlSerializer s = new XmlSerializer(config.GetType());
        StreamReader r = File.OpenText(ConfigName);
        config = (AutoHostConfig)s.Deserialize(r);
        r.Close();
        config.AddMissingCommands();
      } else config.Defaults();

      if (File.Exists(PresetsName)) {
        XmlSerializer s = new XmlSerializer(presets.GetType());
        StreamReader r = File.OpenText(PresetsName);
        presets = (List<Preset>)s.Deserialize(r);
        r.Close();
      }

      banList.Load();
    }

    public void SaveConfig()
    {
      config.Commands.Sort(AutoHostConfig.CommandComparer);
      config.PrivilegedUsers.Sort(AutoHostConfig.UserComparer);
      presets.Sort(delegate(Preset a, Preset b) { return a.Name.CompareTo(b.Name); });

      XmlSerializer s = new XmlSerializer(config.GetType());
      FileStream f = File.OpenWrite(ConfigName);
      f.SetLength(0);
      s.Serialize(f, config);
      f.Close();

      s = new XmlSerializer(presets.GetType());
      f = File.OpenWrite(PresetsName);
      f.SetLength(0);
      s.Serialize(f, presets);
      f.Close();

      banList.Save();
    }



    public void Start(string modname, string mapname)
    {
      Stop();

      lockedByKickSpec = false;
      autoLock = 0;
      kickSpectators = config.KickSpectators;
      minCpuSpeed = config.MinCpuSpeed;

      config.BattleDetails.Validate();
      if (String.IsNullOrEmpty(modname)) modname = config.DefaultMod;
      if (String.IsNullOrEmpty(mapname)) mapname = config.DefaultMap;

      if (!spring.UnitSync.HasMap(mapname)) {
        IEnumerator<MapInfo> enu = spring.UnitSync.MapList.Values.GetEnumerator();
        enu.MoveNext();
        mapname = enu.Current.Name;
      }
      if (!spring.UnitSync.HasMod(modname)) {
        IEnumerator<ModInfo> enu = spring.UnitSync.ModList.Values.GetEnumerator();
        enu.MoveNext();
        modname = enu.Current.Name;
      }


      Battle b = new Battle(config.Password, config.HostingPort, config.MaxPlayers, config.MinRank, spring.UnitSync.GetMapInfo(mapname), config.GameTitle.Replace("%1", MainConfig.SpringieVersion), spring.UnitSync.GetModInfo(modname), config.BattleDetails);
      // if hole punching enabled then we use it
      if (config.UseHolePunching) b.Nat = Battle.NatMode.HolePunching;
      else if (Program.main.config.GargamelMode && Program.main.Stats != null) b.Nat = Battle.NatMode.FixedPorts; else b.Nat = Battle.NatMode.None;  // else either no nat or fixed ports (for gargamel fake - to get client IPs)


      for (int i = 0; i < config.DefaultRectangles.Count; ++i) {
        b.Rectangles.Add(i, config.DefaultRectangles[i]);
      }
      tas.OpenBattle(b);
    }



    void tas_BattleLockChanged(object sender, TasEventArgs e)
    {
      SayBattle("game " + (tas.GetBattle().IsLocked ? "locked" : "unlocked"));
    }

    void tas_BattleUserStatusChanged(object sender, TasEventArgs e)
    {
      UserBattleStatus u;
      Battle b = tas.GetBattle();

      if (b != null && b.ContainsUser(e.ServerParams[0], out u)) {
        if (u.SyncStatus == SyncStatuses.Unsynced) {
          SayBattle("kicking " + u.name + " - has incorrect spring or mod version");
          tas.Kick(u.name);
        }
        
        if (KickSpectators && u.IsSpectator == true && u.name != tas.UserName) {
          SayBattle(config.KickSpectatorText);
          ComKick(TasSayEventArgs.Default, new string[] { u.name });
        }
        HandleAutoLocking();


        int cnt = 0;
        foreach (UserBattleStatus ubs in b.Users) {
          if (!ubs.IsSpectator && ubs.IsReady) cnt++;
        }
        string usname; int allyno;
        if ((cnt == config.MaxPlayers || (autoLock > 0 && autoLock == cnt)) && AllReadyAndSynced(out usname) && AllUniqueTeams(out usname) && BalancedTeams(out allyno)) {
          SayBattle("server is full, starting");
          System.Threading.Thread.Sleep(1000); // just to make sure that other clients update their game info and balance ends
          ComStart(TasSayEventArgs.Default, new string[] { });
        }
      }
    }

    void tas_BattleMapChanged(object sender, TasEventArgs e)
    {
      if (config.DisplayMapLink) SayBattle("maplink: " + linker.GetMapBounceLink(tas.GetBattle().Map.Name));
    }


    private void HandleKickSpecServerLocking()
    {
      if (!spring.IsRunning && (KickSpectators || lockedByKickSpec)) {
        Battle b = tas.GetBattle();
        int cnt = b.CountPlayers();
        if (KickSpectators && cnt >= b.MaxPlayers) {
          lockedByKickSpec = true;
          tas.ChangeLock(true);
        } 
        
        if (lockedByKickSpec && cnt < b.MaxPlayers) {
          lockedByKickSpec = false;
          tas.ChangeLock(false);
        }
      }
    }

    private void HandleAutoLocking()
    {
      if (autoLock > 0) {

        Battle b = tas.GetBattle();
        int cnt = b.CountPlayers();
        if (cnt >= autoLock) {
          tas.ChangeLock(true);
        }

        if (cnt < autoLock) {
          tas.ChangeLock(false);
        }
      }
    }


    void tas_BattleUserJoined(object sender, TasEventArgs e)
    {
      string name = e.ServerParams[0];
      string welc = config.Welcome;
      if (welc != "") {
        welc = welc.Replace("%1", name);
        welc = welc.Replace("%2", GetUserLevel(name).ToString());
        welc = welc.Replace("%3", MainConfig.SpringieVersion);
        SayBattle(welc);
      }
      if (config.DisplayMapLink) SayBattle("maplink: " + linker.GetMapBounceLink(tas.GetBattle().Map.Name));

      HandleKickSpecServerLocking();
      HandleAutoLocking();

      if (minCpuSpeed > 0) {
        User u;
        if (tas.GetExistingUser(name, out u)) {
          if (u.cpu != 0 && u.cpu < minCpuSpeed * 1000) {
            System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;
            SayBattle(name + ", your CPU speed is below minimum set for this server:" + minCpuSpeed + "GHz - sorry");
            ComKick(TasSayEventArgs.Default, new string[] { u.name });
          }
        }
      }
    }


    void CheckForBattleExit()
    {
      if ((DateTime.Now - spring.GameStarted) > TimeSpan.FromSeconds(20)) {
        if (spring.IsRunning) {
          Battle b = tas.GetBattle();
          int count = 0;
          foreach (UserBattleStatus p in b.Users) {
            if (p.IsSpectator) continue;

            User u;
            if (!tas.GetExistingUser(p.name, out u)) continue;
            if (u.isInGame) count++;
          }
          if (count < 1) {
            SayBattle("closing game, " + count + " active player left in game");
            spring.ExitGame();
          }
        }
        // kontrola pro pripad ze by se nevypl spring
        User us;
        if (!spring.IsRunning && tas.GetExistingUser(tas.UserName, out us) && us.isInGame) {
          tas.ChangeMyStatus(false, false);
        }
      }

    }


    void tas_UserStatusChanged(object sender, TasEventArgs e)
    {
      if (spring.IsRunning) {
        Battle b = tas.GetBattle();
        if (e.ServerParams[0] != tas.UserName && b.ContainsUser(e.ServerParams[0])) {
          CheckForBattleExit();
        }
      }
    }

    void tas_BattleUserLeft(object sender, TasEventArgs e)
    {
      CheckForBattleExit();
      HandleKickSpecServerLocking();
      HandleAutoLocking();

      if (spring.IsRunning) {
        spring.SayGame(e.ServerParams[0] + " has left lobby");
      }

      if (e.ServerParams[0] == tempAdminName) {
        SayBattle("temp admin has left the battle");
        tempAdminName = "";
      }

      if (tas.GetBattle().IsLocked && tas.GetBattle().Users.Count < 2) { // player left and only 2 remaining (springie itself + some noob) -> unlock
        tas.ChangeLock(false);
      }
    }

    void spring_SpringExited(object sender, EventArgs e)
    {
      tas.ChangeLock(false);
    }


    public int GetUserLevel(TasSayEventArgs e)
    {
      return GetUserLevel(e.UserName);
    }

    public int GetUserLevel(string name)
    {
      foreach (PrivilegedUser pu in config.PrivilegedUsers) {
        if (pu.Name == name) {
          return pu.Level;
        }
      }
      User u;
      if (tas.GetExistingUser(name, out u)) {
        if (u.isAdmin) return config.DefaulRightsLevelForLobbyAdmins;
      }
      return config.DefaulRightsLevel;
    }


    public bool HasRights(string command, TasSayEventArgs e)
    {
      if (banList.IsBanned(e.UserName)) {
        Respond(e, "tough luck, you are banned");
        return false;
      }
      foreach (CommandConfig c in config.Commands) {
        if (c.Name == command) {
          if (c.Throttling > 0) {
            int diff = (int)DateTime.Now.Subtract(c.lastCall).TotalSeconds;
            if (diff < c.Throttling) {
              Respond(e, "AntiSpam - please wait " + (c.Throttling - diff).ToString() + " more seconds");
              return false;
            }
          }

          for (int i = 0; i < c.ListenTo.Length; i++) {
            if (c.ListenTo[i] == e.Place) {
              int reqLevel = c.Level;
              int ulevel = GetUserLevel(e);

              if (ulevel >= reqLevel) {
                // temp admin stuff
                if (tempAdminName != "" && ulevel <= config.DefaulRightsLevel && e.UserName != tempAdminName && config.DefaultRightsLevelWithTempAdmin < reqLevel) {
                  Respond(e, "Sorry, you cannot do this right now, ask temp admin " + tempAdminName);
                  return false;
                } else {
                  c.lastCall = DateTime.Now;
                  return true; // ALL OK
                }
              } else {
                Respond(e, "Sorry, you do not have rights to execute " + command);
                return false;
              }
            }
          }
          return false; // place not allowed for this command = ignore command
        }
      }
      if (e.Place != TasSayEventArgs.Places.Channel) Respond(e, "Sorry, I don't know command '" + command + "'");
      return false;
    }

    public void Respond(TasSayEventArgs e, string text)
    {
      Respond(tas, spring, e, text);
    }

    public static void Respond(TasClient tas, Spring spring, TasSayEventArgs e, string text)
    {
      TasClient.SayPlace p = TasClient.SayPlace.User;
      bool emote = false;
      if (e.Place == TasSayEventArgs.Places.Battle) {
        p = TasClient.SayPlace.Battle;
        emote = true;
      }
      if (e.Place == TasSayEventArgs.Places.Game && spring.IsRunning) {
        spring.SayGame(text);
      } else tas.Say(p, e.UserName, text, emote);
    }


    public void SayBattle(string text)
    {
      SayBattle(tas, spring, text);
    }


    public static void SayBattle(TasClient tas, Spring spring, string text)
    {
      tas.Say(TasClient.SayPlace.Battle, "", text, true);
      if (spring.IsRunning) spring.SayGame(text);
    }


    void tas_Said(object sender, TasSayEventArgs e)
    {
      // check if it's command
      if (e.Origin == TasSayEventArgs.Origins.Player && !e.IsEmote && e.Text.StartsWith("!")) {
        if (e.Text.Length < 2) return;
        string[] allwords = e.Text.Substring(1).Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
        if (allwords.Length < 1) return;
        string com = allwords[0];

        // remove first word (command)
        string[] words = Utils.ShiftArray(allwords, -1);

        if (!HasRights(com, e)) return;
        switch (com) {
          case "listmaps":
            ComListMaps(e, words);
            break;

          case "listmods":
            ComListMods(e, words);
            break;

          case "help":
            ComHelp(e, words);
            break;

          case "map":
            ComMap(e, words);
            break;

          case "admins":
            ComAdmins(e, words);
            break;


          case "start":
            ComStart(e, words);
            break;

          case "forcestart":
            ComForceStart(e, words);
            break;

          case "force":
            ComForce(e, words);
            break;

          case "split":
            ComSplit(e, words);
            break;

          case "corners":
            ComCorners(e, words);
            break;

          case "maplink":
            linker.SayResults(Utils.Glue(words), UnknownFilesLinker.FileType.Map, tas, e);
            break;

          case "modlink":
            linker.SayResults(Utils.Glue(words), UnknownFilesLinker.FileType.Mod, tas, e);
            break;


          case "ring":
            ComRing(e, words);
            break;

          case "kick":
            ComKick(e, words);
            break;

          case "exit":
            ComExit(e, words);
            break;

          case "lock":
            tas.ChangeLock(true);
            break;

          case "unlock":
            tas.ChangeLock(false);
            break;

          case "vote":
            RegisterVote(e, words);
            break;

          case "votemap":
            StartVote(new VoteMap(tas, spring, this), e, words);
            break;

          case "votekick":
            StartVote(new VoteKick(tas, spring, this), e, words);
            break;

          case "voteforcestart":
            StartVote(new VoteForceStart(tas, spring, this), e, words);
            break;

          case "voteforce":
            StartVote(new VoteForce(tas, spring, this), e, words);
            break;

          case "voteexit":
            StartVote(new VoteExit(tas, spring, this), e, words);
            break;

          case "votepreset":
            StartVote(new VotePreset(tas, spring, this), e, words);
            break;

          case "fix":
            ComFix(e, words);
            break;

          case "rehost":
            ComRehost(e, words);
            break;

          case "voterehost":
            StartVote(new VoteRehost(tas, spring, this), e, words);
            break;

          case "random":
            ComRandom(e, words);
            break;

          case "balance":
            ComBalance(e, words);
            break;

          case "setlevel":
            ComSetLevel(e, words);
            break;

          case "say":
            ComSay(e, words);
            break;

          case "dlmap":
            ComDlMap(e, words);
            break;

          case "dlmod":
            ComDlMod(e, words);
            break;


          case "reload":
            Respond(e, "reloading mod and map list");
            spring.Reload(true, true);
            Respond(e, "reload finished");
            break;

          case "team":
            ComTeam(e, words);
            break;

          case "ally":
            ComAlly(e, words);
            break;

          case "helpall":
            ComHelpAll(e, words);
            break;

          case "fixcolors":
            ComFixColors(e, words);
            break;

          case "springie":
            ComSpringie(e, words);
            break;

          case "endvote":
            StopVote();
            SayBattle("poll cancelled");
            break;

          case "addbox":
            ComAddBox(e, words);
            break;

          case "clearbox":
            ComClearBox(e, words);
            break;

          case "listpresets":
            ComListPresets(e, words);
            break;

          case "presetdetails":
            ComPresetDetails(e, words);
            break;

          case "preset":
            ComPreset(e, words);
            break;

          case "cbalance":
            ComCBalance(e, words);
            break;

          case "listbans":
            banList.ComListBans(e, words);
            break;

          case "ban":
            banList.ComBan(e, words);
            break;

          case "unban":
            banList.ComUnban(e, words);
            break;

          case "smurfs":
            RemoteCommand(Stats.smurfScript, e, words);
            break;

          case "stats":
            RemoteCommand(Stats.statsScript, e, words);
            break;

          case "kickspec":
            ComKickSpec(e, words);
            break;

          case "votekickspec":
            StartVote(new VoteKickSpec(tas, spring, this), e, words);
            break;

          case "tempadmin":
            ComTempAdmin(e, words);
            break;

          case "votetempadmin":
            StartVote(new VoteTempAdmin(tas, spring, this), e, words);
            break;

          case "setpassword":
            ComSetPassword(e, words);
            break;


          case "setgametitle":
            ComSetGameTitle(e, words);
            break;


          case "setminrank":
            ComSetMinRank(e, words);
            break;

          case "setmaxplayers":
            ComSetMaxPlayers(e, words);
            break;

          case "mincpuspeed":
            ComSetMinCpuSpeed(e, words);
            break;

          case "autolock":
            ComAutoLock(e, words);
            break;
        }
      }
    }


    public void StopVote()
    {
      pollTimer.Enabled = false;
      activePoll = null;
    }

    public void StartVote(IVotable vote, TasSayEventArgs e, string[] words)
    {
      if (vote != null) {
        if (activePoll != null) {
          Respond(e, "Another poll already in progress, please wait");
          return;
        }
        if (vote.Init(e, words)) {
          activePoll = vote;
          pollTimer.Interval = PollTimeout * 1000;
          pollTimer.Enabled = true;
        }
      }
    }

    public void RegisterVote(TasSayEventArgs e, string[] words)
    {
      if (activePoll != null) {
        if (activePoll.Vote(e, words)) {
          StopVote();
        }
      } else Respond(e, "There is no poll going on, start some first");
    }


    void pollTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
      if (activePoll != null) {
        activePoll.TimeEnd();
      }
      StopVote();
    }


    public void Stop()
    {
      StopVote();
      spring.ExitGame();
      tas.ChangeMyStatus(false, false);
      tas.LeaveBattle();
    }

  }
}
