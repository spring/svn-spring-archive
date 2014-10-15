#region using

using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

#endregion

namespace Springie.SpringNamespace
{
	/// <summary>
	/// Represents one mod. Detailed information are loaded on demand for given mod.
	/// </summary>
	[Serializable]
	public class ModInfo : ICloneable
	{
		#region Fields

		private string name;
		private string shortBaseName;
		private double version;

		#endregion

		#region Properties

		public string ArchiveName { get; set; }

		public int Checksum { get; set; }

		public string Name
		{
			get { return name; }
			internal set
			{
				name = value;
				ExtractNameAndVersion(name, out shortBaseName, out version);
			}
		}

		public List<Option> Options = new List<Option>();

		public string ShortBaseName
		{
			get { return shortBaseName; }
		}

		public string[] Sides { get; set; }

		public UnitInfo[] Units { get; set; }

		public double Version
		{
			get { return version; }
		}

		#endregion

		#region Constructors

		public ModInfo(string name)
		{
			Name = name;
		}

		#endregion

		#region Public methods

		public string GetDefaultModOptionsTags()
		{
			var sb = new StringBuilder();
			foreach (var o in Options)
			{
				string res = o.ConstructLine(o.Default);
					if (sb.Length > 0) sb.Append("\t");
				sb.Append(res);
			}
			return sb.ToString();
		}


		public static void ExtractNameAndVersion(string fullName, out string name, out double version)
		{
			version = 0;
			name = fullName;
			var m = Regex.Match(fullName, "(.*[^0-9\\.]+)([0-9\\.]+)$");
			if (m.Success) {
				double.TryParse(m.Groups[2].Value, out version);
				name = m.Groups[1].Value;
			}
		}

		public bool GetUnitInfo(string modname, out UnitInfo res)
		{
			for (int i = 0; i < Units.Length; ++i) {
				if (Units[i].Name == modname) {
					res = Units[i];
					return true;
				}
			}
			res = new UnitInfo();
			return false;
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			return Name;
		}

		#endregion

		#region ICloneable Members

		public object Clone()
		{
			var mi = (ModInfo) MemberwiseClone();
			mi.Options = new List<Option>(Options.Count);
			foreach (var option in Options) mi.Options.Add((Option) option.Clone());
			return mi;
		}

		#endregion
	} ;
}