#region using

using System.ComponentModel;
using System.Diagnostics;

#endregion

namespace Springie
{
	public class MainConfig
	{
		#region Constants

		public const string SpringieVersion = "Springie 1.34b";
		public const int TrackerCaPort = 8202;

		#endregion

		#region ErrorHandlingModes enum

		public enum ErrorHandlingModes
		{
			Debug,
			Suppress,
			MessageBox
		}

		#endregion

		#region Fields

		private string accountName = "login";
		private string accountPassword = "pass";
		private int attemptReconnectInterval = 60;
		private bool attemptToRecconnect = true;
		private bool autoUpdate = true;
		private ErrorHandlingModes errorHandlingMode = ErrorHandlingModes.Suppress;
		private string executableName = "spring-dedicated.exe";
		private bool gargamelMode = true;
		private ProcessPriorityClass hostingProcessPriority = ProcessPriorityClass.AboveNormal;
		private string[] joinChannels = new[] {"main"};
		private string planetWarsServer = "planet-wars.eu";
		private bool redirectGameChat = true;
		private string serverHost = "taspringmaster.clan-sy.com";
		private int serverPort = 8200;
		private int springCoreAffinity = 1;
		private bool statsEnabledReal = true;
		private string statsUrlAddressReal = "http://springie.licho.eu/";
		private string[] trackerServers = new[] {"tracker.caspring.org", "backup-tracker.licho.eu"};
	    private int planetWarsPort = 1666;

	    #endregion

		#region Properties

		[Description("Login name")]
		[Category("Account")]
		public string AccountName
		{
			get { return accountName; }
			set { accountName = value; }
		}

		[Description("Your login password")]
		[Category("Account")]
		public string AccountPassword
		{
			get { return accountPassword; }
			set { accountPassword = value; }
		}


		[Description("Time interval before reconnection attempt in seconds")]
		[Category("Server connection")]
		public int AttemptReconnectInterval
		{
			get { return attemptReconnectInterval; }
			set { attemptReconnectInterval = value; }
		}

		[Description("Should attempt to reconnect to server in case of failure?")]
		[Category("Server connection")]
		public bool AttemptToRecconnect
		{
			get { return attemptToRecconnect; }
			set { attemptToRecconnect = value; }
		}

		[Description("Should Springie automatically update itself to latest version?")]
		[Category("Springie")]
		public bool AutoUpdate
		{
			get { return autoUpdate; }
			set { autoUpdate = value; }
		}


		[Category("Springie")]
		[Description("Determines the way in which Springie handles unexpected errors. For general purpose use Suppress, for instant notification and stop on error use MessageBox mode and for debugging use Debug")]
		public ErrorHandlingModes ErrorHandlingMode
		{
			get { return errorHandlingMode; }
			set { errorHandlingMode = value; }
		}

		[Category("Spring")]
		[Description("Executable to run")]
		public string ExecutableName
		{
			get { return executableName; }
			set { executableName = value; }
		}

		[Description("Should this autohost work in gargamel mode (catch smurfs)")]
		[Category("Server connection")]
		public bool GargamelMode
		{
			get { return gargamelMode; }
			set { gargamelMode = value; }
		}

		[Category("Spring")]
		[Description("Sets the priority of spring hosting process")]
		public ProcessPriorityClass HostingProcessPriority
		{
			get { return hostingProcessPriority; }
			set { hostingProcessPriority = value; }
		}

		[Description("Which channels to join on startup")]
		[Category("Spring")]
		public string[] JoinChannels
		{
			get { return joinChannels; }
			set { joinChannels = value; }
		}

		[Description("Enable PlanetWars? Needs stats enabled to work properly")]
		[Category("PlanetWars")]
		public bool PlanetWarsEnabled { get; set; }


		[Description("Location of PlanetWars server")]
		[Category("PlanetWars")]
		public string PlanetWarsServer
		{
			get { return planetWarsServer; }
			set { planetWarsServer = value; }
		}

        [Description("Port of PlanetWars server")]
        [Category("PlanetWars")]
        public int PlanetWarsPort
        {
            get { return planetWarsPort; }
            set { planetWarsPort = value; }
        }


		[Description("Password into PlanetWars system for this springie")]
		[Category("PlanetWars")]
		public string PlanetWarsServerPassword { get; set; }


		[Category("Spring")]
		[Description("Should springie redirect global game chat to lobby?")]
		public bool RedirectGameChat
		{
			get { return redirectGameChat; }
			set { redirectGameChat = value; }
		}


		[Description("Lobby server hostname")]
		[Category("Server connection")]
		public string ServerHost
		{
			get { return serverHost; }
			set { serverHost = value; }
		}

		[Description("Lobby server port")]
		[Category("Server connection")]
		public int ServerPort
		{
			get { return serverPort; }
			set { serverPort = value; }
		}

		[Description("Which cores/CPUs to use 1= first, 2= second, 4= third, 8 = fourth")]
		[Category("Spring")]
		public int SpringCoreAffinity
		{
			get { return springCoreAffinity; }
			set { springCoreAffinity = value; }
		}

		[Description("Should this server report data to stats server?")]
		[Category("Server connection")]
		public bool StatsEnabledReal
		{
			get { return statsEnabledReal; }
			set { statsEnabledReal = value; }
		}

		[Description("Url of stats data gathering service")]
		[Category("Server connection")]
		public string StatsUrlAddressReal
		{
			get { return statsUrlAddressReal; }
			set
			{
				if (!value.EndsWith("/")) value += "/";
				statsUrlAddressReal = value;
			}
		}

		[Category("Downloader")]
		[Description("Downloader trakcer server - used to get map and mod lists")]
		public string[] TrackerServers
		{
			get { return trackerServers; }
			set { trackerServers = value; }
		}

		#endregion
	} ;
}