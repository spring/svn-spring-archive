using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.ComponentModel;
using Springie.SpringNamespace;

namespace Springie.Client
{
  public partial class TasClient
  {
    // NOTE: all these stuffs are actually structures.. Why? To protected data from being modified when accessed by other modules. I'm too lazy to sort rights and make proper classes.
    /// <summary>
    /// Channel - active joined channels
    /// </summary>
    public struct Channel
    {
      public string name;
      public string topic;
      public string topicSetBy;
      public DateTime topicSetDate;
      public List<string> channelUsers;

      public static Channel Create(string name)
      {
        Channel c = new Channel();
        c.name = name;
        c.channelUsers = new List<string>();
        return c;
      }
    };

    /// <summary>
    /// Basic channel information - for channel enumeration
    /// </summary>
    public struct ExistingChannel
    {
      public string name;
      public int userCount;
      public string topic;
    };


    /// <summary>
    /// User - on the server
    /// </summary>
    public struct User
    {
      public string name;
      public int cpu;
      public string country;
      public IPAddress ip;
      public bool isInGame;
      public bool isAway;
      public int rank;
      public bool isAdmin;
      public static User Create(string name)
      {
        User u = new User();
        u.name = name;
        return u;
      }
      public void FromInt(int status)
      {
        isInGame = (status & 1) > 0;
        isAway = (status & 2) > 0;
        isAdmin = (status & 32) > 0;
        rank = (status & 28) >> 2;
      }

      public int ToInt()
      {
        int res = 0;
        res |= isInGame ? 1 : 0;
        res |= isAway ? 2 : 0;
        return res;
      }
    };



    public enum BattleStartPos : int
    {
      NotSet = -1,
      Fixed = 0,
      Random = 1,
      Choose = 2
    }

    public enum BattleEndCondition : int
    {
      NotSet = -1,
      Continues = 0,
      Ends = 1
    }

    public class BattleDetails : ICloneable
    {
      public static BattleDetails Default = new BattleDetails();

      int startingMetal = 1000;

      [Category("Resources"), Description("Starting metal"), DefaultValue(1000)]
      public int StartingMetal
      {
        get { return startingMetal; }
        set { startingMetal = value; }
      }
      int startingEnergy = 1000;

      [Category("Resources"), Description("Starting energy"), DefaultValue(1000)]
      public int StartingEnergy
      {
        get { return startingEnergy; }
        set { startingEnergy = value; }
      }
      int maxUnits = 500;

      [Category("Resources"), Description("Maximum units"), DefaultValue(500)]
      public int MaxUnits
      {
        get { return maxUnits; }
        set { maxUnits = value; }
      }

      
      BattleStartPos startPos = BattleStartPos.Choose;

      [Category("Game rules"), Description("Starting position")]
      public BattleStartPos StartPos
      {
        get { return startPos; }
        set { startPos = value; }
      }

      BattleEndCondition endCondition = BattleEndCondition.Continues;

      [Category("Game rules"), Description("End condition - should continue when comm dies")]
      public BattleEndCondition EndCondition
      {
        get { return endCondition; }
        set { endCondition = value; }
      }


      int limitDgun = 1;

      [Category("Game rules"), Description("Limit dgun to start position")]
      public int LimitDgun
      {
        get { return limitDgun; }
        set { limitDgun = value; }
      }
      int diminishingMM = 0;

      [Category("Game rules"), Description("Diminishing metal maker outputs")]
      public int DiminishingMM
      {
        get { return diminishingMM; }
        set { diminishingMM = value; }
      }

      int ghostedBuildings = 1;

      [Category("Game rules"), Description("Ghosted buildings")]
      public int GhostedBuildings
      {
        get { return ghostedBuildings; }
        set { ghostedBuildings = value; }
      }

      public void Validate()
      {
        if (startingMetal < 0) startingMetal = Default.startingMetal;
        if (startingEnergy < 0) startingEnergy = Default.startingEnergy;
        if (maxUnits < 0) maxUnits = Default.maxUnits;
        if (startPos == BattleStartPos.NotSet) startPos = Default.startPos;
        if (endCondition == BattleEndCondition.NotSet) endCondition = Default.endCondition;
        if (limitDgun < 0) limitDgun = Default.limitDgun;
        if (diminishingMM < 0) diminishingMM = Default.diminishingMM;
        if (ghostedBuildings < 0) ghostedBuildings = Default.ghostedBuildings;
      }

      public void AddToParamList(List<object> objList)
      {
        Validate();
        objList.Add(startingMetal);
        objList.Add(startingEnergy);
        objList.Add(maxUnits);
        objList.Add((int)startPos);
        objList.Add((int)endCondition);
        objList.Add(limitDgun);
        objList.Add(diminishingMM);
        objList.Add(ghostedBuildings);
      }

      #region ICloneable Members

      public object Clone()
      {
        return this.MemberwiseClone();
      }

      #endregion
    };

   
    public class Battle : ICloneable
    {
      public BattleDetails Details = new BattleDetails();
      public ModInfo Mod;
      public string Password = "*";
      public int MaxPlayers;
      public int Rank;
      public string Map;
      public string Title;
      public int HostPort;
      public bool IsLocked = false;

      public List<UserBattleStatus> Users = new List<UserBattleStatus>();


      public Dictionary<int, BattleRect> Rectangles = new Dictionary<int, BattleRect>();

      public bool ContainsUser(string name) {
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

      public void RemoveUser(string name) {
        int ret = GetUserIndex(name);
        if (ret != -1) Users.RemoveAt(ret);
      }



      public int GetUserIndex(string name) {
        for (int i = 0; i < Users.Count; ++i) {
          if (Users[i].name == name) {
            return i;
          }
        }
        return -1;
      }

      public int CountSpectators() {
        int speccount = 0;
        foreach (UserBattleStatus u in Users) {
          if (u.IsSpectator) speccount++;
        }
        return speccount;
      }


      public Battle(string password, int port, int maxplayers, int rank, string map, string title, ModInfo mod, BattleDetails details)
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



      public struct GrPlayer {
        public UserBattleStatus user;
        public GrPlayer(UserBattleStatus ubs) {  user = ubs; }
      };

      public struct GrTeam {
        public int leader;
        public GrTeam(int leader) { this.leader = leader; }
      };

      public struct GrAlly{
        public BattleRect rect;
        public GrAlly(BattleRect r) { rect = r; }
      };

      /// <summary>
      /// Groups tam and ally numbers, so that they both start from 0
      /// </summary>
      public void GroupData(out List<GrPlayer> players, out List<GrTeam> teams, out List<GrAlly> alliances) {
        Dictionary<int, int> teamNums = new Dictionary<int,int>();
        Dictionary<int, int> allyNums = new Dictionary<int,int>();

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
        return b;
      }
      #endregion
    };


    public struct BattleRect {
      public int Left, Top, Right, Bottom; // values 0-200 (native tasclient format)
      public const double Max = 200; 


      public BattleRect(double left, double top, double right, double bottom) { // convert from percentages
        Left = (int)(Max*left);
        Top = (int)(Max*top);
        Right = (int)(Max*right);
        Bottom = (int)(Max*bottom);
      }

      public BattleRect(int left, int top, int right, int bottom) {
        Left = left;
        Top = top;
        Right = right;
        Bottom = bottom;
      }

      public void ToFractions(out double left, out double top, out double right, out double bottom) {
        left = Left / Max;
        top = Top / Max;
        right = Right / Max;
        bottom = Bottom / Max;
      }
    };


    public enum SyncStatuses:int {
      Unknown = 0,
      Synced = 1,
      Unsynced =2 
    }

    public struct UserBattleStatus
    {
      public string name;
      public bool IsReady;
      public int TeamNumber;
      public int AllyNumber;
      public bool IsSpectator;
      public SyncStatuses SyncStatus;
      public int Side;
      public int TeamColor;

      public UserBattleStatus(string name) {
        this.name = name;
        this.IsReady = false;
        this.TeamNumber = 0;
        this.AllyNumber = 0;
        this.IsSpectator = false;
        this.SyncStatus = SyncStatuses.Unknown;
        this.Side = 0;
        this.TeamColor = 0;
      }

      public void SetFrom(int status, int color, string name) {
        this.name = name;
        SetFrom(status, color);
      }

      public void SetFrom(int status, int color)
      {
        IsReady = (status & 2) > 0;
        TeamNumber = (status >> 2) & 15;
        AllyNumber = (status >> 6) & 15;
        IsSpectator = (status & 1024) == 0;
        SyncStatus = (SyncStatuses)(int)((status >> 22) & 3);
        Side = (status >> 24) & 15;
        TeamColor = color;
      }
    };

  }
}
