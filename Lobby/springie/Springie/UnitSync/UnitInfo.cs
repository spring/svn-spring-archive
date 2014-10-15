using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace Springie.SpringNamespace
{
	[TypeConverter(typeof (UnitConverter))]
	[Serializable]
	public struct UnitInfo:ICloneable
	{
		#region Properties

		public string FullName;
		public string Name;

		#endregion

		#region Constructors

		public UnitInfo(string name, string fullName)
		{
			Name = name;
			FullName = fullName;
		}

		#endregion

		#region Public methods

		public static UnitInfo[] FromStringList(string[] src, ModInfo mod)
		{
			var result = new List<UnitInfo>();
			for (int i = 0; i < src.Length; ++i) {
				UnitInfo u;
				if (mod.GetUnitInfo(src[i], out u)) result.Add(u);
			}
			return result.ToArray();
		}

		public static string[] ToStringList(UnitInfo[] src)
		{
			var result = new string[src.Length];
			for (int i = 0; i < src.Length; ++i) result[i] = src[i].Name;
			return result;
		}

		#endregion

		public object Clone()
		{
			return MemberwiseClone();
		}
	}
}