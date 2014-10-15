using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading;
using Microsoft.Win32;
using Springie.Client;

namespace Springie.SpringNamespace
{
  public class SpringLogEventArgs : EventArgs
  {
    private List<string> args = new List<string>();
    private string line;
    private string username;

    public SpringLogEventArgs(string username, string line)
    {
      this.line = line;
      this.username = username;
    }

    public string Username
    {
      get { return username; }
    }

    public string Line
    {
      get { return line; }
    }

    public List<string> Args
    {
      get { return args; }
    }
  } ;

  /// <summary>
  /// represents one install location of spring game
  /// </summary>
  public class Spring : IDisposable
  {
    public const string ExecutableName = "spring.exe";
    public const string InfoLogName = "infolog.txt";
    public const int MaxAllies = 10;
    public const int MaxTeams = 32;
    private const string PathDivider = "/";
    private const string springRegistryKey = "HKEY_CURRENT_USER\\Software\\SJ\\spring";
    private int fullScreen;
    private DateTime gameStarted;
    private int luaUi;
    private Thread outputReader;

    private string path;

    private List<Battle.GrPlayer> players;
    private Process process;

    private bool springWindowHidden = true;
    private Talker talker;
    private UnitSync unitSync;
    private int xResolution;
    private int yResolution;

    public Spring(string path)
    {
      if (string.IsNullOrEmpty(path)) path = Directory.GetCurrentDirectory();

      if (!path.EndsWith(PathDivider)) path += PathDivider; // ensure that path ends with \\
      this.path = path;

      if (!File.Exists(path + ExecutableName)) throw new Exception(ExecutableName + " not found in " + path);

      // init unitsync and load basic info
      unitSync = new UnitSync(path);
    }

    public string Path
    {
      get { return path; }
    }

    public bool SpringWindowHidden
    {
      get { return springWindowHidden; }
      set
      {
        springWindowHidden = value;
        UpdateSpringVisibility();
      }
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


    public bool IsRunning
    {
      get { return (process != null && process.MainWindowHandle != IntPtr.Zero && !process.HasExited); }
    }

    public DateTime GameStarted
    {
      get { return gameStarted; }
    }

    public UnitSync UnitSync
    {
      get { return unitSync; }
    }

    #region IDisposable Members
    public void Dispose() {}
    #endregion

    public event EventHandler<SpringLogEventArgs> PlayerSaid;
    public event EventHandler<SpringLogEventArgs> PlayerJoined;
    public event EventHandler<SpringLogEventArgs> PlayerLeft;
    public event EventHandler<SpringLogEventArgs> PlayerDisconnected;
    public event EventHandler<SpringLogEventArgs> PlayerLost; // player lost the game
    public event EventHandler<SpringLogEventArgs> GameOver; // game has ended

    public event EventHandler SpringExited;
    public event EventHandler SpringStarted;


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
        ConfigMaker.Generate(path + "springie.txt", battle, out players);

        process = new Process();
        process.StartInfo.CreateNoWindow = true;

        if (Program.main.config.SpringStartsMinimized) process.StartInfo.Arguments = "/minimise ";
        else process.StartInfo.Arguments = "";
        process.StartInfo.Arguments += "springie.txt";

        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.WorkingDirectory = path;
        process.StartInfo.FileName = path + ExecutableName;
        process.StartInfo.UseShellExecute = false;
        process.Exited += new EventHandler(springProcess_Exited);

        Thread.Sleep(2000); // give time to user's spring to start and ignore upcoming registry hax
        PrepareRegistry();
        process.Start();

        gameStarted = DateTime.Now;
        process.WaitForInputIdle();

        outputReader = new Thread(SpringOutputReader);
        outputReader.Name = "SpringOutputReader";
        outputReader.Start(this);
        talker = new Talker(process);

        RestoreRegistry();
        if (IsRunning && SpringStarted != null) SpringStarted(this, EventArgs.Empty);

        SpringWindowHidden = Program.main.config.SpringStartsHidden;
        Thread.Sleep(1000);
        ProcessPriority = Program.main.config.HostingProcessPriority;
      }
    }

    private static void SpringOutputReader(object param)
    {
      Spring s = (Spring)param;
      do {
        string l;
        try {
          l = s.process.StandardOutput.ReadLine();
        } catch {
          return;
        }
        if (l == null || !s.IsRunning || l.Length == 0) return;
        s.ProcessLogLine(l);
      } while (true);
    }


    private void ProcessLogLine(string l)
    {
      string[] words;

      if (l.StartsWith("Player")) {
        words = l.Split(' ');
        if (l.Length > 2) {
          if (words[2] == "joined") {
            // player joined
            if (PlayerJoined != null) PlayerJoined(this, new SpringLogEventArgs(words[1], l));
          } else if (words[2] == "left") {
            // player left
            if (PlayerLeft != null) PlayerLeft(this, new SpringLogEventArgs(words[1], l));
          }
        }
      } else if (l[0] == '<') {
        // player said something
        words = l.Split(new char[] {'<', '>', ' '}, 2, StringSplitOptions.RemoveEmptyEntries);
        if (PlayerSaid != null && words.Length > 1) PlayerSaid(this, new SpringLogEventArgs(words[0], words[1]));
      } else if (l.StartsWith("Lost connection to")) {
        // lost connection to player
        words = l.Split(' ');
        if (words.Length > 3) if (PlayerDisconnected != null) PlayerDisconnected(this, new SpringLogEventArgs(words[3], l));
      } else if (l.StartsWith("Team")) {
        words = l.Split(new char[] {'(', ')'});
        if (words.Length > 1) if (PlayerLost != null) PlayerLost(this, new SpringLogEventArgs(words[1], l));
      } else if (l == "Game over") {
        string luser = "";
        SpringLogEventArgs e = new SpringLogEventArgs(luser, l);
        if (GameOver != null) GameOver(this, e);
      }
    }

    public void ForceStart()
    {
      if (IsRunning) {
        talker.SendPressKey(Talker.VK_CONTROL);
        talker.SendPressKey(Talker.VK_ENTER);
        talker.SendReleaseKey(Talker.VK_ENTER);
        talker.SendReleaseKey(Talker.VK_CONTROL);
      }
    }

    public void ExitGame()
    {
      if (IsRunning) {
        lock (talker) {
          talker.SendPressKey(Talker.VK_LSHIFT);
          talker.SendPressKey(Talker.VK_ESC);
          talker.SendReleaseKey(Talker.VK_ESC);
          talker.SendReleaseKey(Talker.VK_LSHIFT);
        }

        process.WaitForExit(1000);
        if (!IsRunning) return;
        process.CloseMainWindow();
        process.WaitForExit(1000);
        if (!IsRunning) return;
        process.Kill();
      }
    }

    public void SayGame(string text)
    {
      if (IsRunning) {
        lock (talker) {
          talker.SendKey(Talker.VK_ENTER);
          talker.SendText(text);
          talker.SendKey(Talker.VK_ENTER);
        }
      }
    }

    public void Kick(string name)
    {
      for (int i = 0; i < players.Count; ++i) {
        if (players[i].user.name == name) {
          SayGame(".kickbynum " + i);
          break;
        }
      }
      SayGame(".kick " + name);
    }

    private void springProcess_Exited(object sender, EventArgs e)
    {
      process = null;
      talker.Close();
      talker = null;
      if (SpringExited != null) SpringExited(this, EventArgs.Empty);
    }

    //int soundVolume;
    private void PrepareRegistry()
    {
      //soundVolume = (int)Registry.GetValue(springRegistryKey, "SoundVolume", 0);
      fullScreen = (int)Registry.GetValue(springRegistryKey, "Fullscreen", 0);
      xResolution = (int)Registry.GetValue(springRegistryKey, "XResolution", 0);
      yResolution = (int)Registry.GetValue(springRegistryKey, "YResolution", 0);
      luaUi = (int)Registry.GetValue(springRegistryKey, "LuaUI", 0);

      //Registry.SetValue(springRegistryKey, "SoundVolume", 0);
      Registry.SetValue(springRegistryKey, "Fullscreen", Program.main.config.SpringFullscreen ? 1 : 0);
      Registry.SetValue(springRegistryKey, "XResolution", Program.main.config.SpringResolutionX);
      Registry.SetValue(springRegistryKey, "YResolution", Program.main.config.SpringResolutionY);
      Registry.SetValue(springRegistryKey, "StdoutDebug", 1);
      Registry.SetValue(springRegistryKey, "LuaUI", 0);
    }

    private void RestoreRegistry()
    {
      //Registry.SetValue(springRegistryKey, "SoundVolume", soundVolume);
      Registry.SetValue(springRegistryKey, "Fullscreen", fullScreen);
      Registry.SetValue(springRegistryKey, "XResolution", xResolution);
      Registry.SetValue(springRegistryKey, "YResolution", yResolution);
      Registry.SetValue(springRegistryKey, "StdoutDebug", 0);
      Registry.SetValue(springRegistryKey, "LuaUI", luaUi);
    }

    public string GetMapArchiveName(string mapname)
    {
      return unitSync.GetMapArchiveName(mapname);
    }


    private void UpdateSpringVisibility()
    {
      if (IsRunning) {
        if (springWindowHidden) Talker.ShowWindow(process.MainWindowHandle, Talker.SW_HIDE);
        else Talker.ShowWindow(process.MainWindowHandle, Talker.SW_NORMAL);
      }
    }
  }
}