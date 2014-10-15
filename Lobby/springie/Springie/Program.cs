#region using

using System;
using System.Globalization;
using System.IO;
using System.Threading;
using System.Windows.Forms;

#endregion

namespace Springie
{
	internal static class Program
	{
		#region Properties

		public static FormMain formMain;
		public static bool GuiEnabled = true;
		public static bool IsLinux = Environment.OSVersion.Platform == PlatformID.Unix;

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		public static Main main;

		public static DateTime startupTime = DateTime.Now;

		public static string WorkPath;

		#endregion

		#region Other methods

		[STAThread]
		private static void Main(string[] args)
		{
			// setup unhandled exception handlers
			Application.ThreadException += Application_ThreadException;
			AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
			Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);

			Application.CurrentCulture = CultureInfo.InvariantCulture;
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

			WorkPath = Application.StartupPath;
			if (WorkPath == "") WorkPath = Directory.GetCurrentDirectory();

			if (args.Length > 0 && args[0] == "-nogui") {
				if (args.Length > 1) WorkPath = Utils.Glue(args, 1);
				GuiEnabled = false;
			} else if (args.Length > 0) WorkPath = Utils.Glue(args);

			main = new Main();


			if (GuiEnabled) {
				try {
					Application.EnableVisualStyles();
					Application.SetCompatibleTextRenderingDefault(false);
					Application.Run(new FormMain());
				} catch (Exception e) {
					if (!ErrorHandling.HandleException(e, "Application exception")) throw;
				}
			} else {
				if (!main.Start()) return;
				while (true) Thread.Sleep(5000);
			}
		}

		#endregion

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