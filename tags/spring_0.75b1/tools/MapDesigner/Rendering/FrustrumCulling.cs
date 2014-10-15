// Copyright Hugh Perkins 2006
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
using System.Text;
using Tao.OpenGl;

namespace MapDesigner
{
    // see http://www.lighthouse3d.com/opengl/viewfrustum/index.php?defvf
    // for good explanation
    public class FrustrumCulling
    {
        static FrustrumCulling instance = new FrustrumCulling();
        public static FrustrumCulling GetInstance() { return instance; }

        public Vector3 camerapos;
        public Rot camerarot;
        public Vector3 viewray;
        public Vector3 right;
        public Vector3 up;

        public double HNear;
        public double HFar;
        public double VNear;
        public double VFar;

        public Vector3 fc, nc, ftl, ftr, fbl, fbr, ntl, ntr, nbl, nbr;
        public Plane[] planes = new Plane[6];

        public FrustrumCulling()
        {
            // RendererFactory.GetInstance().WriteNextFrameEvent += new WriteNextFrameCallback(FrustrumCulling_WriteNextFrameEvent);
            RendererFactory.GetInstance().PreDrawEvent += new PreDrawCallback(FrustrumCulling_PreDrawEvent);
            //SetupFrustrum();
        }

        void SetupFrustrum()
        {
            //Console.WriteLine("setup frustrum");

            camerapos = Camera.GetInstance().RoamingCameraPos;
            camerarot = Camera.GetInstance().RoamingCameraRot;
            Rot inversecamerarot = camerarot.Inverse();
            viewray = -mvMath.YAxis * inversecamerarot;
            viewray.Normalize();
            right = mvMath.XAxis * inversecamerarot;
            up = mvMath.ZAxis * inversecamerarot;
            right.Normalize();
            up.Normalize();

            double nearclip = RendererFactory.GetInstance().NearClip;
            double farclip = RendererFactory.GetInstance().FarClip;
            VNear = 2 * Math.Tan(RendererFactory.GetInstance().FieldOfView / 2 * Math.PI / 180) * nearclip;
            VFar = VNear * farclip / nearclip;
            HNear = VNear * (double)RendererFactory.GetInstance().OuterWindowWidth / RendererFactory.GetInstance().OuterWindowHeight;
            HFar = HNear * farclip / nearclip;

            fc = camerapos + viewray * farclip;
            ftl = fc + (up * VFar / 2) - (right * HFar / 2);
            ftr = fc + (up * VFar / 2) + (right * HFar / 2);
            fbl = fc - (up * VFar / 2) - (right * HFar / 2);
            fbr = fc - (up * VFar / 2) + (right * HFar / 2);

            nc = camerapos + viewray * nearclip;

            ntl = nc + (up * VNear / 2) - (right * HNear / 2);
            ntr = nc + (up * VNear / 2) + (right * HNear / 2);
            nbl = nc - (up * VNear / 2) - (right * HNear / 2);
            nbr = nc - (up * VNear / 2) + (right * HNear / 2);

            // note: all normals point outwards
            planes[0] = new Plane(-viewray, nc);
            planes[1] = new Plane(viewray, fc);

            Vector3 vectoralongplane;
            Vector3 normal;

            vectoralongplane = (ntr - camerapos).Normalize();
            normal = (up * vectoralongplane).Normalize();
            planes[2] = new Plane(normal, camerapos);

            vectoralongplane = (nbr - camerapos).Normalize();
            normal = (right * vectoralongplane).Normalize();
            planes[3] = new Plane(normal, camerapos);

            vectoralongplane = (nbl - camerapos).Normalize();
            normal = -(up * vectoralongplane).Normalize();
            planes[4] = new Plane(normal, camerapos);

            vectoralongplane = (ntl - camerapos).Normalize();
            normal = -(right * vectoralongplane).Normalize();
            planes[5] = new Plane(normal, camerapos);
        }

        //public FrustrumCulling( Vector3 camerapos, Rot camerarot, float nearclip, float farclip)
        void FrustrumCulling_PreDrawEvent()
        {
            SetupFrustrum();
        }

        // for testing only
        void FrustrumCulling_WriteNextFrameEvent()
        {
            SetupFrustrum();

            IGraphicsHelper g = GraphicsHelperFactory.GetInstance();
            /*
            g.SetMaterialColor(new Color(1, 1, 0));
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(camerapos + viewray * 0.51 + HNear / 2 * 0.95 * right + VNear / 2 * 0.95 * up);
            g.Vertex(camerapos + viewray * 0.51 - HNear / 2 * 0.95 * right + VNear / 2 * 0.95 * up);
            Gl.glEnd();
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(camerapos + viewray * 0.51 - HNear / 2 * 0.95 * right - VNear / 2 * 0.95 * up);
            g.Vertex(camerapos + viewray * 0.51 + HNear / 2 * 0.95 * right - VNear / 2 * 0.95 * up);
            Gl.glEnd();
             */

            g.SetMaterialColor(new Color(1, 0, 1));
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(camerapos + viewray * 1050 + HFar / 2 * 0.95 * right + VFar / 2 * 0.95 * up);
            g.Vertex(camerapos + viewray * 1050 - HFar / 2 * 0.95 * right + VFar / 2 * 0.95 * up);
            Gl.glEnd();
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(camerapos + viewray * 1050 - HFar / 2 * 0.95 * right - VFar / 2 * 0.95 * up);
            g.Vertex(camerapos + viewray * 1050 + HFar / 2 * 0.95 * right - VFar / 2 * 0.95 * up);
            Gl.glEnd();

            g.SetMaterialColor(new Color(1, 0, 0));
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(viewray * 10);
            g.Vertex(viewray * 100);
            Gl.glEnd();

            g.SetMaterialColor(new Color(0, 1, 0));
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(viewray * 10);
            g.Vertex(viewray * 10 + right * 100);
            Gl.glEnd();

            g.SetMaterialColor(new Color(0, 0, 1));
            Gl.glBegin(Gl.GL_LINES);
            g.Vertex(viewray * 10);
            g.Vertex(viewray * 10 + up * 100);
            Gl.glEnd();

            g.SetMaterialColor(new Color(0, 1, 1));
            for (int i = 0; i < 6; i++)
            {
                Gl.glBegin(Gl.GL_LINES);
                g.Vertex(planes[i].point + viewray * 100);
                g.Vertex(planes[i].point + planes[i].normalizednormal * 100 + viewray * 100);
                Gl.glEnd();
            }

            //Console.WriteLine( CheckObject(camerapos - 3 * viewray, 2) );
            //System.Environment.Exit(0);
        }

        public bool IsInsideFrustum(Vector3 centrepos, double boundingradius)
        {
            //Console.WriteLine("IsInsideFrustrum " + centrepos + " " + boundingradius);
            foreach (Plane plane in planes)
            {
                double distance = plane.GetDistance(centrepos);
                //Console.WriteLine( "plane distance: " + distance );
                if (distance > boundingradius)
                {
                    //System.Environment.Exit(0);
                    return false;
                }
            }
            return true;
        }
    }
}
