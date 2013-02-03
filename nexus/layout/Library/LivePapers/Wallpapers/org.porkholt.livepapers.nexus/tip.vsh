varying highp vec2 txc;
varying lowp vec4 clr;
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

uniform mat4 modelViewProjectionMatrix;

void main(void)
{
    clr = color;
	txc = texCoord;
	gl_Position = modelViewProjectionMatrix * position;
}
