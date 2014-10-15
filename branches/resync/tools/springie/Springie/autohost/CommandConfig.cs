using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using Springie.Client;
using System.Xml.Serialization;

namespace Springie.AutoHostNamespace
{
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

    [Category("Command"), Description("How often can this command be executed (in seconds). 0 = no throttling, can execute at any time.")]
    public int Throttling
    {
      get { return throttling; }
      set { throttling = value; }
    }

    [XmlIgnore]
    public DateTime lastCall = DateTime.Now;



    TasSayEventArgs.Places[] listenTo = new TasSayEventArgs.Places[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal };


    [Category("Command"), Description("From which places can you use this command. Normal = PM to server, Battle = battle lobby, Game = from running game.")]
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
}
