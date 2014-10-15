using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;
using System.Net.Sockets;
using System.Text.RegularExpressions;
using System.Collections;
using Springie.Client;
using Springie.SpringNamespace;
using System.Security.Policy;
using System.Threading;

namespace Springie
{
  /// <summary>
  /// Class responsible for downloading new Mods to spring
  /// </summary>
  class FileDownloader
  {
    public enum Status { Done, Failed };
    public class DownloadEventArgs:EventArgs {
      public DownloadItem DownloadItem;
      public Status Status;
      public string Message;
      public DownloadEventArgs(DownloadItem item, Status status, string message) {
        this.DownloadItem = item;
        this.Status = status;
        this.Message = message;
      }
    }

    /************************************************************************/
    /*    PUBLIC ATTRIBS                                                    */
    /************************************************************************/
    /// <summary>
    /// Download completed (either successfully or unsuccessfully)
    /// </summary>
    public event EventHandler<DownloadEventArgs> DownloadCompleted;

    /// <summary>
    /// Download progress has changed
    /// </summary>
    //public event EventHandler<TasEventArgs> DownloadProgressChanged;

    /// <summary>
    /// How often to report progresschanged (in percents)
    /// </summary>
    //public const int ReportPercentStep = 20;

    public enum FileType { Map, Mod }

    /************************************************************************/
    /*    PRIVATE ATTRIBS                                                   */
    /************************************************************************/
    public class DownloadItem
    {
      public Uri url;
      public string fileName;
      public string targetPath;
      public FileType fileType;
      public DownloadItem(){}
      public DownloadItem(FileType fileType, string fileName) {
        this.fileType = fileType;
        this.fileName = fileName;
      }
    };

    Spring spring;
    WebClient wc = null;
    Thread downloadThread = null;

    //int lastPercent = 0;
    Queue<DownloadItem> downloadQueue = new Queue<DownloadItem>();
    DownloadItem currentDownload = null;


    /************************************************************************/
    /*    PUBLIC METHODS                                                    */
    /************************************************************************/
    /// <summary>
    /// Initializes Mod downloader
    /// </summary>
    public FileDownloader(Spring spring)
    {
      this.spring = spring;
    }


    /// <summary>
    /// Queues file for download
    /// </summary>
    public void DownloadFile(string url, string fileName, FileType fileType)
    {
      DownloadItem d = new DownloadItem();
      d.url = new Uri(url);
      d.fileType = fileType;
      if (fileType == FileType.Map) d.targetPath = spring.Path + "maps/";
      else if (fileType == FileType.Mod) d.targetPath = spring.Path + "mods/";
      d.fileName = fileName;
      downloadQueue.Enqueue(d);

      if (downloadQueue.Count == 1 && (downloadThread == null || downloadThread.IsAlive == false)) {
        downloadThread = new Thread(delegate() {
          wc = new WebClient();
          GetNext(); });
        downloadThread.Start();
      }
    }


    public static bool IsFileUrl(string what, out string fileName) {
      fileName = "";
      if (what.StartsWith("http://") || what.StartsWith("ftp://")) {
        string[] fs = what.Split(new char[] { '/', '\\', '?' }, StringSplitOptions.RemoveEmptyEntries);
        if (fs.Length > 0) {
          fileName = fs[fs.Length - 1];
          return true;
        }
      }
      return false;
    }


    /// <summary>
    /// Prepares map download
    /// </summary>
    /// <param name="mapNameUrlOrId"></param>
    public void DownloadMap(string mapNameUrlOrId)
    {
      string realFileName = "";
      
      if (FileDownloader.IsFileUrl(mapNameUrlOrId, out realFileName)) {
        DownloadFile(mapNameUrlOrId, realFileName, FileType.Map);
        return;
      }
      
      try {
        WebClient wc2 = new WebClient();
        string result = "";
        if (mapNameUrlOrId.Contains(".")) {
          result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + mapNameUrlOrId.Replace(".smf", ".sd7")); // try sd7 first

          if (result == "error" || result == "") {
            result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + mapNameUrlOrId.Replace(".smf", ".sdz")); //then sdz
          }

        } else result = wc2.DownloadString("http://www.unknown-files.net/licho.php?id=" + mapNameUrlOrId);


        try {
          realFileName = Regex.Match(result, "file=([^\\&]+)").Groups[1].Value;
        } catch {
          if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map,mapNameUrlOrId), Status.Failed, "File not found"));
          return;
        }
        if (realFileName == "") {
          if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map,mapNameUrlOrId), Status.Failed, "File not found"));
          return;
        }

        string mapSmf = realFileName.Substring(0, realFileName.LastIndexOf('.')) + ".smf";
        if (spring.UnitSync.HasMap(mapSmf)) { // we have this map already let's fuck this
          if (DownloadCompleted != null) DownloadCompleted(this, new DownloadEventArgs(new DownloadItem(FileType.Map, mapNameUrlOrId), Status.Failed, "We already have this map"));
          return;
        }


        DownloadFile(result, realFileName, FileType.Map);

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

      if (FileDownloader.IsFileUrl(modUrlOrId, out realFileName)) {
        DownloadFile(modUrlOrId, realFileName, FileType.Mod);
        return;
      }

      try {
        WebClient wc2 = new WebClient();
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
  }
}
