using System.Collections.Generic;
using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComStart : Command
  {
    public ComStart(CommandHandler handler) : base(handler)
    {
      id = "start";
      description = "starts game";
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      operationText = "start game";
      return true;
    }

    protected override void DoCommand()
    {
      string usname;
      if (!handler.AutoHost.AllReadyAndSynced(out usname)) {
        SayBattle("cannot start, " + usname + " not ready and synced");
        return;
      }

      if (!handler.AutoHost.AllUniqueTeams(out usname)) {
        SayBattle("cannot start, " + usname + " is sharing teams. Use !forcestart to override");
        return;
      }

      int allyno;
      if (!handler.AutoHost.BalancedTeams(out allyno)) {
        SayBattle("cannot start, alliance " + (allyno + 1) + " not fair. Use !forcestart to override");
        return;
      }
      SayBattle("please wait, game is about to start");

      //StopVote(); // TODO stop vote replacement

      Battle b = handler.TasClient.GetBattle();
      if (b != null) {
        string curMap = b.Map.ArchiveName.ToLower();

        Dictionary<int, BattleRect> nd = new Dictionary<int, BattleRect>();
        foreach (KeyValuePair<int, BattleRect> v in b.Rectangles) nd.Add(v.Key, v.Value);
        
        // TODO map boxes in independt class tracking changes 
        //if (MapBoxes.ContainsKey(curMap)) MapBoxes[curMap] = nd;
        //else MapBoxes.Add(curMap, nd);
        //SaveConfig();
      }
      handler.TasClient.ChangeLock(true);
      handler.TasClient.StartGame();
    }
  }
}