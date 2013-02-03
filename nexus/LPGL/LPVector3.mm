#include "LPVector3.h"

void LPVector3::rotate(float angle)
{
    float ox=x, oy=y, sinv = sin(angle), cosv = cos(angle);
    x = cosv*ox-sinv*oy;
    y = sinv*ox+cosv*oy;
}

LPVector3 LPVector3::rotated(float angle) const
{
    LPVector3 p;
    float sinv = sin(angle), cosv = cos(angle);
    p.x = cosv*x-sinv*y;
    p.y = sinv*x+cosv*y;
    p.z = z;
    return p;
}



