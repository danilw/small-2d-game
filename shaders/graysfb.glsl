#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
out lowp vec4 glFragColor;
// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = (u_resolution / u_resolution.y);
  highp vec3 res_2;
  res_2.x = 1.0;
  res_2.yz = ((vec2(0.0, 0.0) / tmpvar_1) + 0.5);
  highp vec3 tmpvar_3;
  tmpvar_3 = min (res_2, vec3(1.0, 1.0, 1.0));
  highp vec2 P_4;
  P_4 = (((
    (gl_FragCoord.xy / u_resolution.y)
   - 
    (tmpvar_1 / 2.0)
  ) / tmpvar_1) + 0.5);
  lowp vec3 tmpvar_5;
  tmpvar_5 = texture (u_texture1, P_4).xyz;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((max (
    max (tmpvar_5.x, tmpvar_5.y)
  , tmpvar_5.z) / 0.1), 0.0, 1.0);
  lowp float tmpvar_7;
  tmpvar_7 = max (0.0, (tmpvar_6 * (tmpvar_6 * 
    (3.0 - (2.0 * tmpvar_6))
  )));
  lowp vec4 tmpvar_8;
  tmpvar_8.x = max ((tmpvar_3.x - tmpvar_7), 0.0);
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.zw = tmpvar_3.yz;
  glFragColor = tmpvar_8;
}

