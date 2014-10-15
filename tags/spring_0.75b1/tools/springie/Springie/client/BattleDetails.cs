using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace Springie.Client
{
  public enum BattleStartPos : int
  {
    Fixed = 0,
    Random = 1,
    Choose = 2
  }

  public enum BattleEndCondition : int
  {
    Continues = 0,
    Ends = 1
  }

  [TypeConverter(typeof(BattleDetails.BattleDetailsConverter))]
  public class BattleDetails : ICloneable
  {
    protected class BattleDetailsConverter : ExpandableObjectConverter
    {
      public override object ConvertTo(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, Type destinationType)
      {
        if (destinationType == typeof(string)) {
          BattleDetails b = (BattleDetails)value;
          return "Position:" + b.StartPos + "; Comm:" + b.EndCondition + "; Dgun:" + b.LimitDgun;
        } else return base.ConvertTo(context, culture, value, destinationType);
      }
    }


    public static BattleDetails Default = new BattleDetails();

    int startingMetal = 1000;
    [Category("Resources"), Description("Starting metal")]
    public int StartingMetal
    {
      get { return startingMetal; }
      set { startingMetal = value; }
    }

    int startingEnergy = 1000;
    [Category("Resources"), Description("Starting energy")]
    public int StartingEnergy
    {
      get { return startingEnergy; }
      set { startingEnergy = value; }
    }
    int maxUnits = 500;

    [Category("Resources"), Description("Maximum units")]
    public int MaxUnits
    {
      get { return maxUnits; }
      set { maxUnits = value; }
    }


    BattleStartPos startPos = BattleStartPos.Choose;

    [Category("Game rules"), Description("Starting position")]
    public BattleStartPos StartPos
    {
      get { return startPos; }
      set { startPos = value; }
    }

    BattleEndCondition endCondition = BattleEndCondition.Continues;

    [Category("Game rules"), Description("End condition - should continue when comm dies")]
    public BattleEndCondition EndCondition
    {
      get { return endCondition; }
      set { endCondition = value; }
    }


    int limitDgun = 1;

    [Category("Game rules"), Description("Limit dgun to start position")]
    public int LimitDgun
    {
      get { return limitDgun; }
      set { limitDgun = value; }
    }
    int diminishingMM = 0;

    [Category("Game rules"), Description("Diminishing metal maker outputs")]
    public int DiminishingMM
    {
      get { return diminishingMM; }
      set { diminishingMM = value; }
    }

    int ghostedBuildings = 1;

    [Category("Game rules"), Description("Ghosted buildings")]
    public int GhostedBuildings
    {
      get { return ghostedBuildings; }
      set { ghostedBuildings = value; }
    }

    public void Validate()
    {
      if (startingMetal < 0) startingMetal = Default.startingMetal;
      if (startingEnergy < 0) startingEnergy = Default.startingEnergy;
      if (maxUnits < 0) maxUnits = Default.maxUnits;
      if (limitDgun < 0) limitDgun = Default.limitDgun;
      if (diminishingMM < 0) diminishingMM = Default.diminishingMM;
      if (ghostedBuildings < 0) ghostedBuildings = Default.ghostedBuildings;
    }

    public void AddToParamList(List<object> objList)
    {
      Validate();
      objList.Add(startingMetal);
      objList.Add(startingEnergy);
      objList.Add(maxUnits);
      objList.Add((int)startPos);
      objList.Add((int)endCondition);
      objList.Add(limitDgun);
      objList.Add(diminishingMM);
      objList.Add(ghostedBuildings);
    }

    #region ICloneable Members

    public object Clone()
    {
      return this.MemberwiseClone();
    }

    #endregion
  };

}
