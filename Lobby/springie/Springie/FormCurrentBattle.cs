#region using

using System;
using System.ComponentModel;
using System.Windows.Forms;
using Springie.autohost;
using Springie.Client;
using Springie.SpringNamespace;

#endregion

namespace Springie
{
	public partial class FormCurrentBattle : Form
	{
		#region Fields

		private CurrentBattle bat = new CurrentBattle();

		#endregion

		#region Constructors

		public FormCurrentBattle()
		{
			InitializeComponent();
		}

		#endregion

		#region Other methods

		private void LoadCurrentData()
		{
			var b = Program.main.Tas.GetBattle();
			if (b != null) {
				bat.BattleDetails = b.Details;
				bat.Map = b.Map.Name;
				bat.Locked = b.IsLocked;

				bat.DisabledUnits = UnitInfo.FromStringList(b.DisabledUnits.ToArray(), b.Mod);
			}
		}

		private void SaveCurrentData()
		{
			var b = Program.main.Tas.GetBattle();
			if (b != null) {
				Program.main.Tas.UpdateBattleDetails(bat.BattleDetails);
				Program.main.Tas.ChangeLock(bat.Locked);
				Program.main.Tas.ChangeMap(Program.main.Spring.UnitSyncWrapper.GetMapInfo(bat.Map));
				Program.main.Tas.EnableAllUnits();

				Program.main.Tas.DisableUnits(UnitInfo.ToStringList(bat.DisabledUnits));
			}
		}

		private void Tas_Changed(object sender, TasEventArgs e)
		{
			LoadCurrentData();
		}

		#endregion

		#region Event Handlers

		private void button1_Click(object sender, EventArgs e)
		{
			SaveCurrentData();
		}

		private void FormCurrentBattle_Load(object sender, EventArgs e)
		{
			LoadCurrentData();
			propertyGrid1.SelectedObject = bat;
		}

		#endregion

		#region Nested type: CurrentBattle

		protected class CurrentBattle
		{
			#region Properties

			[Category("Details")]
			[Description("Battle details")]
			public BattleDetails BattleDetails { get; set; }

			[Category("Disabled units")]
			[Description("List of currently disabled units")]
			public UnitInfo[] DisabledUnits { get; set; }

			[Category("Basic")]
			[Description("Is game locked?")]
			public bool Locked { get; set; }

			[Category("Basic")]
			[Description("Current map")]
			[TypeConverter(typeof (AutoHostConfig.MapConverter))]
			public string Map { get; set; }

			#endregion
		} ;

		#endregion
	}
}