using System;
using System.Collections.Generic;
using System.Text;
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
    public string name;
    public bool IsReady;
    public int TeamNumber;
    public int AllyNumber;
    public bool IsSpectator;
    public SyncStatuses SyncStatus;
    public int Side;
    public int TeamColor;
    public IPAddress ip;
    public int port;

    public UserBattleStatus(string name)
    {
      this.name = name;
      this.IsReady = false;
      this.TeamNumber = 0;
      this.AllyNumber = 0;
      this.IsSpectator = false;
      this.SyncStatus = SyncStatuses.Unknown;
      this.Side = 0;
      this.TeamColor = 0;
      this.port = 0;
      this.ip = IPAddress.None;
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
  };
}
