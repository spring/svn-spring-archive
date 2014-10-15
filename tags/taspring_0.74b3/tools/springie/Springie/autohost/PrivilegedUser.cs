using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace Springie.AutoHostNamespace
{
  public class PrivilegedUser
  {
    string name;
    [Category("User"), Description("Nickname used in spring lobby")]
    public string Name
    {
      get { return name; }
      set { name = value; }
    }
    int level;

    [Category("User"), Description("Rights level. If rights level is higher or equal to rights level of command - user has rights to use that command.")]
    public int Level
    {
      get { return level; }
      set { level = value; }
    }
    public PrivilegedUser()
    {
    }
    public PrivilegedUser(string name, int level)
    {
      this.name = name;
      this.level = level;
    }
  };
}
