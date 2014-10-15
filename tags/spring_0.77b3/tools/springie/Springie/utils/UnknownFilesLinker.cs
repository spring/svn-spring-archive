#region using

using System;
using System.Collections.Generic;
using System.Net;
using System.Text.RegularExpressions;
using System.Timers;
using Springie.Client;
using Springie.SpringNamespace;

#endregion

namespace Springie
{
	/// <summary>
	/// Class responsible for providing map links
	/// </summary>
	public class UnknownFilesLinker
	{
		/************************************************************************/
		/*   PRIVATE ATTRIBS                                                    */
		/************************************************************************/

		#region Constants

		private const int DeleteCacheInterval = 3600; // inerval in seconds

		#endregion

		#region FileType enum

		public enum FileType
		{
			Map = 13,
			Mod = 14
		}

		#endregion

		#region Fields

		private Dictionary<string, string> cachedResults = new Dictionary<string, string>();
		private Spring spring;
		private Timer timerDelResults = new Timer(DeleteCacheInterval*1000);

		#endregion

		/************************************************************************/
		/*   PUBLIC METHODS                                                     */
		/************************************************************************/

		#region Constructors

		public UnknownFilesLinker(Spring spring)
		{
			this.spring = spring;
			timerDelResults.Elapsed += timerDelResults_Elapsed;
			timerDelResults.Enabled = true;
		}

		#endregion

		#region Public methods

		/// <summary>
		/// Gets map link from .smf map name
		/// </summary>
		/// <param name="name">.smf based map name</param>
		/// <returns>maplink to download corresponding map archive</returns>
		public string GetMapBounceLink(string name)
		{
			name = spring.GetMapArchiveName(name);
			return "http://spring.jobjol.nl/search_result.php?select_select=select_file_name&search=" + Uri.EscapeDataString(name) + "  Or use CaDownloader to auto get maps for game: http://caspring.org/wiki/CaUpdater";
		}

		/// <summary>
		/// Gets search results for full text map search
		/// </summary>
		/// <param name="name">Name to search for</param>
		/// <returns>Search results</returns>
		public string GetResults(string name, FileType type)
		{
			return "Use CaDownloader to get maps and mods automatically: http://caspring.org/wiki/CaUpdater";
			if (cachedResults.ContainsKey(name)) return cachedResults[name];

			var wc = new WebClient();
			string result = "";

			if (String.IsNullOrEmpty(name)) return "you must type name of map, e.g. !maplink altored";

			try {
				result = wc.DownloadString("http://spring.unknown-files.net/page/search/1/" + (int) type + "/" + name);
			} catch {
				return "link search failed, unknown files down :(";
			}
			if (result == "" || !result.Contains("http://spring.unknown-files.net/file/")) return "link search failed, contact Licho";

			int start = result.IndexOf("<b>Search Results</b>");
			int end = result.IndexOf("<b>Quick Search</b>");
			if (start == -1 || end == -1) return "no link found";
			result = result.Substring(start, end - start); // pickup just result lines + something

			var c = Regex.Matches(result, "<a href='(http://spring.unknown-files.net/file/[0-9]*)[^>]*>([^<]+)");
			string response = "";
			foreach (Match m in c) response += m.Groups[2].Value + " ---> " + m.Groups[1].Value + "\n";
			if (response == "") response = "no such map found";
			cachedResults[name] = response;
			return response;
		}


		/// <summary>
		/// Performs map search and says result
		/// </summary>
		/// <param name="name">map to search for</param>
		/// <param name="tas">tasclient to recieve response</param>
		/// <param name="e">say parameters (for forming response)</param>
		public void SayResults(string name, FileType type, TasClient tas, TasSayEventArgs e)
		{
			SayLines(GetResults(name, type), tas, e);
		}

		#endregion

		/************************************************************************/
		/*   EVENT HANDLERS                                                     */
		/************************************************************************/


		/************************************************************************/
		/*   PRIVATE METHODS                                                    */
		/************************************************************************/

		#region Other methods

		private void SayLines(string text, TasClient tas, TasSayEventArgs e)
		{
			var lines = text.Split(new[] {'\n'}, StringSplitOptions.RemoveEmptyEntries);
			foreach (var l in lines) tas.Say(TasClient.SayPlace.User, e.UserName, l, false);
		}

		#endregion

		#region Event Handlers

		private void timerDelResults_Elapsed(object sender, ElapsedEventArgs e)
		{
			cachedResults = new Dictionary<string, string>();
		}

		#endregion
	}
}