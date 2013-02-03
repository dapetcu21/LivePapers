varying highp vec2 txc;
varying lowp vec4 clr;
uniform sampler2D texture;

void main()
{
    gl_FragColor = texture2D(texture,txc) * clr;
}
