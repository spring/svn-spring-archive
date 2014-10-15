using System;
using System.Collections.Generic;
using System.Text;

namespace Springie.Client
{
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
