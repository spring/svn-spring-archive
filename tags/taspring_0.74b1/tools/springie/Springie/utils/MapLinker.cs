using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Text.RegularExpressions;
using System.Timers;
using Springie.Client;
using Springie.SpringNamespace;

namespace Springie
{
  /// <summary>
  /// Class responsible for providing map links
  /// </summary>
  public class MapLinker
  {
    /************************************************************************/
    /*   PRIVATE ATTRIBS                                                    */
    /************************************************************************/
    const int DeleteCacheInterval = 3600; // inerval in seconds
    Dictionary<string, string> cachedResults = new Dictionary<string, string>();
    Timer timerDelResults = new Timer(DeleteCacheInterval * 1000);
    Spring spring;

    /************************************************************************/
    /*   PUBLIC METHODS                                                     */
    /************************************************************************/
    public MapLinker(Spring spring) {
      this.spring = spring;
      timerDelResults.Elapsed += new ElapsedEventHandler(timerDelResults_Elapsed);
      timerDelResults.Enabled = true;
    }

    /// <summary>
    /// Gets map link from .smf map name
    /// </summary>
    /// <param name="name">.smf based map name</param>
    /// <returns>maplink to download corresponding map archive</returns>
    public string GetLink(string name)
    {
      name = spring.GetMapArchiveName(name);
      return "http://www.unknown-files.net/bounce.php?filename=" + Uri.EscapeDataString(name);
    }

    /// <summary>
    /// Gets search results for full text map search
    /// </summary>
    /// <param name="name">Name to search for</param>
    /// <returns>Search results</returns>
    public string GetResults(string name)
    {
      if (cachedResults.ContainsKey(name)) {
        return cachedResults[name];
      }

      WebClient wc = new WebClient();
      string result = "";

      if (String.IsNullOrEmpty(name)) {
        return "you must type name of map, e.g. !maplink altored";
      }

      try {
        result = wc.DownloadString("http://www.unknown-files.net/?page=search&view=&searchdata=" + name + "&MainCategory=1&SubCategory=1_4&orderby=f_name&orderof=ASC&searchfield=0&Search=Search");
      } catch {
        return "link search failed, unknown files down :(";
      }
      if (result == "" || !result.Contains("?page=browse&dlid=")) {
        return "link search failed, contact Licho";
      }

      int start = result.IndexOf("<b>Search Results</b>");
      int end = result.IndexOf("<b>Quick Search</b>");
      if (start == -1 || end == -1) {
        return "no link found";
      }
      result = result.Substring(start, end - start); // pickup just result lines + something

      MatchCollection c = Regex.Matches(result, "<a href='(http://www.unknown-files.net/index.php\\?page=browse&dlid=[0-9]*)'>([^<]*)");
      string response = "";
      foreach (Match m in c) {
        response += m.Groups[2].Value + " ---> " + m.Groups[1].Value + "\n";
      }
      cachedResults[name] = response;
      return response;
    }


    /// <summary>
    /// Performs map search and says result
    /// </summary>
    /// <param name="name">map to search for</param>
    /// <param name="tas">tasclient to recieve response</param>
    /// <param name="e">say parameters (for forming response)</param>
    public void SayResults(string name, TasClient tas, TasSayEventArgs e)
    {
      SayLines(GetResults(name), tas, e);
    }


    /************************************************************************/
    /*   EVENT HANDLERS                                                     */
    /************************************************************************/
    void timerDelResults_Elapsed(object sender, ElapsedEventArgs e)
    {
      cachedResults = new Dictionary<string, string>();
    }


    /************************************************************************/
    /*   PRIVATE METHODS                                                    */
    /************************************************************************/
    private void SayLines(string text, TasClient tas, TasSayEventArgs e)
    {
      string[] lines = text.Split(new char[] {'\n'}, StringSplitOptions.RemoveEmptyEntries);
      foreach (string l in lines) {
        tas.Say(TasClient.SayPlace.User, e.UserName, l, false);
      }
    }
  }
}
