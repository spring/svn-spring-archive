using System.ComponentModel;
using Springie.Client;

namespace Springie.autohost.commands
{
  public class CommandConfig
  {
    public static readonly TasSayEventArgs.Places[] ListenChannelPmBattle = new[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Channel };
    public static readonly TasSayEventArgs.Places[] ListenPmGameBattle = new[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal, TasSayEventArgs.Places.Game };
    public static readonly TasSayEventArgs.Places[] ListenGameBattle = new[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Game };
    public static readonly TasSayEventArgs.Places[] ListenPmBattle = new[] { TasSayEventArgs.Places.Battle, TasSayEventArgs.Places.Normal };

    private int level = 1;
    private int voteLevel = 1;
    private TasSayEventArgs.Places[] listenTo = new[] {TasSayEventArgs.Places.Battle};
    private int throttling = 1;

    [Category("Command")]
    [Description("Rights level. If user's rights level is higher or equal to rights level of command - user has rights to use this command.")]
    public int Level
    {
      get { return level; }
      set { level = value; }
    }
    [Category("Command")]
    [Description("Rights level for voting this command.")]
    public int VoteLevel
    {
      get { return voteLevel; }
      set { voteLevel = value; }
    }


    [Category("Command")]
    [Description("How often can this command be executed (in seconds). 0 = no throttling, can execute at any time.")]
    public int Throttling
    {
      get { return throttling; }
      set { throttling = value; }
    }

    [Category("Command")]
    [Description("From which places can you use this command. Normal = PM to server, Battle = battle lobby, Game = from running game.")]
    public TasSayEventArgs.Places[] ListenTo
    {
      get { return listenTo; }
      set { listenTo = value; }
    }
  } ;
}