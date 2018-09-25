#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform highp int shape_type;
uniform vec2 shape_size;
uniform vec2 shape_pos;
uniform float shape_rotate_an;
out highp vec4 glFragColor;
// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw
void main ()
{
  highp vec2 uv_1;
  vec2 tmpvar_2;
  tmpvar_2 = (u_resolution / u_resolution.y);
  uv_1 = (((gl_FragCoord.xy / u_resolution.y) - (tmpvar_2 / 2.0)) + ((shape_pos / u_resolution.y) - (tmpvar_2 / 2.0)));
  uv_1 = (uv_1 * (u_resolution.y / shape_size.y));
  mat2 tmpvar_3;
  float tmpvar_4;
  tmpvar_4 = -(shape_rotate_an);
  tmpvar_3[uint(0)].x = cos(tmpvar_4);
  tmpvar_3[uint(0)].y = -(sin(tmpvar_4));
  tmpvar_3[1u].x = sin(tmpvar_4);
  tmpvar_3[1u].y = cos(tmpvar_4);
  uv_1 = (uv_1 * tmpvar_3);
  highp float tmpvar_5;
  if ((shape_type == 1)) {
    highp vec2 tmpvar_6;
    tmpvar_6 = (abs(uv_1) - vec2(0.5, 0.5));
    highp vec2 tmpvar_7;
    tmpvar_7 = max (tmpvar_6, vec2(0.0, 0.0));
    tmpvar_5 = ((sqrt(
      dot (tmpvar_7, tmpvar_7)
    ) + min (
      max (tmpvar_6.x, tmpvar_6.y)
    , 0.0)) + 0.5);
  } else {
    if ((shape_type == 2)) {
      tmpvar_5 = ((sqrt(
        dot (uv_1, uv_1)
      ) - 0.5) + 0.5);
    } else {
      if ((shape_type == 0)) {
        highp vec2 p_8;
        p_8 = (uv_1 * 2.0);
        p_8.x = (abs(p_8.x) - 1.0);
        p_8.y = (p_8.y + 0.5773503);
        if ((p_8.x > -((1.732051 * p_8.y)))) {
          highp vec2 tmpvar_9;
          tmpvar_9.x = (p_8.x - (1.732051 * p_8.y));
          tmpvar_9.y = ((-1.732051 * p_8.x) - p_8.y);
          p_8 = (tmpvar_9 / 2.0);
        };
        p_8.x = (p_8.x - clamp (p_8.x, -2.0, 0.0));
        tmpvar_5 = ((-(
          sqrt(dot (p_8, p_8))
        ) * sign(p_8.y)) + 0.5);
      };
    };
  };
  highp float tmpvar_10;
  tmpvar_10 = clamp (((tmpvar_5 - 0.6) / -0.2), 0.0, 1.0);
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_11.w = (tmpvar_10 * (tmpvar_10 * (3.0 - 
    (2.0 * tmpvar_10)
  )));
  glFragColor = tmpvar_11;
}

