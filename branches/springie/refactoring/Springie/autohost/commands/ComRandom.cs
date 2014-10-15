using System;
using System.Collections.Generic;
using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComRandom : Command
  {
    private int allyCount;

    public ComRandom(CommandHandler handler) : base(handler)
    {
      id = "random";
      description = "assigns people to <allycount> random alliances, e.g. !random - makes 2 random alliances";
      paramDescription = "<allycount>";
      config.Throttling = 5;
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      if (parameters.Length > 0) {
        if (!int.TryParse(parameters[0].ToString(), out allyCount)) allyCount = 2;
      } else allyCount = 2;
      if (allyCount < 2) allyCount = 2;

      operationText = string.Format("assign players to {0} random teams", allyCount);
      return true;
    }

    protected override void DoCommand()
    {
      handler.Execute<ComFix>();
      Battle b = handler.TasClient.GetBattle();

      List<UserBattleStatus> actUsers = new List<UserBattleStatus>();
      foreach (UserBattleStatus u in b.Users) if (!u.IsSpectator) actUsers.Add(u);

      Random r = new Random();

      int al = 0;
      while (actUsers.Count > 0) {
        int index = r.Next(actUsers.Count);
        handler.TasClient.ForceAlly(actUsers[index].name, al);
        actUsers.RemoveAt(index);
        al++;
        al = al % allyCount;
      }
    }
  }
}