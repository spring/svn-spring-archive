using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie.AutoHostNamespace
{
  public class Preset
  {
    string name = "<enter name here>";
    [Category("Basic"), Description("Name of this preset")]
    public string Name
    {
      set { name = value; }
      get { return name; }
    }


    string description;
    [Category("Basic"), Description("Brief description of this preset")]
    public string Description
    {
      get { return description; }
      set { description = value; }
    }


    int? startingMetal;
    [Category("Resources"), Description("Starting metal")]
    public int? StartingMetal
    {
      get { return startingMetal; }
      set { startingMetal = value; }
    }

    int? startingEnergy;
    [Category("Resources"), Description("Starting energy")]
    public int? StartingEnergy
    {
      get { return startingEnergy; }
      set { startingEnergy = value; }
    }

    int? maxUnits;
    [Category("Resources"), Description("Maximum units")]
    public int? MaxUnits
    {
      get { return maxUnits; }
      set { maxUnits = value; }
    }


    BattleStartPos? startPos;
    [Category("Game rules"), Description("Starting position")]
    public BattleStartPos? StartPos
    {
      get { return startPos; }
      set { startPos = value; }
    }

    BattleEndCondition? endCondition;
    [Category("Game rules"), Description("End condition - should continue when comm dies")]
    public BattleEndCondition? EndCondition
    {
      get { return endCondition; }
      set { endCondition = value; }
    }


    int? limitDgun;
    [Category("Game rules"), Description("Limit dgun to start position, 0 = no limit, 1 = limited")]
    public int? LimitDgun
    {
      get { return limitDgun; }
      set { limitDgun = value; }
    }

    int? diminishingMM;
    [Category("Game rules"), Description("Diminishing metal maker outputs, 0 = normal mm, 1 = diminishing mm")]
    public int? DiminishingMM
    {
      get { return diminishingMM; }
      set { diminishingMM = value; }
    }

    int? ghostedBuildings;
    [Category("Game rules"), Description("Ghosted buildings, 0 = no ghosted buildings, 1 = ghosted buildings")]
    public int? GhostedBuildings
    {
      get { return ghostedBuildings; }
      set { ghostedBuildings = value; }
    }


    bool enableAllUnits = false;
    [Category("Units"), Description("Should this preset enable all units before disabling")]
    public bool EnableAllUnits
    {
      get { return enableAllUnits; }
      set { enableAllUnits = value; }
    }

    private UnitInfo[] disabledUnits = new UnitInfo[0];
    [Category("Units"), Description("Units to disable")]
    public UnitInfo[] DisabledUnits
    {
      get { return disabledUnits; }
      set { disabledUnits = value; }
    }

    public void Apply(TasClient tas)
    {
      Battle b = tas.GetBattle();
      if (b == null) return;
      BattleDetails d = b.Details;

      if (startingMetal.HasValue) d.StartingMetal = startingMetal.Value;
      if (startingEnergy.HasValue) d.StartingEnergy = startingEnergy.Value;
      if (maxUnits.HasValue) d.MaxUnits = maxUnits.Value;
      if (startPos.HasValue) d.StartPos = startPos.Value;
      if (endCondition.HasValue) d.EndCondition = endCondition.Value;
      if (limitDgun.HasValue) d.LimitDgun = limitDgun.Value;
      if (diminishingMM.HasValue) d.DiminishingMM = diminishingMM.Value;
      if (ghostedBuildings.HasValue) d.GhostedBuildings = ghostedBuildings.Value;

      d.Validate();
      tas.UpdateBattleDetails(d);

      if (enableAllUnits) tas.EnableAllUnits();
      if (disabledUnits.Length > 0) {
        tas.DisableUnits(UnitInfo.ToStringList(disabledUnits));
      }
    }

    public override string ToString()
    {
      string ret = "";

      if (startingMetal.HasValue) ret += "metal: " + startingMetal.Value + "\n";
      if (startingEnergy.HasValue) ret += "energy: " + startingEnergy.Value + "\n";
      if (maxUnits.HasValue) ret += "units: " + maxUnits.Value + "\n";
      if (startPos.HasValue) ret += "start position: " + startPos.Value + "\n";
      if (endCondition.HasValue) ret += "comm end: " + endCondition.Value + "\n";
      if (limitDgun.HasValue) ret += "limit dgun: " + limitDgun.Value + "\n";
      if (diminishingMM.HasValue) ret += "diminishing mm: " + diminishingMM.Value + "\n";
      if (ghostedBuildings.HasValue) ret += "ghosted buildings: " + ghostedBuildings.Value + "\n";

      for (int i = 0; i < disabledUnits.Length; ++i) ret += "Disable " + disabledUnits[i].Name + " (" + disabledUnits[i].FullName + ")\n";

      if (ret == "") ret = "no changes";
      return ret;
    }

  }
}
