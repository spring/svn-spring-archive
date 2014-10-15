using System;
using System.Collections.Generic;
using System.Text;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.AutoHostNamespace
{
  public interface IVotable
  {
    bool Init(TasSayEventArgs e, string[] words);
    void TimeEnd();
    bool Vote(TasSayEventArgs e, string[] words);
  }


  abstract public class AbstractPoll
  {
    protected TasClient tas;
    protected Spring spring;
    protected AutoHost ah;
    protected int initialUserCount = 0;

    protected List<string> users = new List<string>();
    protected List<int> votes = new List<int>();

    protected int options = 2;
    protected const double ratio = 0.5;

    public AbstractPoll() { }

    public AbstractPoll(TasClient tas, Spring spring, AutoHost ah)
    {
      this.tas = tas;
      this.spring = spring;
      this.ah = ah;
      string[] usrs;
      int[] indexes;
      AutoHost.FilterUsers(new string[0], tas, spring, out usrs, out indexes);
      foreach (string s in usrs) {
        if (s != tas.UserName) {
          users.Add(s);
          votes.Add(0);
        }
      }
      initialUserCount = users.Count;
    }

    protected bool CheckEnd(out int winVote)
    {
      int[] sums = new int[options];
      foreach (int val in votes) {
        if (val > 0 && val <= options) sums[val - 1]++;
      }
      for (int i = 0; i < sums.Length; ++i) {
        string text = string.Format("option {0} has {1} of {2} votes", i + 1, sums[i], (int)(initialUserCount * ratio) + 1);

        tas.Say(TasClient.SayPlace.Battle, "", text, true);
        spring.SayGame(text);
        if (sums[i] > (int)(initialUserCount * ratio)) {
          winVote = i + 1;
          return true;
        }
      }
      winVote = 0;
      return false;
    }

    protected bool RegisterVote(TasSayEventArgs e, string[] words, out int vote)
    {
      vote = 0;
      if (words.Length != 1) return false;
      int.TryParse(words[0], out vote);
      if (vote > 0 && vote <= options) { // vote within parameters, lets register it

        int ind = users.IndexOf(e.UserName);
        if (ind == -1) {
          votes.Add(vote);
          users.Add(e.UserName);
        } else {
          votes[ind] = vote;
        }
        return true;
      }
      return false;
    }
  };



  public class VoteMap : AbstractPoll, IVotable
  {
    string map;

    public VoteMap(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        AutoHost.Respond(tas, spring, e, "You must specify map name");
        return false;
      }

      string[] vals;
      int[] indexes;
      if (AutoHost.FilterMaps(words, tas, spring, out vals, out indexes) > 0) {
        map = vals[0];
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to change map to " + map + "? !vote 1 = yes, !vote 2 = no", true);
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "Cannot find such map");
        return false;
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes, map stays", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - changing map to " + map, true);
          tas.ChangeMap(map);
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes, map stays", true);
        }
        return true;
      } else return false;
    }
  }


  public class VoteKick : AbstractPoll, IVotable
  {
    string player;

    new const double ratio = 0.66;

    public VoteKick(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        AutoHost.Respond(tas, spring, e, "You must specify player name");
        return false;
      }

      string[] players;
      int[] indexes;
      if (AutoHost.FilterUsers(words, tas, spring, out players, out indexes) > 0) {
        player = players[0];
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to kick " + player + "? !vote 1 = yes, !vote 2 = no", true);
        spring.SayGame("vote to kick " + player + " started in lobby");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "Cannot find such player");
        return false;
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes, player stays", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - kicking " + player, true);
          tas.Kick(player);
          spring.SayGame(".kick " + player);
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes, player stays", true);
        }
        return true;
      } else return false;
    }
  }

  public class VoteForce : AbstractPoll, IVotable
  {
    new const double ratio = 0.50;

    public VoteForce(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to force game? !vote 1 = yes, !vote 2 = no", true);
        spring.SayGame("vote to force this started in lobby");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "battle not started yet");
        return false;
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.ComForce(e, words);
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - forcing", true);
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
        }
        return true;
      } else return false;
    }
  }


  public class VoteForceStart : AbstractPoll, IVotable
  {
    new const double ratio = 0.50;

    public VoteForceStart(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (!spring.IsRunning) {
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to force start game? !vote 1 = yes, !vote 2 = no", true);
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "battle already started");
        return false;
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - force starting", true);
          ah.ComForceStart(e, words);
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
        }
        return true;
      } else return false;
    }
  }



  public class VoteExit : AbstractPoll, IVotable
  {
    new const double ratio = 0.66;

    public VoteExit(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to exit this game? !vote 1 = yes, !vote 2 = no", true);
        spring.SayGame("vote to exit this game started in lobby");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "game not running");
        return false;
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - force exiting", true);
          ah.ComExit(e, words);
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
        }
        return true;
      } else return false;
    }
  }




  public class VoteRehost : AbstractPoll, IVotable
  {
    new const double ratio = 0.66;
    string modname = "";

    public VoteRehost(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        tas.Say(TasClient.SayPlace.Battle, "", "Do you want to rehost this game? !vote 1 = yes, !vote 2 = no", true);
        spring.SayGame("vote to rehost this game started in lobby");
        return true;
      } else {
        string[] mods;
        int[] indexes;
        if (AutoHost.FilterMods(words, tas, spring, out mods, out indexes) == 0) {
          AutoHost.Respond(tas, spring, e, "cannot find such mod");
          return false;
        } else {
          modname = mods[0];
          tas.Say(TasClient.SayPlace.Battle, "", "Do you want to rehost this game to " + modname + "? !vote 1 = yes, !vote 2 = no", true);
          spring.SayGame("vote to rehost this game started in lobby");
          return true;
        }
      }
    }

    public void TimeEnd()
    {
      tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          tas.Say(TasClient.SayPlace.Battle, "", "vote successful - rehosting", true);

          ah.ComRehost(e, new string[] { modname });
        } else {
          tas.Say(TasClient.SayPlace.Battle, "", "not enough votes", true);
        }
        return true;
      } else return false;
    }
  }

}
