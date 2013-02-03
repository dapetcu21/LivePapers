#ifndef LPVECTOR3_H
#define LPVECTOR3_H

#include "LPUtil.h"
#include "LPVector2.h"
#include <OpenGLES/ES2/gl.h>

struct LPVector3
{
    union {
        float x;
        float width;
    };
    union {
        float y;
        float height;
    };
    union {
        float z;
        float depth;
    };
    LPVector3() {};
    LPVector3(const LPVector2 & o, float zz) : x(o.x), y(o.y), z(zz) {};
    LPVector3(float xx, const LPVector2 & o) : x(xx), y(o.x), z(o.y) {};
    LPVector3(float xx, float yy) : x(xx), y(yy), z(0) {};
    LPVector3(float xx, float yy, float zz) : x(xx), y(yy), z(zz) {};
    LPVector3(const LPVector2 & o) : x(o.x), y(o.y), z(0) {};
    LPVector3(const LPVector3 & o) : x(o.x), y(o.y), z(o.z) {};

	void setUniform(GLint location) const { glUniform3f(location, x, y, z); }

    LPVector3 operator - () const
    {
        return LPVector3(-x,-y,-z);
    }

    LPVector3 operator + (const LPVector3 & o) const
    {
        return LPVector3(x+o.x,y+o.y,z+o.z);
    }
    LPVector3 & operator += (const LPVector3 & othr)
    {
        x+=othr.x;
        y+=othr.y;
        z+=othr.z;
        return *this;
    }

    LPVector3 operator - (const LPVector3 & o) const
    {
        return LPVector3(x-o.x,y-o.y);
    }
    LPVector3 & operator -= (const LPVector3 & othr)
    {
        x-=othr.x;
        y-=othr.y;
        z-=othr.z;
        return *this;
    }

    LPVector3 operator * (float d) const
    {
        return LPVector3(x*d,y*d,z*d);
    }
    LPVector3 & operator *= (float d)
    {
        x*=d;
        y*=d;
        z*=d;
        return * this;
    }

    LPVector3 operator * (const LPVector3 & p) const
    {
        return LPVector3(x*p.x,y*p.y,z*p.z);
    }
    LPVector3 & operator *= (const LPVector3 & p)
    {
        x*=p.x;
        y*=p.y;
        z*=p.z;
        return * this;
    }

    LPVector3 operator / (float d) const
    {
        return LPVector3(x/d,y/d,z/d);
    }
    LPVector3 & operator /= (float d)
    {
        x/=d;
        y/=d;
        z/=d;
        return * this;
    }

    LPVector3 operator / (const LPVector3 & p) const
    {
        return LPVector3(x/p.x,y/p.y,z/p.z);
    }
    
    LPVector3 & operator /= (const LPVector3 & p)
    {
        x/=p.x;
        y/=p.y;
        z/=p.z;
        return * this;
    }
    
    float length() const { return LPSqrt(x*x+y*y+z*z); } 
    float squaredLength() const { return x*x+y*y+z*z; }
    float inverseLength() const { return LPInvSqrt(x*x+y*y+z*z); }
    void rotate(float angle);
    LPVector3 rotated(float angle) const;
    
    bool operator < (const LPVector3 & o) const
    {
        if (x==o.x) 
        {
            if (y==o.y)
                return z<o.z;
            return y<o.y;
        }
        return x<o.x;
    }
    
    bool operator > (const LPVector3 & o) const
    {
        if (x==o.x) 
        {
            if (y==o.y)
                return z>o.z;
            return y>o.y;
        }
        return x>o.x;
    }
    
    bool operator == (const LPVector3 & o) const
    {
        return (x==o.x && y==o.y && z==o.z);
    }
    
    void normalize() { 
        (*this) *= inverseLength();
    }
    LPVector3 normalized() const { 
        return (*this) * inverseLength();
    }
    
    float dot(const LPVector3 & v) { return dot(*this,v); }
    static float dot(const LPVector3 & v1, const LPVector3 & v2)
    {
        return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
    }
    
    LPVector3 cross(const LPVector3 & v) { return cross((*this),v); }
    static LPVector3 cross(const LPVector3 & v1, const LPVector3 & v2)
    {
        return LPVector3(v1.y*v2.z-v1.z*v2.y,v1.z*v2.x-v1.x*v2.z,v1.x*v2.y-v1.y*v2.x);
    }
    
    LPVector2 xy() { return LPVector2(x, y); }
    LPVector2 yz() { return LPVector2(y, z); }
};

#endif
