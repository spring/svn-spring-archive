#region using

using System.ComponentModel;
using Springie.Client;
using Springie.SpringNamespace;

#endregion

namespace Springie.autohost
{
	public class Preset
	{
		#region Fields

		private int? diminishingMM;
		private UnitInfo[] disabledUnits = new UnitInfo[0];
		private bool enableAllUnits;
		private BattleEndCondition? endCondition;
		private int? ghostedBuildings;
		private int? limitDgun;
		private int? maxUnits;
		private string name = "<enter name here>";
		private string[] perform = new string[0];
		private int? startingEnergy;
		private int? startingMetal;
		private BattleStartPos? startPos;

		#endregion

		#region Properties

		[Category("Basic")]
		[Description("Brief description of this preset")]
		public string Description { get; set; }

		[Category("Game rules")]
		[Description("Diminishing metal maker outputs, 0 = normal mm, 1 = diminishing mm")]
		public int? DiminishingMM
		{
			get { return diminishingMM; }
			set { diminishingMM = value; }
		}

		[Category("Units")]
		[Description("Units to disable")]
		public UnitInfo[] DisabledUnits
		{
			get { return disabledUnits; }
			set { disabledUnits = value; }
		}

		[Category("Units")]
		[Description("Should this preset enable all units before disabling")]
		public bool EnableAllUnits
		{
			get { return enableAllUnits; }
			set { enableAllUnits = value; }
		}

		[Category("Game rules")]
		[Description("End condition - should continue when comm dies")]
		public BattleEndCondition? EndCondition
		{
			get { return endCondition; }
			set { endCondition = value; }
		}

		[Category("Game rules")]
		[Description("Ghosted buildings, 0 = no ghosted buildings, 1 = ghosted buildings")]
		public int? GhostedBuildings
		{
			get { return ghostedBuildings; }
			set { ghostedBuildings = value; }
		}

		[Category("Game rules")]
		[Description("Limit dgun to start position, 0 = no limit, 1 = limited")]
		public int? LimitDgun
		{
			get { return limitDgun; }
			set { limitDgun = value; }
		}

		[Category("Resources")]
		[Description("Maximum units")]
		public int? MaxUnits
		{
			get { return maxUnits; }
			set { maxUnits = value; }
		}

		[Category("Basic")]
		[Description("Name of this preset")]
		public string Name
		{
			set { name = value; }
			get { return name; }
		}

		[Category("Basic")]
		[Description("List of additional commands to be performed")]
		public string[] Perform
		{
			set { perform = value; }
			get { return perform; }
		}

		[Category("Resources")]
		[Description("Starting energy")]
		public int? StartingEnergy
		{
			get { return startingEnergy; }
			set { startingEnergy = value; }
		}

		[Category("Resources")]
		[Description("Starting metal")]
		public int? StartingMetal
		{
			get { return startingMetal; }
			set { startingMetal = value; }
		}


		[Category("Game rules")]
		[Description("Starting position")]
		public BattleStartPos? StartPos
		{
			get { return startPos; }
			set { startPos = value; }
		}

		#endregion

		#region Public methods

		public void Apply(TasClient tas, Ladder ladder)
		{
			var b = tas.GetBattle();
			if (b == null) return;
			var d = b.Details;

			int mint, maxt;
			if (ladder != null) d = ladder.CheckBattleDetails(d, out mint, out maxt);
			tas.UpdateBattleDetails(d);

			if (enableAllUnits) tas.EnableAllUnits();
			if (disabledUnits.Length > 0) tas.DisableUnits(UnitInfo.ToStringList(disabledUnits));

			foreach (var s in perform) tas.Say(TasClient.SayPlace.Battle, "", s, false);
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			string ret = "";

			if (startingMetal.HasValue) ret += "metal: " + startingMetal.Value + "\n";
			if (startingEnergy.HasValue) ret += "energy: " + startingEnergy.Value + "\n";
			if (maxUnits.HasValue) ret += "units: " + maxUnits.Value + "\n";
			if (startPos.HasValue) ret += "start position: " + startPos.Value + "\n";
			if (endCondition.HasValue) ret += "comm end: " + endCondition.Value + "\n";
			if (limitDgun.HasValue) ret += "limit dgun: " + limitDgun.Value + "\n";
			if (diminishingMM.HasValue) ret += "diminishing mm: " + diminishingMM.Value + "\n";
			if (ghostedBuildings.HasValue) ret += "ghosted buildings: " + ghostedBuildings.Value + "\n";

			for (int i = 0; i < disabledUnits.Length; ++i) ret += "Disable " + disabledUnits[i].Name + " (" + disabledUnits[i].FullName + ")\n";

			if (ret == "") ret = "no changes";
			return ret;
		}

		#endregion
	}
}