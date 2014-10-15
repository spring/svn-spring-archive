#region using

using System;
using System.Collections.Generic;
using System.Runtime.Remoting.Contexts;
using System.Timers;

#endregion

namespace Springie.Downloader
{
	[Synchronization]
	public class DownloaderHandler : ContextBoundObject, IDisposable
	{
		#region Fields

		private bool Closing;
		private ClientConnection con;
		private DateTime lastConnectAttemt = DateTime.Now;
		private DateTime lastPing = DateTime.Now;
		private HostList serverList;
		private Dictionary<int, ShortTorrentInfo> serverTorrentList = new Dictionary<int, ShortTorrentInfo>();
		private readonly Timer timer = new Timer();

		#endregion

		#region Properties

		public bool IsTorrentListDone { get; private set; }

		#endregion

		#region Events

		public event EventHandler<ShortTorrentInfo> TorrentAdded;
		public event EventHandler TorrentListDone;
		public event EventHandler<ShortTorrentInfo> TorrentRemoved;
		public event EventHandler<ResourceLinks> LinksRecieved;

		#endregion

		#region Constructors

		public DownloaderHandler()
		{
			timer.Elapsed += timer_Elapsed;
			timer.Interval = 30000;
			timer.AutoReset = false;
			serverList = new HostList(Program.main.config.TrackerServers);
		}

		public void Start()
		{
			timer.Start();
			ConnectToCaServer();
		}

		public void Dispose()
		{
			Closing = true;
			con.CommandRecieved -= con_CommandRecieved;
			timer.Stop();
			con.Close();
		}

		#endregion

		#region Other methods

		private void ConnectToCaServer()
		{
			con = new ClientConnection();
			con.ConnectionClosed += con_ConnectionClosed;
			con.CommandRecieved += con_CommandRecieved;
			con.Connected += con_Connected;
			lastPing = DateTime.Now;
			lastConnectAttemt = DateTime.Now;
			con.Connect(serverList.CurrentHost, MainConfig.TrackerCaPort);
		}

		#endregion

		#region Event Handlers

		private void con_CommandRecieved(object sender, ServerConnectionEventArgs e)
		{
			ProcessCommandRecieved(e);
		}

		private void ProcessCommandRecieved(ServerConnectionEventArgs e)
		{
			try {
				if (e.Result == ServerConnectionEventArgs.ResultTypes.Success) {
					switch (e.Command) {
						case "T+":
						{
							int hash = int.Parse(e.Parameters[0]);
							string type = e.Parameters[2];
							string name = e.Parameters[1];
							if (!serverTorrentList.ContainsKey(hash)) {
								var ti = new ShortTorrentInfo(name, hash, type);
								serverTorrentList.Add(hash, ti);
								if (TorrentAdded != null) TorrentAdded(this, ti);
							}
						}
							break;

						case "T-":
						{
							int hash = int.Parse(e.Parameters[0]);
							ShortTorrentInfo ti;
							if (serverTorrentList.TryGetValue(hash, out ti)) {
								serverTorrentList.Remove(hash);
								if (TorrentRemoved != null) TorrentRemoved(this, ti);
							}
						}
							break;


						case "M+":
							{
								int hash = int.Parse(e.Parameters[0]);
								List<string> mirrors = new List<string>();
								for (int i = 1; i < e.Parameters.Length; ++i) if (e.Parameters[i] != "") mirrors.Add(e.Parameters[i]);
								if (LinksRecieved != null) LinksRecieved(this, new ResourceLinks(hash, mirrors));
							}
							break;



						case "TLISTDONE":
							IsTorrentListDone = true;
							if (TorrentListDone != null) TorrentListDone(this, EventArgs.Empty);
							break;

						case "PING":
							lastPing = DateTime.Now;
							con.SendCommand("PING");
							break;
					}
				}
			} catch (Exception ex) {
				ErrorHandling.HandleException(ex, "error recieving data from P2P server");
			}
		}

		private void con_Connected(object sender, EventArgs e)
		{
			lastPing = DateTime.Now;
		}


		public void RequestLinksForHash(int checksum)
		{
			if (con.IsConnected) con.SendCommand("LINK", checksum.ToString());
		}


		private void con_ConnectionClosed(object sender, EventArgs e)
		{
			con.ConnectionClosed -= con_ConnectionClosed;
			Console.WriteLine("Connection to server closed");
		}


		private void timer_Elapsed(object sender, ElapsedEventArgs e)
		{
			if (Closing) return;
			try {
				timer.Stop();

				if (con.IsConnected && DateTime.Now.Subtract(lastPing).TotalSeconds > 120) {
					con.Close();
					return;
				}
				if (!con.IsConnected && !con.IsConnecting && DateTime.Now.Subtract(lastConnectAttemt).TotalSeconds > 30) {
					serverList.GetNext();
					ConnectToCaServer();
				}
			} catch (Exception ex) {
				ErrorHandling.HandleException(ex, "error in periodic p2p update");
			} finally {
				timer.Start();
			}
		}

		#endregion
	}

	public class ResourceLinks:EventArgs
	{
		public int Checksum { get; private set; }
		public List<string> Mirrors { get; private set; }
		public ResourceLinks(int checksum, List<string> mirrors)
		{
			Checksum = checksum;
			Mirrors = mirrors;
		}
	}
}