// Copyright Hugh Perkins 2006
// hughperkins@gmail.com http://manageddreams.com
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 2 as published by the
// Free Software Foundation;
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
using System.Text;
using System.Threading;
using System.IO;
using Gtk;
using Glade;

namespace MapDesigner
{
    public class MainUIWindow
    {
        //CommandQueue commandqueue;

        [Widget]
        public HScale brushsize = null;

        [Widget]
        public VBox brusheffectvbox = null;

        [Widget]
        public VBox brushshapevbox = null;

        [Widget]
        public VBox custombrusheffectlabels = null;

        [Widget]
        public VBox custombrusheffectwidgets = null;

        [Widget]
        public VBox custombrushshapelabels = null;

        [Widget]
        public VBox custombrushshapewidgets = null;

        [Widget]
        public Combo texturestagecombo = null;

        [Widget]
        public Combo operationcombo = null;

        [Widget]
        public Entry texturefilenamelbl = null;

        [Widget]
        public Entry blendtexturefilename = null;

        [Widget]
        public Entry heightmapfilename = null;

        [Widget]
        public HScale tilesizescale = null;

        [Widget]
        public MenuBar menubar1 = null;

        [Widget]
        public Window mainwindow = null;

        Terrain terrain;

        public MainUIWindow()
        {
            Glade.XML app = new Glade.XML("./MapDesigner.glade", "mainwindow", "");
            app.Autoconnect(this);
            //raiselower.Activate();
            Terrain.GetInstance().TerrainModified += new Terrain.TerrainModifiedHandler(MainUIWindow_TerrainModified);
            //MainUIWindow_TerrainModified();
        }

        void MainUIWindow_TerrainModified()
        {
            LogFile.GetInstance().WriteLine("MainUIWindow_TerrainModified() >>>");
            terrain = Terrain.GetInstance();
            heightmapfilename.Text = terrain.HeightmapFilename;
            string[] stagenames = new string[terrain.texturestages.Count];
            bool currenttexturestagevalid = false;
            string oldtexturestagecombotext = texturestagecombo.Entry.Text;
            for (int i = 0; i < terrain.texturestages.Count; i++)
            {
                string maptexturestagename = "texstage" + (i + 1);
                stagenames[i] = maptexturestagename;
                if( oldtexturestagecombotext == maptexturestagename )
                {
                    currenttexturestagevalid = true;
                }
            }
            LogFile.GetInstance().WriteLine("stage names: " + String.Join(",", stagenames));
            settingtexturestagecomboentry = true;
            texturestagecombo.PopdownStrings = stagenames;
            if (!currenttexturestagevalid)
            {
                LogFile.GetInstance().WriteLine("resetting currenttexturestage");
                texturestagecombo.Entry.Text = stagenames[0];
                on_texturestage_changed(null, null);
                //blendtexturefilename.Text = "";
                //texturefilenamelbl.Text = "";
                //operationcombo.Entry.Text = "";
            }
            else
            {
                texturestagecombo.Entry.Text = oldtexturestagecombotext;
                on_texturestage_changed(null, null);
            }
            settingtexturestagecomboentry = false;
            LogFile.GetInstance().WriteLine("MainUIWindow_TerrainModified() <<<");
        }
        bool settingtexturestagecomboentry = false;

        string HeightmapFilename
        {
            set
            {
                heightmapfilename.Text = value;
            }
            get
            {
                return heightmapfilename.Text;
            }
        }
        public void InfoMessage(string message)
        {
            DialogHelpers.ShowInfoMessage( mainwindow, message);
        }
        public void WarningMessage(string message)
        {
            DialogHelpers.ShowWarningMessage(mainwindow, message);
        }
        public void ErrorMessage(string message)
        {
            DialogHelpers.ShowErrorMessage(mainwindow, message);
        }

        string lastdirectorypath = "maps";

        public string GetFilePath(string prompt, string defaultfilename)
        {
            using (FileSelection dialog = new FileSelection(prompt))
            {
                dialog.Filename = Path.Combine(lastdirectorypath, defaultfilename);
                ResponseType response = (ResponseType)dialog.Run();
                dialog.Hide();
                if (response == ResponseType.Ok)
                {
                    LogFile.GetInstance().WriteLine("got filepath: " + dialog.Filename);
                    lastdirectorypath = Path.GetDirectoryName(dialog.Filename);
                    return dialog.Filename;
                }
                else
                {
                    LogFile.GetInstance().WriteLine("Cancel pressed");
                    return "";
                }
            }
        }
        /*
        void on_new_heightmap1_activate(object o, EventArgs e)
        {
            MapSizeDialog sizedialog = new MapSizeDialog(new MapSizeDialog.DoneCallback(on_new_heightmap1_activate_2));
        }
         */
        
        void on_new_sm3_activate(object o, EventArgs e)
        {
            Sm3Persistence.GetInstance().NewSm3();
        }
         
        /*
        void on_open_heightmap1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Heightmap open path", "heightmap.bmp");
            if (filepath != "")
            {
                commandqueue.Enqueue(new CmdOpenHeightMap(filepath));
            }
        }
         */
        void on_open_sm3_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Open SM3", "*.sm3");
            if (filepath != "")
            {
                Sm3Persistence.GetInstance().LoadSm3(filepath);
            }
        }

        void on_save_sm3_as1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Save SM3 as", "*.sm3");
            if (filepath != "")
            {
                Sm3Persistence.GetInstance().SaveSm3(filepath);
            }
        }
        void on_save_sm3_activate(object o, EventArgs e)
        {
            if (Terrain.GetInstance().Sm3Filename == "")
            {
                on_save_sm3_as1_activate(o, e);
                return;
            }
            Sm3Persistence.GetInstance().SaveSm3(Terrain.GetInstance().Sm3Filename);
        }
        void on_save_all1_activate(object o, EventArgs e)
        {
        }

        void on_export_slopemap1_activate(object o, EventArgs e)
        {
            string filepath = GetFilePath("Slopemap export path", "slopemap.jpg");
            if (filepath != "")
            {
                SlopeMapPersistence.GetInstance().Save(filepath);
            }
        }

        void on_export_blended_terrain_texture1_activate(object o, EventArgs e)
        {
            MessageDialog dialog = new MessageDialog( this.mainwindow, DialogFlags.DestroyWithParent,
                 MessageType.Question, ButtonsType.YesNo, "Warning: this operation will require considerable quantities of Ram, and will take some time.  Are you sure you want to continue?");
            ResponseType responsetype = (ResponseType)dialog.Run();
            dialog.Destroy();
            if (responsetype != ResponseType.Yes)
            {
                return;
            }
            string filepath = GetFilePath("Blended terrain texture filepath", "blendedtexture.JPG");
            if (filepath != "")
            {
                ExportAsSingleTexture.GetInstance().Export(filepath);
            }
        }

        void on_quit1_activate(object o, EventArgs e)
        {
            System.Environment.Exit(0);
        }

        void on_btnLoadHeightmap_clicked(object o, EventArgs e)
        {
            string filepath = GetFilePath("Open heightmap", "*.JPG");
            if (filepath != "")
            {
                HeightMapPersistence.GetInstance().Load(filepath);
            }
        }
        void on_btnHeightMapSave_clicked(object o, EventArgs e)
        {
            if (Terrain.GetInstance().HeightmapFilename != "")
            {
                HeightMapPersistence.GetInstance().Save(Terrain.GetInstance().HeightmapFilename);
            }
            else
            {
                on_btnHeightmapSaveAs_clicked(o, e);
            }
        }
        void on_btnHeightmapSaveAs_clicked(object o, EventArgs e)
        {
            string filepath = GetFilePath("Save heightmap as", "*.JPG");
            if (filepath != "")
            {
                HeightMapPersistence.GetInstance().Save(filepath);
            }
        }

        int GetSelectedMapTextureStageIndex()
        {
            string texturestagename = texturestagecombo.Entry.Text;
            int texturestagenumber = Convert.ToInt32(texturestagename.Substring(texturestagename.Length - 1)) - 1;
            LogFile.GetInstance().WriteLine("selected texture stage index " + texturestagenumber);
            return texturestagenumber;
        }

        MapTextureStage GetSelectedMapTextureStage()
        {
            try
            {
                MapTextureStage maptexturestage = terrain.texturestages[GetSelectedMapTextureStageIndex()];
                return maptexturestage;
            }
            catch( Exception )
            {
                //Console.WriteLine(e);
                return null;
            }
        }

        void on_texturestage_changed(object o, EventArgs e)
        {
            LogFile.GetInstance().WriteLine("on_texturestage_changed() >>>");
            MapTextureStage maptexturestage = GetSelectedMapTextureStage();
            if (maptexturestage != null)
            {
                texturefilenamelbl.Text = maptexturestage.SplatTextureFilename;
                blendtexturefilename.Text = maptexturestage.BlendTextureFilename;
                operationcombo.Entry.Text = maptexturestage.Operation.ToString();
                ( BrushEffectController.GetInstance()
                    .brusheffects[typeof( PaintTexture )] as PaintTexture )
                    .SetCurrentEditTexture( maptexturestage );
                tilesizescale.Value = maptexturestage.Tilesize;
            }
            LogFile.GetInstance().WriteLine("on_texturestage_changed() <<<");
        }

        void on_btnAddStage_clicked(object o, EventArgs e)
        {
            //MapTextureStage maptexturestage = GetSelectedMapTextureStage();
            //if (maptexturestage != null)
            //{
                Terrain.GetInstance().texturestages.Add(new MapTextureStage( MapTextureStage.OperationType.Blend ));
                terrain.OnTerrainModified();
            //}
        }

        void on_btnRemoveStage_clicked(object o, EventArgs e)
        {
            if (terrain.texturestages.Count > 1)
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                if (maptexturestage != null)
                {
                    Terrain.GetInstance().texturestages.Remove(maptexturestage);
                    terrain.OnTerrainModified();
                }
            }
            else
            {
                InfoMessage("You need at least one texture stage for the map to run");
            }
        }

        void on_btnMoveStageUp_clicked(object o, EventArgs e)
        {
            try
            {
                int maptextureindex = GetSelectedMapTextureStageIndex();
                if( maptextureindex > 0 )
                {
                    terrain.texturestages.Reverse(maptextureindex - 1, 2);
                }
                terrain.OnTerrainModified();
            }
            catch( Exception ex )
            {
                LogFile.GetInstance().WriteLine(ex.ToString());
            }
        }

        void on_btnMoveStageDown_clicked(object o, EventArgs e)
        {
            try
            {
                int maptextureindex = GetSelectedMapTextureStageIndex();
                if (maptextureindex < terrain.texturestages.Count - 1)
                {
                    terrain.texturestages.Reverse(maptextureindex, 2);
                }
                terrain.OnTerrainModified();
            }
            catch (Exception ex)
            {
                LogFile.GetInstance().WriteLine(ex.ToString());
            }
        }

        public void on_operation_changed(object o, EventArgs e)
        {
            LogFile.GetInstance().WriteLine("on_operation_changed >>> ");
            if (!settingtexturestagecomboentry)
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                if (maptexturestage != null)
                {
                    if (operationcombo.Entry.Text != "")
                    {
                        MapTextureStage.OperationType operation = MapTextureStage.OperationType.NoTexture;
                        if (operationcombo.Entry.Text == "Blend")
                        {
                            operation = MapTextureStage.OperationType.Blend;
                        }
                        else if (operationcombo.Entry.Text == "Replace")
                        {
                            operation = MapTextureStage.OperationType.Replace;
                        }
                        else if (operationcombo.Entry.Text == "Nop")
                        {
                            operation = MapTextureStage.OperationType.Nop;
                        }
                        else if (operationcombo.Entry.Text == "NoTexture")
                        {
                            operation = MapTextureStage.OperationType.NoTexture;
                        }
                        maptexturestage.Operation = operation;
                        terrain.OnTerrainModified();
                    }
                }
            }
            LogFile.GetInstance().WriteLine("on_operation_changed <<<");
        }

        void on_tilesizescale_value_changed(object o, EventArgs e)
        {
            if (!settingtexturestagecomboentry)
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                if (maptexturestage != null)
                {
                    LogFile.GetInstance().WriteLine("changing tilesize to " + (int)tilesizescale.Value);
                    maptexturestage.Tilesize = (int)tilesizescale.Value;
                }
            }
        }

        void on_btnLoadTextureFile_clicked(object o, EventArgs e)
        {
            string filepath = GetFilePath("Load texture", "*.JPG");
            if (filepath != "")
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                maptexturestage.texture.LoadFromFile(filepath);
                terrain.OnTerrainModified();
            }
        }
        void on_btnLoadBlendTexture_clicked(object o, EventArgs e)
        {
            string filepath = GetFilePath("Load blend texture", "*.JPG");
            if (filepath != "")
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                maptexturestage.blendtexture.LoadFromFile(filepath);
                terrain.OnTerrainModified();
            }
        }
        void on_btnSaveAsBlendTexture_clicked(object o, EventArgs e)
        {
            string filepath = GetFilePath("Save blend texture as", "*.JPG");
            if (filepath != "")
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                maptexturestage.blendtexture.SaveAlphaToFile(filepath);
                blendtexturefilename.Text = filepath;
            }
        }
        void on_btnSaveBlendTexture_clicked(object o, EventArgs e)
        {
            if (blendtexturefilename.Text == "")
            {
                on_btnSaveAsBlendTexture_clicked(o, e);
            }
            else
            {
                MapTextureStage maptexturestage = GetSelectedMapTextureStage();
                maptexturestage.blendtexture.SaveAlphaToFile(blendtexturefilename.Text);
            }
        }
        void on_change_dimensions1_activate(object o, EventArgs e)
        {
            new MapSizeDialog();
        }
        void on_change_height_scale1_activate(object o, EventArgs e)
        {
            new HeightScaleDialog();
        }
        void on_800_x_1_activate(object o, EventArgs e)
        {
        }
        void on_1024_x_1_activate(object o, EventArgs e)
        {
        }
        void on_show_slopemap1_activate(object o, EventArgs e)
        {
        }
        void on_show_movementareas1_activate(object o, EventArgs e)
        {
        }
        void on_refresh_slopemap1_activate(object o, EventArgs e)
        {
        }

        void on_about1_activate(object o, EventArgs e)
        {
            using (Dialog dialog = new MessageDialog(null, DialogFlags.DestroyWithParent,
                 MessageType.Info, ButtonsType.Close,
                 "MapDesigner by Hugh Perkins\n\nBuilt using C#, GTK#, GTK, Tao, SDL, OpenGL, Spring"))
            {
                dialog.Run();
                dialog.Hide();
            }
        }

        Dictionary<RadioButton,IBrushEffect> brusheffects = new Dictionary<RadioButton,IBrushEffect>();
        Dictionary<RadioButton, IBrushShape> brushshapes = new Dictionary<RadioButton, IBrushShape>();
        RadioButton brusheffectgroup = null;
        RadioButton brushshapegroup = null;

        public void AddBrushEffect( string name, string description, IBrushEffect brusheffect )
        {
            RadioButton radiobutton = null;
            if (brusheffectgroup != null)
            {
                radiobutton = new RadioButton( brusheffectgroup, name );
                brusheffectvbox.PackEnd( radiobutton );
                brusheffectvbox.ShowAll();
            }
            else
            {
                radiobutton = new RadioButton( name );
                brusheffectvbox.PackEnd( radiobutton );
                brusheffectvbox.ShowAll();
                //radiobutton.Activate();
                brusheffectgroup = radiobutton;
                brusheffect.ShowControlBox( custombrusheffectlabels, custombrusheffectwidgets );
            }
            brusheffects.Add( radiobutton, brusheffect );
            radiobutton.Toggled += new EventHandler(brusheffect_Toggled);
        }

        public void AddBrushShape( string name, string description, IBrushShape brushshape )
        {
            RadioButton radiobutton = null;
            if (brushshapegroup != null )
            {
                radiobutton = new RadioButton( brushshapegroup, name );
                brushshapevbox.PackEnd( radiobutton );
                brushshapevbox.ShowAll();
            }
            else
            {
                radiobutton = new RadioButton( name );
                brushshapevbox.PackEnd( radiobutton );
                brushshapevbox.ShowAll();
                brushshapegroup = radiobutton;
                brushshape.ShowControlBox( custombrushshapelabels, custombrushshapewidgets );
               // radiobutton.Activate();
            }
            brushshapes.Add( radiobutton, brushshape );
            radiobutton.Toggled += new EventHandler( brushshape_Toggled );
        }

        void ClearVBox( VBox vbox )
        {
            foreach (Widget widget in vbox.Children)
            {
                widget.Destroy();
                vbox.Remove( widget );
            }
        }

        void brusheffect_Toggled( object o, EventArgs e )
        {
            IBrushEffect targeteffect = brusheffects[o as RadioButton];
            Console.WriteLine( "selected effect " + targeteffect );
            CurrentEditBrush.GetInstance().BrushEffect = targeteffect;
            ClearVBox( custombrusheffectlabels );
            ClearVBox( custombrusheffectwidgets );
            targeteffect.ShowControlBox( custombrusheffectlabels, custombrusheffectwidgets );
        }

        void brushshape_Toggled( object o, EventArgs e )
        {
            IBrushShape targeteffect = brushshapes[o as RadioButton];
            Console.WriteLine( "selected shape " + targeteffect );
            CurrentEditBrush.GetInstance().BrushShape = targeteffect;
            ClearVBox( custombrushshapelabels );
            ClearVBox( custombrushshapewidgets );
            targeteffect.ShowControlBox( custombrushshapelabels, custombrushshapewidgets );
        }

        public void on_brushsize1_move_slider(object o, EventArgs e)
        {
            LogFile.GetInstance().WriteLine("New brushsize: " + brushsize.Value.ToString());
            CurrentEditBrush.GetInstance().BrushSize = (int)brushsize.Value;
        }

        void on_level_of_detail1_activate(object o, EventArgs e)
        {
            new LodDialog();
        }

        public void Tick()
        {
        }
    }
}
