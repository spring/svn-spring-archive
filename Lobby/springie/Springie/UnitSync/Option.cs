#region using

using System;
using System.Collections.Generic;

#endregion

namespace Springie.SpringNamespace
{
	[Serializable]
	public class Option : ICloneable
	{
		#region Constants

		private const string Table = "GAME/MODOPTIONS/";

		#endregion

		#region Type enum

		public enum Type
		{
			Error = 0,
			Bool = 1,
			List = 2,
			Number = 3,
			String = 4
		} ;

		#endregion

		#region Properties

		public string Default;
		public string Description;
		public string Key;
		public List<ListOption> ListOptions = new List<ListOption>();
		public float max = float.MinValue;
		public float min = float.MinValue;

		public string Name;
		public Type OptionType;
		public float strMaxLen = 65535;

		#endregion

		#region Public methods

		public bool GetPair(string Value, out string result)
		{
			result = "";
			switch (OptionType) {
				case Type.Bool:
					if (Value != "0" && Value != "1") return false;
					result = ConstructLine(Value);
					return true;

				case Type.Number:
					double d;
					if (!double.TryParse(Value, out d)) return false;
					if (d < min || d > max) return false;
					result = ConstructLine(Value);
					return true;

				case Type.String:
					if (strMaxLen != 0 && Value.Length > strMaxLen) return false;
					result = ConstructLine(Value);
					return true;

				case Type.List:
					foreach (var lop in ListOptions) {
						if (lop.Key == Value) {
							result = ConstructLine(lop.Key);
							return true;
						}
					}
					return false;
			}

			return false;
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			string pom = "";
			string typs = "";
			if (OptionType == Type.Number) {
				typs = "x";
				pom += " = ";
				if (min != float.MinValue) pom += " >=" + min;
				if (max != float.MaxValue) pom += " <=" + max;
			}
			if (OptionType == Type.List) {
				pom += " = ";
				foreach (var lop in ListOptions) {
					pom += lop.Key + "-" + lop.Description + " | ";
					typs += lop.Key + "|";
				}
			}
			if (OptionType == Type.Bool) typs += "0|1";
			if (OptionType == Type.String) typs += "s";

			return string.Format("{0}={1}  ({2}{3})", Key, typs, Description, pom);
		}

		#endregion

		#region Other methods

		public string ConstructLine(string val)
		{
			return Table + Key + "=" + val;
		}

		#endregion

		#region ICloneable Members

		public object Clone()
		{
			var opt = (Option) MemberwiseClone();
			opt.ListOptions = new List<ListOption>(ListOptions.Count);
			foreach (var option in ListOptions) opt.ListOptions.Add((ListOption) option.Clone());
			return opt;
		}

		#endregion
	}
}