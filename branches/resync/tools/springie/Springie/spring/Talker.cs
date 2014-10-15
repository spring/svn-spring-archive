using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Threading;
using System.Diagnostics;

namespace Springie.SpringNamespace
{
  /// <summary>
  /// Class for sending keyboard related windows commands
  /// </summary>
  class Talker : IDisposable
  {
    [DllImport("User32.Dll")]
    public static extern IntPtr FindWindow(String className, String windowName);

    [DllImport("User32.Dll")]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);


    [DllImport("User32.Dll")]
    public static extern bool PostMessage(IntPtr hWnd, int msg, int wParam, int lParam);

    [DllImport("User32.Dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    public const int SW_HIDE = 0;
    public const int SW_SHOWNORMAL = 1;
    public const int SW_NORMAL = 1;
    public const int SW_SHOWMINIMIZED = 2;
    public const int SW_SHOWMAXIMIZED = 3;
    public const int SW_MAXIMIZE = 3;
    public const int SW_SHOWNOACTIVATE = 4;
    public const int SW_SHOW = 5;
    public const int SW_MINIMIZE = 6;
    public const int SW_SHOWMINNOACTIVE = 7;
    public const int SW_SHOWNA = 8;
    public const int SW_RESTORE = 9;
    public const int SW_SHOWDEFAULT = 10;
    public const int SW_FORCEMINIMIZE = 11;
    public const int SW_MAX = 11;




    /// <summary>
    /// transforms char to scan code
    /// </summary>
    /// <param name="ch">char</param>
    /// <returns>scan code (one byte actually)</returns>
    [DllImport("User32.Dll")]
    public static extern int VkKeyScan(char ch);


    public const int VK_ESC = 0x1B;
    public const int VK_ENTER = 0x0D;
    public const int VK_LSHIFT = 0xA0;
    public const int VK_RCONTROL = 0xA3;
    public const int VK_CONTROL = 17;

    /// <summary>
    /// flag to be added to scan code to simulate shift+key
    /// </summary>
    public const int FL_SHIFT = 1 << 8;
    public const int FL_CTRL = 1 << 9;



    private IntPtr target = new IntPtr();
    const int WM_KEYDOWN = 0x0100;
    const int WM_KEYUP = 0x0101;
    const int WM_CHAR = 0x0102;


    class Message
    {
      public int message;
      public int lparam;
      public int wparam;
      public IntPtr target;
      public Message(IntPtr target, int message, int lparam, int wparam)
      {
        this.target = target;
        this.message = message;
        this.lparam = lparam;
        this.wparam = wparam;
      }
    };

    Queue<Message> messageQueue = new Queue<Message>();
    Semaphore semaphore = new Semaphore(0, int.MaxValue);
    bool exitThread = false;
    Thread senderThread;
    Process process;
    object myLock = new object();

    private void AddMessage(IntPtr target, int mess, int lparam, int wparam)
    {
      lock (myLock) {
        messageQueue.Enqueue(new Message(target, mess, lparam, wparam));
        semaphore.Release();
      }
    }


    private static void ExecuteMessages(object param)
    {
      Talker t = (Talker)param;
      while (!t.exitThread) {
        t.semaphore.WaitOne();
        if (t.exitThread) return;
        Queue<Message> temp;
        lock (t.myLock) {
          temp = new Queue<Message>(t.messageQueue);
          t.messageQueue.Clear();
        }
        while (temp.Count > 0) {
          Message m = temp.Dequeue();
          PostMessage(m.target, m.message, m.lparam, m.wparam);
          if (m.lparam == VK_LSHIFT || m.lparam == VK_ENTER || m.lparam == VK_ESC || m.lparam == VK_CONTROL) Thread.Sleep(100);
        }
      }
    }


    /// <summary>
    /// Sends one complete key press
    /// </summary>
    /// <param name="virtCode"></param>
    public void SendKey(int virtCode)
    {
      SendPressKey(virtCode);
      SendReleaseKey(virtCode);
    }

    public void SendPressKey(int virtCode)
    {
      AddMessage(target, WM_KEYDOWN, virtCode, 1);
    }

    public void SendReleaseKey(int virtCode)
    {
      AddMessage(target, WM_KEYUP, virtCode, 1 + 1 << 30 + 1 << 31);
    }


    /// <summary>
    /// Sends text - transforms chars to scan codes
    /// </summary>
    /// <param name="text">text to be sent</param>
    public void SendText(string text)
    {
      for (int i = 0; i < text.Length; ++i) {
        int scan = VkKeyScan(text[i]);
        SendKey(scan);
      }
    }

    /// <summary>
    /// Constructs Talker class
    /// </summary>
    /// <param name="targetHandle">Handle to target window</param>
    public Talker(Process process)
    {
      this.process = process;
      target = process.MainWindowHandle;
      senderThread = new Thread(new ParameterizedThreadStart(ExecuteMessages));
      senderThread.Name = "Talker";
      senderThread.Start(this);
    }

    public void Close()
    {
      exitThread = true;
      semaphore.Release(10);
      senderThread.Join();
    }


    #region IDisposable Members

    public void Dispose()
    {
      Close();
    }

    #endregion
  }
}
