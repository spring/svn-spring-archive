using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComBalance : Command
  {
    private int allyCount;

    public ComBalance(CommandHandler handler) : base(handler)
    {
      id = "balance";
      description = "assigns people to <allycount> rank balanced alliances, e.g. !balance - makes 2 random but balanced alliances";
      paramDescription = "<allycount>";
      config.Throttling = 5;
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      if (parameters.Length > 0) {
        if (!int.TryParse(parameters[0].ToString(), out allyCount)) allyCount = 2;
      } else allyCount = 2;
      if (allyCount < 2) allyCount = 2;
      operationText = string.Format("balance to {0} teams", allyCount);
      return true;
    }

    protected override void DoCommand()
    {
      handler.Execute<ComFix>();
      handler.AutoHost.BalanceTeams(allyCount, false);
    }
  }
}