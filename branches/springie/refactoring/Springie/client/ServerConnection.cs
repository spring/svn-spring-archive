using System;
using System.Net.Sockets;
using System.Text;

namespace Springie.Client
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

    private object[] parameters;
    private int requestId = 0;

    private ResultTypes result = ResultTypes.NotSet;

    private ServerConnection serverConnection = null;


    public ServerConnectionEventArgs() {}

    public ServerConnectionEventArgs(ServerConnection serverConnection, int requestId, string command, object[] parameters)
    {
      this.serverConnection = serverConnection;
      this.requestId = requestId;
      this.command = command;
      this.parameters = parameters;
    }

    public int RequestId
    {
      get { return requestId; }
      set { requestId = value; }
    }

    public string Command
    {
      get { return command; }
      set { command = value; }
    }

    public object[] Parameters
    {
      get { return parameters; }
      set { parameters = value; }
    }

    public ResultTypes Result
    {
      get { return result; }
      set { result = value; }
    }

    public ServerConnection ServerConnection
    {
      get { return serverConnection; }
      set { serverConnection = value; }
    }
  }


  /// <summary>
  /// Handles communiction with server on low level
  /// </summary>
  public class ServerConnection : IDisposable
  {
    private int commandNumber = 0;
    private object myLock = new object();
    private Byte[] readBuffer;
    private int readPosition = 0;
    private NetworkStream stream;
    private TcpClient tcp;

    public ServerConnection() {}

    /// <summary>
    /// Creates object and connects to TA server
    /// </summary>
    /// <param name="host">server host</param>
    /// <param name="port">server port</param>
    public ServerConnection(string host, int port)
    {
      Connect(host, port);
    }

    #region IDisposable Members
    public void Dispose()
    {
      Close();
    }
    #endregion

    /// <summary>
    /// Raised when command has finished sending
    /// </summary>
    public event EventHandler<ServerConnectionEventArgs> CommandSent;

    /// <summary>
    /// raised when connection is closed 
    /// </summary>
    public event EventHandler ConnectionClosed;

    /// <summary>
    /// Raised when command is recieved from the server
    /// </summary>
    public event EventHandler<ServerConnectionEventArgs> CommandRecieved;


    /// <summary>
    /// Connects to TA server and resets internal data
    /// </summary>
    /// <param name="host">server host</param>
    /// <param name="port">server port</param>
    public void Connect(string host, int port)
    {
      tcp = new TcpClient(host, port);
      stream = tcp.GetStream();
      readBuffer = new byte[tcp.ReceiveBufferSize];
      readPosition = 0;
      stream.BeginRead(readBuffer, 0, readBuffer.Length, new AsyncCallback(DataRecieveCallback), this);
    }

    /// <summary>
    /// Prepares byte array with command
    /// </summary>
    /// <param name="command">command</param>
    /// <param name="pars">command parameters</param>
    /// <returns></returns>
    private byte[] PrepareCommand(string command, object[] pars)
    {
      string prepstring = command;
      for (int i = 0; i < pars.Length; ++i) {
        string s = pars[i].ToString();

        prepstring += (s[0] == '\t' ? "" : " ") + s; // if parameter starts with \t it's sentence seperator and we will ommit space
      }
      prepstring += '\n';
      return ASCIIEncoding.ASCII.GetBytes(prepstring);
    }

    /// <summary>
    /// Sends command to server
    /// </summary>
    /// <param name="id">command id - use this to internally track when command finished sending</param>
    /// <param name="command">command</param>
    /// <param name="parameters">command parameters</param>
    public void SendCommand(int id, string command, params object[] parameters)
    {
      ServerConnectionEventArgs eventArgs = new ServerConnectionEventArgs(this, id, command, parameters);
      if (stream != null && stream.CanWrite) {
        try {
          byte[] buffer = PrepareCommand(command, parameters);
          stream.BeginWrite(buffer, 0, buffer.Length, new AsyncCallback(CommandSentCallback), eventArgs);
        } catch {
          eventArgs.Result = ServerConnectionEventArgs.ResultTypes.NetworkError;
          if (CommandSent != null) CommandSent(this, eventArgs);
          Close();
          return;
        }
      } else {
        eventArgs.Result = ServerConnectionEventArgs.ResultTypes.NetworkError;
        if (CommandSent != null) CommandSent(this, eventArgs);
      }
    }


    private static void CommandSentCallback(IAsyncResult res)
    {
      ServerConnectionEventArgs arg = (ServerConnectionEventArgs)res.AsyncState;
      arg.Result = ServerConnectionEventArgs.ResultTypes.Success;
      try {
        arg.ServerConnection.stream.EndWrite(res);
      } catch {
        arg.Result = ServerConnectionEventArgs.ResultTypes.NetworkError;
        arg.ServerConnection.Close();
        return;
      }
      if (arg.ServerConnection.CommandSent != null) arg.ServerConnection.CommandSent(arg.ServerConnection, arg);
    }


    private static void DataRecieveCallback(IAsyncResult res)
    {
      ServerConnection server = (ServerConnection)res.AsyncState;
      try {
        server.readPosition += server.stream.EndRead(res); // actual data read - this blocks
      } catch {
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
          foreach (string line in recData.Split(new char[] {'\n'}, StringSplitOptions.RemoveEmptyEntries)) {
            // for each line = command do
            string[] args = line.Split(' '); // split arguments
            /*for (int j = 0; j < args.Length; ++j) { // replace \t with ' ' in every argument
              args[j] = args[j].Replace('\t', ' ');
            }*/

            // prepare and send command recieved info
            ServerConnectionEventArgs command = new ServerConnectionEventArgs();
            command.ServerConnection = server;
            command.RequestId = server.commandNumber++;
            command.Command = args[0];
            command.Result = ServerConnectionEventArgs.ResultTypes.Success;
            command.Parameters = new string[args.Length - 1];
            for (int j = 1; j < args.Length; ++j) command.Parameters[j - 1] = args[j];
            if (server.CommandRecieved != null) server.CommandRecieved(server, command);
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
        byte[] n = new byte[server.readBuffer.Length*2];
        server.readBuffer.CopyTo(n, 0);
        server.readBuffer = n;
        rembuf = server.readBuffer.Length - server.readPosition;
      }

      try {
        server.stream.BeginRead(server.readBuffer, server.readPosition, rembuf, new AsyncCallback(DataRecieveCallback), server);
      } catch {
        // there was error while reading - stream is broken
        server.Close();
        return;
      }
    }


    /// <summary>
    /// Closes connection to remote server
    /// </summary>
    public void Close()
    {
      lock (myLock) {
        CommandRecieved = null;
        CommandSent = null;
        if (tcp != null && tcp.Connected) tcp.Close();
        stream = null;
        tcp = null;
        if (ConnectionClosed != null) ConnectionClosed(this, EventArgs.Empty);
        ConnectionClosed = null;
      }
    }
  }
}