namespace Springie.autohost.commands
{
  public class ComSpec : ComAbstractTargetsPlayer
  {
    public ComSpec(CommandHandler handler) : base(handler)
    {
      id = "spec";
      description = "forces player to spectator";
      config.ListenTo = CommandConfig.ListenPmGameBattle;
      config.Level = 2;
      allowEmptyArgs = false;
      canTargetMultiple = false;

      operationText = string.Format("spec {0}", playerNames[0]);
    }


    protected override void DoCommand()
    {
      handler.TasClient.ForceSpectator(playerNames[0]);
    }
  }
}