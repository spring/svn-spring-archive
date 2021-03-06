using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using Springie.Client;
using Springie.SpringNamespace;
using System.Net;

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
      string[] temp = new string[spring.UnitSync.MapList.Keys.Count];
      int cnt = 0;
      foreach (string s in spring.UnitSync.MapList.Keys) { temp[cnt++] = s; }
      return Filter(temp, words, out vals, out indexes);

    }

    private int FilterMaps(string[] words, out string[] vals, out int[] indexes)
    {
      return FilterMaps(words, tas, spring, out vals, out indexes);
    }


    internal static int FilterPresets(string[] words, AutoHost autohost, out string[] vals, out int[] indexes)
    {
      string[] temp = new string[autohost.presets.Count];
      int cnt = 0;
      foreach (Preset p in autohost.presets) { temp[cnt++] = p.Name + " --> " + p.Description; }
      return Filter(temp, words, out vals, out indexes);
    }

    private int FilterPresets(string[] words, out string[] vals, out int[] indexes)
    {
      return FilterPresets(words, this, out vals, out indexes);
    }

    internal static int FilterUsers(string[] words, TasClient tas, Spring spring, out string[] vals, out int[] indexes)
    {
      Battle b = tas.GetBattle();
      string[] temp = new string[b.Users.Count];
      int i = 0;
      foreach (UserBattleStatus u in b.Users) {
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
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
        for (int i = 0; i < vals.Length; ++i) {
          tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
        }
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      } else Respond(e, "no such map found");
    }


    private void ComListMods(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;
      if (FilterMods(words, out vals, out indexes) > 0) {
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
        for (int i = 0; i < vals.Length; ++i) {
          tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
        }
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      } else Respond(e, "no such mod found");
    }

    private void ComListPresets(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;

      if (FilterPresets(words, out vals, out indexes) > 0) {
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
        for (int i = 0; i < vals.Length; ++i) {
          tas.Say(TasClient.SayPlace.User, e.UserName, indexes[i] + ": " + vals[i], false);
        }
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      } else Respond(e, "no such preset found");
    }



    private void ComHelp(TasSayEventArgs e, string[] words)
    {
      int ulevel = GetUserLevel(e);
      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      foreach (CommandConfig c in config.Commands) {
        if (c.Level <= ulevel) {
          tas.Say(TasClient.SayPlace.User, e.UserName, " !" + c.Name + " " + c.HelpText, false);
        }
      }
      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
    }


    private void ComHelpAll(TasSayEventArgs e, string[] words)
    {
      List<CommandConfig> copy = new List<CommandConfig>(config.Commands);
      copy.Sort(delegate(CommandConfig a, CommandConfig b) { if (a.Level != b.Level) return a.Level.CompareTo(b.Level); else return a.Name.CompareTo(b.Name); });

      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      foreach (CommandConfig c in copy) {
        tas.Say(TasClient.SayPlace.User, e.UserName, "Level " + c.Level + " --> !" + c.Name + " " + c.HelpText, false);
      }
      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
    }


    private void ComAdmins(TasSayEventArgs e, string[] words)
    {
      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      foreach (PrivilegedUser u in config.PrivilegedUsers) {
        tas.Say(TasClient.SayPlace.User, e.UserName, " " + u.Name + " (level " + u.Level.ToString() + ")", false);
      }
      tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
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
        tas.ChangeMap(spring.UnitSync.MapList[vals[0]]);

      } else Respond(e, "Cannot find such map.");

    }


    private bool AllReadyAndSynced(out string usname)
    {
      usname = "";
      int cnt = 0;
      foreach (UserBattleStatus p in tas.GetBattle().Users) {
        if (p.IsSpectator) continue; else cnt++;
        if (p.SyncStatus != SyncStatuses.Synced || !p.IsReady) {
          usname = p.name;
          return false;
        }
      }
      if (cnt == 0) return false; else return true;
    }

    private bool AllUniqueTeams(out string username)
    {
      List<int> teams = new List<int>();
      username = "";
      foreach (UserBattleStatus p in tas.GetBattle().Users) {
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

      foreach (UserBattleStatus p in tas.GetBattle().Users) {
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
            tas.AddBattleRectangle(0, new BattleRect(0, 0, 1.0, perc / 100.0));
            tas.AddBattleRectangle(1, new BattleRect(0, 1.0 - perc / 100.0, 1.0, 1.0));
          } else {
            tas.AddBattleRectangle(0, new BattleRect(0, 0, perc / 100.0, 1.0));
            tas.AddBattleRectangle(1, new BattleRect(1.0 - perc / 100.0, 0, 1.0, 1.0));
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
            tas.AddBattleRectangle(0, new BattleRect(0, 0, p, p));
            tas.AddBattleRectangle(1, new BattleRect(1 - p, 1 - p, 1, 1));
            tas.AddBattleRectangle(2, new BattleRect(1 - p, 0, 1, p));
            tas.AddBattleRectangle(3, new BattleRect(0, 1 - p, p, 1));
          } else {
            tas.AddBattleRectangle(0, new BattleRect(1 - p, 0, 1, p));
            tas.AddBattleRectangle(1, new BattleRect(0, 1 - p, p, 1));
            tas.AddBattleRectangle(2, new BattleRect(0, 0, p, p));
            tas.AddBattleRectangle(3, new BattleRect(1 - p, 1 - p, 1, 1));
          }
        }
      }
    }



    public void ComAddBox(TasSayEventArgs e, string[] words)
    {
      if (words.Length < 4) {
        Respond(e, "This command needs at least 4 parameters");
        return;
      }
      int x, y, w, h;
      if (!int.TryParse(words[0], out x) || !int.TryParse(words[1], out y) || !int.TryParse(words[2], out w) || !int.TryParse(words[3], out h)) {
        Respond(e, "All parameters must be numbers");
        return;
      }
      int numrect = 0;
      if (words.Length > 4) int.TryParse(words[4], out numrect);

      if (numrect == 0) {
        numrect = tas.GetBattle().GetFirstEmptyRectangle();
        if (numrect == -1) {
          Respond(e, "Cannot add more boxes");
          return;
        }
        numrect++;
      }
      tas.AddBattleRectangle(numrect - 1, new BattleRect(x * 2, y * 2, (x + w) * 2, (y + h) * 2));
    }

    public void ComClearBox(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        foreach (int i in tas.GetBattle().Rectangles.Keys) {
          tas.RemoveBattleRectangle(i);
        }
      } else {
        int numrect = 0;
        if (!int.TryParse(words[0], out numrect)) {
          Respond(e, "paramater must by a number of rectangle");
        }
        tas.RemoveBattleRectangle(numrect - 1);
      }
    }

    void ComRing(TasSayEventArgs e, string[] words)
    {
      List<string> usrlist = new List<string>();

      if (words.Length == 0) { // ringing idle
        foreach (UserBattleStatus p in tas.GetBattle().Users) {
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


    public void ComKick(TasSayEventArgs e, string[] words)
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

      if (spring.IsRunning) spring.Kick(usrlist[0]);
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
      Battle b = tas.GetBattle();
      int cnt = 0;
      foreach (UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          tas.ForceTeam(u.name, cnt);
          cnt++;
        }
      }
      tas.Say(TasClient.SayPlace.Battle, "", "team numbers fixed", true);
    }


    public void ComFixColors(TasSayEventArgs e, string[] words)
    {
      List<MyCol> cols = new List<MyCol>();
      Battle b = tas.GetBattle();

      foreach (UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) cols.Add((MyCol)u.TeamColor);
      }
      MyCol[] arcols = cols.ToArray();

      MyCol.FixColors(arcols, 30000);

      int cnt = 0;
      foreach (UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          tas.ForceColor(u.name, (int)arcols[cnt]);
          cnt++;
        }
      }

      tas.Say(TasClient.SayPlace.Battle, "", "colors fixed", true);
    }


    public void ComRehost(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
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
      Battle b = tas.GetBattle();

      List<UserBattleStatus> actUsers = new List<UserBattleStatus>();
      foreach (UserBattleStatus u in b.Users) {
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
    private class UsRank
    {
      public int id;
      public int rank;
      public string clan;
      public UsRank(int id, int rank, string clan)
      {
        this.id = id;
        this.rank = rank;
        this.clan = clan;
      }
    }



    private static string GetClan(string name)
    {
      string[] parts = name.Split(new char[] { '[', ']' }, StringSplitOptions.RemoveEmptyEntries);
      if (parts.Length >= 2) {
        if (parts[0].Length > parts[1].Length) return parts[1]; else return parts[0];
      } return "";
    }

    private void BalanceTeams(int teamCount, bool clanwise)
    {
      List<UserBattleStatus> actUsers = new List<UserBattleStatus>();
      List<UsRank> ranker = new List<UsRank>();
      Battle b = tas.GetBattle();

      foreach (UserBattleStatus u in b.Users) {
        if (!u.IsSpectator) {
          actUsers.Add(u);
          User p;
          if (tas.GetExistingUser(u.name, out p)) ranker.Add(new UsRank(ranker.Count, p.rank, GetClan(u.name))); else ranker.Add(new UsRank(ranker.Count, 0, GetClan(u.name))); // cannot find user, assume rank 0
        }
      }

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

      if (teamCount < 2 || teamCount > ranker.Count) teamCount = 2;

      List<UsRank>[] teamUsers = new List<UsRank>[teamCount];
      for (int i = 0; i < teamUsers.Length; ++i) teamUsers[i] = new List<UsRank>();
      int[] teamSums = new int[teamCount];

      List<string>[] teamClans = new List<string>[teamCount];
      for (int i = 0; i < teamClans.Length; ++i) teamClans[i] = new List<string>();


      // this cycle performs actual user adding to teams
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

        int picked_user = 0;
        if (clanwise) { // clanwise balancing - attempt to pick someone with same clan
          // selected team already has some clan
          int rank = ranker[0].rank;
          List<int> temp = new List<int>();


          // get list of clans assigned to other teams
          List<string> assignedClans = new List<string>();
          for (int i = 0; i < teamClans.Length; ++i) {
            if (i != minid) {
              foreach (string clanName in teamClans[i]) {
                assignedClans.Add(clanName);
              }
            }
          }


          // first try to get some with same clan
          if (teamClans[minid].Count > 0) {
            for (int i = 0; i < ranker.Count; ++i) {
              if (temp.Count > 0 && ranker[i].rank != rank) break;
              if (teamClans[minid].Contains(ranker[i].clan)) temp.Add(i);
            }
          }

          if (temp.Count == 0 && assignedClans.Count > 0) {
            // we dont have any candidates try to get clanner from unassigned clan
            for (int i = 0; i < ranker.Count; ++i) {
              if (temp.Count > 0 && ranker[i].rank != rank) break;
              if (ranker[i].clan != "" && !assignedClans.Contains(ranker[i].clan)) temp.Add(i);
            }
          }

          if (temp.Count == 0) {
            // we still dont have any candidates try to get non-clanner
            for (int i = 0; i < ranker.Count; ++i) {
              if (temp.Count > 0 && ranker[i].rank != rank) break;
              if (ranker[i].clan == "") temp.Add(i);
            }
          }

          // if we have some candidates pick one randomly
          if (temp.Count > 0) picked_user = temp[rand.Next(temp.Count)]; ;
        }

        UsRank usr = ranker[picked_user];
        teamUsers[minid].Add(usr);
        teamSums[minid] += usr.rank;

        if (clanwise && usr.clan != "") { // if we work with clans add user's clan to clan list for his team
          if (!teamClans[minid].Contains(usr.clan)) teamClans[minid].Add(usr.clan);
        }

        ranker.RemoveAt(picked_user);

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
      if (clanwise) t += " respecting clans";
      tas.Say(TasClient.SayPlace.Battle, "", t, true);
    }




    public void ComBalance(TasSayEventArgs e, string[] words)
    {
      int teamCount = 2;
      if (words.Length > 0) int.TryParse(words[0], out teamCount); else teamCount = 2;
      ComFix(e, words);
      BalanceTeams(teamCount, false);
    }

    public void ComCBalance(TasSayEventArgs e, string[] words)
    {
      int teamCount = 2;
      if (words.Length > 0) int.TryParse(words[0], out teamCount); else teamCount = 2;
      ComFix(e, words);
      BalanceTeams(teamCount, true);
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


    public void ComTeam(TasSayEventArgs e, string[] words)
    {
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
      if (FilterUsers(Utils.ShiftArray(words, -1), out usrs, out idx) == 0) {
        Respond(e, "no such player found");
      } else {
        tas.Say(TasClient.SayPlace.Battle, "", "Forcing " + usrs[0] + " to team " + (teamno + 1), true);
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
        tas.Say(TasClient.SayPlace.Battle, "", "Forcing " + usrs[0] + " to alliance " + (allyno + 1), true);
        tas.ForceAlly(usrs[0], allyno);
      }
    }


    public void ComSpringie(TasSayEventArgs e, string[] words)
    {
      Client.Battle b = tas.GetBattle();

      TimeSpan running = DateTime.Now.Subtract(Program.startupTime);
      running = new TimeSpan((int)running.TotalHours, running.Minutes, running.Seconds);

      TimeSpan started = DateTime.Now.Subtract(spring.GameStarted);
      started = new TimeSpan((int)started.TotalHours, started.Minutes, started.Seconds);

      Respond(e, tas.UserName + " (" + MainConfig.SpringieVersion + ") running for " + running);
      Respond(e, "players: " + (b.Users.Count - b.CountSpectators()) + "/" + b.MaxPlayers);
      Respond(e, "mod: " + b.Mod.Name);
      Respond(e, "map: " + b.Map.Name);
      Respond(e, "game " + (spring.IsRunning ? "running since " : "not running, last started ") + (spring.GameStarted != DateTime.MinValue ? started.ToString() + " ago" : "never"));
    }

    public void ComPresetDetails(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;
      if (FilterPresets(words, out vals, out indexes) > 0) {
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
        foreach (string line in presets[indexes[0]].ToString().Split(new char[] { '\n' }, StringSplitOptions.RemoveEmptyEntries)) {
          tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
        }
        tas.Say(TasClient.SayPlace.User, e.UserName, "---", false);
      } else Respond(e, "no such preset found");
    }


    public void ComPreset(TasSayEventArgs e, string[] words)
    {
      string[] vals;
      int[] indexes;
      if (FilterPresets(words, out vals, out indexes) > 0) {
        Preset p = presets[indexes[0]];
        Respond(e, "applying preset " + p.Name + " (" + p.Description + ")");
        p.Apply(tas);
      } else Respond(e, "no such preset found");
    }


    private void SayLines(TasSayEventArgs e, string what)
    {
      foreach (string line in what.Split(new char[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)) {
        tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
      }
    }


    private void RemoteCommand(string scriptName, TasSayEventArgs e, string[] words) {
      Battle b = tas.GetBattle();
      string query = string.Format("user={0}&map={1}&mod={2}&p={3}", e.UserName, b.Map.Name,b.Mod.Name, Utils.Glue(words));
      foreach (UserBattleStatus u in b.Users) {
        if (u.name != tas.UserName) {
          query += string.Format("&users[]={0}|{1}|{2}", u.name,(u.IsSpectator ? "1" : "0"), u.AllyNumber);
        }
      }
      string[] response = Program.main.Stats.SendCommand(scriptName, query, false, true).Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);

      if (response.Length == 0) Respond(e, "error accessing stats server");
      
      if (response[0].StartsWith("RESPOND")) {
        for (int i = 1; i < response.Length; ++i ) {
          Respond(e, response[i]);
        }
      } else {
        foreach (string line in response) tas.Say(TasClient.SayPlace.User, e.UserName, line, false);
      }
    }
  }
}
