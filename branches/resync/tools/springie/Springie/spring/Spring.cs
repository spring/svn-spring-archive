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

    public const string ExecutableName = "spring.exe";
    public const string InfoLogName = "infolog.txt";
    public const int MaxTeams = 16;
    public const int MaxAllies = 10;
    const string PathDivider = "/";

    Talker talker;
    string path;
    public string Path { get { return path; } }
    Process process;

    List<Battle.GrPlayer> players;

    bool springWindowHidden = true;
    public bool SpringWindowHidden
    {
      get { return springWindowHidden; }
      set { springWindowHidden = value; UpdateSpringVisibility(); }
    }

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
        return (process != null && process.MainWindowHandle != IntPtr.Zero && !process.HasExited);
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
    Thread outputReader;

    public Spring(string path)
    {
      if (string.IsNullOrEmpty(path)) path = Directory.GetCurrentDirectory();

      if (!path.EndsWith(PathDivider)) path += PathDivider; // ensure that path ends with \\
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

        ConfigMaker.Generate(path + "springie.txt", battle, out players);

        process = new Process();
        process.StartInfo.CreateNoWindow = true;

        if (Program.main.config.SpringStartsMinimized) {
          process.StartInfo.Arguments = "/minimise ";
        } else process.StartInfo.Arguments = "";
        process.StartInfo.Arguments += "springie.txt";

        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.WorkingDirectory = path;
        process.StartInfo.FileName = path + ExecutableName;
        process.StartInfo.UseShellExecute = false;
        process.Exited += new EventHandler(springProcess_Exited);
        
        Thread.Sleep(1000); // give time to user's spring to start and ignore upcoming registry hax
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
        System.Threading.Thread.Sleep(1000);
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
        if (l == null || !s.IsRunning) return;
        s.ProcessLogLine(l);
      } while (true);
    }


    private void ProcessLogLine(string l)
    {
      Console.Write(l);
      string[] words;

      if (l.StartsWith("Player")) {
        words = l.Split(' ');
        if (l.Length > 2) {
          if (words[2] == "joined") { // player joined
            if (PlayerJoined != null) PlayerJoined(this, new SpringLogEventArgs(words[1], l));
          } else if (words[2] == "left") { // player left
            if (PlayerLeft != null) PlayerLeft(this, new SpringLogEventArgs(words[1], l));
          }
        }
      } else if (l[0] == '<') { // player said something
        words = l.Split(new char[] { '<', '>', ' ' }, 2, StringSplitOptions.RemoveEmptyEntries);
        if (PlayerSaid != null && words.Length > 1) PlayerSaid(this, new SpringLogEventArgs(words[0], words[1]));

      } else if (l.StartsWith("Lost connection to")) { // lost connection to player
        words = l.Split(' ');
        if (words.Length > 3) {
          if (PlayerDisconnected != null) PlayerDisconnected(this, new SpringLogEventArgs(words[3], l));
        }
      } else if (l.StartsWith("Team")) {
        words = l.Split(new char[] { '(', ')' });
        if (words.Length > 1) {
          if (PlayerLost != null) PlayerLost(this, new SpringLogEventArgs(words[1], l));
        }
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

    void springProcess_Exited(object sender, EventArgs e)
    {
      process = null;
      talker.Close();
      talker = null;
      if (SpringExited != null) SpringExited(this, EventArgs.Empty);
    }

    int soundVolume;
    int xResolution;
    int yResolution;
    int fullScreen;
    const string springRegistryKey = "HKEY_CURRENT_USER\\Software\\SJ\\spring";
    private void PrepareRegistry()
    {
      soundVolume = (int)Registry.GetValue(springRegistryKey, "SoundVolume", 0);
      fullScreen = (int)Registry.GetValue(springRegistryKey, "Fullscreen", 0);
      xResolution = (int)Registry.GetValue(springRegistryKey, "XResolution", 0);
      yResolution = (int)Registry.GetValue(springRegistryKey, "YResolution", 0);

      Registry.SetValue(springRegistryKey, "SoundVolume", 0);
      Registry.SetValue(springRegistryKey, "Fullscreen", Program.main.config.SpringFullscreen ? 1 : 0);
      Registry.SetValue(springRegistryKey, "XResolution", Program.main.config.SpringResolutionX);
      Registry.SetValue(springRegistryKey, "YResolution", Program.main.config.SpringResolutionY);
      Registry.SetValue(springRegistryKey, "StdoutDebug", 1);
    }

    private void RestoreRegistry()
    {
      Registry.SetValue(springRegistryKey, "SoundVolume", soundVolume);
      Registry.SetValue(springRegistryKey, "Fullscreen", fullScreen);
      Registry.SetValue(springRegistryKey, "XResolution", xResolution);
      Registry.SetValue(springRegistryKey, "YResolution", yResolution);
      Registry.SetValue(springRegistryKey, "StdoutDebug", 0);
    }

    public string GetMapArchiveName(string mapname)
    {
      return unitSync.GetMapArchiveName(mapname);
    }


    private void UpdateSpringVisibility()
    {
      if (IsRunning) {
        if (springWindowHidden) Talker.ShowWindow(process.MainWindowHandle, Talker.SW_HIDE); else Talker.ShowWindow(process.MainWindowHandle, Talker.SW_NORMAL);
      }
    }

    #region IDisposable Members

    public void Dispose()
    {
    }

    #endregion
  }
}
