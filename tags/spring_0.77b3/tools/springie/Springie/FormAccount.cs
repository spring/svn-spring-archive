#region using

using System;
using System.Windows.Forms;

#endregion

namespace Springie
{
	public partial class FormAccount : Form
	{
		#region Constants

		private const int CountDown = 60;

		#endregion

		#region Fields

		private int countValue = CountDown;

		#endregion

		#region Properties

		public string Login
		{
			get { return textBox1.Text; }
			set { textBox1.Text = value; }
		}

		public string Password
		{
			get { return textBox2.Text; }
			set { textBox2.Text = value; }
		}

		#endregion

		#region Constructors

		public FormAccount()
		{
			InitializeComponent();
		}

		#endregion

		#region Event Handlers

		private void button1_Click(object sender, EventArgs e)
		{
			timer1.Stop();
			DialogResult = DialogResult.OK;
		}

		private void FormAccount_FormClosing(object sender, FormClosingEventArgs e)
		{
			timer1.Stop();
		}

		private void FormAccount_Shown(object sender, EventArgs e)
		{
			Login = Program.main.config.AccountName;
			Password = Program.main.config.AccountPassword;
			timer1.Interval = 1000;
			timer1.Start();
		}

		private void timer1_Tick(object sender, EventArgs e)
		{
			countValue--;
			button1.Text = "Apply (" + countValue + ")";
			if (countValue == 0) button1.PerformClick();
		}

		#endregion
	}
}