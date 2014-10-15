using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.ComponentModel;
using System.Xml.Serialization;

namespace Springie.AutoHostNamespace
{
  public class BannedUser
  {
    string name;
    [Description("Original name")]
    public string Name
    {
      get { return name; }
      set { name = value;}
    }

    string reason;
    [Description("Reason of the ban")]
    public string Reason
    {
      get { return reason; }
      set { reason = value; }
    }


    TimeSpan duration;
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


    DateTime started;
    [Description("Ban start time")]
    public DateTime Started
    {
      get { return started; }
      set { started = value; }
    }

    public BannedUser() { }

    public BannedUser(string name)
    {
      this.name = name;
      this.started = DateTime.Now;
      this.nickNames.Add(name);
    }

    [XmlIgnore]
    public bool Expired
    {
      get { return (Started + Duration < DateTime.Now); }
    }

    public List<string> ipAddresses = new List<string>();
    public List<string> nickNames = new List<string>();
  }
}
