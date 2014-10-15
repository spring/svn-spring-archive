#region using

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading;
using Springie.Client;

#endregion

namespace Springie.SpringNamespace
{
	public class SpringLogEventArgs : EventArgs
	{
		#region Fields

		private List<string> args = new List<string>();
		private string line;
		private string username;

		#endregion

		#region Properties

		public List<string> Args
		{
			get { return args; }
		}

		public string Line
		{
			get { return line; }
		}

		public string Username
		{
			get { return username; }
		}

		#endregion

		#region Constructors

		public SpringLogEventArgs(string username) : this(username, "") {}

		public SpringLogEventArgs(string username, string line)
		{
			this.line = line;
			this.username = username;
		}

		#endregion
	} ;

	/// <summary>
	/// represents one install location of spring game
	/// </summary>
	public class Spring : IDisposable
	{
		#region Constants

		public const string ExecutableName = "spring-dedicated.exe";
		public const int MaxAllies = 10;
		public const int MaxTeams = 32;

		#endregion

		#region Fields

		private DateTime gameStarted;
		//    const string PathDivider = "/";

		private string path;

		private Process process;
		private Talker talker;


		private UnitSync unitSync;

		#endregion

		#region Properties

		public DateTime GameStarted
		{
			get { return gameStarted; }
		}

		public bool IsRunning
		{
			get { return (process != null && !process.HasExited); }
		}

		public string Path
		{
			get { return path; }
		}

		public ProcessPriorityClass ProcessPriority
		{
			get
			{
				if (IsRunning) return process.PriorityClass;
				else return Program.main.config.HostingProcessPriority;
			}
			set { if (IsRunning) process.PriorityClass = value; }
		}

		public UnitSync UnitSync
		{
			get { return unitSync; }
		}

		#endregion

		#region Events

		public event EventHandler<SpringLogEventArgs> GameOver; // game has ended
		public event EventHandler<SpringLogEventArgs> PlayerDisconnected;
		public event EventHandler<SpringLogEventArgs> PlayerJoined;
		public event EventHandler<SpringLogEventArgs> PlayerLeft;
		public event EventHandler<SpringLogEventArgs> PlayerLost; // player lost the game
		public event EventHandler<SpringLogEventArgs> PlayerSaid;
		public event EventHandler SpringExited;
		public event EventHandler SpringStarted;

		#endregion

		#region Constructors

		public Spring(string path)
		{
			if (string.IsNullOrEmpty(path)) path = Directory.GetCurrentDirectory();

			if (!path.EndsWith("/")) path += "/"; // ensure that path ends with \\
			this.path = path;

			if (!File.Exists(path + ExecutableName)) throw new Exception(ExecutableName + " not found in " + path);

			// init unitsync and load basic info
			unitSync = new UnitSync(path);
		}

		public void Dispose() {}

		#endregion

		#region Public methods

		public void ExitGame()
		{
			if (IsRunning) {
				SayGame("/quit");
			  process.WaitForExit(2000);
				if (!IsRunning) return;
				process.Kill();;
				process.WaitForExit(1000);
				if (!IsRunning) return;
				process.Kill();
			}
		}

		public void ForceStart()
		{
			if (IsRunning) talker.SendText("/forcestart");
		}

		public string GetMapArchiveName(string mapname)
		{
			return unitSync.GetMapArchiveName(mapname);
		}

		public void Kick(string name)
		{
			SayGame("/kick " + name);
		}

		/// <summary>
		/// Reloads map and or mod list
		/// </summary>
		/// <param name="reloadMods">should reload mods</param>
		/// <param name="reloadMaps">should reload maps</param>
		public void Reload(bool reloadMods, bool reloadMaps)
		{
			unitSync.Reload(reloadMods, reloadMaps);
		}

		public void SayGame(string text)
		{
			if (IsRunning) talker.SendText(text);
		}

		public void StartGame(Battle battle)
		{
			if (!IsRunning) {
				List<Battle.GrPlayer> players;
				talker = new Talker();
				talker.SpringEvent += talker_SpringEvent;
				string configName = "springie" + Program.main.AutoHost.config.HostingPort + ".txt";
				ConfigMaker.Generate(path + configName, battle, talker.LoopbackPort, out players);
				talker.SetPlayers(players);


				process = new Process();
				process.StartInfo.CreateNoWindow = true;
				process.StartInfo.Arguments += configName;
				process.StartInfo.WorkingDirectory = path;
				process.StartInfo.FileName = path + ExecutableName;
				process.StartInfo.UseShellExecute = false;
				process.Exited += springProcess_Exited;

				process.Start();
        
				gameStarted = DateTime.Now;


				if (IsRunning && SpringStarted != null) SpringStarted(this, EventArgs.Empty);

				Thread.Sleep(1000);
				ProcessPriority = Program.main.config.HostingProcessPriority;
			}
		}

		#endregion

		#region Event Handlers

		private void springProcess_Exited(object sender, EventArgs e)
		{
			process = null;
			talker.Close();
			talker = null;
			if (SpringExited != null) SpringExited(this, EventArgs.Empty);
		}

		private void talker_SpringEvent(object sender, Talker.SpringEventArgs e)
		{
			switch (e.EventType) {
				case Talker.SpringEventType.PLAYER_JOINED:
					if (PlayerJoined != null) PlayerJoined(this, new SpringLogEventArgs(e.PlayerName));
					break;

				case Talker.SpringEventType.PLAYER_LEFT:
					if (e.Param == 0) {
						if (PlayerDisconnected != null) PlayerDisconnected(this, new SpringLogEventArgs(e.PlayerName));
						else if (PlayerLeft != null) PlayerLeft(this, new SpringLogEventArgs(e.PlayerName));
					}
					break;

				case Talker.SpringEventType.PLAYER_CHAT:
					if (PlayerSaid != null) PlayerSaid(this, new SpringLogEventArgs(e.PlayerName, e.Text));
					break;

				case Talker.SpringEventType.PLAYER_DEFEATED:
					if (PlayerLost != null) PlayerLost(this, new SpringLogEventArgs(e.PlayerName));
					break;

				case Talker.SpringEventType.SERVER_GAMEOVER:
					if (GameOver != null) GameOver(this, new SpringLogEventArgs(e.PlayerName));
					break;

				case Talker.SpringEventType.SERVER_QUIT:
					//if (GameOver != null) GameOver(this, new SpringLogEventArgs(e.PlayerName));
					break;
			}
		}

		#endregion
	}
}