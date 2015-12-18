varying highp vec4 DestinationColor;
varying highp vec2 TexCoordOut;
uniform sampler2D Texture;

void main(void) {
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut);
}