#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform int ssgiBounces;
uniform int ssgiSteps;
uniform float viewWidth;
uniform float viewHeight;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// faamatalaga o le suesuega o le malamalama
vec3 computeGI(vec2 uv) {
        const int MAX_BOUNCES = 4;
        const int MAX_STEPS = 64;
        vec3 gi = vec3(0.0);
        vec2 pixel = vec2(1.0 / viewWidth, 1.0 / viewHeight);
        for (int b = 0; b < MAX_BOUNCES; ++b) {
                if (b >= ssgiBounces) break;
                for (int s = 0; s < MAX_STEPS; ++s) {
                        if (s >= ssgiSteps) break;
                        float ang = float(s) / float(ssgiSteps) * 6.283185;
                        vec2 off = pixel * float(b + 1) * vec2(cos(ang), sin(ang));
                        gi += texture(colortex1, uv + off).rgb;
                }
        }
        gi /= float(max(ssgiBounces * ssgiSteps, 1));
        return gi;
}

// faamama faigofie e pei o le gaosi kosi
vec3 blurGI(vec2 uv) {
        vec2 px = vec2(1.0 / viewWidth, 1.0 / viewHeight);
        vec3 col = vec3(0.0);
        col += texture(colortex1, uv + px * vec2(-1.0, -1.0)).rgb * 0.0625;
        col += texture(colortex1, uv + px * vec2( 0.0, -1.0)).rgb * 0.125;
        col += texture(colortex1, uv + px * vec2( 1.0, -1.0)).rgb * 0.0625;
        col += texture(colortex1, uv + px * vec2(-1.0,  0.0)).rgb * 0.125;
        col += texture(colortex1, uv).rgb * 0.25;
        col += texture(colortex1, uv + px * vec2( 1.0,  0.0)).rgb * 0.125;
        col += texture(colortex1, uv + px * vec2(-1.0,  1.0)).rgb * 0.0625;
        col += texture(colortex1, uv + px * vec2( 0.0,  1.0)).rgb * 0.125;
        col += texture(colortex1, uv + px * vec2( 1.0,  1.0)).rgb * 0.0625;
        return col;
}

void main() {
        vec3 albedo = texture(colortex0, texcoord).rgb;
        vec3 direct = texture(colortex1, texcoord).rgb;
        vec3 gi = computeGI(texcoord);
        vec3 blurred = blurGI(texcoord);
        vec3 lighting = direct + gi + blurred * 0.5;
        color = vec4(albedo * lighting, 1.0);
}
