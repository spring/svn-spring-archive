using System;
using System.Collections.Generic;
using System.Text;
using System.Net;

namespace Springie.Client
{
  // NOTE: all these stuffs are actually structures.. Why? To protected data from being modified when accessed by other modules. I'm too lazy to sort rights and make proper classes.
  /// <summary>
  /// Channel - active joined channels
  /// </summary>
  public struct Channel
  {
    public string name;
    public string topic;
    public string topicSetBy;
    public DateTime topicSetDate;
    public List<string> channelUsers;

    public static Channel Create(string name)
    {
      Channel c = new Channel();
      c.name = name;
      c.channelUsers = new List<string>();
      return c;
    }
  };

  /// <summary>
  /// Basic channel information - for channel enumeration
  /// </summary>
  public struct ExistingChannel
  {
    public string name;
    public int userCount;
    public string topic;
  };


  /// <summary>
  /// User - on the server
  /// </summary>
  public struct User
  {
    public string name;
    public int cpu;
    public string country;
    public bool isInGame;
    public bool isAway;
    public int rank;
    public bool isAdmin;
    public static User Create(string name)
    {
      User u = new User();
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
  };




  public class TasEventArgs : EventArgs
  {
    List<string> serverParams = new List<string>();
    public List<string> ServerParams
    {
      get { return serverParams; }
      set { serverParams = value; }
    }

    public TasEventArgs() { }
    public TasEventArgs(params string[] serverParams)
    {
      this.serverParams = new List<string>(serverParams);
    }
  };


  public class TasSayEventArgs : EventArgs
  {
    public enum Origins { Server, Player }
    public enum Places { Normal, Motd, Channel, Battle, MessageBox, Broadcast, Game }

    public static TasSayEventArgs Default = new TasSayEventArgs(Origins.Player, Places.Battle, "", "", "", false);

    Origins origin;
    Places place;
    string text;
    bool isEmote;
    string userName;
    string channel;

    public string Channel
    {
      get { return channel; }
      set { channel = value; }
    }

    public bool IsEmote
    {
      get { return isEmote; }
      set { isEmote = value; }
    }
    public Origins Origin
    {
      get { return origin; }
      set { origin = value; }
    }

    public Places Place
    {
      get { return place; }
      set { place = value; }
    }

    public string Text
    {
      get { return text; }
      set { text = value; }
    }

    public string UserName
    {
      get { return userName; }
      set { userName = value; }
    }


    public TasSayEventArgs(Origins origin, Places place, string channel, string username, string text, bool isEmote)
    {
      this.origin = origin;
      this.place = place;
      this.userName = username;
      this.text = text;
      this.isEmote = isEmote;
      this.channel = channel;
    }

  };

  public class TasClientException : Exception
  {
    public TasClientException() { }
    public TasClientException(string message)
      : base(message)
    {
    }
  };




}
