#region using

using System;
using System.IO;
using System.Timers;
using System.Windows.Forms;
using System.Xml.Serialization;
using PlanetWarsShared.Springie;
using Springie.autohost;
using Springie.Client;
using Springie.SpringNamespace;
using Timer=System.Timers.Timer;

#endregion

namespace Springie
{
	public class Main
	{
		#region Constants

		public const string ConfigMain = "main.xml";

		#endregion

		#region Fields

		private AutoHost autoHost;
		private AutoUpdater autoUpdater;
		private Timer recon;
		private Spring spring;

		private Stats stats;

		private TasClient tas;

		#endregion

		#region Properties

		public AutoHost AutoHost
		{
			get { return autoHost; }
		}

		public MainConfig config;
		public ISpringieServer PlanetWars;

		public Spring Spring
		{
			get { return spring; }
		}

		public Stats Stats
		{
			get { return stats; }
		}

		public TasClient Tas
		{
			get { return tas; }
		}

		#endregion

		#region Constructors

		public Main()
		{
			LoadConfig();
			SaveConfig();
		}

		#endregion

		#region Public methods

		public void InitializePlanetWarsServer()
		{
			try {
				PlanetWars = (ISpringieServer) Activator.GetObject(typeof (ISpringieServer), String.Format("tcp://{0}:1666/IServer", config.PlanetWarsServer));
			} catch (Exception ex) {}
		}

		public void LoadConfig()
		{
			config = new MainConfig();
			if (File.Exists(Application.StartupPath + '/' + ConfigMain)) {
				var s = new XmlSerializer(config.GetType());
				var r = File.OpenText(Application.StartupPath + '/' + ConfigMain);
				config = (MainConfig) s.Deserialize(r);
				r.Close();
			}
		}

		public void ReLogin()
		{
			tas_Connected(this, new TasEventArgs());
		}

		public void SaveConfig()
		{
			var s = new XmlSerializer(config.GetType());
			var f = File.OpenWrite(Application.StartupPath + '/' + ConfigMain);
			f.SetLength(0);
			s.Serialize(f, config);
			f.Close();
		}


		public bool Start()
		{
			if (config.AttemptToRecconnect) {
				recon = new Timer(config.AttemptReconnectInterval*1000);
				recon.Elapsed += recon_Elapsed;
			}

			recon.Enabled = false;

			try {
				spring = new Spring(config.SpringPath);
			} catch {
				MessageBox.Show("Spring not found in " + config.SpringPath, "error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				var od = new OpenFileDialog();
				od.FileName = Spring.ExecutableName;
				od.DefaultExt = Path.GetExtension(Spring.ExecutableName);
				od.InitialDirectory = config.SpringPath;
				od.Title = "Please select your spring installation";
				od.RestoreDirectory = true;
				od.CheckFileExists = true;
				od.CheckPathExists = true;
				od.AddExtension = true;
				od.Filter = "Executable (*.exe)|*.exe";
				var dr = od.ShowDialog();
				if (dr == DialogResult.OK) {
					config.SpringPath = Path.GetDirectoryName(od.FileName);
					SaveConfig();
					try {
						spring = new Spring(config.SpringPath);
					} catch (Exception e) {
						MessageBox.Show(e.ToString(), "Error while checking spring, exiting");
						Application.Exit();
						return false;
					}
				} else {
					MessageBox.Show("Spring not found, exiting");
					Application.Exit();
					return false;
				}
			}

			if (config.PlanetWarsEnabled) InitializePlanetWarsServer();

			tas = new TasClient();
			tas.ConnectionLost += tas_ConnectionLost;
			tas.Connected += tas_Connected;
			tas.LoginDenied += tas_LoginDenied;
			tas.LoginAccepted += tas_LoginAccepted;
			tas.Said += tas_Said;
			tas.MyStatusChangedToInGame += tas_MyStatusChangedToInGame;
			spring.SpringExited += spring_SpringExited;
			spring.SpringStarted += spring_SpringStarted;
			spring.PlayerSaid += spring_PlayerSaid;
			autoHost = new AutoHost(tas, spring, null);
			autoUpdater = new AutoUpdater(spring, tas);

			if (config.StatsEnabledReal) stats = new Stats(tas, spring);
			try {
				tas.Connect(config.ServerHost, config.ServerPort);
			} catch {
				recon.Start();
			}
			return true;
		}


		public void Stop()
		{
			tas.ConnectionLost -= tas_ConnectionLost;
			tas.Disconnect();
		}

		#endregion

		#region Event Handlers

		private void recon_Elapsed(object sender, ElapsedEventArgs e)
		{
			recon.Stop();
			try {
				tas.Connect(config.ServerHost, config.ServerPort);
			} catch {
				recon.Start();
			}
		}

		private void spring_PlayerSaid(object sender, SpringLogEventArgs e)
		{
			tas.GameSaid(e.Username, e.Line);
			if (config.RedirectGameChat && e.Username != tas.UserName && !e.Line.StartsWith("Allies:") && !e.Line.StartsWith("Spectators:")) tas.Say(TasClient.SayPlace.Battle, "", "[" + e.Username + "]" + e.Line, false);
		}

		private void spring_SpringExited(object sender, EventArgs e)
		{
			if (tas != null) tas.ChangeMyStatus(false, false);
		}

		private void spring_SpringStarted(object sender, EventArgs e)
		{
			if (Program.main.config.AllowInGameJoin) {
				tas.ChangeMyStatus(false, false);
				tas.ChangeLock(false);
			}
		}


		// login accepted - join channels

		// im connected, let's login
		private void tas_Connected(object sender, TasEventArgs e)
		{
			tas.Login(config.AccountName, config.AccountPassword, MainConfig.SpringieVersion);
		}


		private void tas_ConnectionLost(object sender, TasEventArgs e)
		{
			autoHost.Stop();
			recon.Start();
		}

		private void tas_LoginAccepted(object sender, TasEventArgs e)
		{
			for (int i = 0; i < config.JoinChannels.Length; ++i) tas.JoinChannel(config.JoinChannels[i]);
			autoHost.Start(null, null);
		}

		private void tas_LoginDenied(object sender, TasEventArgs e)
		{
			//MessageBox.Show(e.ServerParams[0], "Login failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
			Program.formMain.GetNewLogPass();
		}

		private void tas_MyStatusChangedToInGame(object sender, TasEventArgs e)
		{
			spring.StartGame(tas.GetBattle());
		}

		private void tas_Said(object sender, TasSayEventArgs e)
		{
			if (config.RedirectGameChat && e.Place == TasSayEventArgs.Places.Battle && e.Origin == TasSayEventArgs.Origins.Player && e.UserName != tas.UserName && e.IsEmote == false && !Program.main.config.AllowInGameJoin) {
				// TODO disable disabled redirect for allow ingame joins
				spring.SayGame("[" + e.UserName + "]" + e.Text);
			}
		}

		#endregion
	}
}