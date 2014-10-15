#region using

using System.ComponentModel;

#endregion

namespace Springie.autohost
{
	public class PrivilegedUser
	{
		#region Properties

		[Category("User")]
		[Description("Rights level. If rights level is higher or equal to rights level of command - user has rights to use that command.")]
		public int Level { get; set; }

		[Category("User")]
		[Description("Nickname used in spring lobby")]
		public string Name { get; set; }

		#endregion

		#region Constructors

		public PrivilegedUser() {}

		public PrivilegedUser(string name, int level)
		{
			this.Name = name;
			this.Level = level;
		}

		#endregion
	} ;
}