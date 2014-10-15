#region using

using System;
using System.Net.Sockets;
using System.Text;

#endregion

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

		#region Fields

		private string command = "";

		private ResultTypes result = ResultTypes.NotSet;

		#endregion

		#region Properties

		public string Command
		{
			get { return command; }
			set { command = value; }
		}

		public object[] Parameters { get; set; }
		public int RequestId { get; set; }

		public ResultTypes Result
		{
			get { return result; }
			set { result = value; }
		}

		public ServerConnection ServerConnection { get; set; }

		#endregion

		#region Constructors

		public ServerConnectionEventArgs() {}

		public ServerConnectionEventArgs(ServerConnection serverConnection, int requestId, string command, object[] parameters)
		{
			this.ServerConnection = serverConnection;
			this.RequestId = requestId;
			this.command = command;
			this.Parameters = parameters;
		}

		#endregion
	}


	/// <summary>
	/// Handles communiction with server on low level
	/// </summary>
	public class ServerConnection : IDisposable
	{
		#region Fields

		private int commandNumber;
		private object myLock = new object();
		private Byte[] readBuffer;
		private int readPosition;
		private NetworkStream stream;
		private TcpClient tcp;

		#endregion

		#region Events

		/// <summary>
		/// Raised when command is recieved from the server
		/// </summary>
		public event EventHandler<ServerConnectionEventArgs> CommandRecieved;

		/// <summary>
		/// Raised when command has finished sending
		/// </summary>
		public event EventHandler<ServerConnectionEventArgs> CommandSent;

		/// <summary>
		/// raised when connection is closed 
		/// </summary>
		public event EventHandler ConnectionClosed;

		#endregion

		#region Constructors

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

		public void Dispose()
		{
			Close();
		}

		#endregion

		#region Public methods

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
			stream.BeginRead(readBuffer, 0, readBuffer.Length, DataRecieveCallback, this);
		}

		/// <summary>
		/// Sends command to server
		/// </summary>
		/// <param name="id">command id - use this to internally track when command finished sending</param>
		/// <param name="command">command</param>
		/// <param name="parameters">command parameters</param>
		public void SendCommand(int id, string command, params object[] parameters)
		{
			var eventArgs = new ServerConnectionEventArgs(this, id, command, parameters);
			if (stream != null && stream.CanWrite) {
				try {
					var buffer = PrepareCommand(command, parameters);
					stream.BeginWrite(buffer, 0, buffer.Length, CommandSentCallback, eventArgs);
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

		#endregion

		#region Other methods

		private static void CommandSentCallback(IAsyncResult res)
		{
			var arg = (ServerConnectionEventArgs) res.AsyncState;
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
			var server = (ServerConnection) res.AsyncState;
			try {
				int cnt = server.stream.EndRead(res); // actual data read - this blocks
				server.readPosition += cnt;
				if (cnt == 0) {
					server.Close();
					return;
				}
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
					foreach (var line in recData.Split(new[] {'\n'}, StringSplitOptions.RemoveEmptyEntries)) {
						// for each line = command do
						var args = line.Split(' '); // split arguments
						/*for (int j = 0; j < args.Length; ++j) { // replace \t with ' ' in every argument
              args[j] = args[j].Replace('\t', ' ');
            }*/

						// prepare and send command recieved info
						var command = new ServerConnectionEventArgs();
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
				var n = new byte[server.readBuffer.Length*2];
				server.readBuffer.CopyTo(n, 0);
				server.readBuffer = n;
				rembuf = server.readBuffer.Length - server.readPosition;
			}

			try {
				server.stream.BeginRead(server.readBuffer, server.readPosition, rembuf, DataRecieveCallback, server);
			} catch {
				// there was error while reading - stream is broken
				server.Close();
				return;
			}
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
			return Encoding.ASCII.GetBytes(prepstring);
		}

		#endregion
	}
}