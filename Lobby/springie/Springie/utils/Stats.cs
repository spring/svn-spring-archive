#region using

using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using System.Xml.Serialization;
using PlanetWarsShared;
using PlanetWarsShared.Springie;
using Springie.Client;
using Springie.SpringNamespace;

#endregion

namespace Springie
{
	public class Stats
	{
		#region Constants

		public const string accountsFileName = "do_not_delete_me.xml";
		public const string gatherScript = "statsGather.php";
		public const string smurfScript = "smurfs.php";
		public const string statsScript = "stats.php";

		#endregion

		#region Fields

		private List<Account> accounts = new List<Account>();
		private Battle battle;
		private string password = "";
		private Dictionary<string, EndGamePlayerInfo> players = new Dictionary<string, EndGamePlayerInfo>();
		private Spring spring;
		private DateTime startTime;

		protected string StatsUrl
		{
			get { return Program.main.config.StatsUrlAddressReal; }
		}

		private TasClient tas;

		protected string UserName
		{
			get
			{
				if (tas != null && !string.IsNullOrEmpty(tas.UserName)) return tas.UserName;
				else return Program.main.config.AccountName;
			}
		}

		#endregion

		#region Constructors

		public Stats(TasClient tas, Spring spring)
		{
			this.tas = tas;
			this.spring = spring;

			LoadAccounts();

			tas.LoginAccepted += tas_LoginAccepted;
			if (Program.main.config.GargamelMode) {
				tas.UserRemoved += tas_UserRemoved;
				tas.BattleUserIpRecieved += tas_BattleUserIpRecieved;
				tas.UserStatusChanged += tas_UserStatusChanged;
			}
			spring.SpringStarted += spring_SpringStarted;
			spring.PlayerJoined += spring_PlayerJoined;
			spring.PlayerLeft += spring_PlayerLeft;
			spring.PlayerLost += spring_PlayerLost;
			spring.PlayerDisconnected += spring_PlayerDisconnected;
			spring.GameOver += spring_GameOver;
		}

		#endregion

		#region Public methods

		public static string CalculateHexMD5Hash(string input)
		{
			var md5 = MD5.Create();
			var inputBytes = Encoding.ASCII.GetBytes(input);
			var hash = md5.ComputeHash(inputBytes);

			var sb = new StringBuilder();
			for (int i = 0; i < hash.Length; i++) sb.Append(hash[i].ToString("x2"));
			return sb.ToString();
		}

		public string SendCommand(string script, string query, bool async, bool hash)
		{
			Uri uri;
			try {
				if (hash) {
					query += "&login=" + UserName;
					uri = new Uri(StatsUrl + script + "?" + query.Replace("#", "%23") + "&hash=" + CalculateHexMD5Hash(query + password));

					Console.WriteLine(query);
					Console.WriteLine(CalculateHexMD5Hash(query + password));
				} else uri = new Uri(StatsUrl + script + "?" + query);

				if (async) {
					var t1 = new Thread(delegate(object s)
					                    	{
					                    		try {
					                    			var wc = new WebClient();
					                    			wc.DownloadString((Uri) s);
					                    		} catch {}
					                    	});
					t1.Start(uri);
					return "";
				} else {
					var wc = new WebClient();
					return wc.DownloadString(uri);
				}
			} catch {
				return "";
			}
		}

		#endregion

		#region Other methods

		private void LoadAccounts()
        {
		    string fname = Program.WorkPath + '/' + accountsFileName;
			if (File.Exists(fname)) {
				var s = new XmlSerializer(accounts.GetType());
				var r = File.OpenText(fname);
				accounts = (List<Account>) s.Deserialize(r);
				r.Close();
			}
		}

		private bool RegisterPlayerInCombat(string name)
		{
			if (players.ContainsKey(name)) return true;
			var p = new EndGamePlayerInfo();
			p.Name = name;
			int idx = battle.GetUserIndex(name);
			if (idx != -1) {
				p.Side = battle.Mod.Sides[battle.Users[idx].Side];
				p.Spectator = battle.Users[idx].IsSpectator;
				p.AllyNumber = battle.Users[idx].AllyNumber;
				p.Ip = battle.Users[idx].ip.ToString();

				User u;
				if (tas.GetExistingUser(name, out u)) p.Rank = u.rank + 1;
			} else return false;
			players.Add(name, p);
			return true;
		}

		private void SaveAccounts()
		{
            string fname = Program.WorkPath + '/' + accountsFileName;
			var s = new XmlSerializer(accounts.GetType());
			var f = File.OpenWrite(fname);
			f.SetLength(0);
			s.Serialize(f, accounts);
			f.Close();
		}

		#endregion

		#region Event Handlers

		private void spring_GameOver(object sender, SpringLogEventArgs e)
		{
			string query = String.Format("a=battle&map={0}&mod={1}&title={2}&start={3}&duration={4}", battle.Map.Name, battle.Mod.Name, battle.Title, Utils.ToUnix(startTime), Utils.ToUnix(DateTime.Now.Subtract(startTime)));

			foreach (var p in players.Values) if (!p.Spectator && p.AliveTillEnd) foreach (var pset in players.Values) if (pset.AllyNumber == p.AllyNumber && !pset.Spectator) pset.OnVictoryTeam = true;

			foreach (var p in players.Values) query += "&player[]=" + p;

            if (Program.main.PlanetWars != null) Program.main.PlanetWars.SendBattleResult(battle, players);

			// send only if there were at least 2 players in game
			if (players.Count > 1) SendCommand(gatherScript, query, true, true);
		}

		private void spring_PlayerDisconnected(object sender, SpringLogEventArgs e)
		{
			if (RegisterPlayerInCombat(e.Username)) {
			    players[e.Username].DisconnectTime = (int)DateTime.Now.Subtract(startTime).TotalSeconds;
                players[e.Username].AliveTillEnd = false;
			}
		}

		private void spring_PlayerJoined(object sender, SpringLogEventArgs e)
		{
			if (e.Username == UserName) return; // do not add autohost itself
			RegisterPlayerInCombat(e.Username);
		}

		private void spring_PlayerLeft(object sender, SpringLogEventArgs e)
		{
			if (RegisterPlayerInCombat(e.Username)) {
			    players[e.Username].LeaveTime = (int)DateTime.Now.Subtract(startTime).TotalSeconds;
                players[e.Username].AliveTillEnd = false;
			}
		}

		private void spring_PlayerLost(object sender, SpringLogEventArgs e)
		{
			if (RegisterPlayerInCombat(e.Username)) {
				players[e.Username].LoseTime = (int)DateTime.Now.Subtract(startTime).TotalSeconds;
				players[e.Username].AliveTillEnd = false;
			}
		}

		private void spring_SpringStarted(object sender, EventArgs e)
		{
			battle = tas.GetBattle();
			players = new Dictionary<string, EndGamePlayerInfo>();
			startTime = DateTime.Now;
		}

		private void tas_BattleUserIpRecieved(object sender, TasEventArgs e)
		{
			User u;
			if (tas.GetExistingUser(e.ServerParams[0], out u)) SendCommand(gatherScript, "a=joinplayer&name=" + u.name + "&rank=" + u.rank + "&ip=" + e.ServerParams[1], true, true);
		}


		private void tas_LoginAccepted(object sender, TasEventArgs e)
		{
			var a = accounts.Find(delegate(Account acc) { return acc.UserName == UserName; });
			if (a != null) password = a.Password;

			if (password == "") {
				password = SendCommand(gatherScript, "a=register&name=" + UserName, false, false);
				if (password != "") {
					if (password.StartsWith("FAILED")) {
						var mes = "You need correct password to submit stats with account " + UserName + ", stats won't work - " + password;
						if (Program.GuiEnabled) MessageBox.Show(mes, "Stats registration failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
						else ErrorHandling.HandleException(null, mes);
					}
					else {
						accounts.Add(new Account(UserName, password));
						SaveAccounts();
					}
				} else {
					var mes = "Error registering to stats server - stats server probably down. Statistics wont work until next Springie start";
					if (Program.GuiEnabled) MessageBox.Show(mes, "Stats registration failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
					else ErrorHandling.HandleException(null, mes);
				}
			}
		}

		private void tas_UserRemoved(object sender, TasEventArgs e)
		{
			SendCommand(gatherScript, "a=removeplayer&name=" + e.ServerParams[0], true, true);
		}

		private void tas_UserStatusChanged(object sender, TasEventArgs e)
		{
			User u;
			if (tas.GetExistingUser(e.ServerParams[0], out u)) SendCommand(gatherScript, "a=addplayer&name=" + u.name + "&rank=" + (u.rank + 1), true, true);
		}

		#endregion

		#region Nested type: Account

		public class Account
		{
			#region Properties

			public string Password;
			public string UserName;

			#endregion

			#region Constructors

			public Account() {}

			public Account(string userName, string password)
			{
				UserName = userName;
				Password = password;
			}

			#endregion
		} ;

		#endregion
	}
}