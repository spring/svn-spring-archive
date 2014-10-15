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
    protected int lastVote = -1; // last registered vote value

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

      initialUserCount = 0;
      Battle b = tas.GetBattle();
      if (b != null) {
        foreach (UserBattleStatus us in b.Users) {
          if (us.name != tas.UserName) {
            users.Add(us.name);
            votes.Add(0);
            if (!us.IsSpectator) initialUserCount++;
          }
        }
      }
    }

    public virtual void TimeEnd()
    {
      ah.SayBattle("not enough votes");
    }

    protected bool CheckEnd(out int winVote)
    {
      int[] sums = new int[options];
      foreach (int val in votes) {
        if (val > 0 && val <= options) sums[val - 1]++;
      }

      int votesLeft = votes.FindAll(delegate(int t) { return (t == 0); }).Count;
      bool canDecide = false;
      int winLimit = (int)(initialUserCount * ratio);

      for (int i = 0; i < sums.Length; ++i) {
        string text = string.Format("option {0} has {1} of {2} votes", i + 1, sums[i], winLimit + 1);

        if (i + 1 == lastVote) ah.SayBattle(text);

        if (sums[i] > winLimit) {
          winVote = i + 1;
          return true;
        }
        if (sums[i] + votesLeft > winLimit) canDecide = true;
      }
      winVote = 0;
      if (!canDecide) return true; else return false;
    }

    protected bool RegisterVote(TasSayEventArgs e, string[] words, out int vote)
    {
      vote = 0;
      if (words.Length != 1) return false;
      int.TryParse(words[0], out vote);
      if (vote > 0 && vote <= options) { // vote within parameters, lets register it
        lastVote = vote;

        int ind = users.IndexOf(e.UserName);
        Battle b = tas.GetBattle();
        if (b != null) {
          int bidx = b.GetUserIndex(e.UserName);
          if (bidx > -1) if (b.Users[bidx].IsSpectator) return false;
          if (ind == -1) {
            votes.Add(vote);
            users.Add(e.UserName);
          } else {
            votes[ind] = vote;
          }
          return true;
        }
      }
      return false;
    }
  };


  /************************************************************************/
  /*      VOTE MAP                                                        */
  /************************************************************************/
  public class VoteMap : AbstractPoll, IVotable
  {
    string map;

    public VoteMap(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    bool IVotable.Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        AutoHost.Respond(tas, spring, e, "You must specify map name");
        return false;
      }

      string[] vals;
      int[] indexes;
      if (AutoHost.FilterMaps(words, tas, spring, out vals, out indexes) > 0) {
        map = vals[0];
        ah.SayBattle("Do you want to change map to " + map + "? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "Cannot find such map");
        return false;
      }
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - changing map to " + map);
          tas.ChangeMap(spring.UnitSync.MapList[map]);
        } else {
          ah.SayBattle("not enough votes, map stays");
        }
        return true;
      } else return false;
    }
  }

  /************************************************************************/
  /*    VOTE KICK                                                         */
  /************************************************************************/
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
        ah.SayBattle("Do you want to kick " + player + "? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "Cannot find such player");
        return false;
      }
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - kicking " + player);
          ah.ComKick(TasSayEventArgs.Default, new string[] { player });
        } else {
          ah.SayBattle("not enough votes, player stays");
        }
        return true;
      } else return false;
    }
  }

  /************************************************************************/
  /*      VOTE FORCE                                                      */
  /************************************************************************/
  public class VoteForce : AbstractPoll, IVotable
  {
    new const double ratio = 0.50;

    public VoteForce(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        ah.SayBattle("Do you want to force game? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "battle not started yet");
        return false;
      }
    }


    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.ComForce(e, words);
          ah.SayBattle("vote successful - forcing");
        } else {
          ah.SayBattle("not enough votes");
        }
        return true;
      } else return false;
    }
  }


  /************************************************************************/
  /*    VOTE FORCE START                                                  */
  /************************************************************************/
  public class VoteForceStart : AbstractPoll, IVotable
  {
    new const double ratio = 0.50;

    public VoteForceStart(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (!spring.IsRunning) {
        ah.SayBattle("Do you want to force start game? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "battle already started");
        return false;
      }
    }


    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - force starting");
          ah.ComForceStart(e, words);
        } else {
          ah.SayBattle("not enough votes");
        }
        return true;
      } else return false;
    }
  }


  /************************************************************************/
  /*     VOTE EXIT                                                        */
  /************************************************************************/
  public class VoteExit : AbstractPoll, IVotable
  {
    new const double ratio = 0.66;

    public VoteExit(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (spring.IsRunning) {
        ah.SayBattle("Do you want to exit this game? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "game not running");
        return false;
      }
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - force exiting");
          ah.ComExit(e, words);
        } else {
          ah.SayBattle("not enough votes");
        }
        return true;
      } else return false;
    }
  }



  /************************************************************************/
  /*    VOTE REHOST                                                       */
  /************************************************************************/
  public class VoteRehost : AbstractPoll, IVotable
  {
    new const double ratio = 0.66;
    string modname = "";

    public VoteRehost(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        ah.SayBattle("Do you want to rehost this game? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        string[] mods;
        int[] indexes;
        if (AutoHost.FilterMods(words, tas, spring, out mods, out indexes) == 0) {
          AutoHost.Respond(tas, spring, e, "cannot find such mod");
          return false;
        } else {
          modname = mods[0];
          ah.SayBattle("Do you want to rehost this game to " + modname + "? !vote 1 = yes, !vote 2 = no");
          return true;
        }
      }
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - rehosting");

          ah.ComRehost(e, new string[] { modname });
        } else {
          ah.SayBattle("not enough votes");
        }
        return true;
      } else return false;
    }
  }


  /************************************************************************/
  /*     VOTE PRESET                                                      */
  /************************************************************************/
  public class VotePreset : AbstractPoll, IVotable
  {
    int presetId;
    string presetName;

    public VotePreset(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        AutoHost.Respond(tas, spring, e, "You must specify preset name");
        return false;
      }

      string[] vals;
      int[] indexes;
      if (AutoHost.FilterPresets(words, ah, out vals, out indexes) > 0) {
        presetId = indexes[0];
        presetName = vals[0];
        ah.SayBattle("Do you want to apply preset " + presetName + "? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "cannot find such preset");
        return false;
      }
    }


    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful - appling preset " + presetName);
          ah.presets[presetId].Apply(tas);
        } else {
          ah.SayBattle("not enough votes for preset");
        }
        return true;
      } else return false;
    }
  }


  /************************************************************************/
  /*     VOTE KICKSPEC                                                    */
  /************************************************************************/
  public class VoteKickSpec : AbstractPoll, IVotable
  {
    public VoteKickSpec(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    bool stateAfter = false;

    public bool Init(TasSayEventArgs e, string[] words)
    {
      stateAfter = !ah.KickSpectators;
      ah.SayBattle("Do you want to " + (stateAfter ? "ENABLE" : "DISABLE") + " spectator kicking? !vote 1 = yes, !vote 2 = no");
      return true;
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          ah.SayBattle("vote successful");
          ah.ComKickSpec(e, new string[] { stateAfter ? "1" : "0" });
        } else {
          ah.SayBattle("not enough votes to " + (stateAfter ? "ENABLE" : "DISABLE") + " kickspec");
        }
        return true;
      } else return false;
    }
  }


  /************************************************************************/
  /*    VOTE BOSS                                                    */
  /************************************************************************/
  public class VoteBoss : AbstractPoll, IVotable
  {
    string player;

    //new const double ratio = 0.50;

    public VoteBoss(TasClient tas, Spring spring, AutoHost ah) : base(tas, spring, ah) { }

    public bool Init(TasSayEventArgs e, string[] words)
    {
      if (words.Length == 0) {
        if (ah.BossName == "") {
          ah.Respond(e, "there is currently no boss to remove");
          return false;
        } else {
          player = "";
          ah.SayBattle("Do you want to remove current boss " + ah.BossName + "? !vote 1 = yes, !vote 2 = no");
          return true;
        }
      }

      string[] players;
      int[] indexes;
      if (AutoHost.FilterUsers(words, tas, spring, out players, out indexes) > 0) {
        player = players[0];
        ah.SayBattle("Do you want to elect " + player + " for the boss? !vote 1 = yes, !vote 2 = no");
        return true;
      } else {
        AutoHost.Respond(tas, spring, e, "Cannot find such player");
        return false;
      }
    }

    public bool Vote(TasSayEventArgs e, string[] words)
    {
      int vote;
      if (!RegisterVote(e, words, out vote)) {
        AutoHost.Respond(tas, spring, e, "You must vote valid option/not be a spectator");
        return false;
      }

      int winVote;
      if (CheckEnd(out winVote)) {
        if (winVote == 1) {
          if (player == "") ah.SayBattle("vote successful - boss removed"); else
            ah.SayBattle("vote successful - new boss is " + player);
          ah.BossName = player;
        } else {
          ah.SayBattle("not enough votes");
        }
        return true;
      } else return false;
    }
  }



}

