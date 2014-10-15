#region using

using System;
using System.IO;
using System.Net;
using System.Windows.Forms;

#endregion

namespace Springie
{
	public class ErrorHandling
	{
		#region Constants

		private const string LogFile = "springie_errors.txt";
		private const string ReportUrl = "http://springie.licho.eu/error.php";

		#endregion

		#region Public methods

		/// <summary>
		/// Handles one exception (saves to log file and sends to website)
		/// </summary>
		/// <param name="e">exception to be handled</param>
		/// <param name="moreInfo">additional information</param>
		/// <returns>returns true if exception was handled, false if called should rethrow</returns>
		public static bool HandleException(Exception e, string moreInfo)
		{
			try {
				// write to error log
				var s = File.AppendText(Application.StartupPath + '/' + LogFile);
				s.WriteLine("===============\r\n{0}\r\n{1}\r\n{2}\r\n", DateTime.Now.ToString("g"), moreInfo, e);
				s.Close();

				// send to error gathering site
				var wc = new WebClient();
				string urtext = string.Format("{0}?username={1}&springie={2}&moreinfo={3}&exception={4}", ReportUrl, Program.main.config.AccountName, MainConfig.SpringieVersion, moreInfo + "", e);
				wc.DownloadString(new Uri(urtext));
			} catch {}

			try {
				// optionally display messagebox
				if (Program.main.config.ErrorHandlingMode == MainConfig.ErrorHandlingModes.MessageBox) MessageBox.Show(e.ToString(), moreInfo);
			} catch {}

			if (Program.main.config.ErrorHandlingMode == MainConfig.ErrorHandlingModes.Debug) return false;
			else return true;
		}

		#endregion
	}
}