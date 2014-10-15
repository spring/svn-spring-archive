//**************************************************************************
// *   Copyright (C) 2004,2006 by Jacques Gasselin, Hugh Perkins        *
 //*   jacquesgasselin@hotmail.com                                           *
 //*   hughperkins@gmail.com  http://manageddreams.com    *
 //*                                                                         *
 //*   This program is free software; you can redistribute it and/or modify  *
 //*   it under the terms of the GNU Lesser General Public License as       *
 //*   published by the Free Software Foundation; either version 2 of the    *
 //*   License, or (at your option) any later version.                       *
 //*                                                                         *
 //*   This program is distributed in the hope that it will be useful,       *
 //*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 //*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 //*   GNU General Public License for more details.                          *
 //*                                                                         *
 //*   You should have received a copy of the GNU Lesser General Public     *
 //*   License along with this program; if not, write to the                 *
 //*   Free Software Foundation, Inc.,                                       *
 //*   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             * 
 //**************************************************************************

// History:
// - First created by Jacques Gasselin, 2004
// - applyRotateX, applyRotateY, applyRotateZ, applyRotateXYZ methods added by Sebastien Bloc
// - Ported to C#.Net by Hugh Perkins, 2006

using System;

namespace MathGl
{
    //!column major matrix class for OpenGL
    public class GLMatrix4d
    {
        double[]m = new double[16];
        
        //!Create an uninitialised matrix
        public GLMatrix4d()
        { }
    
        //!Create an initialised matrix
        public GLMatrix4d(double val)
        { m[0]=m[1]=m[2]=m[3]=m[4]=m[5]=m[6]=m[7]=m[8]=m[9]=m[10]=m[11]=m[12]=m[13]=m[14]=m[15]=val; }
    
        //!Create a matrix from an array
        public GLMatrix4d( double[] val)
        {
            Buffer.BlockCopy( val, 0, m, 0, Buffer.ByteLength( val ) );
        }
    
        //!Copy a matrix
        public GLMatrix4d(GLMatrix4d mat)
        { 
            Buffer.BlockCopy( mat.m, 0, m, 0, Buffer.ByteLength( mat.m ) );
        }
        
        public double[] ToArray()
        {
            double[]arraycopy = new double[16];
            Buffer.BlockCopy( m, 0, arraycopy, 0, Buffer.ByteLength( m ) );
            return arraycopy;
        }
    
        //!Get the matrix determinant
        public double det() { return m[0]*cofactorm0() - m[1]*cofactorm1() + m[2]*cofactorm2() - m[3]*cofactorm3(); }
    
        //!Get the adjoint matrix
        public GLMatrix4d adjoint()
        {
            GLMatrix4d ret = new GLMatrix4d();
    
            ret.m[0] = cofactorm0();
            ret.m[1] = -cofactorm4();
            ret.m[2] = cofactorm8();
            ret.m[3] = -cofactorm12();
    
            ret.m[4] = -cofactorm1();
            ret.m[5] = cofactorm5();
            ret.m[6] = -cofactorm9();
            ret.m[7] = cofactorm13();
    
            ret.m[8] = cofactorm2();
            ret.m[9] = -cofactorm6();
            ret.m[10] = cofactorm10();
            ret.m[11] = -cofactorm14();
    
            ret.m[12] = -cofactorm3();
            ret.m[13] = cofactorm7();
            ret.m[14] = -cofactorm11();
            ret.m[15] = cofactorm15();
    
            return ret;
        }
    
        //!Adjoint method inverse, constant time inversion implementation
        public GLMatrix4d inverse() 
        {
            GLMatrix4d ret = new GLMatrix4d(adjoint());
    
            double determinant = m[0]*ret[0] + m[1]*ret[4] + m[2]*ret[8] + m[3]*ret[12];
            //assert(determinant!=0 && "Singular matrix has no inverse");
    
            ret /= determinant;
            return ret;
        }
    
    
        //!Equality check. 
        //public static bool operator== (GLMatrix4d one, GLMatrix4d two)
        //{
          //  for( int i = 0; i < 16; i++ )
            //{
              //  if( one.m[i] != two.m[i] )
               // {
                //    return false;
               // }
           // }
           // return true;
        //}
        // dot net requires we also define !=
        //public static bool operator!= (GLMatrix4d one, GLMatrix4d two)
        //{
          //  for( int i = 0; i < 16; i++ )
           // {
              //  if( one.m[i] != two.m[i] )
                //{
                  //  return true;
               // }
            //}
            //return false;
        //}
        //public override bool Equals( object twoobject )
        //{
         //   GLMatrix4d two = twoobject as GLMatrix4d;
          //  for( int i = 0; i < 16; i++ )
            //{
              //  if( m[i] != two.m[i] )
               // {
                //    return false;
                //}
            //}
            //return true;
        //}
    
        //!Direct access to the matrix elements, just remember they are in column major format!!
        public virtual double this[ int ind ]{
            get{
                return m[ ind ];
            }
        //    set{
         //       base[ ind ] = value;
          //  }
        }
    
        //!Implicit cast vector access as suggested by maquinn
        //operator const double*(void) const { return m; }
    
        //!Implicit cast vector access as suggested by maquinn
        //operator double*(void) { return m; }
    
        //!Multiply this matrix by a scalar
        public static GLMatrix4d operator*( GLMatrix4d mat, double val)
        {
            GLMatrix4d result = new GLMatrix4d();
            for(byte i = 0; i < 16; ++i)
            {
                result.m[i] = mat.m[i] * val;
            }
            return result;
        }
        public static GLMatrix4d operator*( double val, GLMatrix4d mat )
        {
            GLMatrix4d result = new GLMatrix4d();
            for(byte i = 0; i < 16; ++i)
            {
                result.m[i] = mat.m[i] * val;
            }
            return result;
        }
    
        //!Divide this matrix by a scalar
        public static GLMatrix4d operator/( GLMatrix4d mat, double val)
        {
            GLMatrix4d result = new GLMatrix4d();
            for(byte i = 0; i < 16; ++i)
            {
                result.m[i] = mat.m[i] / val;
            }
            return result;
        }
    
        //!Add a matrix to this matrix
        public static GLMatrix4d operator+( GLMatrix4d one, GLMatrix4d two)
        {
            GLMatrix4d result = new GLMatrix4d();
            for(byte i = 0; i < 16; ++i)
            {
                result.m[i] = one.m[i] + two.m[i];
            }
            return result;
        }
    
        //!Subtract a matrix from this matrix
        public static GLMatrix4d operator-( GLMatrix4d one, GLMatrix4d two)
        {
            GLMatrix4d result = new GLMatrix4d();
            for(byte i = 0; i < 16; ++i)
            {
                result.m[i] = one.m[i] - two.m[i];
            }
            return result;
        }
    
        //!Get the matrix dot product, most commonly used form of matrix multiplication
        public static GLMatrix4d operator* ( GLMatrix4d one, GLMatrix4d two )
        {
            GLMatrix4d ret = new GLMatrix4d();
            for(byte j = 0; j < 4; ++j)
            {
                ret.m[j] = one.m[j]*two.m[0]
                         + one.m[j+4]*two.m[1]
                         + one.m[j+8]*two.m[2]
                         + one.m[j+12]*two.m[3];
    
                ret.m[j+4] = one.m[j]*two.m[4]
                           + one.m[j+4]*two.m[5]
                           + one.m[j+8]*two.m[6]
                           + one.m[j+12]*two.m[7];
    
                ret.m[j+8] = one.m[j]*two.m[8]
                           + one.m[j+4]*two.m[9]
                           + one.m[j+8]*two.m[10]
                           + one.m[j+12]*two.m[11];
    
                ret.m[j+12] = one[j]*two.m[12]
                            + one[j+4]*two.m[13]
                            + one[j+8]*two.m[14]
                            + one[j+12]*two.m[15];
            }
            return ret;
        }
    
        //!Apply the matrix dot product to this matrix
        //!unrolling by sebastien bloc
        public GLMatrix4d mult3by3(GLMatrix4d mat)
        {
            GLMatrix4d temp = new GLMatrix4d(this);
            m[0] = temp.m[0]*mat.m[0]+temp.m[4]*mat.m[1]+temp.m[8]*mat.m[2];
            m[4] = temp.m[0]*mat.m[4]+temp.m[4]*mat.m[5]+temp.m[8]*mat.m[6];
            m[8] = temp.m[0]*mat.m[8]+temp.m[4]*mat.m[9]+temp.m[8]*mat.m[10];
    
            m[1] = temp.m[1]*mat.m[0]+temp.m[5]*mat.m[1]+temp.m[9]*mat.m[2];
            m[5] = temp.m[1]*mat.m[4]+temp.m[5]*mat.m[5]+temp.m[9]*mat.m[6];
            m[9] = temp.m[1]*mat.m[8]+temp.m[5]*mat.m[9]+temp.m[9]*mat.m[10];
    
            m[2] = temp.m[2]*mat.m[0]+temp.m[6]*mat.m[1]+temp.m[10]*mat.m[2];
            m[6] = temp.m[2]*mat.m[4]+temp.m[6]*mat.m[5]+temp.m[10]*mat.m[6];
            m[10] = temp.m[2]*mat.m[8]+temp.m[6]*mat.m[9]+temp.m[10]*mat.m[10];
    
            m[3] = temp.m[3]*mat.m[0]+temp.m[7]*mat.m[1]+temp.m[11]*mat.m[2];
            m[7] = temp.m[3]*mat.m[4]+temp.m[7]*mat.m[5]+temp.m[11]*mat.m[6];
            m[11] = temp.m[3]*mat.m[8]+temp.m[7]*mat.m[9]+temp.m[11]*mat.m[10];
            return this;
        }
    
        //!Get the matrix vector dot product, used to transform vertecies
        public static GLVector4d operator* ( GLMatrix4d mat, GLVector4d vec)
        {
            GLVector4d ret = new GLVector4d();
            for(byte j = 0; j < 4; ++j)
            {
                ret.val[j] = vec.x*mat[j]
                           + vec.y*mat[j+4]
                           + vec.z*mat[j+8]
                           + vec.w*mat[j+12];
            }
            return ret;
        }
    
        //!Get the matrix vector dot product with w = 1, use for transforming non 4D vectors
        public static GLVector3d operator* ( GLMatrix4d mat, GLVector3d vec)
        {
            GLVector3d ret = new GLVector3d();
            for(byte j = 0; j < 3; ++j)
                for(byte i = 0; i < 3; ++i)
                    ret.val[j] += vec.val[i]*mat.m[j+i*4]; //scale and rotate disregarding w scaling
    
            for(byte i = 0; i < 3; ++i)
                ret.val[i] += mat.m[i+3*4]; //translate
    
            //do w scaling
            double w = mat.m[15];
            for(byte i = 0; i < 3; ++i)
                w += vec.val[i]*mat.m[3+i*4];
    
            double resip = 1/w;
    
            for(byte i = 0; i < 3; ++i)
                ret.val[i] *= resip;
    
            return ret;
        }
    
    
        //!Transpose the matrix
        public GLMatrix4d transpose()
        {
            double temp;
            for( int i = 0; i < 4; ++i)
                for( int j = 0; j < 4; ++j)
                {
                    temp = m[j+i*4];
                    m[j+i*4] = m[i+j*4];
                    m[i+j*4] = temp;
                };
            return this;
        }
    
        //!Return the transpose
        public GLMatrix4d getTranspose()
        {
            GLMatrix4d temp = new GLMatrix4d();
            for( int i = 0; i < 4; ++i)
                for( int j = 0; j < 4; ++j)
                    temp.m[j+i*4] = m[i+j*4];
            return temp;
        }
    
        //!Special glMatricies
        //!Identity matrix
        public static GLMatrix4d identity()
        {
            GLMatrix4d ret = new GLMatrix4d();
    
            ret.m[0] = 1;   ret.m[4] = 0;   ret.m[8]  = 0;  ret.m[12] = 0;
            ret.m[1] = 0;   ret.m[5] = 1;   ret.m[9]  = 0;  ret.m[13] = 0;
            ret.m[2] = 0;   ret.m[6] = 0;   ret.m[10] = 1;  ret.m[14] = 0;
            ret.m[3] = 0;   ret.m[7] = 0;   ret.m[11] = 0;  ret.m[15] = 1;
    
            return ret;
        }
    
        //!Make this an identity matrix
        public GLMatrix4d loadIdentity()
        {
            m[0] = 1;   m[4] = 0;   m[8]  = 0;  m[12] = 0;
            m[1] = 0;   m[5] = 1;   m[9]  = 0;  m[13] = 0;
            m[2] = 0;   m[6] = 0;   m[10] = 1;  m[14] = 0;
            m[3] = 0;   m[7] = 0;   m[11] = 0;  m[15] = 1;
    
            return this;
        }
    
        //!Make this an OpenGL rotation matrix
        public GLMatrix4d loadRotate(double angle, double x, double y, double z)
        {
            double magSqr = x*x + y*y + z*z;
            if(magSqr != 1.0)
            {
                double mag = Math.Sqrt(magSqr);
                x/=mag;
                y/=mag;
                z/=mag;
            }
            double c = Math.Cos(angle*Math.PI/180);
            double s = Math.Sin(angle*Math.PI/180);
            m[0] = x*x*(1-c)+c;
            m[1] = y*x*(1-c)+z*s;
            m[2] = z*x*(1-c)-y*s;
            m[3] = 0;
    
            m[4] = x*y*(1-c)-z*s;
            m[5] = y*y*(1-c)+c;
            m[6] = z*y*(1-c)+x*s;
            m[7] = 0;
    
            m[8] = x*z*(1-c)+y*s;
            m[9] = y*z*(1-c)-x*s;
            m[10] = z*z*(1-c)+c;
            m[11] = 0;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = 0;
            m[15] = 1;
    
            return this;
        }
    
        //!Load rotate[X,Y,Z,XYZ] specialisations by sebastien bloc
        //!Make this an OpenGL rotation matrix: same as loadRotate(angle,1,0,0)
        public GLMatrix4d loadRotateX(double angle)
        {
            double c = Math.Cos(angle*Math.PI/180);
            double s = Math.Sin(angle*Math.PI/180);
            m[0] = 1;
            m[1] = 0;
            m[2] = 0;
            m[3] = 0;
    
            m[4] = 0;
            m[5] = c;
            m[6] = s;
            m[7] = 0;
    
            m[8] = 0;
            m[9] = -s;
            m[10] = c;
            m[11] = 0;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = 0;
            m[15] = 1;
    
            return this;
        }
    
        //!Make this an OpenGL rotation matri0: same as loadRotate(angle,0,1,0)
        public GLMatrix4d loadRotateY(double angle)
        {
            double c = Math.Cos(angle*Math.PI/180);
            double s = Math.Sin(angle*Math.PI/180);
            m[0] = c;
            m[1] = 0;
            m[2] = -s;
            m[3] = 0;
    
            m[4] = 0;
            m[5] = 1;
            m[6] = 0;
            m[7] = 0;
    
            m[8] = s;
            m[9] = 0;
            m[10] = c;
            m[11] = 0;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = 0;
            m[15] = 1;
    
            return this;
        }
    
        //!Make this an OpenGL rotation matrix: same as loadRotateZ(angle,0,0,1)
        public GLMatrix4d loadRotateZ(double angle)
        {
            double c = Math.Cos(angle*Math.PI/180);
            double s = Math.Sin(angle*Math.PI/180);
            m[0] = c;
            m[1] = s;
            m[2] = 0;
            m[3] = 0;
    
            m[4] = -s;
            m[5] = c;
            m[6] = 0;
            m[7] = 0;
    
            m[8] = 0;
            m[9] = 0;
            m[10] = 1;
            m[11] = 0;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = 0;
            m[15] = 1;
    
            return this;
        }
    
        //!Apply an OpenGL rotation matrix to this
        public GLMatrix4d applyRotate(double angle, double x, double y, double z)
        {
            GLMatrix4d temp = new GLMatrix4d();
            temp.loadRotate(angle,x,y,z);
            return mult3by3(temp);
        }
    
        //!Apply rotate[X,Y,Z,XYZ] specialisations by sebastien bloc
        //!Apply an OpenGL rotation matrix to this
        public GLMatrix4d applyRotateX(double angle)
        {
            GLMatrix4d temp = new GLMatrix4d();
            temp.loadRotateX(angle);
            return mult3by3(temp);
        }
    
        //!Apply an OpenGL rotation matrix to this
        public GLMatrix4d applyRotateY(double angle)
        {
            GLMatrix4d temp = new GLMatrix4d();
            temp.loadRotateY(angle);
            return mult3by3(temp);
        }
    
        //!Apply an OpenGL rotation matrix to this
        public GLMatrix4d applyRotateZ(double angle)
        {
            GLMatrix4d temp = new GLMatrix4d();
            temp.loadRotateZ(angle);
            return mult3by3(temp);
        }
    
        //!Apply an OpenGL rotation matrix to this
        public GLMatrix4d applyRotateXYZ(double x,double y,double z)
        {
            GLMatrix4d temp = new GLMatrix4d();
            temp.loadRotateX(x);
            mult3by3(temp);
            temp.loadRotateY(y);
            mult3by3(temp);
            temp.loadRotateZ(z);
            return mult3by3(temp);
        }
    
        //!Make this an OpenGL scale matrix
        public GLMatrix4d loadScale(double x, double y, double z)
        {
            m[0] = x;   m[4] = 0;   m[8]  = 0;  m[12] = 0;
            m[1] = 0;   m[5] = y;   m[9]  = 0;  m[13] = 0;
            m[2] = 0;   m[6] = 0;   m[10] = z;  m[14] = 0;
            m[3] = 0;   m[7] = 0;   m[11] = 0;  m[15] = 1;
    
            return this;
        }
    
        //!Apply an OpenGL scale matrix to this
        public GLMatrix4d applyScale(double x, double y)
        {
            //improved version
            //assuming z = 1
            m[0]*=x;    m[1]*=x;    m[2]*=x;    m[3]*=x;
            m[4]*=y;    m[5]*=y;    m[6]*=y;    m[7]*=y;
            return this;
        }
    
        //!Apply an OpenGL scale matrix to this
        public GLMatrix4d applyScale(double x, double y, double z)
        {
            //improved version
            m[0]*=x;    m[1]*=x;    m[2]*=x;    m[3]*=x;
            m[4]*=y;    m[5]*=y;    m[6]*=y;    m[7]*=y;
            m[8]*=z;    m[9]*=z;    m[10]*=z;   m[11]*=z;
            return this;
        }
    
        //!Apply an OpenGL scale matrix to this
        public GLMatrix4d applyScale( GLVector2d scale)
        {
            //improved version
            //Assuming z = 1
           m[0]*=scale.x;    m[1]*=scale.x;    m[2]*=scale.x;    m[3]*=scale.x;
           m[4]*=scale.y;    m[5]*=scale.y;    m[6]*=scale.y;    m[7]*=scale.y;
           return this;
        }
    
        //!Apply an OpenGL scale matrix to this
        public GLMatrix4d applyScale( GLVector3d scale)
        {
            //improved version
            m[0]*=scale.x;    m[1]*=scale.x;    m[2]*=scale.x;    m[3]*=scale.x;
            m[4]*=scale.y;    m[5]*=scale.y;    m[6]*=scale.y;    m[7]*=scale.y;
            m[8]*=scale.z;    m[9]*=scale.z;    m[10]*=scale.z;   m[11]*=scale.z;
            return this;
        }
    
        //!Make this an OpenGL translate matrix
        public GLMatrix4d loadTranslate(double x, double y, double z)
        {
            m[0] = 1;   m[4] = 0;   m[8]  = 0;  m[12] = x;
            m[1] = 0;   m[5] = 1;   m[9]  = 0;  m[13] = y;
            m[2] = 0;   m[6] = 0;   m[10] = 1;  m[14] = z;
            m[3] = 0;   m[7] = 0;   m[11] = 0;  m[15] = 1;
    
            return this;
        }
    
        //!Apply an OpenGL translate matrix to this
        public GLMatrix4d applyTranslate(double x, double y)
        {
            //improved version
            //assuming z = 0
            m[12] += m[0]*x + m[4]*y;
            m[13] += m[1]*x + m[5]*y;
            m[14] += m[2]*x + m[6]*y;
            return this;
        }
    
        //!Apply an OpenGL translate matrix to this
        public GLMatrix4d applyTranslate(double x, double y, double z)
        {
            //improved version
            m[12] += m[0]*x + m[4]*y + m[8]*z;
            m[13] += m[1]*x + m[5]*y + m[9]*z;
            m[14] += m[2]*x + m[6]*y + m[10]*z;
            return this;
        }
    
        //!Apply an OpenGL translate matrix to this
        public GLMatrix4d applyTranslate( GLVector2d trans)
        {
            ////improved version
            ////assuming z = 0
            m[12] += m[0]*trans.x + m[4]*trans.y;
            m[13] += m[1]*trans.x + m[5]*trans.y;
            m[14] += m[2]*trans.x + m[6]*trans.y;
            return this;
        }
    
        //!Apply an OpenGL translate matrix to this
        public GLMatrix4d applyTranslate( GLVector3d trans)
        {
            //improved version
            m[12] += m[0]*trans.x + m[4]*trans.y + m[8]*trans.z;
            m[13] += m[1]*trans.x + m[5]*trans.y + m[9]*trans.z;
            m[14] += m[2]*trans.x + m[6]*trans.y + m[10]*trans.z;
            return this;
        }
    
        //!OpenGL frustum matrix
        public static GLMatrix4d glFrustum(double left, double right,
                           double bottom, double top,
                       double zNear, double zFar)
        {
            GLMatrix4d ret = new GLMatrix4d();
            ret.m[0] = 2*zNear/(right-left);
            ret.m[1] = 0;
            ret.m[2] = 0;
            ret.m[3] = 0;
    
            ret.m[4] = 0;
            ret.m[5] = 2*zNear/(top-bottom);
            ret.m[6] = 0;
            ret.m[7] = 0;
    
            ret.m[8] = (right+left)/(right-left);
            ret.m[9] = (top+bottom)/(top-bottom);
            ret.m[10] = -(zFar+zNear)/(zFar-zNear);
            ret.m[11] = -1;
    
            ret.m[12] = 0;
            ret.m[13] = 0;
            ret.m[14] = -2*zFar*zNear/(zFar-zNear);
            ret.m[15] = 0;
    
            return ret;
        }
    
        //!Make this with an OpenGL frustum matrix
        public GLMatrix4d loadFrustum(double left, double right,
                         double bottom, double top,
                     double zNear, double zFar)
        {
            m[0] = 2*zNear/(right-left);
            m[1] = 0;
            m[2] = 0;
            m[3] = 0;
    
            m[4] = 0;
            m[5] = 2*zNear/(top-bottom);
            m[6] = 0;
            m[7] = 0;
    
            m[8] = (right+left)/(right-left);
            m[9] = (top+bottom)/(top-bottom);
            m[10] = -(zFar+zNear)/(zFar-zNear);
            m[11] = -1;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = -2*zFar*zNear/(zFar-zNear);
            m[15] = 0;
    
            return this;
        }
    
        //!OpenGL orthogonal matrix
        public static GLMatrix4d glOrtho(double left, double right,
                        double bottom, double top,
                    double zNear, double zFar)
        {
            GLMatrix4d ret = new GLMatrix4d();
    
            ret.m[0] = 2/(right-left);
            ret.m[1] = 0;
            ret.m[2] = 0;
            ret.m[3] = 0;
    
            ret.m[4] = 0;
            ret.m[5] = 2/(top-bottom);
            ret.m[6] = 0;
            ret.m[7] = 0;
    
            ret.m[8] = 0;
            ret.m[9] = 0;
            ret.m[10] = -2/(zFar-zNear);
            ret.m[11] = 0;
    
            ret.m[12] = -(right+left)/(right-left);
            ret.m[13] = -(top+bottom)/(top-bottom);
            ret.m[14] = -(zFar+zNear)/(zFar-zNear);
            ret.m[15] = 1;
    
            return ret;
        }
    
        //!OpenGL orthogonal matrix
        public GLMatrix4d loadOrtho(double left, double right,
                        double bottom, double top,
                    double zNear, double zFar)
        {
            m[0] = 2/(right-left);
            m[1] = 0;
            m[2] = 0;
            m[3] = 0;
    
            m[4] = 0;
            m[5] = 2/(top-bottom);
            m[6] = 0;
            m[7] = 0;
    
            m[8] = 0;
            m[9] = 0;
            m[10] = -2/(zFar-zNear);
            m[11] = 0;
    
            m[12] = -(right+left)/(right-left);
            m[13] = -(top+bottom)/(top-bottom);
            m[14] = -(zFar+zNear)/(zFar-zNear);
            m[15] = 1;
    
            return this;
        }
    
        //!OpenGL View Matrix.
        public GLMatrix4d loadView( GLVector3d front, GLVector3d up, GLVector3d side)
        {
            m[0] = side.x;
            m[1] = up.x;
            m[2] = -front.x;
            m[3] = 0;
    
            m[4] = side.y;
            m[5] = up.y;
            m[6] = -front.y;
            m[7] = 0;
    
            m[8] = side.z;
            m[9] = up.z;
            m[10] = -front.z;
            m[11] = 0;
    
            m[12] = 0;
            m[13] = 0;
            m[14] = 0;
            m[15] = 1;
    
            return this;
        }
    
        //!Row major order is expected to conform with standard output
        // here, we create a new constructor to handle strings
        public GLMatrix4d( string inputstring )
        {
            string[]splitinputstring = inputstring.Split(new char[]{'\n'});
            for(int j = 0; j < 4; ++j)
            {
                string[]splitsingleline = splitinputstring[j].Split( new char[]{' '} );
                for(int i = 0; i < 4; ++i)
                {
                    m[i*4+j] = Convert.ToDouble( splitsingleline[i] );
                }
            }
        }
    
        //!Row major order is expected to conform with standard input
        public override string ToString()
        {
            string outstring = "";
            for(int j = 0; j < 4; ++j)
            {
                for(int i = 0; i < 4; ++i)
                {
                    outstring += m[i*4+j] + " ";
                }
                outstring += "\n";
            }
            return outstring;
        }
    
        //*Cofactor maker after the looping determinant theory I'm sure we all learnt in high-school
        //  *  factor1 |   ^          |
        //  *  ------------|----------v----
        //  *          | major   |
        //  *          |         |  minor
        //  *              ^          |
        //  *  factor2 |   |          |
        //  *  ------------|----------v----
        //  *          | major   |
        //  *          |         |  minor
        //  *              ^          |
        //  *  factor3 |   |          |
        //  *  ------------|----------v----
        //  *          | major   |
        //  *          |         |  minor
        //  *              ^          |
        //  *              |          v
         
        double cofactor_maker(double f1,double mj1,double mi1, double f2,double mj2,double mi2, double f3,double mj3,double mi3)
        {
            return f1*(mj1*mi1-mj2*mi3) + f2*(mj2*mi2-mj3*mi1) + f3*(mj3*mi3-mj1*mi2);
        }
    
        //T cofactorm0()const { return m[5]*(m[10]*m[15]-m[11]*m[14])+m[6]*(m[11]*m[13]-m[8]*m[15])+m[7]*(m[8]*m[14]*m[10]*m[13]);  }
        //!Cofactor of m[0]
        double cofactorm0() { return cofactor_maker(m[5],m[10],m[15], m[6],m[11],m[13], m[7],m[9],m[14]); }
        //!Cofactor of m[1]
        double cofactorm1() { return cofactor_maker(m[6],m[11],m[12], m[7],m[8],m[14], m[4],m[10],m[15]); }
        //!Cofactor of m[2]
        double cofactorm2() { return cofactor_maker(m[7],m[8],m[13], m[4],m[9],m[15], m[5],m[11],m[12]); }
        //!Cofactor of m[3]
        double cofactorm3() { return cofactor_maker(m[4],m[9],m[14], m[5],m[10],m[12], m[6],m[8],m[13]); }
    
        //!Cofactor of m[4]
        double cofactorm4() { return cofactor_maker(m[9],m[14],m[3], m[10],m[15],m[1], m[11],m[13],m[2]); }
        //!Cofactor of m[5]
        double cofactorm5() { return cofactor_maker(m[10],m[15],m[0], m[11],m[12],m[2], m[8],m[14],m[3]); }
        //!Cofactor of m[6]
        double cofactorm6() { return cofactor_maker(m[11],m[12],m[1], m[8],m[13],m[3], m[9],m[15],m[0]); }
        //!Cofactor of m[7]
        double cofactorm7() { return cofactor_maker(m[8],m[13],m[2], m[9],m[14],m[0], m[10],m[12],m[1]); }
    
        //!Cofactor of m[8]
        double cofactorm8() { return cofactor_maker(m[13],m[2],m[7], m[14],m[3],m[5], m[15],m[1],m[6]); }
        //!Cofactor of m[9]
        double cofactorm9() { return cofactor_maker(m[14],m[13],m[4], m[15],m[0],m[6], m[12],m[2],m[7]); }
        //!Cofactor of m[10]
        double cofactorm10() { return cofactor_maker(m[15],m[0],m[5], m[12],m[1],m[7], m[13],m[3],m[4]); }
        //!Cofactor of m[11]
        double cofactorm11() { return cofactor_maker(m[12],m[1],m[6], m[13],m[2],m[4], m[14],m[0],m[5]); }
    
        //!Cofactor of m[12]
        double cofactorm12() { return cofactor_maker(m[1],m[6],m[11], m[2],m[7],m[9], m[3],m[5],m[10]); }
        //!Cofactor of m[13]
        double cofactorm13() { return cofactor_maker(m[2],m[7],m[8], m[3],m[4],m[10], m[10],m[6],m[11]); }
        //!Cofactor of m[14]
        double cofactorm14() { return cofactor_maker(m[3],m[4],m[9], m[0],m[5],m[11], m[1],m[7],m[8]); }
        //!Cofactor of m[15]
        double cofactorm15() { return cofactor_maker(m[0],m[5],m[10], m[1],m[6],m[8], m[2],m[4],m[9]); }
    }
}
