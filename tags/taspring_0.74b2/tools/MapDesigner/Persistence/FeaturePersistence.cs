// Created by Hugh Perkins 2006
// hughperkins@gmail.com http://manageddreams.com
// 
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
// 1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
//

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace MapDesigner
{
    // loading and saving of feature placement
    public class FeaturePersistence
    {
        static FeaturePersistence instance = new FeaturePersistence();
        public static FeaturePersistence GetInstance() { return instance; }

        FeaturePersistence()
        {
        }

        // from FeaturePlacer Form1.cs by Jelmer Cnossen
        // with convenience constructor added by Hugh Perkins
        class Sm3Feature
        {
            public float x, y, z;
            public float rotation;
            public int type;
            public Sm3Feature() { }
            public Sm3Feature(int type, double x, double y, double z)
            {
                this.type = type;
                this.x = (float)x;
                this.y = (float)y;
                this.z = (float)z;
                this.rotation = 0;
            }
        }

        public void LoadFeatures(string featurelistfilename, string featuredatafilename)
        {
            LogFile.GetInstance().WriteLine("LoadFeatures()");
            TdfParser tdfparser = TdfParser.FromFile(featurelistfilename);
            Terrain terrain = Terrain.GetInstance();
            terrain.FeatureMap = new Unit[terrain.MapWidth, terrain.MapHeight];
            Dictionary<int,string> featurenamebynumber = new Dictionary<int, string>();
            int numfeaturetypes = tdfparser.RootSection.GetIntValue("map/featuretypes/numtypes");
            LogFile.GetInstance().WriteLine("Num types: " + numfeaturetypes);
            for (int i = 0; i < numfeaturetypes; i++)
            {
                string featurename = tdfparser.RootSection.GetStringValue("map/featuretypes/type" + i);
                if (!File.Exists(Path.Combine("objects3d", featurename + ".s3o")))
                {
                    MainUI.GetInstance().uiwindow.WarningMessage("Warning: objects3d/" + featurename + ".s3o not found");
                }
                else
                {
                    LogFile.GetInstance().WriteLine("Feature type " + i + " " + featurename.ToLower());
                    featurenamebynumber.Add(i, featurename.ToLower());
                }
            }

            List<Sm3Feature> features = new List<Sm3Feature>();

            // from FeaturePlacer Form1.cs by Jelmer Cnossen
            FileStream fs = new FileStream(featuredatafilename, FileMode.Open);
            if (fs != null)
            {
                BinaryReader br = new BinaryReader(fs);
                if (br.ReadByte() != 0)
                {
                    MainUI.GetInstance().uiwindow.WarningMessage("The featuredata you are trying to load was saved using a different version.");
                    return;
                }

                int numFeatures = br.ReadInt32();
                features.Clear();
                for (int a = 0; a < numFeatures; a++)
                {
                    Sm3Feature f = new Sm3Feature();
                    features.Add(f);
                    f.type = br.ReadInt32();
                    f.x = br.ReadSingle();
                    f.y = br.ReadSingle();
                    f.z = br.ReadSingle();
                    f.rotation = br.ReadSingle();
                }
            }

            foreach (Sm3Feature sm3feature in features)
            {
                if (featurenamebynumber.ContainsKey(sm3feature.type))
                {
                    string featurename = featurenamebynumber[sm3feature.type].ToLower();
                    if( !UnitCache.GetInstance().UnitsByName.ContainsKey( featurename ) )
                    {
                        LogFile.GetInstance().WriteLine("Loading unit " + Path.Combine("objects3d", featurename + ".s3o") + " ... ");
                        Unit unit = new S3oLoader().LoadS3o( Path.Combine( "objects3d", featurename + ".s3o" ) );
                        UnitCache.GetInstance().UnitsByName.Add( featurename, unit );
                    }
                    LogFile.GetInstance().WriteLine("Adding " + featurename + " at " + (int)(sm3feature.x / Terrain.SquareSize) + " " + (int)(sm3feature.y / Terrain.SquareSize));
                    terrain.FeatureMap[(int)( sm3feature.x / Terrain.SquareSize), (int)(sm3feature.y / Terrain.SquareSize)] = UnitCache.GetInstance().UnitsByName[featurename];
                }
            }

            terrain.OnTerrainModified();
        }

        public void SaveFeatures(string featurelistfilename, string featuredatafilename)
        {
            Dictionary<string, int> featurenumberbyname = new Dictionary<string,int>();
            List<Sm3Feature> features = new List<Sm3Feature>();
            int nextnumber = 0;
            StreamWriter featurelistfile = new StreamWriter(featurelistfilename, false, Encoding.UTF8);
            for (int x = 0; x < Terrain.GetInstance().MapWidth; x++)
            {
                for (int y = 0; y < Terrain.GetInstance().MapHeight; y++)
                {
                    Unit thisunit = Terrain.GetInstance().FeatureMap[x, y];
                    if ( thisunit != null)
                    {
                        if( !featurenumberbyname.ContainsKey( thisunit.Name ) )
                        {
                            featurenumberbyname.Add( thisunit.Name, nextnumber );
                            nextnumber++;
                        }
                        int featurenumber = featurenumberbyname[ thisunit.Name ];
                        features.Add(new Sm3Feature(featurenumber, x * Terrain.SquareSize, y * Terrain.SquareSize, Terrain.GetInstance().Map[x,y]));
                        // note to self: unsure whether to multiply by squaresize or not ???
                    }
                }
            }
            featurelistfile.WriteLine("[MAP]");
            featurelistfile.WriteLine("{");
            featurelistfile.WriteLine("   [FeatureTypes]");
            featurelistfile.WriteLine( "   {" );
            featurelistfile.WriteLine( "      NumTypes=" + featurenumberbyname.Count + ";" );
            foreach( KeyValuePair< string, int > kvp in featurenumberbyname )
            {
                featurelistfile.WriteLine( "      type" + kvp.Value + "=" + kvp.Key + ";" );
            }
            featurelistfile.WriteLine( "   }" );
            featurelistfile.WriteLine("}");
            featurelistfile.Close();

            // from FeaturePlacer Form1.cs by Jelmer Cnossen
            // for reference, FeaturePlacer uses following data types:
            //    public class feature
            //    {
            //        public float x, y, z;
             //       public float rotation;
             //       public int type;
             //   }
            FileStream fs = new FileStream(featuredatafilename, FileMode.Create);
            if (fs != null)
            {
                fs.WriteByte(0); // version

                BinaryWriter bw = new BinaryWriter(fs);
                bw.Write((UInt32)features.Count);

                foreach (Sm3Feature f in features)
                {
                    bw.Write(f.type);
                    bw.Write(f.x);
                    bw.Write(f.y);
                    bw.Write(f.z);
                    bw.Write(f.rotation);
                }
            }
            fs.Close();

            MainUI.GetInstance().uiwindow.InfoMessage("Features stored to file");
        }
    }
}
