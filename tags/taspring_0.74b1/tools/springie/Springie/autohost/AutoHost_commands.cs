using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.AutoHostNamespace
{
  public partial class AutoHost
  {
    internal static int Filter(string[] source, string[] words, out string[] resultVals, out int[] resultIndexes)
    {

      int i;

      // search by direct index
      if (words.Length == 1) {
        if (int.TryParse(words[0], out i)) {
          if (i >= 0 && i < source.Length) {
            resultVals = new string[] { source[i] };
            resultIndexes = new int[] { i };
            return 1;
          }
        }

        // search by direct word
        string glued = Utils.Glue(words);
        for (i = 0; i < source.Length; ++i) {
          if (source[i] == glued) {
            resultVals = new string[] { source[i] };
            resultIndexes = new int[] { i };
            return 1;
          }
        }
      }

      List<string> res = new List<string>();
      List<int> resi = new List<int>();

      for (i = 0; i < words.Length; ++i) words[i] = words[i].ToLower();
      for (i = 0; i < source.Length; ++i) {
        string item = source[i];
        bool isok = true;
        for (int j = 0; j < words.Length; ++j) {
          if (!item.ToLower().Contains(words[j])) {
            isok = false;
            break;
          }
        }
        if (isok) {
          res.Add(item);
          resi.Add(i);
        }
      }

      resultVals = res.ToArray();
      resultIndexes = resi.ToArray();

      return res.Count;
    }



    internal static int FilterMaps(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
    {
      return Filter(spring.UnitSync.MapList.ToArray(), words, out vals, out indexes);

    }

    private int FilterMaps(string[] words, out string[] vals, out int[] indexes)
    {
      return FilterMaps(words, tas, spring, out vals, out indexes);
    }


    internal static int FilterUsers(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
    {
      TasClient.Battle b = tas.GetBattle();
      string[] temp = new string[b.Users.Count];
      int i = 0;
      foreach (TasClient.UserBattleStatus u in b.Users) {
        temp[i++] = u.name;
      }
      return Filter(temp, words, out vals, out indexes);
    }

    private int FilterUsers(string[] words, out string[] vals, out int[] indexes)
    {
      return FilterUsers(words, tas, spring, out vals, out indexes);
    }


    internal static int FilterMods(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
    {
      string[] temp = new string[spring.UnitSync.ModList.Keys.Count];
      int cnt = 0;
      foreach (string s in spring.UnitSync.ModList.Keys) { temp[cnt++] = s; }

      return Filter(temp, words, out vals, out indexes);
    }

    private int FilterMods(string[] words, out string[] vals, out int[] indexes)
    {
      return FilterMods(words, tas, spring, out vals, out indexes);
    }

    private void ComListMaps(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;
      if (FilterMaps(words, out vals, out indexes) > 0) {
        for (int i = 0; i < vals.Length; ++i) {
          tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
        }
      } else Respond(e, "no such map found");
    }

    private void ComListMods(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;
      if (FilterMods(words, out vals, out indexes) > 0) {
        for (int i = 0; i < vals.Length; ++i) {
          tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
        }
      } else Respond(e, "no such mod found");
    }

    
    
    private void ComHelp(TasSayEventArgs e, string[] words)
    {
      int ulevel = GetUserLevel(e);
      foreach (CommandConfig c in config.Commands) {
        if (c.Level <= ulevel) {
          tas.Say(TasClient.SayPlace.User, e.UserName, " !" + c.Name + " " + c.HelpText, false);
        }
      }
    }


    private void ComHelpAll(TasSayEventArgs e, string[] words)
    {
      List<CommandConfig> copy = new List<CommandConfig>(config.Commands);
      copy.Sort(delegate(CommandConfig a, CommandConfig b) { if (a.Level != b.Level) return a.Level.CompareTo(b.Level); else return a.Name.CompareTo(b.Name);});

      foreach (CommandConfig c in copy) {
       tas.Say(TasClient.SayPlace.User, e.UserName, "Level " + c.Level + " --> !" + c.Name + " " + c.HelpText, false);
      }
   }

    
    private void ComAdmins(TasSayEventArgs e, string[] words)
    {
      foreach (PrivilegedUser u in config.PrivilegedUsers) {
        tas.Say(TasClient.SayPlace.User, e.UserName, " " + u.Name + " (level " + u.Level.ToString() + ")", false);
      }
    }


    private void ComMap(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        Respond(e, "You must specify a map name");
        return;
      }
      string[] vals;
      int[] indexes;
      if (FilterMaps(words, out vals, out indexes) > 0) {
        tas.Say(TasClient.SayPlace.Battle, "", "changing map to " + vals[0], true);
        tas.ChangeMap(vals[0]);

      } else Respond(e, "Cannot find such map.");

    }


    private bool AllReadyAndSynced(out string usname)
    {
      usname = "";
      foreach (TasClient.UserBattleStatus p in tas.GetBattle().Users) {
        if (p.IsSpectator) continue;
        if (p.SyncStatus != TasClient.SyncStatuses.Synced || !p.IsReady) {
          usname = p.name;
          return false;
        }
      }
      return true;
    }

    private bool AllUniqueTeams(out string username)
    {
      List<int> teams = new List<int>();
      username = "";
      foreach (TasClient.UserBattleStatus p in tas.GetBattle().Users) {
        if (p.IsSpectator) continue;
        if (teams.Contains(p.TeamNumber)) {
          username = p.name;
          return false;
        } else teams.Add(p.TeamNumber);
      }
      return true;
    }

    private bool BalancedTeams(out int allyno)
    {
      int[] counts = new int[16];
      allyno = 0;

      foreach (TasClient.UserBattleStatus p in tas.GetBattle().Users) {
        if (p.IsSpectator) continue;
        counts[p.AllyNumber]++;
      }

      int tsize = 0;
      for (int i = 0; i < counts.Length; ++i) {
        if (counts[i] != 0) {
          if (tsize == 0) tsize = counts[i];
          else if (tsize != counts[i]) {
            allyno = i;
            return false;
          }
        }
      }
      return true;

    }

    private void ComStart(TasSayEventArgs e, string[] words)
    {
      string usname;
      if (!AllReadyAndSynced(out usname)) {
        tas.Say(TasClient.SayPlace.Battle, "", "cannot start, " + usname + " not ready and synced", true);
        return;
      }

      if (!AllUniqueTeams(out usname)) {
        tas.Say(TasClient.SayPlace.Battle, "", "cannot start, " + usname + " is sharing teams. Use !forcestart to override", true);
        return;
      }

      int allyno;
      if (!BalancedTeams(out allyno)) {
        tas.Say(TasClient.SayPlace.Battle, "", "cannot start, alliance " + (allyno + 1).ToString() + " not fair. Use !forcestart to override", true);
        return;
      }
      tas.Say(TasClient.SayPlace.Battle, "", "please wait, game is about to start", true);
      StopVote();
      tas.ChangeLock(true);
      spring.StartGame(tas.GetBattle());
    }

    public void ComForceStart(TasSayEventArgs e, string[] words)
    {
      string usname;
      if (!AllReadyAndSynced(out usname)) {
        tas.Say(TasClient.SayPlace.Battle, "", "cannot start, " + usname + " not ready and synced", true);
        return;
      }
      tas.Say(TasClient.SayPlace.Battle, "", "please wait, game is about to start", true);

      StopVote();
      tas.ChangeLock(true);
      spring.StartGame(tas.GetBattle());
    }

    public void ComForce(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        spring.SayGame("forcing game start by " + e.UserName);
        tas.Say(TasClient.SayPlace.Battle, "", "forcing game start in game", true);
        spring.ForceStart();
      } else {
        Respond(e, "cannot force, game not started");
      }
    }

    public void ComSplit(TasSayEventArgs e, string[] words)
    {
      if (words.Length != 2) {
        Respond(e, "This command needs 2 parameters");
        return;
      }
      if (words[0] != "h" && words[0] != "v") {
        Respond(e, "first parameter must be 'h' or 'v'");
      } else {
        int perc;
        int.TryParse(words[1], out perc);
        if (perc < 0 || perc > 50) Respond(e, "second parameter must be between 0 and 50");
        else {
          if (words[0] == "h") {
            tas.AddBattleRectangle(0, new TasClient.BattleRect(0, 0, 1.0, perc / 100.0));
            tas.AddBattleRectangle(1, new TasClient.BattleRect(0, 1.0 - perc / 100.0, 1.0, 1.0));
          } else {
            tas.AddBattleRectangle(0, new TasClient.BattleRect(0, 0, perc / 100.0, 1.0));
            tas.AddBattleRectangle(1, new TasClient.BattleRect(1.0 - perc / 100.0, 0, 1.0, 1.0));
          }
          tas.RemoveBattleRectangle(2);
          tas.RemoveBattleRectangle(3);
        }
      }
    }


    public void ComCorners(TasSayEventArgs e, string[] words)
    {
      if (words.Length != 2) {
        Respond(e, "This command needs 2 parameters");
        return;
      }
      if (words[0] != "a" && words[0] != "b") {
        Respond(e, "first parameter must be 'a' or 'b'");
      } else {
        int perc;
        int.TryParse(words[1], out perc);
        if (perc < 0 || perc > 50) Respond(e, "second parameter must be between 0 and 50");
        else {
          double p = perc / 100.0;
          if (words[0] == "a") {
            tas.AddBattleRectangle(0, new TasClient.BattleRect(0, 0, p, p));
            tas.AddBattleRectangle(1, new TasClient.BattleRect(1 - p, 1 - p, 1, 1));
            tas.AddBattleRectangle(2, new TasClient.BattleRect(1 - p, 0, 1, p));
            tas.AddBattleRectangle(3, new TasClient.BattleRect(0, 1 - p, p, 1));
          } else {
            tas.AddBattleRectangle(0, new TasClient.BattleRect(1 - p, 0, 1, p));
            tas.AddBattleRectangle(1, new TasClient.BattleRect(0, 1 - p, p, 1));
            tas.AddBattleRectangle(2, new TasClient.BattleRect(0, 0, p, p));
            tas.AddBattleRectangle(3, new TasClient.BattleRect(1 - p, 1 - p, 1, 1));
          }
        }
      }
    }


    void ComRing(TasSayEventArgs e, string[] words)
    {
      List<string> usrlist = new List<string>();

      if (words.Length == 0) { // ringing idle
        foreach (TasClient.UserBattleStatus p in tas.GetBattle().Users) {
          if (p.IsSpectator) continue;
          if (!p.IsReady) usrlist.Add(p.name);
        }
      } else {
        string[] vals;
        int[] indexes;
        FilterUsers(words, out vals, out indexes);
        usrlist = new List<string>(vals);
      }

      foreach (string s in usrlist) {
        tas.Ring(s);
        tas.Say(TasClient.SayPlace.Battle, "", "ringing " + s, true);
      }
    }


    void ComKick(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        Respond(e, "You must specify player name");
        return;
      }

      int[] indexes;
      string[] usrlist;
      if (FilterUsers(words, out usrlist, out indexes) == 0) {
        Respond(e, "Cannot find such player");
        return;
      }

      if (spring.IsRunning) spring.SayGame(".kick " + usrlist[0]);
      tas.Say(TasClient.SayPlace.Battle, "", "kicking " + usrlist[0], true);
      tas.Kick(usrlist[0]);
    }

    public void ComExit(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        tas.Say(TasClient.SayPlace.Battle, "", "exiting game", true);
      } else {
        Respond(e, "cannot exit, not in game");
      }
      spring.ExitGame();
    }

    public void ComFix(TasSayEventArgs e, string[] words)
    {
      TasClient.Battle b = tas.GetBattle();
      int cnt = 0;
      foreach (TasClient.UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          tas.ForceTeam(u.name, cnt);
          cnt++;
        }
      }
      tas.Say(TasClient.SayPlace.Battle, "", "team numbers fixed", true);
    }

    public void ComRehost(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0 ) {
        Start(null, null);
      } else {
        string[] mods;
        int[] indexes;
        if (FilterMods(words, out mods, out indexes) == 0) {
          Respond(e, "cannot find such mod");
        } else {
          Start(mods[0], null);
        }
      }
    }

    public void ComRandom(TasSayEventArgs e, string[] words)
    {
      ComFix(e, words);
      TasClient.Battle b = tas.GetBattle();

      List<TasClient.UserBattleStatus> actUsers = new List<TasClient.UserBattleStatus>();
      foreach (TasClient.UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) actUsers.Add(u);
      }

      int teamCount = 0;
      if (words.Length > 0) int.TryParse(words[0], out teamCount); else teamCount = 2;
      if (teamCount < 2) teamCount = 2;
      if (teamCount > actUsers.Count) teamCount = 2;
      Random r = new Random();

      int al = 0;
      while (actUsers.Count > 0) {
        int index = r.Next(actUsers.Count);
        tas.ForceAlly(actUsers[index].name, al);
        actUsers.RemoveAt(index);
        al++;
        al = al % teamCount;
      }
      tas.Say(TasClient.SayPlace.Battle, "", "players assigned to " + teamCount + " random teams", true);
    }



    // user and rank info
    private struct UsRank
    {
      public int id;
      public int rank;
      public UsRank(int id, int rank)
      {
        this.id = id;
        this.rank = rank;
      }
    }

    public void ComBalance(TasSayEventArgs e, string[] words)
    {
      List<TasClient.UserBattleStatus> actUsers = new List<TasClient.UserBattleStatus>();
      List<UsRank> ranker = new List<UsRank>();
      TasClient.Battle b = tas.GetBattle();

      foreach (TasClient.UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          actUsers.Add(u);
          TasClient.User p;
          if (tas.GetExistingUser(u.name, out p)) ranker.Add(new UsRank(ranker.Count, p.rank)); else ranker.Add(new UsRank(ranker.Count, 0)); // cannot find user, assume rank 0
        }
      }

      ComFix(e, words);

      Random rand = new Random();

      List<UsRank> tempList = new List<UsRank>(ranker);
      ranker.Clear();
      while (tempList.Count > 0) {
        // find max rank value
        int maxval = int.MinValue;
        foreach (UsRank u in tempList) {
          if (u.rank > maxval) {
            maxval = u.rank;
          }
        }

        List<UsRank> l2 = new List<UsRank>(); // pick pieces with max rank to l2
        int j = 0;
        while (j < tempList.Count) {
          if (tempList[j].rank == maxval) {
            l2.Add(tempList[j]);
            tempList.RemoveAt(j);
            j = 0;
          }
          j++;
        }

        while (l2.Count > 0) { // randomly add pieces from l2 to ranker
          int ind = rand.Next(l2.Count);
          ranker.Add(l2[ind]);
          l2.RemoveAt(ind);
        }
      }

      int teamCount = 2;
      if (words.Length > 0) int.TryParse(words[0], out teamCount); else teamCount = 2;
      if (teamCount < 2 || teamCount > ranker.Count) teamCount = 2;

      List<UsRank>[] teamUsers = new List<UsRank>[teamCount];
      for (int i = 0; i < teamUsers.Length; ++i) teamUsers[i] = new List<UsRank>();
      int[] teamSums = new int[teamCount];

      int cnt = 0;
      while (ranker.Count > 0) {

        int minsum = int.MaxValue;
        int minid = 0;
        for (int i = 0; i < teamCount; ++i) {
          List<UsRank> l = teamUsers[i];
          // pick only current "row" and find the one with least sum
          if (l.Count == cnt / teamCount) {
            if (teamSums[i] < minsum) {
              minid = i;
              minsum = teamSums[i];
            }
          }
        }

        teamUsers[minid].Add(ranker[0]);
        teamSums[minid] += ranker[0].rank;
        ranker.RemoveAt(0);

        cnt++;
      }


      // alliances for allinace permutations
      List<int> allys = new List<int>();
      for (int i = 0; i < teamCount; ++i) allys.Add(i);

      for (int i = 0; i < teamCount; ++i) {
        // permute one alliance
        int rdindex = rand.Next(allys.Count);
        int allynum = allys[rdindex];
        allys.RemoveAt(rdindex);

        foreach (UsRank u in teamUsers[i]) {
          tas.ForceAlly(actUsers[u.id].name, allynum);
        }
      }

      string t = string.Format("{0} players balanced to {1} teams (ranks ", actUsers.Count, teamCount);
      for (int i = 0; i < teamSums.Length; ++i) {
        if (i > 0) t += ":";
        t += teamSums[i].ToString();
      }
      t += ")";

      tas.Say(TasClient.SayPlace.Battle, "", t, true);
    }


    public void ComSetLevel(TasSayEventArgs e, string[] words)
    {
      if (words.Length != 2) {
        Respond(e, "This command needs 2 parameters");
        return;
      }
      int lvl;
      int.TryParse(words[0], out lvl);
      config.SetPrivilegedUser(words[1], lvl);
      SaveConfig();
      Respond(e, words[1] + " has rights level " + lvl.ToString());
    }


    public void ComSay(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        Respond(e, "This command needs 1 parameter (say text)");
        return;
      }
      if (!spring.IsRunning) {
        Respond(e, "Game is not running");
        return;
      }
      if (e.Place == TasSayEventArgs.Places.Game) {
        tas.Say(TasClient.SayPlace.Battle, "", "[" + e.UserName + "]" + Utils.Glue(words), false);
      } else spring.SayGame("[" + e.UserName + "]" + Utils.Glue(words));
    }

    public void ComDlMap(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        Respond(e, "This command needs 1 parameter (map name)");
        return;
      }
      string res = mapLinker.GetResults(Utils.Glue(words));
      string id = "";
      int iid = -1;

      if (int.TryParse(res, out iid)) { // check if it's UF map id
        id = iid.ToString();
      } else {
        try {
          id = Regex.Match(res, "dlid=([0-9]*)").Groups[1].Value;
        } catch { }
      }

      if (id != "") {
        Respond(e, "Map download is being prepared");
        mapDownloader.DownloadMap(id);
      } else {
        Respond(e, "I cannot find such map");
      }
    }

    
    public void ComTeam(TasSayEventArgs e, string[] words) {
      if (words.Length < 2) {
        Respond(e, "this command needs 2 parameters (team number and player name)");
        return;
      }
      int teamno = 0;
      if (!int.TryParse(words[0], out teamno) || --teamno < 0 || teamno >= Spring.MaxTeams) {
        Respond(e, "invalid team number");
        return;
      }
      string[] usrs;
      int[] idx;
      if (FilterUsers(Utils.ShiftArray(words,-1), out usrs, out idx) == 0) {
        Respond(e, "no such player found");
      } else {
        tas.Say(TasClient.SayPlace.Battle, "", "Forcing " + usrs[0] + " to team " + (teamno+1), true);
        tas.ForceTeam(usrs[0], teamno);
      }
    }


    public void ComAlly(TasSayEventArgs e, string[] words)
    {
      if (words.Length < 2) {
        Respond(e, "this command needs 2 parameters (ally number and player name)");
        return;
      }
      int allyno = 0;
      if (!int.TryParse(words[0], out allyno) || --allyno < 0 || allyno >= Spring.MaxAllies) {
        Respond(e, "invalid ally number");
        return;
      }
      string[] usrs;
      int[] idx;
      if (FilterUsers(Utils.ShiftArray(words, -1), out usrs, out idx) == 0) {
        Respond(e, "no such player found");
      } else {
        tas.Say(TasClient.SayPlace.Battle, "", "Forcing " + usrs[0] + " to alliance " + (allyno+1), true);
        tas.ForceAlly(usrs[0], allyno);
      }
    }

  }
}
