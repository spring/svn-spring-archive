#region using

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;

#endregion

namespace Springie.SpringNamespace
{
	internal class UnitConverter : StringConverter
	{
		#region Overrides

		public override object ConvertFrom(ITypeDescriptorContext context, CultureInfo culture, object value)
		{
			string tofind = value.ToString().Split(' ')[0];
			foreach (var u in GetMod().Units) if (u.Name == tofind) return u;
			return null;
		}

		public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value, Type destinationType)
		{
			if (destinationType == typeof (String)) {
				if (value == null) return null;
				var u = (UnitInfo) value;
				if (u.Name != null) return u.Name + " (" + u.FullName + ")";
				else return null;
			} else return base.ConvertTo(context, culture, value, destinationType);
		}


		public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
		{
			return new StandardValuesCollection(GetMod().Units);
		}

		public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
		{
			return true;
		}

		#endregion

		#region Other methods

		private ModInfo GetMod()
		{
			if (Program.main.Tas != null) {
				var b = Program.main.Tas.GetBattle();
				if (b != null) return b.Mod;
			}
			return Program.main.Spring.UnitSync.GetModInfo(Program.main.AutoHost.config.DefaultMod);
		}

		#endregion
	}


	[TypeConverter(typeof (UnitConverter))]
	public struct UnitInfo
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
	}


	/// <summary>
	/// Represents one mod. Detailed information are loaded on demand for given mod.
	/// </summary>
	public class ModInfo
	{
		#region Fields

		protected string archiveName;
		private int checksum;
		private bool loaded;
		private int modId = -1;
		private object myLock = new object();
		private string name;
		private string[] sides;
		private UnitInfo[] units;
		private UnitSync unitSync;

		#endregion

		#region Properties

		public string ArchiveName
		{
			get
			{
				CheckLoaded();
				return archiveName;
			}
			set { archiveName = value; }
		}

		public int Checksum
		{
			get
			{
				CheckLoaded();
				return checksum;
			}
			set { checksum = value; }
		}

		public int ModId
		{
			get { return modId; }
		}

		public string Name
		{
			get { return name; }
		}

		public List<UnitSync.Option> Options = new List<UnitSync.Option>();

		public string[] Sides
		{
			get
			{
				CheckLoaded();
				return sides;
			}
			set { sides = value; }
		}

		public UnitInfo[] Units
		{
			get
			{
				CheckLoaded();
				return units;
			}
			set { units = value; }
		}

		#endregion

		#region Constructors

		public ModInfo(UnitSync owner, string name, int modId)
		{
			unitSync = owner;
			this.name = name;
			this.modId = modId;
		}

		#endregion

		#region Public methods

		public bool GetUnitInfo(string name, out UnitInfo res)
		{
			for (int i = 0; i < Units.Length; ++i) {
				if (Units[i].Name == name) {
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
			return name;
		}

		#endregion

		#region Other methods

		private void CheckLoaded()
		{
			if (!loaded && unitSync != null) {
				lock (myLock) {
					loaded = true;
					unitSync.LoadModInfo(this);
				}
			}
		}

		#endregion
	} ;


	public class MapInfo
	{
		#region Fields

		protected string archiveName;

		private int checksum;
		private bool loaded;
		private int mapId = -1;
		private object myLock = new object();
		private string name;
		private UnitSync unitSync;

		#endregion

		#region Properties

		public string ArchiveName
		{
			get
			{
				CheckLoaded();
				return archiveName;
			}
			set { archiveName = value; }
		}

		public int Checksum
		{
			get
			{
				CheckLoaded();
				return checksum;
			}
			set { checksum = value; }
		}

		public int MapId
		{
			get { return mapId; }
		}

		public string Name
		{
			get { return name; }
		}

		#endregion

		#region Constructors

		public MapInfo(UnitSync owner, string name, int mapId)
		{
			unitSync = owner;
			this.name = name;
			this.mapId = mapId;
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			return name;
		}

		#endregion

		#region Other methods

		private void CheckLoaded()
		{
			if (!loaded && unitSync != null) {
				lock (myLock) {
					loaded = true;
					unitSync.LoadMapInfo(this);
				}
			}
		}

		#endregion
	} ;


	public class UnitSync : IDisposable
	{
		#region Fields

		private Dictionary<string, MapInfo> mapList = new Dictionary<string, MapInfo>();
		private Dictionary<string, ModInfo> modList = new Dictionary<string, ModInfo>();
		private string path;

		#endregion

		#region Properties

		public Dictionary<string, MapInfo> MapList
		{
			get { return mapList; }
		}

		public Dictionary<string, ModInfo> ModList
		{
			get { return modList; }
		}

		#endregion

		#region Constructors

		public UnitSync() : this(Directory.GetCurrentDirectory()) {}

		public UnitSync(string path)
		{
			this.path = path;
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);
			if (Init(false, 0) != 1) throw new Exception("unitsync.dll init failed");
			//if (InitArchiveScanner() != 1) throw new Exception("unitsync.dll:InitArchiveScanner() failed");
			LoadModList();
			LoadMapList();
			Directory.SetCurrentDirectory(opath);
		}

		public void Dispose()
		{
			UnInit();
		}

		#endregion

		#region Public methods

		public string GetMapArchiveName(string mapname)
		{
			if (mapList.ContainsKey(mapname)) return mapList[mapname].ArchiveName;
			else return "";
		}

		public MapInfo GetMapInfo(string name)
		{
			return mapList[name];
		}

		public ModInfo GetModInfo(string name)
		{
			if (modList.ContainsKey(name)) return modList[name];
			else {
				foreach (var p in modList) if (p.Value.ArchiveName == name) return p.Value;
				return null;
			}
		}

		public bool HasMap(string name)
		{
			return mapList.ContainsKey(name);
		}


		public bool HasMod(string modName)
		{
			if (!modList.ContainsKey(modName)) {
				foreach (var p in modList) if (p.Value.ArchiveName == modName) return true;
				return false;
			} else return true;
		}

		/// <summary>
		/// Loads new map information
		/// </summary>
		/// <param name="mi"></param>
		internal void LoadMapInfo(MapInfo mi)
		{
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);

			mi.Checksum = (int)GetMapChecksum(mi.MapId);

			Directory.SetCurrentDirectory(opath);
		}

		internal void LoadModInfo(ModInfo mi)
		{
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);
			//ReInit(true);

			//GetPrimaryModCount();
			if (mi.Name != GetPrimaryModName(mi.ModId)) throw new Exception("Mod " + mi.Name + " modified without reload");

			//uint result = 0;
			mi.ArchiveName = GetPrimaryModArchive(mi.ModId);

			mi.Checksum = (int)GetPrimaryModChecksum(mi.ModId);

			AddAllArchives(mi.ArchiveName);
			mi.Sides = new String[GetSideCount()];
			for (int x = 0; x < mi.Sides.Length; ++x) mi.Sides[x] = GetSideName(x);

			// weirdest stuff of all...
			while (ProcessUnitsNoChecksum() != 0) {}
			;
			mi.Units = new UnitInfo[GetUnitCount()];
			for (int x = 0; x < mi.Units.Length; ++x) mi.Units[x] = new UnitInfo(GetUnitName(x), GetFullUnitName(x));

			int opts = GetModOptionCount();
			for (int x = 0; x < opts; x++) {
				var o = new Option(x);
				mi.Options.Add(o);
			}

			Directory.SetCurrentDirectory(opath);
		}

		internal void Reload(bool reloadMods, bool reloadMaps)
		{
			if (reloadMods || reloadMaps) ReInit(true);
			if (reloadMaps) LoadMapList();
			if (reloadMods) LoadModList();
		}

		#endregion

		#region Other methods

		[DllImport("unitsync.dll")]
		private static extern void AddAllArchives(string root);

		[DllImport("unitsync.dll")]
		private static extern uint GetArchiveChecksum(string archive);

		[DllImport("unitsync.dll")]
		private static extern string GetFullUnitName(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetMapArchiveCount(string mapName);

		[DllImport("unitsync.dll")]
		private static extern string GetMapArchiveName(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetMapCount();

		[DllImport("unitsync.dll")]
		private static extern string GetMapName(int index);

		/************************************************************************/
		/*     OPTIONS                                                          */
		/************************************************************************/

		[DllImport("unitsync.dll")]
		private static extern int GetMapOptionCount(string mapName);

		[DllImport("unitsync.dll")]
		private static extern int GetModOptionCount();

		[DllImport("unitsync.dll")]
		private static extern int GetOptionBoolDef(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionDesc(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionKey(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetOptionListCount(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionListDef(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionListItemDesc(int index, int itemIndex);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionListItemKey(int index, int itemIndex);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionListItemName(int index, int itemIndex);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionName(int index);

		[DllImport("unitsync.dll")]
		private static extern float GetOptionNumberDef(int index);

		[DllImport("unitsync.dll")]
		private static extern float GetOptionNumberMax(int index);

		[DllImport("unitsync.dll")]
		private static extern float GetOptionNumberMin(int index);

		[DllImport("unitsync.dll")]
		private static extern float GetOptionNumberStep(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetOptionStringDef(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetOptionStringMaxLen(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetOptionType(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetPrimaryModArchive(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetPrimaryModArchiveCount(int index);

		[DllImport("unitsync.dll")]
		private static extern string GetPrimaryModArchiveList(int index);

		[DllImport("unitsync.dll")]
		private static extern uint GetMapChecksumFromName(string mapName);

		[DllImport("unitsync.dll")]
		private static extern uint GetMapChecksum(int mapIndex);

		[DllImport("unitsync.dll")]
		private static extern uint GetPrimaryModChecksum(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetPrimaryModCount();

		[DllImport("unitsync.dll")]
		private static extern string GetPrimaryModName(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetSideCount();

		[DllImport("unitsync.dll")]
		private static extern string GetSideName(int index);

		[DllImport("unitsync.dll")]
		private static extern int GetUnitCount();

		[DllImport("unitsync.dll")]
		private static extern string GetUnitName(int index);

		/*
    //     INIT
    */

		[DllImport("unitsync.dll")]
		private static extern int Init(bool isServer, int id);

		/// <summary>
		/// Gets map list from unit sync, does not make full reinit by default
		/// </summary>
		/// <returns></returns>
		private void LoadMapList()
		{
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);

			int mapCount = GetMapCount();
			mapList.Clear();
			for (int i = 0; i < mapCount; ++i) {
				var mi = new MapInfo(this, GetMapName(i), i);
				mapList[mi.Name] = mi;
				mi.ArchiveName = RequestMapArchive(mi.Name);
			}
			Directory.SetCurrentDirectory(opath);
		}


		/// <summary>
		/// Gets mod list - does not make full reinit by default
		/// </summary>
		/// <returns></returns>
		private void LoadModList()
		{
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);

			int modCount = GetPrimaryModCount();

			modList.Clear();
			for (int i = 0; i < modCount; ++i) {
				var mi = new ModInfo(this, GetPrimaryModName(i), i);
				modList[mi.Name] = mi;
			}
		}

		[DllImport("unitsync.dll")]
		private static extern int ProcessUnitsNoChecksum();

		/// <summary>
		/// ReInits unitsync
		/// </summary>
		/// <param name="full">if true does complete reinit (neccesary to find new map or mod), if false does just archivescannerinit</param>
		private void ReInit(bool full)
		{
			string opath = Directory.GetCurrentDirectory();
			Directory.SetCurrentDirectory(path);

			if (full) {
				UnInit();
				if (Init(false, 0) != 1) throw new Exception("unitsync.dll init failed");
			}
			//if (InitArchiveScanner() != 1) throw new Exception("unitsync.dll:InitArchiveScanner() failed");

			Directory.SetCurrentDirectory(opath);
		}

		private string RequestMapArchive(string mapname)
		{
			int i = GetMapArchiveCount(mapname);
			if (i > 0) {
				string arch = GetMapArchiveName(0);
				int lastslash = arch.LastIndexOfAny(new[] {'/', '\\'});
				return arch.Substring(lastslash + 1);
			} else return "";
		}


		[DllImport("unitsync.dll")]
		private static extern void UnInit();

		#endregion

		#region Nested type: ListOption

		public struct ListOption
		{
			#region Properties

			public string Description;
			public string Key;
			public string Name;

			#endregion

			#region Constructors

			public ListOption(int optionIndex, int itemIndex)
			{
				Name = GetOptionListItemName(optionIndex, itemIndex);
				Description = GetOptionListItemDesc(optionIndex, itemIndex);
				Key = GetOptionListItemKey(optionIndex, itemIndex);
			}

			#endregion
		}

		#endregion

		#region Nested type: Option

		public class Option
		{
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

			#region Fields

			private float max = float.MinValue;
			private float min = float.MinValue;
			private float step, strMaxLen = 65535;
			private string Table = "GAME/MODOPTIONS/";

			#endregion

			#region Properties

			public string Default;
			public string Description;
			public string Key;
			public List<ListOption> ListOptions = new List<ListOption>();

			public string Name;
			public Type OptionType;

			#endregion

			#region Constructors

			public Option(int idx)
			{
				Name = GetOptionName(idx);
				Key = GetOptionKey(idx);
				Description = GetOptionDesc(idx);
				OptionType = (Type) GetOptionType(idx);
				strMaxLen = GetOptionStringMaxLen(idx);
				min = GetOptionNumberMin(idx);
				max = GetOptionNumberMax(idx);
				step = GetOptionNumberStep(idx);
				int listCount = GetOptionListCount(idx);
				for (int i = 0; i < listCount; i++) {
					var optl = new ListOption(idx, i);
					ListOptions.Add(optl);
				}
				switch (OptionType) {
					case Type.Bool:
						Default = GetOptionBoolDef(idx).ToString();
						break;
					case Type.Number:
						Default = GetOptionNumberDef(idx).ToString();
						break;
					case Type.String:
						Default = GetOptionStringDef(idx);
						break;
					case Type.List:
						Default = GetOptionListDef(idx);
						break;
				}
			}

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

			private string ConstructLine(string val)
			{
				return Table + Key + "=" + val;
			}

			#endregion
		}

		#endregion
	}
}