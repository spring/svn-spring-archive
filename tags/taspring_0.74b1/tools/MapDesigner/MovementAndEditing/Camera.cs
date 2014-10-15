// Copyright Hugh Perkins 2004,2005,2006
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

//! \file
//! \brief Handles camera movement on client, such as pans, orbits etc

using System;
using System.Collections;
using MathGl;

namespace MapDesigner
{
    public class Camera
    {
        const string OverheadOTAConfigName = "cameratranslate";
        const string OverheadOTAOrbitConfigName = "cameraorbit";

        public enum CameraMoveType
        {
            None,
            OverheadOTA,
            OverheadOTAOrbit
        }
        
        public enum Viewpoint
        {
            MouseLook,
            BehindPlayer,
            ThirdParty
        }
        
        public Viewpoint viewpoint = Viewpoint.MouseLook;
    
        CameraMoveType CurrentMove = CameraMoveType.None; //!< current movetype, eg PAN or ORBIT
        
        public bool bRoamingCameraEnabled = true;  //!< if camera is enabled (otherwise, just normal avatar view)
        public Vector3 RoamingCameraPos = new Vector3();  //!< position of camera
        public Rot RoamingCameraRot = new Rot();  //!< rotation of camera
            
        public Vector3 CameraPos;  // note to self: what is this??? not = roamingcamera???
        public Rot CameraRot;
            
        Vector3 dragstartmousestate = new Vector3();

        class OverheadOTAState
        {
            public double x = 0;
            public double y = 0;
            public double distance = 0;
            public double anglefromhorizontaldegrees = 0;
            public OverheadOTAState(double x, double y, double distance, double anglefromhorizontaldegrees)
            {
                this.x = x;
                this.y = y;
                this.distance = distance;
                this.anglefromhorizontaldegrees = anglefromhorizontaldegrees;
            }
            public OverheadOTAState(OverheadOTAState orig)
            {
                this.x = orig.x;
                y = orig.y;
                distance = orig.distance;
                anglefromhorizontaldegrees = orig.anglefromhorizontaldegrees;
            }
        }

        OverheadOTAState overheadotastate_dragstart;
        OverheadOTAState overheadotastate_current = new OverheadOTAState( 500, 500, 200.0, 30 );

        MouseMoveConfigMappings mousemove;
        Config config;
        
        static Camera instance = new Camera();
        public static Camera GetInstance()
        {
            return instance;
        }
        
        public Camera()
        {
            RendererFactory.GetInstance().PreDrawEvent += new PreDrawCallback(renderer_PreDrawEvent);
            IMouseFilterMouseCache mousefiltermousecache = MouseFilterMouseCacheFactory.GetInstance();
            mousemove = MouseMoveConfigMappings.GetInstance();
            config = Config.GetInstance();

            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand(OverheadOTAConfigName, new KeyCommandHandler(CameraModeOverheadTAHandler));
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand(OverheadOTAOrbitConfigName, new KeyCommandHandler(CameraModeOverheadTAHandlerOrbit));

            /*
            KeyFilterComboKeys.GetInstance().RegisterCombo(
                new string[]{"cameramode"}, null, new KeyComboHandler( CameraModeZoomHandler ) );
            KeyFilterComboKeys.GetInstance().RegisterCombo(
                new string[]{"cameramode","cameraorbit"}, null, new KeyComboHandler( CameraModeOrbitHandler ) );
            KeyFilterComboKeys.GetInstance().RegisterCombo(
                new string[]{"cameramode","camerapan"}, null, new KeyComboHandler( CamerModePanHandler ) );
             */

            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand( "toggleviewpoint", new KeyCommandHandler( ToggleViewpointHandler ) );
              
            //mousefiltermousecache.MouseDown += new MouseEventHandler( MouseDown );
            mousefiltermousecache.MouseMove += new MouseMoveHandler(mousefiltermousecache_MouseMove);
            //mousefiltermousecache.MouseUp += new MouseEventHandler( MouseUp );
            UpdateRoamingCameraRotAndPosFromOverheadOTA();
        }

        void mousefiltermousecache_MouseMove()
        {
        //    Console.WriteLine(mousemove.GetHorizontal(OverheadOTAConfigName) + " " + mousemove.GetVertical(OverheadOTAConfigName) + " " + mousemove.GetZoom(OverheadOTAConfigName));
            if (CurrentMove == CameraMoveType.OverheadOTA)
            {
                UpdateOverheadOTA();
            }
            else if (CurrentMove == CameraMoveType.OverheadOTAOrbit)
            {
                UpdateOverheadOTAOrbit();
            }
        }

        void UpdateRoamingCameraRotAndPosFromOverheadOTA()
        {
            RoamingCameraPos = new Vector3(
                overheadotastate_current.x,
                overheadotastate_current.y + overheadotastate_current.distance * Math.Cos(overheadotastate_current.anglefromhorizontaldegrees * Math.PI / 180),
                overheadotastate_current.distance * Math.Sin(overheadotastate_current.anglefromhorizontaldegrees * Math.PI / 180));
            //RoamingCameraRot = mvMath.AxisAngle2Rot( mvMath.ZAxis, Math.PI ) *  mvMath.AxisAngle2Rot(mvMath.XAxis, + overheadotastate_current.anglefromhorizontaldegrees * Math.PI / 180);
            RoamingCameraRot = mvMath.AxisAngle2Rot(mvMath.XAxis, + overheadotastate_current.anglefromhorizontaldegrees * Math.PI / 180);
        }

        void UpdateOverheadOTA()
        {
            Vector3 currentmousestate = mousemove.GetMouseStateVector( OverheadOTAConfigName);
            Vector3 distancevector = currentmousestate - dragstartmousestate;

            overheadotastate_current.x = overheadotastate_dragstart.x + distancevector.x * config.cameratranslatespeed;
            overheadotastate_current.y = overheadotastate_dragstart.y + distancevector.y * config.cameratranslatespeed;
            overheadotastate_current.distance = overheadotastate_dragstart.distance + distancevector.z * config.cameratranslatespeed;
            UpdateRoamingCameraRotAndPosFromOverheadOTA();
        }

        void UpdateOverheadOTAOrbit()
        {
            Vector3 currentmousestate = mousemove.GetMouseStateVector(OverheadOTAOrbitConfigName);
            Vector3 distancevector = currentmousestate - dragstartmousestate;

            overheadotastate_current.anglefromhorizontaldegrees = config.camerarotatespeed * distancevector.y + overheadotastate_dragstart.anglefromhorizontaldegrees;
            UpdateRoamingCameraRotAndPosFromOverheadOTA();
        }

        void renderer_PreDrawEvent()
        {
            ApplyCamera();
        }

        public void ToggleViewpointHandler(string command, bool down)
        {
            if( down )
            {
                //Test.Debug(  "toggling viewpoint..." ); // Test.Debug
                // viewpoint = (Viewpoint)(( (int)viewpoint + 1 ) % 3 );
                //viewpoint = (Viewpoint)(( (int)viewpoint + 1 ) % 2 );  // disactivating third viewpoint for now (since we cant see avatar at moment...)
            }
        }
                
        // stops listening to mouse moves
        public void CameraMoveDone()
        {
            CurrentMove = CameraMoveType.None;
        }

        void CameraModeOverheadTAHandler( string command, bool down )
        {
            if (!down)
            {
                CameraMoveDone();
            }
            else
            {
                CurrentMove = CameraMoveType.OverheadOTA;
                overheadotastate_dragstart = new OverheadOTAState( overheadotastate_current );
                dragstartmousestate = mousemove.GetMouseStateVector(OverheadOTAConfigName);
            }
        }

        void CameraModeOverheadTAHandlerOrbit(string command, bool down)
        {
            if (!down)
            {
                CameraMoveDone();
            }
            else
            {
                CurrentMove = CameraMoveType.OverheadOTAOrbit;
                overheadotastate_dragstart = new OverheadOTAState(overheadotastate_current);
                dragstartmousestate = mousemove.GetMouseStateVector(OverheadOTAOrbitConfigName);
            }
        }

        public void ApplyCamera()
        {
            
            //PlayerMovement playermovement = PlayerMovement.GetInstance();
            
            GLMatrix4d cameramatrix = GLMatrix4d.identity();

            // rotate and reflect so x points right, y points backwards, z points up
            cameramatrix.applyRotate(-90, 1.0, 0.0, 0.0);
            cameramatrix.applyScale(1, -1, 1);

            // rotate so x points right, y points forward, z points up
            //cameramatrix.applyRotate(-90, 1.0, 0.0, 0.0);

            // rotate so z axis is up, and x axis is forward, y axis is left
            //cameramatrix.applyRotate(90, 0.0, 0.0, 1.0);
            //cameramatrix.applyRotate( 90, 0.0, 1.0, 0.0 );

            if( bRoamingCameraEnabled )
            {
                Rot inversecamerarot = RoamingCameraRot.Inverse();
                mvMath.ApplyRotToGLMatrix4d( ref cameramatrix, inversecamerarot  );
                cameramatrix.applyTranslate( - RoamingCameraPos.x,- RoamingCameraPos.y, - RoamingCameraPos.z  );
            }
            else if( viewpoint == Viewpoint.MouseLook )
            {
                //cameramatrix.applyRotate( - playermovement.avataryrot, 0f, 1f, 0f );
                //cameramatrix.applyRotate( - playermovement.avatarzrot, 0f, 0f, 1f );
                //cameramatrix.applyTranslate( - playermovement.avatarpos.x, - playermovement.avatarpos.y, - playermovement.avatarpos.z );
            }
            else if( viewpoint == Viewpoint.BehindPlayer )
            {
                /*
                cameramatrix.applyRotate( -18f, 0f, 1f, 0f );

                // Vector3 V = new Vector3( 0, playermovement.avataryrot * mvMath.PiOver180, playermovement.avatarzrot * mvMath.PiOver180 );

                cameramatrix.applyTranslate( 3.0f, 0.0f, -1.0f );

                cameramatrix.applyRotate( - (float)playermovement.avataryrot, 0f, 1f, 0f );
                cameramatrix.applyRotate( - (float)playermovement.avatarzrot, 0f, 0f, 1f );

                cameramatrix.applyTranslate( -playermovement.avatarpos.x, -playermovement.avatarpos.y, -playermovement.avatarpos.z );
                 */
            }
            else if( viewpoint == Viewpoint.ThirdParty )
            {
                /*
                cameramatrix.applyRotate( -18f, 0f, 1f, 0f );
                cameramatrix.applyRotate( -90f, 0f, 0f, 1f );

                cameramatrix.applyTranslate( 0.0, - fThirdPartyViewZoom, fThirdPartyViewZoom / 3.0 );
                cameramatrix.applyRotate( - fThirdPartyViewRotate, 0f, 0f, 1f );
                cameramatrix.applyTranslate( - playermovement.avatarpos.x, - playermovement.avatarpos.y, - playermovement.avatarpos.z );
                 */
            }    
            
            GraphicsHelperFactory.GetInstance().LoadMatrix( cameramatrix.ToArray() );
        }
    }    
}
