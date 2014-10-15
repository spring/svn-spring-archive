using Springie.SpringNamespace;

namespace Springie.autohost.commands
{
  public class ComTeam : ComAbstractTargetsPlayer
  {
    protected int targetNumber;

    public ComTeam(CommandHandler handler) : base(handler)
    {
      id = "team";
      description = "changes player team";
      config.Level = 2;
      playernameStartIndex = 1;
      allowEmptyArgs = false;
      canTargetMultiple = false;
    }

    public override bool Parse(Client.TasSayEventArgs eventArgs, object[] parameters)
    {
      if (base.Parse(eventArgs, parameters)) {
        if (!int.TryParse(parameters[0].ToString(), out targetNumber)) {
          Respond(eventArgs, "first parameter must be a number");
          return false;
        }
        if (targetNumber < 0 || targetNumber>= Spring.MaxAllies) {
          Respond(eventArgs, "id number must be between 0 and {1}", Spring.MaxAllies);
          return false;
        }

        operationText = string.Format("set {0} team to {1}", playerNames[0], targetNumber);

        return true;
      } else return false;
    }


    protected override void DoCommand()
    {
      handler.TasClient.ForceAlly(playerNames[0], targetNumber);
    }
  }
}