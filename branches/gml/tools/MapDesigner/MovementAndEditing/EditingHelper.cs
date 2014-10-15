using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    public class EditingHelper
    {
        /// <summary>
        /// Return current mouse intersect point to x-y plane on map, in display coordinates
        /// </summary>
        /// <returns></returns>
        public static Vector3 GetIntersectPoint()
        {
            // intersect mousevector with x-z plane.
            Terrain terrain = Terrain.GetInstance();
            Vector3 mousevector = GraphicsHelperFactory.GetInstance().GetMouseVector(
                Camera.GetInstance().RoamingCameraPos, 
                Camera.GetInstance().RoamingCameraRot, 
                MouseFilterMouseCacheFactory.GetInstance().MouseX, 
                MouseFilterMouseCacheFactory.GetInstance().MouseY);
            Vector3 camerapos = Camera.GetInstance().RoamingCameraPos;
            int width = terrain.HeightMapWidth;
            int height = terrain.HeightMapHeight;
            //Vector3 planenormal = mvMath.ZAxis;
            mousevector.Normalize();
            if (mousevector.z < -0.0005)
            {
                //Vector3 intersectionpoint = camerapos + mousevector * (Vector3.DotProduct(camerapos, planenormal) + 0) /
                //  (Vector3.DotProduct(mousevector, planenormal));
                Vector3 intersectpoint = camerapos - mousevector * (camerapos.z / mousevector.z);
                //Console.WriteLine("intersection: " + intersectionpoint.ToString());
                double heightmapx = intersectpoint.x / Terrain.SquareSize;
                double heightmapy = intersectpoint.y / Terrain.SquareSize;
                if (heightmapx >= 0 && heightmapy >= 0 &&
                    heightmapx < width && heightmapy < height)
                {
                    intersectpoint.z = Terrain.GetInstance().Map[(int)heightmapx, (int)heightmapy];
                    return intersectpoint;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                //                Console.WriteLine("no intersection");
                return null;
            }
        }
    }
}
