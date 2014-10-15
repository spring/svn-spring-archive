using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Springie.AutoHostNamespace;

namespace Springie
{

  public partial class FormSettings : Form
  {
    public FormSettings()
    {
      InitializeComponent();
    }

    private void LoadAdmins() {
      listBoxAdmins.Items.Clear();
      listBoxAdmins.Items.Add("[ Add new admin... ]");
      foreach (PrivilegedUser p in Program.main.AutoHost.config.PrivilegedUsers) {
        listBoxAdmins.Items.Add(p.Name);
      }
    }

    private void FormSettings_Load(object sender, EventArgs e)
    {
      propertyGrid1.SelectedObject = Program.main.config;
      propertyGrid2.SelectedObject = Program.main.AutoHost.config;
      propertyGridBattleDetail.SelectedObject = Program.main.AutoHost.config.BattleDetails;
      foreach (CommandConfig c in Program.main.AutoHost.config.Commands) {
        listBox1.Items.Add(c.Name);
      }

      propertyGrid5.TextChanged += new EventHandler(propertyGrid5_TextChanged);
      LoadAdmins();
    }

    void propertyGrid5_TextChanged(object sender, EventArgs e)
    {
      LoadAdmins();
    }


    private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
    {
      propertyGrid4.SelectedObject = Program.main.AutoHost.config.Commands[listBox1.SelectedIndex];
    }

    private void listBoxAdmins_SelectedIndexChanged(object sender, EventArgs e)
    {
      if (listBoxAdmins.SelectedIndex == -1) return;
      if (listBoxAdmins.SelectedIndex==0) {
        propertyGrid5.SelectedObject = new PrivilegedUser();
        buttonDelete.Visible = false;
        buttonAdd.Visible = true;
      } else {
        propertyGrid5.SelectedObject = Program.main.AutoHost.config.PrivilegedUsers[listBoxAdmins.SelectedIndex - 1];
        buttonDelete.Visible = true;
        buttonAdd.Visible = false;
      }
    }

    private void buttonAdd_Click(object sender, EventArgs e)
    {
      PrivilegedUser pu = propertyGrid5.SelectedObject as PrivilegedUser;
      if (!String.IsNullOrEmpty(pu.Name)) {
        Program.main.AutoHost.config.PrivilegedUsers.Add((PrivilegedUser)propertyGrid5.SelectedObject);
        propertyGrid5.SelectedObject = new PrivilegedUser();
        LoadAdmins();
      }
    }

    private void buttonDelete_Click(object sender, EventArgs e)
    {
      if (listBoxAdmins.SelectedIndex > 0) {
        Program.main.AutoHost.config.PrivilegedUsers.RemoveAt(listBoxAdmins.SelectedIndex - 1);
        LoadAdmins();
      }
    }

    private void apply_battle_details_Click(object sender, EventArgs e)
    {
      if (Program.main.Tas.IsConnected) {
        Program.main.Tas.UpdateBattleDetails((Springie.Client.TasClient.BattleDetails)propertyGridBattleDetail.SelectedObject);
      }
    }

  }
}