using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComHelp : Command
  {
    public ComHelp(CommandHandler handler) : base(handler)
    {
      id = "help";
      config.Level = 0;
      config.ListenTo = CommandConfig.ListenChannelPmBattle;
      description = "lists all commands available specifically to you";
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      operationText = "display help";
      return true;
    }

    protected override void DoCommand()
    {
      // TODO: dodelat
      //int ulevel = GetUserLevel(e);
      //tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      //foreach (CommandConfig c in config.Commands) if (c.Level <= ulevel) tas.Say(TasClient.SayPlace.User, e.UserName, " !" + c.Name + " " + c.HelpText, false);
      //tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
    }
  }
}