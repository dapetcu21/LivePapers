#ifndef LPUTIL_H
#define LPUTIL_H

struct LPVector2;

float LPInvSqrt(float);
float LPSqrt(float);
double LPSqrt(double);
double LPInvSqrt(double);

float LPLowPassFilter(float var, float newval, float period, float cutoff);
double LPLowPassFilter(double var, double newval, double period, double cutoff);

float LPAngleFromNormalizedVector(const LPVector2 & vec);
inline float LPAngleFromVector(const LPVector2 & vec);

inline float LPWarp(float v, float f)
{
    if (v<0)
        v-=((int)(v/f)-1)*f;
    if (v>=f)
        v-=((int)(v/f))*f;
    return v;
}

inline float LPClamp(float v, float l, float h)
{
    if (v < l)
        v = l;
    if (v > h)
        v = h;
    return v;
}

inline float LPNormalizeAngle(float v)
{
    if (v>M_PI)
        v-=((int)(v+M_PI)*(1.0f/(M_PI*2)))*(M_PI*2);
    if (v<-M_PI)
        v-=((int)(v-M_PI)*(1.0f/(M_PI*2)))*(M_PI*2);
    return v;
}

#endif
