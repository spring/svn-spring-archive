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
		private BattleStartPos startPos = BattleStartPos.Choose;

		#endregion

		#region Properties

		public static BattleDetails Default = new BattleDetails();

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
			return string.Format("GAME/StartPosType={0}\t", (int) startPos);
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
						case "game/startpostype":
							StartPos = (BattleStartPos) int.Parse(arg[1]);
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
					return "Position:" + b.StartPos;
				} else return base.ConvertTo(context, culture, value, destinationType);
			}

			#endregion
		}

		#endregion
	} ;
}