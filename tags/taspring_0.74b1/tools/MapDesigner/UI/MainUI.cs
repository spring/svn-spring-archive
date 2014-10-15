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
    class HeightMapSizeDialog
    {
        public delegate void DoneCallback( object source );

        public int width;
        public int height;

		Window window = null;	       
		Combo widthcombo = null;
		Combo heightcombo = null;
        Button button;

        DoneCallback source;
		
		public HeightMapSizeDialog( DoneCallback source )
		{
            this.source = source;

			window = new Window ("Heightmap width and height:");
			window.SetDefaultSize (200, 100);

            Table table = new Table( 3, 2, false );
            table.BorderWidth = 20;
            table.RowSpacing = 20;
            table.ColumnSpacing = 20;
            window.Add(table);

            table.Attach(new Label("Width:"), 0, 1, 0, 1);
            table.Attach(new Label("Height:"), 0, 1, 1, 2);

            widthcombo = new Combo();
            widthcombo.PopdownStrings = new string[]{"4","8","12","16","20","24","28","32"};
            table.Attach(widthcombo, 1, 2, 0, 1);

            heightcombo = new Combo();
            heightcombo.PopdownStrings = new string[]{"4","8","12","16","20","24","28","32"};
            table.Attach(heightcombo, 1, 2, 1, 2);

			Button button = new Button (Stock.Ok);
			button.Clicked += new EventHandler (OnOkClicked);
			button.CanDefault = true;
			
            table.Attach(button, 1, 2, 2, 3);

            window.Modal = true;
            window.ShowAll();
		}

		void OnOkClicked (object o, EventArgs args)
		{
            Console.WriteLine("Ok clicked" );
            Console.WriteLine(widthcombo.Entry.Text);
            width = Convert.ToInt32( widthcombo.Entry.Text);
            height = Convert.ToInt32( heightcombo.Entry.Text);
            window.Hide();
            source( this );
        }
    }
    /*
    class HeightMapSizeDialogOld
    {
        public int width;
        public int height;

        [Widget]
        Entry widthentry;

        [Widget]
        Entry heightentry;

        void ShowWarningMessage(string text)
        {
            Dialog dialog = new MessageDialog(this, DialogFlags.DestroyWithParent, MessageType.Warning, ButtonsType.Ok,
                text );
            dialog.Show();
            dialog.Hide();
        }

        void on_okbutton_clicked(object o, EventArgs e)
        {
            try
            {
                width = Convert.ToInt32(widthentry.Text);
                height = Convert.ToInt32(heightentry.Text);
            }
            catch (Exception e)
            {
                ShowWarningMessage("Please enter the height and width and try again");
                return;
            }
            if ((width - 1) % 32 > 0)
            {
                ShowWarningMessage("Width should be a multiple of 64 + 1, eg 65, 129 or 1025");
                return;
            }
            if ((height - 1) % 32 > 0)
            {
                ShowWarningMessage("Height should be a multiple of 64 + 1, eg 65, 129 or 1025");
                return;
            }
            
        }

        public HeightMapSizeDialogOld()
        {
            Glade.XML app = new Glade.XML("./gtksharptest.glade", "HeightMapSizeDialog", "");
            app.Autoconnect(this);
        }
    }
*/
    public class MainUIWindow
    {
        UICommandQueue commandqueue;

        [Widget]
        HScale brushsize;

        [Widget]
        RadioButton raiselower;
        [Widget]
        RadioButton flatten;

        public MainUIWindow()
        {
            Glade.XML app = new Glade.XML("./gtksharptest.glade", "window1", "");
            app.Autoconnect(this);
            raiselower.Activate();
            commandqueue = UICommandQueue.GetInstance();
        }
        string GetFilePath(string prompt, string defaultfilename)
        {
            using (FileSelection dialog = new FileSelection(prompt))
            {
                dialog.Complete(defaultfilename);
                ResponseType response = (ResponseType)dialog.Run();
                dialog.Hide();
                if (response == ResponseType.Ok)
                {
                    Console.WriteLine("got filepath: " + dialog.Filename);
                    return dialog.Filename;
                }
                else
                {
                    Console.WriteLine("Cancel pressed");
                    return "";
                }
            }
        }
        void on_new_heightmap1_activate(object o, EventArgs e)
        {
            HeightMapSizeDialog sizedialog = new HeightMapSizeDialog(new HeightMapSizeDialog.DoneCallback( on_new_heightmap1_activate_2 ) );
        }
        void on_new_heightmap1_activate_2( object o )
        {
            HeightMapSizeDialog dialog = o as HeightMapSizeDialog;
            commandqueue.Enqueue(new CmdNewHeightMap( dialog.width, dialog.height));
        }
        void on_open_heightmap1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Heightmap open path", "heightmap.bmp");
            if (filepath != "")
            {
                commandqueue.Enqueue(new CmdOpenHeightMap(filepath));
            }
        }
        void on_save_heightmap1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Heightmap save path", "heightmap.bmp");
            if (filepath != "")
            {
                commandqueue.Enqueue(new CmdSaveHeightMap(filepath));
            }
        }
        void on_export_slopemap1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Slopemap export path","slopemap.bmp");
            if (filepath != "")
            {
                commandqueue.Enqueue(new CmdExportSlopeMap(filepath));
            }
        }
        void on_quit1_activate(object o, EventArgs e)
        {
            System.Environment.Exit(0);
        }

        void on_800_x_1_activate(object o, EventArgs e)
        {
        }
        void on_1024_x_2_activate(object o, EventArgs e)
        {
        }
        void on_show_slopemap1_activate(object o, EventArgs e)
        {
        }
        void on_show_movementareas1_activate(object o, EventArgs e)
        {
        }
        void on_refresh_slopemap1_activate(object o, EventArgs e)
        {
        }

        void on_about1_activate(object o, EventArgs e)
        {
            using( Dialog dialog =  new MessageDialog(null, DialogFlags.DestroyWithParent,
                 MessageType.Info, ButtonsType.Close, 
                 "MapDesigner by Hugh Perkins\n\nBuilt using C#, GTK#, GTK, Tao, SDL, OpenGL, Spring" ))
            {
                dialog.Run();
                dialog.Hide();
            }
        }

        void on_flatten_activate(object o, EventArgs e)
        {
            if (flatten.Active)
            {
                Console.WriteLine("flatten clicked" + e.ToString() + " " + ((Gtk.RadioButton)o).Name);
                UICommandQueue.GetInstance().Enqueue(new UICommandBrushEffect(UICommandBrushEffect.BrushEffect.Flatten));
            }
        }

        void on_raiselower_activate(object o, EventArgs e)
        {
            if (raiselower.Active)
            {
                Console.WriteLine("raiselower clicked" + e.ToString() + " " + ((Gtk.RadioButton)o).Name);
                UICommandQueue.GetInstance().Enqueue(new UICommandBrushEffect(UICommandBrushEffect.BrushEffect.RaiseLower));
            }
        }

        public void on_brushsize1_move_slider(object o, EventArgs e)
        {
            Console.WriteLine("New brushsize: " + brushsize.Value.ToString());
            UICommandQueue.GetInstance().Enqueue(new UICommandChangeBrushSize((int)brushsize.Value));
        }
        /*
        Dictionary<Type, List<UICommandHandler>> consumersbycommand = new Dictionary<Type, List<UICommandHandler>>();

        public void RegisterConsumer(Type commandtype, UICommandHandler handler)
        {
            if (!consumersbycommand.ContainsKey(commandtype))
            {
                consumersbycommand.Add(commandtype, new List<UICommandHandler>());
            }
            consumersbycommand[commandtype].Add(handler);
        }
         */
    }

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
        MainUI()
        {
            RendererFactory.GetInstance().Tick += new TickHandler(MainUI_Tick);
            Application.Init();
            uiwindow = new MainUIWindow();
            Application.RunIteration( false);
        }

        void MainUI_Tick()
        {

            while (Application.EventsPending() )
            {
                Application.RunIteration(false);
            }
        }
    }
}
