namespace Springie.autohost.commands
{
  public class ComKick : ComAbstractTargetsPlayer
  {
    public ComKick(CommandHandler handler) : base(handler)
    {
      id = "kick";
      description = "kicks a player from game/battle room";
      config.ListenTo = CommandConfig.ListenPmGameBattle;
      config.Level = 3;
      allowEmptyArgs = false;
      canTargetMultiple = false;
    }

    public override bool Parse(Client.TasSayEventArgs eventArgs, object[] parameters)
    {
      if (base.Parse(eventArgs, parameters)) {
        operationText = "kick " + playerNames[0];
        return true;
      } else return false;
    }
    
    protected override void DoCommand()
    {
      if (handler.Spring.IsRunning) handler.Spring.Kick(playerNames[0]);
      handler.TasClient.Kick(playerNames[0]);
   }
  }
}