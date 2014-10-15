// Copyright Hugh Perkins 2006
// hughperkins@gmail.com http://manageddreams.com
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
// 1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
//

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Threading;
using System.Globalization;

namespace MapDesigner
{
    class EntryPoint
    {
        // this is just to test error traps:
        public static void TestCrash()
        {
            int a = 5; int b = 0;
            int c = a / b; // crash here
            a = c; // remove warning message on compile
        }

        public static void Main()
        {
            try
            {
                Thread.CurrentThread.CurrentCulture = new CultureInfo("en-GB");
                // TestCrash();
                new MapDesigner().Go();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                StreamWriter sw = new StreamWriter("error.log", true);

                sw.WriteLine("=======================================================================");
                sw.WriteLine("");
                sw.WriteLine("Unfortunately, MapDesigner experienced a critical error");
                sw.WriteLine("Here is the error report.  It's very technical, but it will mean something");
                sw.WriteLine("to the developer.");
                sw.WriteLine("Can you email this to hughperkins@gmail.com please, and we'll have a look at it.");
                sw.WriteLine("");
                sw.WriteLine("=======================================================================");
                sw.WriteLine(DateTime.Now.ToString());
                sw.WriteLine(System.Environment.Version.ToString() + " " + System.Environment.ProcessorCount.ToString() + " " + System.Environment.OSVersion.ToString() );
                try
                {
                    sw.WriteLine( File.GetLastWriteTime( EnvironmentHelper.GetExeFilename() ) );
                }
                catch( Exception e2 )
                {
                    sw.WriteLine(e2.ToString());
                }
                sw.WriteLine(e.ToString());
                sw.WriteLine("");
                try
                {
                    sw.WriteLine("logfile:");
                    LogFile.GetInstance().Shutdown();
                    StreamReader sr = new StreamReader(LogFile.GetInstance().Filename);
                    string logfilecontents = sr.ReadToEnd();
                    sw.WriteLine(logfilecontents);
                    sw.WriteLine();
                }
                catch( Exception e2 )
                {
                    Console.WriteLine("Error writing logfile: " + e2.ToString());
                }
                sw.Close();

                ProcessStartInfo processstartinfo = new ProcessStartInfo();
                processstartinfo.FileName = "notepad";
                processstartinfo.UseShellExecute = true;
                processstartinfo.CreateNoWindow = false;
                processstartinfo.RedirectStandardOutput = false;
                processstartinfo.Arguments = "error.log";

                Process process;
                process = Process.Start(processstartinfo);
            }
        }
    }
}
