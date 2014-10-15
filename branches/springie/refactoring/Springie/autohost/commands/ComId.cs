using Springie.SpringNamespace;

namespace Springie.autohost.commands
{
  public class ComId : ComAbstractTargetsPlayer
  {
    protected int targetNumber;

    public ComId(CommandHandler handler) : base(handler)
    {
      id = "id";
      description = "changes player id";
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
        if (targetNumber < 0 || targetNumber>= Spring.MaxTeams) {
          Respond(eventArgs, "id number must be between 0 and {1}", Spring.MaxTeams);
          return false;
        }

        operationText = string.Format("set {0} id to {1}", playerNames[0], targetNumber);

        return true;
      } else return false;
    }


    protected override void DoCommand()
    {
      handler.TasClient.ForceTeam(playerNames[0], targetNumber);
    }
  }
}