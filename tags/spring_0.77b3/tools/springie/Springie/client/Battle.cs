#region using

using System;
using System.Collections.Generic;
using Springie.SpringNamespace;

#endregion

namespace Springie.Client
{
	public class Battle : ICloneable
	{
		#region NatMode enum

		public enum NatMode
		{
			None = 0,
			HolePunching = 1,
			FixedPorts = 2
		} ;

		#endregion

		#region Properties

		public List<BotBattleStatus> Bots = new List<BotBattleStatus>();

		public BattleDetails Details = new BattleDetails();
		public List<string> DisabledUnits = new List<string>();
		public int HostPort;
		public bool IsLocked;
		public MapInfo Map;
		public int MaxPlayers;
		public ModInfo Mod;
		public Dictionary<string, string> ModOptions = new Dictionary<string, string>();
		public NatMode Nat = NatMode.None;
		public string Password = "*";
		public int Rank;
		public Dictionary<int, BattleRect> Rectangles = new Dictionary<int, BattleRect>();
		public string Title;

		public List<UserBattleStatus> Users = new List<UserBattleStatus>();

		#endregion

		#region Constructors

		public Battle(string password, int port, int maxplayers, int rank, MapInfo map, string title, ModInfo mod, BattleDetails details)
		{
			if (!String.IsNullOrEmpty(password)) Password = password;
			else Password = "*";
			if (port == 0) HostPort = 8452;
			else HostPort = port;
			MaxPlayers = maxplayers;
			Rank = rank;
			Map = map;
			Title = title;
			Mod = mod;
			if (details != null) Details = details;
			else details = new BattleDetails();
			details.Validate();
		}

		#endregion

		#region Public methods

		public bool ContainsUser(string name)
		{
			foreach (var u in Users) if (u.name == name) return true;
			return false;
		}

		public bool ContainsUser(string name, out UserBattleStatus retu)
		{
			foreach (var u in Users) {
				if (u.name == name) {
					retu = u;
					return true;
				}
			}
			retu = new UserBattleStatus();
			return false;
		}

		/// <summary>
		/// count players - non spectators
		/// </summary>
		/// <returns>returns number of players that will play the game</returns>
		public int CountPlayers()
		{
			int speccount = 0;
			foreach (var u in Users) if (!u.IsSpectator) speccount++;
			return speccount;
		}

		public int CountSpectators()
		{
			int speccount = 0;
			foreach (var u in Users) if (u.IsSpectator) speccount++;
			return speccount;
		}

		public int GetFirstEmptyRectangle()
		{
			for (int i = 0; i < Spring.MaxAllies; ++i) if (!Rectangles.ContainsKey(i)) return i;
			return -1;
		}

		public int GetUserIndex(string name)
		{
			for (int i = 0; i < Users.Count; ++i) if (Users[i].name == name) return i;
			return -1;
		}

		/// <summary>
		/// Groups tam and ally numbers, so that they both start from 0
		/// </summary>
		public void GroupData(out List<GrPlayer> players, out List<GrTeam> teams, out List<GrAlly> alliances)
		{
			var teamNums = new Dictionary<int, int>();
			var allyNums = new Dictionary<int, int>();

			players = new List<GrPlayer>();
			teams = new List<GrTeam>();
			alliances = new List<GrAlly>();

			foreach (var p in Users) {
				var u = (UserBattleStatus) p.Clone();

				if (!u.IsSpectator) {
					if (!teamNums.ContainsKey(u.TeamNumber)) {
						teamNums.Add(u.TeamNumber, teams.Count); // add transformation of team
						teams.Add(new GrTeam(players.Count));
					}
					u.TeamNumber = teamNums[u.TeamNumber];

					if (!allyNums.ContainsKey(u.AllyNumber)) {
						allyNums.Add(u.AllyNumber, alliances.Count); // add transformation of ally
						alliances.Add(new GrAlly());
					}
					u.AllyNumber = allyNums[u.AllyNumber];
				}
				players.Add(new GrPlayer(u));
			}

			foreach (var p in Bots) {
				var u = (BotBattleStatus) p.Clone();

				if (!teamNums.ContainsKey(u.TeamNumber)) {
					teamNums.Add(u.TeamNumber, teams.Count); // add transformation of team
					int leader = 0;
					for (leader = 0; leader < players.Count; ++leader) if (players[leader].user.name == u.owner) break;
					var gr = new GrTeam(leader);
					gr.bot = u;
					teams.Add(gr);
				}
				u.TeamNumber = teamNums[u.TeamNumber];

				if (!allyNums.ContainsKey(u.AllyNumber)) {
					allyNums.Add(u.AllyNumber, alliances.Count); // add transformation of ally
					alliances.Add(new GrAlly());
				}
				u.AllyNumber = allyNums[u.AllyNumber];
			}


			// now assign rectangles and skip unused
			foreach (var r in Rectangles) if (allyNums.ContainsKey(r.Key)) alliances[allyNums[r.Key]] = new GrAlly(r.Value);
		}

		public void RemoveUser(string name)
		{
			int ret = GetUserIndex(name);
			if (ret != -1) Users.RemoveAt(ret);
		}

		#endregion

		#region ICloneable Members

		public object Clone()
		{
			var b = (Battle) MemberwiseClone();
			if (Details != null) b.Details = (BattleDetails) Details.Clone();
			if (Users != null) b.Users = new List<UserBattleStatus>(Users);
			if (Rectangles != null) b.Rectangles = new Dictionary<int, BattleRect>(Rectangles);

			if (DisabledUnits != null) b.DisabledUnits = new List<string>(DisabledUnits);
			return b;
		}

		#endregion

		#region Nested type: GrAlly

		public struct GrAlly
		{
			#region Properties

			public BattleRect rect;

			#endregion

			#region Constructors

			public GrAlly(BattleRect r)
			{
				rect = r;
			}

			#endregion
		} ;

		#endregion

		#region Nested type: GrPlayer

		public struct GrPlayer
		{
			#region Properties

			public UserBattleStatus user;

			#endregion

			#region Constructors

			public GrPlayer(UserBattleStatus ubs)
			{
				user = ubs;
			}

			#endregion
		} ;

		#endregion

		#region Nested type: GrTeam

		public struct GrTeam
		{
			#region Properties

			public BotBattleStatus bot;
			public int leader;

			#endregion

			#region Constructors

			public GrTeam(int leader)
			{
				bot = null;
				this.leader = leader;
			}

			#endregion
		} ;

		#endregion
	} ;
}