using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Timers;
using System.Windows.Forms;
using Springie.Client;
using Springie.SpringNamespace;
using Timer=System.Timers.Timer;

namespace Springie
{
  internal class AutoUpdater
  {
    /************************************************************************/
    /*    PRIVATE ATTRIBS                                                   */
    /************************************************************************/

    private const int updateCheckInterval = 1; //in minutes
    private const string updateSite = "http://springie.licho.eu/";
    private Spring spring;
    private TasClient tas;
    private Timer timer;

    /************************************************************************/
    /*    PUBLIC METHODS                                                    */
    /************************************************************************/

    /// <summary>
    /// Initializes auto downloader
    /// </summary>
    public AutoUpdater(Spring spring, TasClient tas)
    {
      this.spring = spring;
      this.tas = tas;

      timer = new Timer();
      timer.Interval = updateCheckInterval*1000*60;
      timer.AutoReset = true;
      timer.Elapsed += timer_Elapsed;
      timer.Start();
      spring.SpringExited += spring_SpringExited;
    }

    private bool enabled
    {
      get { return Program.main.config.AutoUpdate; }
    }

    private void timer_Elapsed(object sender, ElapsedEventArgs e)
    {
      updateSpringie();
    }

    private void spring_SpringExited(object sender, EventArgs e)
    {
      updateSpringie();
    }


    /************************************************************************/
    /*    PRIVATE METHODS                                                   */
    /************************************************************************/

    private void updateSpringie()
    {
      if (enabled && !spring.IsRunning) {
        timer.Enabled = false;

        UpdateCa();

        using (WebClient wc = new WebClient()) {
          try {
            string remoteVersion = wc.DownloadString(updateSite + "version.txt").Trim();
            if (!string.IsNullOrEmpty(remoteVersion) && remoteVersion != MainConfig.SpringieVersion.Trim()) {
              string target = Application.ExecutablePath;
              target = target.Remove(target.LastIndexOf('.'));
              target += ".upd";

              tas.Say(TasClient.SayPlace.Battle, "", "Springie is now downloading new version", true);
              wc.DownloadFile(updateSite + "springie.upd", target);

              File.Delete(Application.ExecutablePath + ".bak");
              File.Move(Application.ExecutablePath, Application.ExecutablePath + ".bak");
              File.Move(target, Application.ExecutablePath);
              tas.Say(TasClient.SayPlace.Battle, "", "Springie is auto-upgrading to newer version, rejoin please", true);

              Process.Start(Application.ExecutablePath);
              Application.Exit();
            }
          } catch (WebException) {}
        }
        timer.Enabled = true;
      }
    }

    private static int ExtractVersionNumber(string modname)
    {
      int ver = 0;
      Match m = Regex.Match(modname, "\\-([0-9]+)");
      if (m.Success) int.TryParse(m.Groups[1].Value, out ver);
      return ver;
    }


    private void UpdateCa()
    {
      if (Program.main.config.CaUpdating == MainConfig.CaUpdateMode.None) return;

      Battle b = tas.GetBattle();
      if (b != null) {
        spring.Reload(true, false);
        string selMod = b.Mod.Name;
        int vers = int.MinValue;
        foreach (string s in spring.UnitSync.ModList.Keys) {
          if (s.Contains("Complete Annihilation")) {
            if ((Program.main.config.CaUpdating == MainConfig.CaUpdateMode.Stable && s.Contains("stable")) || Program.main.config.CaUpdating == MainConfig.CaUpdateMode.Latest) {
              int nv = ExtractVersionNumber(s);
              if (nv > vers) {
                vers = nv;
                selMod = s;
              }
            }
          }
        }

        if (b.Mod.Name != selMod) {
          tas.Say(TasClient.SayPlace.Battle, "", "Springie is now rehosting to new version of CA - " + selMod, true);
          Program.main.AutoHost.ComRehost(TasSayEventArgs.Default, new string[] {selMod});
        }
      }
    }
  }
}