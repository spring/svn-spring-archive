using System;
using System.Net.Sockets;
using System.Text;

namespace Springie.Downloader
{
  /// <summary>
  /// Event arguments used in many ServerConnection events
  /// </summary>
  public class ServerConnectionEventArgs : EventArgs
  {
    #region ResultTypes enum

    public enum ResultTypes
    {
      Success,
      NetworkError,
      NotSet
    } ;

    #endregion

    private string command = "";
    private ResultTypes result = ResultTypes.NotSet;
    public ServerConnectionEventArgs() {}

    public ServerConnectionEventArgs(ServerConnection serverConnection, string command, string[] parameters)
    {
      ServerConnection = serverConnection;
      this.command = command;
      Parameters = parameters;
    }

    public string Command
    {
      get { return command; }
      set { command = value; }
    }

    public string[] Parameters { get; set; }

    public ResultTypes Result
    {
      get { return result; }
      set { result = value; }
    }

    public ServerConnection ServerConnection { get; set; }
  }


  /// <summary>
  /// Handles communiction with server on low level
  /// </summary>
  public abstract class ServerConnection : IDisposable
  {
    private readonly object myLock = new object();
    private bool isConnected;
    private bool isConnecting;
    protected Byte[] readBuffer;
    private int readPosition;
    protected TcpClient tcp;

    public bool IsConnecting
    {
      get { return isConnecting; }
    }

    public bool IsConnected
    {
      get { return isConnected; }
    }

    #region IDisposable Members

    public void Dispose()
    {
      Close();
    }

    #endregion

    public event EventHandler ConnectionClosed;
    public event EventHandler Connected;
    public event EventHandler<ServerConnectionEventArgs> CommandRecieved;

    public void Connect(string host, int port)
    {
      readPosition = 0;
      tcp = new TcpClient();
      try {
        isConnecting = true;
        tcp.BeginConnect(host, port, ConnectCallback, this);
      } catch {
        Close();
      }
    }


    protected abstract byte[] PrepareCommand(string command, object[] pars);


    public void SendCommand(string command, params string[] parameters)
    {
      if (IsConnected) {
        try {
          var buffer = PrepareCommand(command, parameters);
          tcp.GetStream().BeginWrite(buffer, 0, buffer.Length, CommandSentCallback, this);
        } catch (Exception ex) {
          ErrorHandling.HandleException(ex, "Error sending command");
          Close();
          return;
        }
      }
    }


    private static void ConnectCallback(IAsyncResult res)
    {
      var con = res.AsyncState as ServerConnection;
      try {
        con.tcp.EndConnect(res);
        con.readBuffer = new byte[con.tcp.ReceiveBufferSize];
        con.readPosition = 0;
        con.tcp.GetStream().BeginRead(con.readBuffer, 0, con.readBuffer.Length, DataRecieveCallback, con);
        con.isConnected = true;
        con.isConnecting = false;
        try {
          if (con.Connected != null) con.Connected(con, EventArgs.Empty);
        } catch (Exception ex) {
          ErrorHandling.HandleException(ex, "Error in connect callback");
        }
      } catch {
        con.Close();
      }
    }

    private static void CommandSentCallback(IAsyncResult res)
    {
      var serv = res.AsyncState as ServerConnection;
      try {
        serv.tcp.GetStream().EndWrite(res);
      } catch {
        serv.Close();
      }
    }


    protected abstract ServerConnectionEventArgs ParseCommand(string line);


    private static void DataRecieveCallback(IAsyncResult res)
    {
      var server = (ServerConnection) res.AsyncState;
      if (server.IsConnected) {
        try {
          int read = server.tcp.GetStream().EndRead(res); // actual data read - this blocks
          server.readPosition += read;
          if (read == 0) {
            server.Close();
            return;
          }
        } catch (Exception ex) {
          ErrorHandling.HandleException(ex, "Error while recieving data form server");
          // there was error while reading - stream is broken
          server.Close();
          return;
        }

        // check data for new line - isolating commands from it
        for (int i = server.readPosition - 1; i >= 0; --i) {
          if (server.readBuffer[i] == '\n') {
            // new line found - convert to string and parse commands

            String recData = Encoding.ASCII.GetString(server.readBuffer, 0, i + 1); // convert recieved bytes to string

            // cycle through lines of data
            foreach (var line in recData.Split(new[] {'\n'}, StringSplitOptions.RemoveEmptyEntries)) {
              // for each line = command do

              ServerConnectionEventArgs command;
              try {
                command = server.ParseCommand(line);
                try {
                  if (server.CommandRecieved != null) server.CommandRecieved(server, command);
                } catch (Exception ex) {
                  ErrorHandling.HandleException(ex, "Error processing command");
                  throw;
                }
              } catch (Exception ex) {
                ErrorHandling.HandleException(ex, "Error parsing command " + line);
              }
            }

            // copy remaining data (not ended by \n yet) to the beginning of buffer
            for (int x = 0; x < server.readPosition - i - 1; ++x) server.readBuffer[x] = server.readBuffer[x + i + 1];
            server.readPosition = server.readPosition - i - 1;
            break;
          }
        }

        // prepare to read more data
        int rembuf = server.readBuffer.Length - server.readPosition;
        if (rembuf <= 0) {
          // read buffer too small, increase it
          var n = new byte[server.readBuffer.Length*2];
          server.readBuffer.CopyTo(n, 0);
          server.readBuffer = n;
          rembuf = server.readBuffer.Length - server.readPosition;
        }

        try {
          server.tcp.GetStream().BeginRead(server.readBuffer, server.readPosition, rembuf, DataRecieveCallback, server);
        } catch (Exception ex) {
          // there was error while reading - stream is broken
          ErrorHandling.HandleException(ex, "Error recieving data");
          server.Close();
          return;
        }
      }
    }


    /// <summary>
    /// Closes connection to remote server
    /// </summary>
    public void Close()
    {
      lock (myLock) {
        CommandRecieved = null;
        Connected = null;
        isConnected = false;
        isConnecting = false;
        try {
          tcp.GetStream().Close();
          tcp.Close();
        } catch {}

        try {
          if (ConnectionClosed != null) ConnectionClosed(this, EventArgs.Empty);
        } catch (Exception ex) {
          ErrorHandling.HandleException(ex, "Error procesing connection close");
        }
        ConnectionClosed = null;
      }
    }
  }
}