using System;
using Springie.Client;

namespace Springie.autohost.commands
{
  public abstract class Command
  {
    protected string description;
    protected readonly CommandHandler handler;
    protected string id;
    protected string paramDescription;

    protected CommandConfig config = new CommandConfig();

    protected bool enabled;
    protected DateTime lastExecution = DateTime.Now;
    protected string operationText;

    internal Command(CommandHandler handler)
    {
      this.handler = handler;
    }

    public bool Enabled
    {
      get { return enabled; }
      set { enabled = value; }
    }

    public CommandConfig Config
    {
      get { return config; }
      set { config = value; }
    }

    public string Description
    {
      get { return description; }
    }

    public string Id
    {
      get { return id; }
    }

    public string ParamDescription
    {
      get { return paramDescription; }
    }


    public bool Parse(params object[] parameters)
    {
      return Parse(TasSayEventArgs.Default, parameters);
    }

    public abstract bool Parse(TasSayEventArgs eventArgs, params object[] parameters);

    public bool Execute(params object[] parameters)
    {
      return Execute(TasSayEventArgs.Default, parameters);
    }

    public virtual bool Execute(TasSayEventArgs eventArgs, params object[] parameters)
    {
      if (Enabled) {
        if (Parse(eventArgs, parameters)) {
          int diff = (int)(DateTime.Now.Subtract(lastExecution).TotalSeconds - Config.Throttling);
          if (diff >= 0) {
            lastExecution = DateTime.Now;
            SayBattle("does {0}", operationText);
            DoCommand();
            return true;
          } else {
            Respond(eventArgs, "wait {0} seconds", -diff);
            return false;
          }
        } else {
          Respond(eventArgs, "usage: !{0} {1}", id, paramDescription);
          return false;
        }
      } else return false;
    }

    protected void Respond(TasSayEventArgs eventArgs, string text, params object[] args)
    {
      AutoHost.Respond(handler.TasClient, handler.Spring, eventArgs, string.Format(text, args));
    }


    /// <summary>
    /// Says text both in battle room and in spring
    /// </summary>
    /// <param name="text"></param>
    /// <param name="args"></param>
    protected void SayBattle(string text, params object[] args)
    {
      SayBattle(true, text, args);
    }

    protected void SayBattle(bool inGame, string text, params object[] args)
    {
      AutoHost.SayBattle(handler.TasClient, handler.Spring, string.Format(text, args), inGame);
    }


    protected abstract void DoCommand();
  }
}