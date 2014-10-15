#region using

using System.Collections.Generic;
using System.Net;
using Springie.Client;

#endregion

namespace Springie.autohost
{
	public class Ladder
	{
		#region Constants

		private const string ladderUrl = "http://blendax.informatik.uni-bremen.de/jan/spring/ladder/lobby/";

		#endregion

		#region Fields

		private int ladderId;

		private List<string> maps = new List<string>();

		private string[] rules;

		#endregion

		#region Properties

		public int Id
		{
			get { return ladderId; }
		}

		public List<string> Maps
		{
			get { return maps; }
		}

		#endregion

		#region Constructors

		public Ladder(int id)
		{
			ladderId = id;
			LoadMapList();
			LoadRules();
		}

		#endregion

		#region Public methods

		public BattleDetails CheckBattleDetails(BattleDetails battleDetailsOriginal, out int minTeamPlayers, out int maxTeamPlayers)
		{
			minTeamPlayers = 1;
			maxTeamPlayers = 8;
			BattleDetails battleDetails;
			if (battleDetailsOriginal != null) battleDetails = (BattleDetails) battleDetailsOriginal.Clone();
			else battleDetails = new BattleDetails();

			foreach (var line in rules) {
				var args = line.Split(' ');
				string key = args[0];
				string val = Utils.Glue(args, 1);

				if (key == "min_players_per_allyteam") minTeamPlayers = int.Parse(val);
				if (key == "max_players_per_allyteam") maxTeamPlayers = int.Parse(val);
				if (key == "startpos") if (val != "any") battleDetails.StartPos = (BattleStartPos) int.Parse(val);
				if (key == "gamemode") if (val != "any") battleDetails.EndCondition = (BattleEndCondition) int.Parse(val);
				if (key == "dgun") if (val != "any") battleDetails.LimitDgun = int.Parse(val);
				if (key == "ghost") if (val != "any") battleDetails.GhostedBuildings = int.Parse(val);
				if (key == "diminish") if (val != "any") battleDetails.DiminishingMM = int.Parse(val);
				if (key == "metal") {
					if (val != "any") {
						int min = int.Parse(args[1]);
						int max = int.Parse(args[2]);
						if (battleDetails.StartingMetal < min) battleDetails.StartingMetal = min;
						if (battleDetails.StartingMetal > max) battleDetails.StartingMetal = max;
					}
				}
				if (key == "energy") {
					if (val != "any") {
						int min = int.Parse(args[1]);
						int max = int.Parse(args[2]);
						if (battleDetails.StartingEnergy < min) battleDetails.StartingEnergy = min;
						if (battleDetails.StartingEnergy > max) battleDetails.StartingEnergy = max;
					}
				}

				if (key == "units") {
					if (val != "any") {
						int min = int.Parse(args[1]);
						int max = int.Parse(args[2]);
						if (battleDetails.MaxUnits < min) battleDetails.MaxUnits = min;
						if (battleDetails.MaxUnits > max) battleDetails.MaxUnits = max;
					}
				}
			}
			return battleDetails;
		}

		#endregion

		#region Other methods

		private void LoadMapList()
		{
			var wc = new WebClient();
			try {
				string lines = wc.DownloadString(ladderUrl + "maplist.php?ladder=" + ladderId);
				maps.Clear();
				foreach (var line in lines.Split('\n')) maps.Add(line.ToLower());
			} catch {}
			;
		}


		private void LoadRules()
		{
			try {
				var wc = new WebClient();
				wc.UseDefaultCredentials = true;
				string lines = wc.DownloadString(ladderUrl + "rules.php?ladder=" + ladderId);
				rules = lines.Split('\n');
			} catch {}
			;
		}

		#endregion

		/*private static GetLadderList() {
      WebClient wc = new WebClient();
      try {
        string lines = wc.DownloadString("ladderlist.php");
        ladders.Clear();
        foreach (string line in lines.Split('\n', StringSplitOptions.RemoveEmptyEntries)) {
          string[] args = line.Split(' ');
          int id;
          int.TryParse(args[0], out id);
          string name = Utils.Glue(args, 1);
          ladders.Add(id, name);
        }
      } catch { };
    }*/
	}
}