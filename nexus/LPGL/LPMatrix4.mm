#include "LPMatrix4.h"

void LPInvertMatrix(const GLfloat * m, GLfloat * inverse)
{
	GLfloat a0 = m[ 0]*m[ 5] - m[ 1]*m[ 4];
    GLfloat a1 = m[ 0]*m[ 6] - m[ 2]*m[ 4];
    GLfloat a2 = m[ 0]*m[ 7] - m[ 3]*m[ 4];
    GLfloat a3 = m[ 1]*m[ 6] - m[ 2]*m[ 5];
    GLfloat a4 = m[ 1]*m[ 7] - m[ 3]*m[ 5];
    GLfloat a5 = m[ 2]*m[ 7] - m[ 3]*m[ 6];
    GLfloat b0 = m[ 8]*m[13] - m[ 9]*m[12];
    GLfloat b1 = m[ 8]*m[14] - m[10]*m[12];
    GLfloat b2 = m[ 8]*m[15] - m[11]*m[12];
    GLfloat b3 = m[ 9]*m[14] - m[10]*m[13];
    GLfloat b4 = m[ 9]*m[15] - m[11]*m[13];
    GLfloat b5 = m[10]*m[15] - m[11]*m[14];
	
    GLfloat det = a0*b5 - a1*b4 + a2*b3 + a3*b2 - a4*b1 + a5*b0;
    GLfloat invDet = (1.0f)/det;
    
	inverse[ 0] = ( + m[ 5]*b5 - m[ 6]*b4 + m[ 7]*b3 ) * invDet;
	inverse[ 1] = ( - m[ 1]*b5 + m[ 2]*b4 - m[ 3]*b3 ) * invDet;
	inverse[ 2] = ( + m[13]*a5 - m[14]*a4 + m[15]*a3 ) * invDet;
	inverse[ 3] = ( - m[ 9]*a5 + m[10]*a4 - m[11]*a3 ) * invDet;
	inverse[ 4] = ( - m[ 4]*b5 + m[ 6]*b2 - m[ 7]*b1 ) * invDet;
	inverse[ 5] = ( + m[ 0]*b5 - m[ 2]*b2 + m[ 3]*b1 ) * invDet;
	inverse[ 6] = ( - m[12]*a5 + m[14]*a2 - m[15]*a1 ) * invDet;
	inverse[ 7] = ( + m[ 8]*a5 - m[10]*a2 + m[11]*a1 ) * invDet;
	inverse[ 8] = ( + m[ 4]*b4 - m[ 5]*b2 + m[ 7]*b0 ) * invDet;
	inverse[ 9] = ( - m[ 0]*b4 + m[ 1]*b2 - m[ 3]*b0 ) * invDet;
	inverse[10] = ( + m[12]*a4 - m[13]*a2 + m[15]*a0 ) * invDet;
	inverse[11] = ( - m[ 8]*a4 + m[ 9]*a2 - m[11]*a0 ) * invDet;
	inverse[12] = ( - m[ 4]*b3 + m[ 5]*b1 - m[ 6]*b0 ) * invDet;
	inverse[13] = ( + m[ 0]*b3 - m[ 1]*b1 + m[ 2]*b0 ) * invDet;
	inverse[14] = ( - m[12]*a3 + m[13]*a1 - m[14]*a0 ) * invDet;
	inverse[15] = ( + m[ 8]*a3 - m[ 9]*a1 + m[10]*a0 ) * invDet;
	
}

void LPMultiplyMatrix(const GLfloat m0[16], const GLfloat m1[16], GLfloat d[16])
{
	d[0] = m0[0]*m1[0] + m0[4]*m1[1] + m0[8]*m1[2] + m0[12]*m1[3];
	d[1] = m0[1]*m1[0] + m0[5]*m1[1] + m0[9]*m1[2] + m0[13]*m1[3];
	d[2] = m0[2]*m1[0] + m0[6]*m1[1] + m0[10]*m1[2] + m0[14]*m1[3];
	d[3] = m0[3]*m1[0] + m0[7]*m1[1] + m0[11]*m1[2] + m0[15]*m1[3];
	d[4] = m0[0]*m1[4] + m0[4]*m1[5] + m0[8]*m1[6] + m0[12]*m1[7];
	d[5] = m0[1]*m1[4] + m0[5]*m1[5] + m0[9]*m1[6] + m0[13]*m1[7];
	d[6] = m0[2]*m1[4] + m0[6]*m1[5] + m0[10]*m1[6] + m0[14]*m1[7];
	d[7] = m0[3]*m1[4] + m0[7]*m1[5] + m0[11]*m1[6] + m0[15]*m1[7];
	d[8] = m0[0]*m1[8] + m0[4]*m1[9] + m0[8]*m1[10] + m0[12]*m1[11];
	d[9] = m0[1]*m1[8] + m0[5]*m1[9] + m0[9]*m1[10] + m0[13]*m1[11];
	d[10] = m0[2]*m1[8] + m0[6]*m1[9] + m0[10]*m1[10] + m0[14]*m1[11];
	d[11] = m0[3]*m1[8] + m0[7]*m1[9] + m0[11]*m1[10] + m0[15]*m1[11];
	d[12] = m0[0]*m1[12] + m0[4]*m1[13] + m0[8]*m1[14] + m0[12]*m1[15];
	d[13] = m0[1]*m1[12] + m0[5]*m1[13] + m0[9]*m1[14] + m0[13]*m1[15];
	d[14] = m0[2]*m1[12] + m0[6]*m1[13] + m0[10]*m1[14] + m0[14]*m1[15];
	d[15] = m0[3]*m1[12] + m0[7]*m1[13] + m0[11]*m1[14] + m0[15]*m1[15];
}

LPVector2 LPTransformPointMatrix(const GLfloat * m,const LPVector2 & pnt)
{
	GLfloat x,y,w;
	x = pnt.x * m[0] + pnt.y * m[4] + /*0 * m[8] + 1 * */m[12];
	y = pnt.x * m[1] + pnt.y * m[5] + /*0 * m[9] + 1 * */m[13];
	w = pnt.x * m[3] + pnt.y * m[7] + /*0 * m[11]+ 1 * */m[15];        
	w = 1.0f/w;
	
	return LPVector2(x * w, y * w);
}

LPVector3 LPTransformPointMatrix(const GLfloat * m,const LPVector3 & pnt)
{
	GLfloat x,y,z,w;
	x = pnt.x * m[0] + pnt.y * m[4] + pnt.z * m[8]  + m[12];
	y = pnt.x * m[1] + pnt.y * m[5] + pnt.z * m[9]  + m[13];
    z = pnt.x * m[2] + pnt.y * m[6] + pnt.z * m[10] + m[14];
	w = pnt.x * m[3] + pnt.y * m[7] + pnt.z * m[11] + m[15];        
	w = 1.0f/w;
	
	return LPVector3(x * w, y * w, z * w);
}

const LPMatrix4 LPMatrix4Identity(1,0,0,0,
                                  0,1,0,0,
                                  0,0,1,0,
                                  0,0,0,1);
