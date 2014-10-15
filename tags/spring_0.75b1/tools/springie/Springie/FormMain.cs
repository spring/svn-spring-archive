using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Springie;
using System.Threading;
using System.Globalization;
using Springie.Properties;
using Springie.Client;
using Springie.AutoHostNamespace;
using System.Diagnostics;

namespace Springie
{
  public partial class FormMain : Form
  {
    bool exitOnSpringExit = false;
    RichTextBox tServer;
    RichTextBox tBattle;
    Main main = Program.main;
    ToolStripMenuItem hostingPriorityMenu;

    public FormMain()
    {
      Program.formMain = this;
      InitializeComponent();
    }

    private delegate void Event(object sender, EventArgs args);

    private delegate void TasEvent(object sender, TasEventArgs args);

    public void OnFailure(object sender, TasEventArgs args)
    {
      if (InvokeRequired) Invoke(new TasEvent(OnFailure), sender, args);
      else {
        string mes = "Command failed:";
        tServer.AppendText(mes + Utils.Glue(args.ServerParams.ToArray()) + "\r\n");
      }
    }



    private delegate void SayEvent(object sender, TasSayEventArgs args);
    public void OnSaid(object sender, TasSayEventArgs args)
    {
      if (InvokeRequired) Invoke(new SayEvent(OnSaid), sender, args);
      else {
        switch (args.Place) {
          case TasSayEventArgs.Places.Broadcast:
          case TasSayEventArgs.Places.MessageBox:
          case TasSayEventArgs.Places.Motd:
            tServer.AppendText("[" + DateTime.Now.ToString("T") + "] " + args.Text + "\r\n");
            break;

          case TasSayEventArgs.Places.Channel:
            RichTextBox t = GetTab("#" + args.Channel);
            t.AppendText(String.Format("[{0}] <{1}> {2}\r\n", DateTime.Now.ToString("T"), args.UserName, args.Text));
            break;

          case TasSayEventArgs.Places.Normal:
            t = GetTab(args.Channel);
            t.AppendText(String.Format("[{0}] <{1}> {2}\r\n", DateTime.Now.ToString("T"), args.UserName, args.Text));
            break;

          case TasSayEventArgs.Places.Battle:
            tBattle.AppendText(String.Format("[{0}] <{1}> {2}\r\n", DateTime.Now.ToString("T"), args.UserName, args.Text));
            break;
        }
      }
    }


    private RichTextBox GetTab(string name)
    {
      if (tabControl.TabPages.ContainsKey(name)) return (RichTextBox)tabControl.TabPages[name].Controls[0];
      tabControl.TabPages.Add(name, name);
      RichTextBox rt = new RichTextBox();
      rt.ForeColor = Color.Black;
      rt.ReadOnly = true;
      rt.BackColor = Color.White;
      rt.Dock = DockStyle.Fill;
      rt.TextChanged += new EventHandler(rt_TextChanged);
      tabControl.TabPages[tabControl.TabPages.Count - 1].Controls.Add(rt);
      return rt;
    }

    void rt_TextChanged(object sender, EventArgs e)
    {
      RichTextBox rt = (RichTextBox)sender;
      rt.ScrollToCaret();
    }

    private void Form1_Load(object sender, EventArgs e)
    {
      notifyIcon1.Icon = Resources.err;
      if (!Program.main.Start()) return;

      main.Tas.Failure += OnFailure;
      main.Tas.Said += OnSaid;
      main.Tas.Connected += new EventHandler<TasEventArgs>(Tas_Connected);
      main.Tas.ConnectionLost += new EventHandler<TasEventArgs>(Tas_ConnectionLost);
      main.Tas.UserAdded += new EventHandler<TasEventArgs>(Tas_UserAdded);
      main.Tas.UserRemoved += new EventHandler<TasEventArgs>(Tas_UserRemoved);
      main.Tas.BattleUserJoined += new EventHandler<TasEventArgs>(Tas_BattleUserJoined);
      main.Tas.BattleUserStatusChanged += new EventHandler<TasEventArgs>(Tas_BattleUserStatusChanged);
      main.Tas.UserStatusChanged += new EventHandler<TasEventArgs>(Tas_UserStatusChanged);

      main.Tas.BattleUserLeft += new EventHandler<TasEventArgs>(Tas_BattleUserLeft);
      main.Tas.ChannelJoined += new EventHandler<TasEventArgs>(Tas_ChannelJoined);
      main.Tas.ChannelLeft += new EventHandler<TasEventArgs>(Tas_ChannelLeft);
      main.Tas.BattleClosed += new EventHandler<TasEventArgs>(Tas_BattleClosed);
      main.Tas.BattleOpened += new EventHandler<TasEventArgs>(Tas_BattleOpened);
      main.Tas.BattleMapChanged += new EventHandler<TasEventArgs>(Tas_BattleMapChanged);
      main.Spring.SpringStarted += new EventHandler(Spring_SpringStarted);
      main.Spring.SpringExited += new EventHandler(Spring_SpringExited);


      // hosting priority submenu
      hostingPriorityMenu = new ToolStripMenuItem("Hosting priority");
      springToolStripMenuItem.DropDownItems.Add(hostingPriorityMenu);
      foreach (ProcessPriorityClass p in Enum.GetValues((typeof(ProcessPriorityClass)))) {
        ToolStripMenuItem ts = new ToolStripMenuItem(p.ToString());
        ts.Click += new EventHandler(ts_PriorityChangeClick);
        if (p == main.config.HostingProcessPriority) ts.Checked = true;
        hostingPriorityMenu.DropDownItems.Add(ts);
      }
      hostingPriorityMenu.Enabled = false;

      // tabs
      tabControl.TabPages.Clear();
      tServer = GetTab("$server");
      tBattle = GetTab("@battle");


    }

    void Tas_BattleUserStatusChanged(object sender, TasEventArgs e)
    {
      UpdateStatusInfo();
    }

    void Tas_BattleMapChanged(object sender, TasEventArgs e)
    {
      UpdateStatusInfo();
    }

    void Tas_BattleOpened(object sender, TasEventArgs e)
    {
      UpdateStatusInfo();
    }


    
    void ts_PriorityChangeClick(object sender, EventArgs e)
    {
      ToolStripMenuItem i = sender as ToolStripMenuItem;
      if (i != null) {
        ToolStripMenuItem parent = i.OwnerItem as ToolStripMenuItem; // get parent
        if (parent != null) {
          ProcessPriorityClass prio = (ProcessPriorityClass)Enum.Parse(typeof(ProcessPriorityClass), i.Text);
          UpdateSpringPriorityMenu(parent, prio);
          main.Spring.ProcessPriority = prio;
        }
      }
    }

    void Tas_BattleClosed(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_BattleClosed), sender, e);
      else {
        listBoxBattle.Items.Clear();
      }
    }

    void Tas_UserStatusChanged(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_UserStatusChanged), sender, e);
      else {
        string nam = e.ServerParams[0];
        int i = GetUserIndex(listBoxChannel, nam);
        if (i != -1) {
          listBoxChannel.Items[i] = UpdateNameWithCountryAfkAndGame(nam);
        }

        i = GetUserIndex(listBoxBattle, nam);
        if (i != -1) {
          listBoxBattle.Items[i] = UpdateNameWithCountryAfkAndGame(nam);
        }
      }
    }

    private int GetUserIndex(System.Windows.Forms.ListBox lb, string name)
    {
      for (int i = 0; i < lb.Items.Count; ++i) {
        if (lb.Items[i].ToString().StartsWith(name + " ")) return i;
      }
      return -1;
    }

    void Tas_ChannelLeft(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_ChannelLeft), sender, e);
      else tabControl.TabPages.RemoveByKey("#" + e.ServerParams[0]);
    }

    void Tas_ChannelJoined(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_ChannelJoined), sender, e);
      else GetTab("#" + e.ServerParams[0]);
    }

    void Tas_ConnectionLost(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_ConnectionLost), sender, e);
      else {
        notifyIcon1.Icon = Resources.err;
        listBoxBattle.Items.Clear();
        listBoxChannel.Items.Clear();
        rehostToolStripMenuItem.Enabled = false;
      }
    }

    void Spring_SpringExited(object sender, EventArgs e)
    {
      if (InvokeRequired) Invoke(new Event(Spring_SpringExited), sender, e);
      else {
        notifyIcon1.Icon = Resources.ok;
        foreach (ToolStripMenuItem t in springToolStripMenuItem.DropDownItems) {
          t.Enabled = false;
        }
         if (exitOnSpringExit) {
          Close();
        }
        
        UpdateStatusInfo();
      }
    }

    void Spring_SpringStarted(object sender, EventArgs e)
    {
      if (InvokeRequired) Invoke(new Event(Spring_SpringStarted), sender, e);
      else {
        notifyIcon1.Icon = Resources.run;
        
        foreach (ToolStripMenuItem t in springToolStripMenuItem.DropDownItems) {
          t.Enabled = true;
        }
        UpdateSpringPriorityMenu(hostingPriorityMenu, main.config.HostingProcessPriority);
        showhideHostingWindowToolStripMenuItem.Checked = main.Spring.SpringWindowHidden;
        
        UpdateStatusInfo();
      }
    }


    private void UpdateSpringPriorityMenu(ToolStripMenuItem menu, ProcessPriorityClass priority) {
      foreach (ToolStripMenuItem c in menu.DropDownItems) { // list through priorities
        if (c.Text == priority.ToString()) {  // we found priority, set it up
          c.Checked = true;
        } else c.Checked = false;
      }
    }

    void Tas_BattleUserLeft(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_BattleUserLeft), sender, e);
      else {
        UpdateStatusInfo();
        int i = GetUserIndex(listBoxBattle, e.ServerParams[0]);
        if (i != -1) listBoxBattle.Items.RemoveAt(i);
      }
    }

    void Tas_BattleUserJoined(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_BattleUserJoined), sender, e);
      else {
        UpdateStatusInfo();
        string nam = e.ServerParams[0];
        for (int i = 0; i < listBoxBattle.Items.Count; ++i) {
          if (nam.CompareTo(listBoxBattle.Items[i].ToString()) == -1) {
            listBoxBattle.Items.Insert(i, UpdateNameWithCountryAfkAndGame(nam));
            return;
          }
        }
        listBoxBattle.Items.Add(UpdateNameWithCountryAfkAndGame(nam));
      }
    }

    void Tas_UserRemoved(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_UserRemoved), sender, e);
      else {
        int i = GetUserIndex(listBoxChannel, e.ServerParams[0]);
        if (i != -1) listBoxChannel.Items.RemoveAt(i);
      }
    }


    private string UpdateNameWithCountryAfkAndGame(string name)
    {
      User u;
      if (main.Tas.GetExistingUser(name, out u)) return name + " <" + u.country + ">{" + (u.isAway ? "A" : "") + (u.isInGame ? "G" : "") + "}";
      else return name + " ";
    }


    void Tas_UserAdded(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_UserAdded), sender, e);
      else {
        string nam = e.ServerParams[0];
        for (int i = 0; i < listBoxChannel.Items.Count; ++i) {
          if (nam.CompareTo(listBoxChannel.Items[i].ToString()) == -1) {
            listBoxChannel.Items.Insert(i, UpdateNameWithCountryAfkAndGame(nam));
            return;
          }
        }
        listBoxChannel.Items.Add(UpdateNameWithCountryAfkAndGame(nam));
      }
    }



    void Tas_Connected(object sender, TasEventArgs e)
    {
      if (InvokeRequired) Invoke(new TasEvent(Tas_Connected), sender, e);
      else {
        tServer.AppendText("Connected to server\r\n");
        notifyIcon1.Icon = Resources.ok;
        rehostToolStripMenuItem.Enabled = true;
      }
    }


    private void textBox_KeyDown(object sender, KeyEventArgs e)
    {
      if (e.KeyCode == Keys.Enter && textBox.Text.Length > 0) {
        if (!main.Tas.IsConnected) return;
        string tab = tabControl.SelectedTab.Name;
        switch (tab[0]) {
          case '@':
            main.Tas.Say(TasClient.SayPlace.Battle, "", textBox.Text, false);
            if (main.config.RedirectGameChat) main.Spring.SayGame(textBox.Text);
            break;
          case '#':
            main.Tas.Say(TasClient.SayPlace.Channel, tab.Substring(1), textBox.Text, false);
            break;
          case '$':
            return;
          default:
            User u;
            if (!main.Tas.GetExistingUser(tab, out u)) {
              GetTab(tab).AppendText("ERROR: user left\r\n");
            } else main.Tas.Say(TasClient.SayPlace.User, tab, textBox.Text, false);
            break;
        }
        textBox.Text = "";
      }
    }

    private void listBox_SelectedIndexChanged(object sender, EventArgs e)
    {
      ListBox l = (ListBox)sender;
      string name = l.SelectedItem as string;
      if (string.IsNullOrEmpty(name)) return;
      name = (name.Split(' '))[0];
      GetTab(name);
      tabControl.SelectedTab = tabControl.TabPages[name];
    }


    private void tabControl_MouseDown(object sender, MouseEventArgs e)
    {
      if (e.Button == MouseButtons.Right) {
        int ind = 0;
        for (int i = 0; i < tabControl.TabPages.Count; i++) {
          if (tabControl.GetTabRect(i).Contains(e.Location)) {
            ind = i;
            break;
          }
        }
        if (ind > 1 && ind < tabControl.TabCount) {
          if (tabControl.TabPages[ind].Name[0] != '#') tabControl.TabPages.RemoveAt(ind);
        }
      }
    }

    private void notifyIcon1_Click(object sender, EventArgs e)
    {
      if (WindowState == FormWindowState.Minimized) {
        Visible = true;
        WindowState = FormWindowState.Normal;
      } else {
        WindowState = FormWindowState.Minimized;
        Visible = false;
      }
    }


    private void Form1_SizeChanged(object sender, EventArgs e)
    {
      if (this.WindowState == FormWindowState.Minimized) {
        Visible = false;
      }
    }


    private delegate void DelegEmpty();
    public void GetNewLogPass()
    {
      if (InvokeRequired) Invoke(new DelegEmpty(GetNewLogPass));
      else {
        FormAccount p = new FormAccount();
        p.ShowDialog();
        if (p.DialogResult == DialogResult.OK) {
          main.config.AccountName = p.Login;
          main.config.AccountPassword = p.Password;
          main.SaveConfig();
          main.AutoHost.config.PrivilegedUsers.Add(new PrivilegedUser(p.Login, 4));
          main.AutoHost.SaveConfig();
          main.ReLogin();
        }
      }
    }

    private void FormMain_FormClosing(object sender, FormClosingEventArgs e)
    {
      try {
        if (e.CloseReason == CloseReason.UserClosing && main.Spring.IsRunning) {
          DialogResult res = MessageBox.Show("You are currently hosting a game, do you want to wait till game end and then exit springie?", "Game in progress", MessageBoxButtons.YesNoCancel);
          exitOnSpringExit = false;
          if (res == DialogResult.No) main.Stop();
          else if (res == DialogResult.Cancel) {
            e.Cancel = true;
            return;
          } else if (res == DialogResult.Yes) {
            exitOnSpringExit = true;
            e.Cancel = true;
            return;
          }
        } else main.Stop();
      } catch {}
    }


    private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
    {
      FormSettings s = new FormSettings();
      if (s.ShowDialog() == DialogResult.OK) {
        main.SaveConfig();
        main.AutoHost.SaveConfig();
      }
    }

    private void rehostToolStripMenuItem_Click(object sender, EventArgs e)
    {
      if (!main.Tas.IsConnected || !main.Tas.IsLoggedIn) main.ReLogin(); else 
      main.AutoHost.ComRehost(TasSayEventArgs.Default, new string[] { });
    }

    private void reloadModsMapsToolStripMenuItem_Click(object sender, EventArgs e)
    {
      main.Spring.Reload(true, true);
    }

    private void showhideHostingWindowToolStripMenuItem_Click(object sender, EventArgs e)
    {
      ToolStripMenuItem i = sender as ToolStripMenuItem;
      main.Spring.SpringWindowHidden = !main.Spring.SpringWindowHidden;
      i.Checked = main.Spring.SpringWindowHidden;
    }


    private void UpdateStatusInfo() {
      if (InvokeRequired) Invoke(new DelegEmpty(UpdateStatusInfo)); else 
      try {
        if (!main.Tas.IsLoggedIn) return;
        Client.Battle b = main.Tas.GetBattle();
        if (b == null) return;

        int players = b.Users.Count - b.CountSpectators();

        toolStripStatusLabel1.Text = "on since: " + Program.startupTime.ToString("g");
        toolStripStatusLabel2.Text = "players: " + players + "/" + b.MaxPlayers;
        toolStripStatusLabel3.Text = "mod: " + b.Mod.Name;
        toolStripStatusLabel4.Text = "map: " + b.Map.Name;
        toolStripStatusLabel5.Text = "last game: " + (main.Spring.GameStarted != DateTime.MinValue ? main.Spring.GameStarted.ToString("g") : "never");

        

        if (!main.Spring.IsRunning) {
          if (players > 0) {
            if (notifyIcon1.Icon != Resources.joined) notifyIcon1.Icon = Resources.joined;
          } else if (notifyIcon1.Icon != Resources.ok) notifyIcon1.Icon = Resources.ok;
        }

        notifyIcon1.Text = players + "/" + b.MaxPlayers + "\r\n" + b.Map.Name + "\r\n" + (main.Spring.GameStarted != DateTime.MinValue ? main.Spring.GameStarted.ToString("g") : "never");
      } catch {}
    }

    private void currentBattleToolStripMenuItem_Click(object sender, EventArgs e)
    {
      FormCurrentBattle s = new FormCurrentBattle();
      s.ShowDialog();
    }
  }
}
