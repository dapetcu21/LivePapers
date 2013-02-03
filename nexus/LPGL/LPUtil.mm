#include "LPUtil.h"
#include "LPVector2.h"

float LPLowPassFilter(float var, float newval, float period, float cutoff)
{
	float RC=1.0/cutoff;
	float alpha=period/(period+RC);
	return newval * alpha + var * (1.0 - alpha);
}

double LPLowPassFilter(double var, double newval, double period, double cutoff)
{
	double RC=1.0/cutoff;
	double alpha=period/(period+RC);
	return newval * alpha + var * (1.0 - alpha);
}

float LPAngleFromVector(const LPVector2 & vec)
{
    return LPAngleFromNormalizedVector(vec.normalized());
}

float LPAngleFromNormalizedVector(const LPVector2 & vec)
{
    float ang;
    if (abs(vec.x)<0.5)
    {
        ang = acos(vec.x);
        if (vec.y<0)
            ang = M_PI*2-ang;
    } else {
        ang = asin(vec.y);
        if (vec.x<0)
            ang = M_PI-ang;
    }
    if (ang>=M_PI*2)
        ang-=M_PI*2;
    if (ang<0)
        ang+=M_PI*2;
    return ang;
}

#define threehalfs 1.5f

float LPInvSqrt(float number)
{
    union {
        float f;
        int32_t i;
    } v = { number };

    float half = number * 0.5f;
	v.i = 0x5f3759df - ( v.i >> 1 );
	v.f  = v.f * ( threehalfs - ( half * v.f * v.f ) );
	return v.f;
}

float LPSqrt(float number)
{
    union {
        float f;
        int32_t i;
    } v = { number };

    float half = number * 0.5f;
	v.i = 0x5f3759df - ( v.i >> 1 );
	v.f  = v.f * ( threehalfs - ( half * v.f * v.f ) );
	return v.f * number;
}

#define threehalfs_d 1.5f

double LPInvSqrt(double number)
{
    union {
        double f;
        int64_t i;
    } v = { number };

    double half = number * 0.5f;
	v.i = 0x5fe6eb50c7b537a9LL - ( v.i >> 1 );
	v.f  = v.f * ( threehalfs_d - ( half * v.f * v.f ) );
	return v.f;
}

double LPSqrt(double number)
{
    union {
        double f;
        int64_t i;
    } v = { number };

    double half = number * 0.5f;
	v.i = 0x5fe6eb50c7b537a9LL - ( v.i >> 1 );
	v.f  = v.f * ( threehalfs_d - ( half * v.f * v.f ) );
	return v.f * number;
}
