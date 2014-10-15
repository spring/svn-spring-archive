#region using

using System;

#endregion

namespace Springie.Client
{
	[Serializable]
	public struct BattleRect
	{
		#region Constants

		public const double Max = 200;

		#endregion

		#region Fields

		private int bottom; // values 0-200 (native tasclient format)
		private int left; // values 0-200 (native tasclient format)
		private int right; // values 0-200 (native tasclient format)
		private int top; // values 0-200 (native tasclient format)

		#endregion

		#region Properties

		public int Bottom
		{
			get { return bottom; }
			set { bottom = LimitByMax(value); }
		}

		public int Left
		{
			get { return left; }
			set { left = LimitByMax(value); }
		}

		public int Right
		{
			get { return right; }
			set { right = LimitByMax(value); }
		}

		public int Top
		{
			get { return top; }
			set { top = LimitByMax(value); }
		}

		#endregion

		#region Constructors

		public BattleRect(double left, double top, double right, double bottom)
		{
			// convert from percentages
			this.left = LimitByMax((int) (Max*left));
			this.top = LimitByMax((int) (Max*top));
			this.right = LimitByMax((int) (Max*right));
			this.bottom = LimitByMax((int) (Max*bottom));
		}

		public BattleRect(int left, int top, int right, int bottom)
		{
			this.left = LimitByMax(left);
			this.top = LimitByMax(top);
			this.right = LimitByMax(right);
			this.bottom = LimitByMax(bottom);
		}

		#endregion

		#region Public methods

		public void ToFractions(out double left, out double top, out double right, out double bottom)
		{
			left = Left/Max;
			top = Top/Max;
			right = Right/Max;
			bottom = Bottom/Max;
		}

		#endregion

		#region Other methods

		private static int LimitByMax(int input)
		{
			if (input < 0) return 0;
			if (input > Max) return (int) Max;
			return input;
		}

		#endregion
	} ;
}