varying lowp vec4 clr;
attribute vec4 position;
attribute vec4 color;

uniform mat4 modelViewProjectionMatrix;

void main(void)
{
    clr = color;
	gl_Position = modelViewProjectionMatrix * position;
}
