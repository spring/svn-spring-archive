// Copyright Hugh Perkins 2006
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURVector3E. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
// 1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
//
// ======================================================================================
//

using System;
using System.IO;

class GenerateNantBuild
{
    void Walk( string directory )
    {
        Console.WriteLine("Walk: " + directory );
        foreach( string filepath in Directory.GetFiles( directory ) )
        {
            if( filepath.EndsWith( ".cs" ) && !filepath.ToLower().EndsWith( "old.cs" ) &&
                !filepath.EndsWith( "GenerateNantBuild.cs" ) )
            {
                sw.WriteLine( "            <include name=\"" + filepath.Replace( "\\", "/" ) + "\" />" );
            }
        }
      foreach( string subdirectoryfullpath in Directory.GetDirectories( directory ) )
      {
          string subdirectoryname = Path.GetFileName( subdirectoryfullpath );
          Console.WriteLine( subdirectoryfullpath + " " + subdirectoryname );
          if( !subdirectoryname.ToLower().EndsWith( "old" ) && 
              !subdirectoryname.ToLower().EndsWith( "obj" ) &&
                !subdirectoryname.ToLower().EndsWith( ".svn" ) )
          {
            Walk( subdirectoryfullpath );
          }
      }
    }
    StreamWriter sw;
   public void Go()
   {
       sw = new StreamWriter( "nantbuild_generated.txt", false );
       Walk( "." );
       sw.Close();
   }
}

class EntryPoint
{
   public static void Main()
   {
      new GenerateNantBuild().Go();
   }
}



