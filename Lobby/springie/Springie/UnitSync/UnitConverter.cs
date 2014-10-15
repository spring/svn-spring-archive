using System;
using System.ComponentModel;
using System.Globalization;

namespace Springie.SpringNamespace
{
	internal class UnitConverter : StringConverter
	{
		#region Overrides

		public override object ConvertFrom(ITypeDescriptorContext context, CultureInfo culture, object value)
		{
			string tofind = value.ToString().Split(' ')[0];
			foreach (var u in GetMod().Units) if (u.Name == tofind) return u;
			return null;
		}

		public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value, Type destinationType)
		{
			if (destinationType == typeof (String)) {
				if (value == null) return null;
				var u = (UnitInfo) value;
				if (u.Name != null) return u.Name + " (" + u.FullName + ")";
				else return null;
			} else return base.ConvertTo(context, culture, value, destinationType);
		}


		public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
		{
			return new StandardValuesCollection(GetMod().Units);
		}

		public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
		{
			return true;
		}

		#endregion

		#region Other methods

		private ModInfo GetMod()
		{
			if (Program.main.Tas != null) {
				var b = Program.main.Tas.GetBattle();
				if (b != null) return b.Mod;
			}
			return Program.main.Spring.UnitSyncWrapper.GetModInfo(Program.main.AutoHost.config.DefaultMod);
		}

		#endregion
	}
}