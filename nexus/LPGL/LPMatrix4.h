#ifndef LPMATRIX4_H
#define LPMATRIX4_H

#include "LPVector2.h"
#include "LPVector3.h"
#include <OpenGLES/ES2/gl.h>

class LPMatrix4;

LPVector2 LPTransformPointMatrix(const GLfloat * m, const LPVector2 & pnt);
LPVector3 LPTransformPointMatrix(const GLfloat * m, const LPVector3 & pnt);
void LPMultiplyMatrix(const GLfloat m0[16], const GLfloat m1[16], GLfloat d[16]);
void LPInvertMatrix(const GLfloat * m, GLfloat * inverse);


class LPMatrix4
{
public:
    GLfloat m[16];
    
public:
    LPMatrix4() 
    {}

	void setUniform(GLint location) const { glUniformMatrix4fv(location, 1, GL_FALSE, m); }
    
    LPMatrix4(const GLfloat * mx)
    {
        loadMatrix(mx);
    }
    
    LPMatrix4(const LPMatrix4 & mx)
    {
        loadMatrix(mx);
    }
    
    LPMatrix4(GLfloat a0 , GLfloat a1 , GLfloat a2 , GLfloat a3 , 
             GLfloat a4 , GLfloat a5 , GLfloat a6 , GLfloat a7 , 
             GLfloat a8 , GLfloat a9 , GLfloat a10, GLfloat a11, 
             GLfloat a12, GLfloat a13, GLfloat a14, GLfloat a15)
    {
        m[0]  = a0 ; m[1]  = a1 ; m[2]  = a2 ; m[3] =  a3 ;
        m[4]  = a4 ; m[5]  = a5 ; m[6]  = a6 ; m[7] =  a7 ;
        m[8]  = a8 ; m[9]  = a9 ; m[10] = a10; m[11] = a11;
        m[12] = a12 ; m[13] = a13; m[14] = a14; m[15] = a15;
    }
    
    static LPMatrix4 identity() { LPMatrix4 m; m.loadIdentity(); return m; }
    void loadIdentity()
    {
        m[ 0] = 1; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = 1; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = 1; m[11] = 0;
        m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1;
    }
    
    static LPMatrix4 rotation(GLfloat angle) { LPMatrix4 m; m.loadZRotation(angle); return m; }
    void rotate(GLfloat angle) { zRotate(angle); }
    void preRotate(GLfloat angle) { preZRotate(angle); }
    void loadRotation(GLfloat angle) { loadZRotation(angle); }
    
    static LPMatrix4 zRotation(GLfloat angle) { LPMatrix4 m; m.loadZRotation(angle); return m;}
    void zRotate(GLfloat angle) { LPMatrix4 m; m.loadZRotation(angle); (*this)=(*this)*m; }
    void preZRotate(GLfloat angle) { LPMatrix4 m; m.loadZRotation(angle); (*this)=m*(*this); }
    void loadZRotation(GLfloat angle)
    {
        GLfloat s = sin(angle), c = cos(angle);
        m[ 0] = c; m[ 1] = s; m[ 2] = 0; m[ 3] = 0;
        m[ 4] =-s; m[ 5] = c; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = 1; m[11] = 0;
        m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1;
    }

    static LPMatrix4 scaling(const LPVector3 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y,sz.z); return m;}
    void scale(const LPVector3 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y,sz.z); (*this)=(*this)*m; }
    void preScale(const LPVector3 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y,sz.z); (*this)=m*(*this); }
    void loadScaling(const LPVector3 & sz) { loadScaling(sz.x,sz.y,sz.z); }
    
    static LPMatrix4 scaling(const LPVector2 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y); return m;}
    void scale(const LPVector2 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y); (*this)=(*this)*m; }
    void preScale(const LPVector2 & sz) { LPMatrix4 m; m.loadScaling(sz.x,sz.y); (*this)=m*(*this); }
    void loadScaling(const LPVector2 & sz) { loadScaling(sz.x,sz.y); }
    
    static LPMatrix4 scaling(GLfloat x, GLfloat y, GLfloat z) { LPMatrix4 m; m.loadScaling(x,y,z); return m;}
    void scale(GLfloat x, GLfloat y, GLfloat z) { LPMatrix4 m; m.loadScaling(x,y,z); (*this)=(*this)*m; }
    void preScale(GLfloat x, GLfloat y, GLfloat z) { LPMatrix4 m; m.loadScaling(x,y,z); (*this)=m*(*this); }
    void loadScaling(GLfloat x, GLfloat y, GLfloat z)
    {
        m[ 0] = x; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = y; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = z; m[11] = 0;
        m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1;
    }
    
    static LPMatrix4 scaling(GLfloat x, GLfloat y) { LPMatrix4 m; m.loadScaling(x,y); return m;}
    void scale(GLfloat x, GLfloat y) { LPMatrix4 m; m.loadScaling(x,y); (*this)=(*this)*m; }
    void preScale(GLfloat x, GLfloat y) { LPMatrix4 m; m.loadScaling(x,y); (*this)=m*(*this); }
    void loadScaling(GLfloat x, GLfloat y)
    {
        m[ 0] = x; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = y; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = 1; m[11] = 0;
        m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1;
    }
    
    static LPMatrix4 translation(const LPVector2 & p) { LPMatrix4 m; m.loadTranslation(p.x,p.y); return m; };
    void translate(const LPVector2 & p) { LPMatrix4 m; m.loadTranslation(p.x,p.y); (*this)=(*this)*m; }
    void preTranslate(const LPVector2 & p) { m[12]+=p.x; m[13]+=p.y; }
    void loadTranslation(const LPVector2 & p) { loadTranslation(p.x,p.y); }
    
    static LPMatrix4 translation(const LPVector3 & p) { LPMatrix4 m; m.loadTranslation(p.x,p.y,p.z); return m; };
    void translate(const LPVector3 & p) { LPMatrix4 m; m.loadTranslation(p.x,p.y,p.z); (*this)=(*this)*m; }
    void preTranslate(const LPVector3 & p) { m[12]+=p.x; m[13]+=p.y; m[14]+=p.z; }
    void loadTranslation(const LPVector3 & p) { loadTranslation(p.x,p.y,p.z); }
    
    static LPMatrix4 translation(GLfloat x, GLfloat y) { LPMatrix4 m; m.loadTranslation(x,y); return m; };
    void translate(GLfloat x, GLfloat y) { LPMatrix4 m; m.loadTranslation(x,y); (*this)=(*this)*m; }
    void preTranslate(GLfloat x, GLfloat y) { m[12]+=x; m[13]+=y; }
    void loadTranslation(GLfloat x, GLfloat y)
    {
        m[ 0] = 1; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = 1; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = 1; m[11] = 0;
        m[12] = x; m[13] = y; m[14] = 0; m[15] = 1;
    }
    
    static LPMatrix4 translation(GLfloat x, GLfloat y, GLfloat z) { LPMatrix4 m; m.loadTranslation(x,y,z); return m; };
    void translate(GLfloat x, GLfloat y, GLfloat z) { LPMatrix4 m; m.loadTranslation(x,y,z); (*this)=(*this)*m; }
    void preTranslate(GLfloat x, GLfloat y, GLfloat z) { m[12]+=x; m[13]+=y; m[14]+=z; }
    void loadTranslation(GLfloat x, GLfloat y, GLfloat z)
    {
        m[ 0] = 1; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = 1; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = 1; m[11] = 0;
        m[12] = x; m[13] = y; m[14] = z; m[15] = 1;
    }
    
    static LPMatrix4 flipping(const LPVector3 & origin, bool flipX, bool flipY, bool flipZ) { LPMatrix4 m; m.loadFlipping(origin,flipX,flipY,flipZ); return m; };
    void translate(const LPVector3 & origin, bool flipX, bool flipY, bool flipZ) { LPMatrix4 m; m.loadFlipping(origin,flipX,flipY,flipZ); (*this)=(*this)*m; }
    void preScale(const LPVector3 & origin, bool flipX, bool flipY, bool flipZ) { LPMatrix4 m; m.loadFlipping(origin,flipX,flipY,flipZ); (*this)=m*(*this); }
    void loadFlipping(const LPVector3 & o, bool flipX, bool flipY, bool flipZ)
    {
        m[ 0] = flipX?-1:1; m[ 1] = 0;          m[ 2] = 0;          m[ 3] = 0;
        m[ 4] = 0;          m[ 5] = flipY?-1:1; m[ 6] = 0;          m[ 7] = 0;
        m[ 8] = 0;          m[ 9] = 0;          m[10] = flipZ?-1:1; m[11] = 0;
        m[12] = flipX?o.x*2:0; 
        m[13] = flipY?o.y*2:0; 
        m[14] = flipZ?o.z*2:0; m[15] = 1;
    }
    
    static LPMatrix4 perspective(double fovy, double aspect, double zNear, double zFar) { LPMatrix4 m; m.loadPerspective(fovy, aspect, zNear, zFar); return m;}
    void loadPerspective(double fovy, double aspect, double zNear, double zFar)
    {
        double f = 1/tan(fovy/2);
        double nf = zNear - zFar;
        m[ 0] = f/aspect; m[ 1] = 0; m[ 2] = 0; m[ 3] = 0;
        m[ 4] = 0; m[ 5] = f; m[ 6] = 0; m[ 7] = 0;
        m[ 8] = 0; m[ 9] = 0; m[10] = (zFar+zNear)/nf; m[11] = -1;
        m[12] = 0; m[13] = 0; m[14] = (2*zFar*zNear)/nf; m[15] = 0;
    }
    
    static LPMatrix4 frustum(double left,
                            double right,
                            double bottom,
                            double top,
                            double nearVal,
                            double farVal)
    { 
        LPMatrix4 m;
        m.loadFrustum(left, right, bottom, top, nearVal, farVal);
        return m;
    }
    void loadFrustum(double left,
                     double right,
                     double bottom,
                     double top,
                     double nearVal,
                     double farVal)
    {
        double rl = right - left;
        double tb = top - bottom;
        double fn = farVal - nearVal;
        m[ 0] = (2*nearVal)/rl;  m[ 1] = 0;               m[ 2] = 0;                      m[ 3] = 0;
        m[ 4] = 0;               m[ 5] = (2*nearVal)/tb;  m[ 6] = 0;                      m[ 7] = 0;
        m[ 8] = (right+left)/rl; m[ 9] = (top+bottom)/tb; m[10] = -(farVal+nearVal)/fn;   m[11] = -1;
        m[12] = 0;               m[13] = 0;               m[14] = -(2*farVal*nearVal)/fn; m[15] = 0;
    }

    
    void loadMatrix(const LPMatrix4 & mx)
    {
        loadMatrix(mx.m);
    }
        
    void loadMatrix(const GLfloat * mx)
    {
        memcpy(m, mx, sizeof(GLfloat)*16);
    }
    
    const GLfloat * floats() const { return m; } 
    GLfloat * floats() { return m; } 
    
    LPMatrix4 & operator *= (const  LPMatrix4 & o) { (*this) = (*this) * o; return (*this); }
    
    LPMatrix4 transposed() const
    {
        return LPMatrix4(m[0], m[4], m[8], m[12],
                        m[1], m[5], m[9], m[13],
                        m[2], m[6], m[10],m[14],
                        m[3], m[7], m[11],m[15]);
    }
    
    LPMatrix4 inverse() const
    {
        LPMatrix4 d;
        LPInvertMatrix(m,d.m);
        return d;
    }
    LPMatrix4 operator * (const LPMatrix4 & b) const
    {
        LPMatrix4 d;
        LPMultiplyMatrix(m, b.m, d.m);
        return d;
    }
    
    LPVector3 transformPoint(const LPVector3 & p) const
    {
        return LPTransformPointMatrix(m,p);
    }

    LPVector3 untransformPoint(const LPVector3 & p) const { return inverse().transformPoint(p); }
    LPVector2 transformPoint(const LPVector2 & p) const
    {
        return LPTransformPointMatrix(m,p);
    }

    LPVector2 untransformPoint(const LPVector2 & p) const { return inverse().transformPoint(p); }

    LPVector2 operator * (const LPVector2 & p) const
    {
        return transformPoint(p);
    }

    LPVector3 operator * (const LPVector3 & p) const
    {
        return transformPoint(p);
    }

    bool operator == (const LPMatrix4 & o) const
    {
        for (int i = 0; i < 16; i++)
            if (m[i] != o.m[i])
                return false;
        return true;
    }
};

extern const LPMatrix4 LPMatrix4Identity;

#endif
