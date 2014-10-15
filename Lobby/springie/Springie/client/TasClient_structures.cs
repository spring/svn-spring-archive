#region using

using System;
using System.Collections.Generic;

#endregion

namespace Springie.Client
{
	// NOTE: all these stuffs are actually structures.. Why? To protected data from being modified when accessed by other modules. I'm too lazy to sort rights and make proper classes.
	/// <summary>
	/// Channel - active joined channels
	/// </summary>
	public struct Channel
	{
		#region Properties

		public List<string> channelUsers;
		public string name;
		public string topic;
		public string topicSetBy;
		public DateTime topicSetDate;

		#endregion

		#region Public methods

		public static Channel Create(string name)
		{
			var c = new Channel();
			c.name = name;
			c.channelUsers = new List<string>();
			return c;
		}

		#endregion
	} ;

	/// <summary>
	/// Basic channel information - for channel enumeration
	/// </summary>
	public struct ExistingChannel
	{
		#region Properties

		public string name;
		public string topic;
		public int userCount;

		#endregion
	} ;


	/// <summary>
	/// User - on the server
	/// </summary>
	public struct User
	{
		#region Properties

		public string country;
		public int cpu;
		public bool isAdmin;
		public bool isAway;
		public bool isInGame;
		public string name;
		public int rank;

		#endregion

		#region Public methods

		public static User Create(string name)
		{
			var u = new User();
			u.name = name;
			return u;
		}

		public void FromInt(int status)
		{
			isInGame = (status & 1) > 0;
			isAway = (status & 2) > 0;
			isAdmin = (status & 32) > 0;
			rank = (status & 28) >> 2;
		}

		public int ToInt()
		{
			int res = 0;
			res |= isInGame ? 1 : 0;
			res |= isAway ? 2 : 0;
			return res;
		}

		#endregion
	} ;


	public class TasEventArgs : EventArgs
	{
		#region Fields

		private List<string> serverParams = new List<string>();

		#endregion

		#region Properties

		public List<string> ServerParams
		{
			get { return serverParams; }
			set { serverParams = value; }
		}

		#endregion

		#region Constructors

		public TasEventArgs() {}

		public TasEventArgs(params string[] serverParams)
		{
			this.serverParams = new List<string>(serverParams);
		}

		#endregion
	} ;


	public class TasSayEventArgs : EventArgs
	{
		#region Origins enum

		public enum Origins
		{
			Server,
			Player
		}

		#endregion

		#region Places enum

		public enum Places
		{
			Normal,
			Motd,
			Channel,
			Battle,
			MessageBox,
			Broadcast,
			Game
		}

		#endregion

		#region Properties

		public string Channel { get; set; }
		public static TasSayEventArgs Default = new TasSayEventArgs(Origins.Player, Places.Battle, "", "", "", false);

		public bool IsEmote { get; set; }

		public Origins Origin { get; set; }

		public Places Place { get; set; }

		public string Text { get; set; }

		public string UserName { get; set; }

		#endregion

		#region Constructors

		public TasSayEventArgs(Origins origin, Places place, string channel, string username, string text, bool isEmote)
		{
			this.Origin = origin;
			this.Place = place;
			UserName = username;
			this.Text = text;
			this.IsEmote = isEmote;
			this.Channel = channel;
		}

		#endregion
	} ;

	public class TasClientException : Exception
	{
		#region Constructors

		public TasClientException() {}
		public TasClientException(string message) : base(message) {}

		#endregion
	} ;
}