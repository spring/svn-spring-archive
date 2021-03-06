#region using

using System;
using System.Net;

#endregion

namespace Springie.Client
{
	public enum SyncStatuses
	{
		Unknown = 0,
		Synced = 1,
		Unsynced = 2
	}

	public class UserBattleStatus : ICloneable
	{
		#region Properties

		public int AllyNumber;
		public IPAddress ip = IPAddress.None;
		public bool IsReady;
		public bool IsSpectator;
		public string name;
		public int port;
		public int Side;
		public SyncStatuses SyncStatus = SyncStatuses.Unknown;
		public int TeamColor;
		public int TeamNumber;

		#endregion

		#region Constructors

		public UserBattleStatus() {}


		public UserBattleStatus(string name)
		{
			this.name = name;
		}

		#endregion

		#region Public methods

		public void SetFrom(int status, int color, string name)
		{
			this.name = name;
			SetFrom(status, color);
		}

		public void SetFrom(int status, int color)
		{
			IsReady = (status & 2) > 0;
			TeamNumber = (status >> 2) & 15;
			AllyNumber = (status >> 6) & 15;
			IsSpectator = (status & 1024) == 0;
			SyncStatus = (SyncStatuses) ((status >> 22) & 3);
			Side = (status >> 24) & 15;
			TeamColor = color;
		}

		#endregion

		#region ICloneable Members

		public virtual object Clone()
		{
			return MemberwiseClone();
		}

		#endregion
	} ;
}