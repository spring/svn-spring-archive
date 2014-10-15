using System;
using System.Collections.Generic;
using System.Text;

namespace Springie.Downloader
{
	public class HostList
	{
		private List<string> data;
		private int position;

		public HostList(IEnumerable<string> data)
		{
			this.data = new List<string>(data);
		}

		public string CurrentHost
		{
			get { return data[position]; }
		}

		public string CurrentUrl
		{
			get { return string.Format("http://{0}/", data[position]); }
		}


		public string GetNext()
		{
			position++;
			if (position >= data.Count) position = 0;
			return data[position];
		}
	}
}
