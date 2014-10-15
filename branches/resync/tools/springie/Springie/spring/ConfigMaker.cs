using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Threading;
using Springie.Client;

namespace Springie.SpringNamespace
{
  public class ConfigMaker
  {
    public static void Generate(string filename, Battle b, out List<Battle.GrPlayer> players) {
      Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture; 
      
      StringBuilder s = new StringBuilder();

      s.AppendLine("[GAME]");
      s.AppendLine("{");
      s.AppendFormat("  Mapname={0};\n", b.Map.Name);
      s.AppendFormat("  StartMetal={0};\n", b.Details.StartingMetal);
      s.AppendFormat("  StartEnergy={0};\n", b.Details.StartingEnergy);
      s.AppendFormat("  MaxUnits={0};\n", b.Details.MaxUnits);
      s.AppendFormat("  StartPosType={0};\n", (int)b.Details.StartPos);
      s.AppendFormat("  GameMode={0};\n", (int)b.Details.EndCondition);
      s.AppendFormat("  GameType={0};\n", b.Mod.ArchiveName);
      s.AppendFormat("  LimitDGun={0};\n", b.Details.LimitDgun);
      s.AppendFormat("  DiminishingMMs={0};\n", b.Details.DiminishingMM);
      s.AppendFormat("  GhostedBuildings={0};\n", b.Details.GhostedBuildings);
      s.AppendLine();
      s.AppendFormat("  HostIP={0};\n", "localhost");
      s.AppendFormat("  HostPort={0};\n", b.HostPort);
      s.AppendFormat("  MinSpeed={0};\n", 1);
      s.AppendFormat("  MaxSpeed={0};\n", 1);
      s.AppendLine();
      s.AppendFormat("  MyPlayerNum={0};\n", 0);

      //List<Battle.GrPlayer> players;
      List<Battle.GrTeam> teams;
      List<Battle.GrAlly> alliances;

      b.GroupData(out players, out teams, out alliances);

      s.AppendLine();
      s.AppendFormat("  NumPlayers={0};\n", players.Count);
      s.AppendFormat("  NumTeams={0};\n", teams.Count);
      s.AppendFormat("  NumAllyTeams={0};\n", alliances.Count);
      s.AppendLine();
      
      // PLAYERS
      for (int i = 0; i < players.Count ; ++i) {
        UserBattleStatus u = players[i].user;
        s.AppendFormat("  [PLAYER{0}]\n", i);
        s.AppendLine("  {");
        s.AppendFormat("     name={0};\n", u.name);
        s.AppendFormat("     Spectator={0};\n", u.IsSpectator ? 1 : 0);
        if (!u.IsSpectator) {
          s.AppendFormat("     team={0};\n", u.TeamNumber);
        }
        s.AppendLine("  }");
      }

      // TEAMS
      s.AppendLine();
      for (int i = 0 ; i < teams.Count; ++i) {
        s.AppendFormat("  [TEAM{0}]\n", i);
        s.AppendLine("  {");
        s.AppendFormat("     TeamLeader={0};\n", teams[i].leader);
        UserBattleStatus u = players[teams[i].leader].user;
        s.AppendFormat("     AllyTeam={0};\n", u.AllyNumber);
        s.AppendFormat("     RGBColor={0:F5} {1:F5} {2:F5};\n", (u.TeamColor & 255) / 255.0, ((u.TeamColor >> 8) & 255) / 255.0, ((u.TeamColor >> 16) & 255) / 255.0);
        s.AppendFormat("     Side={0};\n", b.Mod.Sides[u.Side]);
        s.AppendFormat("     Handicap={0};\n", 0);
        s.AppendLine("  }");
      }


      // ALLYS
      s.AppendLine();
      for (int i = 0; i < alliances.Count; ++i) {
        s.AppendFormat("[ALLYTEAM{0}]\n", i);
        s.AppendLine("{");
        s.AppendFormat("     NumAllies={0};\n", 0);
        double left,top,right,bottom;
        alliances[i].rect.ToFractions(out left, out top, out right, out bottom);
        s.AppendFormat("     StartRectLeft={0};\n", left);
        s.AppendFormat("     StartRectTop={0};\n", top);
        s.AppendFormat("     StartRectRight={0};\n", right);
        s.AppendFormat("     StartRectBottom={0};\n", bottom);
        s.AppendLine("}");
      }

      s.AppendLine();
      s.AppendFormat("  NumRestrictions={0};\n", b.DisabledUnits.Count);
      s.AppendLine("  [RESTRICT]");
      s.AppendLine("  {");
      for (int i = 0; i < b.DisabledUnits.Count ; ++i) {
        s.AppendFormat("    Unit{0}={1};\n", i, b.DisabledUnits[i]);
        s.AppendFormat("    Limit{0}=0;\n", i);
      }
      s.AppendLine("  }");
      s.AppendLine("}");

      StreamWriter f = File.CreateText(filename);
      f.Write(s.ToString());
      f.Flush();
      f.Close();
      

    }
  }
}
