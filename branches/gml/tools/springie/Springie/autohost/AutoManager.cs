using System;
using System.Threading;
using System.Timers;
using Springie.autohost;
using Springie.Client;
using Springie.SpringNamespace;
using Timer=System.Timers.Timer;

namespace Springie.AutoHostNamespace
{
  public class AutoManager
  {
    private const int KickAfter = 300;
    private const int RingEvery = 60;
    private const int SpecAfkAfter = 60;
    private const int SpecForceAfter = 120;

    private AutoHost ah;
    private int from;
    private DateTime lastRing = DateTime.Now;
    private Spring spring;
    private TasClient tas;
    private Timer timer = new Timer(5000);

    private int to;

    private DateTime waitForReadySince = DateTime.Now;
    private bool waitReady = false;

    public AutoManager(AutoHost ah, TasClient tas, Spring spring)
    {
      this.ah = ah;
      this.tas = tas;
      this.spring = spring;
      timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
      timer.Start();
    }

    public bool Enabled
    {
      get { return from > 0; }
    }


    private void timer_Elapsed(object sender, ElapsedEventArgs e)
    {
      lock (timer) {
        timer.Stop();
        try {
          if (from > 0 && !spring.IsRunning) {
            Battle b = tas.GetBattle();
            if (b != null) {
              int plrCnt = b.CountPlayers();
              if (plrCnt >= from && plrCnt <= to) {
                string notReady;
                bool isReady = ah.AllReadyAndSynced(out notReady);
                if (plrCnt%2 == 0) {
                  int allyno;
                  if (!ah.BalancedTeams(out allyno)) {
                    ah.ComFix(TasSayEventArgs.Default, new string[] {});
                    ah.ComFixColors(TasSayEventArgs.Default, new string[] {});
                    ah.BalanceTeams(2, false);
                  }
                }
                if (isReady) {
                  Thread.Sleep(1000);
                  if (!spring.IsRunning) ah.ComStart(TasSayEventArgs.Default, new string[] {});
                } else {
                  DateTime now = DateTime.Now;
                  if (!waitReady) {
                    waitReady = true;
                    waitForReadySince = now;
                  }
                  if (plrCnt > from && plrCnt%2 == 1 && b.IsLocked) ah.ComAutoLock(TasSayEventArgs.Default, new string[] {(plrCnt + 1).ToString()});

                  if (now.Subtract(lastRing).TotalSeconds > RingEvery) {
                    lastRing = now;
                    ah.ComRing(TasSayEventArgs.Default, new string[] {});
                  }

                  if (plrCnt > from && now.Subtract(waitForReadySince).TotalSeconds > SpecForceAfter) ah.ComForceSpectator(TasSayEventArgs.Default, new string[] {notReady});

                  if (now.Subtract(waitForReadySince).TotalSeconds > SpecAfkAfter) ah.ComForceSpectatorAfk(TasSayEventArgs.Default, new string[] {});
                  if (now.Subtract(waitForReadySince).TotalSeconds > KickAfter) ah.ComKick(TasSayEventArgs.Default, new string[] {notReady});
                }
              } else {
                if (b.IsLocked && plrCnt < from) ah.ComAutoLock(TasSayEventArgs.Default, new string[] {to.ToString()});
                else if (plrCnt > to) {
                  string notready;
                  if (!ah.AllReadyAndSynced(out notready)) ah.ComForceSpectator(TasSayEventArgs.Default, new string[] {notready});
                }
                waitReady = false;
              }
            }
          } else {
            lastRing = DateTime.Now;
            waitReady = false;
          }
        } finally {
          timer.Start();
        }
      }
    }

    public void Manage(int from, int to)
    {
      if (to < from) to = from;
      this.from = from;
      this.to = to;
      timer.Start();
    }

    public void Stop()
    {
      from = 0;
      to = 0;
      lock (timer) {
        timer.Stop();
      }
    }
  }
}