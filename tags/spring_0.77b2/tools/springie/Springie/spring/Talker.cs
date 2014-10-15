using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Threading;
using System.Diagnostics;
using System.Net.Sockets;
using System.Net;
using System.Text;
using Springie.Client;

namespace Springie.SpringNamespace
{
  class Talker : IDisposable
  {
    public enum SpringEventType : byte
    {
      /// Server has started ()
      SERVER_STARTED = 0,

      /// Server is about to exit ()
      SERVER_QUIT = 1,

      /// Game starts ()
      SERVER_STARTPLAYING = 2,

      /// Game has ended ()
      SERVER_GAMEOVER = 3,

      /// Player has joined the game (uchar playernumber, string name)
      PLAYER_JOINED = 10,

      /// Player has left (uchar playernumber, uchar reason (0: lost connection, 1: left, 2: kicked) )
      PLAYER_LEFT = 11,

      /// Player has updated its ready-state (uchar playernumber, uchar state (0: not ready, 1: ready, 2: state not changed) )
      PLAYER_READY = 12,

      /// Player has sent a chat message (uchar playernumber, string text)
      PLAYER_CHAT = 13,

      /// Player has been defeated (uchar playernumber)
      PLAYER_DEFEATED = 14
    };

    public class SpringEventArgs : EventArgs
    {
      public SpringEventType EventType;
      public string PlayerName;
      public byte PlayerNumber = 0;
      public byte Param;
      public string Text;
    }





    protected bool close = false;

    int loopbackPort;
    public int LoopbackPort
    {
      get
      {
        return loopbackPort;
      }
    }

    Thread thread;
    UdpClient udp;
    int springTalkPort;
    List<Battle.GrPlayer> initialPlayers;

    public event EventHandler<SpringEventArgs> SpringEvent;


    public void SendText(string text)
    {
      byte[] bytes = Encoding.ASCII.GetBytes(text);
      udp.Send(bytes, bytes.Length, "127.0.0.1", springTalkPort);
    }

    
    public void SetPlayers(List<Battle.GrPlayer> players) {
      initialPlayers = players;
    }


    public Talker()
    {
      udp = new UdpClient(0);
      loopbackPort = ((IPEndPoint)udp.Client.LocalEndPoint).Port;

      thread = new Thread(delegate() { Listener(); });
      thread.Start();
    }

    private void Listener()
    {
      while (!close) {
        IPEndPoint endpoint = new IPEndPoint(IPAddress.Loopback, 0);
        byte[] data = udp.Receive(ref endpoint);
        if (endpoint.Port != loopbackPort) {
          springTalkPort = endpoint.Port;
        }
        if (data.Length > 0) {
          SpringEventArgs sea = new SpringEventArgs();

          sea.EventType = (SpringEventType)data[0];

          switch (sea.EventType) {
            case SpringEventType.PLAYER_JOINED:
              sea.PlayerNumber = data[1];
              sea.PlayerName = Encoding.ASCII.GetString(data, 2, data.Length - 2);
              break;
            case SpringEventType.PLAYER_LEFT:
              sea.PlayerNumber = data[1];
              sea.Param = data[2];
              break;
            case SpringEventType.PLAYER_READY:
              sea.PlayerNumber = data[1];
              sea.Param = data[2];
              break;

            case SpringEventType.PLAYER_CHAT:
              sea.PlayerNumber = data[1];
              sea.Text = Encoding.ASCII.GetString(data, 2, data.Length - 2);
              break;

            case SpringEventType.PLAYER_DEFEATED:
              sea.PlayerNumber = data[1];
              break;
          }
          if (sea.PlayerName == null) {
            sea.PlayerName = initialPlayers[sea.PlayerNumber].user.name;
          }

          if (SpringEvent != null) SpringEvent(this, sea);
        }
      }
    }

    public void Close()
    {
      close = true;
      UdpClient udclose = new UdpClient();
      udclose.Send(new byte[2] { 0, (byte)SpringEventType.SERVER_QUIT }, 1, "127.0.0.1", loopbackPort);
      thread.Join(1000);
    }


    #region IDisposable Members

    public void Dispose()
    {
      Close();
    }

    #endregion
  }
}
