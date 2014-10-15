using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;
using System.Net.Sockets;
using System.Text.RegularExpressions;
using System.Collections;
using Springie.Client;
using Springie.SpringNamespace;
using System.Timers;
using System.Windows.Forms;

namespace Springie
{
  class AutoUpdater
  {

    /************************************************************************/
    /*    PRIVATE ATTRIBS                                                   */
    /************************************************************************/
    bool enabled
    {
      get { return Program.main.config.AutoUpdate; }
    }

    System.Timers.Timer timer;
    Spring spring;
    TasClient tas;

    const int updateCheckInterval = 1; //in minutes
    const string updateSite = "http://springie.licho.eu/";

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

      timer = new System.Timers.Timer();
      timer.Interval = updateCheckInterval * 1000 * 60;
      timer.AutoReset = true;
      timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
      timer.Start();

      spring.SpringExited += new EventHandler(spring_SpringExited);
    }

    void timer_Elapsed(object sender, ElapsedEventArgs e)
    {
      updateSpringie();
    }

    void spring_SpringExited(object sender, EventArgs e)
    {
      updateSpringie();
    }



    void timer_Tick(object sender, EventArgs e)
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

              System.Diagnostics.Process.Start(Application.ExecutablePath);
              Application.Exit();
            }
          } catch (WebException) {
          }

          //UpdateCa();
        }
        timer.Enabled = true;
      }
    }

    private void UpdateCa()
    {
      using (WebClient wc = new WebClient()) {
        try {
          string remoteVersion = wc.DownloadString("http://files.caspring.org/snapshots/latest_revision").Trim();
          if (!string.IsNullOrEmpty(remoteVersion) && remoteVersion != Program.main.config.CaVersion.Trim()) {

            tas.Say(TasClient.SayPlace.Battle, "", "Springie is now downloading new version of CA - " + remoteVersion, true);
            string url = String.Format("http://files.caspring.org/snapshots/r{0}/ca-r{0}.sdz", remoteVersion);
            Program.main.config.CaVersion = remoteVersion;
            Program.main.SaveConfig();
            Program.main.AutoHost.ComDlMod(TasSayEventArgs.Default, new string[] { url });
          }
        } catch (WebException) {
        }
      }
    }

  }
}
