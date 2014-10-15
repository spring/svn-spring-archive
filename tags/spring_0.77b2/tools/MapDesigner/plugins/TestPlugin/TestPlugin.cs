using System;
using Gtk;
using MapDesigner;

public class TestPlugin
{
    public void Load()
    {
        Console.WriteLine("testplugin starting");
        bool pluginsmenufound = false;
        Menu pluginsmenu = null;
        foreach (Widget widget in MainUI.GetInstance().uiwindow.menubar1.Children)
        {
            Console.WriteLine(widget.Name + " " + widget.GetType().ToString());
            MenuItem menuitem = widget as MenuItem;
            foreach (Widget subwidget in menuitem.Children)
            {
                Console.WriteLine(subwidget.Name + " " + subwidget.GetType().ToString());
                AccelLabel accellabel = subwidget as AccelLabel;
                Console.WriteLine(accellabel.Text);
                if (accellabel.Text.ToLower() == "plugins")
                {
                    pluginsmenufound = true;
                    pluginsmenu = menuitem.Submenu as Menu;
                }
            }
        }
        if (!pluginsmenufound)
        {
            MenuItem pluginsmenuitem = new MenuItem("Plugins");
            MainUI.GetInstance().uiwindow.menubar1.Add(pluginsmenuitem);
            pluginsmenu = new Menu();
            pluginsmenuitem.Submenu = pluginsmenu;
            pluginsmenuitem.ShowAll();
        }
        MenuItem Testpluginmenuitem = new MenuItem("About TestPlugin...");
        Testpluginmenuitem.Activated += new EventHandler(Testpluginmenuitem_Activated);
        pluginsmenu.Add(Testpluginmenuitem);

        Testpluginmenuitem.Show();
        pluginsmenu.ShowAll();
    }

    void Testpluginmenuitem_Activated(object sender, EventArgs e)
    {
        MainUI.GetInstance().uiwindow.InfoMessage("Example of manipulating main window from plugin");
    }
}
