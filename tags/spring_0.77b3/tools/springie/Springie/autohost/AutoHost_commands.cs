#region using

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Threading;
using PlanetWarsShared;
using PlanetWarsShared.Springie;
using Springie.Client;
using Springie.SpringNamespace;

#endregion

namespace Springie.autohost
{
	public partial class AutoHost
	{
		#region Fields

		private List<string> toNotify = new List<string>();

		#endregion

		#region Public methods

		public bool AllReadyAndSynced(out List<string> usname)
		{
			usname = new List<string>();
			foreach (var p in tas.GetBattle().Users) {
				if (p.IsSpectator) continue;
				if (p.SyncStatus != SyncStatuses.Synced || !p.IsReady) usname.Add(p.name);
			}
			return usname.Count == 0;
		}

		public bool AllUniqueTeams(out List<string> username)
		{
			var teams = new List<int>();
			username = new List<string>();
			foreach (var p in tas.GetBattle().Users) {
				if (p.IsSpectator) continue;
				if (teams.Contains(p.TeamNumber)) username.Add(p.name);
				else teams.Add(p.TeamNumber);
			}
			return username.Count == 0;
		}


		public bool BalancedTeams(out int allyno)
		{
			var counts = new int[16];
			allyno = 0;


			foreach (var p in tas.GetBattle().Users) {
				if (p.IsSpectator) continue;
				counts[p.AllyNumber]++;
			}

			int tsize = 0;
			for (int i = 0; i < counts.Length; ++i) {
				if (counts[i] != 0) {
					if (tsize == 0) tsize = counts[i];
					else if (tsize != counts[i]) {
						allyno = i;
						return false;
					}
				}
			}
			if (ladder != null) {
				int mint, maxt;
				ladder.CheckBattleDetails(null, out mint, out maxt);
				if (tsize < mint || tsize > maxt) {
					SayBattle("Ladder only allows team sizes " + mint + " - " + maxt);
					return false;
				}
			}
			return true;
		}

		public void BalanceTeams(int teamCount, bool clanwise)
		{
			var actUsers = new List<UserBattleStatus>();
			var ranker = new List<UsRank>();
			var b = tas.GetBattle();

			foreach (var u in b.Users) {
				if (!u.IsSpectator) {
					actUsers.Add(u);
					User p;
					if (tas.GetExistingUser(u.name, out p)) ranker.Add(new UsRank(ranker.Count, p.rank, GetClan(u.name)));
					else ranker.Add(new UsRank(ranker.Count, 0, GetClan(u.name))); // cannot find user, assume rank 0
				}
			}

			var rand = new Random();

			var tempList = new List<UsRank>(ranker);
			ranker.Clear();
			while (tempList.Count > 0) {
				// find max rank value
				int maxval = int.MinValue;
				foreach (var u in tempList) if (u.rank > maxval) maxval = u.rank;

				var l2 = new List<UsRank>(); // pick pieces with max rank to l2
				int j = 0;
				while (j < tempList.Count) {
					if (tempList[j].rank == maxval) {
						l2.Add(tempList[j]);
						tempList.RemoveAt(j);
						j = 0;
					}
					j++;
				}

				while (l2.Count > 0) {
					// randomly add pieces from l2 to ranker
					int ind = rand.Next(l2.Count);
					ranker.Add(l2[ind]);
					l2.RemoveAt(ind);
				}
			}

			if (teamCount < 2 || teamCount > ranker.Count) teamCount = 2;

			var teamUsers = new List<UsRank>[teamCount];
			for (int i = 0; i < teamUsers.Length; ++i) teamUsers[i] = new List<UsRank>();
			var teamSums = new int[teamCount];

			var teamClans = new List<string>[teamCount];
			for (int i = 0; i < teamClans.Length; ++i) teamClans[i] = new List<string>();

			if (clanwise) {
				string clans = "";
				// remove clans that have less than 2 members - those are irelevant
				foreach (var u in ranker) {
					if (u.clan != "") {
						if (ranker.FindAll(delegate(UsRank x) { return x.clan == u.clan; }).Count < 2) u.clan = "";
						else clans += u.clan + ", ";
					}
				}
				if (clans != "") SayBattle("those clan are being balanced: " + clans);
			}

			// this cycle performs actual user adding to teams
			int cnt = 0;
			while (ranker.Count > 0) {
				int minsum = int.MaxValue;
				int minid = 0;
				for (int i = 0; i < teamCount; ++i) {
					var l = teamUsers[i];
					// pick only current "row" and find the one with least sum
					if (l.Count == cnt/teamCount) {
						if (teamSums[i] < minsum) {
							minid = i;
							minsum = teamSums[i];
						}
					}
				}

				int picked_user = 0;
				if (clanwise) {
					// clanwise balancing - attempt to pick someone with same clan
					// selected team already has some clan
					int rank = ranker[0].rank;
					var temp = new List<int>();

					// get list of clans assigned to other teams
					var assignedClans = new List<string>();
					for (int i = 0; i < teamClans.Length; ++i) if (i != minid) foreach (var clanName in teamClans[i]) assignedClans.Add(clanName);

					// first try to get some with same clan
					if (teamClans[minid].Count > 0) {
						for (int i = 0; i < ranker.Count; ++i) {
							if (temp.Count > 0 && ranker[i].rank != rank) break;
							if (ranker[i].clan != "" && teamClans[minid].Contains(ranker[i].clan)) temp.Add(i);
						}
					}

					if (temp.Count == 0) {
						// we dont have any candidates try to get clanner from unassigned clan
						for (int i = 0; i < ranker.Count; ++i) {
							if (temp.Count > 0 && ranker[i].rank != rank) break;
							if (ranker[i].clan != "" && !assignedClans.Contains(ranker[i].clan)) temp.Add(i);
						}
					}

					if (temp.Count == 0) {
						// we still dont have any candidates try to get non-clanner
						for (int i = 0; i < ranker.Count; ++i) {
							if (temp.Count > 0 && ranker[i].rank != rank) break;
							if (ranker[i].clan == "") temp.Add(i);
						}
					}

					// if we have some candidates pick one randomly
					if (temp.Count > 0) picked_user = temp[rand.Next(temp.Count)];
					;
				}

				var usr = ranker[picked_user];
				teamUsers[minid].Add(usr);
				teamSums[minid] += usr.rank;

				if (clanwise && usr.clan != "") {
					// if we work with clans add user's clan to clan list for his team
					if (!teamClans[minid].Contains(usr.clan)) teamClans[minid].Add(usr.clan);
				}

				ranker.RemoveAt(picked_user);

				cnt++;
			}

			// alliances for allinace permutations
			var allys = new List<int>();
			for (int i = 0; i < teamCount; ++i) allys.Add(i);

			for (int i = 0; i < teamCount; ++i) {
				// permute one alliance
				int rdindex = rand.Next(allys.Count);
				int allynum = allys[rdindex];
				allys.RemoveAt(rdindex);

				foreach (var u in teamUsers[i]) tas.ForceAlly(actUsers[u.id].name, allynum);
			}

			string t = string.Format("{0} players balanced to {1} teams (ranks ", actUsers.Count, teamCount);
			for (int i = 0; i < teamSums.Length; ++i) {
				if (i > 0) t += ":";
				t += teamSums[i].ToString();
			}
			t += ")";
			if (clanwise) t += " respecting clans";
			SayBattle(t);
		}


		public void ComAddBox(TasSayEventArgs e, string[] words)
		{
			if (words.Length < 4) {
				Respond(e, "This command needs at least 4 parameters");
				return;
			}
			int x, y, w, h;
			if (!int.TryParse(words[0], out x) || !int.TryParse(words[1], out y) || !int.TryParse(words[2], out w) || !int.TryParse(words[3], out h)) {
				Respond(e, "All parameters must be numbers");
				return;
			}
			int numrect = 0;
			if (words.Length > 4) int.TryParse(words[4], out numrect);

			if (numrect == 0) {
				numrect = tas.GetBattle().GetFirstEmptyRectangle();
				if (numrect == -1) {
					Respond(e, "Cannot add more boxes");
					return;
				}
				numrect++;
			}
			tas.AddBattleRectangle(numrect - 1, new BattleRect(x*2, y*2, (x + w)*2, (y + h)*2));
		}

		public void ComAlly(TasSayEventArgs e, string[] words)
		{
			if (words.Length < 2) {
				Respond(e, "this command needs 2 parameters (ally number and player name)");
				return;
			}
			int allyno = 0;
			if (!int.TryParse(words[0], out allyno) || --allyno < 0 || allyno >= Spring.MaxAllies) {
				Respond(e, "invalid ally number");
				return;
			}
			string[] usrs;
			int[] idx;
			if (FilterUsers(Utils.ShiftArray(words, -1), out usrs, out idx) == 0) Respond(e, "no such player found");
			else {
				SayBattle("Forcing " + usrs[0] + " to alliance " + (allyno + 1));
				tas.ForceAlly(usrs[0], allyno);
			}
		}

		public void ComAutoLock(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				autoLock = 0;
				Respond(e, "AutoLocking disabled");
				return;
			}
			int num = 0;
			int.TryParse(words[0], out num);
			int maxp = tas.GetBattle().MaxPlayers;
			if (num < config.AutoLockMinPlayers || num > maxp) {
				autoLock = 0;
				Respond(e, "number of players must be between " + config.AutoLockMinPlayers + " and " + maxp + ", AutoLocking disabled");
				return;
			}
			autoLock = num;
			HandleAutoLocking();
			Respond(e, "AutoLock set to " + autoLock + " players");
		}

		public void ComBalance(TasSayEventArgs e, string[] words)
		{
			int teamCount = 2;
			if (words.Length > 0) int.TryParse(words[0], out teamCount);
			else teamCount = 2;
			ComFix(e, words);
			BalanceTeams(teamCount, false);
		}

		public void ComBoss(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				if (bossName == "") {
					Respond(e, "there is currently no active boss");
					return;
				}
				SayBattle("boss " + bossName + " removed");
				bossName = "";
				return;
			} else {
				string[] usrs;
				int[] idx;
				if (FilterUsers(words, out usrs, out idx) == 0) Respond(e, "no such player found");
				else {
					SayBattle("New boss is " + usrs[0]);
					bossName = usrs[0];
				}
			}
		}

		public void ComCBalance(TasSayEventArgs e, string[] words)
		{
			int teamCount = 2;
			if (words.Length > 0) int.TryParse(words[0], out teamCount);
			else teamCount = 2;
			ComFix(e, words);
			BalanceTeams(teamCount, true);
		}

		public void ComClearBox(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) foreach (var i in tas.GetBattle().Rectangles.Keys) tas.RemoveBattleRectangle(i);
			else {
				int numrect = 0;
				if (!int.TryParse(words[0], out numrect)) Respond(e, "paramater must by a number of rectangle");
				tas.RemoveBattleRectangle(numrect - 1);
			}
		}

		public void ComCorners(TasSayEventArgs e, string[] words)
		{
			if (words.Length != 2) {
				Respond(e, "This command needs 2 parameters");
				return;
			}
			if (words[0] != "a" && words[0] != "b") Respond(e, "first parameter must be 'a' or 'b'");
			else {
				int perc;
				int.TryParse(words[1], out perc);
				if (perc < 0 || perc > 50) Respond(e, "second parameter must be between 0 and 50");
				else {
					double p = perc/100.0;
					if (words[0] == "a") {
						tas.AddBattleRectangle(0, new BattleRect(0, 0, p, p));
						tas.AddBattleRectangle(1, new BattleRect(1 - p, 1 - p, 1, 1));
						tas.AddBattleRectangle(2, new BattleRect(1 - p, 0, 1, p));
						tas.AddBattleRectangle(3, new BattleRect(0, 1 - p, p, 1));
					} else {
						tas.AddBattleRectangle(0, new BattleRect(1 - p, 0, 1, p));
						tas.AddBattleRectangle(1, new BattleRect(0, 1 - p, p, 1));
						tas.AddBattleRectangle(2, new BattleRect(0, 0, p, p));
						tas.AddBattleRectangle(3, new BattleRect(1 - p, 1 - p, 1, 1));
					}
				}
			}
		}

		public void ComDlMap(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "This command needs 1 parameter (map name)");
				return;
			}
			string str = Utils.Glue(words);
			string dump;
			int dumpi;
			string res = str;

			if (!int.TryParse(str, out dumpi) && !FileDownloader.IsFileUrl(str, out dump)) {
				res = "";
				try {
					dump = linker.GetResults(str, UnknownFilesLinker.FileType.Map);
					res = Regex.Match(dump, "file/([0-9]*)").Groups[1].Value;
				} catch {}
			}

			if (res != "") {
				Respond(e, "Starting map download");
				fileDownloader.DownloadMap(res);
			} else Respond(e, "I cannot find such map");
		}


		public void ComDlMod(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "This command needs 1 parameter (mod name or id)");
				return;
			}
			string str = Utils.Glue(words);
			string dump;
			int dumpi;
			string res = str;

			if (!int.TryParse(str, out dumpi) && !FileDownloader.IsFileUrl(str, out dump)) {
				res = "";
				try {
					dump = linker.GetResults(str, UnknownFilesLinker.FileType.Mod);
					res = Regex.Match(dump, "file/([0-9]*)").Groups[1].Value;
				} catch {}
			}

			if (res != "") {
				Respond(e, "Starting mod download");
				fileDownloader.DownloadMod(res);
			} else Respond(e, "I cannot find such mod");
		}


		public void ComExit(TasSayEventArgs e, string[] words)
		{
			if (spring.IsRunning) SayBattle("exiting game");
			else Respond(e, "cannot exit, not in game");
			spring.ExitGame();
		}


		public void ComFix(TasSayEventArgs e, string[] words)
		{
			var b = tas.GetBattle();
			int cnt = 0;
			foreach (var u in b.Users) {
				if (!u.IsSpectator) {
					tas.ForceTeam(u.name, cnt);
					cnt++;
				}
			}
			SayBattle("team numbers fixed");
		}


		public void ComFixColors(TasSayEventArgs e, string[] words)
		{
			var cols = new List<MyCol>();
			var b = tas.GetBattle();

			foreach (var u in b.Users) if (!u.IsSpectator) cols.Add((MyCol) u.TeamColor);
			var arcols = cols.ToArray();

			MyCol.FixColors(arcols, 30000);

			bool changed = false;
			int cnt = 0;
			foreach (var u in b.Users) {
				if (!u.IsSpectator) {
					if (u.TeamColor != (int) arcols[cnt]) {
						tas.ForceColor(u.name, (int) arcols[cnt]);
						changed = true;
					}
					cnt++;
				}
			}
			if (changed) SayBattle("colors fixed");
		}

		public void ComForce(TasSayEventArgs e, string[] words)
		{
			if (spring.IsRunning) {
				SayBattle("forcing game start by " + e.UserName);
				spring.ForceStart();
			} else Respond(e, "cannot force, game not started");
		}

		public void ComForceSpectator(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "You must specify player name");
				return;
			}

			int[] indexes;
			string[] usrlist;
			if (FilterUsers(words, out usrlist, out indexes) == 0) {
				Respond(e, "Cannot find such player");
				return;
			}

			tas.ForceSpectator(usrlist[0]);
			Respond(e, "Forcing " + usrlist[0] + " to spectator");
		}

		public void ComForceSpectatorAfk(TasSayEventArgs e, string[] words)
		{
			var b = tas.GetBattle();
			if (b != null) {
				foreach (var u in b.Users) {
					User u2;
					if (u.name != tas.UserName && !u.IsSpectator && !u.IsReady && tas.GetExistingUser(u.name, out u2)) if (u2.isAway) ComForceSpectator(e, new[] {u.name});
				}
			}
		}

		public void ComForceStart(TasSayEventArgs e, string[] words)
		{
			/*string usname;
      if (!AllReadyAndSynced(out usname)) {
        SayBattle("cannot start, " + usname + " not ready and synced");
        return;
      }*/
			if (CheckAndSendPlanetWarsStart(e)) {
				SayBattle("please wait, game is about to start");

				StopVote();
				tas.ChangeLock(true);
				tas.StartGame();
			}
		}

		public void ComKick(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "You must specify player name");
				return;
			}

			int[] indexes;
			string[] usrlist;
			if (FilterUsers(words, out usrlist, out indexes) == 0) {
				Respond(e, "Cannot find such player");
				return;
			}

			if (usrlist[0] == tas.UserName) {
				Respond(e, "won't kick myself, not in suicidal mood today");
				return;
			}

			if (spring.IsRunning) spring.Kick(usrlist[0]);
			tas.Kick(usrlist[0]);
		}

		public void ComKickMinRank(TasSayEventArgs e, string[] words)
		{
			if (words.Length > 0 && (words[0] == "1" || words[0] == "0")) kickMinRank = (words[0] == "1");
			else kickMinRank = !kickMinRank;

			if (kickMinRank) SayBattle("automatic minrank kicking is now ENABLED");
			else SayBattle("automatic minrank kicking is now DISABLED");

			HandleMinRankKicking();
		}

		public void ComKickSpec(TasSayEventArgs e, string[] words)
		{
			if (words.Length > 0 && (words[0] == "1" || words[0] == "0")) kickSpectators = (words[0] == "1");
			else kickSpectators = !kickSpectators;

			if (kickSpectators) SayBattle("automatic spectator kicking is now ENABLED");
			else SayBattle("automatic spectator kicking is now DISABLED");

			if (kickSpectators) {
				SayBattle(config.KickSpectatorText);
				var b = tas.GetBattle();
				if (b != null) foreach (var u in b.Users) if (u.name != tas.UserName && u.IsSpectator) ComKick(e, new[] {u.name});
			}
		}

		public void ComManage(TasSayEventArgs e, string[] words)
		{
			if (words.Length < 1) {
				Respond(e, "this command needs 1 parameters (minimum number of players to manage for)");
				return;
			}
			int min = 0;
			int.TryParse(words[0], out min);
			int max = min;
			if (words.Length > 1) int.TryParse(words[1], out max);
			if (min == 0) Respond(e, "managing disabled");
			else Respond(e, "auto managing for " + min + " to " + max + " players");
			manager.Manage(min, max);
		}

		public void ComPreset(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;
			if (FilterPresets(words, out vals, out indexes) > 0) {
				var p = presets[indexes[0]];
				Respond(e, "applying preset " + p.Name + " (" + p.Description + ")");
				p.Apply(tas, ladder);
			} else Respond(e, "no such preset found");
		}

		public void ComPresetDetails(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;
			if (FilterPresets(words, out vals, out indexes) > 0) {
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
				foreach (var line in presets[indexes[0]].ToString().Split(new[] {'\n'}, StringSplitOptions.RemoveEmptyEntries)) tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			} else Respond(e, "no such preset found");
		}


		public void ComRandom(TasSayEventArgs e, string[] words)
		{
			ComFix(e, words);
			var b = tas.GetBattle();

			var actUsers = new List<UserBattleStatus>();
			foreach (var u in b.Users) if (!u.IsSpectator) actUsers.Add(u);

			int teamCount = 0;
			if (words.Length > 0) int.TryParse(words[0], out teamCount);
			else teamCount = 2;
			if (teamCount < 2) teamCount = 2;
			if (teamCount > actUsers.Count) teamCount = 2;
			var r = new Random();

			int al = 0;
			while (actUsers.Count > 0) {
				int index = r.Next(actUsers.Count);
				tas.ForceAlly(actUsers[index].name, al);
				actUsers.RemoveAt(index);
				al++;
				al = al%teamCount;
			}
			SayBattle("players assigned to " + teamCount + " random teams");
		}

		public void ComRehost(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) Start(null, null);
			else {
				string[] mods;
				int[] indexes;
				if (FilterMods(words, out mods, out indexes) == 0) Respond(e, "cannot find such mod");
				else Start(mods[0], null);
			}
		}

		public void ComRing(TasSayEventArgs e, string[] words)
		{
			var usrlist = new List<string>();

			if (words.Length == 0) {
				// ringing idle
				foreach (var p in tas.GetBattle().Users) {
					if (p.IsSpectator) continue;
					if (!p.IsReady) usrlist.Add(p.name);
				}
			} else {
				string[] vals;
				int[] indexes;
				FilterUsers(words, out vals, out indexes);
				usrlist = new List<string>(vals);
			}

			string rang = "";
			foreach (var s in usrlist) {
				tas.Ring(s);
				rang += s + ", ";
			}

			if (words.Length == 0 && usrlist.Count > 7) SayBattle("ringing all unready");
			else SayBattle("ringing " + rang);
		}


		// user and rank info


		public void ComSay(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "This command needs 1 parameter (say text)");
				return;
			}
			SayBattle("[" + e.UserName + "]" + Utils.Glue(words));
		}

		public void ComSetLevel(TasSayEventArgs e, string[] words)
		{
			if (words.Length != 2) {
				Respond(e, "This command needs 2 parameters");
				return;
			}
			int lvl;
			int.TryParse(words[0], out lvl);
			config.SetPrivilegedUser(words[1], lvl);
			SaveConfig();
			Respond(e, words[1] + " has rights level " + lvl);
		}

		public void ComSplit(TasSayEventArgs e, string[] words)
		{
			if (words.Length != 2) {
				Respond(e, "This command needs 2 parameters");
				return;
			}
			if (words[0] != "h" && words[0] != "v") Respond(e, "first parameter must be 'h' or 'v'");
			else {
				int perc;
				int.TryParse(words[1], out perc);
				if (perc < 0 || perc > 50) Respond(e, "second parameter must be between 0 and 50");
				else {
					if (words[0] == "h") {
						tas.AddBattleRectangle(0, new BattleRect(0, 0, 1.0, perc/100.0));
						tas.AddBattleRectangle(1, new BattleRect(0, 1.0 - perc/100.0, 1.0, 1.0));
					} else {
						tas.AddBattleRectangle(0, new BattleRect(0, 0, perc/100.0, 1.0));
						tas.AddBattleRectangle(1, new BattleRect(1.0 - perc/100.0, 0, 1.0, 1.0));
					}
					tas.RemoveBattleRectangle(2);
					tas.RemoveBattleRectangle(3);
				}
			}
		}


		public void ComSpringie(TasSayEventArgs e, string[] words)
		{
			var b = tas.GetBattle();

			var running = DateTime.Now.Subtract(Program.startupTime);
			running = new TimeSpan((int) running.TotalHours, running.Minutes, running.Seconds);

			var started = DateTime.Now.Subtract(spring.GameStarted);
			started = new TimeSpan((int) started.TotalHours, started.Minutes, started.Seconds);

			Respond(e, tas.UserName + " (" + MainConfig.SpringieVersion + ") running for " + running);
			Respond(e, "players: " + (b.Users.Count - b.CountSpectators()) + "/" + b.MaxPlayers);
			Respond(e, "mod: " + b.Mod.Name);
			Respond(e, "map: " + b.Map.Name);
			Respond(e, "game " + (spring.IsRunning ? "running since " : "not running, last started ") + (spring.GameStarted != DateTime.MinValue ? started + " ago" : "never"));
		}

		public void ComStart(TasSayEventArgs e, string[] words)
		{
			List<string> usname;
			if (!AllReadyAndSynced(out usname)) {
				SayBattle("cannot start, " + Utils.Glue(usname.ToArray()) + " not ready and synced");
				return;
			}

			if (!AllUniqueTeams(out usname)) {
				SayBattle("cannot start, " + Utils.Glue(usname.ToArray()) + " is sharing teams. Use !forcestart to override");
				return;
			}

			int allyno;
			if (!BalancedTeams(out allyno)) {
				SayBattle("cannot start, alliance " + (allyno + 1) + " not fair. Use !forcestart to override");
				return;
			}

			if (CheckAndSendPlanetWarsStart(e)) {
				SayBattle("please wait, game is about to start");

				StopVote();

				var b = tas.GetBattle();
				if (b != null) {
					string curMap = b.Map.ArchiveName.ToLower();

					var nd = new Dictionary<int, BattleRect>();
					foreach (var v in b.Rectangles) nd.Add(v.Key, v.Value);

					if (MapBoxes.ContainsKey(curMap)) MapBoxes[curMap] = nd;
					else MapBoxes.Add(curMap, nd);
					SaveConfig();
				}
				tas.ChangeLock(true);
				tas.StartGame();
			}
		}

		public void ComTeam(TasSayEventArgs e, string[] words)
		{
			if (words.Length < 2) {
				Respond(e, "this command needs 2 parameters (team number and player name)");
				return;
			}
			int teamno = 0;
			if (!int.TryParse(words[0], out teamno) || --teamno < 0 || teamno >= Spring.MaxTeams) {
				Respond(e, "invalid team number");
				return;
			}
			string[] usrs;
			int[] idx;
			if (FilterUsers(Utils.ShiftArray(words, -1), out usrs, out idx) == 0) Respond(e, "no such player found");
			else {
				SayBattle("Forcing " + usrs[0] + " to team " + (teamno + 1));
				tas.ForceTeam(usrs[0], teamno);
			}
		}

		internal static int Filter(string[] source, string[] words, out string[] resultVals, out int[] resultIndexes)
		{
			int i;

			// search by direct index
			if (words.Length == 1) {
				if (int.TryParse(words[0], out i)) {
					if (i >= 0 && i < source.Length) {
						resultVals = new[] {source[i]};
						resultIndexes = new[] {i};
						return 1;
					}
				}

				// search by direct word
				string glued = Utils.Glue(words);
				for (i = 0; i < source.Length; ++i) {
					if (source[i] == glued) {
						resultVals = new[] {source[i]};
						resultIndexes = new[] {i};
						return 1;
					}
				}
			}

			var res = new List<string>();
			var resi = new List<int>();

			for (i = 0; i < words.Length; ++i) words[i] = words[i].ToLower();
			for (i = 0; i < source.Length; ++i) {
				if (source[i] + "" == "") continue;
				string item = source[i];
				bool isok = true;
				for (int j = 0; j < words.Length; ++j) {
					if (!item.ToLower().Contains(words[j])) {
						isok = false;
						break;
					}
				}
				if (isok) {
					res.Add(item);
					resi.Add(i);
				}
			}

			resultVals = res.ToArray();
			resultIndexes = resi.ToArray();

			return res.Count;
		}

		public int FilterMaps(string[] words, out string[] vals, out int[] indexes)
		{
			return FilterMaps(words, tas, spring, ladder, out vals, out indexes);
		}

		internal static int FilterMods(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
		{
			var temp = new string[spring.UnitSync.ModList.Keys.Count];
			int cnt = 0;
			foreach (var s in spring.UnitSync.ModList.Keys) {
				var limit = Program.main.AutoHost.config.LimitMods;
				if (limit != null && limit.Length > 0) {
					bool allowed = false;
					for (int i = 0; i < limit.Length; ++i) {
						if (s.ToLower().Contains(limit[i].ToLower())) {
							allowed = true;
							break;
						}
					}
					if (allowed) temp[cnt++] = s;
				} else temp[cnt++] = s;
			}

			return Filter(temp, words, out vals, out indexes);
		}

		public int FilterPlanets(string[] words, out string[] vals, out int[] indexes)
		{
			var pw = Program.main.PlanetWars;
			var options = pw.GetAttackOptions();

			var temp = new string[options.Count];
			int cnt = 0;
			foreach (var planet in options) temp[cnt++] = planet.Name;
			return Filter(temp, words, out vals, out indexes);
		}


		internal static int FilterPresets(string[] words, AutoHost autohost, out string[] vals, out int[] indexes)
		{
			var temp = new string[autohost.presets.Count];
			int cnt = 0;
			foreach (var p in autohost.presets) temp[cnt++] = p.Name + " --> " + p.Description;
			return Filter(temp, words, out vals, out indexes);
		}

		internal static int FilterUsers(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
		{
			var b = tas.GetBattle();
			var temp = new string[b.Users.Count];
			int i = 0;
			foreach (var u in b.Users) temp[i++] = u.name;
			return Filter(temp, words, out vals, out indexes);
		}


		public string GetOptionsString(TasSayEventArgs e, string[] words)
		{
			string s = Utils.Glue(words);
			string result = "";
			var pairs = s.Split(new[] {','});
			if (pairs.Length == 0 || pairs[0].Length == 0) {
				Respond(e, "requires key=value format");
				return "";
			}
			foreach (var pair in pairs) {
				var parts = pair.Split(new[] {'='}, 2);
				if (parts.Length != 2) {
					Respond(e, "requires key=value format");
					return "";
				}
				var b = tas.GetBattle();
				string key = parts[0];
				string val = parts[1];

				bool found = false;
				foreach (var o in b.Mod.Options) {
					if (o.Key == key) {
						found = true;
						string res;
						if (o.GetPair(val, out res)) {
							if (result != "") result += "\t";
							result += res;
						} else Respond(e, "Value " + val + " is not valid for this option");

						break;
					}
				}
				if (!found) {
					Respond(e, "No option called " + key + " found");
					return "";
				}
			}
			return result;
		}

		#endregion

		#region Other methods

		private bool CheckAndSendPlanetWarsStart(TasSayEventArgs e)
		{
			if (Program.main.config.PlanetWarsEnabled) {
				try {
					bool ok = true;
					var pw = Program.main.PlanetWars;
					string currentMapName = tas.GetBattle().Map.Name;
					var fmap = pw.GetAttackOptions().Find(p => p.MapName == currentMapName);
					if (fmap == null) {
						SayBattle("This planet is not currently allowed, select another one");
						return false;
					}

					var factions = pw.GetFactions();

					var actual = new List<IPlayer>();
					foreach (var user in tas.GetBattle().Users) {
						if (!user.IsSpectator) {
							var info = pw.GetPlayerInfo(user.name);
							actual.Add(info);
							string side = tas.GetBattle().Mod.Sides[user.Side];
							string hisSide = factions.Find(f => f.Name == info.FactionName).SpringSide;

							if (!string.Equals(side, hisSide, StringComparison.InvariantCultureIgnoreCase)) {
								SayBattle(string.Format("{0} must switch to {1}", user.name, hisSide), false);
								ok = false;
							}
						}
					}
					if (ok) {
						string options = pw.GetStartupModOptions(tas.GetBattle().Map.Name, actual);
						var b = tas.GetBattle();
						foreach (var o in b.Mod.Options) {
							if (o.Key == "planetwars") {
								string res;
								if (o.GetPair(options, out res)) {
									tas.SetScriptTag(res);
									return ok;
								} else {
									Respond(e, "Eror setting script tag");
									return false;
								}
							}
						}
						Respond(e, "This mod does not support PlanetWars");
						return false;
					}

					return ok;
				} catch (Exception ex) {
					SayBattle(string.Format("Error when checking PlanetWars teams: {0}", ex.Message), false);
					return false;
				}
			} else return true;
		}

		private void ComAdmins(TasSayEventArgs e, string[] words)
		{
			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			foreach (var u in config.PrivilegedUsers) tas.Say(TasClient.SayPlace.User, e.UserName, " " + u.Name + " (level " + u.Level + ")", false);
			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
		}

		private void ComHelp(TasSayEventArgs e, string[] words)
		{
			int ulevel = GetUserLevel(e);
			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			foreach (var c in config.Commands) if (c.Level <= ulevel) tas.Say(TasClient.SayPlace.User, e.UserName, " !" + c.Name + " " + c.HelpText, false);
			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
		}


		private void ComHelpAll(TasSayEventArgs e, string[] words)
		{
			var copy = new List<CommandConfig>(config.Commands);
			copy.Sort(delegate(CommandConfig a, CommandConfig b)
			          	{
			          		if (a.Level != b.Level) return a.Level.CompareTo(b.Level);
			          		else return a.Name.CompareTo(b.Name);
			          	});

			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			foreach (var c in copy) tas.Say(TasClient.SayPlace.User, e.UserName, "Level " + c.Level + " --> !" + c.Name + " " + c.HelpText, false);
			tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
		}

		private void ComListMaps(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;
			if (FilterMaps(words, out vals, out indexes) > 0) {
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
				for (int i = 0; i < vals.Length; ++i) tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			} else Respond(e, "no such map found");
		}

		private void ComListMods(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;
			if (FilterMods(words, out vals, out indexes) > 0) {
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
				for (int i = 0; i < vals.Length; ++i) tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			} else Respond(e, "no such mod found");
		}

		private void ComListOptions(TasSayEventArgs e, string[] words)
		{
			var b = tas.GetBattle();
			if (b.Mod.Options.Count == 0) Respond(e, "this mod has no options");
			else foreach (var opt in b.Mod.Options) Respond(e, opt.ToString());
		}

		private void ComListPlanets(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;
			if (!Program.main.config.PlanetWarsEnabled) {
				Respond(e, "This is not PlanetWars host");
				return;
			}
			try {
				if (FilterPlanets(words, out vals, out indexes) > 0) {
					Respond(e, "Planets available for attack are:");
					for (int i = 0; i < vals.Length; ++i) Respond(e, string.Format("{0}: {1}", indexes[i], vals[i]));
				} else Respond(e, "no such planet found");
			} catch (Exception ex) {
				Respond(e, string.Format("Error getting planets: {0}", ex.Message));
			}
		}

		private void ComListPresets(TasSayEventArgs e, string[] words)
		{
			string[] vals;
			int[] indexes;

			if (FilterPresets(words, out vals, out indexes) > 0) {
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
				for (int i = 0; i < vals.Length; ++i) tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
				tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
			} else Respond(e, "no such preset found");
		}

		private void ComMap(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Respond(e, "You must specify a map name");
				return;
			}
			string[] vals;
			int[] indexes;
			if (FilterMaps(words, out vals, out indexes) > 0) {
				SayBattle("changing map to " + vals[0]);
				tas.ChangeMap(spring.UnitSync.MapList[vals[0]]);
			} else Respond(e, "Cannot find such map.");
		}


		private void ComNotify(TasSayEventArgs e, string[] words)
		{
			if (!toNotify.Contains(e.UserName)) toNotify.Add(e.UserName);
			Respond(e, "I will notify you when game ends");
		}

		private void ComPlanet(TasSayEventArgs e, string[] words)
		{
			if (!Program.main.config.PlanetWarsEnabled) {
				Respond(e, "This is not a PlanetWars host");
				return;
			}

			if (words.Length == 0) {
				Respond(e, "You must specify planet name");
				return;
			}
			string[] vals;
			int[] indexes;
			if (FilterPlanets(words, out vals, out indexes) > 0) {
				var pw = Program.main.PlanetWars;
				var info = pw.GetPlayerInfo(e.UserName);
				var fact = pw.GetOffensiveFaction();
				if (info != null && info.IsCommanderInChief) {
					if (info.FactionName == fact.Name) {
						SayBattle(string.Format("changing planet to {0} by {1}", vals[0], e.UserName));
						var planet = pw.GetAttackOptions().Find((m) => m.Name == vals[0]);
						tas.ChangeMap(spring.UnitSync.MapList[planet.MapName]);
					} else Respond(e, string.Format("It's currently {0} turn", fact.Name));
				} else Respond(e, "You are not a commander-in-chief");
			} else Respond(e, "Cannot find such planet.");
		}

		private void ComRegister(TasSayEventArgs e, string[] words)
		{
			if (!Program.main.config.PlanetWarsEnabled) {
				Respond(e, "This is not PlanetWars host");
				return;
			}
			if (words.Length < 2) {
				Respond(e, "This command needs 2-3 parameters - side and password and optional planet name (you can PM it to me)");
				return;
			}


			try {
				var pw = Program.main.PlanetWars;
				string response = pw.Register(new AuthInfo {Login = e.UserName, Password = words[1]}, words[0], words.Length > 2 ? Utils.Glue(words, 2) : null);
				Respond(e, string.Format(response));
			} catch (Exception ex) {
				Respond(e, string.Format("Error when registering: {0}", ex.Message));
			}
		}

		private void ComSetGameTitle(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) Respond(e, "this command needs one parameter - new game title");
			else {
				Program.main.AutoHost.config.GameTitle = Utils.Glue(words);
				SaveConfig();
				Respond(e, "game title changed");
			}
		}

		private void ComSetMaxPlayers(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) Respond(e, "this command needs one parameter - number of players");
			else {
				int plr;
				int.TryParse(words[0], out plr);
				if (plr < 1) plr = 1;
				if (plr > Spring.MaxTeams) plr = Spring.MaxTeams;
				Program.main.AutoHost.config.MaxPlayers = plr;
				SaveConfig();
				Respond(e, "server size changed");
			}
		}

		private void ComSetMinCpuSpeed(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) Respond(e, "this command needs one parameter - minimal CPU speed");
			else {
				Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
				double minCpu;
				double.TryParse(words[0], out minCpu);
				minCpuSpeed = minCpu;
				SayBattle("minimal CPU speed is now " + minCpuSpeed + "GHz");
				if (minCpuSpeed > 0) {
					var b = tas.GetBattle();
					if (b != null) {
						foreach (var ubs in b.Users) {
							User u;
							if (ubs.name != tas.UserName && tas.GetExistingUser(ubs.name, out u)) if (u.cpu > 0 && u.cpu < minCpuSpeed*1000) ComKick(e, new[] {u.name});
						}
					}
				}
			}
		}

		private void ComSetMinRank(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) Respond(e, "this command needs one parameter - rank number");
			else {
				int rank;
				int.TryParse(words[0], out rank);
				if (rank < TasClient.MinRank) rank = TasClient.MinRank;
				if (rank > TasClient.MaxRank) rank = TasClient.MaxRank;
				Program.main.AutoHost.config.MinRank = rank;
				SaveConfig();
				Respond(e, "server rank changed");
				HandleMinRankKicking();
			}
		}


		private void ComSetOption(TasSayEventArgs e, string[] words)
		{
			string ret = GetOptionsString(e, words);
			if (ret != "") {
				tas.SetScriptTag(ret);
				Respond(e, "Options set");
			}
		}

		private void ComSetPassword(TasSayEventArgs e, string[] words)
		{
			if (words.Length == 0) {
				Program.main.AutoHost.config.Password = "";
				Respond(e, "password remoded");
			} else {
				Program.main.AutoHost.config.Password = words[0];
				SaveConfig();
				Respond(e, "password changed");
			}
		}

		private static int FilterMaps(string[] words, TasClient tas, Spring spring, Ladder ladder, out string[] vals, out int[] indexes)
		{
			var temp = new string[spring.UnitSync.MapList.Keys.Count];
			int cnt = 0;
			foreach (var s in spring.UnitSync.MapList.Keys) {
				if (ladder != null) {
					if (ladder.Maps.Contains(s.ToLower())) temp[cnt++] = s;
				} else {
					var limit = Program.main.AutoHost.config.LimitMaps;
					if (limit != null && limit.Length > 0) {
						bool allowed = false;
						for (int i = 0; i < limit.Length; ++i) {
							if (s.ToLower().Contains(limit[i].ToLower())) {
								allowed = true;
								break;
							}
						}
						if (allowed) temp[cnt++] = s;
					} else temp[cnt++] = s;
				}
			}
			return Filter(temp, words, out vals, out indexes);
		}

		private int FilterMods(string[] words, out string[] vals, out int[] indexes)
		{
			return FilterMods(words, tas, spring, out vals, out indexes);
		}

		private int FilterPresets(string[] words, out string[] vals, out int[] indexes)
		{
			return FilterPresets(words, this, out vals, out indexes);
		}

		private int FilterUsers(string[] words, out string[] vals, out int[] indexes)
		{
			return FilterUsers(words, tas, spring, out vals, out indexes);
		}

		private static string GetClan(string name)
		{
			foreach (Match m in Regex.Matches(name, "\\[([^\\]]+)\\]")) return m.Groups[1].Value;
			return "";
		}

		private void RemoteCommand(string scriptName, TasSayEventArgs e, string[] words)
		{
			if (Program.main.Stats == null) {
				Respond(e, "Stats system is disabled on this autohost.");
				return;
			}
			var b = tas.GetBattle();
			if (b != null) {
				string query = string.Format("user={0}&map={1}&mod={2}&p={3}", e.UserName, b.Map.Name, b.Mod.Name, Utils.Glue(words));
				foreach (var u in b.Users) if (u.name != tas.UserName) query += string.Format("&users[]={0}|{1}|{2}", u.name, (u.IsSpectator ? "1" : "0"), u.AllyNumber);
				var response = Program.main.Stats.SendCommand(scriptName, query, false, true).Split(new[] {'\r', '\n'}, StringSplitOptions.RemoveEmptyEntries);

				if (response.Length == 0) {
					Respond(e, "error accessing stats server");
					return;
				}

				if (response[0].StartsWith("RESPOND")) for (int i = 1; i < response.Length; ++i) Respond(e, response[i]);
				else foreach (var line in response) tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
			}
		}

		private void SayLines(TasSayEventArgs e, string what)
		{
			foreach (var line in what.Split(new[] {'\n', '\r'}, StringSplitOptions.RemoveEmptyEntries)) tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
		}

		#endregion

		#region Nested type: UsRank

		private class UsRank
		{
			#region Properties

			public string clan;
			public int id;
			public int rank;

			#endregion

			#region Constructors

			public UsRank(int id, int rank, string clan)
			{
				this.id = id;
				this.rank = rank;
				this.clan = clan;
			}

			#endregion
		}

		#endregion
	}
}