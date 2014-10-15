#region using

using System;
using System.Collections.Generic;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading;
using Springie.SpringNamespace;

#endregion

namespace Springie
{
	/// <summary>
	/// Class responsible for downloading new Mods to spring
	/// </summary>
	internal class FileDownloader
	{
		#region FileType enum

		/// <summary>
		/// Download progress has changed
		/// </summary>
		//public event EventHandler<TasEventArgs> DownloadProgressChanged;
		/// <summary>
		/// How often to report progresschanged (in percents)
		/// </summary>
		//public const int ReportPercentStep = 20;
		public enum FileType
		{
			Map,
			Mod
		}

		#endregion

		#region Status enum

		public enum Status
		{
			Done,
			Failed
		} ;

		#endregion

		#region Fields

		private DownloadItem currentDownload;
		private Queue<DownloadItem> downloadQueue = new Queue<DownloadItem>();
		private Thread downloadThread;

		/************************************************************************/
		/*    PRIVATE ATTRIBS                                                   */
		/************************************************************************/

		private Spring spring;
		private WebClient wc;

		#endregion

		/************************************************************************/
		/*    PUBLIC METHODS                                                    */
		/************************************************************************/

		#region Events

		/// <summary>
		/// Download completed (either successfully or unsuccessfully)
		/// </summary>
		public event EventHandler<DownloadEventArgs> DownloadCompleted;

		#endregion

		#region Constructors

		/// <summary>
		/// Initializes Mod downloader
		/// </summary>
		public FileDownloader(Spring spring)
		{
			this.spring = spring;
		}

		#endregion

		#region Public methods

		/// <summary>
		/// Queues file for download
		/// </summary>
		public void DownloadFile(string url, string fileName, FileType fileType)
		{
			var d = new DownloadItem();
			d.url = new Uri(url);
			d.fileType = fileType;
			if (fileType == FileType.Map) d.targetPath = spring.Path + "maps/";
			else if (fileType == FileType.Mod) d.targetPath = spring.Path + "mods/";
			d.fileName = fileName;
			downloadQueue.Enqueue(d);

			if (downloadQueue.Count == 1 && (downloadThread == null || downloadThread.IsAlive == false)) {
				downloadThread = new Thread(delegate()
				                            	{
				                            		wc = new WebClient();
				                            		GetNext();
				                            	});
				downloadThread.Start();
			}
		}


		/// <summary>
		/// Prepares map download
		/// </summary>
		/// <param name="mapNameUrlOrId"></param>
		public void DownloadMap(string mapNameUrlOrId)
		{
			string realFileName = "";

			if (IsFileUrl(mapNameUrlOrId, out realFileName)) {
				DownloadFile(mapNameUrlOrId, realFileName, FileType.Map);
				return;
			}

			try {
				var wc2 = new WebClient();
				string result = "";
				if (mapNameUrlOrId.Contains(".")) {
					result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + mapNameUrlOrId.Replace(".smf", ".sd7")); // try sd7 first

					if (result == "error" || result == "") result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + mapNameUrlOrId.Replace(".smf", ".sdz")); //then sdz
				} else result = wc2.DownloadString("http://www.unknown-files.net/licho.php?id=" + mapNameUrlOrId);

				string realUrl = "";
				try {
					realUrl = Regex.Match(result, "file=(.*)").Groups[1].Value;
					realFileName = Regex.Match(result, "filename=([^\\&]+)").Groups[1].Value;
				} catch {
					if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, mapNameUrlOrId), Status.Failed, "File not found"));
					return;
				}
				if (realFileName == "") {
					if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, mapNameUrlOrId), Status.Failed, "File not found"));
					return;
				}

				string mapSmf = realFileName.Substring(0, realFileName.LastIndexOf('.')) + ".smf";
				if (spring.UnitSync.HasMap(mapSmf)) {
					// we have this map already let's fuck this
					if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, mapNameUrlOrId), Status.Failed, "We already have this map"));
					return;
				}

				DownloadFile(realUrl, realFileName, FileType.Map);
			} catch {
				if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, mapNameUrlOrId), Status.Failed, "Error while determining map URL"));
				return;
			}
		}


		/// <summary>
		/// Prepares mod download
		/// </summary>
		/// <param name="modNameUrlOrId"></param>
		public void DownloadMod(string modUrlOrId)
		{
			string realFileName = "";

			if (IsFileUrl(modUrlOrId, out realFileName)) {
				DownloadFile(modUrlOrId, realFileName, FileType.Mod);
				return;
			}

			try {
				var wc2 = new WebClient();
				string result = "";

				// otherwise use unknown files
				result = wc2.DownloadString("http://www.unknown-files.net/licho.php?id=" + modUrlOrId + "&mod=yes");

				realFileName = "";
				try {
					realFileName = Regex.Match(result, "file=([^\\&]+)").Groups[1].Value;
				} catch {
					if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, modUrlOrId), Status.Failed, "File not found"));
					return;
				}
				if (realFileName == "") {
					if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, modUrlOrId), Status.Failed, "File not found"));
					return;
				}

				DownloadFile(result, realFileName, FileType.Mod);
			} catch {
				if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, modUrlOrId), Status.Failed, "Error while determining mod URL"));
				return;
			}
		}

		public static bool IsFileUrl(string what, out string fileName)
		{
			fileName = "";
			if (what.StartsWith("http://") || what.StartsWith("ftp://")) {
				var fs = what.Split(new[] {'/', '\\', '?'}, StringSplitOptions.RemoveEmptyEntries);
				if (fs.Length > 0) {
					fileName = fs[fs.Length - 1];
					return true;
				}
			}
			return false;
		}

		#endregion

		/************************************************************************/
		/*     EVENT HANDLERS                                                   */
		/************************************************************************/
		/*void wc_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
    {
      if (e.ProgressPercentage >= lastPercent + ReportPercentStep) {
        lastPercent = (e.ProgressPercentage / ReportPercentStep) * ReportPercentStep;
        if (DownloadProgressChanged != null) DownloadProgressChanged(this, new TasEventArgs(currentDownload.fileName, e.ProgressPercentage.ToString()));
      }
    }


    void wc_DownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
    {
      if (e.Error != null || e.Cancelled) {
        string ername = e.Error != null ? e.Error.Message : "cancelled";
        if (DownloadCompleted != null) DownloadCompleted(this, new TasEventArgs(currentDownload.fileName, ername));
      } else if (DownloadCompleted != null) DownloadCompleted(this, new TasEventArgs(currentDownload.fileName));
      GetNext();
    }*/

		/************************************************************************/
		/*     STATIC METHODS                                                   */
		/************************************************************************/


		/************************************************************6************/
		/*    PRIVATE METHODS                                                   */
		/************************************************************************/

		#region Other methods

		/// <summary>
		/// Tries to handle next request from queue
		/// </summary>
		private void GetNext()
		{
			if (downloadQueue.Count == 0 || wc.IsBusy) return;

			currentDownload = downloadQueue.Dequeue();
			// lastPercent = 0;
			try {
				wc.DownloadFile(currentDownload.url, currentDownload.targetPath + "/" + currentDownload.fileName);

				if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(currentDownload, Status.Done, ""));
			} catch (Exception e) {
				if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(currentDownload, Status.Failed, e.Message));
			}
			GetNext();

			//wc.DownloadFileAsync(currentDownload.url, currentDownload.targetPath + "/" + currentDownload.fileName);
		}

		#endregion

		#region Nested type: DownloadEventArgs

		public class DownloadEventArgs : EventArgs
		{
			#region Properties

			public DownloadItem DownloadItem;
			public string Message;
			public Status Status;

			#endregion

			#region Constructors

			public DownloadEventArgs(DownloadItem item, Status status, string message)
			{
				DownloadItem = item;
				Status = status;
				Message = message;
			}

			#endregion
		}

		#endregion

		#region Nested type: DownloadItem

		public class DownloadItem
		{
			#region Properties

			public string fileName;
			public FileType fileType;
			public string targetPath;
			public Uri url;

			#endregion

			#region Constructors

			public DownloadItem() {}

			public DownloadItem(FileType fileType, string fileName)
			{
				this.fileType = fileType;
				this.fileName = fileName;
			}

			#endregion
		} ;

		#endregion
	}
}