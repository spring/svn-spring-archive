using System;
using System.ComponentModel;
using System.Xml.Serialization;
using Springie.Client;

namespace Springie.autohost
{
  public class CommandConfig
  {
    private string helpText;

    [XmlIgnore]
    public DateTime lastCall = DateTime.Now;

    private int level;


    private TasSayEventArgs.Places[] listenTo = new TasSayEventArgs.Places[] {TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal};
    private string name;
    private int throttling = 0;


    public CommandConfig() {}


    public CommandConfig(string name, int level, string helpText, int throttling, TasSayEventArgs.Places[] listenTo) : this(name, level, helpText, throttling)
    {
      this.listenTo = listenTo;
    }

    public CommandConfig(string name, int level, string helpText, int throttling) : this(name, level, helpText)
    {
      this.throttling = throttling;
    }

    public CommandConfig(string name, int level, string helpText)
    {
      this.name = name;
      this.level = level;
      this.helpText = helpText;
    }

    [ReadOnly(true)]
    [Category("Command")]
    public string Name
    {
      get { return name; }
      set { name = value; }
    }

    [Category("Command")]
    [Description("Rights level. If user's rights level is higher or equal to rights level of command - user has rights to use this command.")]
    public int Level
    {
      get { return level; }
      set { level = value; }
    }

    [Category("Texts")]
    [Description("Help text to be displayed in !help listings.")]
    public string HelpText
    {
      get { return helpText; }
      set { helpText = value; }
    }

    [Category("Command")]
    [Description("How often can this command be executed (in seconds). 0 = no throttling, can execute at any time.")]
    public int Throttling
    {
      get { return throttling; }
      set { throttling = value; }
    }

    [Category("Command")]
    [Description("From which places can you use this command. Normal = PM to server, Battle = battle lobby, Game = from running game.")]
    public TasSayEventArgs.Places[] ListenTo
    {
      get { return listenTo; }
      set { listenTo = value; }
    }
  } ;
}