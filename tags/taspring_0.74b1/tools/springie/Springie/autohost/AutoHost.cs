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
    const int CheckUnsyncInterval = 20; // how often to check for unsynced people
    public const int PollTimeout = 60;

    public AutoHostConfig config = new AutoHostConfig();
    TasClient tas;
    Spring spring;
    MapLinker mapLinker;
    IVotable activePoll = null;
    Timer pollTimer = null;

    UnSyncKicker unsyncKicker;

    MapDownloader mapDownloader;

    public AutoHost(TasClient tas, Spring spring, AutoHostConfig conf)
    {
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

      mapLinker = new MapLinker(spring);
      mapDownloader = new MapDownloader(spring);
      mapDownloader.DownloadCompleted += new EventHandler<TasEventArgs>(mapDownloader_DownloadCompleted);
      mapDownloader.DownloadProgressChanged += new EventHandler<TasEventArgs>(mapDownloader_DownloadProgressChanged);

      tas.BattleFound += new EventHandler<TasEventArgs>(tas_BattleFound);
    }

    void tas_BattleFound(object sender, TasEventArgs e)
    {
      string map = Utils.Glue(e.ServerParams.ToArray(), 9).Split('\t')[0];
      if (!spring.UnitSync.MapList.Contains(map)) {
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
    }

    public void SaveConfig()
    {
      config.Commands.Sort(AutoHostConfig.CommandComparer);
      config.PrivilegedUsers.Sort(AutoHostConfig.UserComparer);

      XmlSerializer s = new XmlSerializer(config.GetType());
      FileStream f = File.OpenWrite(ConfigName);
      f.SetLength(0);
      s.Serialize(f, config);
      f.Close();
    }



    public void Start(string modname, string mapname)
    {
      Stop();

      config.BattleDetails.Validate();
      if (String.IsNullOrEmpty(modname)) modname = config.DefaultMod;
      if (String.IsNullOrEmpty(mapname)) mapname = config.DefaultMap;

      if (!spring.UnitSync.HasMap(mapname)) {
        mapname = spring.UnitSync.MapList[0];
      }
      if (!spring.UnitSync.HasMod(modname)) {
        IEnumerator<ModInfo> enu = spring.UnitSync.ModList.Values.GetEnumerator();
        enu.MoveNext();
        modname = enu.Current.Name;
      }

      TasClient.Battle b = new TasClient.Battle(config.Password, config.HostingPort, config.MaxPlayers, config.MinRank, mapname, config.GameTitle.Replace("%1", MainConfig.SpringieVersion), spring.UnitSync.GetModInfo(modname), config.BattleDetails);

      for (int i = 0; i < config.DefaultRectangles.Count; ++i) {
        b.Rectangles.Add(i, config.DefaultRectangles[i]);
      }
      tas.OpenBattle(b);
      unsyncKicker = new UnSyncKicker(tas);
    }



    void tas_BattleLockChanged(object sender, TasEventArgs e)
    {
      tas.Say(TasClient.SayPlace.Battle, "", "game " + (tas.GetBattle().IsLocked ? "locked" : "unlocked"), true);
    }

    void tas_BattleUserStatusChanged(object sender, TasEventArgs e)
    {
      TasClient.UserBattleStatus u;
      if (tas.GetBattle().ContainsUser(e.ServerParams[0], out u)) {
        if (u.SyncStatus == TasClient.SyncStatuses.Unsynced) {
          tas.Say(TasClient.SayPlace.Battle, "", "kicking " + u.name + " - has incorrect spring or mod version", true);
          tas.Kick(u.name);
        }
      }
    }

    void tas_BattleMapChanged(object sender, TasEventArgs e)
    {
      tas.Say(TasClient.SayPlace.Battle, "", "maplink: " + mapLinker.GetLink(tas.GetBattle().Map), true);
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
      tas.Say(TasClient.SayPlace.Battle, name, "maplink: " + mapLinker.GetLink(tas.GetBattle().Map), true);
    }


    void CheckForBattleExit()
    {
      if (spring.IsRunning && (DateTime.Now - spring.GameStarted) > TimeSpan.FromSeconds(20)) {
        TasClient.Battle b = tas.GetBattle();
        int count = 0;
        foreach (TasClient.UserBattleStatus p in b.Users) {
          if (p.IsSpectator) continue;

          TasClient.User u;
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
        TasClient.Battle b = tas.GetBattle();
        if (e.ServerParams[0] != tas.UserName && b.ContainsUser(e.ServerParams[0])) {
          CheckForBattleExit();
        }
      }
    }

    void tas_UserRemoved(object sender, TasEventArgs e)
    {
      if (spring.IsRunning) {
        TasClient.Battle b = tas.GetBattle();
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
      foreach (CommandConfig c in config.Commands) {
        if (c.Name == command) {
          if (c.Throttling > 0) {
            int diff = DateTime.Now.Subtract(c.lastCall).Seconds;
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
        string[] allwords = e.Text.Substring(1).Split(new char[] {' '}, StringSplitOptions.RemoveEmptyEntries);
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
      if (unsyncKicker != null) unsyncKicker.Close();
      unsyncKicker = null;
      spring.ExitGame();
      tas.ChangeMyStatus(false, false);
      tas.LeaveBattle();
    }

  }
}
