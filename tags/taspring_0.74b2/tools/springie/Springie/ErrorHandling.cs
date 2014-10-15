using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;

namespace Springie
{
  public class ErrorHandling
  {
    const string LogFile = "springie_errors.txt";
    const string ReportUrl = "http://springie.licho.eu/error.php";

    /// <summary>
    /// Handles one exception (saves to log file and sends to website)
    /// </summary>
    /// <param name="e">exception to be handled</param>
    /// <param name="moreInfo">additional information</param>
    /// <returns>returns true if exception was handled, false if called should rethrow</returns>
    public static bool HandleException(Exception e, string moreInfo) {
      try {
        // write to error log
        StreamWriter s = File.AppendText(Application.StartupPath + '/' + LogFile);
        s.WriteLine("===============\r\n{0}\r\n{1}\r\n{2}\r\n", DateTime.Now.ToString("g"), moreInfo, e);
        s.Close();

        // send to error gathering site
        WebClient wc = new WebClient();
        string urtext = string.Format("{0}?username={1}&springie={2}&moreinfo={3}&exception={4}", ReportUrl, Program.main.config.AccountName, MainConfig.SpringieVersion, moreInfo+"", e);
        wc.DownloadString(new Uri(urtext));
       
      } catch {}
      
      try {
        // optionally display messagebox
        if (Program.main.config.ErrorHandlingMode == MainConfig.ErrorHandlingModes.MessageBox) MessageBox.Show(e.ToString(), moreInfo);
      } catch {}
      
      if (Program.main.config.ErrorHandlingMode == MainConfig.ErrorHandlingModes.Debug) return false; else return true;
    }
  }
}
