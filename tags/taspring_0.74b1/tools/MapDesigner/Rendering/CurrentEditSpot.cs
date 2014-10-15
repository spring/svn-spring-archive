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

using System;
using System.Collections.Generic;
using System.Text;
using Tao.OpenGl;

namespace MapDesigner
{
    class CurrentEditSpot
    {
        public CurrentEditSpot()
        {
            RendererFactory.GetInstance().WriteNextFrameEvent += new WriteNextFrameCallback(CurrentEditSpot_WriteNextFrameEvent);
        }

        void CurrentEditSpot_WriteNextFrameEvent()
        {
            Vector3 intersectpoint = HeightEditor.GetInstance().GetIntersectPoint();
            if (intersectpoint != null)
            {
                double distancefromcamera = ( intersectpoint - Camera.GetInstance().RoamingCameraPos ).Det();
                GraphicsHelperFactory.GetInstance().SetMaterialColor(new Color(0, 0, 1));
                Gl.glPushMatrix();
                Gl.glTranslated(intersectpoint.x, intersectpoint.y, intersectpoint.z);
                Gl.glScaled(0.01 * distancefromcamera, 0.01 * distancefromcamera, 0.01 * distancefromcamera);
                GraphicsHelperFactory.GetInstance().DrawSphere();
                Gl.glPopMatrix();
            }
        }
    }
}
