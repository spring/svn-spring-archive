namespace Springie.Client
{
	public class BotBattleStatus : UserBattleStatus
	{
		#region Properties

		public string aiLib;
		public string owner;

		#endregion

		#region Constructors

		public BotBattleStatus(string name, string owner, string aiLib) : base(name)
		{
			this.owner = owner;
			this.aiLib = aiLib;
		}

		#endregion
	} ;
}