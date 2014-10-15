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

namespace Springie
{
  /// <summary>
  /// Class responsible for downloading new maps to spring
  /// </summary>
  class MapDownloader
  {
    /************************************************************************/
    /*    PUBLIC ATTRIBS                                                    */
    /************************************************************************/
    /// <summary>
    /// Download completed (either successfully or unsuccessfully)
    /// </summary>
    public event EventHandler<TasEventArgs> DownloadCompleted;

    /// <summary>
    /// Download progress has changed
    /// </summary>
    public event EventHandler<TasEventArgs> DownloadProgressChanged;

    /// <summary>
    /// How often to report progresschanged (in percents)
    /// </summary>
    public const int ReportPercentStep = 20;

    /************************************************************************/
    /*    PRIVATE ATTRIBS                                                   */
    /************************************************************************/
    Spring spring;
    WebClient wc = new WebClient();

    string realFileName;
    string currentName;
    int lastPercent = 0;
    Queue<string> downloadQueue = new Queue<string>();


    /************************************************************************/
    /*    PUBLIC METHODS                                                    */
    /************************************************************************/
    /// <summary>
    /// Initializes map downloader
    /// </summary>
    /// <param name="spring">spring instance to use</param>
    public MapDownloader(Spring spring)
    {
      this.spring = spring;
      wc.DownloadFileCompleted += new System.ComponentModel.AsyncCompletedEventHandler(wc_DownloadFileCompleted);
      wc.DownloadProgressChanged += new DownloadProgressChangedEventHandler(wc_DownloadProgressChanged);
    }


    /// <summary>
    /// Queues map for download - map is identified by name or by unknown files id
    /// </summary>
    /// <param name="name">name(.smf) or UF id</param>
    public void DownloadMap(string name)
    {
      if (downloadQueue.Contains(name)) return;
      downloadQueue.Enqueue(name);
      if (downloadQueue.Count == 1 && !wc.IsBusy) {
        GetNext();
      }
    }


    /************************************************************************/
    /*     EVENT HANDLERS                                                   */
    /************************************************************************/
    void wc_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
    {
      if (e.ProgressPercentage >= lastPercent + ReportPercentStep) {
        lastPercent = (e.ProgressPercentage / ReportPercentStep) * ReportPercentStep;
        if (DownloadProgressChanged != null) DownloadProgressChanged(this, new TasEventArgs(realFileName != "" ? realFileName : currentName, e.ProgressPercentage.ToString()));
      }
    }


    void wc_DownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
    {
      if (e.Error != null || e.Cancelled) {
        string ername = e.Error != null ? e.Error.Message : "cancelled";
        if (DownloadCompleted != null) DownloadCompleted(this, new TasEventArgs(realFileName != "" ? realFileName : currentName, ername));
      } else if (DownloadCompleted != null) DownloadCompleted(this, new TasEventArgs(realFileName != "" ? realFileName : currentName));
      GetNext();
    }

    /************************************************************************/
    /*    PRIVATE METHODS                                                   */
    /************************************************************************/
    /// <summary>
    /// Tries to handle next request from queue
    /// </summary>
    private void GetNext()
    {
      if (downloadQueue.Count == 0 || wc.IsBusy) return;

      currentName = downloadQueue.Dequeue();

      try {
        WebClient wc2 = new WebClient();

        string result = "";
        if (currentName.Contains(".")) {
          result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + currentName.Replace(".smf", ".sd7")); // try sd7 first

          if (result == "error" || result == "") {
            result = wc2.DownloadString("http://www.unknown-files.net/licho.php?filename=" + currentName.Replace(".smf", ".sdz")); //then sdz
          }

        } else result = wc2.DownloadString("http://www.unknown-files.net/licho.php?id=" + currentName);


        realFileName = "";
        try {
          realFileName = Regex.Match(result, "file=([^\\&]*)").Groups[1].Value;
        } catch {
          wc_DownloadFileCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(new Exception("File not found"), true, null));
          return;
        }

        if (realFileName == "") {
          wc_DownloadFileCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(new Exception("File not found"), true, null));
          return;
        }

        string mapSmf = realFileName.Substring(0, realFileName.LastIndexOf('.')) + ".smf";
        if (spring.UnitSync.HasMap(mapSmf)) { // we have this map already let's fuck this
          wc_DownloadFileCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(null, false, null));
          return;
        }

        lastPercent = 0;
        wc.DownloadFileAsync(new Uri(result), spring.Path + "maps/" + realFileName);

      } catch { // catch general error
        wc_DownloadFileCompleted(this, new System.ComponentModel.AsyncCompletedEventArgs(new Exception("Error occured while downloading"), true, null));
      }
    }
  }
}
