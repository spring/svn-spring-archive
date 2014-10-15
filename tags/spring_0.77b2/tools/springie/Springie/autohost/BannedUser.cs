using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;

namespace Springie.autohost
{
  public class BannedUser
  {
    private TimeSpan duration;
    public List<string> ipAddresses = new List<string>();
    private string name;
    public List<string> nickNames = new List<string>();

    private string reason;
    private DateTime started;
    public BannedUser() {}

    public BannedUser(string name)
    {
      this.name = name;
      started = DateTime.Now;
      nickNames.Add(name);
    }

    [Description("Original name")]
    public string Name
    {
      get { return name; }
      set { name = value; }
    }

    [Description("Reason of the ban")]
    public string Reason
    {
      get { return reason; }
      set { reason = value; }
    }


    [Description("Ban duration")]
    [XmlIgnore]
    public TimeSpan Duration
    {
      get { return duration; }
      set { duration = value; }
    }

    [Browsable(false)]
    public string XmlDuration
    {
      get { return duration.ToString(); }
      set { duration = TimeSpan.Parse(value); }
    }


    [Description("Ban start time")]
    public DateTime Started
    {
      get { return started; }
      set { started = value; }
    }

    [XmlIgnore]
    public bool Expired
    {
      get { return (Started + Duration < DateTime.Now); }
    }
  }
}