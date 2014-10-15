using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Springie
{
  public partial class FormAccount : Form
  {
    public string Login {
      get {
        return textBox1.Text;
      }
    }

    public string Password {
      get {
        return textBox2.Text;
      }
    }

    public FormAccount()
    {
      InitializeComponent();
    }

    private void button1_Click(object sender, EventArgs e)
    {
      DialogResult = DialogResult.OK;
    }
  }
}