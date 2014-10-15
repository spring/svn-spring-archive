using System;
using System.ComponentModel;
using System.Windows.Forms;
using Springie.autohost;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie
{
  public partial class FormCurrentBattle : Form
  {
    private CurrentBattle bat = new CurrentBattle();

    public FormCurrentBattle()
    {
      InitializeComponent();
    }

    private void LoadCurrentData()
    {
      Battle b = Program.main.Tas.GetBattle();
      if (b != null) {
        bat.BattleDetails = b.Details;
        bat.Map = b.Map.Name;
        bat.Locked = b.IsLocked;

        bat.DisabledUnits = UnitInfo.FromStringList(b.DisabledUnits.ToArray(), b.Mod);
      }
    }

    private void SaveCurrentData()
    {
      Battle b = Program.main.Tas.GetBattle();
      if (b != null) {
        Program.main.Tas.UpdateBattleDetails(bat.BattleDetails);
        Program.main.Tas.ChangeLock(bat.Locked);
        Program.main.Tas.ChangeMap(Program.main.Spring.UnitSync.GetMapInfo(bat.Map));
        Program.main.Tas.EnableAllUnits();

        Program.main.Tas.DisableUnits(UnitInfo.ToStringList(bat.DisabledUnits));
      }
    }

    private void FormCurrentBattle_Load(object sender, EventArgs e)
    {
      LoadCurrentData();
      propertyGrid1.SelectedObject = bat;
    }

    private void Tas_Changed(object sender, TasEventArgs e)
    {
      LoadCurrentData();
    }

    private void button1_Click(object sender, EventArgs e)
    {
      SaveCurrentData();
    }

    #region Nested type: CurrentBattle
    protected class CurrentBattle
    {
      private BattleDetails battleDetails;
      private UnitInfo[] disabledUnits;
      private bool locked;
      private string map;

      [Category("Basic")]
      [Description("Current map")]
      [TypeConverter(typeof(AutoHostConfig.MapConverter))]
      public string Map
      {
        get { return map; }
        set { map = value; }
      }

      [Category("Basic")]
      [Description("Is game locked?")]
      public bool Locked
      {
        get { return locked; }
        set { locked = value; }
      }


      [Category("Details")]
      [Description("Battle details")]
      public BattleDetails BattleDetails
      {
        get { return battleDetails; }
        set { battleDetails = value; }
      }

      [Category("Disabled units")]
      [Description("List of currently disabled units")]
      public UnitInfo[] DisabledUnits
      {
        get { return disabledUnits; }
        set { disabledUnits = value; }
      }
    } ;
    #endregion
  }
}