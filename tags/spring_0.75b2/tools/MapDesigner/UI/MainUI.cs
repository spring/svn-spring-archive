// Copyright Hugh Perkins 2004,2005,2006
// hughperkins@gmail.com http://manageddreams.com
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 2 as published by the
// Free Software Foundation;
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
using System.Threading;
using Gtk;
using Glade;

namespace MapDesigner
{
    public class MainUI
    {
        /*
        public delegate void ClickEvent(Widget widget);
        public delegate void DoubleEvent(Widget widget, double value);
        public delegate void StringEvent(Widget widget, string value);
         */

        static MainUI instance = new MainUI();
        public static MainUI GetInstance() { return instance; }

        public MainUIWindow uiwindow;
        public FeaturesDialog featuresdialog;
        MainUI()
        {
            RendererFactory.GetInstance().Tick += new TickHandler(MainUI_Tick);
            Application.Init();
            uiwindow = new MainUIWindow();
            featuresdialog = new FeaturesDialog();
            //Application.RunIteration( false);
        }

        void MainUI_Tick()
        {
            try
            {
                while (Application.EventsPending())
                {
                    Application.RunIteration(false);
                }
                uiwindow.Tick();
            }
            catch (Exception e)
            {
                LogFile.GetInstance().WriteLine(e.ToString());
            }
        }
    }
}
