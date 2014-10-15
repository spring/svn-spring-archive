using System;

namespace Springie.SpringNamespace
{
	[Serializable]
	public struct ListOption:ICloneable
	{
		#region Properties

		public string Description;
		public string Key;
		public string Name;

		#endregion

		public object Clone()
		{
			return MemberwiseClone();
		}
	}
}