#region using

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading;
using System.Timers;
using System.Xml.Serialization;
using Springie.AutoHostNamespace;
using Springie.Client;
using Springie.SpringNamespace;
using Timer=System.Timers.Timer;

#endregion

namespace Springie.autohost
{
    public partial class AutoHost
    {
        #region Constants

        public const string BoxesName = "boxes.bin";
        public const string ConfigName = "autohost.xml";

        public const int PollTimeout = 60;
        public const string PresetsName = "presets.xml";

        #endregion

        #region Fields

        private IVotable activePoll;
        private int autoLock;
        private BanList banList;
        private string bossName = "";
        private string delayedModChange;


        private bool kickMinRank;
        private bool kickSpectators;
        private ResourceLinkProvider linkProvider;
        private bool lockedByKickSpec;

        private AutoManager manager;
        private int mapCycleIndex;


        private double minCpuSpeed;
        private Timer pollTimer;
        private object savLock = new object();
        private Spring spring;
        private TasClient tas;

        #endregion

        #region Properties

        public string BossName
        {
            get { return bossName; }
            set { bossName = value; }
        }

        public AutoHostConfig config = new AutoHostConfig();

        public bool KickSpectators
        {
            get { return kickSpectators; }
        }

        public Ladder ladder;
        public Dictionary<string, Dictionary<int, BattleRect>> MapBoxes = new Dictionary<string, Dictionary<int, BattleRect>>();

        public double MinCpuSpeed
        {
            get { return minCpuSpeed; }
        }

        public List<Preset> presets = new List<Preset>();

        #endregion

        #region Constructors

        public AutoHost(TasClient tas, Spring spring, AutoHostConfig conf)
        {
            banList = new BanList(this, tas);

            if (conf == null) LoadConfig();
            else config = conf;
            SaveConfig();

            this.tas = tas;
            this.spring = spring;

            tas.Said += tas_Said;

            pollTimer = new Timer(PollTimeout*1000);
            pollTimer.Enabled = false;
            pollTimer.AutoReset = false;
            pollTimer.Elapsed += pollTimer_Elapsed;

            spring.SpringExited += spring_SpringExited;
            spring.GameOver += spring_GameOver;
            spring.NotifyModsChanged += spring_NotifyModsChanged;

            tas.BattleUserLeft += tas_BattleUserLeft;
            tas.UserStatusChanged += tas_UserStatusChanged;
            tas.BattleUserJoined += tas_BattleUserJoined;
            tas.BattleMapChanged += tas_BattleMapChanged;
            tas.BattleUserStatusChanged += tas_BattleUserStatusChanged;
            tas.BattleLockChanged += tas_BattleLockChanged;
            tas.BattleOpened += tas_BattleOpened;

            linkProvider = new ResourceLinkProvider();
            spring.UnitSyncWrapper.Downloader.LinksRecieved += linkProvider.Downloader_LinksRecieved;
        }

        #endregion

        /*void fileDownloader_DownloadProgressChanged(object sender, TasEventArgs e)
    {
      if (tas.IsConnected) {
        SayBattle(e.ServerParams[0] + " " + e.ServerParams[1] + "% done");
      }
    }*/

        #region Public methods

        public int GetUserLevel(TasSayEventArgs e)
        {
            return GetUserLevel(e.UserName);
        }

        public int GetUserLevel(string name)
        {
            foreach (var pu in config.PrivilegedUsers) if (pu.Name == name) return pu.Level;
            User u;
            if (tas.GetExistingUser(name, out u)) if (u.isAdmin) return config.DefaulRightsLevelForLobbyAdmins;
            return config.DefaulRightsLevel;
        }


        public bool HasRights(string command, TasSayEventArgs e)
        {
            if (banList.IsBanned(e.UserName)) {
                Respond(e, "tough luck, you are banned");
                return false;
            }
            foreach (var c in config.Commands) {
                if (c.Name == command) {
                    if (c.Throttling > 0) {
                        int diff = (int) DateTime.Now.Subtract(c.lastCall).TotalSeconds;
                        if (diff < c.Throttling) {
                            Respond(e, "AntiSpam - please wait " + (c.Throttling - diff) + " more seconds");
                            return false;
                        }
                    }

                    for (int i = 0; i < c.ListenTo.Length; i++) {
                        if (c.ListenTo[i] == e.Place) {
                            int reqLevel = c.Level;
                            int ulevel = GetUserLevel(e);

                            if (ulevel >= reqLevel) {
                                // boss stuff
                                if (bossName != "" && ulevel <= config.DefaulRightsLevel && e.UserName != bossName && config.DefaultRightsLevelWithBoss < reqLevel) {
                                    Respond(e, "Sorry, you cannot do this right now, ask boss admin " + bossName);
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

        public void LoadConfig()
        {
            if (File.Exists(Program.WorkPath + '/' + ConfigName)) {
                var s = new XmlSerializer(config.GetType());
                var r = File.OpenText(Program.WorkPath + '/' + ConfigName);
                config = (AutoHostConfig) s.Deserialize(r);
                r.Close();
                config.AddMissingCommands();
            } else config.Defaults();

            if (File.Exists(Program.WorkPath + '/' + PresetsName)) {
                var s = new XmlSerializer(presets.GetType());
                using (var r = File.OpenText(Program.WorkPath + '/' + PresetsName)) {
                    presets = (List<Preset>) s.Deserialize(r);
                    r.Close();
                }
            }

            if (File.Exists(Program.WorkPath + '/' + BoxesName)) {
                var frm = new BinaryFormatter();
                using (var r = new FileStream(Program.WorkPath + '/' + BoxesName, FileMode.Open)) {
                    MapBoxes = (Dictionary<string, Dictionary<int, BattleRect>>) frm.Deserialize(r);
                    r.Close();
                }
            }

            banList.Load();
        }

        public void RegisterVote(TasSayEventArgs e, string[] words)
        {
            if (activePoll != null) {
                if (activePoll.Vote(e, words)) StopVote();
            } else Respond(e, "There is no poll going on, start some first");
        }

        public void Respond(TasSayEventArgs e, string text)
        {
            Respond(tas, spring, e, text);
        }

        public static void Respond(TasClient tas, Spring spring, TasSayEventArgs e, string text)
        {
            var p = TasClient.SayPlace.User;
            bool emote = false;
            if (e.Place == TasSayEventArgs.Places.Battle) {
                p = TasClient.SayPlace.Battle;
                emote = true;
            }
            if (e.Place == TasSayEventArgs.Places.Game && spring.IsRunning) spring.SayGame(text);
            else tas.Say(p, e.UserName, text, emote);
        }

        public void SaveConfig()
        {
            lock (savLock) {
                config.Commands.Sort(AutoHostConfig.CommandComparer);

                // remove duplicated admins
                var l = new List<PrivilegedUser>();
                foreach (var p in config.PrivilegedUsers) if (l.Find(delegate(PrivilegedUser u) { return u.Name == p.Name; }) == null) l.Add(p);
                ;
                config.PrivilegedUsers = l;
                config.PrivilegedUsers.Sort(AutoHostConfig.UserComparer);

                presets.Sort(delegate(Preset a, Preset b) { return a.Name.CompareTo(b.Name); });

                var s = new XmlSerializer(config.GetType());
                var f = File.OpenWrite(Program.WorkPath + '/' + ConfigName);
                f.SetLength(0);
                s.Serialize(f, config);
                f.Close();

                s = new XmlSerializer(presets.GetType());
                f = File.OpenWrite(Program.WorkPath + '/' + PresetsName);
                f.SetLength(0);
                s.Serialize(f, presets);
                f.Close();

                banList.Save();

                var fm = new BinaryFormatter();
                using (var fs = new FileStream(Program.WorkPath + '/' + BoxesName, FileMode.Create)) {
                    fm.Serialize(fs, MapBoxes);
                    fs.Close();
                }
            }
        }


        public void SayBattle(string text)
        {
            SayBattle(text, true);
        }

        public void SayBattle(string text, bool ingame)
        {
            SayBattle(tas, spring, text, ingame);
        }


        public static void SayBattle(TasClient tas, Spring spring, string text, bool ingame)
        {
            tas.Say(TasClient.SayPlace.Battle, "", text, true);
            if (spring.IsRunning && ingame) spring.SayGame(text);
        }

        public void Start(string modname, string mapname)
        {
            Stop();

            manager = new AutoManager(this, tas, spring);
            lockedByKickSpec = false;
            autoLock = 0;
            kickSpectators = config.KickSpectators;
            minCpuSpeed = config.MinCpuSpeed;
            kickMinRank = config.KickMinRank;

            if (config.LadderId > 0) ladder = new Ladder(config.LadderId);
            else ladder = null;

            if (String.IsNullOrEmpty(modname)) modname = config.DefaultMod;
            if (String.IsNullOrEmpty(mapname)) mapname = config.DefaultMap;

            if (!spring.UnitSyncWrapper.HasMap(mapname)) {
                IEnumerator<MapInfo> enu = spring.UnitSyncWrapper.MapList.Values.GetEnumerator();
                enu.MoveNext();
                mapname = enu.Current.Name;
            }
            if (!string.IsNullOrEmpty(config.AutoUpdateMod)) {
                string latest = spring.UnitSyncWrapper.GetNewestModVersion(config.AutoUpdateMod);
                if (latest != null) modname = latest;
            }

            if (!spring.UnitSyncWrapper.HasMod(modname)) {
                IEnumerator<ModInfo> enu = spring.UnitSyncWrapper.ModList.Values.GetEnumerator();
                enu.MoveNext();
                modname = enu.Current.Name;
            }

            int mint, maxt;
            var b = new Battle((ladder == null ? config.Password : "ladderlock2"), config.HostingPort, config.MaxPlayers, config.MinRank, spring.UnitSyncWrapper.GetMapInfo(mapname), (ladder != null ? "(ladder " + ladder.Id + ") " : "") + config.GameTitle.Replace("%1", MainConfig.SpringieVersion), spring.UnitSyncWrapper.GetModInfo(modname), (ladder != null ? ladder.CheckBattleDetails(config.BattleDetails, out mint, out maxt) : config.BattleDetails));
            // if hole punching enabled then we use it
            if (config.UseHolePunching) b.Nat = Battle.NatMode.HolePunching;
            else if (Program.main.config.GargamelMode && Program.main.Stats != null) b.Nat = Battle.NatMode.FixedPorts;
            else b.Nat = Battle.NatMode.None; // else either no nat or fixed ports (for gargamel fake - to get client IPs)

            for (int i = 0; i < config.DefaultRectangles.Count; ++i) b.Rectangles.Add(i, config.DefaultRectangles[i]);
            tas.OpenBattle(b);
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
                    pollTimer.Interval = PollTimeout*1000;
                    pollTimer.Enabled = true;
                }
            }
        }


        public void Stop()
        {
            if (manager != null) manager.Stop();
            StopVote();
            spring.ExitGame();
            tas.ChangeMyStatus(false, false);
            tas.LeaveBattle();
        }

        public void StopVote()
        {
            pollTimer.Enabled = false;
            activePoll = null;
        }

        #endregion

        #region Other methods

        private void CheckForBattleExit()
        {
            if ((DateTime.Now - spring.GameStarted) > TimeSpan.FromSeconds(20)) {
                if (spring.IsRunning) {
                    var b = tas.GetBattle();
                    int count = 0;
                    foreach (var p in b.Users) {
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
                if (!spring.IsRunning && tas.GetExistingUser(tas.UserName, out us) && us.isInGame) tas.ChangeMyStatus(false, false);
            }
        }

        private void HandleAutoLocking()
        {
            if (autoLock > 0 && (!spring.IsRunning)) {
                var b = tas.GetBattle();
                int cnt = b.CountPlayers();
                if (cnt >= autoLock) tas.ChangeLock(true);

                if (cnt < autoLock) tas.ChangeLock(false);
            }
        }

        private void HandleKickSpecServerLocking()
        {
            if (!spring.IsRunning && (KickSpectators || lockedByKickSpec)) {
                var b = tas.GetBattle();
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

        private void HandleMinRankKicking()
        {
            if (kickMinRank && config.MinRank > 0) {
                var b = tas.GetBattle();
                if (b != null) {
                    foreach (var u in b.Users) {
                        User x;
                        tas.GetExistingUser(u.name, out x);
                        if (u.name != tas.UserName && x.rank < config.MinRank) {
                            SayBattle(x.name + ", your rank is too low, rank kicking is enabled here");
                            ComKick(TasSayEventArgs.Default, new[] {u.name});
                        }
                    }
                }
            }
        }

        #endregion

        #region Event Handlers


        private void pollTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            if (activePoll != null) activePoll.TimeEnd();
            StopVote();
        }

        private void spring_GameOver(object sender, SpringLogEventArgs e)
        {
            SayBattle("Game over, exiting");
            new Thread(x =>
                           {
                               Thread.Sleep(3000); // wait for stats
                               spring.ExitGame();
                           }).Start();

            if (config.MapCycle.Length > 0) {
                mapCycleIndex = mapCycleIndex%config.MapCycle.Length;
                SayBattle("changing to another map in mapcycle");
                ComMap(TasSayEventArgs.Default, config.MapCycle[mapCycleIndex].Split(new[] {' '}, StringSplitOptions.RemoveEmptyEntries));
                mapCycleIndex++;
            }
        }

        private void spring_NotifyModsChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(config.AutoUpdateMod)) {
                string latest = spring.UnitSyncWrapper.GetNewestModVersion(config.AutoUpdateMod);
                var b = tas.GetBattle();
                if (!string.IsNullOrEmpty(latest) && b != null && b.Mod != null & b.Mod.Name != latest) {
                    config.DefaultMod = latest;
                    if (!spring.IsRunning) {
                        SayBattle("Updating to latest mod version: " + latest);
                        ComRehost(TasSayEventArgs.Default, new[] {latest});
                    } else delayedModChange = latest;
                }
            }
        }

        private void spring_SpringExited(object sender, EventArgs e)
        {
            tas.ChangeLock(false);
            var b = tas.GetBattle();
            foreach (var s in toNotify) {
                if (b != null && b.ContainsUser(s)) tas.Ring(s);
                tas.Say(TasClient.SayPlace.User, s, "** Game just ended, join me! **", false);
            }
            toNotify.Clear();
            if (!string.IsNullOrEmpty(delayedModChange)) {
                string mod = delayedModChange;
                delayedModChange = null;
                SayBattle("Updating to latest mod version: " + mod);
                ComRehost(TasSayEventArgs.Default, new[] {mod});
            }
        }


        private void tas_BattleLockChanged(object sender, TasEventArgs e)
        {
            SayBattle("game " + (tas.GetBattle().IsLocked ? "locked" : "unlocked"), false);
        }

        private void tas_BattleMapChanged(object sender, TasEventArgs e)
        {
            var b = tas.GetBattle();
            string mapName = b.Map.Name.ToLower();
            if (MapBoxes.ContainsKey(mapName)) {
                for (int i = 0; i < b.Rectangles.Count; ++i) tas.RemoveBattleRectangle(i);
                var dict = MapBoxes[mapName];
                foreach (var v in dict) tas.AddBattleRectangle(v.Key, v.Value);
            }

            if (Program.main.PlanetWars != null) Program.main.PlanetWars.MapChanged();
        }

        private void tas_BattleOpened(object sender, TasEventArgs e)
        {
            tas.DisableUnits(UnitInfo.ToStringList(config.DisabledUnits));
        }

        private void tas_BattleUserJoined(object sender, TasEventArgs e)
        {
            string name = e.ServerParams[0];
            string welc = config.Welcome;
            if (welc != "") {
                welc = welc.Replace("%1", name);
                welc = welc.Replace("%2", GetUserLevel(name).ToString());
                welc = welc.Replace("%3", MainConfig.SpringieVersion);
                SayBattle(welc, false);
            }
            if (spring.IsRunning) {
                var started = DateTime.Now.Subtract(spring.GameStarted);
                started = new TimeSpan((int) started.TotalHours, started.Minutes, started.Seconds);
                SayBattle(string.Format("GAME IS CURRENTLY IN PROGRESS, PLEASE WAIT TILL IT ENDS! Running for {0}", started), false);
                SayBattle("If you say !notify, I will PM you when game ends.", false);
            }

            HandleKickSpecServerLocking();
            HandleAutoLocking();
            HandleMinRankKicking();

            if (minCpuSpeed > 0) {
                User u;
                if (tas.GetExistingUser(name, out u)) {
                    if (u.cpu != 0 && u.cpu < minCpuSpeed*1000) {
                        Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
                        SayBattle(name + ", your CPU speed is below minimum set for this server:" + minCpuSpeed + "GHz - sorry");
                        ComKick(TasSayEventArgs.Default, new[] {u.name});
                    }
                }
            }
            if (Program.main.PlanetWars != null) Program.main.PlanetWars.UserJoined(name);
        }

        private void tas_BattleUserLeft(object sender, TasEventArgs e)
        {
            CheckForBattleExit();
            HandleKickSpecServerLocking();
            HandleAutoLocking();

            if (spring.IsRunning) spring.SayGame(e.ServerParams[0] + " has left lobby");

            if (e.ServerParams[0] == bossName) {
                SayBattle("boss has left the battle");
                bossName = "";
            }

            if (tas.GetBattle().IsLocked && tas.GetBattle().Users.Count < 2) {
                // player left and only 2 remaining (springie itself + some noob) -> unlock
                tas.ChangeLock(false);
            }
        }

        private void tas_BattleUserStatusChanged(object sender, TasEventArgs e)
        {
            UserBattleStatus u;
            var b = tas.GetBattle();

            if (b != null && b.ContainsUser(e.ServerParams[0], out u)) {
                if (KickSpectators && u.IsSpectator && u.name != tas.UserName) {
                    SayBattle(config.KickSpectatorText);
                    ComKick(TasSayEventArgs.Default, new[] {u.name});
                }
                HandleAutoLocking();

                int cnt = 0;
                foreach (var ubs in b.Users) if (!ubs.IsSpectator && ubs.IsReady) cnt++;
                List<string> usname;
                int allyno;
                if (!manager.Enabled) {
                    if ((cnt == config.MaxPlayers || (autoLock > 0 && autoLock == cnt)) && !Program.main.config.PlanetWarsEnabled && AllReadyAndSynced(out usname) && AllUniqueTeams(out usname) && BalancedTeams(out allyno)) {
                        SayBattle("server is full, starting");
                        Thread.Sleep(1000); // just to make sure that other clients update their game info and balance ends
                        ComStart(TasSayEventArgs.Default, new string[] {});
                    }
                }
            }
        }

        private void tas_Said(object sender, TasSayEventArgs e)
        {
            // check if it's command
            if (e.Origin == TasSayEventArgs.Origins.Player && !e.IsEmote && e.Text.StartsWith("!")) {
                if (e.Text.Length < 2) return;
                var allwords = e.Text.Substring(1).Split(new[] {' '}, StringSplitOptions.RemoveEmptyEntries);
                if (allwords.Length < 1) return;
                string com = allwords[0];

                // remove first word (command)
                var words = Utils.ShiftArray(allwords, -1);

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
                        linkProvider.FindLinks(words, ResourceLinkProvider.FileType.Map, tas, e);
                        break;

                    case "modlink":
                        linkProvider.FindLinks(words, ResourceLinkProvider.FileType.Mod, tas, e);
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


                    case "id":
                        ComTeam(e, words);
                        break;

                    case "team":
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

                    case "manage":
                        ComManage(e, words);
                        break;

                    case "notify":
                        ComNotify(e, words);
                        break;

                    case "votekickspec":
                        StartVote(new VoteKickSpec(tas, spring, this), e, words);
                        break;

                    case "boss":
                        ComBoss(e, words);
                        break;

                    case "voteboss":
                        StartVote(new VoteBoss(tas, spring, this), e, words);
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

                    case "spec":
                        ComForceSpectator(e, words);
                        break;

                    case "specafk":
                        ComForceSpectatorAfk(e, words);
                        break;

                    case "kickminrank":
                        ComKickMinRank(e, words);
                        break;

                    case "cheats":
                        if (spring.IsRunning) {
                            spring.SayGame("/cheat");
                            SayBattle("Cheats!");
                        } else Respond(e, "Cannot set cheats, game not running");
                        break;

                    case "listoptions":
                        ComListOptions(e, words);
                        break;

                    case "setoptions":
                        ComSetOption(e, words);
                        break;

                    case "votesetoptions":
                        StartVote(new VoteSetOptions(tas, spring, this), e, words);
                        break;

                    case "listplanets":
                        if (Program.main.PlanetWars != null) Program.main.PlanetWars.ComListPlanets(e, words);
                        else Respond(e, "Not a PlanetWars server");
                        break;

                    case "register":
                        if (Program.main.PlanetWars != null) Program.main.PlanetWars.ComRegister(e, words);
                        else Respond(e, "Not a PlanetWars autohost");
                        break;


                    case "planet":
                    case "attack":
                        if (Program.main.PlanetWars != null) Program.main.PlanetWars.ComPlanet(e, words);
                        else Respond(e, "Not a PlanetWars server");
                        break;

                    case "setpwserver":
                        if (words.Length < 1) Respond(e, "Specify address");
                        else {
                            // hack this is just debug, remove this later
                            Program.main.config.PlanetWarsServer = words[0];
                            Program.main.InitializePlanetWarsServer();
                            Respond(e, "Planetwars server changed to " + words[0]);
                        }
                        break;

                    case "voteplanet":
                    case "voteattack":
                        if (Program.main.config.PlanetWarsEnabled) StartVote(new VotePlanet(tas, spring, this), e, words);
                        else Respond(e, "PlanetWars not enabled on this host");
                        break;
                    case "resetpassword":
                        if (Program.main.PlanetWars != null) Program.main.PlanetWars.ComResetPassword(e);
                        else Respond(e, "This is not PlanetWars autohost");

                        break;
                }
            }
        }

        private void tas_UserStatusChanged(object sender, TasEventArgs e)
        {
            if (spring.IsRunning) {
                var b = tas.GetBattle();
                if (e.ServerParams[0] != tas.UserName && b.ContainsUser(e.ServerParams[0])) CheckForBattleExit();
            }
        }

        #endregion
    }
}