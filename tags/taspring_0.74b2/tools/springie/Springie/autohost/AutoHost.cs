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

    const int CheckUnsyncInterval = 20; // how often to check for unsynced people
    public const int PollTimeout = 60;

    public AutoHostConfig config = new AutoHostConfig();

    public List<Preset> presets = new List<Preset>();


    TasClient tas;
    Spring spring;
    MapLinker mapLinker;
    IVotable activePoll = null;
    Timer pollTimer = null;

    //UnSyncKicker unsyncKicker;

    MapDownloader mapDownloader;
    BanList banList;

    int mapCycleIndex = 0;

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
      tas.UserRemoved += new EventHandler<TasEventArgs>(tas_UserRemoved);
      tas.UserStatusChanged += new EventHandler<TasEventArgs>(tas_UserStatusChanged);
      tas.BattleUserJoined += new EventHandler<TasEventArgs>(tas_BattleUserJoined);
      tas.BattleMapChanged += new EventHandler<TasEventArgs>(tas_BattleMapChanged);
      tas.BattleUserStatusChanged += new EventHandler<TasEventArgs>(tas_BattleUserStatusChanged);
      tas.BattleLockChanged += new EventHandler<TasEventArgs>(tas_BattleLockChanged);
      tas.BattleOpened += new EventHandler<TasEventArgs>(tas_BattleOpened);

      mapLinker = new MapLinker(spring);
      mapDownloader = new MapDownloader(spring);
      mapDownloader.DownloadCompleted += new EventHandler<TasEventArgs>(mapDownloader_DownloadCompleted);
      mapDownloader.DownloadProgressChanged += new EventHandler<TasEventArgs>(mapDownloader_DownloadProgressChanged);

      
      tas.BattleFound += new EventHandler<TasEventArgs>(tas_BattleFound);
    }

    void tas_BattleOpened(object sender, TasEventArgs e)
    {
      tas.DisableUnits(UnitInfo.ToStringList(config.DisabledUnits));
    }

    void tas_BattleFound(object sender, TasEventArgs e)
    {
      string map = Utils.Glue(e.ServerParams.ToArray(), 10).Split('\t')[0];
      if (!spring.UnitSync.MapList.ContainsKey(map)) {
        if (config.AutoDownloadNewMaps) mapDownloader.DownloadMap(map);
      }
    }


    void mapDownloader_DownloadProgressChanged(object sender, TasEventArgs e)
    {
      if (tas.IsConnected) {
        tas.Say(TasClient.SayPlace.Battle, "", e.ServerParams[0] + " " + e.ServerParams[1] + "% done", true);
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
      if (tas.IsConnected) tas.Say(TasClient.SayPlace.Battle, "", mes, true);
    }

    void spring_GameOver(object sender, SpringLogEventArgs e)
    {
      System.Threading.Thread.Sleep(3000); // wait for stats
      tas.Say(TasClient.SayPlace.Battle, "", "Game over, exiting", true);
      spring.ExitGame();

      if (config.MapCycle.Length > 0) {
        mapCycleIndex = mapCycleIndex % config.MapCycle.Length;
        tas.Say(TasClient.SayPlace.Battle, "", "changing to another map in mapcycle", true);
        ComMap(new TasSayEventArgs(TasSayEventArgs.Origins.Player, TasSayEventArgs.Places.Battle, "", tas.UserName, "", false), config.MapCycle[mapCycleIndex].Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries));
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

      for (int i = 0; i < config.DefaultRectangles.Count; ++i) {
        b.Rectangles.Add(i, config.DefaultRectangles[i]);
      }
      tas.OpenBattle(b);
      //unsyncKicker = new UnSyncKicker(tas);
    }



    void tas_BattleLockChanged(object sender, TasEventArgs e)
    {
      tas.Say(TasClient.SayPlace.Battle, "", "game " + (tas.GetBattle().IsLocked ? "locked" : "unlocked"), true);
    }

    void tas_BattleUserStatusChanged(object sender, TasEventArgs e)
    {
      UserBattleStatus u;
      if (tas.GetBattle().ContainsUser(e.ServerParams[0], out u)) {
        if (u.SyncStatus == SyncStatuses.Unsynced) {
          tas.Say(TasClient.SayPlace.Battle, "", "kicking " + u.name + " - has incorrect spring or mod version", true);
          tas.Kick(u.name);
        }
      }
    }

    void tas_BattleMapChanged(object sender, TasEventArgs e)
    {
      if (config.DisplayMapLink) tas.Say(TasClient.SayPlace.Battle, "", "maplink: " + mapLinker.GetLink(tas.GetBattle().Map.Name), true);
    }


    void tas_BattleUserJoined(object sender, TasEventArgs e)
    {
      string name = e.ServerParams[0];
      string welc = config.Welcome;
      if (welc != "") {
        welc = welc.Replace("%1", name);
        welc = welc.Replace("%2", GetUserLevel(name).ToString());
        welc = welc.Replace("%3", MainConfig.SpringieVersion);
        tas.Say(TasClient.SayPlace.Battle, name, welc, true);
      }
      if (config.DisplayMapLink) tas.Say(TasClient.SayPlace.Battle, name, "maplink: " + mapLinker.GetLink(tas.GetBattle().Map.Name), true);
    }


    void CheckForBattleExit()
    {
      if (spring.IsRunning && (DateTime.Now - spring.GameStarted) > TimeSpan.FromSeconds(20)) {
        Battle b = tas.GetBattle();
        int count = 0;
        foreach (UserBattleStatus p in b.Users) {
          if (p.IsSpectator) continue;

          User u;
          if (!tas.GetExistingUser(p.name, out u)) continue;
          if (u.isInGame) count++;
        }
        if (count < 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "closing game, " + count + " active player left in game", true);
          spring.ExitGame();
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

    void tas_UserRemoved(object sender, TasEventArgs e)
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
      if (spring.IsRunning) {
        CheckForBattleExit();
        spring.SayGame(e.ServerParams[0] + " has left lobby");
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
      int ulevel = config.DefaulRightsLevel;
      foreach (PrivilegedUser pu in config.PrivilegedUsers) {
        if (pu.Name == name) {
          ulevel = pu.Level;
          break;
        }
      }
      return ulevel;
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
                c.lastCall = DateTime.Now;
                return true; // ALL OK
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
      if (e.Place == TasSayEventArgs.Places.Game) {
        spring.SayGame(text);
      } else tas.Say(p, e.UserName, text, emote);
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
            mapLinker.SayResults(Utils.Glue(words), tas, e);
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
            tas.Say(TasClient.SayPlace.Battle, "", "poll cancelled", true);
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
      //if (unsyncKicker != null) unsyncKicker.Close();
      //unsyncKicker = null;
      spring.ExitGame();
      tas.ChangeMyStatus(false, false);
      tas.LeaveBattle();
    }

  }
}
