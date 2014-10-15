using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.ComponentModel;

namespace Springie
{
  public class MainConfig
  {
    public const string SpringieVersion = "Springie 0.94b";

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
    public string ServerHost
    {
      get { return serverHost; }
      set { serverHost = value; }
    }

    int serverPort = 8200;
    [Description("Lobby server port")]
    [Category("Server connection")]
    public int ServerPort
    {
      get { return serverPort; }
      set { serverPort = value; }
    }


    string statsUrl = "http://unknown-files.net/stats/";
    [Description("Url of stats data gathering service")]
    [Category("Server connection")]
    public string StatsUrl
    {
      get { return statsUrl; }
      set { if (!value.EndsWith("/")) value += "/"; statsUrl = value; }
    }


    bool gargamelMode = true;
    [Description("Should this autohost work in gargamel mode (catch smurfs)")]
    [Category("Server connection")]
    public bool GargamelMode
    {
      get { return gargamelMode; }
      set { gargamelMode = value; }
    }


    bool statsEnabled = true;
    [Description("Should this server report data to stats server?")]
    [Category("Server connection")]
    public bool StatsEnabled
    {
      get { return statsEnabled; }
      set { statsEnabled = value; }
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
    [Category("Spring"), Description("Default hosting spring window width")]
    public int SpringResolutionX
    {
      get { return springResolutionX; }
      set { springResolutionX = value; }
    }

    int springResolutionY = 2;
    [Category("Spring"), Description("Default hosting spring window height")]
    public int SpringResolutionY
    {
      get { return springResolutionY; }
      set { springResolutionY = value; }
    }

    bool springFullscreen = false;
    [Category("Spring"), Description("Should hosting spring start as fullscreen")]
    public bool SpringFullscreen
    {
      get { return springFullscreen; }
      set { springFullscreen = value; }
    }


    bool springStartsHidden = true;
    [Category("Spring"), Description("Should hosting spring start hidden by default")]
    public bool SpringStartsHidden
    {
      get { return springStartsHidden; }
      set { springStartsHidden = value; }
    }

    bool springStartsMinimized = true;
    [Category("Spring"), Description("Should hosting spring start minimized by default")]
    public bool SpringStartsMinimized
    {
      get { return springStartsMinimized; }
      set { springStartsMinimized = value; }
    }

    bool redirectGameChat = true;
    [Category("Spring"), Description("Should springie redirect global game chat to lobby?")]
    public bool RedirectGameChat
    {
      get { return redirectGameChat; }
      set { redirectGameChat = value; }
    }


    ProcessPriorityClass hostingProcessPriority = ProcessPriorityClass.Normal;
    [Category("Spring"), Description("Sets the priority of spring hosting process")]
    public ProcessPriorityClass HostingProcessPriority
    {
      get { return hostingProcessPriority; }
      set { hostingProcessPriority = value; }
    }


    public enum ErrorHandlingModes : int { Debug, Suppress, MessageBox }
    ErrorHandlingModes errorHandlingMode = ErrorHandlingModes.Suppress;
    [Category("Springie"), Description("Determines the way in which Springie handles unexpected errors. For general purpose use Suppress, for instant notification and stop on error use MessageBox mode and for debugging use Debug")]
    public ErrorHandlingModes ErrorHandlingMode
    {
      get { return errorHandlingMode; }
      set { errorHandlingMode = value; }
    }
  };
}