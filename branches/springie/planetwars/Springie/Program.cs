using System;
using System.Globalization;
using System.Threading;
using System.Windows.Forms;

namespace Springie
{
  internal static class Program
  {
    public static FormMain formMain = null;

    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    public static Main main = new Main();

    public static DateTime startupTime = DateTime.Now;

    [STAThread]
    private static void Main()
    {
      // setup unhandled exception handlers
      Application.ThreadException += new ThreadExceptionEventHandler(Application_ThreadException);
      AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(CurrentDomain_UnhandledException);
      Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);

      Application.CurrentCulture = CultureInfo.InvariantCulture;
      Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

      try {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new FormMain());
      } catch (Exception e) {
        if (!ErrorHandling.HandleException(e, "Application exception")) throw;
      }
    }


    // unhandled exception in non-ui thread
    private static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
      Exception ex = (Exception)e.ExceptionObject;
      if (!ErrorHandling.HandleException(ex, "Secondary thread unhandled exception")) throw ex;
    }

    // unhandled exception in gui thread
    private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
    {
      if (!ErrorHandling.HandleException(e.Exception, "Main thread unhandled exception")) throw e.Exception;
    }
  }
}