using System;

namespace Springie.SpringNamespace
{
	[Serializable]
	public class MapInfo
	{
		#region Fields

		protected string archiveName;

		#endregion

		#region Properties

		public int Checksum { get; set; }


		public string Name { get; private set; }

		#endregion

		#region Constructors

		public MapInfo(string name)
		{
			Name = name;
		}

		#endregion

		#region Overrides

		public override string ToString()
		{
			return Name;
		}

		#endregion
	} ;
}