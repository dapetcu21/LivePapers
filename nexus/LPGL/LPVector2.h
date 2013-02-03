#ifndef LPVECTOR2_H
#define LPVECTOR2_H

#include "LPUtil.h"
#include <OpenGLES/ES2/gl.h>

struct LPVector2
{
    union {
        float x;
        float width;
    };
    union {
        float y;
        float height;
    };

    LPVector2() {};
    LPVector2(float xx, float yy) : x(xx), y(yy) {};
    LPVector2(const LPVector2 & o) : x(o.x), y(o.y) {};
	LPVector2(const CGSize & s) : x(s.width), y(s.height) {};
	LPVector2(const CGPoint & s) : x(s.x), y(s.y) {};
	void setUniform(GLint location) const { glUniform2f(location, x, y); }

    LPVector2 operator - () const
    {
        return LPVector2(-x,-y);
    }


    LPVector2 operator + (const LPVector2 & o) const
    {
        return LPVector2(x+o.x,y+o.y);
    }
    LPVector2 & operator += (const LPVector2 & othr)
    {
        x+=othr.x;
        y+=othr.y;
        return *this;
    }

    LPVector2 operator - (const LPVector2 & o) const
    {
        return LPVector2(x-o.x,y-o.y);
    }
    LPVector2 & operator -= (const LPVector2 & othr)
    {
        x-=othr.x;
        y-=othr.y;
        return *this;
    }

    LPVector2 operator * (float d) const
    {
        return LPVector2(x*d,y*d);
    }
    LPVector2 & operator *= (float d)
    {
        x*=d;
        y*=d;
        return * this;
    }

    LPVector2 operator * (const LPVector2 & p) const
    {
        return LPVector2(x*p.x,y*p.y);
    }

    LPVector2 & operator *= (const LPVector2 & p)
    {
        x*=p.x;
        y*=p.y;
        return *this;
    }
    
    LPVector2 operator / (float d) const
    {
        return LPVector2(x/d,y/d);
    }
    LPVector2 & operator /= (float d)
    {
        x/=d;
        y/=d;
        return * this;
    }

    LPVector2 operator / (const LPVector2 & p) const
    {
        return LPVector2(x/p.x,y/p.y);
    }

    LPVector2 & operator /= (const LPVector2 & p)
    {
        x/=p.x;
        y/=p.y;
        return *this;
    }

    float length() const { return LPSqrt(x*x+y*y); } 
    float squaredLength() const { return x*x+y*y; }
    float inverseLength() const { return LPInvSqrt(x*x+y*y); }
    LPVector2 rotated(float angle) const;
    void rotate(float angle);
   
    bool operator < (const LPVector2 & o) const
    {
        if (x==o.x) 
            return y<o.y;
        return x<o.x;
    }
    
    bool operator > (const LPVector2 & o) const
    {
        if (x==o.x) 
            return y>o.y;
        return x>o.x;
    }
    
    bool operator == (const LPVector2 & o) const
    {
        return (x==o.x && y==o.y);
    }

    void normalize() { 
        (*this) *= inverseLength();
    }
    LPVector2 normalized() const { 
        return (*this) * inverseLength();
    }
    
    float dot(const LPVector2 & v) { return dot(*this,v); }
    static float dot(const LPVector2 & v1, const LPVector2 & v2)
    {
        return v1.x*v2.x+v1.y*v2.y;
    }
};


#endif
