using System;

namespace Springie.Downloader
{
	public class ShortTorrentInfo:EventArgs
	{
		#region Properties

		public int Hash;
		public string Name;
		public string Type;

		#endregion

		#region Constructors

		public ShortTorrentInfo(string name, int hash, string type)
		{
			Name = name;
			Hash = hash;
			Type = type;
		}

		#endregion
	}
}