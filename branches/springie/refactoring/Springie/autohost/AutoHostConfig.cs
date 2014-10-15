using System.Collections.Generic;
using System.ComponentModel;
using Springie.autohost.commands;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.autohost
{
  public class AutoHostConfig
  {
    private bool autoDownloadNewMaps = false;
    private int autoLockMinPlayers = 2;
    private BattleDetails battleDetails = new BattleDetails();
    public List<CommandConfig> Commands = new List<CommandConfig>();
    private int defaulRightsLevel = 1;
    private int defaulRightsLevelForLobbyAdmins = 4;
    private string defaultMap = "SmallDivide.smf";
    private string defaultMod = "XTA v8";
    public List<BattleRect> DefaultRectangles = new List<BattleRect>();
    private int defaultRightsLevelWithBoss = 0;
    private UnitInfo[] disabledUnits = new UnitInfo[] {};
    private bool displayMapLink = true;
    private string gameTitle = "AutoHost (%1)";
    private int hostingPort = 8452;
    private bool kickMinRank = false;
    private bool kickSpectators = false;
    private string kickSpectatorText = "spectators not allowed here at this time, sorry";
    private int ladderId = 0;
    private string[] limitMaps;
    private string[] limitMods;
    private string[] mapCycle = new string[] {};
    private int maxPlayers = 10;
    private double minCpuSpeed = 0;
    private int minRank = 0;
    private string password = "*";
    public List<PrivilegedUser> PrivilegedUsers = new List<PrivilegedUser>();
    private bool useHolePunching = false;
    private string welcome = "Hi %1 (rights:%2), welcome to %3, automated host. For help say !help";

    public AutoHostConfig() {}

    [Category("Basic options")]
    [Description("Game password")]
    public string Password
    {
      get { return password; }
      set { password = value; }
    }

    [Category("Basic options")]
    [Description("Hosting port number")]
    public int HostingPort
    {
      get { return hostingPort; }
      set { hostingPort = value; }
    }


    [Category("Basic options")]
    [Description("Should Springie use hole punching NAT traversal method? - Incompatible with gargamel mode")]
    public bool UseHolePunching
    {
      get { return useHolePunching; }
      set { useHolePunching = value; }
    }

    [Category("Basic options")]
    [Description("Maximum number of players")]
    public int MaxPlayers
    {
      get { return maxPlayers; }
      set { maxPlayers = value; }
    }

    [Category("Basic options")]
    [Description("Minimum rank to be allowed to join")]
    public int MinRank
    {
      get { return minRank; }
      set { minRank = value; }
    }

    [Category("Basic options")]
    [Description("Should autohost kick people below min rank?")]
    public bool KickMinRank
    {
      get { return kickMinRank; }
      set { kickMinRank = value; }
    }


    [Category("Mod and map")]
    [Description("Default game mod")]
    [TypeConverter(typeof(ModConverter))]
    public string DefaultMod
    {
      get { return defaultMod; }
      set { defaultMod = value; }
    }


    [Category("Mod and map")]
    [Description("Limit map selection to this list")]
    public string[] LimitMaps
    {
      get { return limitMaps; }
      set { limitMaps = value; }
    }

    [Category("Mod and map")]
    [Description("Limit mod selection to this list")]
    public string[] LimitMods
    {
      get { return limitMods; }
      set { limitMods = value; }
    }

    [Category("Mod and map")]
    [Description("Default game map")]
    [TypeConverter(typeof(MapConverter))]
    public string DefaultMap
    {
      get { return defaultMap; }
      set { defaultMap = value; }
    }

    [Category("Mod and map")]
    [Description("Should springie redirect global game chat to lobby?")]
    public bool AutoDownloadNewMaps
    {
      get { return autoDownloadNewMaps; }
      set { autoDownloadNewMaps = value; }
    }


    [Category("Mod and map")]
    [Description("Optional mapcycle - when game ends, another map is from this list is picked. You don't have to specify exact names here, springie is using filtering capabilities to find entered maps.")]
    public string[] MapCycle
    {
      get { return mapCycle; }
      set { mapCycle = value; }
    }


    [Category("Texts")]
    [Description("Game title - appears in open game list, %1 = springie version")]
    public string GameTitle
    {
      get { return gameTitle; }
      set { gameTitle = value; }
    }


    [Category("Default battle settings")]
    [Description("Do you want to automatically kick spectators")]
    public bool KickSpectators
    {
      get { return kickSpectators; }
      set { kickSpectators = value; }
    }

    [Category("Default battle settings")]
    [Description("Players with CPU speed (in GHz) below this value will be autokicked - 0 no kicking")]
    public double MinCpuSpeed
    {
      get { return minCpuSpeed; }
      set { minCpuSpeed = value; }
    }


    [Category("Default battle settings")]
    [Description("Defines battle details to use by default")]
    public BattleDetails BattleDetails
    {
      get { return battleDetails; }
      set { battleDetails = value; }
    }

    [Category("Default battle settings")]
    [Description("List of units disabled by default")]
    public UnitInfo[] DisabledUnits
    {
      get { return disabledUnits; }
      set { disabledUnits = value; }
    }

    [Category("Rights")]
    [Description("Default rights level for lobby admins (mod admins)")]
    public int DefaulRightsLevelForLobbyAdmins
    {
      get { return defaulRightsLevelForLobbyAdmins; }
      set { defaulRightsLevelForLobbyAdmins = value; }
    }


    [Category("Rights")]
    [Description("Default rights level for non-privileged users")]
    public int DefaulRightsLevel
    {
      get { return defaulRightsLevel; }
      set { defaulRightsLevel = value; }
    }

    [Category("Rights")]
    [Description("Default rights level for non-privileged users when there is a boss in game")]
    public int DefaultRightsLevelWithBoss
    {
      get { return defaultRightsLevelWithBoss; }
      set { defaultRightsLevelWithBoss = value; }
    }


    [Category("Basic options")]
    [Description("Minimum number of players for autolocking")]
    public int AutoLockMinPlayers
    {
      get { return autoLockMinPlayers; }
      set { autoLockMinPlayers = value; }
    }

    [Category("Texts")]
    [Description("Welcome message - server says this when users joins. %1 = user name, %2 = user rights level, %3 = springie version")]
    public string Welcome
    {
      get { return welcome; }
      set { welcome = value; }
    }


    [Category("Texts")]
    [Description("Message used when kicking spectator")]
    public string KickSpectatorText
    {
      get { return kickSpectatorText; }
      set { kickSpectatorText = value; }
    }


    [Category("Texts")]
    [Description("Should Springie advertise a maplink to new joiners and after map change?")]
    public bool DisplayMapLink
    {
      get { return displayMapLink; }
      set { displayMapLink = value; }
    }

    [Category("Basic options")]
    [Description("Should Springie host ladder map? Pick ladder id")]
    public int LadderId
    {
      get { return ladderId; }
      set { ladderId = value; }
    }


    public void SetPrivilegedUser(string name, int level)
    {
      for (int i = 0; i < PrivilegedUsers.Count; ++i) {
        if (PrivilegedUsers[i].Name == name) {
          if (level == 0) {
            PrivilegedUsers.RemoveAt(i);
            return;
          } else {
            PrivilegedUsers[i].Level = level;
            return;
          }
        }
      }
      if (level > 0) PrivilegedUsers.Add(new PrivilegedUser(name, level));
    }

    public void AddMissingCommands()
    {
      List<CommandConfig> addedCommands = new List<CommandConfig>();

      AddMissing(new CommandConfig("listmaps", 0, "[<filters>..] - lists maps on server, e.g. !listmaps altor div", 10), addedCommands);
      AddMissing(new CommandConfig("listmods", 0, "[<filters>..] - lists mods on server, e.g. !listmods absolute 2.23", 5), addedCommands);
      AddMissing(new CommandConfig("map", 2, "[<filters>..] - changes server map, eg. !map altor div"), addedCommands);

      AddMissing(new CommandConfig("manage", 1, "<minaplayer> [<maxplayers>] - auto manage server for min to max players"), addedCommands);

      AddMissing(new CommandConfig("forcestart", 2, " - starts game forcibly (ignoring warnings)", 5), addedCommands);

      AddMissing(new CommandConfig("say", 0, "<text> - says something in game", 0, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game}), addedCommands);

      AddMissing(new CommandConfig("force", 2, " - forces game start inside game", 8, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game}), addedCommands);

      AddMissing(new CommandConfig("split", 1, "<\"h\"/\"v\"> <percent> - draws with given direction and percentual size, e.g. !split h 15"), addedCommands);

      AddMissing(new CommandConfig("corners", 1, "<\"a\"/\"b\"> <percent> - draws corners (a or b mode differ in ordering), e.g. !corners a 15"), addedCommands);

      AddMissing(new CommandConfig("exit", 3, " - exits the game", 0, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game}), addedCommands);

      AddMissing(new CommandConfig("lock", 1, " - locks the game"), addedCommands);

      AddMissing(new CommandConfig("unlock", 1, " - unlocks the game"), addedCommands);


      AddMissing(new CommandConfig("rehost", 3, "[<modname>..] - rehosts game, e.g. !rehost abosol 2.23 - rehosts AA2.23"), addedCommands);

      AddMissing(new CommandConfig("admins", 0, " - lists admins", 5), addedCommands);

      AddMissing(new CommandConfig("setlevel", 4, "<level> <playername> - set's rights level for player.Setting to 0 deletes players."), addedCommands);

      AddMissing(new CommandConfig("maplink", 0, "[<mapname>..] - looks for maplinks at unknown-files", 5, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal}), addedCommands);

      AddMissing(new CommandConfig("modlink", 0, "[<modname>..] - looks for modlinks at unknown-files", 5, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal}), addedCommands);

      AddMissing(new CommandConfig("dlmap", 1, "[<mapname/dllid/url>..] - downloads map to server. You can either specify map name or map id (from unknown files) or map URL", 10), addedCommands);

      AddMissing(new CommandConfig("dlmod", 1, "[<modname/dllid/url>..] - downloads mod to server. You must specify mod file id (from unknown files) or mod URL", 10), addedCommands);

      AddMissing(new CommandConfig("reload", 2, " - reloads mod and map list (can take long time)", 30), addedCommands);

      AddMissing(new CommandConfig("helpall", 0, "- lists all commands known to Springie (sorted by command level)", 5), addedCommands);

      AddMissing(new CommandConfig("fixcolors", 1, "- changes too similar colors to more different (note that color difference is highly subjective and impossible to model mathematically, so it won't always produce results satisfying for all)", 10), addedCommands);

      AddMissing(new CommandConfig("springie", 0, "- responds with basic springie information", 5, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel}), addedCommands);

      AddMissing(new CommandConfig("addbox", 1, "<left> <top> <width> <height> [<number>] - adds a new box rectangle"), addedCommands);

      AddMissing(new CommandConfig("clearbox", 1, "[<number>] - removes a box (or removes all boxes if number not specified)"), addedCommands);

      AddMissing(new CommandConfig("listpresets", 0, "[<presetname>..] - lists all presets this server has (with name filtering)", 5), addedCommands);

      AddMissing(new CommandConfig("listoptions", 1, " - lists all mod/map options", 5), addedCommands);

      AddMissing(new CommandConfig("setoptions", 1, "<name>=<value>[,<name>=<value>] - applies mod/map options", 0), addedCommands);

      AddMissing(new CommandConfig("votesetoptions", 1, "<name>=<value>[,<name>=<value>] - starts a vote to apply mod/map options", 0), addedCommands);

      AddMissing(new CommandConfig("preset", 2, "[<presetname>..] - applies given preset to current battle"), addedCommands);

      AddMissing(new CommandConfig("votepreset", 0, "[<presetname>..] - starts a vote to apply given preset"), addedCommands);

      AddMissing(new CommandConfig("presetdetails", 0, "[<presetname>..] - shows details of given preset", 2), addedCommands);

      AddMissing(new CommandConfig("cbalance", 1, "[<allycount>] - assigns people to allycount random balanced alliances but attempts to put clanmates to same teams", 10), addedCommands);

      AddMissing(new CommandConfig("ban", 4, "<username> [<duration>] [<reason>...] - bans user username for duration (in minutes) with given reason. Duration 0 = ban for 1000 years", 0), addedCommands);

      AddMissing(new CommandConfig("unban", 4, "<username> - unbans user", 0), addedCommands);

      AddMissing(new CommandConfig("listbans", 0, "- lists currently banned users", 0), addedCommands);

      AddMissing(new CommandConfig("smurfs", 0, "- finds smurfs, use this command to get more help", 5, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel}), addedCommands);

      AddMissing(new CommandConfig("stats", 0, "- displays statistics, use this command to get more help", 5, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel}), addedCommands);

      AddMissing(new CommandConfig("kickspec", 2, "[0|1] - enables or disables automatic spectator kicking", 0, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game, TasSayEventArgs.Places.Normal}), addedCommands);

      AddMissing(new CommandConfig("setpassword", 4, "<newpassword> - sets server password (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setminrank", 4, "<minrank> - sets server minimum rank (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setmaxplayers", 4, "<maxplayers> - sets server size (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setgametitle", 4, "<new title> - sets server game title (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("mincpuspeed", 4, "<GHz> - sets minimum CPU for this host - players with CPU speed below this value are auto-kicked, 0 = no limit"), addedCommands);

      AddMissing(new CommandConfig("boss", 2, "<name> - sets <name> as a new boss, use without parameter to remove any current boss. If there is a boss on server, other non-admin people have their rights reduced"), addedCommands);


      AddMissing(new CommandConfig("autolock", 1, "<players> - sets desired number of players in game. If this number is reached, server will autolock itself, if someone leaves, it will autounlock again. !autolock without parameter disables auto locking"), addedCommands);


      AddMissing(new CommandConfig("specafk", 1, "forces all AFK player to become spectators", 0), addedCommands);

      AddMissing(new CommandConfig("kickminrank", 4, "[0/1] enables or disables automatic kicking of people based upon their rank", 0), addedCommands);

      AddMissing(new CommandConfig("cheats", 3, "enables/disables .cheats in game", 0, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game}), addedCommands);

      AddMissing(new CommandConfig("notify", 0, "springie notifies you when game ends", 0, new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game, TasSayEventArgs.Places.Channel}), addedCommands);

      Commands.RemoveAll(delegate(CommandConfig c) { return !addedCommands.Contains(c); });
    }


    public static int CommandComparer(CommandConfig a, CommandConfig b)
    {
      return a.Name.CompareTo(b.Name);
    }

    public static int UserComparer(PrivilegedUser a, PrivilegedUser b)
    {
      return a.Name.CompareTo(b.Name);
    }

    public void Defaults()
    {
      DefaultRectangles.Add(new BattleRect(0.0, 0.0, 1.0, 0.15));
      DefaultRectangles.Add(new BattleRect(0.0, 0.85, 1.0, 1.0));
      AddMissingCommands();
    }

    #region Nested type: MapConverter
    public class MapConverter : StringConverter
    {
      public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
      {
        return true;
      }

      public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
      {
        List<string> maps = new List<string>();
        foreach (KeyValuePair<string, MapInfo> p in Program.main.Spring.UnitSync.MapList) maps.Add(p.Value.Name);
        return new StandardValuesCollection(maps);
      }
    } ;
    #endregion

    #region Nested type: ModConverter
    public class ModConverter : StringConverter
    {
      public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
      {
        return true;
      }

      public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
      {
        List<string> mods = new List<string>();
        foreach (KeyValuePair<string, ModInfo> p in Program.main.Spring.UnitSync.ModList) mods.Add(p.Value.Name);
        return new StandardValuesCollection(mods);
      }
    } ;
    #endregion
  }
}