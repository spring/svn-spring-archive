using System;
using System.Collections.Generic;
using System.Text;
using Springie.Client;
using Springie.SpringNamespace;
using System.Xml.Serialization;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Windows.Forms;
using System.Threading;

namespace Springie
{
  public class Stats
  {
    TasClient tas;
    Spring spring;

    string password = "";
    List<Account> accounts = new List<Account>();

    Dictionary<string, Player> players = new Dictionary<string, Player>();

    // original battle settings
    Battle battle;
    DateTime startTime;

    public const string accountsFileName = "do_not_delete_me.xml";
    public const string gatherScript = "statsGather.php";
    public const string smurfScript = "smurfs.php";
    public const string statsScript = "stats.php";

    protected string StatsUrl
    {
      get
      {
        return Program.main.config.StatsUrl;
      }
    }

    protected string UserName
    {
      get
      {
        if (tas != null && !string.IsNullOrEmpty(tas.UserName)) return tas.UserName;
        else return Program.main.config.AccountName;
      }
    }

    public string SendCommand(string script, string query, bool async, bool hash)
    {
      Uri uri;
      try {
        if (hash) {
          query += "&login=" + UserName;
          uri = new Uri(StatsUrl + script + "?" + query + "&hash=" + CalculateHexMD5Hash(query + password));
        } else uri = new Uri(StatsUrl + script + "?" + query);

        if (async) {
          Thread t1 = new Thread(delegate(object s) {
            try {
              WebClient wc = new WebClient();
              wc.DownloadString((Uri)s);
            } catch { }
          });
          t1.Start(uri);
          return "";
        } else {
          WebClient wc = new WebClient();
          return wc.DownloadString(uri);
        }
      } catch {
        return "";
      }
    }



    public Stats(TasClient tas, Spring spring)
    {
      this.tas = tas;
      this.spring = spring;

      LoadAccounts();

      tas.LoginAccepted += new EventHandler<TasEventArgs>(tas_LoginAccepted);
      if (Program.main.config.GargamelMode) {
        tas.UserRemoved += new EventHandler<TasEventArgs>(tas_UserRemoved);
        tas.BattleUserIpRecieved += new EventHandler<TasEventArgs>(tas_BattleUserIpRecieved);
        tas.UserStatusChanged += new EventHandler<TasEventArgs>(tas_UserStatusChanged);
      }
      spring.SpringStarted += new EventHandler(spring_SpringStarted);
      spring.PlayerJoined += new EventHandler<SpringLogEventArgs>(spring_PlayerJoined);
      spring.PlayerLeft += new EventHandler<SpringLogEventArgs>(spring_PlayerLeft);
      spring.PlayerLost += new EventHandler<SpringLogEventArgs>(spring_PlayerLost);
      spring.PlayerDisconnected += new EventHandler<SpringLogEventArgs>(spring_PlayerDisconnected);
      spring.GameOver += new EventHandler<SpringLogEventArgs>(spring_GameOver);
    }

    void tas_UserStatusChanged(object sender, TasEventArgs e)
    {
      User u;
      if (tas.GetExistingUser(e.ServerParams[0], out u)) {
        SendCommand(gatherScript, "a=addplayer&name=" + u.name + "&rank=" + (u.rank + 1), true, true);
      }
    }

    void tas_BattleUserIpRecieved(object sender, TasEventArgs e)
    {
      User u;
      if (tas.GetExistingUser(e.ServerParams[0], out u)) {
        SendCommand(gatherScript, "a=joinplayer&name=" + u.name + "&rank=" + u.rank + "&ip=" + e.ServerParams[1], true, true);
      }
     
    }


    void spring_GameOver(object sender, SpringLogEventArgs e)
    {
      string query = String.Format("a=battle&map={0}&mod={1}&title={2}&start={3}&duration={4}", battle.Map.Name, battle.Mod.Name, battle.Title, Utils.ToUnix(startTime), Utils.ToUnix(DateTime.Now.Subtract(startTime)));


      foreach (Player p in players.Values) {
        if (!p.Spectator && p.AliveTillEnd) {
          foreach (Player pset in players.Values) {
            if (pset.AllyNumber == p.AllyNumber && !pset.Spectator) pset.OnVictoryTeam = true;
          }
        }
      }

      foreach (Player p in players.Values) {
        query += "&player[]=" + p;
      }

      // send only if there were at least 2 players in game
      if (players.Count > 1) SendCommand(gatherScript, query, true, true);
    }

    void spring_PlayerDisconnected(object sender, SpringLogEventArgs e)
    {
      if (RegisterPlayerInCombat(e.Username)) {
        players[e.Username].DisconnectTime = DateTime.Now.Subtract(startTime);
      }
    }

    void spring_PlayerLost(object sender, SpringLogEventArgs e)
    {
      if (RegisterPlayerInCombat(e.Username)) {
        players[e.Username].LoseTime = DateTime.Now.Subtract(startTime);
        players[e.Username].AliveTillEnd = false;
      }
    }

    void spring_PlayerLeft(object sender, SpringLogEventArgs e)
    {
      if (RegisterPlayerInCombat(e.Username)) {
        players[e.Username].LeaveTime = DateTime.Now.Subtract(startTime);
      }
    }

    private bool RegisterPlayerInCombat(string name) {
      if (players.ContainsKey(name)) return true;
      Player p = new Player();
      p.Name = name;
      int idx = battle.GetUserIndex(name);
      if (idx != -1) {
        p.Side = battle.Mod.Sides[battle.Users[idx].Side];
        p.Spectator = battle.Users[idx].IsSpectator;
        p.AllyNumber = battle.Users[idx].AllyNumber;
        p.Ip = battle.Users[idx].ip.ToString();
        
        User u;
        if (tas.GetExistingUser(name, out u)) {
          p.Rank = u.rank + 1;
        }
      } else return false;
      players.Add(name, p);
      return true;
    }

    void spring_PlayerJoined(object sender, SpringLogEventArgs e)
    {
      if (e.Username == UserName) return; // do not add autohost itself
      RegisterPlayerInCombat(e.Username);
    }

    void spring_SpringStarted(object sender, EventArgs e)
    {
      battle = tas.GetBattle();
      players = new Dictionary<string, Player>();
      startTime = DateTime.Now;
    }

    void tas_UserRemoved(object sender, TasEventArgs e)
    {
      SendCommand(gatherScript, "a=removeplayer&name=" + e.ServerParams[0], true, true);
    }


    void tas_LoginAccepted(object sender, TasEventArgs e)
    {
      Account a = accounts.Find(delegate(Account acc) { return acc.UserName == UserName; });
      if (a != null) {
        password = a.Password;
      }

      if (password == "") {
        password = SendCommand(gatherScript, "a=register&name=" + UserName, false, false);
        if (password != "") {
          if (password.StartsWith("FAILED")) {
            MessageBox.Show("You need correct password to submit stats with account " + UserName + ", stats won't work - " + password, "Stats registration failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
          } else {
            accounts.Add(new Account(UserName, password));
            SaveAccounts();
          }
        } else MessageBox.Show("Error registering to stats server - stats server probably down. Statistics wont work until next Springie start", "Stats registration failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
      }
    }

    private void SaveAccounts()
    {
      XmlSerializer s = new XmlSerializer(accounts.GetType());
      FileStream f = File.OpenWrite(accountsFileName);
      f.SetLength(0);
      s.Serialize(f, accounts);
      f.Close();
    }

    private void LoadAccounts()
    {
      if (File.Exists(accountsFileName)) {
        XmlSerializer s = new XmlSerializer(accounts.GetType());
        StreamReader r = File.OpenText(accountsFileName);
        accounts = (List<Account>)s.Deserialize(r);
        r.Close();
      }
    }

    public static string CalculateHexMD5Hash(string input)
    {
      MD5 md5 = MD5.Create();
      byte[] inputBytes = Encoding.ASCII.GetBytes(input);
      byte[] hash = md5.ComputeHash(inputBytes);

      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < hash.Length; i++) {
        sb.Append(hash[i].ToString("x2"));
      }
      return sb.ToString();
    }


    public class Account
    {
      public string UserName;
      public string Password;
      public Account() { }
      public Account(string userName, string password)
      {
        this.UserName = userName;
        this.Password = password;
      }
    };


    class Player
    {
      public string Name = "";
      public bool AliveTillEnd = true;
      public bool OnVictoryTeam = false;
      public bool Spectator = false;
      public TimeSpan LoseTime;
      public TimeSpan LeaveTime;
      public TimeSpan DisconnectTime;
      public string Side = ""; // mod side
      public string Ip = "";
      public int AllyNumber = 0;
      public int Rank = 0; // - actually rank + 1 .. starts at 1 and not 0

      public override string ToString()
      {
        string ret = "";
        ret += Name + "|" + Ip + "|" + (Spectator ? "1" : "0") + "|";
        ret += (OnVictoryTeam ? "1" : "0") + "|" + (AliveTillEnd ? "1" : "0") + "|";
        ret += Utils.ToUnix(DisconnectTime) + "|" + Utils.ToUnix(LeaveTime) + "|";
        ret += Side + "|" + Utils.ToUnix(LoseTime) + "|" + AllyNumber + "|" + Rank;
        return ret;
      }
    };
  }
}
