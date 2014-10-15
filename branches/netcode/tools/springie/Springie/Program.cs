using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Springie
{
  static class Program
  {
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    public static Main main = new Main();
    public static FormMain formMain = null;
    public static DateTime startupTime = DateTime.Now;

    [STAThread]
    static void Main()
    {
      // setup unhandled exception handlers
      Application.ThreadException += new System.Threading.ThreadExceptionEventHandler(Application_ThreadException);
      AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(CurrentDomain_UnhandledException);
      Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);

      Application.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;
     
      try {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new FormMain());
      } catch (Exception e) {
        if (!ErrorHandling.HandleException(e, "Application exception")) throw;
      }
    }

    
    // unhandled exception in non-ui thread
    static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
      Exception ex = (Exception)e.ExceptionObject;
      if (!ErrorHandling.HandleException(ex, "Secondary thread unhandled exception")) throw ex;
    }

    // unhandled exception in gui thread
    static void Application_ThreadException(object sender, System.Threading.ThreadExceptionEventArgs e)
    {
      if (!ErrorHandling.HandleException(e.Exception, "Main thread unhandled exception")) throw e.Exception;
    }
  }
}