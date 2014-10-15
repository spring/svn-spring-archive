using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComFix : Command
  {
    public ComFix(CommandHandler handler) : base(handler)
    {
      id = "fix";
      description = "fixes team numbers";
      config.Throttling = 2;
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      operationText = "fix player IDs";
      return true;
    }

    protected override void DoCommand()
    {
      Battle b = handler.TasClient.GetBattle();
      int cnt = 0;
      foreach (UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          handler.TasClient.ForceTeam(u.name, cnt);
          cnt++;
        }
      }
    }
  }
}