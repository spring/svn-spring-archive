#region using

using System;
using System.Collections.Generic;
using Springie.autohost;
using Springie.Client;
using Springie.Downloader;

#endregion

namespace Springie
{
	/// <summary>
	/// Class responsible for providing map links
	/// </summary>
	public class ResourceLinkProvider
	{
		#region Constants

		private const int RequestTimeout = 60; // inerval in seconds

		#endregion

		#region FileType enum

		public enum FileType
		{
			Map,
			Mod
		}

		#endregion

		#region Fields

		private object locker = new object();

		private List<LinkRequest> requests = new List<LinkRequest>();

		#endregion

		#region Public methods

		public void Downloader_LinksRecieved(object sender, ResourceLinks e)
		{
			lock (locker) {
				var todel = new List<LinkRequest>();
				foreach (var request in requests) {
					if (DateTime.Now.Subtract(request.Created).TotalSeconds > RequestTimeout) todel.Add(request);
					else if (request.Hash == e.Checksum) foreach (var s in e.Mirrors) Program.main.AutoHost.Respond(request.SayArgs, s);
				}
				requests.RemoveAll(todel.Contains);
			}
		}


		public void FindLinks(string[] words, FileType type, TasClient tas, TasSayEventArgs e)
		{
			if (words.Length == 0) {
				var b = tas.GetBattle();
				if (b == null) return;
				Program.main.AutoHost.Respond(e, string.Format("Getting SpringDownloader mirrors for currently hosted {0}", type));
				if (type == FileType.Map) RequestLink(new LinkRequest(b.Map.Checksum, e));
				else RequestLink(new LinkRequest(b.Mod.Checksum, e));
			} else {
				List<string> items;
				if (type == FileType.Map) items = new List<string>(Program.main.Spring.UnitSyncWrapper.MapList.Keys);
				else items = new List<string>(Program.main.Spring.UnitSyncWrapper.ModList.Keys);

				int[] resultIndexes;
				string[] resultVals;
				int cnt = AutoHost.Filter(items.ToArray(), words, out resultVals, out resultIndexes);
				if (cnt == 0) Program.main.AutoHost.Respond(e, string.Format("No such {0} found", type));
				Program.main.AutoHost.Respond(e, string.Format("Getting SpringDownloader mirrors for {0}, please wait", resultVals[0]));

				int hash = type == FileType.Map ? Program.main.Spring.UnitSyncWrapper.MapList[resultVals[0]].Checksum : Program.main.Spring.UnitSyncWrapper.ModList[resultVals[0]].Checksum;

				RequestLink(new LinkRequest(hash, e));
			}
		}

		#endregion

		#region Other methods

		private void RequestLink(LinkRequest request)
		{
			lock (locker) requests.Add(request);
			Program.main.Spring.UnitSyncWrapper.Downloader.RequestLinksForHash(request.Hash);
		}

		#endregion

		#region Nested type: LinkRequest

		private class LinkRequest
		{
			#region Properties

			public DateTime Created;
			public int Hash;
			public TasSayEventArgs SayArgs;

			#endregion

			#region Constructors

			public LinkRequest(int hash, TasSayEventArgs sayArgs)
			{
				Hash = hash;
				SayArgs = sayArgs;
				Created = DateTime.Now;
			}

			#endregion
		}

		#endregion
	}
}