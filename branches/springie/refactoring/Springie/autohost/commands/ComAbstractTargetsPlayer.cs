using Springie.Client;

namespace Springie.autohost.commands
{
  public abstract class ComAbstractTargetsPlayer : Command
  {
    protected string[] playerNames;
    protected bool allowEmptyArgs;
    protected bool canTargetMultiple;
    protected int playernameStartIndex;

    protected ComAbstractTargetsPlayer(CommandHandler handler) : base(handler)
    {
      paramDescription = allowEmptyArgs ? "[<playername..>]" : "<playername..>";
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      if (parameters.Length <= playernameStartIndex) {
        if (allowEmptyArgs) {
          playerNames = new string[0];
          return true;
        }
        Respond(eventArgs, "You must specify player name");
        return false;
      }

      string[] filterWords = new string[parameters.Length - playernameStartIndex];
      for (int i = 0; i < parameters.Length; i++) filterWords[i] = parameters[i + playernameStartIndex].ToString();
      int[] indexes;
      handler.AutoHost.FilterUsers(filterWords, out playerNames, out indexes);

      if (playerNames.Length == 0) {
        Respond(eventArgs, "Cannot find such player");
        return false;
      }

      foreach (string s in playerNames) {
        if (s == handler.TasClient.UserName) {
          Respond(eventArgs, "Cannot target myself");
          return false;
        }
      }


      if (playerNames.Length > 1 && !canTargetMultiple) {
        Respond(eventArgs, "This matches more than one player");
        return false;
      }
      
      return true;
    }
  }
}