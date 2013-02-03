#include "LPVector2.h"

LPVector2 LPVector2::rotated(float angle) const
{
    LPVector2 p;
    float sinv = sin(angle), cosv = cos(angle);
    p.x = cosv*x-sinv*y;
    p.y = sinv*x+cosv*y;
    return p;
}

void LPVector2::rotate(float angle)
{
    float ox=x, oy=y, sinv = sin(angle), cosv = cos(angle);
    x = cosv*ox-sinv*oy;
    y = sinv*ox+cosv*oy;
}

