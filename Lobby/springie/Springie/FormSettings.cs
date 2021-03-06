#region using

using System;
using System.Windows.Forms;
using Springie.autohost;

#endregion

namespace Springie
{
	public partial class FormSettings : Form
	{
		#region Constructors

		public FormSettings()
		{
			InitializeComponent();
		}

		#endregion

		/************************************************************************/
		/*      ADMINS                                                          */
		/************************************************************************/

		#region Other methods

		private void LoadAdmins()
		{
			listBoxAdmins.Items.Clear();
			listBoxAdmins.Items.Add("[ Add new admin... ]");
			foreach (var p in Program.main.AutoHost.config.PrivilegedUsers) listBoxAdmins.Items.Add(p.Name);
		}

		private void LoadPresets()
		{
			listBoxPresets.Items.Clear();
			listBoxPresets.Items.Add("[ Add new preset... ]");
			foreach (var p in Program.main.AutoHost.presets) listBoxPresets.Items.Add(p.Name);
		}

		#endregion

		#region Event Handlers

		private void buttonAdd_Click(object sender, EventArgs e)
		{
			var pu = propertyGrid5.SelectedObject as PrivilegedUser;
			if (!String.IsNullOrEmpty(pu.Name)) {
				Program.main.AutoHost.config.PrivilegedUsers.Add((PrivilegedUser) propertyGrid5.SelectedObject);
				propertyGrid5.SelectedObject = new PrivilegedUser();
				LoadAdmins();
				buttonAdd.Visible = false;
			}
		}

		private void buttonDelete_Click(object sender, EventArgs e)
		{
			if (listBoxAdmins.SelectedIndex > 0) {
				Program.main.AutoHost.config.PrivilegedUsers.RemoveAt(listBoxAdmins.SelectedIndex - 1);
				LoadAdmins();
				buttonDelete.Visible = false;
			}
		}


		/************************************************************************/
		/*    PRESETS                                                           */
		/************************************************************************/

		private void buttonPresetAdd_Click(object sender, EventArgs e)
		{
			var pu = propertyPreset.SelectedObject as Preset;
			if (!String.IsNullOrEmpty(pu.Name)) {
				Program.main.AutoHost.presets.Add((Preset) propertyPreset.SelectedObject);
				propertyPreset.SelectedObject = new Preset();
				LoadPresets();
				buttonPresetAdd.Visible = false;
			}
		}

		private void buttonPresetDelete_Click(object sender, EventArgs e)
		{
			if (listBoxPresets.SelectedIndex > 0) {
				Program.main.AutoHost.presets.RemoveAt(listBoxPresets.SelectedIndex - 1);
				LoadPresets();
				buttonPresetDelete.Visible = false;
			}
		}

		private void FormSettings_Load(object sender, EventArgs e)
		{
			propertyGrid1.SelectedObject = Program.main.config;
			propertyGrid2.SelectedObject = Program.main.AutoHost.config;

			foreach (var c in Program.main.AutoHost.config.Commands) listBox1.Items.Add(c.Name);

			propertyGrid5.TextChanged += propertyGrid5_TextChanged;
			LoadAdmins();
			LoadPresets();
		}

		private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
		{
			propertyGrid4.SelectedObject = Program.main.AutoHost.config.Commands[listBox1.SelectedIndex];
		}

		private void listBoxAdmins_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (listBoxAdmins.SelectedIndex == -1) return;
			if (listBoxAdmins.SelectedIndex == 0) {
				propertyGrid5.SelectedObject = new PrivilegedUser();
				buttonDelete.Visible = false;
				buttonAdd.Visible = true;
			} else {
				propertyGrid5.SelectedObject = Program.main.AutoHost.config.PrivilegedUsers[listBoxAdmins.SelectedIndex - 1];
				buttonDelete.Visible = true;
				buttonAdd.Visible = false;
			}
		}

		private void listBoxPresets_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (listBoxPresets.SelectedIndex == -1) return;
			if (listBoxPresets.SelectedIndex == 0) {
				propertyPreset.SelectedObject = new Preset();
				buttonPresetDelete.Visible = false;
				buttonPresetAdd.Visible = true;
			} else {
				propertyPreset.SelectedObject = Program.main.AutoHost.presets[listBoxPresets.SelectedIndex - 1];
				buttonPresetDelete.Visible = true;
				buttonPresetAdd.Visible = false;
			}
		}

		private void propertyGrid5_TextChanged(object sender, EventArgs e)
		{
			LoadAdmins();
		}

		#endregion
	}
}