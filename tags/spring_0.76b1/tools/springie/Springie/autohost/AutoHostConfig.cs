using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;
using System.ComponentModel;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.AutoHostNamespace
{
  public class AutoHostConfig
  {
    public class ModConverter : StringConverter
    {
      public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
      {
        return true;
      }

      public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
      {
        List<string> mods = new List<string>();
        foreach (KeyValuePair<string, ModInfo> p in Program.main.Spring.UnitSync.ModList) {
          mods.Add(p.Value.Name);
        }
        return new StandardValuesCollection(mods);
      }
    };

    public class MapConverter : StringConverter
    {
      public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
      {
        return true;
      }

      public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
      {
        List<string> maps = new List<string>();
        foreach (KeyValuePair<string, MapInfo> p in Program.main.Spring.UnitSync.MapList) {
          maps.Add(p.Value.Name);
        }
        return new StandardValuesCollection(maps);
      }


    };


    string password = "*";

    [Category("Basic options")]
    [Description("Game password")]
    public string Password
    {
      get { return password; }
      set { password = value; }
    }

    int hostingPort = 8452;
    [Category("Basic options")]
    [Description("Hosting port number")]
    public int HostingPort
    {
      get { return hostingPort; }
      set { hostingPort = value; }
    }


    //bool useHolePunching = false;
    public bool UseHolePunching { get { return false; } }
    /*[Category("Basic options")]
    [Description("Should Springie use hole punching NAT traversal method?")]
    public bool UseHolePunching
    {
      get { return useHolePunching; }
      set { useHolePunching = value; }
    }*/

    int maxPlayers = 10;
    [Category("Basic options")]
    [Description("Maximum number of players")]
    public int MaxPlayers
    {
      get { return maxPlayers; }
      set { maxPlayers = value; }
    }
    int minRank = 0;

    [Category("Basic options")]
    [Description("Minimum rank to be allowed to join")]
    public int MinRank
    {
      get { return minRank; }
      set { minRank = value; }
    }

    bool kickMinRank = false;
    [Category("Basic options")]
    [Description("Should autohost kick people below min rank?")]
    public bool KickMinRank
    {
      get { return kickMinRank; }
      set { kickMinRank = value; }
    }


    string defaultMod = "XTA v8";
    [Category("Mod and map"), Description("Default game mod"), TypeConverter(typeof(ModConverter))]
    public string DefaultMod
    {
      get { return defaultMod; }
      set { defaultMod = value; }
    }


    string defaultMap = "SmallDivide.smf";
    [Category("Mod and map"), Description("Default game map"), TypeConverter(typeof(MapConverter))]
    public string DefaultMap
    {
      get { return defaultMap; }
      set { defaultMap = value; }
    }

    bool autoDownloadNewMaps = false;
    [Category("Mod and map"), Description("Should springie redirect global game chat to lobby?")]
    public bool AutoDownloadNewMaps
    {
      get { return autoDownloadNewMaps; }
      set { autoDownloadNewMaps = value; }
    }


    string[] mapCycle = new string[] { };
    [Category("Mod and map"), Description("Optional mapcycle - when game ends, another map is from this list is picked. You don't have to specify exact names here, springie is using filtering capabilities to find entered maps.")]
    public string[] MapCycle
    {
      get { return mapCycle; }
      set { mapCycle = value; }
    }


    public List<BattleRect> DefaultRectangles = new List<BattleRect>();

    string gameTitle = "AutoHost (%1)";
    [Category("Texts")]
    [Description("Game title - appears in open game list, %1 = springie version")]
    public string GameTitle
    {
      get { return gameTitle; }
      set { gameTitle = value; }
    }


    private bool kickSpectators = false;
    [Category("Default battle settings"), Description("Do you want to automatically kick spectators")]
    public bool KickSpectators
    {
      get { return kickSpectators; }
      set { kickSpectators = value; }
    }

    private double minCpuSpeed = 0;
    [Category("Default battle settings"), Description("Players with CPU speed (in GHz) below this value will be autokicked - 0 no kicking")]
    public double MinCpuSpeed
    {
      get { return minCpuSpeed; }
      set { minCpuSpeed = value; }
    }


    private BattleDetails battleDetails = new BattleDetails();
    [Category("Default battle settings"), Description("Defines battle details to use by default")]
    public BattleDetails BattleDetails
    {
      get { return battleDetails; }
      set { battleDetails = value; }
    }

    private UnitInfo[] disabledUnits = new UnitInfo[] { };
    [Category("Default battle settings"), Description("List of units disabled by default")]
    public UnitInfo[] DisabledUnits
    {
      get { return disabledUnits; }
      set { disabledUnits = value; }
    }

    int defaulRightsLevelForLobbyAdmins = 4;
    [Category("Rights")]
    [Description("Default rights level for lobby admins (mod admins)")]
    public int DefaulRightsLevelForLobbyAdmins
    {
      get { return defaulRightsLevelForLobbyAdmins; }
      set { defaulRightsLevelForLobbyAdmins = value; }
    }
    

    int defaulRightsLevel = 1;
    [Category("Rights")]
    [Description("Default rights level for non-privileged users")]
    public int DefaulRightsLevel
    {
      get { return defaulRightsLevel; }
      set { defaulRightsLevel = value; }
    }

    int defaultRightsLevelWithBoss = 0;
    [Category("Rights")]
    [Description("Default rights level for non-privileged users when there is a boss in game")]
    public int DefaultRightsLevelWithBoss
    {
      get { return defaultRightsLevelWithBoss; }
      set { defaultRightsLevelWithBoss = value; }
    }

    
    int autoLockMinPlayers = 2;
    [Category("Basic options")]
    [Description("Minimum number of players for autolocking")]
    public int AutoLockMinPlayers
    {
      get { return autoLockMinPlayers; }
      set { autoLockMinPlayers = value; }
    }

    public List<CommandConfig> Commands = new List<CommandConfig>();
    public List<PrivilegedUser> PrivilegedUsers = new List<PrivilegedUser>();

    string welcome = "Hi %1 (rights:%2), welcome to %3, automated host. For help say !help";
    [Category("Texts")]
    [Description("Welcome message - server says this when users joins. %1 = user name, %2 = user rights level, %3 = springie version")]
    public string Welcome
    {
      get { return welcome; }
      set { welcome = value; }
    }


    string kickSpectatorText = "spectators not allowed here at this time, sorry";
    [Category("Texts")]
    [Description("Message used when kicking spectator")]
    public string KickSpectatorText
    {
      get { return kickSpectatorText; }
      set { kickSpectatorText = value; }
    }



    bool displayMapLink = true;
    [Category("Texts")]
    [Description("Should Springie advertise a maplink to new joiners and after map change?")]
    public bool DisplayMapLink
    {
      get { return displayMapLink; }
      set { displayMapLink = value; }
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

    private void AddMissing(CommandConfig command, List<CommandConfig> addedCommands)
    {
      foreach (CommandConfig c in Commands) {
        if (c.Name == command.Name) {
          addedCommands.Add(c);
          return;
        }
      }
      Commands.Add(command);
      addedCommands.Add(command);
    }

    public void AddMissingCommands()
    {
      List<CommandConfig> addedCommands = new List<CommandConfig>();

      AddMissing(new CommandConfig("help", 0, " - lists all commands available specifically to you", 5), addedCommands);

      AddMissing(new CommandConfig("random", 1, "<allycount> - assigns people to <allycount> random alliances, e.g. !random - makes 2 random alliances", 10), addedCommands);

      AddMissing(new CommandConfig("balance", 1, "<allycount> - assigns people to <allycount> rank balanced alliances, e.g. !balance - makes 2 random but balanced alliances", 10), addedCommands);

      AddMissing(new CommandConfig("start", 1, " - starts game", 5), addedCommands);

      AddMissing(new CommandConfig("ring", 0, "[<filters>..] - rings all unready or specific player(s), e.g. !ring - rings unready, !ring icho - rings Licho", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);


      AddMissing(new CommandConfig("listmaps", 0, "[<filters>..] - lists maps on server, e.g. !listmaps altor div", 10), addedCommands);
      AddMissing(new CommandConfig("listmods", 0, "[<filters>..] - lists mods on server, e.g. !listmods absolute 2.23", 5), addedCommands);
      AddMissing(new CommandConfig("map", 2, "[<filters>..] - changes server map, eg. !map altor div"), addedCommands);

      AddMissing(new CommandConfig("forcestart", 2, " - starts game forcibly (ignoring warnings)", 5), addedCommands);

      AddMissing(new CommandConfig("say", 0, "<text> - says something in game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("force", 2, " - forces game start inside game", 8, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);
      AddMissing(new CommandConfig("kick", 3, "[<filters>..] - kicks a player", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("split", 1, "<\"h\"/\"v\"> <percent> - draws with given direction and percentual size, e.g. !split h 15"), addedCommands);

      AddMissing(new CommandConfig("corners", 1, "<\"a\"/\"b\"> <percent> - draws corners (a or b mode differ in ordering), e.g. !corners a 15"), addedCommands);


      AddMissing(new CommandConfig("exit", 3, " - exits the game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("lock", 1, " - locks the game"), addedCommands);

      AddMissing(new CommandConfig("unlock", 1, " - unlocks the game"), addedCommands);

      AddMissing(new CommandConfig("fix", 1, " - fixes teamnumbers", 5), addedCommands);

      AddMissing(new CommandConfig("votemap", 0, "[<mapname>..] - starts vote for new map, e.g. !votemap altored div"), addedCommands);

      AddMissing(new CommandConfig("votekick", 0, "[<mapname>..] - starts vote to kick a player, e.g. !votekick Licho", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("voteforcestart", 0, " - starts vote to force game to start in lobby"), addedCommands);

      AddMissing(new CommandConfig("voteforce", 0, " - starts vote to force game to start from game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("voteexit", 0, " - starts vote to exit game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("vote", 0, "<number> - votes for given option (works from battle only), e.g. !vote 1", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("rehost", 3, "[<modname>..] - rehosts game, e.g. !rehost abosol 2.23 - rehosts AA2.23"), addedCommands);
      AddMissing(new CommandConfig("voterehost", 0, "[<modname>..] - votes to rehost game, e.g. !rehost abosol 2.23 - rehosts AA2.23", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("admins", 0, " - lists admins", 5), addedCommands);

      AddMissing(new CommandConfig("setlevel", 4, "<level> <playername> - set's rights level for player.Setting to 0 deletes players."), addedCommands);

      AddMissing(new CommandConfig("maplink", 0, "[<mapname>..] - looks for maplinks at unknown-files", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Channel }), addedCommands);

      AddMissing(new CommandConfig("modlink", 0, "[<modname>..] - looks for modlinks at unknown-files", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Channel }), addedCommands);


      AddMissing(new CommandConfig("dlmap", 1, "[<mapname/dllid/url>..] - downloads map to server. You can either specify map name or map id (from unknown files) or map URL", 10), addedCommands);

      AddMissing(new CommandConfig("dlmod", 1, "[<modname/dllid/url>..] - downloads mod to server. You must specify mod file id (from unknown files) or mod URL", 10), addedCommands);


      AddMissing(new CommandConfig("reload", 2, " - reloads mod and map list (can take long time)", 30), addedCommands);

      AddMissing(new CommandConfig("team", 2, "<teamnumber> [<playername>..] - forces given player to a team"), addedCommands);

      AddMissing(new CommandConfig("ally", 2, "<allynumber> [<playername>..] - forces given player to an alliance"), addedCommands);

      AddMissing(new CommandConfig("helpall", 0, "- lists all commands known to Springie (sorted by command level)", 5), addedCommands);

      AddMissing(new CommandConfig("fixcolors", 1, "- changes too similar colors to more different (note that color difference is highly subjective and impossible to model mathematically, so it won't always produce results satisfying for all)", 10), addedCommands);

      AddMissing(new CommandConfig("springie", 0, "- responds with basic springie information", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel }), addedCommands);

      AddMissing(new CommandConfig("endvote", 2, "- ends current poll"), addedCommands);

      AddMissing(new CommandConfig("addbox", 1, "<left> <top> <width> <height> [<number>] - adds a new box rectangle"), addedCommands);

      AddMissing(new CommandConfig("clearbox", 1, "[<number>] - removes a box (or removes all boxes if number not specified)"), addedCommands);

      AddMissing(new CommandConfig("listpresets", 0, "[<presetname>..] - lists all presets this server has (with name filtering)", 5), addedCommands);

      AddMissing(new CommandConfig("preset", 2, "[<presetname>..] - applies given preset to current battle"), addedCommands);

      AddMissing(new CommandConfig("votepreset", 0, "[<presetname>..] - starts a vote to apply given preset"), addedCommands);

      AddMissing(new CommandConfig("presetdetails", 0, "[<presetname>..] - shows details of given preset", 2), addedCommands);

      AddMissing(new CommandConfig("cbalance", 1, "[<allycount>] - assigns people to allycount random balanced alliances but attempts to put clanmates to same teams", 10), addedCommands);

      AddMissing(new CommandConfig("ban", 4, "<username> [<duration>] [<reason>...] - bans user username for duration (in minutes) with given reason. Duration 0 = ban for 1000 years", 0), addedCommands);

      AddMissing(new CommandConfig("unban", 4, "<username> - unbans user", 0), addedCommands);

      AddMissing(new CommandConfig("listbans", 0, "- lists currently banned users", 0), addedCommands);

      AddMissing(new CommandConfig("smurfs", 0, "- finds smurfs, use this command to get more help", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel }), addedCommands);

      AddMissing(new CommandConfig("stats", 0, "- displays statistics, use this command to get more help", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel }), addedCommands);

      AddMissing(new CommandConfig("kickspec", 2, "[0|1] - enables or disables automatic spectator kicking", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game, TasSayEventArgs.Places.Normal }), addedCommands);

      AddMissing(new CommandConfig("votekickspec", 0, "- starts a vote to enables or disable automatic spectator kicking", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("setpassword", 4, "<newpassword> - sets server password (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setminrank", 4, "<minrank> - sets server minimum rank (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setmaxplayers", 4, "<maxplayers> - sets server size (needs !rehost to apply)"), addedCommands);

      AddMissing(new CommandConfig("setgametitle", 4, "<new title> - sets server game title (needs !rehost to apply)"), addedCommands);


      AddMissing(new CommandConfig("mincpuspeed", 4, "<GHz> - sets minimum CPU for this host - players with CPU speed below this value are auto-kicked, 0 = no limit"), addedCommands);


      AddMissing(new CommandConfig("boss", 2, "<name> - sets <name> as a new boss, use without parameter to remove any current boss. If there is a boss on server, other non-admin people have their rights reduced"), addedCommands);


      AddMissing(new CommandConfig("voteboss", 0, "<name> - sets <name> as a new boss, use without parameter to remove any current boss. If there is a boss on server, other non-admin people have their rights reduced", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);

      AddMissing(new CommandConfig("autolock", 1, "<players> - sets desired number of players in game. If this number is reached, server will autolock itself, if someone leaves, it will autounlock again. !autolock without parameter disables auto locking"), addedCommands);

      AddMissing(new CommandConfig("spec", 2, "<username> - forces player to become spectator", 0), addedCommands);

      AddMissing(new CommandConfig("specafk", 1, "forces all AFK player to become spectators", 0), addedCommands);

      AddMissing(new CommandConfig("kickminrank", 4, "[0/1] enables or disables automatic kicking of people based upon their rank", 0), addedCommands);

      AddMissing(new CommandConfig("cheats", 3, "enables/disables .cheats in game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }), addedCommands);


      Commands.RemoveAll(delegate(CommandConfig c) { return !addedCommands.Contains(c);});
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

    public AutoHostConfig()
    {
    }
  }

}
