using System;
using System.Collections.Generic;
using System.Reflection;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.autohost.commands
{
  public class CommandHandler
  {
    private readonly Dictionary<string, Command> commandsByName = new Dictionary<string, Command>();
    private readonly Dictionary<Type, Command> commandsByType = new Dictionary<Type, Command>();
    private Dictionary<string, CommandConfig> configs = new Dictionary<string, CommandConfig>();
    private AutoHost autoHost;
    private Spring spring;
    private TasClient tasClient;

    private const string ConfigFile = "commands.xml";


    /// <summary>
    /// Loads all existing commands in assembly into commandlist
    /// </summary>
    public CommandHandler()
    {
      foreach (Type type in Assembly.GetExecutingAssembly().GetTypes()) {
        if (type.IsClass && type.IsSubclassOf(typeof(Command))) {
          Command command = (Command)type.GetConstructor(new Type[] {typeof(CommandHandler)}).Invoke(new object[] {this});
          commandsByName.Add(command.Id, command);
          commandsByType.Add(type, command);
        }
      }
    }


    void LoadConfigs()
    {
     //TODO dodelat loading a saving 
    }



    public TasClient TasClient
    {
      get { return tasClient; }
      set { tasClient = value; }
    }

    public AutoHost AutoHost
    {
      get { return autoHost; }
      set { autoHost = value; }
    }

    public Spring Spring
    {
      get { return spring; }
      set { spring = value; }
    }

    /// <summary>
    /// Gets command
    /// </summary>
    /// <typeparam name="T">type of command to get</typeparam>
    /// <returns></returns>
    public T Get<T>() where T : Command
    {
      Command command;
      if (commandsByType.TryGetValue(typeof(T), out command)) return (T)command;
      return null;
    }


    public bool Execute<T>(params object[] arguments) where T : Command
    {
      return Execute<T>(null, arguments);
    }

    public bool Execute<T>(TasSayEventArgs eventArgs, params object[] arguments) where T : Command
    {
      return Get<T>().Execute(eventArgs, arguments);
    }


    
    /// <summary>
    /// Gets command
    /// </summary>
    /// <param name="id">text id of command</param>
    /// <returns></returns>
    public Command Get(string id)
    {
      Command command;
      if (commandsByName.TryGetValue(id, out command)) return command;
      else return null;
    }
  }
}