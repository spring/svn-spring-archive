using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Threading;
using Microsoft.Win32;
using System.Timers;
using Springie.Client;

namespace Springie.SpringNamespace
{
  public class SpringLogEventArgs : EventArgs
  {
    string username;
    public string Username { get { return username; } }

    string line;
    public string Line { get { return line; } }

    List<string> args = new List<string>();
    public List<string> Args
    {
      get { return args; }
    }

    public SpringLogEventArgs(string username): this(username, "") {}

    public SpringLogEventArgs(string username, string line)
    {
      this.line = line;
      this.username = username;
    }
  };

  /// <summary>
  /// represents one install location of spring game
  /// </summary>
  public class Spring : IDisposable
  {
    public event EventHandler<SpringLogEventArgs> PlayerSaid;
    public event EventHandler<SpringLogEventArgs> PlayerJoined;
    public event EventHandler<SpringLogEventArgs> PlayerLeft;
    public event EventHandler<SpringLogEventArgs> PlayerDisconnected;
    public event EventHandler<SpringLogEventArgs> PlayerLost; // player lost the game
    public event EventHandler<SpringLogEventArgs> GameOver; // game has ended

    public event EventHandler SpringExited;
    public event EventHandler SpringStarted;

    public const string ExecutableName = "dedicated.exe";
    public const int MaxTeams = 32;
    public const int MaxAllies = 10;
//    const string PathDivider = "/";

    Talker talker;
    string path;
    public string Path { get { return path; } }
    Process process;


    public ProcessPriorityClass ProcessPriority
    {
      get
      {
        if (IsRunning) return process.PriorityClass;
        else return Program.main.config.HostingProcessPriority;
      }
      set
      {
        if (IsRunning) {
          process.PriorityClass = value;
        }
      }

    }



    public bool IsRunning
    {
      get
      {
        return (process != null && !process.HasExited);
      }
    }
    DateTime gameStarted;
    public DateTime GameStarted
    {
      get { return gameStarted; }
    }

    UnitSync unitSync;
    public UnitSync UnitSync
    {
      get { return unitSync; }
    }

    public Spring(string path)
    {
      if (string.IsNullOrEmpty(path)) path = Directory.GetCurrentDirectory();

      if (!path.EndsWith("/")) path += "/"; // ensure that path ends with \\
      this.path = path;

      if (!File.Exists(path + ExecutableName)) throw new Exception(ExecutableName + " not found in " + path);

      // init unitsync and load basic info
      unitSync = new UnitSync(path);
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

    // SPRING.EXE functions
    public void StartGame(Battle battle)
    {
      if (!IsRunning) {

        List<Battle.GrPlayer> players;
        talker = new Talker();
        talker.SpringEvent += new EventHandler<Talker.SpringEventArgs>(talker_SpringEvent);
        string configName = "springie" + Program.main.AutoHost.config.HostingPort + ".txt";
        ConfigMaker.Generate(path + configName, battle, talker.LoopbackPort, out players);
        talker.SetPlayers(players);


        process = new Process();
        process.StartInfo.CreateNoWindow = true;
        process.StartInfo.Arguments += configName;
        process.StartInfo.WorkingDirectory = path;
        process.StartInfo.FileName = path + ExecutableName;
        process.StartInfo.UseShellExecute = false;
        process.Exited += new EventHandler(springProcess_Exited);
        
        process.Start();
        process.ProcessorAffinity = (IntPtr)Program.main.config.SpringCoreAffinity;

        gameStarted = DateTime.Now;
        process.WaitForInputIdle();

    
        if (IsRunning && SpringStarted != null) SpringStarted(this, EventArgs.Empty);
        
        System.Threading.Thread.Sleep(1000);
        ProcessPriority = Program.main.config.HostingProcessPriority;
      }
    }

    void talker_SpringEvent(object sender, Talker.SpringEventArgs e)
    {
      switch (e.EventType) {
        case Talker.SpringEventType.PLAYER_JOINED:
          if (PlayerJoined != null) PlayerJoined(this, new SpringLogEventArgs(e.PlayerName));
          break;

        case Talker.SpringEventType.PLAYER_LEFT:
          if (e.Param == 0) if (PlayerDisconnected != null) PlayerDisconnected(this, new SpringLogEventArgs(e.PlayerName));
            else if (PlayerLeft != null) PlayerLeft(this, new SpringLogEventArgs(e.PlayerName));
          break;

        case Talker.SpringEventType.PLAYER_CHAT:
          if (PlayerSaid != null) PlayerSaid(this, new SpringLogEventArgs(e.PlayerName, e.Text));
          break;

        case Talker.SpringEventType.PLAYER_DEFEATED:
          if (PlayerLost != null) PlayerLost(this, new SpringLogEventArgs(e.PlayerName));
          break;

        case Talker.SpringEventType.SERVER_GAMEOVER:
//          if (GameOver != null) GameOver(this, new SpringLogEventArgs(e.PlayerName));
          break;
        
        case Talker.SpringEventType.SERVER_QUIT:
          if (GameOver != null) GameOver(this, new SpringLogEventArgs(e.PlayerName));
          break;

      }

    }



    
    public void ForceStart()
    {
      if (IsRunning) {
        talker.SendText(".forcestart");
      }
    }

    public void ExitGame()
    {
      if (IsRunning) {
        // TODO talker method to exit spring
//        process.WaitForExit(1000);
//        if (!IsRunning) return;

        process.CloseMainWindow();
        process.WaitForExit(1000);
        if (!IsRunning) return;
        process.Kill();
      }
    }

    public void SayGame(string text)
    {
      if (IsRunning) {
        talker.SendText(text);
      }
    }

    public void Kick(string name)
    {
      SayGame(".kick " + name);
    }


    void springProcess_Exited(object sender, EventArgs e)
    {
      process = null;
      talker.Close();
      talker = null;
      if (SpringExited != null) SpringExited(this, EventArgs.Empty);
    }


    public string GetMapArchiveName(string mapname)
    {
      return unitSync.GetMapArchiveName(mapname);
    }


    #region IDisposable Members

    public void Dispose()
    {
    }

    #endregion
  }
}
