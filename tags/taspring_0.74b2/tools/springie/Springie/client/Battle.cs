using System;
using System.Collections.Generic;
using System.Text;
using Springie.SpringNamespace;

namespace Springie.Client
{
  public class Battle : ICloneable
  {
    public BattleDetails Details = new BattleDetails();
    public ModInfo Mod;
    public string Password = "*";
    public int MaxPlayers;
    public int Rank;
    public MapInfo Map;
    public string Title;
    public int HostPort;
    public bool IsLocked = false;

    public List<UserBattleStatus> Users = new List<UserBattleStatus>();


    public Dictionary<int, BattleRect> Rectangles = new Dictionary<int, BattleRect>();

    public List<string> DisabledUnits = new List<string>();


    public int GetFirstEmptyRectangle()
    {
      for (int i = 0; i < Spring.MaxAllies; ++i) {
        if (!Rectangles.ContainsKey(i)) return i;
      }
      return -1;
    }

    public bool ContainsUser(string name)
    {
      foreach (UserBattleStatus u in Users) {
        if (u.name == name) return true;
      }
      return false;
    }

    public bool ContainsUser(string name, out UserBattleStatus retu)
    {
      foreach (UserBattleStatus u in Users) {
        if (u.name == name) {
          retu = u;
          return true;
        }
      }
      retu = new UserBattleStatus();
      return false;
    }

    public void RemoveUser(string name)
    {
      int ret = GetUserIndex(name);
      if (ret != -1) Users.RemoveAt(ret);
    }



    public int GetUserIndex(string name)
    {
      for (int i = 0; i < Users.Count; ++i) {
        if (Users[i].name == name) {
          return i;
        }
      }
      return -1;
    }

    public int CountSpectators()
    {
      int speccount = 0;
      foreach (UserBattleStatus u in Users) {
        if (u.IsSpectator) speccount++;
      }
      return speccount;
    }


    public Battle(string password, int port, int maxplayers, int rank, MapInfo map, string title, ModInfo mod, BattleDetails details)
    {
      if (!String.IsNullOrEmpty(password)) this.Password = password; else this.Password = "*";
      if (port == 0) this.HostPort = 8452; else this.HostPort = port;
      this.MaxPlayers = maxplayers;
      this.Rank = rank;
      this.Map = map;
      this.Title = title;
      this.Mod = mod;
      if (details != null) this.Details = details; else details = new BattleDetails();
      details.Validate();
    }



    public struct GrPlayer
    {
      public UserBattleStatus user;
      public GrPlayer(UserBattleStatus ubs) { user = ubs; }
    };

    public struct GrTeam
    {
      public int leader;
      public GrTeam(int leader) { this.leader = leader; }
    };

    public struct GrAlly
    {
      public BattleRect rect;
      public GrAlly(BattleRect r) { rect = r; }
    };

    /// <summary>
    /// Groups tam and ally numbers, so that they both start from 0
    /// </summary>
    public void GroupData(out List<GrPlayer> players, out List<GrTeam> teams, out List<GrAlly> alliances)
    {
      Dictionary<int, int> teamNums = new Dictionary<int, int>();
      Dictionary<int, int> allyNums = new Dictionary<int, int>();

      players = new List<GrPlayer>();
      teams = new List<GrTeam>();
      alliances = new List<GrAlly>();

      foreach (UserBattleStatus p in Users) {
        UserBattleStatus u = p;

        if (!u.IsSpectator) {
          if (!teamNums.ContainsKey(u.TeamNumber)) {
            teamNums.Add(u.TeamNumber, teams.Count); // add transformation of team
            teams.Add(new GrTeam(players.Count));
          }
          u.TeamNumber = teamNums[u.TeamNumber];


          if (!allyNums.ContainsKey(u.AllyNumber)) {
            allyNums.Add(u.AllyNumber, alliances.Count); // add transformation of ally
            alliances.Add(new GrAlly());
          }
          u.AllyNumber = allyNums[u.AllyNumber];
        }
        players.Add(new GrPlayer(u));
      }

      // now assign rectangles and skip unused
      foreach (KeyValuePair<int, BattleRect> r in Rectangles) {
        if (allyNums.ContainsKey(r.Key)) {
          alliances[allyNums[r.Key]] = new GrAlly(r.Value);
        }
      }
    }

    #region ICloneable Members
    public object Clone()
    {
      Battle b = (Battle)this.MemberwiseClone();
      if (this.Details != null) b.Details = (BattleDetails)this.Details.Clone();
      if (this.Users != null) b.Users = new List<UserBattleStatus>(Users);
      if (this.Rectangles != null) b.Rectangles = new Dictionary<int, BattleRect>(Rectangles);

      if (this.DisabledUnits != null) b.DisabledUnits = new List<string>(DisabledUnits);
      return b;
    }
    #endregion
  };
}
