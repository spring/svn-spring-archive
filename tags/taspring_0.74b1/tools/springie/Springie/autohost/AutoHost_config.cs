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
    class ModConverter : StringConverter
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

    class MapConverter : StringConverter
    {
      public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
      {
        return true;
      }

      public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
      {
        return new StandardValuesCollection(Program.main.Spring.UnitSync.MapList);
      }
    };

   
    string password = "*";

    [Category("Basic options")]
    [Description("Game password")]
    [DefaultValue("*")]
    public string Password
    {
      get { return password; }
      set { password = value; }
    }

    int hostingPort = 8452;

    [Category("Basic options")]
    [Description("Hosting port number")]
    [DefaultValue(8452)]
    public int HostingPort
    {
      get { return hostingPort; }
      set { hostingPort = value; }
    }
    int maxPlayers = 10;

    [Category("Basic options")]
    [Description("Maximum number of players")]
    [DefaultValue(10)]
    public int MaxPlayers
    {
      get { return maxPlayers; }
      set { maxPlayers = value; }
    }
    int minRank = 0;

    [Category("Basic options")]
    [Description("Minimum rank to be allowed to join")]
    [DefaultValue(0)]
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


    public List<TasClient.BattleRect> DefaultRectangles = new List<TasClient.BattleRect>();

    string gameTitle = "AutoHost (%1)";

    [Category("Texts")]
    [Description("Game title - appears in open game list, %1 = springie version")]
    public string GameTitle
    {
      get { return gameTitle; }
      set { gameTitle = value; }
    }

    public TasClient.BattleDetails BattleDetails = new TasClient.BattleDetails();


    int defaulRightsLevel = 1;

    [Category("Rights")]
    [Description("Default rights level for non-privileged users")]
    [DefaultValue(1)]
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
    [DefaultValue("Hi %1 (rights:%2), welcome to %3, automated host. For help say !help")]
    public string Welcome
    {
      get { return welcome; }
      set { welcome = value; }
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

      AddMissing(new CommandConfig("balance", 1, "<allycount> - assigns people to <allycount> rank balanced alliances, e.g. !balance - makes 2 random but balanced alliances", 10));

      AddMissing(new CommandConfig("start", 1, " - starts game", 5));

      AddMissing(new CommandConfig("ring", 1, "[<filters>..] - rings all unready or specific player(s), e.g. !ring - rings unready, !ring icho - rings Licho", 5, new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game }));


      AddMissing(new CommandConfig("listmaps", 1, "[<filters>..] - lists maps on server, e.g. !listmaps altor div", 20));
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

      AddMissing(new CommandConfig("fix", 1, " - fixes teamnumbers", 10));

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
      DefaultRectangles.Add(new TasClient.BattleRect(0.0, 0.0, 1.0, 0.15));
      DefaultRectangles.Add(new TasClient.BattleRect(0.0, 0.85, 1.0, 1.0));
      AddMissingCommands();
    }

    public AutoHostConfig()
    {
    }
  }


  public class CommandConfig
  {

    string name;

    [ReadOnly(true), Category("Command")]
    public string Name
    {
      get { return name; }
      set { name = value; }
    }

    int level;

    [Category("Command"), Description("Rights level. If user's rights level is higher or equal to rights level of command - user has rights to use this command.")]
    public int Level
    {
      get { return level; }
      set { level = value; }
    }
    string helpText;

    [Category("Texts"), Description("Help text to be displayed in !help listings.")]
    public string HelpText
    {
      get { return helpText; }
      set { helpText = value; }
    }

    int throttling = 0;

    [Category("Command"), Description("How often can this command be executed (in seconds). 0 = no throttling, can execute at any time."), DefaultValue(0)]
    public int Throttling
    {
      get { return throttling; }
      set { throttling = value; }
    }

    [XmlIgnore]
    public DateTime lastCall = DateTime.Now;



    TasSayEventArgs.Places[] listenTo = new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal };


    [Category("Command"), Description("From which places can you use this command. Normal = PM to server, Battle = battle lobby, Game = from running game."), DefaultValue(0)]
    public TasSayEventArgs.Places[] ListenTo
    {
      get { return listenTo; }
      set { listenTo = value; }
    }
    public CommandConfig() { }


    public CommandConfig(string name, int level, string helpText, int throttling, TasSayEventArgs.Places[] listenTo)
      : this(name, level, helpText, throttling)
    {
      this.listenTo = listenTo;
    }

    public CommandConfig(string name, int level, string helpText, int throttling)
      : this(name, level, helpText)
    {
      this.throttling = throttling;
    }

    public CommandConfig(string name, int level, string helpText)
    {
      this.name = name;
      this.level = level;
      this.helpText = helpText;
    }
  };


  public class PrivilegedUser
  {
    string name;
    [Category("User"), Description("Nickname used in spring lobby")]
    public string Name
    {
      get { return name; }
      set { name = value; }
    }
    int level;

    [Category("User"), Description("Rights level. If rights level is higher or equal to rights level of command - user has rights to use that command.")]
    public int Level
    {
      get { return level; }
      set { level = value; }
    }
    public PrivilegedUser()
    {
    }
    public PrivilegedUser(string name, int level)
    {
      this.name = name;
      this.level = level;
    }
  };


}
