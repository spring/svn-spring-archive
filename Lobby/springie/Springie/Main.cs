#region using

#region using

using System;
using System.IO;
using System.Timers;
using System.Xml.Serialization;
using Springie.autohost;
using Springie.Client;
using Springie.PlanetWars;
using Springie.SpringNamespace;

#endregion

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

        public PlanetWarsHandler PlanetWars;

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
            if (PlanetWars != null) PlanetWars.Dispose();
            if (config.PlanetWarsEnabled) PlanetWars = new PlanetWarsHandler(config.PlanetWarsServer, config.PlanetWarsPort, autoHost, tas, config);
            else PlanetWars = null;
        }

        public void LoadConfig()
        {
            config = new MainConfig();
            if (File.Exists(Program.WorkPath + '/' + ConfigMain)) {
                var s = new XmlSerializer(config.GetType());
                var r = File.OpenText(Program.WorkPath + '/' + ConfigMain);
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
            var f = File.OpenWrite(Program.WorkPath + '/' + ConfigMain);
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
            spring = new Spring();


            tas = new TasClient();
            tas.ConnectionLost += tas_ConnectionLost;
            tas.Connected += tas_Connected;
            tas.LoginDenied += tas_LoginDenied;
            tas.LoginAccepted += tas_LoginAccepted;
            tas.Said += tas_Said;
            tas.MyStatusChangedToInGame += tas_MyStatusChangedToInGame;
            tas.ChannelUserAdded += tas_ChannelUserAdded;
            spring.SpringExited += spring_SpringExited;
            spring.SpringStarted += spring_SpringStarted;
            spring.PlayerSaid += spring_PlayerSaid;
            autoHost = new AutoHost(tas, spring, null);
            if (config.PlanetWarsEnabled) InitializePlanetWarsServer();
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
            if (PlanetWars != null) PlanetWars.SpringExited();
        }

        private void spring_SpringStarted(object sender, EventArgs e)
        {
            tas.ChangeLock(false);
        }

        private void tas_ChannelUserAdded(object sender, TasEventArgs e)
        {
            if (PlanetWars != null) PlanetWars.UserJoinedChannel(e.ServerParams[0], e.ServerParams[1]);
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
            ErrorHandling.HandleException(null, "Login failed");
            if (Program.GuiEnabled && Program.formMain != null) Program.formMain.GetNewLogPass();
        }

        private void tas_MyStatusChangedToInGame(object sender, TasEventArgs e)
        {
            spring.StartGame(tas.GetBattle());
        }

        private void tas_Said(object sender, TasSayEventArgs e)
        {
            if (PlanetWars != null) PlanetWars.UserSaid(e);

            if (config.RedirectGameChat && e.Place == TasSayEventArgs.Places.Battle && e.Origin == TasSayEventArgs.Origins.Player && e.UserName != tas.UserName && e.IsEmote == false) spring.SayGame("[" + e.UserName + "]" + e.Text);
        }

        #endregion
    }
}