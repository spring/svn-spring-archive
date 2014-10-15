#region using

using System;
using System.Globalization;
using System.Threading;
using System.Windows.Forms;

#endregion

namespace Springie
{
	internal static class Program
	{
		#region Properties

		public static FormMain formMain;

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		public static Main main = new Main();

		public static DateTime startupTime = DateTime.Now;

		#endregion

		#region Other methods

		[STAThread]
		private static void Main()
		{
			// setup unhandled exception handlers
			Application.ThreadException += Application_ThreadException;
			AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
			Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);

			Application.CurrentCulture = CultureInfo.InvariantCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

			//if (!main.Start()) return;
			//while (true) Thread.Sleep(2000);
			try {
				Application.EnableVisualStyles();
				Application.SetCompatibleTextRenderingDefault(false);
				Application.Run(new FormMain());
			} catch (Exception e) {
				if (!ErrorHandling.HandleException(e, "Application exception")) throw;
			}
		}

		#endregion

		// unhandled exception in non-ui thread

		// unhandled exception in gui thread

		#region Event Handlers

		private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
		{
			if (!ErrorHandling.HandleException(e.Exception, "Main thread unhandled exception")) throw e.Exception;
		}

		private static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
		{
			var ex = (Exception) e.ExceptionObject;
			if (!ErrorHandling.HandleException(ex, "Secondary thread unhandled exception")) throw ex;
		}

		#endregion
	}
}