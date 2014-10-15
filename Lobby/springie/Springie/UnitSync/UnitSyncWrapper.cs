#region using

using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Remoting.Contexts;
using System.Runtime.Serialization.Formatters.Binary;
using Springie.Downloader;

#endregion

namespace Springie.SpringNamespace
{
	[Synchronization]
	public class UnitSyncWrapper : ContextBoundObject
	{
		#region Fields

		public DownloaderHandler Downloader;
		private Dictionary<string, ModInfo> loadedModList = new Dictionary<string, ModInfo>();
		private Dictionary<string, MapInfo> mapList = new Dictionary<string, MapInfo>();
		private Dictionary<string, ModInfo> modList = new Dictionary<string, ModInfo>();

		#endregion

		#region Properties

		public Dictionary<string, MapInfo> MapList
		{
			get { return mapList; }
		}

		public Dictionary<string, ModInfo> ModList
		{
			get { return modList; }
		}

		#endregion

		#region Events

		public event EventHandler NotifyModsChanged;

		#endregion

		#region Constructors

		public UnitSyncWrapper() : this(Program.WorkPath) {}

		public UnitSyncWrapper(string path)
		{
			var bf = new BinaryFormatter();
			Downloader = new DownloaderHandler();
			Downloader.TorrentAdded += downloader_TorrentAdded;
			Downloader.TorrentRemoved += downloader_TorrentRemoved;
			Downloader.TorrentListDone += downloader_TorrentListDone;
			Downloader.Start();


			try {
				using (var fs = new FileStream(Path.Combine(path, "mapinfo.dat"), FileMode.Open)) mapList = (Dictionary<string, MapInfo>) bf.Deserialize(fs);
			} catch (Exception ex) {
				ErrorHandling.HandleException(ex, "While loading mapinfo.dat");
			}
			try {
				using (var fs = new FileStream(Path.Combine(path, "modinfo.dat"), FileMode.Open)) loadedModList = (Dictionary<string, ModInfo>) bf.Deserialize(fs);
			} catch (Exception ex) {
				ErrorHandling.HandleException(ex, "While loading modinfo.dat");
			}
			modList = new Dictionary<string, ModInfo>(loadedModList);
		}

		#endregion

		#region Public methods

		public MapInfo GetMapInfo(string name)
		{
			return mapList[name];
		}

		public ModInfo GetModInfo(string name)
		{
			if (modList.ContainsKey(name)) return modList[name];
			else {
				foreach (var p in modList) if (p.Value.ArchiveName == name) return p.Value;
				return null;
			}
		}

		public bool HasMap(string name)
		{
			return mapList.ContainsKey(name);
		}


		public bool HasMod(string modName)
		{
			if (!modList.ContainsKey(modName)) {
				foreach (var p in modList) if (p.Value.ArchiveName == modName) return true;
				return false;
			} else return true;
		}

		#endregion

		#region Other methods

		private void ProcessTorrentAdded(ShortTorrentInfo e)
		{
			if (e.Type == "MOD") {
				foreach (var mi in modList.Values) if (mi.Checksum == e.Hash) return;

				double version;
				string baseName;
				ModInfo.ExtractNameAndVersion(e.Name, out baseName, out version);
				ModInfo closestMi = null;
				double difference = double.MaxValue;
				foreach (var mi in loadedModList.Values) {
					if (mi.ShortBaseName == baseName)
					{
						var nd = Math.Abs(mi.Version - version);
						if (nd < difference) {
							difference = nd;
							closestMi = mi;
						}
					}
				}
				
				if (closestMi != null) {
					var newMi = (ModInfo)closestMi.Clone();
					newMi.Checksum = e.Hash;
					newMi.Name = e.Name;
					modList[newMi.Name] = newMi;
					if (Downloader.IsTorrentListDone && NotifyModsChanged != null) NotifyModsChanged(this, EventArgs.Empty);
				}

			} else if (e.Type == "MAP") {
				foreach (var mi in mapList.Values) if (mi.Checksum == e.Hash) return;
				mapList[e.Name] = new MapInfo(e.Name) {Checksum = e.Hash};
			}
		}

		private void ProcessTorrentRemoved(ShortTorrentInfo e)
		{
			if (e.Type == "MOD") {
				bool found = false;
				foreach (var mi in modList.Values) {
					if (mi.Checksum == e.Hash) {
						found = true;
						break;
					}
				}
				if (found) modList.Remove(e.Name);
				if (Downloader.IsTorrentListDone && NotifyModsChanged != null) NotifyModsChanged(this, EventArgs.Empty);
			} else if (e.Type == "MAP") {
				bool found = false;
				foreach (var mi in mapList.Values) {
					if (mi.Checksum == e.Hash) {
						found = true;
						break;
					}
				}
				if (found) mapList.Remove(e.Name);
			}
		}

		#endregion


		public string GetNewestModVersion(string baseName)
		{
			double newest = double.MinValue;
			string best = null;
			foreach (ModInfo mi in modList.Values) {
				if (mi.ShortBaseName == baseName) {
					if (mi.Version > newest) {
						newest = mi.Version;
						best = mi.Name;
					}
				}
			}
			return best;
		}

		#region Event Handlers

		private void downloader_TorrentAdded(object sender, ShortTorrentInfo e)
		{
			ProcessTorrentAdded(e);
		}

		private void downloader_TorrentListDone(object sender, EventArgs e)
		{
			if (NotifyModsChanged != null) NotifyModsChanged(this, EventArgs.Empty);
		}

		private void downloader_TorrentRemoved(object sender, ShortTorrentInfo e)
		{
			ProcessTorrentRemoved(e);
		}

		#endregion
	}
}