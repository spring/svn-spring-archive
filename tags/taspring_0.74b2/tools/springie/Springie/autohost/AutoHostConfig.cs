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


    string[] mapCycle = new string[] {};
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
    



    int defaulRightsLevel = 1;
    [Category("Rights")]
    [Description("Default rights level for non-privileged users")]
    public int DefaulRightsLevel
    {
      get { return defaulRightsLevel; }
      set { defaulRightsLevel = value; }
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

    private void AddMissing(CommandConfig command)
    {
      foreach (CommandConfig c in Commands) {
        if (c.Name == command.Name) return;
      }
      Commands.Add(command);
    }

    public void AddMissingCommands()
    {
      AddMissing(new CommandConfig("help", 0, " - lists all commands available specifically to you", 5));

      AddMissing(new CommandConfig("random", 1, "<allycount> - assigns people to <allycount> random alliances, e.g. !random - makes 2 random alliances", 10));

      AddMissing(new CommandConfig("balance", 1, "<allycount> - assigns people to <allycount> rank balanced alliances, e.g. !balance - makes 2 random but balanced alliances", 5));

      AddMissing(new CommandConfig("start", 1, " - starts game", 5));

      AddMissing(new CommandConfig("ring", 1, "[<filters>..] - rings all unready or specific player(s), e.g. !ring - rings unready, !ring icho - rings Licho", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));


      AddMissing(new CommandConfig("listmaps", 1, "[<filters>..] - lists maps on server, e.g. !listmaps altor div", 10));
      AddMissing(new CommandConfig("listmods", 1, "[<filters>..] - lists mods on server, e.g. !listmods absolute 2.23", 5));
      AddMissing(new CommandConfig("map", 2, "[<filters>..] - changes server map, eg. !map altor div"));

      AddMissing(new CommandConfig("forcestart", 2, " - starts game forcibly (ignoring warnings)", 5));

      AddMissing(new CommandConfig("say", 1, "<text> - says something in game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("force", 2, " - forces game start inside game", 8, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));
      AddMissing(new CommandConfig("kick", 3, "[<filters>..] - kicks a player", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("split", 1, "<\"h\"/\"v\"> <percent> - draws with given direction and percentual size, e.g. !split h 15"));

      AddMissing(new CommandConfig("corners", 1, "<\"a\"/\"b\"> <percent> - draws corners (a or b mode differ in ordering), e.g. !corners a 15"));


      AddMissing(new CommandConfig("exit", 3, " - exits the game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("lock", 1, " - locks the game"));

      AddMissing(new CommandConfig("unlock", 1, " - unlocks the game"));

      AddMissing(new CommandConfig("fix", 1, " - fixes teamnumbers", 5));

      AddMissing(new CommandConfig("votemap", 1, "[<mapname>..] - starts vote for new map, e.g. !votemap altored div"));

      AddMissing(new CommandConfig("votekick", 1, "[<mapname>..] - starts vote to kick a player, e.g. !votekick Licho", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("voteforcestart", 1, " - starts vote to force game to start in lobby"));

      AddMissing(new CommandConfig("voteforce", 1, " - starts vote to force game to start from game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("voteexit", 1, " - starts vote to exit game", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("vote", 0, "<number> - votes for given option (works from battle only), e.g. !vote 1", 0, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));

      AddMissing(new CommandConfig("rehost", 3, "[<modname>..] - rehosts game, e.g. !rehost abosol 2.23 - rehosts AA2.23"));
      AddMissing(new CommandConfig("voterehost", 1, "[<modname>..] - votes to rehost game, e.g. !rehost abosol 2.23 - rehosts AA2.23"));

      AddMissing(new CommandConfig("admins", 0, " - lists admins", 5));

      AddMissing(new CommandConfig("setlevel", 4, "<level> <playername> - set's rights level for player.Setting to 0 deletes players."));

      AddMissing(new CommandConfig("maplink", 0, "[<mapname>..] - looks for maplinks at unknown-files", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal }));

      AddMissing(new CommandConfig("dlmap", 1, "[<mapname/dllid>..] - downloads map to server. You can either specify map name or map id (from unknown files)", 10));

      AddMissing(new CommandConfig("reload", 2, " - reloads mod and map list (can take long time)", 30));

      AddMissing(new CommandConfig("team", 2, "<teamnumber> [<playername>..] - forces given player to a team", 5));

      AddMissing(new CommandConfig("ally", 2, "<allynumber> [<playername>..] - forces given player to an alliance", 5));

      AddMissing(new CommandConfig("helpall", 0, "- lists all commands known to Springie (sorted by command level)", 5));

      AddMissing(new CommandConfig("fixcolors", 1, "- changes too similar colors to more different (note that color difference is highly subjective and impossible to model mathematically, so it won't always produce results satisfying for all)", 10));

      AddMissing(new CommandConfig("springie", 0, "- responds with basic springie information", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel}));

      AddMissing(new CommandConfig("endvote", 2, "- ends current poll", 0));

      AddMissing(new CommandConfig("addbox", 1, "<left> <top> <width> <height> [<number>] - adds a new box rectangle"));
      
      AddMissing(new CommandConfig("clearbox", 1, "[<number>] - removes a box (or removes all boxes if number not specified)"));

      AddMissing(new CommandConfig("listpresets", 1, "[<presetname>..] - lists all presets this server has (with name filtering)", 5));

      AddMissing(new CommandConfig("preset", 2, "[<presetname>..] - applies given preset to current battle"));

      AddMissing(new CommandConfig("votepreset", 1, "[<presetname>..] - starts a vote to apply given preset"));

      AddMissing(new CommandConfig("presetdetails", 1, "[<presetname>..] - shows details of given preset", 2));

      AddMissing(new CommandConfig("cbalance", 1, "[<allycount>] - assigns people to allycount random balanced alliances but attempts to put clanmates to same teams", 5));

      AddMissing(new CommandConfig("ban", 4, "<username> [<duration>] [<reason>...] - bans user username for duration (in minutes) with given reason. Duration 0 = ban for 1000 years", 0));

      AddMissing(new CommandConfig("unban", 4, "<username> - unbans user", 0));

      AddMissing(new CommandConfig("listbans", 1, "- lists currently banned users", 0));

      AddMissing(new CommandConfig("smurfs", 1, "- finds smurfs, use this command to get more help", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel }));

      AddMissing(new CommandConfig("stats", 1, "- displays statistics, use this command to get more help", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Channel }));

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
