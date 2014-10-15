using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.IO;

namespace Springie.SpringNamespace
{
  public struct UnitInfo
  {
    public string Name;
    public string FullName;
    public UnitInfo(string name, string fullName)
    {
      this.Name = name;
      this.FullName = fullName;
    }
  }


  /// <summary>
  /// Represents one mod. Detailed information are loaded on demand for given mod.
  /// </summary>
  public class ModInfo
  {
    string name;
    public string Name
    {
      get { return name; }
    }

    protected string archiveName;
    public string ArchiveName
    {
      get { CheckLoaded(); return archiveName; }
      set { archiveName = value; }
    }

    private int checksum;
    public int Checksum
    {
      get { CheckLoaded(); return checksum; }
      set { checksum = value; }
    }

    private string[] sides;
    public string[] Sides
    {
      get { CheckLoaded(); return sides; }
      set { sides = value; }
    }

    private UnitInfo[] units;
    public UnitInfo[] Units
    {
      get { CheckLoaded(); return units; }
      set { units = value; }
    }

    UnitSync unitSync = null;
    bool loaded = false;
    int modId = -1;
    public int ModId { get { return modId; } }
    private object myLock = new object();


    public ModInfo(UnitSync owner, string name, int modId)
    {
      unitSync = owner;
      this.name = name;
      this.modId = modId;
    }

    private void CheckLoaded()
    {

      if (!loaded && unitSync != null) {
        lock (myLock) {
          loaded = true;
          unitSync.LoadModInfo(this);
        }
      }
    }
  };


  public class MapInfo
  {
    public string Name;
    public string ArchiveName;
  };


  public class UnitSync : IDisposable
  {
    public UnitSync() : this(Directory.GetCurrentDirectory()) { }

    string path;
    Dictionary<string, string> mapArchives = new Dictionary<string, string>();

    List<string> mapList = new List<string>();
    public List<string> MapList
    {
      get { return mapList; }
    }

    Dictionary<string, ModInfo> modList = new Dictionary<string, ModInfo>();
    public Dictionary<string, ModInfo> ModList
    {
      get { return modList; }
    }



    public UnitSync(string path)
    {
      this.path = path;
      string opath = Directory.GetCurrentDirectory();
      Directory.SetCurrentDirectory(path);
      if (Init(false, 0) != 1) throw new Exception("unitsync.dll init failed");
      if (InitArchiveScanner() != 1) throw new Exception("unitsync.dll:InitArchiveScanner() failed");
      LoadModList();
      LoadMapList();
      Directory.SetCurrentDirectory(opath);
    }


    /// <summary>
    /// Gets map list from unit sync, does not make full reinit by default
    /// </summary>
    /// <returns></returns>
    void LoadMapList()
    {
      string opath = Directory.GetCurrentDirectory();
      Directory.SetCurrentDirectory(path);

      mapArchives = new Dictionary<string, string>();

      int mapCount = GetMapCount();
      mapList.Clear();
      for (int i = 0; i < mapCount; ++i) {
        string mapname = GetMapName(i);
        mapList.Add(mapname);
        mapArchives[mapname] = RequestMapArchive(mapname);
      }
      Directory.SetCurrentDirectory(opath);
    }


    /// <summary>
    /// Gets mod list - does not make full reinit by default
    /// </summary>
    /// <returns></returns>
    void LoadModList()
    {
      string opath = Directory.GetCurrentDirectory();
      Directory.SetCurrentDirectory(path);

      int modCount = GetPrimaryModCount();

      modList.Clear();
      for (int i = 0; i < modCount; ++i) {
        ModInfo mi = new ModInfo(this, GetPrimaryModName(i), i);
        modList[mi.Name] = mi;
      }

    }


    internal void LoadModInfo(ModInfo mi)
    {
      string opath = Directory.GetCurrentDirectory();
      Directory.SetCurrentDirectory(path);
      int i = mi.ModId;

      ReInit(true);

      GetPrimaryModCount();
      if (mi.Name != GetPrimaryModName(i)) throw new Exception("Mod " + mi.Name + " modified without reload");

      mi.ArchiveName = GetPrimaryModArchive(i);
      uint result = 0;
      int acount = GetPrimaryModArchiveCount(i);
      for (int x = 0; x < acount; ++x) {
        result += GetArchiveChecksum(GetPrimaryModArchiveList(x));
      }
      mi.Checksum = (int)result;

      AddAllArchives(mi.ArchiveName);

      mi.Sides = new String[GetSideCount()];
      for (int x = 0; x < mi.Sides.Length; ++x) {
        mi.Sides[x] = GetSideName(x);
      }

      // weirdest stuff of all...
      while (ProcessUnitsNoChecksum() != 0) { };
      mi.Units = new UnitInfo[GetUnitCount()];
      for (int x = 0; x < mi.Units.Length; ++x) {
        mi.Units[x] = new UnitInfo(GetUnitName(x), GetFullUnitName(x));
      }


      Directory.SetCurrentDirectory(opath);
    }


    /// <summary>
    /// ReInits unitsync
    /// </summary>
    /// <param name="full">if true does complete reinit (neccesary to find new map or mod), if false does just archivescannerinit</param>
    void ReInit(bool full)
    {
      string opath = Directory.GetCurrentDirectory();
      Directory.SetCurrentDirectory(path);

      if (full) {
        UnInit();
        if (Init(false, 0) != 1) throw new Exception("unitsync.dll init failed");
      }
      if (InitArchiveScanner() != 1) throw new Exception("unitsync.dll:InitArchiveScanner() failed");

      Directory.SetCurrentDirectory(opath);
    }


    public string GetMapArchiveName(string mapname)
    {
      if (mapArchives.ContainsKey(mapname)) return mapArchives[mapname]; else return "";
    }

    public bool HasMap(string name)
    {
      return mapList.Contains(name);
    }

    public ModInfo GetModInfo(string name)
    {
      return modList[name];
    }

    public bool HasMod(string modName)
    {
      return modList.ContainsKey(modName);
    }


    string RequestMapArchive(string mapname)
    {
      int i = GetMapArchiveCount(mapname);
      if (i > 0) {
        string arch = GetMapArchiveName(0);
        int lastslash = arch.LastIndexOfAny(new char[] { '/', '\\' });
        return arch.Substring(lastslash + 1);
      } else return "";
    }

    /*
    //     MAPS
    */
    [DllImport("unitsync.dll")]
    static extern int GetMapCount();

    [DllImport("unitsync.dll")]
    static extern string GetMapName(int index);

    [DllImport("unitsync.dll")]
    static extern int GetMapArchiveCount(string mapName);

    [DllImport("unitsync.dll")]
    static extern string GetMapArchiveName(int index);

    /*
    //     MODS
    */
    [DllImport("unitsync.dll")]
    static extern int GetPrimaryModCount();

    [DllImport("unitsync.dll")]
    static extern string GetPrimaryModName(int index);

    [DllImport("unitsync.dll")]
    static extern string GetPrimaryModArchive(int index);

    [DllImport("unitsync.dll")]
    static extern string GetPrimaryModArchiveList(int index);

    [DllImport("unitsync.dll")]
    static extern uint GetArchiveChecksum(string archive);

    [DllImport("unitsync.dll")]
    static extern int GetPrimaryModArchiveCount(int index);

    [DllImport("unitsync.dll")]
    static extern void AddAllArchives(string root);


    /*
    //     SIDES
    */
    [DllImport("unitsync.dll")]
    static extern int GetSideCount();

    [DllImport("unitsync.dll")]
    static extern string GetSideName(int index);


    /*
    //     UNITS
    */
    [DllImport("unitsync.dll")]
    static extern int ProcessUnitsNoChecksum();

    [DllImport("unitsync.dll")]
    static extern int GetUnitCount();

    [DllImport("unitsync.dll")]
    static extern string GetUnitName(int index);

    [DllImport("unitsync.dll")]
    static extern string GetFullUnitName(int index);


    /*
    //     INIT
    */
    [DllImport("unitsync.dll")]
    static extern int Init(bool isServer, int id);

    [DllImport("unitsync.dll")]
    static extern int InitArchiveScanner();

    [DllImport("unitsync.dll")]
    static extern void UnInit();


    #region IDisposable Members
    public void Dispose()
    {
      UnInit();
    }
    #endregion

    internal void Reload(bool reloadMods, bool reloadMaps)
    {
      if (reloadMods || reloadMaps) {
        ReInit(true);
      }
      if (reloadMaps) LoadMapList();
      if (reloadMods) LoadModList();
    }

  }
}
