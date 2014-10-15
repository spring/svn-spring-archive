namespace Springie
{
  partial class FormMain
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null)) {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
      this.components = new System.ComponentModel.Container();
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormMain));
      this.groupBox2 = new System.Windows.Forms.GroupBox();
      this.listBoxChannel = new System.Windows.Forms.ListBox();
      this.groupBox1 = new System.Windows.Forms.GroupBox();
      this.listBoxBattle = new System.Windows.Forms.ListBox();
      this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
      this.menuStrip1 = new System.Windows.Forms.MenuStrip();
      this.optionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.settingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.actionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.rehostToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.reloadModsMapsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.springToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.showhideHostingWindowToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.tabControl = new System.Windows.Forms.TabControl();
      this.tabPage1 = new System.Windows.Forms.TabPage();
      this.tabPage2 = new System.Windows.Forms.TabPage();
      this.splitContainer1 = new System.Windows.Forms.SplitContainer();
      this.textBox = new System.Windows.Forms.TextBox();
      this.splitContainer2 = new System.Windows.Forms.SplitContainer();
      this.groupBox2.SuspendLayout();
      this.groupBox1.SuspendLayout();
      this.menuStrip1.SuspendLayout();
      this.tabControl.SuspendLayout();
      this.splitContainer1.Panel1.SuspendLayout();
      this.splitContainer1.Panel2.SuspendLayout();
      this.splitContainer1.SuspendLayout();
      this.splitContainer2.Panel1.SuspendLayout();
      this.splitContainer2.Panel2.SuspendLayout();
      this.splitContainer2.SuspendLayout();
      this.SuspendLayout();
      // 
      // groupBox2
      // 
      this.groupBox2.Controls.Add(this.listBoxChannel);
      this.groupBox2.Dock = System.Windows.Forms.DockStyle.Fill;
      this.groupBox2.Location = new System.Drawing.Point(0, 0);
      this.groupBox2.Name = "groupBox2";
      this.groupBox2.Size = new System.Drawing.Size(176, 363);
      this.groupBox2.TabIndex = 7;
      this.groupBox2.TabStop = false;
      this.groupBox2.Text = "Users";
      // 
      // listBoxChannel
      // 
      this.listBoxChannel.Dock = System.Windows.Forms.DockStyle.Fill;
      this.listBoxChannel.FormattingEnabled = true;
      this.listBoxChannel.Location = new System.Drawing.Point(3, 16);
      this.listBoxChannel.Name = "listBoxChannel";
      this.listBoxChannel.Size = new System.Drawing.Size(170, 342);
      this.listBoxChannel.TabIndex = 0;
      this.listBoxChannel.SelectedIndexChanged += new System.EventHandler(this.listBox_SelectedIndexChanged);
      // 
      // groupBox1
      // 
      this.groupBox1.Controls.Add(this.listBoxBattle);
      this.groupBox1.Dock = System.Windows.Forms.DockStyle.Fill;
      this.groupBox1.Location = new System.Drawing.Point(0, 0);
      this.groupBox1.Name = "groupBox1";
      this.groupBox1.Size = new System.Drawing.Size(176, 228);
      this.groupBox1.TabIndex = 6;
      this.groupBox1.TabStop = false;
      this.groupBox1.Text = "Battle";
      // 
      // listBoxBattle
      // 
      this.listBoxBattle.Dock = System.Windows.Forms.DockStyle.Fill;
      this.listBoxBattle.FormattingEnabled = true;
      this.listBoxBattle.Location = new System.Drawing.Point(3, 16);
      this.listBoxBattle.Name = "listBoxBattle";
      this.listBoxBattle.Size = new System.Drawing.Size(170, 199);
      this.listBoxBattle.TabIndex = 0;
      this.listBoxBattle.SelectedIndexChanged += new System.EventHandler(this.listBox_SelectedIndexChanged);
      // 
      // notifyIcon1
      // 
      this.notifyIcon1.Text = "Springie";
      this.notifyIcon1.Visible = true;
      this.notifyIcon1.Click += new System.EventHandler(this.notifyIcon1_Click);
      // 
      // menuStrip1
      // 
      this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.optionsToolStripMenuItem,
            this.actionsToolStripMenuItem,
            this.springToolStripMenuItem});
      this.menuStrip1.Location = new System.Drawing.Point(0, 0);
      this.menuStrip1.Name = "menuStrip1";
      this.menuStrip1.Size = new System.Drawing.Size(702, 24);
      this.menuStrip1.TabIndex = 7;
      this.menuStrip1.Text = "Options";
      // 
      // optionsToolStripMenuItem
      // 
      this.optionsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.settingsToolStripMenuItem});
      this.optionsToolStripMenuItem.Name = "optionsToolStripMenuItem";
      this.optionsToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
      this.optionsToolStripMenuItem.Text = "Options";
      // 
      // settingsToolStripMenuItem
      // 
      this.settingsToolStripMenuItem.Name = "settingsToolStripMenuItem";
      this.settingsToolStripMenuItem.Size = new System.Drawing.Size(115, 22);
      this.settingsToolStripMenuItem.Text = "Settings";
      this.settingsToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
      // 
      // actionsToolStripMenuItem
      // 
      this.actionsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.rehostToolStripMenuItem,
            this.reloadModsMapsToolStripMenuItem});
      this.actionsToolStripMenuItem.Name = "actionsToolStripMenuItem";
      this.actionsToolStripMenuItem.Size = new System.Drawing.Size(54, 20);
      this.actionsToolStripMenuItem.Text = "Actions";
      // 
      // rehostToolStripMenuItem
      // 
      this.rehostToolStripMenuItem.Name = "rehostToolStripMenuItem";
      this.rehostToolStripMenuItem.Size = new System.Drawing.Size(171, 22);
      this.rehostToolStripMenuItem.Text = "Rehost";
      this.rehostToolStripMenuItem.Click += new System.EventHandler(this.rehostToolStripMenuItem_Click);
      // 
      // reloadModsMapsToolStripMenuItem
      // 
      this.reloadModsMapsToolStripMenuItem.Name = "reloadModsMapsToolStripMenuItem";
      this.reloadModsMapsToolStripMenuItem.Size = new System.Drawing.Size(171, 22);
      this.reloadModsMapsToolStripMenuItem.Text = "Reload Mods/Maps";
      this.reloadModsMapsToolStripMenuItem.Click += new System.EventHandler(this.reloadModsMapsToolStripMenuItem_Click);
      // 
      // springToolStripMenuItem
      // 
      this.springToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.showhideHostingWindowToolStripMenuItem});
      this.springToolStripMenuItem.Name = "springToolStripMenuItem";
      this.springToolStripMenuItem.Size = new System.Drawing.Size(49, 20);
      this.springToolStripMenuItem.Text = "Spring";
      // 
      // showhideHostingWindowToolStripMenuItem
      // 
      this.showhideHostingWindowToolStripMenuItem.Enabled = false;
      this.showhideHostingWindowToolStripMenuItem.Name = "showhideHostingWindowToolStripMenuItem";
      this.showhideHostingWindowToolStripMenuItem.Size = new System.Drawing.Size(175, 22);
      this.showhideHostingWindowToolStripMenuItem.Text = "Hide hosting window";
      this.showhideHostingWindowToolStripMenuItem.Click += new System.EventHandler(this.showhideHostingWindowToolStripMenuItem_Click);
      // 
      // tabControl
      // 
      this.tabControl.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                  | System.Windows.Forms.AnchorStyles.Left)
                  | System.Windows.Forms.AnchorStyles.Right)));
      this.tabControl.Controls.Add(this.tabPage1);
      this.tabControl.Controls.Add(this.tabPage2);
      this.tabControl.Location = new System.Drawing.Point(0, 0);
      this.tabControl.Name = "tabControl";
      this.tabControl.SelectedIndex = 0;
      this.tabControl.Size = new System.Drawing.Size(522, 573);
      this.tabControl.TabIndex = 0;
      this.tabControl.MouseDown += new System.Windows.Forms.MouseEventHandler(this.tabControl_MouseDown);
      // 
      // tabPage1
      // 
      this.tabPage1.Location = new System.Drawing.Point(4, 22);
      this.tabPage1.Name = "tabPage1";
      this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
      this.tabPage1.Size = new System.Drawing.Size(514, 547);
      this.tabPage1.TabIndex = 0;
      this.tabPage1.Text = "tabPage1";
      this.tabPage1.UseVisualStyleBackColor = true;
      // 
      // tabPage2
      // 
      this.tabPage2.Location = new System.Drawing.Point(4, 22);
      this.tabPage2.Name = "tabPage2";
      this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
      this.tabPage2.Size = new System.Drawing.Size(514, 547);
      this.tabPage2.TabIndex = 1;
      this.tabPage2.Text = "tabPage2";
      this.tabPage2.UseVisualStyleBackColor = true;
      // 
      // splitContainer1
      // 
      this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
      this.splitContainer1.Location = new System.Drawing.Point(0, 24);
      this.splitContainer1.Name = "splitContainer1";
      // 
      // splitContainer1.Panel1
      // 
      this.splitContainer1.Panel1.Controls.Add(this.textBox);
      this.splitContainer1.Panel1.Controls.Add(this.tabControl);
      // 
      // splitContainer1.Panel2
      // 
      this.splitContainer1.Panel2.Controls.Add(this.splitContainer2);
      this.splitContainer1.Size = new System.Drawing.Size(702, 595);
      this.splitContainer1.SplitterDistance = 522;
      this.splitContainer1.TabIndex = 8;
      // 
      // textBox
      // 
      this.textBox.Dock = System.Windows.Forms.DockStyle.Bottom;
      this.textBox.Location = new System.Drawing.Point(0, 575);
      this.textBox.Name = "textBox";
      this.textBox.Size = new System.Drawing.Size(522, 20);
      this.textBox.TabIndex = 1;
      this.textBox.KeyDown += new System.Windows.Forms.KeyEventHandler(this.textBox_KeyDown);
      // 
      // splitContainer2
      // 
      this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
      this.splitContainer2.Location = new System.Drawing.Point(0, 0);
      this.splitContainer2.Name = "splitContainer2";
      this.splitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal;
      // 
      // splitContainer2.Panel1
      // 
      this.splitContainer2.Panel1.Controls.Add(this.groupBox1);
      // 
      // splitContainer2.Panel2
      // 
      this.splitContainer2.Panel2.Controls.Add(this.groupBox2);
      this.splitContainer2.Size = new System.Drawing.Size(176, 595);
      this.splitContainer2.SplitterDistance = 228;
      this.splitContainer2.TabIndex = 0;
      // 
      // FormMain
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(702, 619);
      this.Controls.Add(this.splitContainer1);
      this.Controls.Add(this.menuStrip1);
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.MainMenuStrip = this.menuStrip1;
      this.MinimumSize = new System.Drawing.Size(500, 500);
      this.Name = "FormMain";
      this.Text = "Springie";
      this.SizeChanged += new System.EventHandler(this.Form1_SizeChanged);
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FormMain_FormClosing);
      this.Load += new System.EventHandler(this.Form1_Load);
      this.groupBox2.ResumeLayout(false);
      this.groupBox1.ResumeLayout(false);
      this.menuStrip1.ResumeLayout(false);
      this.menuStrip1.PerformLayout();
      this.tabControl.ResumeLayout(false);
      this.splitContainer1.Panel1.ResumeLayout(false);
      this.splitContainer1.Panel1.PerformLayout();
      this.splitContainer1.Panel2.ResumeLayout(false);
      this.splitContainer1.ResumeLayout(false);
      this.splitContainer2.Panel1.ResumeLayout(false);
      this.splitContainer2.Panel2.ResumeLayout(false);
      this.splitContainer2.ResumeLayout(false);
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.GroupBox groupBox1;
    private System.Windows.Forms.GroupBox groupBox2;
    private System.Windows.Forms.ListBox listBoxChannel;
    private System.Windows.Forms.ListBox listBoxBattle;
    private System.Windows.Forms.NotifyIcon notifyIcon1;
    private System.Windows.Forms.MenuStrip menuStrip1;
    private System.Windows.Forms.ToolStripMenuItem optionsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem settingsToolStripMenuItem;
    private System.Windows.Forms.TabControl tabControl;
    private System.Windows.Forms.TabPage tabPage1;
    private System.Windows.Forms.TabPage tabPage2;
    private System.Windows.Forms.SplitContainer splitContainer1;
    private System.Windows.Forms.TextBox textBox;
    private System.Windows.Forms.SplitContainer splitContainer2;
    private System.Windows.Forms.ToolStripMenuItem actionsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem rehostToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem springToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem reloadModsMapsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem showhideHostingWindowToolStripMenuItem;

  }
}

