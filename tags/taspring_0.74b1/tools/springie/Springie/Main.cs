using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;
using System.IO;
using System.Timers;
using System.Windows.Forms;
using System.ComponentModel;
using Springie.Client;
using Springie.SpringNamespace;
using Springie.AutoHostNamespace;
using System.Diagnostics;

namespace Springie
{
  public class MainConfig {
    
    public const string SpringieVersion = "Springie 0.83a";


    bool attemptToRecconnect = true;
    [Description("Should attempt to reconnect to server in case of failure?")]
    [Category("Server connection")]
    public bool AttemptToRecconnect
    {
      get { return attemptToRecconnect; }
      set { attemptToRecconnect = value; }
    }
    int attemptReconnectInterval = 20;


    [Description("Time interval before reconnection attempt in seconds")]
    [Category("Server connection")]
    public int AttemptReconnectInterval
    {
      get { return attemptReconnectInterval; }
      set { attemptReconnectInterval = value; }
    }

    string serverHost = "taspringmaster.clan-sy.com";

    [Description("Lobby server hostname")]
    [Category("Server connection")]
    [DefaultValue("taspringmaster.clan-sy.com")]
    public string ServerHost
    {
      get { return serverHost; }
      set { serverHost = value; }
    }
    int serverPort = 8200;

    [Description("Lobby server port")]
    [Category("Server connection")]
    [DefaultValue(8200)]
    public int ServerPort
    {
      get { return serverPort; }
      set { serverPort = value; }
    }

    string accountName = "login";
    [Description("Login name")]
    [Category("Account")]
    public string AccountName
    {
      get { return accountName; }
      set { accountName = value; }
    }
    string accountPassword = "pass";

    [Description("Your login password")]
    [Category("Account")]
    public string AccountPassword
    {
      get { return accountPassword; }
      set { accountPassword = value; }
    }

    string springPath = "./";

    [Description("Path to your spring directory folder")]
    [Category("Spring")]
    public string SpringPath
    {
      get { return springPath; }
      set { springPath = value; }
    }

    string[] joinChannels = new string[] { "main" };
    [Description("Which channels to join on startup")]
    [Category("Spring")]
    public string[] JoinChannels
    {
      get { return joinChannels; }
      set { joinChannels = value; }
    }


    int springResolutionX = 2;
    [Category("Spring"), Description("Default hosting spring window width"), DefaultValue(2)]
    public int SpringResolutionX
    {
      get { return springResolutionX; }
      set { springResolutionX = value; }
    }

    int springResolutionY = 2;
    [Category("Spring"), Description("Default hosting spring window height"), DefaultValue(2)]
    public int SpringResolutionY
    {
      get { return springResolutionY; }
      set { springResolutionY = value; }
    }

    bool springFullscreen = false;
    [Category("Spring"), Description("Should hosting spring start as fullscreen"), DefaultValue(false)]
    public bool SpringFullscreen
    {
      get { return springFullscreen; }
      set { springFullscreen = value; }
    }


    bool springStartsHidden = true;
    [Category("Spring"), Description("Should hosting spring start hidden by default"), DefaultValue(true)]
    public bool SpringStartsHidden
    {
      get { return springStartsHidden; }
      set { springStartsHidden = value; }
    }

    bool redirectGameChat = true;
    [Category("Spring"), Description("Should springie redirect global game chat to lobby?")]
    public bool RedirectGameChat
    {
      get { return redirectGameChat; }
      set { redirectGameChat = value; }
    }


    ProcessPriorityClass hostingProcessPriority = ProcessPriorityClass.AboveNormal;
    [Category("Spring"), Description("Sets the priority of spring hosting process"), DefaultValue(ProcessPriorityClass.AboveNormal)]
    public ProcessPriorityClass HostingProcessPriority
    {
      get { return hostingProcessPriority; }
      set { hostingProcessPriority = value; }
    }
    

    public enum ErrorHandlingModes:int {Debug, Suppress, MessageBox}
    ErrorHandlingModes errorHandlingMode = ErrorHandlingModes.Suppress;
    [Category("Springie"), Description("Determines the way in which Springie handles unexpected errors. For general purpose use Suppress, for instant notification and stop on error use MessageBox mode and for debugging use Debug"), DefaultValue(ErrorHandlingModes.Suppress)]
    public ErrorHandlingModes ErrorHandlingMode
    {
      get { return errorHandlingMode; }
      set { errorHandlingMode = value; }
    }
    
  };

  public class Main
  {
    public MainConfig config;
    public const string ConfigMain = "main.xml";
    System.Timers.Timer recon;

    TasClient tas;
    public TasClient Tas {
      get {
        return tas;
      }
    }
    Spring spring;
    public Spring Spring {
      get {
        return spring;
      }
    }
    AutoHost autoHost;
    public AutoHost AutoHost {
      get {
        return autoHost;
      }
    }

    public void LoadConfig() {
      config = new MainConfig();
      if (File.Exists(ConfigMain)) {
        XmlSerializer s = new XmlSerializer(config.GetType());
        StreamReader r = File.OpenText(ConfigMain);
        config = (MainConfig)s.Deserialize(r);
        r.Close();
      }
    }

    public void SaveConfig() {
      
      XmlSerializer s = new XmlSerializer(config.GetType());
      FileStream f = File.OpenWrite(Application.StartupPath + '/' + ConfigMain);
      f.SetLength(0);
      s.Serialize(f , config);
      f.Close();
    
    }

    public Main() {
      LoadConfig();
      SaveConfig();
    }

    public void Start() {
      if (config.AttemptToRecconnect) {
        recon = new System.Timers.Timer(config.AttemptReconnectInterval * 1000);
        recon.Elapsed += new ElapsedEventHandler(recon_Elapsed);
      }

      recon.Enabled = false;

      try {
        spring = new Spring(config.SpringPath);
      } catch {
        MessageBox.Show("Spring not found in " + config.SpringPath, "error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        OpenFileDialog od = new OpenFileDialog();
        od.FileName = Spring.ExecutableName;
        od.DefaultExt = Path.GetExtension(Spring.ExecutableName);
        od.InitialDirectory = config.SpringPath;
        od.Title = "Please select your spring installation";
        od.RestoreDirectory = true;
        od.CheckFileExists = true;
        od.CheckPathExists = true;
        od.AddExtension = true;
        od.Filter = "Executable (*.exe)|*.exe";
        DialogResult dr = od.ShowDialog();
        if (dr == DialogResult.OK) {
          config.SpringPath = Path.GetDirectoryName(od.FileName);
          SaveConfig();
          spring = new Spring(config.SpringPath);
        } else {
          throw new Exception("Spring not found");
        }
      }
     
    
      tas = new TasClient();
      tas.ConnectionLost += new EventHandler<TasEventArgs>(tas_ConnectionLost);
      tas.Connected += new EventHandler<TasEventArgs>(tas_Connected);
      tas.LoginDenied += new EventHandler<TasEventArgs>(tas_LoginDenied);
      tas.LoginAccepted += new EventHandler<TasEventArgs>(tas_LoginAccepted);
      tas.Said += new EventHandler<TasSayEventArgs>(tas_Said);
      spring.SpringStarted += new EventHandler(spring_SpringStarted);
      spring.SpringExited += new EventHandler(spring_SpringExited);
      spring.PlayerSaid += new EventHandler<SpringLogEventArgs>(spring_PlayerSaid);
      autoHost = new AutoHost(tas, spring, null);
      try {
        tas.Connect(config.ServerHost, config.ServerPort);
      } catch {
        recon.Start();
      }
    }

    void tas_Said(object sender, TasSayEventArgs e)
    {
      if (config.RedirectGameChat && e.Place == TasSayEventArgs.Places.Battle && e.Origin == TasSayEventArgs.Origins.Player && e.UserName != tas.UserName && e.IsEmote == false ) {
        spring.SayGame("[" + e.UserName + "]" + e.Text);
      }
    }

    void spring_PlayerSaid(object sender, SpringLogEventArgs e)
    {
      tas.GameSaid(e.Username, e.Line);
      if (config.RedirectGameChat && e.Username != tas.UserName && !e.Line.StartsWith("Allies:") && !e.Line.StartsWith("Spectators:")) {
        tas.Say(TasClient.SayPlace.Battle, "", "[" + e.Username + "]" + e.Line, false);
      }
    }

    public void ReLogin() {
      tas_Connected(this, new TasEventArgs());      
    }

    void tas_LoginDenied(object sender, TasEventArgs e)
    {
      Program.formMain.GetNewLogPass();
    }

    void spring_SpringExited(object sender, EventArgs e)
    {
      if (tas != null) tas.ChangeMyStatus(false, false);
    }

    void spring_SpringStarted(object sender, EventArgs e)
    {
      if (tas != null) tas.ChangeMyStatus(false, true);
    }


    // login accepted - join channels
    void tas_LoginAccepted(object sender, TasEventArgs e)
    {
      for (int i =0; i<config.JoinChannels.Length; ++i) {
        tas.JoinChannel(config.JoinChannels[i]);
      }
      autoHost.Start(null, null);
    }

    // im connected, let's login
    void tas_Connected(object sender, TasEventArgs e)
    {
      tas.Login(config.AccountName, config.AccountPassword, MainConfig.SpringieVersion);
    }


    void recon_Elapsed(object sender, ElapsedEventArgs e)
    {
      recon.Stop();
      try {
        tas.Connect(config.ServerHost, config.ServerPort);
      } catch {
        recon.Start();
      }
    }

    void tas_ConnectionLost(object sender, TasEventArgs e)
    {
      autoHost.Stop();
      recon.Start();
    }
  }
}
