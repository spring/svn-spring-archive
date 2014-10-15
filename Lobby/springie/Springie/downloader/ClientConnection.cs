using System.Text;

namespace Springie.Downloader
{
  /// <summary>
  /// Handles communiction with clients using client protocol
  /// </summary>
  public class ClientConnection : ServerConnection
  {
    protected override byte[] PrepareCommand(string command, object[] pars)
    {
      string prepstring = command + "|";
      if (pars != null) {
        for (int i = 0; i < pars.Length; ++i) {
          string s = pars[i] != null ? pars[i].ToString() : "";
          prepstring += MyEscape(s) + "|"; // if parameter starts with \t it's sentence seperator and we will ommit space
        }
      }
      prepstring += '\n';
      return Encoding.ASCII.GetBytes(prepstring);
    }

    protected override ServerConnectionEventArgs ParseCommand(string line)
    {
      var command = new ServerConnectionEventArgs();
      command.ServerConnection = this;
      if (line != null) {
        var args = line.Split('|'); // split arguments
        command.Command = args[0];
        command.Result = ServerConnectionEventArgs.ResultTypes.Success;
        command.Parameters = new string[args.Length - 1];
        for (int j = 1; j < args.Length; ++j) command.Parameters[j - 1] = MyUnescape(args[j]);
      } else {
        command.Result = ServerConnectionEventArgs.ResultTypes.NetworkError;
        command.Parameters = new string[] {};
        command.Command = "";
      }
      return command;
    }

  	protected static string MyEscape(string input)
		{
			return input.Replace("|", "&divider&");
		}

  	protected static string MyUnescape(string input)
		{
			return input.Replace("&divider&", "|");
		}

  }
}