attribute vec4 Position;
attribute vec4 SourceColor;

uniform mat4 Projection;
uniform mat4 ModelView;

varying vec4 DestinationColor;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main (void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * ModelView * Position;
    TexCoordOut = TexCoordIn;
}