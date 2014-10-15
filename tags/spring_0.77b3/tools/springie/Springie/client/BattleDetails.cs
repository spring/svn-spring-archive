#region using

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;

#endregion

namespace Springie.Client
{
	public enum BattleStartPos
	{
		Fixed = 0,
		Random = 1,
		Choose = 2
	}

	public enum BattleEndCondition
	{
		Continues = 0,
		Ends = 1,
		Lineage = 2
	}

	[TypeConverter(typeof (BattleDetailsConverter))]
	public class BattleDetails : ICloneable
	{
		#region Fields

		private int diminishingMM;
		private BattleEndCondition endCondition = BattleEndCondition.Continues;
		private int ghostedBuildings = 1;
		private int limitDgun;
		private int maxUnits = 1000;
		private int startingEnergy = 1000;

		private int startingMetal = 1000;
		private BattleStartPos startPos = BattleStartPos.Choose;

		#endregion

		#region Properties

		public static BattleDetails Default = new BattleDetails();

		[Category("Game rules")]
		[Description("Diminishing metal maker outputs")]
		public int DiminishingMM
		{
			get { return diminishingMM; }
			set { diminishingMM = value; }
		}

		[Category("Game rules")]
		[Description("End condition - should continue when comm dies")]
		public BattleEndCondition EndCondition
		{
			get { return endCondition; }
			set { endCondition = value; }
		}

		[Category("Game rules")]
		[Description("Ghosted buildings")]
		public int GhostedBuildings
		{
			get { return ghostedBuildings; }
			set { ghostedBuildings = value; }
		}

		[Category("Game rules")]
		[Description("Limit dgun to start position")]
		public int LimitDgun
		{
			get { return limitDgun; }
			set { limitDgun = value; }
		}

		[Category("Resources")]
		[Description("Maximum units")]
		public int MaxUnits
		{
			get { return maxUnits; }
			set { maxUnits = value; }
		}

		[Category("Resources")]
		[Description("Starting energy")]
		public int StartingEnergy
		{
			get { return startingEnergy; }
			set { startingEnergy = value; }
		}

		[Category("Resources")]
		[Description("Starting metal")]
		public int StartingMetal
		{
			get { return startingMetal; }
			set { startingMetal = value; }
		}

		[Category("Game rules")]
		[Description("Starting position")]
		public BattleStartPos StartPos
		{
			get { return startPos; }
			set { startPos = value; }
		}

		#endregion

		#region Public methods

		public string GetParamList()
		{
			Validate();
			return string.Format("GAME/StartMetal={0}\tGAME/StartEnergy={1}\tGAME/MaxUnits={2}\tGAME/StartPosType={3}\tGAME/GameMode={4}\tGAME/LimitDGun={5}\tGAME/DiminishingMMs={6}\tGAME/GhostedBuildings={7}", startingMetal, startingEnergy, maxUnits, (int) startPos, (int) endCondition, limitDgun, diminishingMM, ghostedBuildings);
		}

		/// <summary>
		/// parses itself from source tags
		/// </summary>
		/// <param name="source"></param>
		public void Parse(string source, Dictionary<string, string> modOptions)
		{
			foreach (var pair in source.Split('\t')) {
				var arg = pair.Split(new[] {'='}, 2);
				if (arg.Length == 2) {
					switch (arg[0]) {
						case "game/startmetal":
							StartingMetal = int.Parse(arg[1]);
							break;
						case "game/startenergy":
							StartingEnergy = int.Parse(arg[1]);
							break;
						case "game/maxunits":
							MaxUnits = int.Parse(arg[1]);
							break;
						case "game/startpostype":
							StartPos = (BattleStartPos) int.Parse(arg[1]);
							break;
						case "game/gamemode":
							EndCondition = (BattleEndCondition) int.Parse(arg[1]);
							break;
						case "game/limitdgun":
							LimitDgun = int.Parse(arg[1]);
							break;
						case "game/diminishingmms":
							DiminishingMM = int.Parse(arg[1]);
							break;
						case "game/ghostedbuildings":
							GhostedBuildings = int.Parse(arg[1]);
							break;
						default:
							if (arg[0].ToLower().StartsWith("game/modoptions/") || arg[0].ToLower().StartsWith("game\\modoptions\\")) {
								string val = arg[0].Substring(16);
								if (modOptions.ContainsKey(val)) modOptions[val] = arg[1];
								else modOptions.Add(val, arg[1]);
							}
							break;
					}
				}
			}
		}

		public void Validate()
		{
			if (startingMetal < 0) startingMetal = Default.startingMetal;
			if (startingEnergy < 0) startingEnergy = Default.startingEnergy;
			if (maxUnits < 0) maxUnits = Default.maxUnits;
			if (limitDgun < 0) limitDgun = Default.limitDgun;
			if (diminishingMM < 0) diminishingMM = Default.diminishingMM;
			if (ghostedBuildings < 0) ghostedBuildings = Default.ghostedBuildings;
		}

		#endregion

		#region ICloneable Members

		public object Clone()
		{
			return MemberwiseClone();
		}

		#endregion

		#region Nested type: BattleDetailsConverter

		protected class BattleDetailsConverter : ExpandableObjectConverter
		{
			#region Overrides

			public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value, Type destinationType)
			{
				if (destinationType == typeof (string)) {
					var b = (BattleDetails) value;
					return "Position:" + b.StartPos + "; Comm:" + b.EndCondition + "; Dgun:" + b.LimitDgun;
				} else return base.ConvertTo(context, culture, value, destinationType);
			}

			#endregion
		}

		#endregion
	} ;
}