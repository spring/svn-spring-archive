using System;
using System.Collections.Generic;
using System.Text;

    // represents a plane, defined by one normalized normal and one point
    public class Plane
    {
        public Vector3 normalizednormal;
        public Vector3 point;

        public Plane() { }
        public Plane(Vector3 normalizednormal, Vector3 point)
        {
            this.normalizednormal = normalizednormal;
            this.point = point;
        }
        public double GetDistance(Vector3 candidate)
        {
            return Vector3.DotProduct((candidate - point), normalizednormal);
        }
    }
