using System;
using System.Collections.Generic;

namespace Springie.Client
{
  // NOTE: all these stuffs are actually structures.. Why? To protected data from being modified when accessed by other modules. I'm too lazy to sort rights and make proper classes.
  /// <summary>
  /// Channel - active joined channels
  /// </summary>
  public struct Channel
  {
    public List<string> channelUsers;
    public string name;
    public string topic;
    public string topicSetBy;
    public DateTime topicSetDate;

    public static Channel Create(string name)
    {
      Channel c = new Channel();
      c.name = name;
      c.channelUsers = new List<string>();
      return c;
    }
  } ;

  /// <summary>
  /// Basic channel information - for channel enumeration
  /// </summary>
  public struct ExistingChannel
  {
    public string name;
    public string topic;
    public int userCount;
  } ;


  /// <summary>
  /// User - on the server
  /// </summary>
  public struct User
  {
    public string country;
    public int cpu;
    public bool isAdmin;
    public bool isAway;
    public bool isInGame;
    public string name;
    public int rank;

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
  } ;


  public class TasEventArgs : EventArgs
  {
    private List<string> serverParams = new List<string>();

    public TasEventArgs() {}

    public TasEventArgs(params string[] serverParams)
    {
      this.serverParams = new List<string>(serverParams);
    }

    public List<string> ServerParams
    {
      get { return serverParams; }
      set { serverParams = value; }
    }
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

    public static TasSayEventArgs Default = new TasSayEventArgs(Origins.Player, Places.Battle, "", "", "", false);
    private string channel;
    private bool isEmote;

    private Origins origin;
    private Places place;
    private string text;
    private string userName;

    public TasSayEventArgs(Origins origin, Places place, string channel, string username, string text, bool isEmote)
    {
      this.origin = origin;
      this.place = place;
      userName = username;
      this.text = text;
      this.isEmote = isEmote;
      this.channel = channel;
    }

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
  } ;

  public class TasClientException : Exception
  {
    public TasClientException() {}
    public TasClientException(string message) : base(message) {}
  } ;
}