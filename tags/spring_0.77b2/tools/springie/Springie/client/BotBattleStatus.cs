using System.Net;

namespace Springie.Client
{
  public class BotBattleStatus:UserBattleStatus
  {
    public string aiLib;
    public string owner;

    public BotBattleStatus(string name, string owner, string aiLib): base(name)
    {
      this.owner = owner;
      this.aiLib = aiLib;
    }
  } ;
}