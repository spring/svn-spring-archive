using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie
{
  public partial class FormCurrentBattle : Form
  {
    protected class CurrentBattle {

      private string map;
      [Category("Basic"), Description("Current map"), TypeConverter(typeof(Springie.AutoHostNamespace.AutoHostConfig.MapConverter))]
      public string Map
      {
        get { return map; }
        set { map = value; }
      }

      private bool locked;
      [Category("Basic"), Description("Is game locked?")]
      public bool Locked
      {
        get { return locked; }
        set { locked = value; }
      }

      
      private BattleDetails battleDetails;
      [Category("Details"), Description("Battle details")]
      public BattleDetails BattleDetails
      {
        get { return battleDetails; }
        set { battleDetails = value; }
      }
      
      private UnitInfo[] disabledUnits;
      [Category("Disabled units"), Description("List of currently disabled units")]
      public UnitInfo[] DisabledUnits
      {
        get { return disabledUnits; }
        set { disabledUnits = value; }
      }

    };

    CurrentBattle bat = new CurrentBattle();

    public FormCurrentBattle()
    {
      InitializeComponent();
    }

    private void LoadCurrentData() {
      Battle b = Program.main.Tas.GetBattle();     
      if (b!=null) {
        bat.BattleDetails = b.Details;
        bat.Map = b.Map.Name;
        bat.Locked = b.IsLocked;

        bat.DisabledUnits = UnitInfo.FromStringList(b.DisabledUnits.ToArray(), b.Mod);
      }
    }

    private void SaveCurrentData() {
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

    void Tas_Changed(object sender, TasEventArgs e)
    {
      LoadCurrentData();
    }

    private void button1_Click(object sender, EventArgs e)
    {
      SaveCurrentData();
    }

  }
}