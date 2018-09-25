#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
out lowp vec4 glFragColor;
// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw
void main ()
{
  highp vec2 tmpvar_1;
  tmpvar_1 = (gl_FragCoord.xy / u_resolution);
  glFragColor.xyz = vec3(dot (texture (u_texture1, tmpvar_1), vec4(0.3, 0.59, 0.11, 0.0)));
  glFragColor.w = 1.0;
}

