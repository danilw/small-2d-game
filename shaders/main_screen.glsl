#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform float u_time;
uniform highp int QUALITY;
out lowp vec4 glFragColor;
uniform float ppowerhitr;
uniform vec2 xshape_size;
uniform vec2 xshape_pos;
highp int SAMPLES;
float DENSITY;
float WEIGHT;
float ilval;
void main ()
{
  SAMPLES = 8;
  DENSITY = 0.8;
  WEIGHT = 0.38;
  ilval = 1.5;
  lowp vec4 fragColor_1;
  float illumdecay_2;
  lowp vec2 dtc_3;
  highp float dither_4;
  lowp vec3 obj_col_5;
  lowp float obj_6;
  lowp float occ_7;
  highp vec2 tuv_8;
  lowp vec2 coord_9;
  if ((QUALITY == 1)) {
    SAMPLES = 16;
    DENSITY = 0.93;
    WEIGHT = 0.38;
    ilval = 0.8;
  } else {
    if ((QUALITY == 3)) {
      SAMPLES = 64;
      DENSITY = 0.97;
      WEIGHT = 0.25;
      ilval = 0.4;
    } else {
      if ((QUALITY == 2)) {
        SAMPLES = 32;
        DENSITY = 0.95;
        WEIGHT = 0.25;
        ilval = 0.67;
      } else {
        SAMPLES = 8;
        DENSITY = 0.8;
        WEIGHT = 0.38;
        ilval = 1.35;
      };
    };
  };
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_FragCoord.xy / u_resolution);
  lowp vec2 tmpvar_11;
  tmpvar_11 = tmpvar_10;
  coord_9 = tmpvar_11;
  tuv_8 = ((gl_FragCoord.xy / u_resolution.y) - ((u_resolution / u_resolution.y) / 2.0));
  occ_7 = texture (u_texture1, tmpvar_10).x;
  obj_6 = texture (u_texture1, tmpvar_10).y;
  obj_col_5 = texture (u_texture2, tmpvar_10).xyz;
  highp vec2 a_12;
  a_12 = (0.125 * gl_FragCoord.xy);
  highp vec2 a_13;
  a_13 = (0.25 * a_12);
  highp vec2 a_14;
  a_14 = (0.5 * a_13);
  highp vec2 tmpvar_15;
  tmpvar_15 = floor(a_14);
  a_14 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = 0.5;
  tmpvar_16.y = (tmpvar_15.y * 0.75);
  highp vec2 tmpvar_17;
  tmpvar_17 = floor(a_13);
  highp vec2 tmpvar_18;
  tmpvar_18.x = 0.5;
  tmpvar_18.y = (tmpvar_17.y * 0.75);
  highp vec2 a_19;
  a_19 = (0.5 * a_12);
  highp vec2 tmpvar_20;
  tmpvar_20 = floor(a_19);
  a_19 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21.x = 0.5;
  tmpvar_21.y = (tmpvar_20.y * 0.75);
  highp vec2 tmpvar_22;
  tmpvar_22 = floor(a_12);
  highp vec2 tmpvar_23;
  tmpvar_23.x = 0.5;
  tmpvar_23.y = (tmpvar_22.y * 0.75);
  highp vec2 a_24;
  a_24 = (0.5 * gl_FragCoord.xy);
  highp vec2 a_25;
  a_25 = (0.5 * a_24);
  highp vec2 tmpvar_26;
  tmpvar_26 = floor(a_25);
  a_25 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27.x = 0.5;
  tmpvar_27.y = (tmpvar_26.y * 0.75);
  highp vec2 tmpvar_28;
  tmpvar_28 = floor(a_24);
  highp vec2 tmpvar_29;
  tmpvar_29.x = 0.5;
  tmpvar_29.y = (tmpvar_28.y * 0.75);
  highp vec2 tmpvar_30;
  tmpvar_30 = floor(gl_FragCoord.xy);
  highp vec2 tmpvar_31;
  tmpvar_31.x = 0.5;
  tmpvar_31.y = (tmpvar_30.y * 0.75);
  dither_4 = (((
    ((((
      fract(dot (tmpvar_15, tmpvar_16))
     * 0.25) + fract(
      dot (tmpvar_17, tmpvar_18)
    )) * 0.0625) + ((fract(
      dot (tmpvar_20, tmpvar_21)
    ) * 0.25) + fract(dot (tmpvar_22, tmpvar_23))))
   * 0.015625) + (
    (((fract(
      dot (tmpvar_26, tmpvar_27)
    ) * 0.25) + fract(dot (tmpvar_28, tmpvar_29))) * 0.25)
   + 
    fract(dot (tmpvar_30, tmpvar_31))
  )) - 0.4999695);
  dtc_3 = ((tmpvar_11 - texture (u_texture1, tmpvar_10).zw) * ((1.0/(
    float(SAMPLES)
  )) * DENSITY));
  illumdecay_2 = ilval;
  if ((QUALITY > -1)) {
    for (highp int i_32 = 0; i_32 < SAMPLES; i_32 += 4) {
      lowp float s_33;
      coord_9 = (coord_9 - dtc_3);
      lowp vec4 tmpvar_34;
      tmpvar_34 = texture (u_texture1, (coord_9 + (dtc_3 * dither_4)));
      coord_9 = (coord_9 - dtc_3);
      s_33 = (tmpvar_34.x + texture (u_texture1, (coord_9 + (dtc_3 * dither_4))).x);
      coord_9 = (coord_9 - dtc_3);
      s_33 = (s_33 + texture (u_texture1, (coord_9 + (dtc_3 * dither_4))).x);
      coord_9 = (coord_9 - dtc_3);
      s_33 = (s_33 + texture (u_texture1, (coord_9 + (dtc_3 * dither_4))).x);
      s_33 = (s_33 * (illumdecay_2 * WEIGHT));
      occ_7 = (occ_7 + s_33);
      illumdecay_2 = (illumdecay_2 * 0.974);
    };
    highp float tmpvar_35;
    highp float tmpvar_36;
    tmpvar_36 = clamp (((
      sqrt(dot (tuv_8, tuv_8))
     - 0.85) / -0.85), 0.0, 1.0);
    tmpvar_35 = (tmpvar_36 * (tmpvar_36 * (3.0 - 
      (2.0 * tmpvar_36)
    )));
    lowp vec4 tmpvar_37;
    tmpvar_37.w = 1.0;
    tmpvar_37.xyz = (obj_col_5 + ((vec3(0.1872, 0.1872, 0.1872) * occ_7) * tmpvar_35));
    fragColor_1 = (obj_6 * tmpvar_37);
    highp float ngfract_38;
    highp float mask_39;
    highp float angle_40;
    float tmpvar_41;
    tmpvar_41 = ((u_time * 0.00152) + (0.018 * sin(
      (u_time * 0.152)
    )));
    highp float tmpvar_42;
    highp float tmpvar_43;
    tmpvar_43 = (min (abs(
      (tuv_8.y / tuv_8.x)
    ), 1.0) / max (abs(
      (tuv_8.y / tuv_8.x)
    ), 1.0));
    highp float tmpvar_44;
    tmpvar_44 = (tmpvar_43 * tmpvar_43);
    tmpvar_44 = (((
      ((((
        ((((-0.01213232 * tmpvar_44) + 0.05368138) * tmpvar_44) - 0.1173503)
       * tmpvar_44) + 0.1938925) * tmpvar_44) - 0.3326756)
     * tmpvar_44) + 0.9999793) * tmpvar_43);
    tmpvar_44 = (tmpvar_44 + (float(
      (abs((tuv_8.y / tuv_8.x)) > 1.0)
    ) * (
      (tmpvar_44 * -2.0)
     + 1.570796)));
    tmpvar_42 = (tmpvar_44 * sign((tuv_8.y / tuv_8.x)));
    if ((abs(tuv_8.x) > (1e-08 * abs(tuv_8.y)))) {
      if ((tuv_8.x < 0.0)) {
        if ((tuv_8.y >= 0.0)) {
          tmpvar_42 += 3.141593;
        } else {
          tmpvar_42 = (tmpvar_42 - 3.141593);
        };
      };
    } else {
      tmpvar_42 = (sign(tuv_8.y) * 1.570796);
    };
    highp float tmpvar_45;
    tmpvar_45 = sqrt(dot (tuv_8, tuv_8));
    angle_40 = (tmpvar_42 / 6.283159);
    mask_39 = 1.0;
    highp float tmpvar_46;
    tmpvar_46 = (1.65 - (ceil(
      ((6.125 * tmpvar_45) + 0.25)
    ) * 0.1));
    highp float tmpvar_47;
    tmpvar_47 = fract(((6.125 * tmpvar_45) + 0.25));
    float tmpvar_48;
    if ((tmpvar_47 > 0.5)) {
      tmpvar_48 = -(tmpvar_41);
    } else {
      tmpvar_48 = tmpvar_41;
    };
    highp float tmpvar_49;
    tmpvar_49 = abs(((
      fract(((angle_40 * roundEven(
        (12.25 / (tmpvar_46 * tmpvar_46))
      )) + ((tmpvar_48 * 
        (24.5 + (2.0 * tmpvar_46))
      ) * 0.6)))
     * 2.0) - 1.0));
    ngfract_38 = tmpvar_49;
    highp float tmpvar_50;
    tmpvar_50 = fract((tmpvar_45 * 12.25));
    float tmpvar_51;
    if ((tmpvar_50 > 0.5)) {
      tmpvar_51 = -1.0;
    } else {
      tmpvar_51 = 1.0;
    };
    ngfract_38 = (tmpvar_49 * tmpvar_51);
    mask_39 = (1.0 - (ceil(
      (((tmpvar_45 * 12.25) + 0.5) + (ngfract_38 * 0.5))
    ) * 0.1));
    highp float tmpvar_52;
    tmpvar_52 = (2.0 * (abs(
      dFdx(tuv_8.x)
    ) + abs(
      dFdy(tuv_8.x)
    )));
    highp float edge0_53;
    edge0_53 = (-(tmpvar_52) / 3.0);
    highp float tmpvar_54;
    tmpvar_54 = clamp (((
      (sqrt(dot (tuv_8, tuv_8)) - 0.2242)
     - edge0_53) / (
      (tmpvar_52 / 3.0)
     - edge0_53)), 0.0, 1.0);
    highp float tmpvar_55;
    tmpvar_55 = clamp (((
      sqrt(dot (tuv_8, tuv_8))
     - 1.0) / -0.6), 0.0, 1.0);
    highp vec4 tmpvar_56;
    tmpvar_56.w = 1.0;
    tmpvar_56.xyz = max (vec3(0.1019608, 0.07450981, 0.1294118), mix ((
      (0.5 * mix (vec3(0.051, 0.0, 0.27), mix (vec3(0.1019608, 0.07450981, 0.1294118), vec3(1.294118, 1.317647, 1.229412), mask_39), tmpvar_46))
     * 
      (tmpvar_55 * (tmpvar_55 * (3.0 - (2.0 * tmpvar_55))))
    ), vec3(0.8627451, 0.8784314, 0.8196079), (1.0 - 
      (tmpvar_54 * (tmpvar_54 * (3.0 - (2.0 * tmpvar_54))))
    )));
    fragColor_1 = (fragColor_1 + ((
      ((1.0 - obj_6) * tmpvar_56)
     * occ_7) * 0.24));
  } else {
    highp float ngfract_57;
    highp float mask_58;
    highp float angle_59;
    float tmpvar_60;
    tmpvar_60 = ((u_time * 0.00152) + (0.018 * sin(
      (u_time * 0.152)
    )));
    highp float tmpvar_61;
    highp float tmpvar_62;
    tmpvar_62 = (min (abs(
      (tuv_8.y / tuv_8.x)
    ), 1.0) / max (abs(
      (tuv_8.y / tuv_8.x)
    ), 1.0));
    highp float tmpvar_63;
    tmpvar_63 = (tmpvar_62 * tmpvar_62);
    tmpvar_63 = (((
      ((((
        ((((-0.01213232 * tmpvar_63) + 0.05368138) * tmpvar_63) - 0.1173503)
       * tmpvar_63) + 0.1938925) * tmpvar_63) - 0.3326756)
     * tmpvar_63) + 0.9999793) * tmpvar_62);
    tmpvar_63 = (tmpvar_63 + (float(
      (abs((tuv_8.y / tuv_8.x)) > 1.0)
    ) * (
      (tmpvar_63 * -2.0)
     + 1.570796)));
    tmpvar_61 = (tmpvar_63 * sign((tuv_8.y / tuv_8.x)));
    if ((abs(tuv_8.x) > (1e-08 * abs(tuv_8.y)))) {
      if ((tuv_8.x < 0.0)) {
        if ((tuv_8.y >= 0.0)) {
          tmpvar_61 += 3.141593;
        } else {
          tmpvar_61 = (tmpvar_61 - 3.141593);
        };
      };
    } else {
      tmpvar_61 = (sign(tuv_8.y) * 1.570796);
    };
    highp float tmpvar_64;
    tmpvar_64 = sqrt(dot (tuv_8, tuv_8));
    angle_59 = (tmpvar_61 / 6.283159);
    mask_58 = 1.0;
    highp float tmpvar_65;
    tmpvar_65 = (1.65 - (ceil(
      ((6.125 * tmpvar_64) + 0.25)
    ) * 0.1));
    highp float tmpvar_66;
    tmpvar_66 = fract(((6.125 * tmpvar_64) + 0.25));
    float tmpvar_67;
    if ((tmpvar_66 > 0.5)) {
      tmpvar_67 = -(tmpvar_60);
    } else {
      tmpvar_67 = tmpvar_60;
    };
    highp float tmpvar_68;
    tmpvar_68 = abs(((
      fract(((angle_59 * roundEven(
        (12.25 / (tmpvar_65 * tmpvar_65))
      )) + ((tmpvar_67 * 
        (24.5 + (2.0 * tmpvar_65))
      ) * 0.6)))
     * 2.0) - 1.0));
    ngfract_57 = tmpvar_68;
    highp float tmpvar_69;
    tmpvar_69 = fract((tmpvar_64 * 12.25));
    float tmpvar_70;
    if ((tmpvar_69 > 0.5)) {
      tmpvar_70 = -1.0;
    } else {
      tmpvar_70 = 1.0;
    };
    ngfract_57 = (tmpvar_68 * tmpvar_70);
    mask_58 = (1.0 - (ceil(
      (((tmpvar_64 * 12.25) + 0.5) + (ngfract_57 * 0.5))
    ) * 0.1));
    highp float tmpvar_71;
    tmpvar_71 = (2.0 * (abs(
      dFdx(tuv_8.x)
    ) + abs(
      dFdy(tuv_8.x)
    )));
    highp float edge0_72;
    edge0_72 = (-(tmpvar_71) / 3.0);
    highp float tmpvar_73;
    tmpvar_73 = clamp (((
      (sqrt(dot (tuv_8, tuv_8)) - 0.2242)
     - edge0_72) / (
      (tmpvar_71 / 3.0)
     - edge0_72)), 0.0, 1.0);
    highp float tmpvar_74;
    tmpvar_74 = clamp (((
      sqrt(dot (tuv_8, tuv_8))
     - 1.0) / -0.6), 0.0, 1.0);
    highp vec4 tmpvar_75;
    tmpvar_75.w = 1.0;
    tmpvar_75.xyz = max (vec3(0.1019608, 0.07450981, 0.1294118), mix ((
      (0.5 * mix (vec3(0.051, 0.0, 0.27), mix (vec3(0.1019608, 0.07450981, 0.1294118), vec3(1.294118, 1.317647, 1.229412), mask_58), tmpvar_65))
     * 
      (tmpvar_74 * (tmpvar_74 * (3.0 - (2.0 * tmpvar_74))))
    ), vec3(0.8627451, 0.8784314, 0.8196079), (1.0 - 
      (tmpvar_73 * (tmpvar_73 * (3.0 - (2.0 * tmpvar_73))))
    )));
    lowp vec4 tmpvar_76;
    tmpvar_76.w = 1.0;
    tmpvar_76.xyz = obj_col_5;
    fragColor_1 = max ((tmpvar_75 * (1.0 - obj_6)), tmpvar_76);
  };
  fragColor_1 = abs(fragColor_1);
  highp vec2 uv_77;
  uv_77 = tuv_8;
  highp vec4 tmpvar_78;
  if ((ppowerhitr < 0.1)) {
    tmpvar_78 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    uv_77 = (tuv_8 + ((xshape_pos / u_resolution.y) - (
      (u_resolution / u_resolution.y)
     / 2.0)));
    uv_77 = (uv_77 * (u_resolution.y / xshape_size.y));
    highp float tmpvar_79;
    tmpvar_79 = clamp (((
      ((sqrt(dot (uv_77, uv_77)) - 0.5) + 0.5)
     - 0.5) / 0.012), 0.0, 1.0);
    highp vec3 col_80;
    highp vec3 tmpvar_81;
    tmpvar_81.xy = uv_77;
    tmpvar_81.z = (u_time / 15.0);
    highp vec3 p_82;
    highp float f_83;
    p_82 = (tmpvar_81 * 3.0);
    highp vec3 tmpvar_84;
    tmpvar_84 = floor(p_82);
    highp vec3 tmpvar_85;
    tmpvar_85 = (p_82 - tmpvar_84);
    highp vec3 tmpvar_86;
    tmpvar_86 = ((tmpvar_85 * tmpvar_85) * (3.0 - (2.0 * tmpvar_85)));
    highp vec3 p3_87;
    highp vec3 tmpvar_88;
    tmpvar_88 = fract((tmpvar_84 * vec3(0.1031, 0.11369, 0.13787)));
    p3_87 = (tmpvar_88 + dot (tmpvar_88, (tmpvar_88.yxz + 19.19)));
    highp vec3 tmpvar_89;
    tmpvar_89.x = ((p3_87.x + p3_87.y) * p3_87.z);
    tmpvar_89.y = ((p3_87.x + p3_87.z) * p3_87.y);
    tmpvar_89.z = ((p3_87.y + p3_87.z) * p3_87.x);
    highp vec3 p3_90;
    p3_90 = (tmpvar_84 + vec3(1.0, 0.0, 0.0));
    highp vec3 tmpvar_91;
    tmpvar_91 = fract((p3_90 * vec3(0.1031, 0.11369, 0.13787)));
    p3_90 = (tmpvar_91 + dot (tmpvar_91, (tmpvar_91.yxz + 19.19)));
    highp vec3 tmpvar_92;
    tmpvar_92.x = ((p3_90.x + p3_90.y) * p3_90.z);
    tmpvar_92.y = ((p3_90.x + p3_90.z) * p3_90.y);
    tmpvar_92.z = ((p3_90.y + p3_90.z) * p3_90.x);
    highp vec3 p3_93;
    p3_93 = (tmpvar_84 + vec3(0.0, 0.0, 1.0));
    highp vec3 tmpvar_94;
    tmpvar_94 = fract((p3_93 * vec3(0.1031, 0.11369, 0.13787)));
    p3_93 = (tmpvar_94 + dot (tmpvar_94, (tmpvar_94.yxz + 19.19)));
    highp vec3 tmpvar_95;
    tmpvar_95.x = ((p3_93.x + p3_93.y) * p3_93.z);
    tmpvar_95.y = ((p3_93.x + p3_93.z) * p3_93.y);
    tmpvar_95.z = ((p3_93.y + p3_93.z) * p3_93.x);
    highp vec3 p3_96;
    p3_96 = (tmpvar_84 + vec3(1.0, 0.0, 1.0));
    highp vec3 tmpvar_97;
    tmpvar_97 = fract((p3_96 * vec3(0.1031, 0.11369, 0.13787)));
    p3_96 = (tmpvar_97 + dot (tmpvar_97, (tmpvar_97.yxz + 19.19)));
    highp vec3 tmpvar_98;
    tmpvar_98.x = ((p3_96.x + p3_96.y) * p3_96.z);
    tmpvar_98.y = ((p3_96.x + p3_96.z) * p3_96.y);
    tmpvar_98.z = ((p3_96.y + p3_96.z) * p3_96.x);
    highp vec3 p3_99;
    p3_99 = (tmpvar_84 + vec3(0.0, 1.0, 0.0));
    highp vec3 tmpvar_100;
    tmpvar_100 = fract((p3_99 * vec3(0.1031, 0.11369, 0.13787)));
    p3_99 = (tmpvar_100 + dot (tmpvar_100, (tmpvar_100.yxz + 19.19)));
    highp vec3 tmpvar_101;
    tmpvar_101.x = ((p3_99.x + p3_99.y) * p3_99.z);
    tmpvar_101.y = ((p3_99.x + p3_99.z) * p3_99.y);
    tmpvar_101.z = ((p3_99.y + p3_99.z) * p3_99.x);
    highp vec3 p3_102;
    p3_102 = (tmpvar_84 + vec3(1.0, 1.0, 0.0));
    highp vec3 tmpvar_103;
    tmpvar_103 = fract((p3_102 * vec3(0.1031, 0.11369, 0.13787)));
    p3_102 = (tmpvar_103 + dot (tmpvar_103, (tmpvar_103.yxz + 19.19)));
    highp vec3 tmpvar_104;
    tmpvar_104.x = ((p3_102.x + p3_102.y) * p3_102.z);
    tmpvar_104.y = ((p3_102.x + p3_102.z) * p3_102.y);
    tmpvar_104.z = ((p3_102.y + p3_102.z) * p3_102.x);
    highp vec3 p3_105;
    p3_105 = (tmpvar_84 + vec3(0.0, 1.0, 1.0));
    highp vec3 tmpvar_106;
    tmpvar_106 = fract((p3_105 * vec3(0.1031, 0.11369, 0.13787)));
    p3_105 = (tmpvar_106 + dot (tmpvar_106, (tmpvar_106.yxz + 19.19)));
    highp vec3 tmpvar_107;
    tmpvar_107.x = ((p3_105.x + p3_105.y) * p3_105.z);
    tmpvar_107.y = ((p3_105.x + p3_105.z) * p3_105.y);
    tmpvar_107.z = ((p3_105.y + p3_105.z) * p3_105.x);
    highp vec3 p3_108;
    p3_108 = (tmpvar_84 + vec3(1.0, 1.0, 1.0));
    highp vec3 tmpvar_109;
    tmpvar_109 = fract((p3_108 * vec3(0.1031, 0.11369, 0.13787)));
    p3_108 = (tmpvar_109 + dot (tmpvar_109, (tmpvar_109.yxz + 19.19)));
    highp vec3 tmpvar_110;
    tmpvar_110.x = ((p3_108.x + p3_108.y) * p3_108.z);
    tmpvar_110.y = ((p3_108.x + p3_108.z) * p3_108.y);
    tmpvar_110.z = ((p3_108.y + p3_108.z) * p3_108.x);
    f_83 = abs(mix (mix (
      mix (dot (tmpvar_85, (-1.0 + (2.0 * 
        fract(tmpvar_89)
      ))), dot ((tmpvar_85 - vec3(1.0, 0.0, 0.0)), (-1.0 + (2.0 * 
        fract(tmpvar_92)
      ))), tmpvar_86.x)
    , 
      mix (dot ((tmpvar_85 - vec3(0.0, 0.0, 1.0)), (-1.0 + (2.0 * 
        fract(tmpvar_95)
      ))), dot ((tmpvar_85 - vec3(1.0, 0.0, 1.0)), (-1.0 + (2.0 * 
        fract(tmpvar_98)
      ))), tmpvar_86.x)
    , tmpvar_86.z), mix (
      mix (dot ((tmpvar_85 - vec3(0.0, 1.0, 0.0)), (-1.0 + (2.0 * 
        fract(tmpvar_101)
      ))), dot ((tmpvar_85 - vec3(1.0, 1.0, 0.0)), (-1.0 + (2.0 * 
        fract(tmpvar_104)
      ))), tmpvar_86.x)
    , 
      mix (dot ((tmpvar_85 - vec3(0.0, 1.0, 1.0)), (-1.0 + (2.0 * 
        fract(tmpvar_107)
      ))), dot ((tmpvar_85 - vec3(1.0, 1.0, 1.0)), (-1.0 + (2.0 * 
        fract(tmpvar_110)
      ))), tmpvar_86.x)
    , tmpvar_86.z), tmpvar_86.y));
    p_82 = (2.0 * p_82);
    highp vec3 tmpvar_111;
    tmpvar_111 = floor(p_82);
    highp vec3 tmpvar_112;
    tmpvar_112 = (p_82 - tmpvar_111);
    highp vec3 tmpvar_113;
    tmpvar_113 = ((tmpvar_112 * tmpvar_112) * (3.0 - (2.0 * tmpvar_112)));
    highp vec3 p3_114;
    highp vec3 tmpvar_115;
    tmpvar_115 = fract((tmpvar_111 * vec3(0.1031, 0.11369, 0.13787)));
    p3_114 = (tmpvar_115 + dot (tmpvar_115, (tmpvar_115.yxz + 19.19)));
    highp vec3 tmpvar_116;
    tmpvar_116.x = ((p3_114.x + p3_114.y) * p3_114.z);
    tmpvar_116.y = ((p3_114.x + p3_114.z) * p3_114.y);
    tmpvar_116.z = ((p3_114.y + p3_114.z) * p3_114.x);
    highp vec3 p3_117;
    p3_117 = (tmpvar_111 + vec3(1.0, 0.0, 0.0));
    highp vec3 tmpvar_118;
    tmpvar_118 = fract((p3_117 * vec3(0.1031, 0.11369, 0.13787)));
    p3_117 = (tmpvar_118 + dot (tmpvar_118, (tmpvar_118.yxz + 19.19)));
    highp vec3 tmpvar_119;
    tmpvar_119.x = ((p3_117.x + p3_117.y) * p3_117.z);
    tmpvar_119.y = ((p3_117.x + p3_117.z) * p3_117.y);
    tmpvar_119.z = ((p3_117.y + p3_117.z) * p3_117.x);
    highp vec3 p3_120;
    p3_120 = (tmpvar_111 + vec3(0.0, 0.0, 1.0));
    highp vec3 tmpvar_121;
    tmpvar_121 = fract((p3_120 * vec3(0.1031, 0.11369, 0.13787)));
    p3_120 = (tmpvar_121 + dot (tmpvar_121, (tmpvar_121.yxz + 19.19)));
    highp vec3 tmpvar_122;
    tmpvar_122.x = ((p3_120.x + p3_120.y) * p3_120.z);
    tmpvar_122.y = ((p3_120.x + p3_120.z) * p3_120.y);
    tmpvar_122.z = ((p3_120.y + p3_120.z) * p3_120.x);
    highp vec3 p3_123;
    p3_123 = (tmpvar_111 + vec3(1.0, 0.0, 1.0));
    highp vec3 tmpvar_124;
    tmpvar_124 = fract((p3_123 * vec3(0.1031, 0.11369, 0.13787)));
    p3_123 = (tmpvar_124 + dot (tmpvar_124, (tmpvar_124.yxz + 19.19)));
    highp vec3 tmpvar_125;
    tmpvar_125.x = ((p3_123.x + p3_123.y) * p3_123.z);
    tmpvar_125.y = ((p3_123.x + p3_123.z) * p3_123.y);
    tmpvar_125.z = ((p3_123.y + p3_123.z) * p3_123.x);
    highp vec3 p3_126;
    p3_126 = (tmpvar_111 + vec3(0.0, 1.0, 0.0));
    highp vec3 tmpvar_127;
    tmpvar_127 = fract((p3_126 * vec3(0.1031, 0.11369, 0.13787)));
    p3_126 = (tmpvar_127 + dot (tmpvar_127, (tmpvar_127.yxz + 19.19)));
    highp vec3 tmpvar_128;
    tmpvar_128.x = ((p3_126.x + p3_126.y) * p3_126.z);
    tmpvar_128.y = ((p3_126.x + p3_126.z) * p3_126.y);
    tmpvar_128.z = ((p3_126.y + p3_126.z) * p3_126.x);
    highp vec3 p3_129;
    p3_129 = (tmpvar_111 + vec3(1.0, 1.0, 0.0));
    highp vec3 tmpvar_130;
    tmpvar_130 = fract((p3_129 * vec3(0.1031, 0.11369, 0.13787)));
    p3_129 = (tmpvar_130 + dot (tmpvar_130, (tmpvar_130.yxz + 19.19)));
    highp vec3 tmpvar_131;
    tmpvar_131.x = ((p3_129.x + p3_129.y) * p3_129.z);
    tmpvar_131.y = ((p3_129.x + p3_129.z) * p3_129.y);
    tmpvar_131.z = ((p3_129.y + p3_129.z) * p3_129.x);
    highp vec3 p3_132;
    p3_132 = (tmpvar_111 + vec3(0.0, 1.0, 1.0));
    highp vec3 tmpvar_133;
    tmpvar_133 = fract((p3_132 * vec3(0.1031, 0.11369, 0.13787)));
    p3_132 = (tmpvar_133 + dot (tmpvar_133, (tmpvar_133.yxz + 19.19)));
    highp vec3 tmpvar_134;
    tmpvar_134.x = ((p3_132.x + p3_132.y) * p3_132.z);
    tmpvar_134.y = ((p3_132.x + p3_132.z) * p3_132.y);
    tmpvar_134.z = ((p3_132.y + p3_132.z) * p3_132.x);
    highp vec3 p3_135;
    p3_135 = (tmpvar_111 + vec3(1.0, 1.0, 1.0));
    highp vec3 tmpvar_136;
    tmpvar_136 = fract((p3_135 * vec3(0.1031, 0.11369, 0.13787)));
    p3_135 = (tmpvar_136 + dot (tmpvar_136, (tmpvar_136.yxz + 19.19)));
    highp vec3 tmpvar_137;
    tmpvar_137.x = ((p3_135.x + p3_135.y) * p3_135.z);
    tmpvar_137.y = ((p3_135.x + p3_135.z) * p3_135.y);
    tmpvar_137.z = ((p3_135.y + p3_135.z) * p3_135.x);
    f_83 = (f_83 + (0.5 * abs(
      mix (mix (mix (dot (tmpvar_112, 
        (-1.0 + (2.0 * fract(tmpvar_116)))
      ), dot (
        (tmpvar_112 - vec3(1.0, 0.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_119)))
      ), tmpvar_113.x), mix (dot (
        (tmpvar_112 - vec3(0.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_122)))
      ), dot (
        (tmpvar_112 - vec3(1.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_125)))
      ), tmpvar_113.x), tmpvar_113.z), mix (mix (dot (
        (tmpvar_112 - vec3(0.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_128)))
      ), dot (
        (tmpvar_112 - vec3(1.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_131)))
      ), tmpvar_113.x), mix (dot (
        (tmpvar_112 - vec3(0.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_134)))
      ), dot (
        (tmpvar_112 - vec3(1.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_137)))
      ), tmpvar_113.x), tmpvar_113.z), tmpvar_113.y)
    )));
    p_82 = (3.0 * p_82);
    highp vec3 tmpvar_138;
    tmpvar_138 = floor(p_82);
    highp vec3 tmpvar_139;
    tmpvar_139 = (p_82 - tmpvar_138);
    highp vec3 tmpvar_140;
    tmpvar_140 = ((tmpvar_139 * tmpvar_139) * (3.0 - (2.0 * tmpvar_139)));
    highp vec3 p3_141;
    highp vec3 tmpvar_142;
    tmpvar_142 = fract((tmpvar_138 * vec3(0.1031, 0.11369, 0.13787)));
    p3_141 = (tmpvar_142 + dot (tmpvar_142, (tmpvar_142.yxz + 19.19)));
    highp vec3 tmpvar_143;
    tmpvar_143.x = ((p3_141.x + p3_141.y) * p3_141.z);
    tmpvar_143.y = ((p3_141.x + p3_141.z) * p3_141.y);
    tmpvar_143.z = ((p3_141.y + p3_141.z) * p3_141.x);
    highp vec3 p3_144;
    p3_144 = (tmpvar_138 + vec3(1.0, 0.0, 0.0));
    highp vec3 tmpvar_145;
    tmpvar_145 = fract((p3_144 * vec3(0.1031, 0.11369, 0.13787)));
    p3_144 = (tmpvar_145 + dot (tmpvar_145, (tmpvar_145.yxz + 19.19)));
    highp vec3 tmpvar_146;
    tmpvar_146.x = ((p3_144.x + p3_144.y) * p3_144.z);
    tmpvar_146.y = ((p3_144.x + p3_144.z) * p3_144.y);
    tmpvar_146.z = ((p3_144.y + p3_144.z) * p3_144.x);
    highp vec3 p3_147;
    p3_147 = (tmpvar_138 + vec3(0.0, 0.0, 1.0));
    highp vec3 tmpvar_148;
    tmpvar_148 = fract((p3_147 * vec3(0.1031, 0.11369, 0.13787)));
    p3_147 = (tmpvar_148 + dot (tmpvar_148, (tmpvar_148.yxz + 19.19)));
    highp vec3 tmpvar_149;
    tmpvar_149.x = ((p3_147.x + p3_147.y) * p3_147.z);
    tmpvar_149.y = ((p3_147.x + p3_147.z) * p3_147.y);
    tmpvar_149.z = ((p3_147.y + p3_147.z) * p3_147.x);
    highp vec3 p3_150;
    p3_150 = (tmpvar_138 + vec3(1.0, 0.0, 1.0));
    highp vec3 tmpvar_151;
    tmpvar_151 = fract((p3_150 * vec3(0.1031, 0.11369, 0.13787)));
    p3_150 = (tmpvar_151 + dot (tmpvar_151, (tmpvar_151.yxz + 19.19)));
    highp vec3 tmpvar_152;
    tmpvar_152.x = ((p3_150.x + p3_150.y) * p3_150.z);
    tmpvar_152.y = ((p3_150.x + p3_150.z) * p3_150.y);
    tmpvar_152.z = ((p3_150.y + p3_150.z) * p3_150.x);
    highp vec3 p3_153;
    p3_153 = (tmpvar_138 + vec3(0.0, 1.0, 0.0));
    highp vec3 tmpvar_154;
    tmpvar_154 = fract((p3_153 * vec3(0.1031, 0.11369, 0.13787)));
    p3_153 = (tmpvar_154 + dot (tmpvar_154, (tmpvar_154.yxz + 19.19)));
    highp vec3 tmpvar_155;
    tmpvar_155.x = ((p3_153.x + p3_153.y) * p3_153.z);
    tmpvar_155.y = ((p3_153.x + p3_153.z) * p3_153.y);
    tmpvar_155.z = ((p3_153.y + p3_153.z) * p3_153.x);
    highp vec3 p3_156;
    p3_156 = (tmpvar_138 + vec3(1.0, 1.0, 0.0));
    highp vec3 tmpvar_157;
    tmpvar_157 = fract((p3_156 * vec3(0.1031, 0.11369, 0.13787)));
    p3_156 = (tmpvar_157 + dot (tmpvar_157, (tmpvar_157.yxz + 19.19)));
    highp vec3 tmpvar_158;
    tmpvar_158.x = ((p3_156.x + p3_156.y) * p3_156.z);
    tmpvar_158.y = ((p3_156.x + p3_156.z) * p3_156.y);
    tmpvar_158.z = ((p3_156.y + p3_156.z) * p3_156.x);
    highp vec3 p3_159;
    p3_159 = (tmpvar_138 + vec3(0.0, 1.0, 1.0));
    highp vec3 tmpvar_160;
    tmpvar_160 = fract((p3_159 * vec3(0.1031, 0.11369, 0.13787)));
    p3_159 = (tmpvar_160 + dot (tmpvar_160, (tmpvar_160.yxz + 19.19)));
    highp vec3 tmpvar_161;
    tmpvar_161.x = ((p3_159.x + p3_159.y) * p3_159.z);
    tmpvar_161.y = ((p3_159.x + p3_159.z) * p3_159.y);
    tmpvar_161.z = ((p3_159.y + p3_159.z) * p3_159.x);
    highp vec3 p3_162;
    p3_162 = (tmpvar_138 + vec3(1.0, 1.0, 1.0));
    highp vec3 tmpvar_163;
    tmpvar_163 = fract((p3_162 * vec3(0.1031, 0.11369, 0.13787)));
    p3_162 = (tmpvar_163 + dot (tmpvar_163, (tmpvar_163.yxz + 19.19)));
    highp vec3 tmpvar_164;
    tmpvar_164.x = ((p3_162.x + p3_162.y) * p3_162.z);
    tmpvar_164.y = ((p3_162.x + p3_162.z) * p3_162.y);
    tmpvar_164.z = ((p3_162.y + p3_162.z) * p3_162.x);
    f_83 = (f_83 + (0.25 * abs(
      mix (mix (mix (dot (tmpvar_139, 
        (-1.0 + (2.0 * fract(tmpvar_143)))
      ), dot (
        (tmpvar_139 - vec3(1.0, 0.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_146)))
      ), tmpvar_140.x), mix (dot (
        (tmpvar_139 - vec3(0.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_149)))
      ), dot (
        (tmpvar_139 - vec3(1.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_152)))
      ), tmpvar_140.x), tmpvar_140.z), mix (mix (dot (
        (tmpvar_139 - vec3(0.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_155)))
      ), dot (
        (tmpvar_139 - vec3(1.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_158)))
      ), tmpvar_140.x), mix (dot (
        (tmpvar_139 - vec3(0.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_161)))
      ), dot (
        (tmpvar_139 - vec3(1.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_164)))
      ), tmpvar_140.x), tmpvar_140.z), tmpvar_140.y)
    )));
    p_82 = (4.0 * p_82);
    highp vec3 tmpvar_165;
    tmpvar_165 = floor(p_82);
    highp vec3 tmpvar_166;
    tmpvar_166 = (p_82 - tmpvar_165);
    highp vec3 tmpvar_167;
    tmpvar_167 = ((tmpvar_166 * tmpvar_166) * (3.0 - (2.0 * tmpvar_166)));
    highp vec3 p3_168;
    highp vec3 tmpvar_169;
    tmpvar_169 = fract((tmpvar_165 * vec3(0.1031, 0.11369, 0.13787)));
    p3_168 = (tmpvar_169 + dot (tmpvar_169, (tmpvar_169.yxz + 19.19)));
    highp vec3 tmpvar_170;
    tmpvar_170.x = ((p3_168.x + p3_168.y) * p3_168.z);
    tmpvar_170.y = ((p3_168.x + p3_168.z) * p3_168.y);
    tmpvar_170.z = ((p3_168.y + p3_168.z) * p3_168.x);
    highp vec3 p3_171;
    p3_171 = (tmpvar_165 + vec3(1.0, 0.0, 0.0));
    highp vec3 tmpvar_172;
    tmpvar_172 = fract((p3_171 * vec3(0.1031, 0.11369, 0.13787)));
    p3_171 = (tmpvar_172 + dot (tmpvar_172, (tmpvar_172.yxz + 19.19)));
    highp vec3 tmpvar_173;
    tmpvar_173.x = ((p3_171.x + p3_171.y) * p3_171.z);
    tmpvar_173.y = ((p3_171.x + p3_171.z) * p3_171.y);
    tmpvar_173.z = ((p3_171.y + p3_171.z) * p3_171.x);
    highp vec3 p3_174;
    p3_174 = (tmpvar_165 + vec3(0.0, 0.0, 1.0));
    highp vec3 tmpvar_175;
    tmpvar_175 = fract((p3_174 * vec3(0.1031, 0.11369, 0.13787)));
    p3_174 = (tmpvar_175 + dot (tmpvar_175, (tmpvar_175.yxz + 19.19)));
    highp vec3 tmpvar_176;
    tmpvar_176.x = ((p3_174.x + p3_174.y) * p3_174.z);
    tmpvar_176.y = ((p3_174.x + p3_174.z) * p3_174.y);
    tmpvar_176.z = ((p3_174.y + p3_174.z) * p3_174.x);
    highp vec3 p3_177;
    p3_177 = (tmpvar_165 + vec3(1.0, 0.0, 1.0));
    highp vec3 tmpvar_178;
    tmpvar_178 = fract((p3_177 * vec3(0.1031, 0.11369, 0.13787)));
    p3_177 = (tmpvar_178 + dot (tmpvar_178, (tmpvar_178.yxz + 19.19)));
    highp vec3 tmpvar_179;
    tmpvar_179.x = ((p3_177.x + p3_177.y) * p3_177.z);
    tmpvar_179.y = ((p3_177.x + p3_177.z) * p3_177.y);
    tmpvar_179.z = ((p3_177.y + p3_177.z) * p3_177.x);
    highp vec3 p3_180;
    p3_180 = (tmpvar_165 + vec3(0.0, 1.0, 0.0));
    highp vec3 tmpvar_181;
    tmpvar_181 = fract((p3_180 * vec3(0.1031, 0.11369, 0.13787)));
    p3_180 = (tmpvar_181 + dot (tmpvar_181, (tmpvar_181.yxz + 19.19)));
    highp vec3 tmpvar_182;
    tmpvar_182.x = ((p3_180.x + p3_180.y) * p3_180.z);
    tmpvar_182.y = ((p3_180.x + p3_180.z) * p3_180.y);
    tmpvar_182.z = ((p3_180.y + p3_180.z) * p3_180.x);
    highp vec3 p3_183;
    p3_183 = (tmpvar_165 + vec3(1.0, 1.0, 0.0));
    highp vec3 tmpvar_184;
    tmpvar_184 = fract((p3_183 * vec3(0.1031, 0.11369, 0.13787)));
    p3_183 = (tmpvar_184 + dot (tmpvar_184, (tmpvar_184.yxz + 19.19)));
    highp vec3 tmpvar_185;
    tmpvar_185.x = ((p3_183.x + p3_183.y) * p3_183.z);
    tmpvar_185.y = ((p3_183.x + p3_183.z) * p3_183.y);
    tmpvar_185.z = ((p3_183.y + p3_183.z) * p3_183.x);
    highp vec3 p3_186;
    p3_186 = (tmpvar_165 + vec3(0.0, 1.0, 1.0));
    highp vec3 tmpvar_187;
    tmpvar_187 = fract((p3_186 * vec3(0.1031, 0.11369, 0.13787)));
    p3_186 = (tmpvar_187 + dot (tmpvar_187, (tmpvar_187.yxz + 19.19)));
    highp vec3 tmpvar_188;
    tmpvar_188.x = ((p3_186.x + p3_186.y) * p3_186.z);
    tmpvar_188.y = ((p3_186.x + p3_186.z) * p3_186.y);
    tmpvar_188.z = ((p3_186.y + p3_186.z) * p3_186.x);
    highp vec3 p3_189;
    p3_189 = (tmpvar_165 + vec3(1.0, 1.0, 1.0));
    highp vec3 tmpvar_190;
    tmpvar_190 = fract((p3_189 * vec3(0.1031, 0.11369, 0.13787)));
    p3_189 = (tmpvar_190 + dot (tmpvar_190, (tmpvar_190.yxz + 19.19)));
    highp vec3 tmpvar_191;
    tmpvar_191.x = ((p3_189.x + p3_189.y) * p3_189.z);
    tmpvar_191.y = ((p3_189.x + p3_189.z) * p3_189.y);
    tmpvar_191.z = ((p3_189.y + p3_189.z) * p3_189.x);
    f_83 = (f_83 + (0.125 * abs(
      mix (mix (mix (dot (tmpvar_166, 
        (-1.0 + (2.0 * fract(tmpvar_170)))
      ), dot (
        (tmpvar_166 - vec3(1.0, 0.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_173)))
      ), tmpvar_167.x), mix (dot (
        (tmpvar_166 - vec3(0.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_176)))
      ), dot (
        (tmpvar_166 - vec3(1.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_179)))
      ), tmpvar_167.x), tmpvar_167.z), mix (mix (dot (
        (tmpvar_166 - vec3(0.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_182)))
      ), dot (
        (tmpvar_166 - vec3(1.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_185)))
      ), tmpvar_167.x), mix (dot (
        (tmpvar_166 - vec3(0.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_188)))
      ), dot (
        (tmpvar_166 - vec3(1.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_191)))
      ), tmpvar_167.x), tmpvar_167.z), tmpvar_167.y)
    )));
    p_82 = (5.0 * p_82);
    highp vec3 tmpvar_192;
    tmpvar_192 = floor(p_82);
    highp vec3 tmpvar_193;
    tmpvar_193 = (p_82 - tmpvar_192);
    highp vec3 tmpvar_194;
    tmpvar_194 = ((tmpvar_193 * tmpvar_193) * (3.0 - (2.0 * tmpvar_193)));
    highp vec3 p3_195;
    highp vec3 tmpvar_196;
    tmpvar_196 = fract((tmpvar_192 * vec3(0.1031, 0.11369, 0.13787)));
    p3_195 = (tmpvar_196 + dot (tmpvar_196, (tmpvar_196.yxz + 19.19)));
    highp vec3 tmpvar_197;
    tmpvar_197.x = ((p3_195.x + p3_195.y) * p3_195.z);
    tmpvar_197.y = ((p3_195.x + p3_195.z) * p3_195.y);
    tmpvar_197.z = ((p3_195.y + p3_195.z) * p3_195.x);
    highp vec3 p3_198;
    p3_198 = (tmpvar_192 + vec3(1.0, 0.0, 0.0));
    highp vec3 tmpvar_199;
    tmpvar_199 = fract((p3_198 * vec3(0.1031, 0.11369, 0.13787)));
    p3_198 = (tmpvar_199 + dot (tmpvar_199, (tmpvar_199.yxz + 19.19)));
    highp vec3 tmpvar_200;
    tmpvar_200.x = ((p3_198.x + p3_198.y) * p3_198.z);
    tmpvar_200.y = ((p3_198.x + p3_198.z) * p3_198.y);
    tmpvar_200.z = ((p3_198.y + p3_198.z) * p3_198.x);
    highp vec3 p3_201;
    p3_201 = (tmpvar_192 + vec3(0.0, 0.0, 1.0));
    highp vec3 tmpvar_202;
    tmpvar_202 = fract((p3_201 * vec3(0.1031, 0.11369, 0.13787)));
    p3_201 = (tmpvar_202 + dot (tmpvar_202, (tmpvar_202.yxz + 19.19)));
    highp vec3 tmpvar_203;
    tmpvar_203.x = ((p3_201.x + p3_201.y) * p3_201.z);
    tmpvar_203.y = ((p3_201.x + p3_201.z) * p3_201.y);
    tmpvar_203.z = ((p3_201.y + p3_201.z) * p3_201.x);
    highp vec3 p3_204;
    p3_204 = (tmpvar_192 + vec3(1.0, 0.0, 1.0));
    highp vec3 tmpvar_205;
    tmpvar_205 = fract((p3_204 * vec3(0.1031, 0.11369, 0.13787)));
    p3_204 = (tmpvar_205 + dot (tmpvar_205, (tmpvar_205.yxz + 19.19)));
    highp vec3 tmpvar_206;
    tmpvar_206.x = ((p3_204.x + p3_204.y) * p3_204.z);
    tmpvar_206.y = ((p3_204.x + p3_204.z) * p3_204.y);
    tmpvar_206.z = ((p3_204.y + p3_204.z) * p3_204.x);
    highp vec3 p3_207;
    p3_207 = (tmpvar_192 + vec3(0.0, 1.0, 0.0));
    highp vec3 tmpvar_208;
    tmpvar_208 = fract((p3_207 * vec3(0.1031, 0.11369, 0.13787)));
    p3_207 = (tmpvar_208 + dot (tmpvar_208, (tmpvar_208.yxz + 19.19)));
    highp vec3 tmpvar_209;
    tmpvar_209.x = ((p3_207.x + p3_207.y) * p3_207.z);
    tmpvar_209.y = ((p3_207.x + p3_207.z) * p3_207.y);
    tmpvar_209.z = ((p3_207.y + p3_207.z) * p3_207.x);
    highp vec3 p3_210;
    p3_210 = (tmpvar_192 + vec3(1.0, 1.0, 0.0));
    highp vec3 tmpvar_211;
    tmpvar_211 = fract((p3_210 * vec3(0.1031, 0.11369, 0.13787)));
    p3_210 = (tmpvar_211 + dot (tmpvar_211, (tmpvar_211.yxz + 19.19)));
    highp vec3 tmpvar_212;
    tmpvar_212.x = ((p3_210.x + p3_210.y) * p3_210.z);
    tmpvar_212.y = ((p3_210.x + p3_210.z) * p3_210.y);
    tmpvar_212.z = ((p3_210.y + p3_210.z) * p3_210.x);
    highp vec3 p3_213;
    p3_213 = (tmpvar_192 + vec3(0.0, 1.0, 1.0));
    highp vec3 tmpvar_214;
    tmpvar_214 = fract((p3_213 * vec3(0.1031, 0.11369, 0.13787)));
    p3_213 = (tmpvar_214 + dot (tmpvar_214, (tmpvar_214.yxz + 19.19)));
    highp vec3 tmpvar_215;
    tmpvar_215.x = ((p3_213.x + p3_213.y) * p3_213.z);
    tmpvar_215.y = ((p3_213.x + p3_213.z) * p3_213.y);
    tmpvar_215.z = ((p3_213.y + p3_213.z) * p3_213.x);
    highp vec3 p3_216;
    p3_216 = (tmpvar_192 + vec3(1.0, 1.0, 1.0));
    highp vec3 tmpvar_217;
    tmpvar_217 = fract((p3_216 * vec3(0.1031, 0.11369, 0.13787)));
    p3_216 = (tmpvar_217 + dot (tmpvar_217, (tmpvar_217.yxz + 19.19)));
    highp vec3 tmpvar_218;
    tmpvar_218.x = ((p3_216.x + p3_216.y) * p3_216.z);
    tmpvar_218.y = ((p3_216.x + p3_216.z) * p3_216.y);
    tmpvar_218.z = ((p3_216.y + p3_216.z) * p3_216.x);
    f_83 = (f_83 + (0.0625 * abs(
      mix (mix (mix (dot (tmpvar_193, 
        (-1.0 + (2.0 * fract(tmpvar_197)))
      ), dot (
        (tmpvar_193 - vec3(1.0, 0.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_200)))
      ), tmpvar_194.x), mix (dot (
        (tmpvar_193 - vec3(0.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_203)))
      ), dot (
        (tmpvar_193 - vec3(1.0, 0.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_206)))
      ), tmpvar_194.x), tmpvar_194.z), mix (mix (dot (
        (tmpvar_193 - vec3(0.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_209)))
      ), dot (
        (tmpvar_193 - vec3(1.0, 1.0, 0.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_212)))
      ), tmpvar_194.x), mix (dot (
        (tmpvar_193 - vec3(0.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_215)))
      ), dot (
        (tmpvar_193 - vec3(1.0, 1.0, 1.0))
      , 
        (-1.0 + (2.0 * fract(tmpvar_218)))
      ), tmpvar_194.x), tmpvar_194.z), tmpvar_194.y)
    )));
    p_82 = (6.0 * p_82);
    highp float tmpvar_219;
    tmpvar_219 = (0.9 * f_83);
    col_80 = (vec3(0.4196078, 0.5803922, 0.7686275) + (1.0 - (tmpvar_219 + 
      (sqrt(dot (uv_77, uv_77)) - 0.4)
    )));
    col_80 = (col_80 + (1.0 - (4.2 * tmpvar_219)));
    highp vec3 tmpvar_220;
    tmpvar_220 = clamp (col_80, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    col_80 = tmpvar_220;
    highp vec4 tmpvar_221;
    tmpvar_221.xyz = tmpvar_220;
    tmpvar_221.w = 1.0;
    tmpvar_78 = ((ppowerhitr * (tmpvar_79 * 
      (tmpvar_79 * (3.0 - (2.0 * tmpvar_79)))
    )) * tmpvar_221);
  };
  fragColor_1 = (fragColor_1 + clamp (tmpvar_78, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0)));
  if ((u_time <= 15.0)) {
    highp vec2 p_222;
    float tmpvar_223;
    float tmpvar_224;
    tmpvar_224 = (u_time - 2.5);
    tmpvar_223 = clamp ((tmpvar_224 / 1.5), 0.0, 1.0);
    highp float tmpvar_225;
    tmpvar_225 = clamp (((tuv_8.x + 0.5) / 10.0), 0.0, 1.0);
    highp float tmpvar_226;
    tmpvar_226 = clamp (((
      (20.0 * abs(((tmpvar_225 * 
        (tmpvar_225 * (3.0 - (2.0 * tmpvar_225)))
      ) - 0.5)))
     - 10.0) / -0.05000019), 0.0, 1.0);
    highp float tmpvar_227;
    tmpvar_227 = (float(mod (((
      ((tuv_8.x * 0.0031) + 0.0005)
     * 7241.646) + 2130.466), 64.98413)));
    highp vec2 tmpvar_228;
    tmpvar_228.x = floor(tmpvar_227);
    tmpvar_228.y = 2000.0;
    highp vec2 tmpvar_229;
    tmpvar_229.x = fract(tmpvar_227);
    tmpvar_229.y = 0.0;
    highp vec2 p_230;
    p_230 = (tmpvar_228 + vec2(1.0, 0.0));
    highp vec2 tmpvar_231;
    tmpvar_231.x = floor(tmpvar_227);
    tmpvar_231.y = 2000.0;
    highp vec2 tmpvar_232;
    tmpvar_232.x = fract(tmpvar_227);
    tmpvar_232.y = 0.0;
    highp vec2 p_233;
    p_233 = (tmpvar_231 + vec2(1.0, 0.0));
    highp vec2 tmpvar_234;
    tmpvar_234.x = floor(tmpvar_227);
    tmpvar_234.y = 2000.0;
    highp vec2 tmpvar_235;
    tmpvar_235.x = fract(tmpvar_227);
    tmpvar_235.y = 0.0;
    highp vec2 p_236;
    p_236 = (tmpvar_234 + vec2(1.0, 0.0));
    highp vec2 tmpvar_237;
    tmpvar_237.x = floor(tmpvar_227);
    tmpvar_237.y = 2000.0;
    highp vec2 tmpvar_238;
    tmpvar_238.x = fract(tmpvar_227);
    tmpvar_238.y = 0.0;
    highp vec2 p_239;
    p_239 = (tmpvar_237 + vec2(1.0, 0.0));
    p_222.x = tuv_8.x;
    float tmpvar_240;
    tmpvar_240 = clamp ((tmpvar_224 / 1.5), 0.0, 1.0);
    p_222.y = (tuv_8.y + ((
      cos(((0.5 * tuv_8.x) - 0.15))
     - 0.975) * (tmpvar_240 * 
      (tmpvar_240 * (3.0 - (2.0 * tmpvar_240)))
    )));
    highp vec2 tmpvar_241;
    tmpvar_241.x = p_222.x;
    tmpvar_241.y = ((p_222.y * 2.0) + ((
      ((((
        (0.5 * mix (fract((
          sin(((tmpvar_228.x * 591.32) + 308154.0))
         * 
          cos(((tmpvar_228.x * 391.32) + 98154.0))
        )), fract((
          sin(((p_230.x * 591.32) + (p_230.y * 154.077)))
         * 
          cos(((p_230.x * 391.32) + (p_230.y * 49.077)))
        )), tmpvar_229.x))
       + 
        (0.25 * mix (fract((
          sin(((tmpvar_231.x * 591.32) + 308154.0))
         * 
          cos(((tmpvar_231.x * 391.32) + 98154.0))
        )), fract((
          sin(((p_233.x * 591.32) + (p_233.y * 154.077)))
         * 
          cos(((p_233.x * 391.32) + (p_233.y * 49.077)))
        )), tmpvar_232.x))
      ) + (0.125 * 
        mix (fract((sin(
          ((tmpvar_234.x * 591.32) + 308154.0)
        ) * cos(
          ((tmpvar_234.x * 391.32) + 98154.0)
        ))), fract((sin(
          ((p_236.x * 591.32) + (p_236.y * 154.077))
        ) * cos(
          ((p_236.x * 391.32) + (p_236.y * 49.077))
        ))), tmpvar_235.x)
      )) + (0.0625 * mix (
        fract((sin((
          (tmpvar_237.x * 591.32)
         + 308154.0)) * cos((
          (tmpvar_237.x * 391.32)
         + 98154.0))))
      , 
        fract((sin((
          (p_239.x * 591.32)
         + 
          (p_239.y * 154.077)
        )) * cos((
          (p_239.x * 391.32)
         + 
          (p_239.y * 49.077)
        ))))
      , tmpvar_238.x))) - 0.5)
     * 0.12) * (
      (tmpvar_223 * (tmpvar_223 * (3.0 - (2.0 * tmpvar_223))))
     * 
      pow ((tmpvar_226 * (tmpvar_226 * (3.0 - 
        (2.0 * tmpvar_226)
      ))), 0.2)
    )));
    highp float tmpvar_242;
    tmpvar_242 = clamp ((tmpvar_241.y / 0.0025), 0.0, 1.0);
    highp float tmpvar_243;
    tmpvar_243 = (1.0 - (tmpvar_242 * (tmpvar_242 * 
      (3.0 - (2.0 * tmpvar_242))
    )));
    highp float f_244;
    highp float e_245;
    highp vec3 ret_246;
    highp vec2 tuv_247;
    highp float a_248;
    highp vec3 tcol_249;
    float tmpvar_250;
    tmpvar_250 = clamp (((u_time - 1.5) / 1.35), 0.0, 1.0);
    highp float tmpvar_251;
    highp float tmpvar_252;
    tmpvar_252 = (2.0 * (abs(
      dFdx(tuv_8.x)
    ) + abs(
      dFdy(tuv_8.x)
    )));
    highp float edge0_253;
    edge0_253 = (-(tmpvar_252) / 3.0);
    highp float tmpvar_254;
    tmpvar_254 = clamp (((
      (sqrt(dot (tuv_8, tuv_8)) - (0.32 * (tmpvar_250 * (tmpvar_250 * 
        (3.0 - (2.0 * tmpvar_250))
      ))))
     - edge0_253) / (
      (tmpvar_252 / 3.0)
     - edge0_253)), 0.0, 1.0);
    tmpvar_251 = (tmpvar_254 * (tmpvar_254 * (3.0 - 
      (2.0 * tmpvar_254)
    )));
    tcol_249 = (tmpvar_251 * vec3(0.1019608, 0.07450981, 0.1294118));
    highp float tmpvar_255;
    tmpvar_255 = (2.0 * (abs(
      dFdx(tuv_8.x)
    ) + abs(
      dFdy(tuv_8.x)
    )));
    highp float edge0_256;
    edge0_256 = (-(tmpvar_255) / 2.0);
    highp float tmpvar_257;
    tmpvar_257 = clamp (((
      (abs((sqrt(
        dot (tuv_8, tuv_8)
      ) - 0.3542)) - 0.002100006)
     - edge0_256) / (
      (tmpvar_255 / 2.0)
     - edge0_256)), 0.0, 1.0);
    highp float tmpvar_258;
    tmpvar_258 = (1.0 - (tmpvar_257 * (tmpvar_257 * 
      (3.0 - (2.0 * tmpvar_257))
    )));
    a_248 = tmpvar_258;
    tuv_247 = tuv_8;
    highp float tmpvar_259;
    highp float tmpvar_260;
    tmpvar_260 = (min (abs(
      (tuv_8.x / tuv_8.y)
    ), 1.0) / max (abs(
      (tuv_8.x / tuv_8.y)
    ), 1.0));
    highp float tmpvar_261;
    tmpvar_261 = (tmpvar_260 * tmpvar_260);
    tmpvar_261 = (((
      ((((
        ((((-0.01213232 * tmpvar_261) + 0.05368138) * tmpvar_261) - 0.1173503)
       * tmpvar_261) + 0.1938925) * tmpvar_261) - 0.3326756)
     * tmpvar_261) + 0.9999793) * tmpvar_260);
    tmpvar_261 = (tmpvar_261 + (float(
      (abs((tuv_8.x / tuv_8.y)) > 1.0)
    ) * (
      (tmpvar_261 * -2.0)
     + 1.570796)));
    tmpvar_259 = (tmpvar_261 * sign((tuv_8.x / tuv_8.y)));
    if ((abs(tuv_8.y) > (1e-08 * abs(tuv_8.x)))) {
      if ((tuv_8.y < 0.0)) {
        if ((tuv_8.x >= 0.0)) {
          tmpvar_259 += 3.141593;
        } else {
          tmpvar_259 = (tmpvar_259 - 3.141593);
        };
      };
    } else {
      tmpvar_259 = (sign(tuv_8.x) * 1.570796);
    };
    highp vec2 tmpvar_262;
    tmpvar_262.x = ((tmpvar_259 / 3.14158) * 2.0);
    tmpvar_262.y = (sqrt(dot (tuv_8, tuv_8)) * 0.75);
    float tmpvar_263;
    tmpvar_263 = clamp (((u_time - 5.0) / 2.3), 0.0, 1.0);
    a_248 = (tmpvar_258 * float((
      (-1.57079 + (3.14158 * (tmpvar_263 * (tmpvar_263 * 
        (3.0 - (2.0 * tmpvar_263))
      ))))
     >= tmpvar_262.x)));
    float tmpvar_264;
    tmpvar_264 = clamp (((u_time - 1.5) / 1.35), 0.0, 1.0);
    ret_246 = (max (max (
      max (tcol_249, ((a_248 * (1.0 - tmpvar_243)) * vec3(0.9921569, 0.5490196, 0.4666667)))
    , 
      (tmpvar_243 * vec3(0.1019608, 0.07450981, 0.1294118))
    ), (
      ((1.0 - tmpvar_243) * (1.0 - tmpvar_251))
     * vec3(0.6509804, 0.2117647, 0.172549))) * (tmpvar_264 * (tmpvar_264 * 
      (3.0 - (2.0 * tmpvar_264))
    )));
    float tmpvar_265;
    tmpvar_265 = clamp (((u_time - 2.5) / -2.0), 0.0, 1.0);
    vec2 tmpvar_266;
    tmpvar_266.x = 0.0;
    tmpvar_266.y = (0.225 * (tmpvar_265 * (tmpvar_265 * 
      (3.0 - (2.0 * tmpvar_265))
    )));
    highp vec2 uv_267;
    uv_267 = (tuv_8 + tmpvar_266);
    highp float tmpvar_268;
    tmpvar_268 = (2.0 * (abs(
      dFdx(uv_267.x)
    ) + abs(
      dFdy(uv_267.x)
    )));
    highp float edge0_269;
    edge0_269 = (-(tmpvar_268) / 3.0);
    highp float tmpvar_270;
    tmpvar_270 = clamp (((
      (sqrt(dot (uv_267, uv_267)) - 0.2242)
     - edge0_269) / (
      (tmpvar_268 / 3.0)
     - edge0_269)), 0.0, 1.0);
    highp float tmpvar_271;
    tmpvar_271 = (1.0 - (tmpvar_270 * (tmpvar_270 * 
      (3.0 - (2.0 * tmpvar_270))
    )));
    highp float tmpvar_272;
    tmpvar_272 = clamp (((
      abs(((float(mod (tuv_8.y, 0.015))) - 0.0075))
     - 0.0005) / 0.0026), 0.0, 1.0);
    float tmpvar_273;
    float tmpvar_274;
    tmpvar_274 = clamp (((u_time - 7.0) / 2.0), 0.0, 1.0);
    tmpvar_273 = (tmpvar_274 * (tmpvar_274 * (3.0 - 
      (2.0 * tmpvar_274)
    )));
    float tmpvar_275;
    float tmpvar_276;
    tmpvar_276 = clamp ((u_time - 11.0), 0.0, 1.0);
    tmpvar_275 = (tmpvar_276 * (tmpvar_276 * (3.0 - 
      (2.0 * tmpvar_276)
    )));
    e_245 = ((1.0 - max (
      (tmpvar_272 * (tmpvar_272 * (3.0 - (2.0 * tmpvar_272))))
    , 
      (((float(
        (tuv_8.y >= 0.195)
      ) + (
        float((0.185 >= tuv_8.y))
       * 
        float((tuv_8.y >= 0.165))
      )) + (float(
        (0.14 >= tuv_8.y)
      ) * float(
        (tuv_8.y >= 0.06)
      ))) + (float((0.03 >= tuv_8.y)) * float((tuv_8.y >= 0.015))))
    )) * float((
      (tmpvar_273 - 0.5)
     >= 
      (tuv_8.x + ((1.5 * tuv_8.y) * (1.0 - tmpvar_273)))
    )));
    e_245 = (e_245 * float((
      (tuv_8.x - ((2.0 * tuv_8.y) * (1.0 - tmpvar_275)))
     >= 
      (tmpvar_275 - 0.5)
    )));
    e_245 = ((1.0 - e_245) * tmpvar_271);
    ret_246 = max (ret_246, ((
      (1.0 - tmpvar_243)
     * e_245) * vec3(0.8627451, 0.8784314, 0.8196079)));
    highp float tmpvar_277;
    tmpvar_277 = (2.0 * (abs(
      dFdx(tuv_8.x)
    ) + abs(
      dFdy(tuv_8.x)
    )));
    highp float edge0_278;
    edge0_278 = (-(tmpvar_277) / 3.0);
    highp float tmpvar_279;
    tmpvar_279 = clamp (((
      (sqrt(dot (tuv_8, tuv_8)) - 0.3542)
     - edge0_278) / (
      (tmpvar_277 / 3.0)
     - edge0_278)), 0.0, 1.0);
    highp float tmpvar_280;
    tmpvar_280 = clamp ((tuv_8.y - -0.5), 0.0, 1.0);
    highp float tmpvar_281;
    tmpvar_281 = clamp ((tuv_8.y - -0.5), 0.0, 1.0);
    highp float tmpvar_282;
    tmpvar_282 = clamp (((
      abs((((float(mod (tuv_8.y, 
        (0.026 + (0.1 * (tmpvar_280 * (tmpvar_280 * 
          (3.0 - (2.0 * tmpvar_280))
        ))))
      ))) - 0.013) - (0.05 * (tmpvar_281 * 
        (tmpvar_281 * (3.0 - (2.0 * tmpvar_281)))
      ))))
     - 0.001) / 0.0041), 0.0, 1.0);
    e_245 = ((float(
      (-0.109 >= tuv_8.y)
    ) * (1.0 - 
      (tmpvar_279 * (tmpvar_279 * (3.0 - (2.0 * tmpvar_279))))
    )) * (1.0 - (
      (tmpvar_282 * (tmpvar_282 * (3.0 - (2.0 * tmpvar_282))))
     * 
      float((-0.109 >= tuv_8.y))
    )));
    float tmpvar_283;
    tmpvar_283 = clamp (((u_time - 4.0) / 1.5), 0.0, 1.0);
    e_245 = (e_245 * float((
      (0.5 * (tmpvar_283 * (tmpvar_283 * (3.0 - 
        (2.0 * tmpvar_283)
      ))))
     >= 
      abs(tuv_8.x)
    )));
    ret_246 = max (ret_246, (vec3(0.6509804, 0.2117647, 0.172549) * e_245));
    float tmpvar_284;
    float tmpvar_285;
    tmpvar_285 = (u_time - 6.75);
    tmpvar_284 = clamp ((tmpvar_285 / 1.25), 0.0, 1.0);
    float tmpvar_286;
    tmpvar_286 = clamp ((tmpvar_285 / 1.25), 0.0, 1.0);
    float tmpvar_287;
    tmpvar_287 = clamp ((tmpvar_285 / 1.25), 0.0, 1.0);
    float tmpvar_288;
    tmpvar_288 = clamp ((tmpvar_285 / 1.25), 0.0, 1.0);
    mat2 tmpvar_289;
    tmpvar_289[uint(0)].x = cos((3.3 - sin(
      (1.0 - cos((2.0 * (tmpvar_284 * 
        (tmpvar_284 * (3.0 - (2.0 * tmpvar_284)))
      ))))
    )));
    tmpvar_289[uint(0)].y = -(sin((3.3 - 
      sin((1.0 - cos((2.0 * 
        (tmpvar_286 * (tmpvar_286 * (3.0 - (2.0 * tmpvar_286))))
      ))))
    )));
    tmpvar_289[1u].x = sin((3.3 - sin(
      (1.0 - cos((2.0 * (tmpvar_287 * 
        (tmpvar_287 * (3.0 - (2.0 * tmpvar_287)))
      ))))
    )));
    tmpvar_289[1u].y = cos((3.3 - sin(
      (1.0 - cos((2.0 * (tmpvar_288 * 
        (tmpvar_288 * (3.0 - (2.0 * tmpvar_288)))
      ))))
    )));
    tuv_247 = (tuv_8 * tmpvar_289);
    tuv_247 = (tuv_247 + vec2(0.35521, 0.0));
    highp float tmpvar_290;
    tmpvar_290 = (2.0 * (abs(
      dFdx(tuv_247.x)
    ) + abs(
      dFdy(tuv_247.x)
    )));
    highp float edge0_291;
    edge0_291 = (-(tmpvar_290) / 3.0);
    highp float tmpvar_292;
    tmpvar_292 = clamp (((
      (sqrt(dot (tuv_247, tuv_247)) - 0.027)
     - edge0_291) / (
      (tmpvar_290 / 3.0)
     - edge0_291)), 0.0, 1.0);
    ret_246 = max (ret_246, ((
      (1.0 - (tmpvar_292 * (tmpvar_292 * (3.0 - 
        (2.0 * tmpvar_292)
      ))))
     * vec3(0.9921569, 0.5490196, 0.4666667)) * (1.0 - tmpvar_243)));
    float tmpvar_293;
    float tmpvar_294;
    tmpvar_294 = (u_time - 4.5);
    tmpvar_293 = clamp ((tmpvar_294 / 2.8), 0.0, 1.0);
    float tmpvar_295;
    tmpvar_295 = clamp ((tmpvar_294 / 2.8), 0.0, 1.0);
    float tmpvar_296;
    tmpvar_296 = clamp ((tmpvar_294 / 2.8), 0.0, 1.0);
    float tmpvar_297;
    tmpvar_297 = clamp ((tmpvar_294 / 2.8), 0.0, 1.0);
    mat2 tmpvar_298;
    tmpvar_298[uint(0)].x = cos((-0.3 + (tmpvar_293 * 
      (tmpvar_293 * (3.0 - (2.0 * tmpvar_293)))
    )));
    tmpvar_298[uint(0)].y = -(sin((-0.3 + 
      (tmpvar_295 * (tmpvar_295 * (3.0 - (2.0 * tmpvar_295))))
    )));
    tmpvar_298[1u].x = sin((-0.3 + (tmpvar_296 * 
      (tmpvar_296 * (3.0 - (2.0 * tmpvar_296)))
    )));
    tmpvar_298[1u].y = cos((-0.3 + (tmpvar_297 * 
      (tmpvar_297 * (3.0 - (2.0 * tmpvar_297)))
    )));
    tuv_247 = (tuv_8 * tmpvar_298);
    tuv_247 = (tuv_247 + vec2(0.2242, 0.0));
    highp float tmpvar_299;
    tmpvar_299 = (2.0 * (abs(
      dFdx(tuv_247.x)
    ) + abs(
      dFdy(tuv_247.x)
    )));
    highp float edge0_300;
    edge0_300 = (-(tmpvar_299) / 3.0);
    highp float tmpvar_301;
    tmpvar_301 = clamp (((
      (sqrt(dot (tuv_247, tuv_247)) - 0.057)
     - edge0_300) / (
      (tmpvar_299 / 3.0)
     - edge0_300)), 0.0, 1.0);
    f_244 = (1.0 - (tmpvar_301 * (tmpvar_301 * 
      (3.0 - (2.0 * tmpvar_301))
    )));
    ret_246 = max ((ret_246 * (1.0 - 
      ((1.0 - tmpvar_243) * f_244)
    )), ((
      ((1.0 - tmpvar_243) * f_244)
     * vec3(0.1019608, 0.07450981, 0.1294118)) * (1.0 - tmpvar_243)));
    highp vec3 ret_302;
    highp float d_303;
    d_303 = ((float(
      (tuv_8.y >= -0.14)
    ) * float(
      (-0.127 >= tuv_8.y)
    )) * float((0.02 >= 
      abs((tuv_8.x + 0.19))
    )));
    highp vec2 uv_304;
    uv_304 = (tuv_8 + vec2(0.225, 0.14));
    highp float tmpvar_305;
    tmpvar_305 = (2.0 * (abs(
      dFdx(uv_304.x)
    ) + abs(
      dFdy(uv_304.x)
    )));
    highp float edge0_306;
    edge0_306 = (-(tmpvar_305) / 3.0);
    highp float tmpvar_307;
    tmpvar_307 = clamp (((
      (sqrt(dot (uv_304, uv_304)) - 0.0227)
     - edge0_306) / (
      (tmpvar_305 / 3.0)
     - edge0_306)), 0.0, 1.0);
    d_303 = max (d_303, (float(
      (tuv_8.y >= -0.14)
    ) * (1.0 - 
      (tmpvar_307 * (tmpvar_307 * (3.0 - (2.0 * tmpvar_307))))
    )));
    highp vec2 uv_308;
    uv_308 = (tuv_8 + vec2(0.165, 0.14));
    highp float tmpvar_309;
    tmpvar_309 = (2.0 * (abs(
      dFdx(uv_308.x)
    ) + abs(
      dFdy(uv_308.x)
    )));
    highp float edge0_310;
    edge0_310 = (-(tmpvar_309) / 3.0);
    highp float tmpvar_311;
    tmpvar_311 = clamp (((
      (sqrt(dot (uv_308, uv_308)) - 0.0297)
     - edge0_310) / (
      (tmpvar_309 / 3.0)
     - edge0_310)), 0.0, 1.0);
    highp float tmpvar_312;
    tmpvar_312 = clamp (((
      abs((tuv_8.x + 0.12))
     - 0.0031) / -0.0023), 0.0, 1.0);
    highp float tmpvar_313;
    tmpvar_313 = clamp (((
      abs((tuv_8.x + 0.1075))
     - 0.0031) / -0.0023), 0.0, 1.0);
    ret_302 = (max (max (
      max (d_303, (float((tuv_8.y >= -0.14)) * (1.0 - (tmpvar_311 * 
        (tmpvar_311 * (3.0 - (2.0 * tmpvar_311)))
      ))))
    , 
      ((float((-0.094 >= tuv_8.y)) * float((tuv_8.y >= -0.14))) * (tmpvar_312 * (tmpvar_312 * (3.0 - 
        (2.0 * tmpvar_312)
      ))))
    ), (
      (float((-0.115 >= tuv_8.y)) * float((tuv_8.y >= -0.14)))
     * 
      (tmpvar_313 * (tmpvar_313 * (3.0 - (2.0 * tmpvar_313))))
    )) * vec3(0.6509804, 0.2117647, 0.172549));
    d_303 = float((tuv_8.y >= -0.132));
    highp float tmpvar_314;
    tmpvar_314 = clamp (((
      abs(((float(mod (tuv_8.x, 0.006))) - 0.003))
     - 0.0031) / -0.0026), 0.0, 1.0);
    highp vec2 uv_315;
    uv_315 = (tuv_8 + vec2(0.225, 0.143));
    highp float tmpvar_316;
    tmpvar_316 = (2.0 * (abs(
      dFdx(uv_315.x)
    ) + abs(
      dFdy(uv_315.x)
    )));
    highp float edge0_317;
    edge0_317 = (-(tmpvar_316) / 3.0);
    highp float tmpvar_318;
    tmpvar_318 = clamp (((
      (sqrt(dot (uv_315, uv_315)) - 0.02197)
     - edge0_317) / (
      (tmpvar_316 / 3.0)
     - edge0_317)), 0.0, 1.0);
    d_303 = (((
      float((0.015 >= abs((tuv_8.x + 0.225))))
     * d_303) * (tmpvar_314 * 
      (tmpvar_314 * (3.0 - (2.0 * tmpvar_314)))
    )) * (1.0 - (tmpvar_318 * 
      (tmpvar_318 * (3.0 - (2.0 * tmpvar_318)))
    )));
    highp vec3 tmpvar_319;
    tmpvar_319 = mix (ret_302, vec3(1.240196, 0.6862745, 0.5833333), d_303);
    highp float tmpvar_320;
    tmpvar_320 = clamp (((
      abs(((float(mod ((tuv_8.x - 0.093), 0.012))) - 0.006))
     - 0.0061) / -0.0026), 0.0, 1.0);
    d_303 = ((tmpvar_320 * (tmpvar_320 * 
      (3.0 - (2.0 * tmpvar_320))
    )) * float((0.00182 >= 
      abs((tuv_8.y + 0.122))
    )));
    highp vec3 tmpvar_321;
    tmpvar_321 = mix (tmpvar_319, vec3(0.8627451, 0.8784314, 0.8196079), (d_303 * float(
      (0.0165 >= abs((tuv_8.x + 0.165)))
    )));
    ret_302 = tmpvar_321;
    float tmpvar_322;
    tmpvar_322 = clamp ((u_time - 4.7), 0.0, 1.0);
    highp vec3 tmpvar_323;
    tmpvar_323 = max (ret_246, (tmpvar_321 * (tmpvar_322 * 
      (tmpvar_322 * (3.0 - (2.0 * tmpvar_322)))
    )));
    ret_246 = tmpvar_323;
    float tmpvar_324;
    float tmpvar_325;
    tmpvar_325 = (u_time - 14.0);
    tmpvar_324 = clamp ((tmpvar_325 / -2.0), 0.0, 1.0);
    f_244 = (f_244 * (tmpvar_324 * (tmpvar_324 * 
      (3.0 - (2.0 * tmpvar_324))
    )));
    float tmpvar_326;
    tmpvar_326 = clamp ((tmpvar_325 / -2.0), 0.0, 1.0);
    float tmpvar_327;
    tmpvar_327 = clamp ((tmpvar_325 / -2.0), 0.0, 1.0);
    float tmpvar_328;
    tmpvar_328 = clamp ((tmpvar_325 / -2.0), 0.0, 1.0);
    highp vec3 tmpvar_329;
    tmpvar_329 = max (vec3(0.1019608, 0.07450981, 0.1294118), max ((tmpvar_323 * 
      (tmpvar_326 * (tmpvar_326 * (3.0 - (2.0 * tmpvar_326))))
    ), max (
      ((((1.0 - f_244) * tmpvar_271) * vec3(0.8627451, 0.8784314, 0.8196079)) * (1.0 - (tmpvar_327 * (tmpvar_327 * 
        (3.0 - (2.0 * tmpvar_327))
      ))))
    , 
      max ((((
        ((1.0 - f_244) * tmpvar_271)
       * vec3(0.8627451, 0.8784314, 0.8196079)) * (1.0 - tmpvar_243)) * float((u_time >= 12.0))), (((
        ((1.0 - f_244) * tmpvar_271)
       * vec3(0.8627451, 0.8784314, 0.8196079)) * tmpvar_243) * (1.0 - (tmpvar_328 * 
        (tmpvar_328 * (3.0 - (2.0 * tmpvar_328)))
      ))))
    )));
    lowp vec4 tmpvar_330;
    tmpvar_330.w = 1.0;
    tmpvar_330.xyz = tmpvar_329;
    fragColor_1 = tmpvar_330;
  } else {
    if ((u_time <= 25.0)) {
      highp float ce_331;
      highp float tmpvar_332;
      highp float tmpvar_333;
      tmpvar_333 = (2.0 * (abs(
        dFdx(tuv_8.x)
      ) + abs(
        dFdy(tuv_8.x)
      )));
      highp float edge0_334;
      edge0_334 = (-(tmpvar_333) / 3.0);
      highp float tmpvar_335;
      tmpvar_335 = clamp (((
        (sqrt(dot (tuv_8, tuv_8)) - 0.2242)
       - edge0_334) / (
        (tmpvar_333 / 3.0)
       - edge0_334)), 0.0, 1.0);
      tmpvar_332 = (tmpvar_335 * (tmpvar_335 * (3.0 - 
        (2.0 * tmpvar_335)
      )));
      float tmpvar_336;
      tmpvar_336 = clamp (((u_time - 23.0) / 2.0), 0.0, 1.0);
      highp float tmpvar_337;
      tmpvar_337 = clamp (((
        ((sqrt(dot (tuv_8, tuv_8)) - (2.0 * (tmpvar_336 * 
          (tmpvar_336 * (3.0 - (2.0 * tmpvar_336)))
        ))) + 0.5)
       - 0.5) / 0.012), 0.0, 1.0);
      ce_331 = (1.0 - (tmpvar_337 * (tmpvar_337 * 
        (3.0 - (2.0 * tmpvar_337))
      )));
      fragColor_1.xyz = (fragColor_1.xyz * ce_331);
      fragColor_1.xyz = max (fragColor_1.xyz, ((
        (1.0 - obj_6)
       * 
        mix (vec3(0.1019608, 0.07450981, 0.1294118), vec3(0.8627451, 0.8784314, 0.8196079), (1.0 - tmpvar_332))
      ) + obj_col_5));
    };
  };
  fragColor_1.w = 1.0;
  glFragColor = fragColor_1;
}

