#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0,1 */
layout(location = 0) out vec4 albedo;
layout(location = 1) out vec4 direct;

void main() {
        albedo = texture(gtexture, texcoord) * glcolor;
        direct = texture(lightmap, lmcoord);
        if (albedo.a < alphaTestRef) {
                discard;
        }
}