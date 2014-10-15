using System;
using System.Collections.Generic;
using System.Text;
using System.Timers;
using Springie.Client;

namespace Springie.AutoHostNamespace
{
  public class UnSyncKicker : IDisposable
  {
    List<string> users = new List<string>();
    List<DateTime> times = new List<DateTime>();
    const int timeout = 20;
    TasClient tas;
    Timer checkTimer = new Timer(timeout * 1000);

    public UnSyncKicker(TasClient tas) {
      this.tas = tas;
      checkTimer.Elapsed += new ElapsedEventHandler(checkTimer_Elapsed);
      checkTimer.Enabled = true;
      tas.BattleUserJoined += new EventHandler<TasEventArgs>(tas_BattleUserJoined);
      tas.BattleUserLeft += new EventHandler<TasEventArgs>(tas_BattleUserLeft);
    }

    void tas_BattleUserLeft(object sender, TasEventArgs e)
    {
      RemoveUser(e.ServerParams[0]);
    }

    void tas_BattleUserJoined(object sender, TasEventArgs e)
    {
      AddUser(e.ServerParams[0]);
    }

    void checkTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
      KickUnsynced(tas);
    }

    protected void RemoveUser(string name) {
      int id = users.IndexOf(name);
      if (id != -1) {
        users.RemoveAt(id);
        times.RemoveAt(id);
      }
    }
    
    protected void AddUser(string name) {
      RemoveUser(name);
      users.Add(name);
      times.Add(DateTime.Now);
    }

    protected void KickUnsynced(TasClient tas) {
      for (int i = 0; i < users.Count; ++i) {
        UserBattleStatus u;
        if (tas.IsConnected && tas.GetBattle().ContainsUser(users[i], out u)) {
          if (u.SyncStatus == SyncStatuses.Unknown && (DateTime.Now - times[i]) > TimeSpan.FromSeconds(timeout)) {
            tas.Kick(users[i]);
          }
        }
      }
    }


    public void Close() {
      if (checkTimer != null) {
        checkTimer.Enabled = false;
        checkTimer = null;
      }
    }

    public void Reset() {
      users.Clear();
      times.Clear();
    }

    #region IDisposable Members

    public void Dispose()
    {
      Close();
    }

    #endregion
  }
}
