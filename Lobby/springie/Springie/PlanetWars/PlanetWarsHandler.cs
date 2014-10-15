#region using

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Timers;
using PlanetWarsShared;
using PlanetWarsShared.Springie;
using Springie.autohost;
using Springie.Client;

#endregion

namespace Springie.PlanetWars
{
    public class PlanetWarsHandler : IDisposable
    {
        #region SpringMessageType enum

        public enum SpringMessageType
        {
            pwaward,
            pwmorph,
            pwpurchase,
            pwdeath
        }

        #endregion

        #region Fields

        private AutoHost autoHost;
        private List<string> channelAllowedExceptions = new List<string>();
        private List<string> planetWarsChannels = new List<string>();
        private Dictionary<string, string> planetWarsPlayerSide = new Dictionary<string, string>();


        private string host;
        private TasClient tas;
        private Timer timer = new Timer();

        #endregion

        #region Properties

        public AuthInfo account;
        public ISpringieServer server;

        #endregion

        #region Constructors

        public PlanetWarsHandler(string host, int port, AutoHost autoHost, TasClient tas, MainConfig config)
        {
            this.autoHost = autoHost;
            this.tas = tas;
            this.host = host;
            account = new AuthInfo(config.AccountName, config.PlanetWarsServerPassword);

            server = (ISpringieServer) Activator.GetObject(typeof (ISpringieServer), String.Format("tcp://{0}:{1}/IServer", host, port));
            // fill factions for channel monitoring and join channels
            planetWarsChannels = new List<string>();
            var factions = server.GetFactions(account);
            foreach (var fact in factions) {
                string name = fact.Name.ToLower();
                planetWarsChannels.Add(name);
                if (!config.JoinChannels.Contains(name)) {
                    var list = new List<string>(config.JoinChannels);
                    list.Add(name);
                    config.JoinChannels = list.ToArray();
                    if (tas != null && tas.IsConnected && tas.IsLoggedIn) tas.JoinChannel(name);
                }
            }
            timer.Interval = 2000;
            timer.Elapsed += timer_Elapsed;
            timer.AutoReset = true;
            timer.Start();
        }

        public void Dispose()
        {
            timer.Stop();
            timer.Elapsed -= timer_Elapsed;
        }

        #endregion

        #region Public methods

        public void ComListPlanets(TasSayEventArgs e, string[] words)
        {
            string[] vals;
            int[] indexes;
            try {
                if (FilterPlanets(words, out vals, out indexes) > 0) {
					autoHost.Respond(e, string.Format("{0} can attack:", server.GetOffensiveFaction(account).Name));
                    for (int i = 0; i < vals.Length; ++i) autoHost.Respond(e, string.Format("{0}: {1}", indexes[i], vals[i]));
                } else autoHost.Respond(e, "no such planet found");
            } catch (Exception ex) {
                autoHost.Respond(e, string.Format("Error getting planets: {0}", ex));
            }
        }

        public void ComPlanet(TasSayEventArgs e, string[] words)
        {
            if (words.Length == 0) {
                autoHost.Respond(e, "You must specify planet name");
                return;
            }
            string[] vals;
            int[] indexes;
            if (FilterPlanets(words, out vals, out indexes) > 0) {
                var info = server.GetPlayerInfo(account, e.UserName);
                var fact = server.GetOffensiveFaction(account);
                bool canset = false;
                string bestPlayer = "";
                if (info != null) {
                    if (info.IsCommanderInChief) canset = true;
                    else {
                        canset = true;
                        int bestRank = info.RankOrder;
                        foreach (var u in tas.GetBattle().Users) {
                            if (!u.IsSpectator && u.name != e.UserName && tas.GetBattle().Mod.Sides[u.Side].ToLower() == info.FactionName.ToLower()) {
                                var pi = server.GetPlayerInfo(account, u.name);
                                if (pi != null && pi.RankOrder < bestRank) {
                                    // someone sle with better rank exists
                                    bestPlayer = pi.Name;
                                    bestRank = pi.RankOrder;
                                    canset = false;
                                }
                            }
                        }
                    }
                }

                if (canset) {
                    if (info.FactionName == fact.Name) {
                        string pname = vals[0].Split('|')[0];
                        autoHost.SayBattle(string.Format("changing planet to {0} by {1}", pname, e.UserName));
                        var planet = server.GetAttackOptions(account).Where(m => m.Name == pname).Single();
                        tas.ChangeMap(Program.main.Spring.UnitSyncWrapper.MapList[planet.MapName]);
                    } else autoHost.Respond(e, string.Format("It's currently {0} turn", fact.Name));
                } else autoHost.Respond(e, string.Format("You are not first in command here, {0} must do it!", bestPlayer));
            } else autoHost.Respond(e, "Cannot find such planet.");
        }

        public void ComRegister(TasSayEventArgs e, string[] words)
        {
            if (words.Length < 2) {
                autoHost.Respond(e, "This command needs 2-3 parameters - side and password and optional planet name (you can PM it to me). Eg. !register core secretpw");
                return;
            }

            try {
                string response = server.Register(account, new AuthInfo {Login = e.UserName, Password = words[1]}, words[0], words.Length > 2 ? Utils.Glue(words, 2) : null);
                autoHost.Respond(e, string.Format(response));
            } catch (Exception ex) {
                autoHost.Respond(e, string.Format("Error when registering: {0}", ex));
            }
        }

        public void ComResetPassword(TasSayEventArgs e)
        {
            try {
                autoHost.Respond(e, server.ResetPassword(account, e.UserName));
            } catch (Exception ex) {
                autoHost.SayBattle("Error reseting password: " + ex);
            }
        }

        public int FilterPlanets(string[] words, out string[] vals, out int[] indexes)
        {
            var options = server.GetAttackOptions(account);

            if (options != null) {
                var temp = new string[options.Count];
                int cnt = 0;

                foreach (var planet in options) temp[cnt++] = string.Format("{0}|  {1}", planet.Name, Path.GetFileNameWithoutExtension(planet.MapName));
                return AutoHost.Filter(temp, words, out vals, out indexes);
            } else {
                vals = null;
                indexes = null;
                return 0;
            }
        }

        public void MapChanged()
        {
            try {
                string name = tas.GetBattle().Map.Name;
                var mapInfo = server.GetAttackOptions(account).Where(m => m.MapName == name).Single();
                if (mapInfo.StartBoxes != null && mapInfo.StartBoxes.Count > 0) {
                    int rectangles = tas.GetBattle().Rectangles.Count;
                    for (int i = 0; i < rectangles; ++i) tas.RemoveBattleRectangle(i);
                    for (int i = 0; i < mapInfo.StartBoxes.Count; ++i) {
                        var mi = mapInfo.StartBoxes[i];
                        tas.AddBattleRectangle(i, new BattleRect(mi.Left, mi.Top, mi.Right, mi.Bottom));
                    }
                }

                foreach (var command in mapInfo.AutohostCommands) tas.Say(TasClient.SayPlace.Channel, tas.UserName, command, false);

                autoHost.SayBattle(String.Format("Welcome to {0}!  (http://{2}/planet.aspx?name={1})", mapInfo.Name, Uri.EscapeUriString(mapInfo.Name), host));

                var notifyList = server.GetPlayersToNotify(account, name, ReminderEvent.OnBattlePreparing);
                foreach (var userName in notifyList) tas.Say(TasClient.SayPlace.User, userName, string.Format("Planet {0} is under attack! Join the fight!", mapInfo.Name), false);
            } catch (Exception ex) {
                autoHost.SayBattle(string.Format("Error setting planet starting boxes: {0}", ex));
            }
        }

        public void SendBattleResult(Battle battle, Dictionary<string, EndGamePlayerInfo> players)
        {
            try {
                var response = server.SendBattleResult(account, battle.Map.Name, players.Values);


                autoHost.SayBattle(response.MessageToDisplay);
                var users = tas.GetBattle().Users;
                foreach (var p in players.Values) if (p.Name != tas.UserName && users.Find(x => x.name == p.Name) == null) tas.Say(TasClient.SayPlace.User, p.Name, response.MessageToDisplay, false);

                foreach (var kvp in response.RankNotifications) tas.Say(TasClient.SayPlace.User, kvp.Name, kvp.Text, false);

                ComListPlanets(TasSayEventArgs.Default, new string[] {});
            } catch (Exception ex) {
                autoHost.SayBattle(string.Format("Error sending planet battle result :(( {0}", ex), true);
            }
        }

        public void SpringExited()
        {
            try {
                var toNotify = server.GetPlayersToNotify(account, tas.GetBattle().Map.Name, ReminderEvent.OnBattleEnded);
                foreach (var s in toNotify) tas.Say(TasClient.SayPlace.User, s, "PlanetWars battle has just ended.", false);
            } catch (Exception ex) {
                autoHost.SayBattle("Error notifying game end:" + ex);
            }
        }


        public void SpringMessage(string text)
        {
            string txtOrig = text;
            var type = SpringMessageType.pwaward;
            bool found = false;

            foreach (var option in (SpringMessageType[]) Enum.GetValues(typeof (SpringMessageType))) {
                string prefix = option + ":";
                if (text.StartsWith(prefix)) {
                    text = text.Substring(prefix.Length);
                    type = option;
                    found = true;
                    break;
                }
            }
            if (!found) {
                autoHost.SayBattle("Unexpected message: " + text);
                return;
            }

            var parts = text.Split(new[] {','});
            try {
                switch (type) {
                    case SpringMessageType.pwaward:
                        var partsSpace = text.Split(new[] {' '}, 3);
                        string name = partsSpace[0];
                        string awardType = partsSpace[1];
                        string awardText = partsSpace[2];
                        autoHost.SayBattle(string.Format("Award for {0} - {1}", name, awardText));
                        server.AddAward(account, name, awardType, awardText, tas.GetBattle().Map.Name);
                        break;


                    case SpringMessageType.pwmorph:
                        server.UnitDeployed(account, tas.GetBattle().Map.Name, parts[0], parts[1], (int) double.Parse(parts[2]), (int) double.Parse(parts[3]), parts[4]);
                        break;

                    case SpringMessageType.pwpurchase:
                        server.UnitPurchased(account, parts[0], parts[1], double.Parse(parts[2]), (int) double.Parse(parts[3]), (int) double.Parse(parts[4]));
                        break;

                    case SpringMessageType.pwdeath:
                        server.UnitDied(account, parts[0], parts[1], (int) double.Parse(parts[3]), (int) double.Parse(parts[4]));
                        break;
                }
            } catch (Exception ex) {
                autoHost.SayBattle(string.Format("Error while processing '{0}' :{1}", txtOrig, ex));
            }
        }

        public bool StartGame(TasSayEventArgs e)
        {
            try {
                if (!autoHost.ComFix(e, "silent")) {
                    autoHost.Respond(e, "Teams were not fixed, fixing");
                    return false;
                }

                string currentMapName = tas.GetBattle().Map.Name;
                var planet = server.GetAttackOptions(account).Where(p => p.MapName == currentMapName).SingleOrDefault();

                if (planet == null) {
                    autoHost.SayBattle("This planet is not currently allowed, select another one");
                    return false;
                }

                var factions = server.GetFactions(account);
                var actual = new List<IPlayer>();
                foreach (var user in tas.GetBattle().Users) {
                    if (!user.IsSpectator) {
                        var info = server.GetPlayerInfo(account, user.name);
                        actual.Add(info);
                        string side = tas.GetBattle().Mod.Sides[user.Side];
                        string hisSide = factions.Where(f => f.Name == info.FactionName).Single().SpringSide;

                        if (!string.Equals(side, hisSide, StringComparison.InvariantCultureIgnoreCase)) {
                            autoHost.SayBattle(string.Format("{0} must switch to {1}", user.name, hisSide), false);
                            return false;
                        }
                    }
                }


                string options = server.GetStartupModOptions(account, tas.GetBattle().Map.Name, actual);
                //SayBattle(Encoding.ASCII.GetString(Convert.FromBase64String(options.Replace("+", "="))));
                var b = tas.GetBattle();
                foreach (var o in b.Mod.Options) {
                    if (o.Key == "planetwars") {
                        string res;
                        if (o.GetPair(options, out res)) {
                            tas.SetScriptTag(res);

                            var startEvent = server.GetPlayersToNotify(account, currentMapName, ReminderEvent.OnBattleStarted);
                            foreach (var s in startEvent) tas.Say(TasClient.SayPlace.User, s, string.Format("PlanetWars battle for planet {0} owned by {1} is starting.", planet.Name, planet.OwnerName), false);

                            return true;
                        } else {
                            autoHost.Respond(e, "Eror setting script tag");
                            return false;
                        }
                    }
                }
                autoHost.Respond(e, "This mod does not support PlanetWars");
                return false;
            } catch (Exception ex) {
                autoHost.SayBattle(string.Format("Error when checking PlanetWars teams: {0}", ex), false);
                return false;
            }
        }

        public void UserJoined(string name)
        {
            try {
                var current = server.GetOffensiveFaction(account);

                var info = server.GetPlayerInfo(account, name);
                if (info != null) autoHost.SayBattle(string.Format("{0} {1} {2}. Attacking faction is {3}. http://{5}/player.aspx?name={4}", info.IsCommanderInChief ? "All hail to" : "Greetings, ", info.RankText, name, current.Name, Uri.EscapeDataString(info.Name), host), false);
            } catch (Exception ex) {
                autoHost.SayBattle("PlanetWars error: " + ex);
            }
        }

        public void UserJoinedChannel(string channel, string name)
        {
            if (planetWarsChannels.Contains(channel) && name != tas.UserName) {
                bool? isOk = null;
                string side;
                if (planetWarsPlayerSide.TryGetValue(name, out side)) {
                    // first check cached value
                    isOk = side == channel;
                }
                if (!isOk.HasValue) {
                    IPlayer usinfo = null;
                    try {
                        usinfo = server.GetPlayerInfo(account, name);
                    } catch (Exception ex) {
                        autoHost.SayBattle("Error fetching user info:" + ex);
                    }
                    if (usinfo == null) {
                        if (channelAllowedExceptions.Contains(name)) isOk = true;
                        else {
                            channelAllowedExceptions = new List<string>(server.GetFactionChannelAllowedExceptions());
                            isOk = channelAllowedExceptions.Contains(name);
                        }
                    } else {
                        string realFact = usinfo.FactionName.ToLower();
                        planetWarsPlayerSide[name] = realFact;
                        isOk = realFact == channel;
                    }
                }

                // he is not from this faction, mute him
                if (!isOk.Value) tas.Say(TasClient.SayPlace.User, "ChanServ", string.Format("!kick #{0} {1} This is PlanetWars faction channel (http://{2}/) Register using !register command.", channel, name, host), false);
            }
        }

        public void UserSaid(TasSayEventArgs e)
        {
            if (e.Origin == TasSayEventArgs.Origins.Player && e.Place == TasSayEventArgs.Places.Channel && planetWarsChannels.Contains(e.Channel)) {
                //  lets log this
                try {
                    server.SendChatLine(account, e.Channel, e.UserName, e.Text);
                } catch (Exception ex) {
                    autoHost.SayBattle("Error sending chat:" + ex);
                }
            }
        }

        #endregion

        #region Event Handlers

        private void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            timer.Stop();
            try {
                var b = tas.GetBattle();
                if (!autoHost.ComFix(TasSayEventArgs.Default, "silent")) return;

                var factions = new List<IFaction>(server.GetFactions(account));
            	var sides = tas.GetBattle().Mod.Sides.ToList();
				bool teamsOk = true;
                foreach (var user in b.Users.Where(x => !x.IsSpectator && x.SyncStatus != SyncStatuses.Unknown)) {
                    var info = server.GetPlayerInfo(account, user.name);
                    if (info == null) {
                        tas.ForceSpectator(user.name);
                        tas.Say(TasClient.SayPlace.User, user.name, string.Format("This is online campaign server - http://{0}/ - you must register first /to play here. \n To register say: !register side newpassword (optional planetnname) \n Example: !register core secretpw \n Or: !register arm mynewpassword Alpha Centauri",host), false);
                    } else {
                        int hisFaction = factions.IndexOf(factions.Find((f) => f.Name == info.FactionName));
                    	string springSideName = sides.SingleOrDefault(s => s.ToUpper() == info.FactionName.ToUpper());
                    	int springSideIndex = sides.IndexOf(springSideName);

                        // he is in wrong team
                        if (user.AllyNumber != hisFaction) {
                        	tas.ForceAlly(user.name, hisFaction);
							teamsOk = false;
                        } else if (user.Side != springSideIndex) {
							tas.ForceSide(user.name, springSideIndex);
						}
                    }
                }
				if (!teamsOk) return; // dont proceed to balancing if teams are bing changed


                var grouping = b.Users.Where(u => !u.IsSpectator && u.SyncStatus != SyncStatuses.Unknown).GroupBy(u => u.AllyNumber).OrderBy(g => g.Count()).ToList();
                if (grouping.Count() == 2) {
                    if (grouping[1].Count() > 2*grouping[0].Count()) {
                        var newest = b.Users.Where(u => u.AllyNumber == grouping[1].Key && !u.IsSpectator).OrderByDescending(u => u.JoinTime).First();
                        tas.ForceSpectator(newest.name);
                        autoHost.SayBattle(string.Format("There are too many players on that side {0}, sorry you joined last.", newest.name));
                    }
                }
            } catch (Exception ex) {
                autoHost.SayBattle("Problem with PlanetWars:" + ex);
            } finally {
                timer.Start();
            }
        }

        #endregion
    }
}