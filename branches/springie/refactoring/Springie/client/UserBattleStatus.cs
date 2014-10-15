using System.Net;

namespace Springie.Client
{
  public enum SyncStatuses : int
  {
    Unknown = 0,
    Synced = 1,
    Unsynced = 2
  }

  public struct UserBattleStatus
  {
    public int AllyNumber;
    public IPAddress ip;
    public bool IsReady;
    public bool IsSpectator;
    public string name;
    public int port;
    public int Side;
    public SyncStatuses SyncStatus;
    public int TeamColor;
    public int TeamNumber;

    public UserBattleStatus(string name)
    {
      this.name = name;
      IsReady = false;
      TeamNumber = 0;
      AllyNumber = 0;
      IsSpectator = false;
      SyncStatus = SyncStatuses.Unknown;
      Side = 0;
      TeamColor = 0;
      port = 0;
      ip = IPAddress.None;
    }

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
      SyncStatus = (SyncStatuses)(int)((status >> 22) & 3);
      Side = (status >> 24) & 15;
      TeamColor = color;
    }
  } ;
}