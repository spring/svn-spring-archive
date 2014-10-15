using System.Collections.Generic;
using Springie.Client;

namespace Springie.autohost.commands
{
  public class ComRing : ComAbstractTargetsPlayer
  {
    public ComRing(CommandHandler handler) : base(handler)
    {
      id = "ring";
      description = "rings all unready or specific player(s)";
      config.ListenTo = CommandConfig.ListenGameBattle;

      allowEmptyArgs = true;
      canTargetMultiple = true;
    }

    public override bool Parse(TasSayEventArgs eventArgs, object[] parameters)
    {
      if (base.Parse(eventArgs, parameters)) {
        if (parameters.Length == 0) operationText = "ring all unready";
        else {
          string rang = "";
          foreach (string s in playerNames) {
            rang += s + ", ";
          }
          operationText = "ring " + rang;
        }
        return true;
      } else return false;
    }


    protected override void DoCommand()
    {
      List<string> toRing = new List<string>();
      bool ringAllUnready = (playerNames == null || playerNames.Length == 0); // ringing unready if empty args

      if (ringAllUnready) {
        foreach (UserBattleStatus p in handler.TasClient.GetBattle().Users) {
          if (p.IsSpectator) continue;
          if (!p.IsReady) toRing.Add(p.name);
        }
      } else toRing = new List<string>(playerNames);

      foreach (string s in toRing) {
        handler.TasClient.Ring(s);
      }
    }
  }
}