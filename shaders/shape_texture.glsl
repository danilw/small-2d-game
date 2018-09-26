#version 300 es
precision highp float;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rtime;
uniform highp int shape_type;
uniform float ppower;
uniform float ajcd;
uniform float ajcd2;
uniform highp int shape_tile;
uniform vec2 shape_size;
uniform vec2 shape_pos;
uniform float shape_rotate_an;
uniform float shape_rotate_Urot;
out highp vec4 glFragColor;
highp vec3 green;
highp vec3 green_l;
highp vec3 ground1;
highp vec3 ground2;
highp vec3 ground3;
highp vec3 colx;
void main ()
{
  green = vec3(0.4980392, 0.7450981, 0.1254902);
  green_l = vec3(0.572549, 0.8588235, 0.1490196);
  ground1 = vec3(0.8078431, 0.5960785, 0.4117647);
  ground2 = vec3(0.7921569, 0.5607843, 0.3568628);
  ground3 = vec3(0.7568628, 0.4980392, 0.254902);
  colx = vec3(0.2, 0.725, 1.08);
  highp vec4 fragColor_1;
  highp int shape_tile_l_2;
  float zv_3;
  highp vec2 uv_4;
  vec2 tmpvar_5;
  tmpvar_5 = (u_resolution / u_resolution.y);
  highp vec2 tmpvar_6;
  tmpvar_6 = ((gl_FragCoord.xy / u_resolution.y) - (tmpvar_5 / 2.0));
  uv_4 = (tmpvar_6 + ((shape_pos / u_resolution.y) - (tmpvar_5 / 2.0)));
  uv_4 = (uv_4 * (u_resolution.y / shape_size.y));
  zv_3 = (((1080.0 / u_resolution.y) + (50.0 / shape_size.y)) + 2.0);
  shape_tile_l_2 = shape_tile;
  if ((shape_tile > 100)) {
    shape_tile_l_2 = (shape_tile - 100);
    highp float tmpvar_7;
    tmpvar_7 = ((tmpvar_6.x + u_time) + tmpvar_6.y);
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.x = ((sin(
      (3.0 * tmpvar_7)
    ) * 0.5) + 0.5);
    tmpvar_8.y = ((sin(
      ((3.0 * tmpvar_7) + 2.0)
    ) * 0.5) + 0.5);
    tmpvar_8.z = ((sin(
      ((3.0 * tmpvar_7) + 4.0)
    ) * 0.5) + 0.5);
    highp vec3 tmpvar_9;
    tmpvar_9 = tmpvar_8.xyz;
    green_l = tmpvar_9;
    green = tmpvar_9;
    ground1 = (vec3(0.8078431, 0.5960785, 0.4117647) * tmpvar_8.xyz);
    ground2 = (vec3(0.7921569, 0.5607843, 0.3568628) * tmpvar_8.xyz);
    ground3 = (vec3(0.7568628, 0.4980392, 0.254902) * tmpvar_8.xyz);
  } else {
    if ((shape_tile_l_2 > 10)) {
      shape_tile_l_2 = (shape_tile_l_2 - 10);
      green_l = vec3(0.9137255, 0.8745098, 0.7647059);
      green = vec3(0.9137255, 0.8745098, 0.7647059);
    };
  };
  if ((u_rtime <= 15.0)) {
    fragColor_1 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  if (((u_rtime <= 23.0) && (shape_tile_l_2 != 10))) {
    fragColor_1 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  bool tmpvar_10;
  tmpvar_10 = bool(0);
  bool tmpvar_11;
  tmpvar_11 = bool(0);
  if(0 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    mat2 tmpvar_12;
    float tmpvar_13;
    tmpvar_13 = -(shape_rotate_an);
    tmpvar_12[uint(0)].x = cos(tmpvar_13);
    tmpvar_12[uint(0)].y = -(sin(tmpvar_13));
    tmpvar_12[1u].x = sin(tmpvar_13);
    tmpvar_12[1u].y = cos(tmpvar_13);
    uv_4 = (uv_4 * tmpvar_12);
    float zv_14;
    zv_14 = zv_3;
    highp vec3 col_15;
    highp float tmpvar_16;
    if ((shape_type == 1)) {
      highp vec2 tmpvar_17;
      tmpvar_17 = (abs(uv_4) - vec2(0.5, 0.5));
      highp vec2 tmpvar_18;
      tmpvar_18 = max (tmpvar_17, vec2(0.0, 0.0));
      tmpvar_16 = ((sqrt(
        dot (tmpvar_18, tmpvar_18)
      ) + min (
        max (tmpvar_17.x, tmpvar_17.y)
      , 0.0)) + 0.5);
    } else {
      if ((shape_type == 2)) {
        tmpvar_16 = ((sqrt(
          dot (uv_4, uv_4)
        ) - 0.5) + 0.5);
      } else {
        if ((shape_type == 0)) {
          highp vec2 p_19;
          p_19 = (uv_4 * 2.0);
          p_19.x = (abs(p_19.x) - 1.0);
          p_19.y = (p_19.y + 0.5773503);
          if ((p_19.x > -((1.732051 * p_19.y)))) {
            highp vec2 tmpvar_20;
            tmpvar_20.x = (p_19.x - (1.732051 * p_19.y));
            tmpvar_20.y = ((-1.732051 * p_19.x) - p_19.y);
            p_19 = (tmpvar_20 / 2.0);
          };
          p_19.x = (p_19.x - clamp (p_19.x, -2.0, 0.0));
          tmpvar_16 = ((-(
            sqrt(dot (p_19, p_19))
          ) * sign(p_19.y)) + 0.5);
        };
      };
    };
    if ((shape_type == 0)) {
      zv_14 = (zv_3 + 4.0);
    };
    col_15 = ((vec3(1.0, 1.0, 1.0) - (
      sign((tmpvar_16 - 0.5))
     * vec3(0.1, 0.4, 0.7))) * (1.0 - exp(
      (-2.0 * abs((tmpvar_16 - 0.5)))
    )));
    col_15 = (col_15 * (0.8 + (0.2 * 
      cos(((u_time * 2.0) + (max (
        (120.0 - (10.0 * zv_14))
      , 1.0) * (tmpvar_16 - 0.5))))
    )));
    highp float tmpvar_21;
    tmpvar_21 = clamp ((abs(
      (tmpvar_16 - 0.5)
    ) / (0.025 + 
      (0.015 * zv_14)
    )), 0.0, 1.0);
    highp vec3 tmpvar_22;
    tmpvar_22 = mix (col_15, vec3(1.0, 1.0, 1.0), (1.0 - (tmpvar_21 * 
      (tmpvar_21 * (3.0 - (2.0 * tmpvar_21)))
    )));
    col_15 = tmpvar_22;
    highp float tmpvar_23;
    highp float tmpvar_24;
    tmpvar_24 = clamp (((tmpvar_16 - 0.6) / -0.13), 0.0, 1.0);
    tmpvar_23 = (tmpvar_24 * (tmpvar_24 * (3.0 - 
      (2.0 * tmpvar_24)
    )));
    highp vec4 tmpvar_25;
    tmpvar_25.xyz = (tmpvar_22 * tmpvar_23);
    tmpvar_25.w = tmpvar_23;
    fragColor_1 = tmpvar_25;
    tmpvar_11 = bool(1);
  };
  if(1 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec2 p_26;
    p_26.x = uv_4.x;
    highp float d_27;
    p_26.y = (uv_4.y * 1.1);
    p_26.y = (p_26.y + 0.3333333);
    if ((p_26.y > 0.1666667)) {
      p_26.y = (p_26.y + 0.1666667);
    };
    bool tmpvar_28;
    tmpvar_28 = ((float(mod ((p_26.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_28) {
      p_26.x = (uv_4.x + 0.1666667);
    };
    p_26.x = (abs(p_26.x) - 0.3333333);
    p_26.y = (float(mod ((p_26.y + 0.03333334), 0.3333333)));
    if (tmpvar_28) {
      p_26.y = (0.3333333 - abs(p_26.y));
    };
    p_26 = (p_26 * 3.0);
    highp vec2 p_29;
    p_29 = (p_26 + vec2(1.0, 0.0));
    highp float tmpvar_30;
    if ((p_29.y < 0.0)) {
      tmpvar_30 = 1.0;
    } else {
      highp vec2 tmpvar_31;
      tmpvar_31 = abs(p_29);
      highp float tmpvar_32;
      tmpvar_32 = clamp (((-2.0 * 
        ((tmpvar_31.x * 0.5) - (tmpvar_31.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_33;
      tmpvar_33.x = (1.0 - tmpvar_32);
      tmpvar_33.y = (1.0 + tmpvar_32);
      highp vec2 x_34;
      x_34 = (tmpvar_31 - (vec2(0.25, 0.25) * tmpvar_33));
      tmpvar_30 = ((sqrt(
        dot (x_34, x_34)
      ) * sign(
        (((tmpvar_31.x * 0.5) + (tmpvar_31.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_27 = tmpvar_30;
    highp float tmpvar_35;
    if ((p_26.y < 0.0)) {
      tmpvar_35 = 1.0;
    } else {
      highp vec2 tmpvar_36;
      tmpvar_36 = abs(p_26);
      highp float tmpvar_37;
      tmpvar_37 = clamp (((-2.0 * 
        ((tmpvar_36.x * 0.5) - (tmpvar_36.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_38;
      tmpvar_38.x = (1.0 - tmpvar_37);
      tmpvar_38.y = (1.0 + tmpvar_37);
      highp vec2 x_39;
      x_39 = (tmpvar_36 - (vec2(0.25, 0.25) * tmpvar_38));
      tmpvar_35 = ((sqrt(
        dot (x_39, x_39)
      ) * sign(
        (((tmpvar_36.x * 0.5) + (tmpvar_36.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_27 = min (tmpvar_30, tmpvar_35);
    highp vec2 p_40;
    p_40 = (p_26 - vec2(1.0, 0.0));
    highp float tmpvar_41;
    if ((p_40.y < 0.0)) {
      tmpvar_41 = 1.0;
    } else {
      highp vec2 tmpvar_42;
      tmpvar_42 = abs(p_40);
      highp float tmpvar_43;
      tmpvar_43 = clamp (((-2.0 * 
        ((tmpvar_42.x * 0.5) - (tmpvar_42.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_44;
      tmpvar_44.x = (1.0 - tmpvar_43);
      tmpvar_44.y = (1.0 + tmpvar_43);
      highp vec2 x_45;
      x_45 = (tmpvar_42 - (vec2(0.25, 0.25) * tmpvar_44));
      tmpvar_41 = ((sqrt(
        dot (x_45, x_45)
      ) * sign(
        (((tmpvar_42.x * 0.5) + (tmpvar_42.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_46;
    tmpvar_46 = min (d_27, tmpvar_41);
    d_27 = tmpvar_46;
    highp float tmpvar_47;
    tmpvar_47 = clamp (((tmpvar_46 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_48;
    tmpvar_48.w = 1.0;
    tmpvar_48.xyz = mix (ground1, ground2, (1.0 - (tmpvar_47 * 
      (tmpvar_47 * (3.0 - (2.0 * tmpvar_47)))
    )));
    fragColor_1 = (tmpvar_48 * tmpvar_48);
    tmpvar_11 = bool(1);
  };
  if(2 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp float d_49;
    highp vec4 fragColor_50;
    highp vec2 p_51;
    p_51.x = uv_4.x;
    highp float d_52;
    p_51.y = (uv_4.y * 1.1);
    p_51.y = (p_51.y + 0.3333333);
    if ((p_51.y > 0.1666667)) {
      p_51.y = (p_51.y + 0.1666667);
    };
    bool tmpvar_53;
    tmpvar_53 = ((float(mod ((p_51.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_53) {
      p_51.x = (uv_4.x + 0.1666667);
    };
    p_51.x = (abs(p_51.x) - 0.3333333);
    p_51.y = (float(mod ((p_51.y + 0.03333334), 0.3333333)));
    if (tmpvar_53) {
      p_51.y = (0.3333333 - abs(p_51.y));
    };
    p_51 = (p_51 * 3.0);
    highp vec2 p_54;
    p_54 = (p_51 + vec2(1.0, 0.0));
    highp float tmpvar_55;
    if ((p_54.y < 0.0)) {
      tmpvar_55 = 1.0;
    } else {
      highp vec2 tmpvar_56;
      tmpvar_56 = abs(p_54);
      highp float tmpvar_57;
      tmpvar_57 = clamp (((-2.0 * 
        ((tmpvar_56.x * 0.5) - (tmpvar_56.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_58;
      tmpvar_58.x = (1.0 - tmpvar_57);
      tmpvar_58.y = (1.0 + tmpvar_57);
      highp vec2 x_59;
      x_59 = (tmpvar_56 - (vec2(0.25, 0.25) * tmpvar_58));
      tmpvar_55 = ((sqrt(
        dot (x_59, x_59)
      ) * sign(
        (((tmpvar_56.x * 0.5) + (tmpvar_56.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_52 = tmpvar_55;
    highp float tmpvar_60;
    if ((p_51.y < 0.0)) {
      tmpvar_60 = 1.0;
    } else {
      highp vec2 tmpvar_61;
      tmpvar_61 = abs(p_51);
      highp float tmpvar_62;
      tmpvar_62 = clamp (((-2.0 * 
        ((tmpvar_61.x * 0.5) - (tmpvar_61.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_63;
      tmpvar_63.x = (1.0 - tmpvar_62);
      tmpvar_63.y = (1.0 + tmpvar_62);
      highp vec2 x_64;
      x_64 = (tmpvar_61 - (vec2(0.25, 0.25) * tmpvar_63));
      tmpvar_60 = ((sqrt(
        dot (x_64, x_64)
      ) * sign(
        (((tmpvar_61.x * 0.5) + (tmpvar_61.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_52 = min (tmpvar_55, tmpvar_60);
    highp vec2 p_65;
    p_65 = (p_51 - vec2(1.0, 0.0));
    highp float tmpvar_66;
    if ((p_65.y < 0.0)) {
      tmpvar_66 = 1.0;
    } else {
      highp vec2 tmpvar_67;
      tmpvar_67 = abs(p_65);
      highp float tmpvar_68;
      tmpvar_68 = clamp (((-2.0 * 
        ((tmpvar_67.x * 0.5) - (tmpvar_67.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_69;
      tmpvar_69.x = (1.0 - tmpvar_68);
      tmpvar_69.y = (1.0 + tmpvar_68);
      highp vec2 x_70;
      x_70 = (tmpvar_67 - (vec2(0.25, 0.25) * tmpvar_69));
      tmpvar_66 = ((sqrt(
        dot (x_70, x_70)
      ) * sign(
        (((tmpvar_67.x * 0.5) + (tmpvar_67.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_71;
    tmpvar_71 = min (d_52, tmpvar_66);
    d_52 = tmpvar_71;
    highp float tmpvar_72;
    tmpvar_72 = clamp (((tmpvar_71 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    d_49 = (1.0 - (tmpvar_72 * (tmpvar_72 * 
      (3.0 - (2.0 * tmpvar_72))
    )));
    highp vec2 p_73;
    p_73.x = uv_4.x;
    highp float tmpvar_74;
    highp float d_75;
    p_73.y = (uv_4.y * 1.1);
    p_73.y = (p_73.y + -0.3333333);
    if ((p_73.y > 0.0952381)) {
      tmpvar_74 = 1.0;
    } else {
      if ((p_73.y < -0.0952381)) {
        tmpvar_74 = 0.0;
      } else {
        p_73.y = (p_73.y + -0.1388889);
        p_73.x = (uv_4.x + 0.1666667);
        p_73.x = (abs(p_73.x) - 0.3333333);
        p_73.y = (float(mod ((p_73.y + 0.03333334), 0.3333333)));
        p_73.y = (0.3333333 - abs(p_73.y));
        p_73 = (p_73 * 3.0);
        highp vec2 p_76;
        p_76 = (p_73 + vec2(1.0, 0.0));
        highp float tmpvar_77;
        if ((p_76.y < 0.0)) {
          tmpvar_77 = 1.0;
        } else {
          highp vec2 tmpvar_78;
          tmpvar_78 = abs(p_76);
          highp float tmpvar_79;
          tmpvar_79 = clamp (((-2.0 * 
            ((tmpvar_78.x * 0.5) - (tmpvar_78.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_80;
          tmpvar_80.x = (1.0 - tmpvar_79);
          tmpvar_80.y = (1.0 + tmpvar_79);
          highp vec2 x_81;
          x_81 = (tmpvar_78 - (vec2(0.25, 0.25) * tmpvar_80));
          tmpvar_77 = ((sqrt(
            dot (x_81, x_81)
          ) * sign(
            (((tmpvar_78.x * 0.5) + (tmpvar_78.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_75 = tmpvar_77;
        highp float tmpvar_82;
        if ((p_73.y < 0.0)) {
          tmpvar_82 = 1.0;
        } else {
          highp vec2 tmpvar_83;
          tmpvar_83 = abs(p_73);
          highp float tmpvar_84;
          tmpvar_84 = clamp (((-2.0 * 
            ((tmpvar_83.x * 0.5) - (tmpvar_83.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_85;
          tmpvar_85.x = (1.0 - tmpvar_84);
          tmpvar_85.y = (1.0 + tmpvar_84);
          highp vec2 x_86;
          x_86 = (tmpvar_83 - (vec2(0.25, 0.25) * tmpvar_85));
          tmpvar_82 = ((sqrt(
            dot (x_86, x_86)
          ) * sign(
            (((tmpvar_83.x * 0.5) + (tmpvar_83.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_75 = min (tmpvar_77, tmpvar_82);
        highp vec2 p_87;
        p_87 = (p_73 - vec2(1.0, 0.0));
        highp float tmpvar_88;
        if ((p_87.y < 0.0)) {
          tmpvar_88 = 1.0;
        } else {
          highp vec2 tmpvar_89;
          tmpvar_89 = abs(p_87);
          highp float tmpvar_90;
          tmpvar_90 = clamp (((-2.0 * 
            ((tmpvar_89.x * 0.5) - (tmpvar_89.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_91;
          tmpvar_91.x = (1.0 - tmpvar_90);
          tmpvar_91.y = (1.0 + tmpvar_90);
          highp vec2 x_92;
          x_92 = (tmpvar_89 - (vec2(0.25, 0.25) * tmpvar_91));
          tmpvar_88 = ((sqrt(
            dot (x_92, x_92)
          ) * sign(
            (((tmpvar_89.x * 0.5) + (tmpvar_89.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_93;
        tmpvar_93 = min (d_75, tmpvar_88);
        d_75 = tmpvar_93;
        highp float tmpvar_94;
        tmpvar_94 = clamp (((tmpvar_93 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_74 = (1.0 - (tmpvar_94 * (tmpvar_94 * 
          (3.0 - (2.0 * tmpvar_94))
        )));
      };
    };
    highp vec2 p_95;
    p_95.x = uv_4.x;
    p_95.y = (uv_4.y + -0.47);
    highp float tmpvar_96;
    tmpvar_96 = clamp ((p_95.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_97;
    tmpvar_97.w = 1.0;
    tmpvar_97.xyz = mix (mix (mix (
      mix (ground1, ground2, d_49)
    , ground3, 
      max (0.0, (float((uv_4.y >= 0.1111111)) * (1.0 - (tmpvar_74 + d_49))))
    ), green, tmpvar_74), green_l, (tmpvar_96 * (tmpvar_96 * 
      (3.0 - (2.0 * tmpvar_96))
    )));
    highp float tmpvar_98;
    tmpvar_98 = clamp (((uv_4.y - 0.55) / (
      (0.52 - (0.01 * zv_3))
     - 0.55)), 0.0, 1.0);
    fragColor_50 = (tmpvar_97 * (tmpvar_98 * (tmpvar_98 * 
      (3.0 - (2.0 * tmpvar_98))
    )));
    fragColor_1 = (fragColor_50 * fragColor_50);
    tmpvar_11 = bool(1);
  };
  if(3 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec4 fragColor_99;
    highp float d_100;
    highp vec2 p_101;
    p_101.x = uv_4.x;
    highp float d_102;
    p_101.y = (uv_4.y * 1.1);
    p_101.y = (p_101.y + 0.3333333);
    if ((p_101.y > 0.1666667)) {
      p_101.y = (p_101.y + 0.1666667);
    };
    bool tmpvar_103;
    tmpvar_103 = ((float(mod ((p_101.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_103) {
      p_101.x = (uv_4.x + 0.1666667);
    };
    p_101.x = (abs(p_101.x) - 0.3333333);
    p_101.y = (float(mod ((p_101.y + 0.03333334), 0.3333333)));
    if (tmpvar_103) {
      p_101.y = (0.3333333 - abs(p_101.y));
    };
    p_101 = (p_101 * 3.0);
    highp vec2 p_104;
    p_104 = (p_101 + vec2(1.0, 0.0));
    highp float tmpvar_105;
    if ((p_104.y < 0.0)) {
      tmpvar_105 = 1.0;
    } else {
      highp vec2 tmpvar_106;
      tmpvar_106 = abs(p_104);
      highp float tmpvar_107;
      tmpvar_107 = clamp (((-2.0 * 
        ((tmpvar_106.x * 0.5) - (tmpvar_106.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_108;
      tmpvar_108.x = (1.0 - tmpvar_107);
      tmpvar_108.y = (1.0 + tmpvar_107);
      highp vec2 x_109;
      x_109 = (tmpvar_106 - (vec2(0.25, 0.25) * tmpvar_108));
      tmpvar_105 = ((sqrt(
        dot (x_109, x_109)
      ) * sign(
        (((tmpvar_106.x * 0.5) + (tmpvar_106.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_102 = tmpvar_105;
    highp float tmpvar_110;
    if ((p_101.y < 0.0)) {
      tmpvar_110 = 1.0;
    } else {
      highp vec2 tmpvar_111;
      tmpvar_111 = abs(p_101);
      highp float tmpvar_112;
      tmpvar_112 = clamp (((-2.0 * 
        ((tmpvar_111.x * 0.5) - (tmpvar_111.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_113;
      tmpvar_113.x = (1.0 - tmpvar_112);
      tmpvar_113.y = (1.0 + tmpvar_112);
      highp vec2 x_114;
      x_114 = (tmpvar_111 - (vec2(0.25, 0.25) * tmpvar_113));
      tmpvar_110 = ((sqrt(
        dot (x_114, x_114)
      ) * sign(
        (((tmpvar_111.x * 0.5) + (tmpvar_111.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_102 = min (tmpvar_105, tmpvar_110);
    highp vec2 p_115;
    p_115 = (p_101 - vec2(1.0, 0.0));
    highp float tmpvar_116;
    if ((p_115.y < 0.0)) {
      tmpvar_116 = 1.0;
    } else {
      highp vec2 tmpvar_117;
      tmpvar_117 = abs(p_115);
      highp float tmpvar_118;
      tmpvar_118 = clamp (((-2.0 * 
        ((tmpvar_117.x * 0.5) - (tmpvar_117.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_119;
      tmpvar_119.x = (1.0 - tmpvar_118);
      tmpvar_119.y = (1.0 + tmpvar_118);
      highp vec2 x_120;
      x_120 = (tmpvar_117 - (vec2(0.25, 0.25) * tmpvar_119));
      tmpvar_116 = ((sqrt(
        dot (x_120, x_120)
      ) * sign(
        (((tmpvar_117.x * 0.5) + (tmpvar_117.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_121;
    tmpvar_121 = min (d_102, tmpvar_116);
    d_102 = tmpvar_121;
    highp float tmpvar_122;
    tmpvar_122 = clamp (((tmpvar_121 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    d_100 = (1.0 - (tmpvar_122 * (tmpvar_122 * 
      (3.0 - (2.0 * tmpvar_122))
    )));
    highp vec2 p_123;
    p_123.x = uv_4.x;
    highp float tmpvar_124;
    highp float d_125;
    p_123.y = (uv_4.y * 1.1);
    p_123.y = (p_123.y + -0.3333333);
    if ((p_123.y > 0.0952381)) {
      tmpvar_124 = 1.0;
    } else {
      if ((p_123.y < -0.0952381)) {
        tmpvar_124 = 0.0;
      } else {
        p_123.y = (p_123.y + -0.1388889);
        p_123.x = (uv_4.x + 0.1666667);
        p_123.x = (abs(p_123.x) - 0.3333333);
        p_123.y = (float(mod ((p_123.y + 0.03333334), 0.3333333)));
        p_123.y = (0.3333333 - abs(p_123.y));
        p_123 = (p_123 * 3.0);
        highp vec2 p_126;
        p_126 = (p_123 + vec2(1.0, 0.0));
        highp float tmpvar_127;
        if ((p_126.y < 0.0)) {
          tmpvar_127 = 1.0;
        } else {
          highp vec2 tmpvar_128;
          tmpvar_128 = abs(p_126);
          highp float tmpvar_129;
          tmpvar_129 = clamp (((-2.0 * 
            ((tmpvar_128.x * 0.5) - (tmpvar_128.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_130;
          tmpvar_130.x = (1.0 - tmpvar_129);
          tmpvar_130.y = (1.0 + tmpvar_129);
          highp vec2 x_131;
          x_131 = (tmpvar_128 - (vec2(0.25, 0.25) * tmpvar_130));
          tmpvar_127 = ((sqrt(
            dot (x_131, x_131)
          ) * sign(
            (((tmpvar_128.x * 0.5) + (tmpvar_128.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_125 = tmpvar_127;
        highp float tmpvar_132;
        if ((p_123.y < 0.0)) {
          tmpvar_132 = 1.0;
        } else {
          highp vec2 tmpvar_133;
          tmpvar_133 = abs(p_123);
          highp float tmpvar_134;
          tmpvar_134 = clamp (((-2.0 * 
            ((tmpvar_133.x * 0.5) - (tmpvar_133.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_135;
          tmpvar_135.x = (1.0 - tmpvar_134);
          tmpvar_135.y = (1.0 + tmpvar_134);
          highp vec2 x_136;
          x_136 = (tmpvar_133 - (vec2(0.25, 0.25) * tmpvar_135));
          tmpvar_132 = ((sqrt(
            dot (x_136, x_136)
          ) * sign(
            (((tmpvar_133.x * 0.5) + (tmpvar_133.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_125 = min (tmpvar_127, tmpvar_132);
        highp vec2 p_137;
        p_137 = (p_123 - vec2(1.0, 0.0));
        highp float tmpvar_138;
        if ((p_137.y < 0.0)) {
          tmpvar_138 = 1.0;
        } else {
          highp vec2 tmpvar_139;
          tmpvar_139 = abs(p_137);
          highp float tmpvar_140;
          tmpvar_140 = clamp (((-2.0 * 
            ((tmpvar_139.x * 0.5) - (tmpvar_139.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_141;
          tmpvar_141.x = (1.0 - tmpvar_140);
          tmpvar_141.y = (1.0 + tmpvar_140);
          highp vec2 x_142;
          x_142 = (tmpvar_139 - (vec2(0.25, 0.25) * tmpvar_141));
          tmpvar_138 = ((sqrt(
            dot (x_142, x_142)
          ) * sign(
            (((tmpvar_139.x * 0.5) + (tmpvar_139.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_143;
        tmpvar_143 = min (d_125, tmpvar_138);
        d_125 = tmpvar_143;
        highp float tmpvar_144;
        tmpvar_144 = clamp (((tmpvar_143 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_124 = (1.0 - (tmpvar_144 * (tmpvar_144 * 
          (3.0 - (2.0 * tmpvar_144))
        )));
      };
    };
    highp vec2 tmpvar_145;
    tmpvar_145.x = uv_4.y;
    tmpvar_145.y = ((uv_4.x * 0.77777) + 0.05);
    highp vec2 p_146;
    p_146.x = tmpvar_145.x;
    highp float tmpvar_147;
    highp float d_148;
    p_146.y = (tmpvar_145.y * 1.1);
    p_146.y = (p_146.y + -0.3333333);
    if ((p_146.y > 0.0952381)) {
      tmpvar_147 = 1.0;
    } else {
      if ((p_146.y < -0.0952381)) {
        tmpvar_147 = 0.0;
      } else {
        p_146.y = (p_146.y + -0.1388889);
        p_146.x = (uv_4.y + 0.1666667);
        p_146.x = (abs(p_146.x) - 0.3333333);
        p_146.y = (float(mod ((p_146.y + 0.03333334), 0.3333333)));
        p_146.y = (0.3333333 - abs(p_146.y));
        p_146 = (p_146 * 3.0);
        highp vec2 p_149;
        p_149 = (p_146 + vec2(1.0, 0.0));
        highp float tmpvar_150;
        if ((p_149.y < 0.0)) {
          tmpvar_150 = 1.0;
        } else {
          highp vec2 tmpvar_151;
          tmpvar_151 = abs(p_149);
          highp float tmpvar_152;
          tmpvar_152 = clamp (((-2.0 * 
            ((tmpvar_151.x * 0.5) - (tmpvar_151.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_153;
          tmpvar_153.x = (1.0 - tmpvar_152);
          tmpvar_153.y = (1.0 + tmpvar_152);
          highp vec2 x_154;
          x_154 = (tmpvar_151 - (vec2(0.25, 0.25) * tmpvar_153));
          tmpvar_150 = ((sqrt(
            dot (x_154, x_154)
          ) * sign(
            (((tmpvar_151.x * 0.5) + (tmpvar_151.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_148 = tmpvar_150;
        highp float tmpvar_155;
        if ((p_146.y < 0.0)) {
          tmpvar_155 = 1.0;
        } else {
          highp vec2 tmpvar_156;
          tmpvar_156 = abs(p_146);
          highp float tmpvar_157;
          tmpvar_157 = clamp (((-2.0 * 
            ((tmpvar_156.x * 0.5) - (tmpvar_156.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_158;
          tmpvar_158.x = (1.0 - tmpvar_157);
          tmpvar_158.y = (1.0 + tmpvar_157);
          highp vec2 x_159;
          x_159 = (tmpvar_156 - (vec2(0.25, 0.25) * tmpvar_158));
          tmpvar_155 = ((sqrt(
            dot (x_159, x_159)
          ) * sign(
            (((tmpvar_156.x * 0.5) + (tmpvar_156.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_148 = min (tmpvar_150, tmpvar_155);
        highp vec2 p_160;
        p_160 = (p_146 - vec2(1.0, 0.0));
        highp float tmpvar_161;
        if ((p_160.y < 0.0)) {
          tmpvar_161 = 1.0;
        } else {
          highp vec2 tmpvar_162;
          tmpvar_162 = abs(p_160);
          highp float tmpvar_163;
          tmpvar_163 = clamp (((-2.0 * 
            ((tmpvar_162.x * 0.5) - (tmpvar_162.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_164;
          tmpvar_164.x = (1.0 - tmpvar_163);
          tmpvar_164.y = (1.0 + tmpvar_163);
          highp vec2 x_165;
          x_165 = (tmpvar_162 - (vec2(0.25, 0.25) * tmpvar_164));
          tmpvar_161 = ((sqrt(
            dot (x_165, x_165)
          ) * sign(
            (((tmpvar_162.x * 0.5) + (tmpvar_162.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_166;
        tmpvar_166 = min (d_148, tmpvar_161);
        d_148 = tmpvar_166;
        highp float tmpvar_167;
        tmpvar_167 = clamp (((tmpvar_166 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_147 = (1.0 - (tmpvar_167 * (tmpvar_167 * 
          (3.0 - (2.0 * tmpvar_167))
        )));
      };
    };
    highp vec2 p_168;
    p_168 = (uv_4 + (-0.2879 + (0.0005 * zv_3)));
    p_168.y = (p_168.y * 1.105);
    p_168 = (p_168 * 3.0);
    highp vec2 tmpvar_169;
    tmpvar_169 = abs(p_168);
    highp float tmpvar_170;
    tmpvar_170 = clamp (((-2.0 * 
      ((tmpvar_169.x * 0.5) - (tmpvar_169.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_171;
    tmpvar_171.x = (1.0 - tmpvar_170);
    tmpvar_171.y = (1.0 + tmpvar_170);
    highp vec2 x_172;
    x_172 = (tmpvar_169 - (vec2(0.25, 0.25) * tmpvar_171));
    highp float tmpvar_173;
    tmpvar_173 = clamp (((
      ((sqrt(dot (x_172, x_172)) * sign((
        ((tmpvar_169.x * 0.5) + (tmpvar_169.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp float tmpvar_174;
    tmpvar_174 = max ((1.0 - (tmpvar_173 * 
      (tmpvar_173 * (3.0 - (2.0 * tmpvar_173)))
    )), max (tmpvar_124, tmpvar_147));
    highp vec2 p_175;
    p_175.x = uv_4.x;
    p_175.y = (uv_4.y + -0.47);
    highp float tmpvar_176;
    tmpvar_176 = clamp ((p_175.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec2 p_177;
    p_177.x = (uv_4.x + (-0.375 - (0.005 * zv_3)));
    p_177.y = (uv_4.y + -0.178);
    p_177.y = (p_177.y * 1.1);
    p_177 = (p_177 * 2.0);
    highp vec2 tmpvar_178;
    tmpvar_178 = abs(p_177);
    highp float tmpvar_179;
    tmpvar_179 = clamp (((-2.0 * 
      ((tmpvar_178.x * 0.5) - (tmpvar_178.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_180;
    tmpvar_180.x = (1.0 - tmpvar_179);
    tmpvar_180.y = (1.0 + tmpvar_179);
    highp vec2 x_181;
    x_181 = (tmpvar_178 - (vec2(0.25, 0.25) * tmpvar_180));
    highp float tmpvar_182;
    tmpvar_182 = clamp (((
      ((sqrt(dot (x_181, x_181)) * sign((
        ((tmpvar_178.x * 0.5) + (tmpvar_178.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_183;
    p_183 = (uv_4 + vec2(-0.1, 0.39));
    p_183.x = (p_183.x + (-0.375 - (0.005 * zv_3)));
    p_183.y = (p_183.y + -0.178);
    p_183.y = (p_183.y * 1.1);
    p_183 = (p_183 * 2.0);
    highp vec2 tmpvar_184;
    tmpvar_184 = abs(p_183);
    highp float tmpvar_185;
    tmpvar_185 = clamp (((-2.0 * 
      ((tmpvar_184.x * 0.5) - (tmpvar_184.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_186;
    tmpvar_186.x = (1.0 - tmpvar_185);
    tmpvar_186.y = (1.0 + tmpvar_185);
    highp vec2 x_187;
    x_187 = (tmpvar_184 - (vec2(0.25, 0.25) * tmpvar_186));
    highp float tmpvar_188;
    tmpvar_188 = clamp (((
      ((sqrt(dot (x_187, x_187)) * sign((
        ((tmpvar_184.x * 0.5) + (tmpvar_184.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp float tmpvar_189;
    tmpvar_189 = clamp (((
      (uv_4.x - 0.24)
     * 2.0) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec2 tmpvar_190;
    tmpvar_190.x = uv_4.y;
    tmpvar_190.y = (uv_4.x - 0.01);
    highp vec2 p_191;
    p_191.x = tmpvar_190.x;
    p_191.y = (tmpvar_190.y + -0.47);
    highp float tmpvar_192;
    tmpvar_192 = clamp ((p_191.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_193;
    tmpvar_193.w = 1.0;
    tmpvar_193.xyz = mix (mix (mix (
      mix (mix (ground1, ground2, d_100), ground3, max (0.0, (float(
        (uv_4.y >= 0.1111111)
      ) * (1.0 - 
        (tmpvar_174 + d_100)
      ))))
    , green, tmpvar_174), green_l, max (
      (tmpvar_176 * (tmpvar_176 * (3.0 - (2.0 * tmpvar_176))))
    , 
      (tmpvar_192 * (tmpvar_192 * (3.0 - (2.0 * tmpvar_192))))
    )), ground3, (max (
      (1.0 - (tmpvar_182 * (tmpvar_182 * (3.0 - 
        (2.0 * tmpvar_182)
      ))))
    , 
      ((1.0 - (tmpvar_188 * (tmpvar_188 * 
        (3.0 - (2.0 * tmpvar_188))
      ))) * (tmpvar_189 * (tmpvar_189 * (3.0 - 
        (2.0 * tmpvar_189)
      ))))
    ) * (1.0 - tmpvar_174)));
    highp float tmpvar_194;
    tmpvar_194 = clamp (((uv_4.y - 0.55) / (
      (0.52 - (0.01 * zv_3))
     - 0.55)), 0.0, 1.0);
    fragColor_99 = (tmpvar_193 * (tmpvar_194 * (tmpvar_194 * 
      (3.0 - (2.0 * tmpvar_194))
    )));
    fragColor_1 = (fragColor_99 * fragColor_99);
    tmpvar_11 = bool(1);
  };
  if(4 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec2 tmpvar_195;
    tmpvar_195.x = -(uv_4.x);
    tmpvar_195.y = uv_4.y;
    highp vec4 fragColor_196;
    highp float d_197;
    highp vec2 p_198;
    p_198.x = tmpvar_195.x;
    highp float d_199;
    p_198.y = (uv_4.y * 1.1);
    p_198.y = (p_198.y + 0.3333333);
    if ((p_198.y > 0.1666667)) {
      p_198.y = (p_198.y + 0.1666667);
    };
    bool tmpvar_200;
    tmpvar_200 = ((float(mod ((p_198.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_200) {
      p_198.x = (tmpvar_195.x + 0.1666667);
    };
    p_198.x = (abs(p_198.x) - 0.3333333);
    p_198.y = (float(mod ((p_198.y + 0.03333334), 0.3333333)));
    if (tmpvar_200) {
      p_198.y = (0.3333333 - abs(p_198.y));
    };
    p_198 = (p_198 * 3.0);
    highp vec2 p_201;
    p_201 = (p_198 + vec2(1.0, 0.0));
    highp float tmpvar_202;
    if ((p_201.y < 0.0)) {
      tmpvar_202 = 1.0;
    } else {
      highp vec2 tmpvar_203;
      tmpvar_203 = abs(p_201);
      highp float tmpvar_204;
      tmpvar_204 = clamp (((-2.0 * 
        ((tmpvar_203.x * 0.5) - (tmpvar_203.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_205;
      tmpvar_205.x = (1.0 - tmpvar_204);
      tmpvar_205.y = (1.0 + tmpvar_204);
      highp vec2 x_206;
      x_206 = (tmpvar_203 - (vec2(0.25, 0.25) * tmpvar_205));
      tmpvar_202 = ((sqrt(
        dot (x_206, x_206)
      ) * sign(
        (((tmpvar_203.x * 0.5) + (tmpvar_203.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_199 = tmpvar_202;
    highp float tmpvar_207;
    if ((p_198.y < 0.0)) {
      tmpvar_207 = 1.0;
    } else {
      highp vec2 tmpvar_208;
      tmpvar_208 = abs(p_198);
      highp float tmpvar_209;
      tmpvar_209 = clamp (((-2.0 * 
        ((tmpvar_208.x * 0.5) - (tmpvar_208.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_210;
      tmpvar_210.x = (1.0 - tmpvar_209);
      tmpvar_210.y = (1.0 + tmpvar_209);
      highp vec2 x_211;
      x_211 = (tmpvar_208 - (vec2(0.25, 0.25) * tmpvar_210));
      tmpvar_207 = ((sqrt(
        dot (x_211, x_211)
      ) * sign(
        (((tmpvar_208.x * 0.5) + (tmpvar_208.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_199 = min (tmpvar_202, tmpvar_207);
    highp vec2 p_212;
    p_212 = (p_198 - vec2(1.0, 0.0));
    highp float tmpvar_213;
    if ((p_212.y < 0.0)) {
      tmpvar_213 = 1.0;
    } else {
      highp vec2 tmpvar_214;
      tmpvar_214 = abs(p_212);
      highp float tmpvar_215;
      tmpvar_215 = clamp (((-2.0 * 
        ((tmpvar_214.x * 0.5) - (tmpvar_214.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_216;
      tmpvar_216.x = (1.0 - tmpvar_215);
      tmpvar_216.y = (1.0 + tmpvar_215);
      highp vec2 x_217;
      x_217 = (tmpvar_214 - (vec2(0.25, 0.25) * tmpvar_216));
      tmpvar_213 = ((sqrt(
        dot (x_217, x_217)
      ) * sign(
        (((tmpvar_214.x * 0.5) + (tmpvar_214.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_218;
    tmpvar_218 = min (d_199, tmpvar_213);
    d_199 = tmpvar_218;
    highp float tmpvar_219;
    tmpvar_219 = clamp (((tmpvar_218 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    d_197 = (1.0 - (tmpvar_219 * (tmpvar_219 * 
      (3.0 - (2.0 * tmpvar_219))
    )));
    highp vec2 p_220;
    p_220.x = tmpvar_195.x;
    highp float tmpvar_221;
    highp float d_222;
    p_220.y = (uv_4.y * 1.1);
    p_220.y = (p_220.y + -0.3333333);
    if ((p_220.y > 0.0952381)) {
      tmpvar_221 = 1.0;
    } else {
      if ((p_220.y < -0.0952381)) {
        tmpvar_221 = 0.0;
      } else {
        p_220.y = (p_220.y + -0.1388889);
        p_220.x = (tmpvar_195.x + 0.1666667);
        p_220.x = (abs(p_220.x) - 0.3333333);
        p_220.y = (float(mod ((p_220.y + 0.03333334), 0.3333333)));
        p_220.y = (0.3333333 - abs(p_220.y));
        p_220 = (p_220 * 3.0);
        highp vec2 p_223;
        p_223 = (p_220 + vec2(1.0, 0.0));
        highp float tmpvar_224;
        if ((p_223.y < 0.0)) {
          tmpvar_224 = 1.0;
        } else {
          highp vec2 tmpvar_225;
          tmpvar_225 = abs(p_223);
          highp float tmpvar_226;
          tmpvar_226 = clamp (((-2.0 * 
            ((tmpvar_225.x * 0.5) - (tmpvar_225.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_227;
          tmpvar_227.x = (1.0 - tmpvar_226);
          tmpvar_227.y = (1.0 + tmpvar_226);
          highp vec2 x_228;
          x_228 = (tmpvar_225 - (vec2(0.25, 0.25) * tmpvar_227));
          tmpvar_224 = ((sqrt(
            dot (x_228, x_228)
          ) * sign(
            (((tmpvar_225.x * 0.5) + (tmpvar_225.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_222 = tmpvar_224;
        highp float tmpvar_229;
        if ((p_220.y < 0.0)) {
          tmpvar_229 = 1.0;
        } else {
          highp vec2 tmpvar_230;
          tmpvar_230 = abs(p_220);
          highp float tmpvar_231;
          tmpvar_231 = clamp (((-2.0 * 
            ((tmpvar_230.x * 0.5) - (tmpvar_230.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_232;
          tmpvar_232.x = (1.0 - tmpvar_231);
          tmpvar_232.y = (1.0 + tmpvar_231);
          highp vec2 x_233;
          x_233 = (tmpvar_230 - (vec2(0.25, 0.25) * tmpvar_232));
          tmpvar_229 = ((sqrt(
            dot (x_233, x_233)
          ) * sign(
            (((tmpvar_230.x * 0.5) + (tmpvar_230.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_222 = min (tmpvar_224, tmpvar_229);
        highp vec2 p_234;
        p_234 = (p_220 - vec2(1.0, 0.0));
        highp float tmpvar_235;
        if ((p_234.y < 0.0)) {
          tmpvar_235 = 1.0;
        } else {
          highp vec2 tmpvar_236;
          tmpvar_236 = abs(p_234);
          highp float tmpvar_237;
          tmpvar_237 = clamp (((-2.0 * 
            ((tmpvar_236.x * 0.5) - (tmpvar_236.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_238;
          tmpvar_238.x = (1.0 - tmpvar_237);
          tmpvar_238.y = (1.0 + tmpvar_237);
          highp vec2 x_239;
          x_239 = (tmpvar_236 - (vec2(0.25, 0.25) * tmpvar_238));
          tmpvar_235 = ((sqrt(
            dot (x_239, x_239)
          ) * sign(
            (((tmpvar_236.x * 0.5) + (tmpvar_236.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_240;
        tmpvar_240 = min (d_222, tmpvar_235);
        d_222 = tmpvar_240;
        highp float tmpvar_241;
        tmpvar_241 = clamp (((tmpvar_240 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_221 = (1.0 - (tmpvar_241 * (tmpvar_241 * 
          (3.0 - (2.0 * tmpvar_241))
        )));
      };
    };
    highp vec2 tmpvar_242;
    tmpvar_242.x = tmpvar_195.y;
    tmpvar_242.y = ((tmpvar_195.x * 0.77777) + 0.05);
    highp vec2 p_243;
    p_243.x = tmpvar_242.x;
    highp float tmpvar_244;
    highp float d_245;
    p_243.y = (tmpvar_242.y * 1.1);
    p_243.y = (p_243.y + -0.3333333);
    if ((p_243.y > 0.0952381)) {
      tmpvar_244 = 1.0;
    } else {
      if ((p_243.y < -0.0952381)) {
        tmpvar_244 = 0.0;
      } else {
        p_243.y = (p_243.y + -0.1388889);
        p_243.x = (uv_4.y + 0.1666667);
        p_243.x = (abs(p_243.x) - 0.3333333);
        p_243.y = (float(mod ((p_243.y + 0.03333334), 0.3333333)));
        p_243.y = (0.3333333 - abs(p_243.y));
        p_243 = (p_243 * 3.0);
        highp vec2 p_246;
        p_246 = (p_243 + vec2(1.0, 0.0));
        highp float tmpvar_247;
        if ((p_246.y < 0.0)) {
          tmpvar_247 = 1.0;
        } else {
          highp vec2 tmpvar_248;
          tmpvar_248 = abs(p_246);
          highp float tmpvar_249;
          tmpvar_249 = clamp (((-2.0 * 
            ((tmpvar_248.x * 0.5) - (tmpvar_248.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_250;
          tmpvar_250.x = (1.0 - tmpvar_249);
          tmpvar_250.y = (1.0 + tmpvar_249);
          highp vec2 x_251;
          x_251 = (tmpvar_248 - (vec2(0.25, 0.25) * tmpvar_250));
          tmpvar_247 = ((sqrt(
            dot (x_251, x_251)
          ) * sign(
            (((tmpvar_248.x * 0.5) + (tmpvar_248.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_245 = tmpvar_247;
        highp float tmpvar_252;
        if ((p_243.y < 0.0)) {
          tmpvar_252 = 1.0;
        } else {
          highp vec2 tmpvar_253;
          tmpvar_253 = abs(p_243);
          highp float tmpvar_254;
          tmpvar_254 = clamp (((-2.0 * 
            ((tmpvar_253.x * 0.5) - (tmpvar_253.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_255;
          tmpvar_255.x = (1.0 - tmpvar_254);
          tmpvar_255.y = (1.0 + tmpvar_254);
          highp vec2 x_256;
          x_256 = (tmpvar_253 - (vec2(0.25, 0.25) * tmpvar_255));
          tmpvar_252 = ((sqrt(
            dot (x_256, x_256)
          ) * sign(
            (((tmpvar_253.x * 0.5) + (tmpvar_253.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_245 = min (tmpvar_247, tmpvar_252);
        highp vec2 p_257;
        p_257 = (p_243 - vec2(1.0, 0.0));
        highp float tmpvar_258;
        if ((p_257.y < 0.0)) {
          tmpvar_258 = 1.0;
        } else {
          highp vec2 tmpvar_259;
          tmpvar_259 = abs(p_257);
          highp float tmpvar_260;
          tmpvar_260 = clamp (((-2.0 * 
            ((tmpvar_259.x * 0.5) - (tmpvar_259.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_261;
          tmpvar_261.x = (1.0 - tmpvar_260);
          tmpvar_261.y = (1.0 + tmpvar_260);
          highp vec2 x_262;
          x_262 = (tmpvar_259 - (vec2(0.25, 0.25) * tmpvar_261));
          tmpvar_258 = ((sqrt(
            dot (x_262, x_262)
          ) * sign(
            (((tmpvar_259.x * 0.5) + (tmpvar_259.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_263;
        tmpvar_263 = min (d_245, tmpvar_258);
        d_245 = tmpvar_263;
        highp float tmpvar_264;
        tmpvar_264 = clamp (((tmpvar_263 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_244 = (1.0 - (tmpvar_264 * (tmpvar_264 * 
          (3.0 - (2.0 * tmpvar_264))
        )));
      };
    };
    highp vec2 p_265;
    p_265 = (tmpvar_195 + (-0.2879 + (0.0005 * zv_3)));
    p_265.y = (p_265.y * 1.105);
    p_265 = (p_265 * 3.0);
    highp vec2 tmpvar_266;
    tmpvar_266 = abs(p_265);
    highp float tmpvar_267;
    tmpvar_267 = clamp (((-2.0 * 
      ((tmpvar_266.x * 0.5) - (tmpvar_266.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_268;
    tmpvar_268.x = (1.0 - tmpvar_267);
    tmpvar_268.y = (1.0 + tmpvar_267);
    highp vec2 x_269;
    x_269 = (tmpvar_266 - (vec2(0.25, 0.25) * tmpvar_268));
    highp float tmpvar_270;
    tmpvar_270 = clamp (((
      ((sqrt(dot (x_269, x_269)) * sign((
        ((tmpvar_266.x * 0.5) + (tmpvar_266.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp float tmpvar_271;
    tmpvar_271 = max ((1.0 - (tmpvar_270 * 
      (tmpvar_270 * (3.0 - (2.0 * tmpvar_270)))
    )), max (tmpvar_221, tmpvar_244));
    highp vec2 p_272;
    p_272.x = tmpvar_195.x;
    p_272.y = (uv_4.y + -0.47);
    highp float tmpvar_273;
    tmpvar_273 = clamp ((p_272.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec2 p_274;
    p_274.x = (tmpvar_195.x + (-0.375 - (0.005 * zv_3)));
    p_274.y = (uv_4.y + -0.178);
    p_274.y = (p_274.y * 1.1);
    p_274 = (p_274 * 2.0);
    highp vec2 tmpvar_275;
    tmpvar_275 = abs(p_274);
    highp float tmpvar_276;
    tmpvar_276 = clamp (((-2.0 * 
      ((tmpvar_275.x * 0.5) - (tmpvar_275.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_277;
    tmpvar_277.x = (1.0 - tmpvar_276);
    tmpvar_277.y = (1.0 + tmpvar_276);
    highp vec2 x_278;
    x_278 = (tmpvar_275 - (vec2(0.25, 0.25) * tmpvar_277));
    highp float tmpvar_279;
    tmpvar_279 = clamp (((
      ((sqrt(dot (x_278, x_278)) * sign((
        ((tmpvar_275.x * 0.5) + (tmpvar_275.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_280;
    p_280 = (tmpvar_195 + vec2(-0.1, 0.39));
    p_280.x = (p_280.x + (-0.375 - (0.005 * zv_3)));
    p_280.y = (p_280.y + -0.178);
    p_280.y = (p_280.y * 1.1);
    p_280 = (p_280 * 2.0);
    highp vec2 tmpvar_281;
    tmpvar_281 = abs(p_280);
    highp float tmpvar_282;
    tmpvar_282 = clamp (((-2.0 * 
      ((tmpvar_281.x * 0.5) - (tmpvar_281.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_283;
    tmpvar_283.x = (1.0 - tmpvar_282);
    tmpvar_283.y = (1.0 + tmpvar_282);
    highp vec2 x_284;
    x_284 = (tmpvar_281 - (vec2(0.25, 0.25) * tmpvar_283));
    highp float tmpvar_285;
    tmpvar_285 = clamp (((
      ((sqrt(dot (x_284, x_284)) * sign((
        ((tmpvar_281.x * 0.5) + (tmpvar_281.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp float tmpvar_286;
    tmpvar_286 = clamp (((
      (tmpvar_195.x - 0.24)
     * 2.0) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec2 tmpvar_287;
    tmpvar_287.x = tmpvar_195.y;
    tmpvar_287.y = (tmpvar_195.x - 0.01);
    highp vec2 p_288;
    p_288.x = tmpvar_287.x;
    p_288.y = (tmpvar_287.y + -0.47);
    highp float tmpvar_289;
    tmpvar_289 = clamp ((p_288.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_290;
    tmpvar_290.w = 1.0;
    tmpvar_290.xyz = mix (mix (mix (
      mix (mix (ground1, ground2, d_197), ground3, max (0.0, (float(
        (uv_4.y >= 0.1111111)
      ) * (1.0 - 
        (tmpvar_271 + d_197)
      ))))
    , green, tmpvar_271), green_l, max (
      (tmpvar_273 * (tmpvar_273 * (3.0 - (2.0 * tmpvar_273))))
    , 
      (tmpvar_289 * (tmpvar_289 * (3.0 - (2.0 * tmpvar_289))))
    )), ground3, (max (
      (1.0 - (tmpvar_279 * (tmpvar_279 * (3.0 - 
        (2.0 * tmpvar_279)
      ))))
    , 
      ((1.0 - (tmpvar_285 * (tmpvar_285 * 
        (3.0 - (2.0 * tmpvar_285))
      ))) * (tmpvar_286 * (tmpvar_286 * (3.0 - 
        (2.0 * tmpvar_286)
      ))))
    ) * (1.0 - tmpvar_271)));
    highp float tmpvar_291;
    tmpvar_291 = clamp (((uv_4.y - 0.55) / (
      (0.52 - (0.01 * zv_3))
     - 0.55)), 0.0, 1.0);
    fragColor_196 = (tmpvar_290 * (tmpvar_291 * (tmpvar_291 * 
      (3.0 - (2.0 * tmpvar_291))
    )));
    fragColor_1 = (fragColor_196 * fragColor_196);
    tmpvar_11 = bool(1);
  };
  if(5 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec4 fragColor_292;
    highp float tmpvar_293;
    highp vec2 p_294;
    p_294.x = uv_4.x;
    highp float d_295;
    p_294.y = (uv_4.y * 1.1);
    p_294.y = (p_294.y + 0.3333333);
    if ((p_294.y > 0.1666667)) {
      p_294.y = (p_294.y + 0.1666667);
    };
    bool tmpvar_296;
    tmpvar_296 = ((float(mod ((p_294.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_296) {
      p_294.x = (uv_4.x + 0.1666667);
    };
    p_294.x = (abs(p_294.x) - 0.3333333);
    p_294.y = (float(mod ((p_294.y + 0.03333334), 0.3333333)));
    if (tmpvar_296) {
      p_294.y = (0.3333333 - abs(p_294.y));
    };
    p_294 = (p_294 * 3.0);
    highp vec2 p_297;
    p_297 = (p_294 + vec2(1.0, 0.0));
    highp float tmpvar_298;
    if ((p_297.y < 0.0)) {
      tmpvar_298 = 1.0;
    } else {
      highp vec2 tmpvar_299;
      tmpvar_299 = abs(p_297);
      highp float tmpvar_300;
      tmpvar_300 = clamp (((-2.0 * 
        ((tmpvar_299.x * 0.5) - (tmpvar_299.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_301;
      tmpvar_301.x = (1.0 - tmpvar_300);
      tmpvar_301.y = (1.0 + tmpvar_300);
      highp vec2 x_302;
      x_302 = (tmpvar_299 - (vec2(0.25, 0.25) * tmpvar_301));
      tmpvar_298 = ((sqrt(
        dot (x_302, x_302)
      ) * sign(
        (((tmpvar_299.x * 0.5) + (tmpvar_299.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_295 = tmpvar_298;
    highp float tmpvar_303;
    if ((p_294.y < 0.0)) {
      tmpvar_303 = 1.0;
    } else {
      highp vec2 tmpvar_304;
      tmpvar_304 = abs(p_294);
      highp float tmpvar_305;
      tmpvar_305 = clamp (((-2.0 * 
        ((tmpvar_304.x * 0.5) - (tmpvar_304.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_306;
      tmpvar_306.x = (1.0 - tmpvar_305);
      tmpvar_306.y = (1.0 + tmpvar_305);
      highp vec2 x_307;
      x_307 = (tmpvar_304 - (vec2(0.25, 0.25) * tmpvar_306));
      tmpvar_303 = ((sqrt(
        dot (x_307, x_307)
      ) * sign(
        (((tmpvar_304.x * 0.5) + (tmpvar_304.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_295 = min (tmpvar_298, tmpvar_303);
    highp vec2 p_308;
    p_308 = (p_294 - vec2(1.0, 0.0));
    highp float tmpvar_309;
    if ((p_308.y < 0.0)) {
      tmpvar_309 = 1.0;
    } else {
      highp vec2 tmpvar_310;
      tmpvar_310 = abs(p_308);
      highp float tmpvar_311;
      tmpvar_311 = clamp (((-2.0 * 
        ((tmpvar_310.x * 0.5) - (tmpvar_310.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_312;
      tmpvar_312.x = (1.0 - tmpvar_311);
      tmpvar_312.y = (1.0 + tmpvar_311);
      highp vec2 x_313;
      x_313 = (tmpvar_310 - (vec2(0.25, 0.25) * tmpvar_312));
      tmpvar_309 = ((sqrt(
        dot (x_313, x_313)
      ) * sign(
        (((tmpvar_310.x * 0.5) + (tmpvar_310.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_314;
    tmpvar_314 = min (d_295, tmpvar_309);
    d_295 = tmpvar_314;
    highp float tmpvar_315;
    tmpvar_315 = clamp (((tmpvar_314 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    tmpvar_293 = (1.0 - (tmpvar_315 * (tmpvar_315 * 
      (3.0 - (2.0 * tmpvar_315))
    )));
    highp vec2 p_316;
    highp vec2 op_317;
    p_316.x = (uv_4.x + 0.035);
    p_316.y = (uv_4.y + 0.03);
    p_316.y = (p_316.y * 1.1);
    p_316.y = (p_316.y + -0.3333333);
    p_316.y = (p_316.y + -0.1388889);
    op_317 = p_316;
    p_316.y = (float(mod ((p_316.y + 0.03333334), 0.3333333)));
    p_316.y = (0.3333333 - abs(p_316.y));
    p_316 = (p_316 * 3.0);
    highp vec2 tmpvar_318;
    tmpvar_318 = abs(((op_317 * 3.0) + vec2(1.0, -0.4)));
    highp float tmpvar_319;
    tmpvar_319 = clamp (((-2.0 * 
      ((tmpvar_318.x * 0.5) - (tmpvar_318.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_320;
    tmpvar_320.x = (1.0 - tmpvar_319);
    tmpvar_320.y = (1.0 + tmpvar_319);
    highp vec2 x_321;
    x_321 = (tmpvar_318 - (vec2(0.25, 0.25) * tmpvar_320));
    highp vec2 tmpvar_322;
    tmpvar_322 = abs(((op_317 * 3.0) + vec2(1.5, 0.1)));
    highp float tmpvar_323;
    tmpvar_323 = clamp (((-2.0 * 
      ((tmpvar_322.x * 0.5) - (tmpvar_322.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_324;
    tmpvar_324.x = (1.0 - tmpvar_323);
    tmpvar_324.y = (1.0 + tmpvar_323);
    highp vec2 x_325;
    x_325 = (tmpvar_322 - (vec2(0.25, 0.25) * tmpvar_324));
    highp float tmpvar_326;
    tmpvar_326 = clamp (((
      min (min (1.0, ((
        sqrt(dot (x_321, x_321))
       * 
        sign((((tmpvar_318.x * 0.5) + (tmpvar_318.y * 0.5)) - 0.25))
      ) + 0.5)), ((sqrt(
        dot (x_325, x_325)
      ) * sign(
        (((tmpvar_322.x * 0.5) + (tmpvar_322.y * 0.5)) - 0.25)
      )) + 0.5))
     - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    float edge0_327;
    edge0_327 = (-0.235 + (0.001 * zv_3));
    highp float tmpvar_328;
    tmpvar_328 = clamp (((uv_4.x - edge0_327) / (
      (-0.235 - (0.001 * zv_3))
     - edge0_327)), 0.0, 1.0);
    highp float tmpvar_329;
    tmpvar_329 = ((1.0 - (tmpvar_326 * 
      (tmpvar_326 * (3.0 - (2.0 * tmpvar_326)))
    )) * (tmpvar_328 * (tmpvar_328 * 
      (3.0 - (2.0 * tmpvar_328))
    )));
    float edge0_330;
    edge0_330 = (-0.24 + (0.005 * zv_3));
    highp float tmpvar_331;
    tmpvar_331 = clamp (((uv_4.x - edge0_330) / (
      (-0.24 - (0.005 * zv_3))
     - edge0_330)), 0.0, 1.0);
    float edge0_332;
    edge0_332 = (0.64 - (0.005 * zv_3));
    highp float tmpvar_333;
    tmpvar_333 = clamp (((
      (-(uv_4.x) + (uv_4.y * 1.1))
     - edge0_332) / (
      (0.64 + (0.005 * zv_3))
     - edge0_332)), 0.0, 1.0);
    highp vec4 tmpvar_334;
    tmpvar_334.w = 1.0;
    tmpvar_334.xyz = mix (mix (mix (ground1, ground2, tmpvar_293), ground3, max (0.0, 
      (((tmpvar_331 * (tmpvar_331 * 
        (3.0 - (2.0 * tmpvar_331))
      )) * (tmpvar_333 * (tmpvar_333 * 
        (3.0 - (2.0 * tmpvar_333))
      ))) * (1.0 - (tmpvar_329 + tmpvar_293)))
    )), green, tmpvar_329);
    highp float tmpvar_335;
    tmpvar_335 = clamp (((uv_4.y - 0.55) / (
      (0.52 - (0.01 * zv_3))
     - 0.55)), 0.0, 1.0);
    fragColor_292 = (tmpvar_334 * (tmpvar_335 * (tmpvar_335 * 
      (3.0 - (2.0 * tmpvar_335))
    )));
    fragColor_1 = (fragColor_292 * fragColor_292);
    tmpvar_11 = bool(1);
  };
  if(6 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec2 tmpvar_336;
    tmpvar_336.x = -(uv_4.x);
    tmpvar_336.y = uv_4.y;
    highp vec4 fragColor_337;
    highp float tmpvar_338;
    highp vec2 p_339;
    p_339.x = tmpvar_336.x;
    highp float d_340;
    p_339.y = (uv_4.y * 1.1);
    p_339.y = (p_339.y + 0.3333333);
    if ((p_339.y > 0.1666667)) {
      p_339.y = (p_339.y + 0.1666667);
    };
    bool tmpvar_341;
    tmpvar_341 = ((float(mod ((p_339.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_341) {
      p_339.x = (tmpvar_336.x + 0.1666667);
    };
    p_339.x = (abs(p_339.x) - 0.3333333);
    p_339.y = (float(mod ((p_339.y + 0.03333334), 0.3333333)));
    if (tmpvar_341) {
      p_339.y = (0.3333333 - abs(p_339.y));
    };
    p_339 = (p_339 * 3.0);
    highp vec2 p_342;
    p_342 = (p_339 + vec2(1.0, 0.0));
    highp float tmpvar_343;
    if ((p_342.y < 0.0)) {
      tmpvar_343 = 1.0;
    } else {
      highp vec2 tmpvar_344;
      tmpvar_344 = abs(p_342);
      highp float tmpvar_345;
      tmpvar_345 = clamp (((-2.0 * 
        ((tmpvar_344.x * 0.5) - (tmpvar_344.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_346;
      tmpvar_346.x = (1.0 - tmpvar_345);
      tmpvar_346.y = (1.0 + tmpvar_345);
      highp vec2 x_347;
      x_347 = (tmpvar_344 - (vec2(0.25, 0.25) * tmpvar_346));
      tmpvar_343 = ((sqrt(
        dot (x_347, x_347)
      ) * sign(
        (((tmpvar_344.x * 0.5) + (tmpvar_344.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_340 = tmpvar_343;
    highp float tmpvar_348;
    if ((p_339.y < 0.0)) {
      tmpvar_348 = 1.0;
    } else {
      highp vec2 tmpvar_349;
      tmpvar_349 = abs(p_339);
      highp float tmpvar_350;
      tmpvar_350 = clamp (((-2.0 * 
        ((tmpvar_349.x * 0.5) - (tmpvar_349.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_351;
      tmpvar_351.x = (1.0 - tmpvar_350);
      tmpvar_351.y = (1.0 + tmpvar_350);
      highp vec2 x_352;
      x_352 = (tmpvar_349 - (vec2(0.25, 0.25) * tmpvar_351));
      tmpvar_348 = ((sqrt(
        dot (x_352, x_352)
      ) * sign(
        (((tmpvar_349.x * 0.5) + (tmpvar_349.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_340 = min (tmpvar_343, tmpvar_348);
    highp vec2 p_353;
    p_353 = (p_339 - vec2(1.0, 0.0));
    highp float tmpvar_354;
    if ((p_353.y < 0.0)) {
      tmpvar_354 = 1.0;
    } else {
      highp vec2 tmpvar_355;
      tmpvar_355 = abs(p_353);
      highp float tmpvar_356;
      tmpvar_356 = clamp (((-2.0 * 
        ((tmpvar_355.x * 0.5) - (tmpvar_355.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_357;
      tmpvar_357.x = (1.0 - tmpvar_356);
      tmpvar_357.y = (1.0 + tmpvar_356);
      highp vec2 x_358;
      x_358 = (tmpvar_355 - (vec2(0.25, 0.25) * tmpvar_357));
      tmpvar_354 = ((sqrt(
        dot (x_358, x_358)
      ) * sign(
        (((tmpvar_355.x * 0.5) + (tmpvar_355.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_359;
    tmpvar_359 = min (d_340, tmpvar_354);
    d_340 = tmpvar_359;
    highp float tmpvar_360;
    tmpvar_360 = clamp (((tmpvar_359 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    tmpvar_338 = (1.0 - (tmpvar_360 * (tmpvar_360 * 
      (3.0 - (2.0 * tmpvar_360))
    )));
    highp vec2 p_361;
    highp vec2 op_362;
    p_361.x = (tmpvar_336.x + 0.035);
    p_361.y = (uv_4.y + 0.03);
    p_361.y = (p_361.y * 1.1);
    p_361.y = (p_361.y + -0.3333333);
    p_361.y = (p_361.y + -0.1388889);
    op_362 = p_361;
    p_361.y = (float(mod ((p_361.y + 0.03333334), 0.3333333)));
    p_361.y = (0.3333333 - abs(p_361.y));
    p_361 = (p_361 * 3.0);
    highp vec2 tmpvar_363;
    tmpvar_363 = abs(((op_362 * 3.0) + vec2(1.0, -0.4)));
    highp float tmpvar_364;
    tmpvar_364 = clamp (((-2.0 * 
      ((tmpvar_363.x * 0.5) - (tmpvar_363.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_365;
    tmpvar_365.x = (1.0 - tmpvar_364);
    tmpvar_365.y = (1.0 + tmpvar_364);
    highp vec2 x_366;
    x_366 = (tmpvar_363 - (vec2(0.25, 0.25) * tmpvar_365));
    highp vec2 tmpvar_367;
    tmpvar_367 = abs(((op_362 * 3.0) + vec2(1.5, 0.1)));
    highp float tmpvar_368;
    tmpvar_368 = clamp (((-2.0 * 
      ((tmpvar_367.x * 0.5) - (tmpvar_367.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_369;
    tmpvar_369.x = (1.0 - tmpvar_368);
    tmpvar_369.y = (1.0 + tmpvar_368);
    highp vec2 x_370;
    x_370 = (tmpvar_367 - (vec2(0.25, 0.25) * tmpvar_369));
    highp float tmpvar_371;
    tmpvar_371 = clamp (((
      min (min (1.0, ((
        sqrt(dot (x_366, x_366))
       * 
        sign((((tmpvar_363.x * 0.5) + (tmpvar_363.y * 0.5)) - 0.25))
      ) + 0.5)), ((sqrt(
        dot (x_370, x_370)
      ) * sign(
        (((tmpvar_367.x * 0.5) + (tmpvar_367.y * 0.5)) - 0.25)
      )) + 0.5))
     - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    float edge0_372;
    edge0_372 = (-0.235 + (0.001 * zv_3));
    highp float tmpvar_373;
    tmpvar_373 = clamp (((tmpvar_336.x - edge0_372) / (
      (-0.235 - (0.001 * zv_3))
     - edge0_372)), 0.0, 1.0);
    highp float tmpvar_374;
    tmpvar_374 = ((1.0 - (tmpvar_371 * 
      (tmpvar_371 * (3.0 - (2.0 * tmpvar_371)))
    )) * (tmpvar_373 * (tmpvar_373 * 
      (3.0 - (2.0 * tmpvar_373))
    )));
    float edge0_375;
    edge0_375 = (-0.24 + (0.005 * zv_3));
    highp float tmpvar_376;
    tmpvar_376 = clamp (((tmpvar_336.x - edge0_375) / (
      (-0.24 - (0.005 * zv_3))
     - edge0_375)), 0.0, 1.0);
    float edge0_377;
    edge0_377 = (0.64 - (0.005 * zv_3));
    highp float tmpvar_378;
    tmpvar_378 = clamp (((
      (-(tmpvar_336.x) + (uv_4.y * 1.1))
     - edge0_377) / (
      (0.64 + (0.005 * zv_3))
     - edge0_377)), 0.0, 1.0);
    highp vec4 tmpvar_379;
    tmpvar_379.w = 1.0;
    tmpvar_379.xyz = mix (mix (mix (ground1, ground2, tmpvar_338), ground3, max (0.0, 
      (((tmpvar_376 * (tmpvar_376 * 
        (3.0 - (2.0 * tmpvar_376))
      )) * (tmpvar_378 * (tmpvar_378 * 
        (3.0 - (2.0 * tmpvar_378))
      ))) * (1.0 - (tmpvar_374 + tmpvar_338)))
    )), green, tmpvar_374);
    highp float tmpvar_380;
    tmpvar_380 = clamp (((uv_4.y - 0.55) / (
      (0.52 - (0.01 * zv_3))
     - 0.55)), 0.0, 1.0);
    fragColor_337 = (tmpvar_379 * (tmpvar_380 * (tmpvar_380 * 
      (3.0 - (2.0 * tmpvar_380))
    )));
    fragColor_1 = (fragColor_337 * fragColor_337);
    tmpvar_11 = bool(1);
  };
  if(7 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp float d_381;
    highp vec2 p_382;
    p_382.x = uv_4.x;
    highp float d_383;
    p_382.y = (uv_4.y * 1.1);
    p_382.y = (p_382.y + 0.3333333);
    if ((p_382.y > 0.1666667)) {
      p_382.y = (p_382.y + 0.1666667);
    };
    bool tmpvar_384;
    tmpvar_384 = ((float(mod ((p_382.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_384) {
      p_382.x = (uv_4.x + 0.1666667);
    };
    p_382.x = (abs(p_382.x) - 0.3333333);
    p_382.y = (float(mod ((p_382.y + 0.03333334), 0.3333333)));
    if (tmpvar_384) {
      p_382.y = (0.3333333 - abs(p_382.y));
    };
    p_382 = (p_382 * 3.0);
    highp vec2 p_385;
    p_385 = (p_382 + vec2(1.0, 0.0));
    highp float tmpvar_386;
    if ((p_385.y < 0.0)) {
      tmpvar_386 = 1.0;
    } else {
      highp vec2 tmpvar_387;
      tmpvar_387 = abs(p_385);
      highp float tmpvar_388;
      tmpvar_388 = clamp (((-2.0 * 
        ((tmpvar_387.x * 0.5) - (tmpvar_387.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_389;
      tmpvar_389.x = (1.0 - tmpvar_388);
      tmpvar_389.y = (1.0 + tmpvar_388);
      highp vec2 x_390;
      x_390 = (tmpvar_387 - (vec2(0.25, 0.25) * tmpvar_389));
      tmpvar_386 = ((sqrt(
        dot (x_390, x_390)
      ) * sign(
        (((tmpvar_387.x * 0.5) + (tmpvar_387.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_383 = tmpvar_386;
    highp float tmpvar_391;
    if ((p_382.y < 0.0)) {
      tmpvar_391 = 1.0;
    } else {
      highp vec2 tmpvar_392;
      tmpvar_392 = abs(p_382);
      highp float tmpvar_393;
      tmpvar_393 = clamp (((-2.0 * 
        ((tmpvar_392.x * 0.5) - (tmpvar_392.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_394;
      tmpvar_394.x = (1.0 - tmpvar_393);
      tmpvar_394.y = (1.0 + tmpvar_393);
      highp vec2 x_395;
      x_395 = (tmpvar_392 - (vec2(0.25, 0.25) * tmpvar_394));
      tmpvar_391 = ((sqrt(
        dot (x_395, x_395)
      ) * sign(
        (((tmpvar_392.x * 0.5) + (tmpvar_392.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_383 = min (tmpvar_386, tmpvar_391);
    highp vec2 p_396;
    p_396 = (p_382 - vec2(1.0, 0.0));
    highp float tmpvar_397;
    if ((p_396.y < 0.0)) {
      tmpvar_397 = 1.0;
    } else {
      highp vec2 tmpvar_398;
      tmpvar_398 = abs(p_396);
      highp float tmpvar_399;
      tmpvar_399 = clamp (((-2.0 * 
        ((tmpvar_398.x * 0.5) - (tmpvar_398.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_400;
      tmpvar_400.x = (1.0 - tmpvar_399);
      tmpvar_400.y = (1.0 + tmpvar_399);
      highp vec2 x_401;
      x_401 = (tmpvar_398 - (vec2(0.25, 0.25) * tmpvar_400));
      tmpvar_397 = ((sqrt(
        dot (x_401, x_401)
      ) * sign(
        (((tmpvar_398.x * 0.5) + (tmpvar_398.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_402;
    tmpvar_402 = min (d_383, tmpvar_397);
    d_383 = tmpvar_402;
    highp float tmpvar_403;
    tmpvar_403 = clamp (((tmpvar_402 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    d_381 = (1.0 - (tmpvar_403 * (tmpvar_403 * 
      (3.0 - (2.0 * tmpvar_403))
    )));
    highp vec2 p_404;
    p_404.x = uv_4.x;
    p_404.y = (uv_4.y * 1.1);
    p_404.y = (p_404.y + -0.3333333);
    if (((p_404.y <= 0.0952381) && (p_404.y >= -0.0952381))) {
      p_404.y = (p_404.y + -0.1388889);
      p_404.x = (uv_4.x + 0.1666667);
      p_404.x = (abs(p_404.x) - 0.3333333);
      p_404.y = (float(mod ((p_404.y + 0.03333334), 0.3333333)));
      p_404.y = (0.3333333 - abs(p_404.y));
      p_404 = (p_404 * 3.0);
    };
    highp vec2 tmpvar_405;
    tmpvar_405.x = uv_4.y;
    tmpvar_405.y = ((uv_4.x * 0.77777) + 0.05);
    highp vec2 p_406;
    p_406.x = tmpvar_405.x;
    highp float tmpvar_407;
    highp float d_408;
    p_406.y = (tmpvar_405.y * 1.1);
    p_406.y = (p_406.y + -0.3333333);
    if ((p_406.y > 0.0952381)) {
      tmpvar_407 = 1.0;
    } else {
      if ((p_406.y < -0.0952381)) {
        tmpvar_407 = 0.0;
      } else {
        p_406.y = (p_406.y + -0.1388889);
        p_406.x = (uv_4.y + 0.1666667);
        p_406.x = (abs(p_406.x) - 0.3333333);
        p_406.y = (float(mod ((p_406.y + 0.03333334), 0.3333333)));
        p_406.y = (0.3333333 - abs(p_406.y));
        p_406 = (p_406 * 3.0);
        highp vec2 p_409;
        p_409 = (p_406 + vec2(1.0, 0.0));
        highp float tmpvar_410;
        if ((p_409.y < 0.0)) {
          tmpvar_410 = 1.0;
        } else {
          highp vec2 tmpvar_411;
          tmpvar_411 = abs(p_409);
          highp float tmpvar_412;
          tmpvar_412 = clamp (((-2.0 * 
            ((tmpvar_411.x * 0.5) - (tmpvar_411.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_413;
          tmpvar_413.x = (1.0 - tmpvar_412);
          tmpvar_413.y = (1.0 + tmpvar_412);
          highp vec2 x_414;
          x_414 = (tmpvar_411 - (vec2(0.25, 0.25) * tmpvar_413));
          tmpvar_410 = ((sqrt(
            dot (x_414, x_414)
          ) * sign(
            (((tmpvar_411.x * 0.5) + (tmpvar_411.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_408 = tmpvar_410;
        highp float tmpvar_415;
        if ((p_406.y < 0.0)) {
          tmpvar_415 = 1.0;
        } else {
          highp vec2 tmpvar_416;
          tmpvar_416 = abs(p_406);
          highp float tmpvar_417;
          tmpvar_417 = clamp (((-2.0 * 
            ((tmpvar_416.x * 0.5) - (tmpvar_416.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_418;
          tmpvar_418.x = (1.0 - tmpvar_417);
          tmpvar_418.y = (1.0 + tmpvar_417);
          highp vec2 x_419;
          x_419 = (tmpvar_416 - (vec2(0.25, 0.25) * tmpvar_418));
          tmpvar_415 = ((sqrt(
            dot (x_419, x_419)
          ) * sign(
            (((tmpvar_416.x * 0.5) + (tmpvar_416.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_408 = min (tmpvar_410, tmpvar_415);
        highp vec2 p_420;
        p_420 = (p_406 - vec2(1.0, 0.0));
        highp float tmpvar_421;
        if ((p_420.y < 0.0)) {
          tmpvar_421 = 1.0;
        } else {
          highp vec2 tmpvar_422;
          tmpvar_422 = abs(p_420);
          highp float tmpvar_423;
          tmpvar_423 = clamp (((-2.0 * 
            ((tmpvar_422.x * 0.5) - (tmpvar_422.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_424;
          tmpvar_424.x = (1.0 - tmpvar_423);
          tmpvar_424.y = (1.0 + tmpvar_423);
          highp vec2 x_425;
          x_425 = (tmpvar_422 - (vec2(0.25, 0.25) * tmpvar_424));
          tmpvar_421 = ((sqrt(
            dot (x_425, x_425)
          ) * sign(
            (((tmpvar_422.x * 0.5) + (tmpvar_422.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_426;
        tmpvar_426 = min (d_408, tmpvar_421);
        d_408 = tmpvar_426;
        highp float tmpvar_427;
        tmpvar_427 = clamp (((tmpvar_426 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_407 = (1.0 - (tmpvar_427 * (tmpvar_427 * 
          (3.0 - (2.0 * tmpvar_427))
        )));
      };
    };
    highp float tmpvar_428;
    tmpvar_428 = max (0.0, tmpvar_407);
    highp vec2 p_429;
    p_429 = (uv_4 + vec2(-0.1, 0.05));
    p_429.x = (p_429.x + (-0.375 - (0.005 * zv_3)));
    p_429.y = (p_429.y + -0.178);
    p_429.y = (p_429.y * 1.1);
    p_429 = (p_429 * 2.0);
    highp vec2 tmpvar_430;
    tmpvar_430 = abs(p_429);
    highp float tmpvar_431;
    tmpvar_431 = clamp (((-2.0 * 
      ((tmpvar_430.x * 0.5) - (tmpvar_430.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_432;
    tmpvar_432.x = (1.0 - tmpvar_431);
    tmpvar_432.y = (1.0 + tmpvar_431);
    highp vec2 x_433;
    x_433 = (tmpvar_430 - (vec2(0.25, 0.25) * tmpvar_432));
    highp float tmpvar_434;
    tmpvar_434 = clamp (((
      ((sqrt(dot (x_433, x_433)) * sign((
        ((tmpvar_430.x * 0.5) + (tmpvar_430.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_435;
    p_435 = (uv_4 + vec2(-0.1, -0.29));
    p_435.x = (p_435.x + (-0.375 - (0.005 * zv_3)));
    p_435.y = (p_435.y + -0.178);
    p_435.y = (p_435.y * 1.1);
    p_435 = (p_435 * 2.0);
    highp vec2 tmpvar_436;
    tmpvar_436 = abs(p_435);
    highp float tmpvar_437;
    tmpvar_437 = clamp (((-2.0 * 
      ((tmpvar_436.x * 0.5) - (tmpvar_436.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_438;
    tmpvar_438.x = (1.0 - tmpvar_437);
    tmpvar_438.y = (1.0 + tmpvar_437);
    highp vec2 x_439;
    x_439 = (tmpvar_436 - (vec2(0.25, 0.25) * tmpvar_438));
    highp float tmpvar_440;
    tmpvar_440 = clamp (((
      ((sqrt(dot (x_439, x_439)) * sign((
        ((tmpvar_436.x * 0.5) + (tmpvar_436.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_441;
    p_441 = (uv_4 + vec2(-0.1, 0.39));
    p_441.x = (p_441.x + (-0.375 - (0.005 * zv_3)));
    p_441.y = (p_441.y + -0.178);
    p_441.y = (p_441.y * 1.1);
    p_441 = (p_441 * 2.0);
    highp vec2 tmpvar_442;
    tmpvar_442 = abs(p_441);
    highp float tmpvar_443;
    tmpvar_443 = clamp (((-2.0 * 
      ((tmpvar_442.x * 0.5) - (tmpvar_442.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_444;
    tmpvar_444.x = (1.0 - tmpvar_443);
    tmpvar_444.y = (1.0 + tmpvar_443);
    highp vec2 x_445;
    x_445 = (tmpvar_442 - (vec2(0.25, 0.25) * tmpvar_444));
    highp float tmpvar_446;
    tmpvar_446 = clamp (((
      ((sqrt(dot (x_445, x_445)) * sign((
        ((tmpvar_442.x * 0.5) + (tmpvar_442.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp float tmpvar_447;
    tmpvar_447 = clamp (((
      (uv_4.x - 0.24)
     * 2.0) / 0.04), 0.0, 1.0);
    highp vec2 tmpvar_448;
    tmpvar_448.x = uv_4.y;
    tmpvar_448.y = (uv_4.x - 0.01);
    highp vec2 p_449;
    p_449.x = tmpvar_448.x;
    p_449.y = (tmpvar_448.y + -0.47);
    highp float tmpvar_450;
    tmpvar_450 = clamp ((p_449.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_451;
    tmpvar_451.w = 1.0;
    tmpvar_451.xyz = mix (mix (mix (
      mix (ground1, ground2, d_381)
    , green, tmpvar_428), green_l, max (0.0, 
      (tmpvar_450 * (tmpvar_450 * (3.0 - (2.0 * tmpvar_450))))
    )), ground3, (max (
      max ((1.0 - (tmpvar_434 * (tmpvar_434 * 
        (3.0 - (2.0 * tmpvar_434))
      ))), (1.0 - (tmpvar_440 * (tmpvar_440 * 
        (3.0 - (2.0 * tmpvar_440))
      ))))
    , 
      (1.0 - (tmpvar_446 * (tmpvar_446 * (3.0 - 
        (2.0 * tmpvar_446)
      ))))
    ) * (
      (tmpvar_447 * (tmpvar_447 * (3.0 - (2.0 * tmpvar_447))))
     * 
      (1.0 - tmpvar_428)
    )));
    fragColor_1 = (tmpvar_451 * tmpvar_451);
    tmpvar_11 = bool(1);
  };
  if(8 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec2 tmpvar_452;
    tmpvar_452.x = -(uv_4.x);
    tmpvar_452.y = uv_4.y;
    highp float d_453;
    highp vec2 p_454;
    p_454.x = tmpvar_452.x;
    highp float d_455;
    p_454.y = (uv_4.y * 1.1);
    p_454.y = (p_454.y + 0.3333333);
    if ((p_454.y > 0.1666667)) {
      p_454.y = (p_454.y + 0.1666667);
    };
    bool tmpvar_456;
    tmpvar_456 = ((float(mod ((p_454.y + 0.03333334), 0.6666667))) >= 0.3333333);
    if (tmpvar_456) {
      p_454.x = (tmpvar_452.x + 0.1666667);
    };
    p_454.x = (abs(p_454.x) - 0.3333333);
    p_454.y = (float(mod ((p_454.y + 0.03333334), 0.3333333)));
    if (tmpvar_456) {
      p_454.y = (0.3333333 - abs(p_454.y));
    };
    p_454 = (p_454 * 3.0);
    highp vec2 p_457;
    p_457 = (p_454 + vec2(1.0, 0.0));
    highp float tmpvar_458;
    if ((p_457.y < 0.0)) {
      tmpvar_458 = 1.0;
    } else {
      highp vec2 tmpvar_459;
      tmpvar_459 = abs(p_457);
      highp float tmpvar_460;
      tmpvar_460 = clamp (((-2.0 * 
        ((tmpvar_459.x * 0.5) - (tmpvar_459.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_461;
      tmpvar_461.x = (1.0 - tmpvar_460);
      tmpvar_461.y = (1.0 + tmpvar_460);
      highp vec2 x_462;
      x_462 = (tmpvar_459 - (vec2(0.25, 0.25) * tmpvar_461));
      tmpvar_458 = ((sqrt(
        dot (x_462, x_462)
      ) * sign(
        (((tmpvar_459.x * 0.5) + (tmpvar_459.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_455 = tmpvar_458;
    highp float tmpvar_463;
    if ((p_454.y < 0.0)) {
      tmpvar_463 = 1.0;
    } else {
      highp vec2 tmpvar_464;
      tmpvar_464 = abs(p_454);
      highp float tmpvar_465;
      tmpvar_465 = clamp (((-2.0 * 
        ((tmpvar_464.x * 0.5) - (tmpvar_464.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_466;
      tmpvar_466.x = (1.0 - tmpvar_465);
      tmpvar_466.y = (1.0 + tmpvar_465);
      highp vec2 x_467;
      x_467 = (tmpvar_464 - (vec2(0.25, 0.25) * tmpvar_466));
      tmpvar_463 = ((sqrt(
        dot (x_467, x_467)
      ) * sign(
        (((tmpvar_464.x * 0.5) + (tmpvar_464.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    d_455 = min (tmpvar_458, tmpvar_463);
    highp vec2 p_468;
    p_468 = (p_454 - vec2(1.0, 0.0));
    highp float tmpvar_469;
    if ((p_468.y < 0.0)) {
      tmpvar_469 = 1.0;
    } else {
      highp vec2 tmpvar_470;
      tmpvar_470 = abs(p_468);
      highp float tmpvar_471;
      tmpvar_471 = clamp (((-2.0 * 
        ((tmpvar_470.x * 0.5) - (tmpvar_470.y * 0.5))
      ) / 0.5), -1.0, 1.0);
      highp vec2 tmpvar_472;
      tmpvar_472.x = (1.0 - tmpvar_471);
      tmpvar_472.y = (1.0 + tmpvar_471);
      highp vec2 x_473;
      x_473 = (tmpvar_470 - (vec2(0.25, 0.25) * tmpvar_472));
      tmpvar_469 = ((sqrt(
        dot (x_473, x_473)
      ) * sign(
        (((tmpvar_470.x * 0.5) + (tmpvar_470.y * 0.5)) - 0.25)
      )) + 0.5);
    };
    highp float tmpvar_474;
    tmpvar_474 = min (d_455, tmpvar_469);
    d_455 = tmpvar_474;
    highp float tmpvar_475;
    tmpvar_475 = clamp (((tmpvar_474 - 0.5) / (0.025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    d_453 = (1.0 - (tmpvar_475 * (tmpvar_475 * 
      (3.0 - (2.0 * tmpvar_475))
    )));
    highp vec2 p_476;
    p_476.x = tmpvar_452.x;
    p_476.y = (uv_4.y * 1.1);
    p_476.y = (p_476.y + -0.3333333);
    if (((p_476.y <= 0.0952381) && (p_476.y >= -0.0952381))) {
      p_476.y = (p_476.y + -0.1388889);
      p_476.x = (tmpvar_452.x + 0.1666667);
      p_476.x = (abs(p_476.x) - 0.3333333);
      p_476.y = (float(mod ((p_476.y + 0.03333334), 0.3333333)));
      p_476.y = (0.3333333 - abs(p_476.y));
      p_476 = (p_476 * 3.0);
    };
    highp vec2 tmpvar_477;
    tmpvar_477.x = tmpvar_452.y;
    tmpvar_477.y = ((tmpvar_452.x * 0.77777) + 0.05);
    highp vec2 p_478;
    p_478.x = tmpvar_477.x;
    highp float tmpvar_479;
    highp float d_480;
    p_478.y = (tmpvar_477.y * 1.1);
    p_478.y = (p_478.y + -0.3333333);
    if ((p_478.y > 0.0952381)) {
      tmpvar_479 = 1.0;
    } else {
      if ((p_478.y < -0.0952381)) {
        tmpvar_479 = 0.0;
      } else {
        p_478.y = (p_478.y + -0.1388889);
        p_478.x = (uv_4.y + 0.1666667);
        p_478.x = (abs(p_478.x) - 0.3333333);
        p_478.y = (float(mod ((p_478.y + 0.03333334), 0.3333333)));
        p_478.y = (0.3333333 - abs(p_478.y));
        p_478 = (p_478 * 3.0);
        highp vec2 p_481;
        p_481 = (p_478 + vec2(1.0, 0.0));
        highp float tmpvar_482;
        if ((p_481.y < 0.0)) {
          tmpvar_482 = 1.0;
        } else {
          highp vec2 tmpvar_483;
          tmpvar_483 = abs(p_481);
          highp float tmpvar_484;
          tmpvar_484 = clamp (((-2.0 * 
            ((tmpvar_483.x * 0.5) - (tmpvar_483.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_485;
          tmpvar_485.x = (1.0 - tmpvar_484);
          tmpvar_485.y = (1.0 + tmpvar_484);
          highp vec2 x_486;
          x_486 = (tmpvar_483 - (vec2(0.25, 0.25) * tmpvar_485));
          tmpvar_482 = ((sqrt(
            dot (x_486, x_486)
          ) * sign(
            (((tmpvar_483.x * 0.5) + (tmpvar_483.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_480 = tmpvar_482;
        highp float tmpvar_487;
        if ((p_478.y < 0.0)) {
          tmpvar_487 = 1.0;
        } else {
          highp vec2 tmpvar_488;
          tmpvar_488 = abs(p_478);
          highp float tmpvar_489;
          tmpvar_489 = clamp (((-2.0 * 
            ((tmpvar_488.x * 0.5) - (tmpvar_488.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_490;
          tmpvar_490.x = (1.0 - tmpvar_489);
          tmpvar_490.y = (1.0 + tmpvar_489);
          highp vec2 x_491;
          x_491 = (tmpvar_488 - (vec2(0.25, 0.25) * tmpvar_490));
          tmpvar_487 = ((sqrt(
            dot (x_491, x_491)
          ) * sign(
            (((tmpvar_488.x * 0.5) + (tmpvar_488.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        d_480 = min (tmpvar_482, tmpvar_487);
        highp vec2 p_492;
        p_492 = (p_478 - vec2(1.0, 0.0));
        highp float tmpvar_493;
        if ((p_492.y < 0.0)) {
          tmpvar_493 = 1.0;
        } else {
          highp vec2 tmpvar_494;
          tmpvar_494 = abs(p_492);
          highp float tmpvar_495;
          tmpvar_495 = clamp (((-2.0 * 
            ((tmpvar_494.x * 0.5) - (tmpvar_494.y * 0.5))
          ) / 0.5), -1.0, 1.0);
          highp vec2 tmpvar_496;
          tmpvar_496.x = (1.0 - tmpvar_495);
          tmpvar_496.y = (1.0 + tmpvar_495);
          highp vec2 x_497;
          x_497 = (tmpvar_494 - (vec2(0.25, 0.25) * tmpvar_496));
          tmpvar_493 = ((sqrt(
            dot (x_497, x_497)
          ) * sign(
            (((tmpvar_494.x * 0.5) + (tmpvar_494.y * 0.5)) - 0.25)
          )) + 0.5);
        };
        highp float tmpvar_498;
        tmpvar_498 = min (d_480, tmpvar_493);
        d_480 = tmpvar_498;
        highp float tmpvar_499;
        tmpvar_499 = clamp (((tmpvar_498 - 0.5) / (0.025 + 
          (0.015 * zv_3)
        )), 0.0, 1.0);
        tmpvar_479 = (1.0 - (tmpvar_499 * (tmpvar_499 * 
          (3.0 - (2.0 * tmpvar_499))
        )));
      };
    };
    highp float tmpvar_500;
    tmpvar_500 = max (0.0, tmpvar_479);
    highp vec2 p_501;
    p_501 = (tmpvar_452 + vec2(-0.1, 0.05));
    p_501.x = (p_501.x + (-0.375 - (0.005 * zv_3)));
    p_501.y = (p_501.y + -0.178);
    p_501.y = (p_501.y * 1.1);
    p_501 = (p_501 * 2.0);
    highp vec2 tmpvar_502;
    tmpvar_502 = abs(p_501);
    highp float tmpvar_503;
    tmpvar_503 = clamp (((-2.0 * 
      ((tmpvar_502.x * 0.5) - (tmpvar_502.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_504;
    tmpvar_504.x = (1.0 - tmpvar_503);
    tmpvar_504.y = (1.0 + tmpvar_503);
    highp vec2 x_505;
    x_505 = (tmpvar_502 - (vec2(0.25, 0.25) * tmpvar_504));
    highp float tmpvar_506;
    tmpvar_506 = clamp (((
      ((sqrt(dot (x_505, x_505)) * sign((
        ((tmpvar_502.x * 0.5) + (tmpvar_502.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_507;
    p_507 = (tmpvar_452 + vec2(-0.1, -0.29));
    p_507.x = (p_507.x + (-0.375 - (0.005 * zv_3)));
    p_507.y = (p_507.y + -0.178);
    p_507.y = (p_507.y * 1.1);
    p_507 = (p_507 * 2.0);
    highp vec2 tmpvar_508;
    tmpvar_508 = abs(p_507);
    highp float tmpvar_509;
    tmpvar_509 = clamp (((-2.0 * 
      ((tmpvar_508.x * 0.5) - (tmpvar_508.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_510;
    tmpvar_510.x = (1.0 - tmpvar_509);
    tmpvar_510.y = (1.0 + tmpvar_509);
    highp vec2 x_511;
    x_511 = (tmpvar_508 - (vec2(0.25, 0.25) * tmpvar_510));
    highp float tmpvar_512;
    tmpvar_512 = clamp (((
      ((sqrt(dot (x_511, x_511)) * sign((
        ((tmpvar_508.x * 0.5) + (tmpvar_508.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp vec2 p_513;
    p_513 = (tmpvar_452 + vec2(-0.1, 0.39));
    p_513.x = (p_513.x + (-0.375 - (0.005 * zv_3)));
    p_513.y = (p_513.y + -0.178);
    p_513.y = (p_513.y * 1.1);
    p_513 = (p_513 * 2.0);
    highp vec2 tmpvar_514;
    tmpvar_514 = abs(p_513);
    highp float tmpvar_515;
    tmpvar_515 = clamp (((-2.0 * 
      ((tmpvar_514.x * 0.5) - (tmpvar_514.y * 0.5))
    ) / 0.5), -1.0, 1.0);
    highp vec2 tmpvar_516;
    tmpvar_516.x = (1.0 - tmpvar_515);
    tmpvar_516.y = (1.0 + tmpvar_515);
    highp vec2 x_517;
    x_517 = (tmpvar_514 - (vec2(0.25, 0.25) * tmpvar_516));
    highp float tmpvar_518;
    tmpvar_518 = clamp (((
      ((sqrt(dot (x_517, x_517)) * sign((
        ((tmpvar_514.x * 0.5) + (tmpvar_514.y * 0.5))
       - 0.25))) + 0.5)
     - 0.5) / (0.0125 + 
      ((0.015 * zv_3) / 2.0)
    )), 0.0, 1.0);
    highp float tmpvar_519;
    tmpvar_519 = clamp (((
      (tmpvar_452.x - 0.24)
     * 2.0) / 0.04), 0.0, 1.0);
    highp vec2 tmpvar_520;
    tmpvar_520.x = tmpvar_452.y;
    tmpvar_520.y = (tmpvar_452.x - 0.01);
    highp vec2 p_521;
    p_521.x = tmpvar_520.x;
    p_521.y = (tmpvar_520.y + -0.47);
    highp float tmpvar_522;
    tmpvar_522 = clamp ((p_521.y / (0.0025 + 
      (0.015 * zv_3)
    )), 0.0, 1.0);
    highp vec4 tmpvar_523;
    tmpvar_523.w = 1.0;
    tmpvar_523.xyz = mix (mix (mix (
      mix (ground1, ground2, d_453)
    , green, tmpvar_500), green_l, max (0.0, 
      (tmpvar_522 * (tmpvar_522 * (3.0 - (2.0 * tmpvar_522))))
    )), ground3, (max (
      max ((1.0 - (tmpvar_506 * (tmpvar_506 * 
        (3.0 - (2.0 * tmpvar_506))
      ))), (1.0 - (tmpvar_512 * (tmpvar_512 * 
        (3.0 - (2.0 * tmpvar_512))
      ))))
    , 
      (1.0 - (tmpvar_518 * (tmpvar_518 * (3.0 - 
        (2.0 * tmpvar_518)
      ))))
    ) * (
      (tmpvar_519 * (tmpvar_519 * (3.0 - (2.0 * tmpvar_519))))
     * 
      (1.0 - tmpvar_500)
    )));
    fragColor_1 = (tmpvar_523 * tmpvar_523);
    tmpvar_11 = bool(1);
  };
  if(9 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    mat2 tmpvar_524;
    float tmpvar_525;
    tmpvar_525 = -(shape_rotate_an);
    tmpvar_524[uint(0)].x = cos(tmpvar_525);
    tmpvar_524[uint(0)].y = -(sin(tmpvar_525));
    tmpvar_524[1u].x = sin(tmpvar_525);
    tmpvar_524[1u].y = cos(tmpvar_525);
    uv_4 = (uv_4 * tmpvar_524);
    float zv_526;
    zv_526 = zv_3;
    highp vec3 col_527;
    highp float tmpvar_528;
    if ((shape_type == 1)) {
      highp vec2 tmpvar_529;
      tmpvar_529 = (abs(uv_4) - vec2(0.5, 0.5));
      highp vec2 tmpvar_530;
      tmpvar_530 = max (tmpvar_529, vec2(0.0, 0.0));
      tmpvar_528 = ((sqrt(
        dot (tmpvar_530, tmpvar_530)
      ) + min (
        max (tmpvar_529.x, tmpvar_529.y)
      , 0.0)) + 0.5);
    } else {
      if ((shape_type == 2)) {
        tmpvar_528 = ((sqrt(
          dot (uv_4, uv_4)
        ) - 0.5) + 0.5);
      } else {
        if ((shape_type == 0)) {
          highp vec2 p_531;
          p_531 = (uv_4 * 2.0);
          p_531.x = (abs(p_531.x) - 1.0);
          p_531.y = (p_531.y + 0.5773503);
          if ((p_531.x > -((1.732051 * p_531.y)))) {
            highp vec2 tmpvar_532;
            tmpvar_532.x = (p_531.x - (1.732051 * p_531.y));
            tmpvar_532.y = ((-1.732051 * p_531.x) - p_531.y);
            p_531 = (tmpvar_532 / 2.0);
          };
          p_531.x = (p_531.x - clamp (p_531.x, -2.0, 0.0));
          tmpvar_528 = ((-(
            sqrt(dot (p_531, p_531))
          ) * sign(p_531.y)) + 0.5);
        };
      };
    };
    if ((shape_type == 0)) {
      zv_526 = (zv_3 + 4.0);
    };
    col_527 = ((vec3(1.0, 1.0, 1.0) - (
      sign((tmpvar_528 - 0.5))
     * vec3(0.1, 0.4, 0.7))) * (1.0 - exp(
      (-2.0 * abs((tmpvar_528 - 0.5)))
    )));
    col_527 = (col_527 * (0.8 + (0.2 * 
      cos(((u_time * 2.0) + (max (
        (120.0 - (10.0 * zv_526))
      , 1.0) * (tmpvar_528 - 0.5))))
    )));
    highp float tmpvar_533;
    tmpvar_533 = clamp ((abs(
      (tmpvar_528 - 0.5)
    ) / (0.025 + 
      (0.015 * zv_526)
    )), 0.0, 1.0);
    highp vec3 tmpvar_534;
    tmpvar_534 = mix (col_527, vec3(1.0, 1.0, 1.0), (1.0 - (tmpvar_533 * 
      (tmpvar_533 * (3.0 - (2.0 * tmpvar_533)))
    )));
    col_527 = tmpvar_534;
    highp float tmpvar_535;
    highp float tmpvar_536;
    tmpvar_536 = clamp (((tmpvar_528 - 0.6) / -0.13), 0.0, 1.0);
    tmpvar_535 = (tmpvar_536 * (tmpvar_536 * (3.0 - 
      (2.0 * tmpvar_536)
    )));
    highp vec4 tmpvar_537;
    tmpvar_537.xyz = (tmpvar_534 * tmpvar_535);
    tmpvar_537.w = tmpvar_535;
    fragColor_1 = tmpvar_537;
    float tmpvar_538;
    float tmpvar_539;
    tmpvar_539 = (float(mod (u_time, 4.0)));
    tmpvar_538 = float((2.0 >= tmpvar_539));
    float tmpvar_540;
    float tmpvar_541;
    tmpvar_541 = clamp (((tmpvar_539 - 2.0) / 2.0), 0.0, 1.0);
    tmpvar_540 = (tmpvar_541 * (tmpvar_541 * (3.0 - 
      (2.0 * tmpvar_541)
    )));
    highp float tmpvar_542;
    if ((tmpvar_539 > 2.0)) {
      tmpvar_542 = 0.0;
    } else {
      float tmpvar_543;
      tmpvar_543 = clamp (((float(mod (tmpvar_539, 2.0))) / 2.0), 0.0, 1.0);
      float tmpvar_544;
      tmpvar_544 = (0.6 * (tmpvar_543 * (tmpvar_543 * 
        (3.0 - (2.0 * tmpvar_543))
      )));
      float edge0_545;
      edge0_545 = (tmpvar_544 + 0.001);
      highp float tmpvar_546;
      tmpvar_546 = clamp (((
        abs(uv_4.x)
       - edge0_545) / (tmpvar_544 - edge0_545)), 0.0, 1.0);
      tmpvar_542 = (tmpvar_546 * (tmpvar_546 * (3.0 - 
        (2.0 * tmpvar_546)
      )));
    };
    fragColor_1 = mix (((tmpvar_537.zxxw * 0.6) * (tmpvar_538 + tmpvar_540)), tmpvar_537, tmpvar_542);
    tmpvar_11 = bool(1);
  };
  if(10 == shape_tile_l_2) tmpvar_10 = bool(1);
  if(tmpvar_11) tmpvar_10 = bool(0);
  if (tmpvar_10) {
    highp vec2 uv_547;
    uv_547 = uv_4;
    highp vec3 col_548;
    float rot2_549;
    float rot_550;
    rot_550 = -0.33;
    if ((u_time > 7.0)) {
      rot_550 = (-0.33 - shape_rotate_Urot);
    };
    rot2_549 = 0.0;
    if ((u_time > 7.0)) {
      rot2_549 = -(shape_rotate_an);
    };
    float tmpvar_551;
    tmpvar_551 = clamp (((u_time - 2.0) / -2.0), 0.0, 1.0);
    float edge0_552;
    edge0_552 = (1.2 - sin((-1.57079 * 
      (tmpvar_551 * (tmpvar_551 * (3.0 - (2.0 * tmpvar_551))))
    )));
    float tmpvar_553;
    tmpvar_553 = clamp (((u_time - edge0_552) / (0.2 - edge0_552)), 0.0, 1.0);
    uv_547.y = (uv_4.y + (1.4 * (tmpvar_553 * 
      (tmpvar_553 * (3.0 - (2.0 * tmpvar_553)))
    )));
    float tmpvar_554;
    tmpvar_554 = clamp (((u_time / 2.0) / 0.8), 0.0, 1.0);
    float tmpvar_555;
    tmpvar_555 = cos((1.57079 - (1.57079 * 
      sin((1.57079 * (tmpvar_554 * (tmpvar_554 * 
        (3.0 - (2.0 * tmpvar_554))
      ))))
    )));
    vec2 tmpvar_556;
    tmpvar_556.y = -0.5;
    tmpvar_556.x = (-2.5 * tmpvar_555);
    vec2 tmpvar_557;
    tmpvar_557.y = -0.5;
    tmpvar_557.x = (2.5 * tmpvar_555);
    highp vec2 tmpvar_558;
    tmpvar_558 = (uv_4 - tmpvar_556);
    vec2 tmpvar_559;
    tmpvar_559 = (tmpvar_557 - tmpvar_556);
    highp float tmpvar_560;
    highp vec2 x_561;
    x_561 = (tmpvar_558 - (tmpvar_559 * clamp (
      (dot (tmpvar_558, tmpvar_559) / dot (tmpvar_559, tmpvar_559))
    , 0.0, 1.0)));
    tmpvar_560 = sqrt(dot (x_561, x_561));
    highp float tmpvar_562;
    highp vec2 tmpvar_563;
    tmpvar_563 = (abs(uv_547) - vec2(0.4, 0.4));
    highp vec2 tmpvar_564;
    tmpvar_564 = max (tmpvar_563, vec2(0.0, 0.0));
    tmpvar_562 = (abs((
      (sqrt(dot (tmpvar_564, tmpvar_564)) + min (max (tmpvar_563.x, tmpvar_563.y), 0.0))
     + 0.5)) - 0.1);
    highp float tmpvar_565;
    tmpvar_565 = ((sqrt(
      dot (uv_547, uv_547)
    ) - 0.5) + 0.5);
    highp float tmpvar_566;
    tmpvar_566 = ((sqrt(
      dot (uv_547, uv_547)
    ) - 0.43) + 0.5);
    highp float tmpvar_567;
    tmpvar_567 = ((sqrt(
      dot (uv_547, uv_547)
    ) - 0.34) + 0.5);
    highp float tmpvar_568;
    tmpvar_568 = ((sqrt(
      dot (uv_547, uv_547)
    ) - 0.07) + 0.5);
    highp float tmpvar_569;
    tmpvar_569 = ((sqrt(
      dot (uv_547, uv_547)
    ) - 0.13) + 0.5);
    if ((u_time < 7.0)) {
      highp vec2 uv_570;
      uv_570 = (uv_547 * mat2(-0.8011436, -0.5984721, 0.5984721, -0.8011436));
      highp float tmpvar_571;
      highp float tmpvar_572;
      tmpvar_572 = (min (abs(
        (uv_570.x / uv_570.y)
      ), 1.0) / max (abs(
        (uv_570.x / uv_570.y)
      ), 1.0));
      highp float tmpvar_573;
      tmpvar_573 = (tmpvar_572 * tmpvar_572);
      tmpvar_573 = (((
        ((((
          ((((-0.01213232 * tmpvar_573) + 0.05368138) * tmpvar_573) - 0.1173503)
         * tmpvar_573) + 0.1938925) * tmpvar_573) - 0.3326756)
       * tmpvar_573) + 0.9999793) * tmpvar_572);
      tmpvar_573 = (tmpvar_573 + (float(
        (abs((uv_570.x / uv_570.y)) > 1.0)
      ) * (
        (tmpvar_573 * -2.0)
       + 1.570796)));
      tmpvar_571 = (tmpvar_573 * sign((uv_570.x / uv_570.y)));
      if ((abs(uv_570.y) > (1e-08 * abs(uv_570.x)))) {
        if ((uv_570.y < 0.0)) {
          if ((uv_570.x >= 0.0)) {
            tmpvar_571 += 3.141593;
          } else {
            tmpvar_571 = (tmpvar_571 - 3.141593);
          };
        };
      } else {
        tmpvar_571 = (sign(uv_570.x) * 1.570796);
      };
      highp vec2 tmpvar_574;
      tmpvar_574.x = ((tmpvar_571 / 3.14158) * 2.0);
      tmpvar_574.y = sqrt(dot (uv_570, uv_570));
      uv_570 = tmpvar_574;
      float tmpvar_575;
      tmpvar_575 = clamp (((
        (u_time / 2.0)
       - 0.2) / 2.8), 0.0, 1.0);
      float tmpvar_576;
      tmpvar_576 = -((-4.084054 + (6.283159 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_575 * (tmpvar_575 * (3.0 - 
            (2.0 * tmpvar_575)
          ))))
        ))))
      )));
      highp float tmpvar_577;
      tmpvar_577 = clamp (((tmpvar_574.x - tmpvar_576) / (
        (0.01 + tmpvar_576)
       - tmpvar_576)), 0.0, 1.0);
      highp float tmpvar_578;
      tmpvar_578 = clamp (((
        abs((tmpvar_562 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp vec3 tmpvar_579;
      tmpvar_579 = mix (col_548, vec3(0.8392157, 0.8588235, 0.827451), ((1.0 - 
        (tmpvar_577 * (tmpvar_577 * (3.0 - (2.0 * tmpvar_577))))
      ) * (1.0 - 
        (tmpvar_578 * (tmpvar_578 * (3.0 - (2.0 * tmpvar_578))))
      )));
      col_548 = tmpvar_579;
      highp vec2 uv_580;
      uv_580 = (uv_547 * mat2(6.5128e-06, 1.0, -1.0, 6.5128e-06));
      highp float tmpvar_581;
      highp float tmpvar_582;
      tmpvar_582 = (min (abs(
        (uv_580.x / uv_580.y)
      ), 1.0) / max (abs(
        (uv_580.x / uv_580.y)
      ), 1.0));
      highp float tmpvar_583;
      tmpvar_583 = (tmpvar_582 * tmpvar_582);
      tmpvar_583 = (((
        ((((
          ((((-0.01213232 * tmpvar_583) + 0.05368138) * tmpvar_583) - 0.1173503)
         * tmpvar_583) + 0.1938925) * tmpvar_583) - 0.3326756)
       * tmpvar_583) + 0.9999793) * tmpvar_582);
      tmpvar_583 = (tmpvar_583 + (float(
        (abs((uv_580.x / uv_580.y)) > 1.0)
      ) * (
        (tmpvar_583 * -2.0)
       + 1.570796)));
      tmpvar_581 = (tmpvar_583 * sign((uv_580.x / uv_580.y)));
      if ((abs(uv_580.y) > (1e-08 * abs(uv_580.x)))) {
        if ((uv_580.y < 0.0)) {
          if ((uv_580.x >= 0.0)) {
            tmpvar_581 += 3.141593;
          } else {
            tmpvar_581 = (tmpvar_581 - 3.141593);
          };
        };
      } else {
        tmpvar_581 = (sign(uv_580.x) * 1.570796);
      };
      highp vec2 tmpvar_584;
      tmpvar_584.x = ((tmpvar_581 / 3.14158) * 2.0);
      tmpvar_584.y = sqrt(dot (uv_580, uv_580));
      uv_580 = tmpvar_584;
      float tmpvar_585;
      tmpvar_585 = clamp (((
        (u_time / 2.0)
       - 0.62) / 2.38), 0.0, 1.0);
      float tmpvar_586;
      tmpvar_586 = (-4.084054 + (6.283159 * cos(
        (1.57079 - (1.57079 * sin((1.57079 * 
          (tmpvar_585 * (tmpvar_585 * (3.0 - (2.0 * tmpvar_585))))
        ))))
      )));
      float edge0_587;
      edge0_587 = (0.01 + tmpvar_586);
      highp float tmpvar_588;
      tmpvar_588 = clamp (((tmpvar_584.x - edge0_587) / (tmpvar_586 - edge0_587)), 0.0, 1.0);
      highp float tmpvar_589;
      tmpvar_589 = clamp (((
        abs((tmpvar_565 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp vec3 tmpvar_590;
      tmpvar_590 = mix (tmpvar_579, vec3(0.8392157, 0.8588235, 0.827451), ((tmpvar_588 * 
        (tmpvar_588 * (3.0 - (2.0 * tmpvar_588)))
      ) * (1.0 - 
        (tmpvar_589 * (tmpvar_589 * (3.0 - (2.0 * tmpvar_589))))
      )));
      col_548 = tmpvar_590;
      mat2 tmpvar_591;
      tmpvar_591[uint(0)].x = cos(rot_550);
      tmpvar_591[uint(0)].y = -(sin(rot_550));
      tmpvar_591[1u].x = sin(rot_550);
      tmpvar_591[1u].y = cos(rot_550);
      highp vec2 uv_592;
      uv_592 = (uv_547 * tmpvar_591);
      highp float d_593;
      uv_592 = (uv_592 * mat2(6.5128e-06, -1.0, 1.0, 6.5128e-06));
      highp float tmpvar_594;
      highp float tmpvar_595;
      tmpvar_595 = (min (abs(
        (uv_592.x / uv_592.y)
      ), 1.0) / max (abs(
        (uv_592.x / uv_592.y)
      ), 1.0));
      highp float tmpvar_596;
      tmpvar_596 = (tmpvar_595 * tmpvar_595);
      tmpvar_596 = (((
        ((((
          ((((-0.01213232 * tmpvar_596) + 0.05368138) * tmpvar_596) - 0.1173503)
         * tmpvar_596) + 0.1938925) * tmpvar_596) - 0.3326756)
       * tmpvar_596) + 0.9999793) * tmpvar_595);
      tmpvar_596 = (tmpvar_596 + (float(
        (abs((uv_592.x / uv_592.y)) > 1.0)
      ) * (
        (tmpvar_596 * -2.0)
       + 1.570796)));
      tmpvar_594 = (tmpvar_596 * sign((uv_592.x / uv_592.y)));
      if ((abs(uv_592.y) > (1e-08 * abs(uv_592.x)))) {
        if ((uv_592.y < 0.0)) {
          if ((uv_592.x >= 0.0)) {
            tmpvar_594 += 3.141593;
          } else {
            tmpvar_594 = (tmpvar_594 - 3.141593);
          };
        };
      } else {
        tmpvar_594 = (sign(uv_592.x) * 1.570796);
      };
      highp vec2 tmpvar_597;
      tmpvar_597.x = ((tmpvar_594 / 3.14158) * 2.0);
      tmpvar_597.y = sqrt(dot (uv_592, uv_592));
      uv_592 = tmpvar_597;
      float tmpvar_598;
      float tmpvar_599;
      tmpvar_599 = (u_time / 2.0);
      tmpvar_598 = clamp (((tmpvar_599 - 0.4) / 1.6), 0.0, 1.0);
      float tmpvar_600;
      tmpvar_600 = -((-4.084054 + (6.283159 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_598 * (tmpvar_598 * (3.0 - 
            (2.0 * tmpvar_598)
          ))))
        ))))
      )));
      float tmpvar_601;
      tmpvar_601 = clamp (((tmpvar_599 - 0.4) / 1.4), 0.0, 1.0);
      float tmpvar_602;
      tmpvar_602 = -((-2.293353 + (5.340685 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_601 * (tmpvar_601 * (3.0 - 
            (2.0 * tmpvar_601)
          ))))
        ))))
      )));
      highp float tmpvar_603;
      tmpvar_603 = clamp (((tmpvar_597.x - tmpvar_600) / (
        (0.1 + tmpvar_600)
       - tmpvar_600)), 0.0, 1.0);
      float edge0_604;
      edge0_604 = (1.52 + tmpvar_602);
      highp float tmpvar_605;
      tmpvar_605 = clamp (((tmpvar_597.x - edge0_604) / (
        (1.6201 + tmpvar_602)
       - edge0_604)), 0.0, 1.0);
      d_593 = ((tmpvar_603 * (tmpvar_603 * 
        (3.0 - (2.0 * tmpvar_603))
      )) * (tmpvar_605 * (tmpvar_605 * 
        (3.0 - (2.0 * tmpvar_605))
      )));
      highp float tmpvar_606;
      tmpvar_606 = clamp (((tmpvar_597.x - 2.003988) / -0.0999999), 0.0, 1.0);
      highp float tmpvar_607;
      tmpvar_607 = min (d_593, (tmpvar_606 * (tmpvar_606 * 
        (3.0 - (2.0 * tmpvar_606))
      )));
      d_593 = tmpvar_607;
      highp float tmpvar_608;
      tmpvar_608 = clamp (((
        abs((tmpvar_566 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp vec3 tmpvar_609;
      tmpvar_609 = mix (tmpvar_590, vec3(0.9960784, 0.4039216, 0.3882353), (tmpvar_607 * (1.0 - 
        (tmpvar_608 * (tmpvar_608 * (3.0 - (2.0 * tmpvar_608))))
      )));
      col_548 = tmpvar_609;
      highp vec2 uv_610;
      uv_610 = (uv_547 * mat2(-1.0, -1.30256e-05, 1.30256e-05, -1.0));
      highp float tmpvar_611;
      highp float tmpvar_612;
      tmpvar_612 = (min (abs(
        (uv_610.x / uv_610.y)
      ), 1.0) / max (abs(
        (uv_610.x / uv_610.y)
      ), 1.0));
      highp float tmpvar_613;
      tmpvar_613 = (tmpvar_612 * tmpvar_612);
      tmpvar_613 = (((
        ((((
          ((((-0.01213232 * tmpvar_613) + 0.05368138) * tmpvar_613) - 0.1173503)
         * tmpvar_613) + 0.1938925) * tmpvar_613) - 0.3326756)
       * tmpvar_613) + 0.9999793) * tmpvar_612);
      tmpvar_613 = (tmpvar_613 + (float(
        (abs((uv_610.x / uv_610.y)) > 1.0)
      ) * (
        (tmpvar_613 * -2.0)
       + 1.570796)));
      tmpvar_611 = (tmpvar_613 * sign((uv_610.x / uv_610.y)));
      if ((abs(uv_610.y) > (1e-08 * abs(uv_610.x)))) {
        if ((uv_610.y < 0.0)) {
          if ((uv_610.x >= 0.0)) {
            tmpvar_611 += 3.141593;
          } else {
            tmpvar_611 = (tmpvar_611 - 3.141593);
          };
        };
      } else {
        tmpvar_611 = (sign(uv_610.x) * 1.570796);
      };
      highp vec2 tmpvar_614;
      tmpvar_614.x = ((tmpvar_611 / 3.14158) * 2.0);
      tmpvar_614.y = sqrt(dot (uv_610, uv_610));
      uv_610 = tmpvar_614;
      float tmpvar_615;
      tmpvar_615 = clamp (((
        (u_time / 2.0)
       - 0.4) / 1.6), 0.0, 1.0);
      float tmpvar_616;
      tmpvar_616 = -((-4.084054 + (6.283159 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_615 * (tmpvar_615 * (3.0 - 
            (2.0 * tmpvar_615)
          ))))
        ))))
      )));
      highp float tmpvar_617;
      tmpvar_617 = clamp (((tmpvar_614.x - tmpvar_616) / (
        (0.01 + tmpvar_616)
       - tmpvar_616)), 0.0, 1.0);
      highp float tmpvar_618;
      tmpvar_618 = clamp (((
        abs((tmpvar_567 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp vec3 tmpvar_619;
      tmpvar_619 = mix (tmpvar_609, vec3(0.2862745, 0.06666667, 0.6117647), ((tmpvar_617 * 
        (tmpvar_617 * (3.0 - (2.0 * tmpvar_617)))
      ) * (1.0 - 
        (tmpvar_618 * (tmpvar_618 * (3.0 - (2.0 * tmpvar_618))))
      )));
      col_548 = tmpvar_619;
      highp vec2 uv_620;
      uv_620 = (uv_547 * mat2(-1.0, 1.30256e-05, -1.30256e-05, -1.0));
      highp float tmpvar_621;
      highp float tmpvar_622;
      tmpvar_622 = (min (abs(
        (uv_620.x / uv_620.y)
      ), 1.0) / max (abs(
        (uv_620.x / uv_620.y)
      ), 1.0));
      highp float tmpvar_623;
      tmpvar_623 = (tmpvar_622 * tmpvar_622);
      tmpvar_623 = (((
        ((((
          ((((-0.01213232 * tmpvar_623) + 0.05368138) * tmpvar_623) - 0.1173503)
         * tmpvar_623) + 0.1938925) * tmpvar_623) - 0.3326756)
       * tmpvar_623) + 0.9999793) * tmpvar_622);
      tmpvar_623 = (tmpvar_623 + (float(
        (abs((uv_620.x / uv_620.y)) > 1.0)
      ) * (
        (tmpvar_623 * -2.0)
       + 1.570796)));
      tmpvar_621 = (tmpvar_623 * sign((uv_620.x / uv_620.y)));
      if ((abs(uv_620.y) > (1e-08 * abs(uv_620.x)))) {
        if ((uv_620.y < 0.0)) {
          if ((uv_620.x >= 0.0)) {
            tmpvar_621 += 3.141593;
          } else {
            tmpvar_621 = (tmpvar_621 - 3.141593);
          };
        };
      } else {
        tmpvar_621 = (sign(uv_620.x) * 1.570796);
      };
      highp vec2 tmpvar_624;
      tmpvar_624.x = ((tmpvar_621 / 3.14158) * 2.0);
      tmpvar_624.y = sqrt(dot (uv_620, uv_620));
      uv_620 = tmpvar_624;
      float tmpvar_625;
      tmpvar_625 = clamp (((
        (u_time / 2.0)
       - 0.85) / 1.65), 0.0, 1.0);
      float tmpvar_626;
      tmpvar_626 = -((-4.084054 + (6.283159 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_625 * (tmpvar_625 * (3.0 - 
            (2.0 * tmpvar_625)
          ))))
        ))))
      )));
      highp float tmpvar_627;
      tmpvar_627 = clamp (((tmpvar_624.x - tmpvar_626) / (
        (0.01 + tmpvar_626)
       - tmpvar_626)), 0.0, 1.0);
      float edge0_628;
      edge0_628 = (0.01 - tmpvar_626);
      highp float tmpvar_629;
      tmpvar_629 = clamp (((tmpvar_624.x - edge0_628) / (
        -(tmpvar_626)
       - edge0_628)), 0.0, 1.0);
      highp float tmpvar_630;
      tmpvar_630 = clamp (((
        abs((tmpvar_568 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp vec3 tmpvar_631;
      tmpvar_631 = mix (tmpvar_619, vec3(0.2862745, 0.06666667, 0.6117647), ((
        (tmpvar_627 * (tmpvar_627 * (3.0 - (2.0 * tmpvar_627))))
       * 
        (tmpvar_629 * (tmpvar_629 * (3.0 - (2.0 * tmpvar_629))))
      ) * (1.0 - 
        (tmpvar_630 * (tmpvar_630 * (3.0 - (2.0 * tmpvar_630))))
      )));
      col_548 = tmpvar_631;
      highp vec2 uv_632;
      uv_632 = (uv_547 * mat2(-1.0, 1.30256e-05, -1.30256e-05, -1.0));
      highp float tmpvar_633;
      highp float tmpvar_634;
      tmpvar_634 = (min (abs(
        (uv_632.x / uv_632.y)
      ), 1.0) / max (abs(
        (uv_632.x / uv_632.y)
      ), 1.0));
      highp float tmpvar_635;
      tmpvar_635 = (tmpvar_634 * tmpvar_634);
      tmpvar_635 = (((
        ((((
          ((((-0.01213232 * tmpvar_635) + 0.05368138) * tmpvar_635) - 0.1173503)
         * tmpvar_635) + 0.1938925) * tmpvar_635) - 0.3326756)
       * tmpvar_635) + 0.9999793) * tmpvar_634);
      tmpvar_635 = (tmpvar_635 + (float(
        (abs((uv_632.x / uv_632.y)) > 1.0)
      ) * (
        (tmpvar_635 * -2.0)
       + 1.570796)));
      tmpvar_633 = (tmpvar_635 * sign((uv_632.x / uv_632.y)));
      if ((abs(uv_632.y) > (1e-08 * abs(uv_632.x)))) {
        if ((uv_632.y < 0.0)) {
          if ((uv_632.x >= 0.0)) {
            tmpvar_633 += 3.141593;
          } else {
            tmpvar_633 = (tmpvar_633 - 3.141593);
          };
        };
      } else {
        tmpvar_633 = (sign(uv_632.x) * 1.570796);
      };
      highp vec2 tmpvar_636;
      tmpvar_636.x = ((tmpvar_633 / 3.14158) * 2.0);
      tmpvar_636.y = sqrt(dot (uv_632, uv_632));
      uv_632 = tmpvar_636;
      float tmpvar_637;
      tmpvar_637 = clamp (((
        (u_time / 2.0)
       - 1.85) / 0.65), 0.0, 1.0);
      highp float tmpvar_638;
      tmpvar_638 = clamp (((
        abs((tmpvar_569 - 0.5))
       - 0.01) / 0.002), 0.0, 1.0);
      highp float tmpvar_639;
      tmpvar_639 = clamp (((uv_4.y - -0.5) / 0.00999999), 0.0, 1.0);
      col_548 = (mix (tmpvar_631, vec3(0.8392157, 0.8588235, 0.827451), (
        (((float(mod ((
          abs((tmpvar_636.x - 20.5))
         * 6.0), 2.0))) * (float(mod ((
          (tmpvar_636.x + 20.5)
         * 6.0), 2.0)))) * cos((1.57079 - (1.57079 * 
          sin((1.57079 * (tmpvar_637 * (tmpvar_637 * 
            (3.0 - (2.0 * tmpvar_637))
          ))))
        ))))
       * 
        (1.0 - (tmpvar_638 * (tmpvar_638 * (3.0 - 
          (2.0 * tmpvar_638)
        ))))
      )) * (tmpvar_639 * (tmpvar_639 * 
        (3.0 - (2.0 * tmpvar_639))
      )));
      if ((u_time > 4.0)) {
        highp vec3 colx_640;
        colx_640 = col_548;
        col_548 = (vec3(0.01678431, 0.01717647, 0.01654902) / abs((tmpvar_565 - 0.5)));
        mat2 tmpvar_641;
        tmpvar_641[uint(0)].x = cos(rot_550);
        tmpvar_641[uint(0)].y = -(sin(rot_550));
        tmpvar_641[1u].x = sin(rot_550);
        tmpvar_641[1u].y = cos(rot_550);
        highp vec2 uv_642;
        uv_642 = (uv_547 * tmpvar_641);
        highp float d_643;
        uv_642 = (uv_642 * mat2(6.5128e-06, -1.0, 1.0, 6.5128e-06));
        highp float tmpvar_644;
        highp float tmpvar_645;
        tmpvar_645 = (min (abs(
          (uv_642.x / uv_642.y)
        ), 1.0) / max (abs(
          (uv_642.x / uv_642.y)
        ), 1.0));
        highp float tmpvar_646;
        tmpvar_646 = (tmpvar_645 * tmpvar_645);
        tmpvar_646 = (((
          ((((
            ((((-0.01213232 * tmpvar_646) + 0.05368138) * tmpvar_646) - 0.1173503)
           * tmpvar_646) + 0.1938925) * tmpvar_646) - 0.3326756)
         * tmpvar_646) + 0.9999793) * tmpvar_645);
        tmpvar_646 = (tmpvar_646 + (float(
          (abs((uv_642.x / uv_642.y)) > 1.0)
        ) * (
          (tmpvar_646 * -2.0)
         + 1.570796)));
        tmpvar_644 = (tmpvar_646 * sign((uv_642.x / uv_642.y)));
        if ((abs(uv_642.y) > (1e-08 * abs(uv_642.x)))) {
          if ((uv_642.y < 0.0)) {
            if ((uv_642.x >= 0.0)) {
              tmpvar_644 += 3.141593;
            } else {
              tmpvar_644 = (tmpvar_644 - 3.141593);
            };
          };
        } else {
          tmpvar_644 = (sign(uv_642.x) * 1.570796);
        };
        highp vec2 tmpvar_647;
        tmpvar_647.x = ((tmpvar_644 / 3.14158) * 2.0);
        tmpvar_647.y = sqrt(dot (uv_642, uv_642));
        uv_642 = tmpvar_647;
        float tmpvar_648;
        float tmpvar_649;
        tmpvar_649 = (u_time / 2.0);
        tmpvar_648 = clamp (((tmpvar_649 - 0.4) / 1.6), 0.0, 1.0);
        float tmpvar_650;
        tmpvar_650 = -((-4.084054 + (6.283159 * 
          cos((1.57079 - (1.57079 * sin(
            (1.57079 * (tmpvar_648 * (tmpvar_648 * (3.0 - 
              (2.0 * tmpvar_648)
            ))))
          ))))
        )));
        float tmpvar_651;
        tmpvar_651 = clamp (((tmpvar_649 - 0.4) / 1.4), 0.0, 1.0);
        float tmpvar_652;
        tmpvar_652 = -((-2.293353 + (5.340685 * 
          cos((1.57079 - (1.57079 * sin(
            (1.57079 * (tmpvar_651 * (tmpvar_651 * (3.0 - 
              (2.0 * tmpvar_651)
            ))))
          ))))
        )));
        highp float tmpvar_653;
        tmpvar_653 = clamp (((tmpvar_647.x - tmpvar_650) / (
          (0.1 + tmpvar_650)
         - tmpvar_650)), 0.0, 1.0);
        float edge0_654;
        edge0_654 = (1.52 + tmpvar_652);
        highp float tmpvar_655;
        tmpvar_655 = clamp (((tmpvar_647.x - edge0_654) / (
          (1.6201 + tmpvar_652)
         - edge0_654)), 0.0, 1.0);
        d_643 = ((tmpvar_653 * (tmpvar_653 * 
          (3.0 - (2.0 * tmpvar_653))
        )) * (tmpvar_655 * (tmpvar_655 * 
          (3.0 - (2.0 * tmpvar_655))
        )));
        highp float tmpvar_656;
        tmpvar_656 = clamp (((tmpvar_647.x - 2.003988) / -0.0999999), 0.0, 1.0);
        highp float tmpvar_657;
        tmpvar_657 = min (d_643, (tmpvar_656 * (tmpvar_656 * 
          (3.0 - (2.0 * tmpvar_656))
        )));
        d_643 = tmpvar_657;
        highp vec3 tmpvar_658;
        tmpvar_658 = max (max (max (col_548, 
          ((vec3(0.02988235, 0.01211765, 0.01164706) * tmpvar_657) / abs((tmpvar_566 - 0.5)))
        ), (vec3(0.01717647, 0.004, 0.03670588) / 
          abs((tmpvar_567 - 0.5))
        )), (vec3(0.02290196, 0.005333333, 0.04894118) / abs(
          (tmpvar_568 - 0.5)
        )));
        col_548 = tmpvar_658;
        highp float tmpvar_659;
        highp float tmpvar_660;
        tmpvar_660 = clamp (((
          abs((tmpvar_569 - 0.5))
         - 0.01) / 0.11), 0.0, 1.0);
        tmpvar_659 = (tmpvar_660 * (tmpvar_660 * (3.0 - 
          (2.0 * tmpvar_660)
        )));
        highp vec2 uv_661;
        uv_661 = (uv_547 * mat2(-1.0, 1.30256e-05, -1.30256e-05, -1.0));
        highp float tmpvar_662;
        highp float tmpvar_663;
        tmpvar_663 = (min (abs(
          (uv_661.x / uv_661.y)
        ), 1.0) / max (abs(
          (uv_661.x / uv_661.y)
        ), 1.0));
        highp float tmpvar_664;
        tmpvar_664 = (tmpvar_663 * tmpvar_663);
        tmpvar_664 = (((
          ((((
            ((((-0.01213232 * tmpvar_664) + 0.05368138) * tmpvar_664) - 0.1173503)
           * tmpvar_664) + 0.1938925) * tmpvar_664) - 0.3326756)
         * tmpvar_664) + 0.9999793) * tmpvar_663);
        tmpvar_664 = (tmpvar_664 + (float(
          (abs((uv_661.x / uv_661.y)) > 1.0)
        ) * (
          (tmpvar_664 * -2.0)
         + 1.570796)));
        tmpvar_662 = (tmpvar_664 * sign((uv_661.x / uv_661.y)));
        if ((abs(uv_661.y) > (1e-08 * abs(uv_661.x)))) {
          if ((uv_661.y < 0.0)) {
            if ((uv_661.x >= 0.0)) {
              tmpvar_662 += 3.141593;
            } else {
              tmpvar_662 = (tmpvar_662 - 3.141593);
            };
          };
        } else {
          tmpvar_662 = (sign(uv_661.x) * 1.570796);
        };
        highp vec2 tmpvar_665;
        tmpvar_665.x = ((tmpvar_662 / 3.14158) * 2.0);
        tmpvar_665.y = sqrt(dot (uv_661, uv_661));
        uv_661 = tmpvar_665;
        float tmpvar_666;
        tmpvar_666 = clamp (((
          (u_time / 2.0)
         - 1.85) / 0.65), 0.0, 1.0);
        float tmpvar_667;
        float tmpvar_668;
        tmpvar_668 = (u_time - 4.0);
        tmpvar_667 = clamp ((tmpvar_668 / 2.5), 0.0, 1.0);
        float tmpvar_669;
        tmpvar_669 = clamp ((tmpvar_668 / 2.5), 0.0, 1.0);
        float edge0_670;
        edge0_670 = (0.01 + (tmpvar_667 * (tmpvar_667 * 
          (3.0 - (2.0 * tmpvar_667))
        )));
        highp float tmpvar_671;
        tmpvar_671 = clamp (((
          sqrt(dot (uv_547, uv_547))
         - edge0_670) / (
          (0.65 * (tmpvar_669 * (tmpvar_669 * (3.0 - 
            (2.0 * tmpvar_669)
          ))))
         - edge0_670)), 0.0, 1.0);
        highp float tmpvar_672;
        tmpvar_672 = clamp (((
          sqrt(dot (uv_547, uv_547))
         - 0.8) / -0.3), 0.0, 1.0);
        col_548 = (max (colx_640, (
          min (max (max (tmpvar_658, (
            ((1.0 - tmpvar_659) * (((float(mod (
              (abs((tmpvar_665.x - 20.5)) * 6.0)
            , 2.0))) * (float(mod (
              ((tmpvar_665.x + 20.5) * 6.0)
            , 2.0)))) * cos((1.57079 - 
              (1.57079 * sin((1.57079 * (tmpvar_666 * 
                (tmpvar_666 * (3.0 - (2.0 * tmpvar_666)))
              ))))
            ))))
           * 
            (vec3(0.02517647, 0.02576471, 0.02482353) / abs((tmpvar_569 - 0.5)))
          )), 0.0), 1.0)
         * 
          (tmpvar_671 * (tmpvar_671 * (3.0 - (2.0 * tmpvar_671))))
        )) * (tmpvar_672 * (tmpvar_672 * 
          (3.0 - (2.0 * tmpvar_672))
        )));
      };
      highp float tmpvar_673;
      tmpvar_673 = clamp (((
        abs(tmpvar_560)
       - 0.01) / 0.002), 0.0, 1.0);
      col_548 = clamp (max (col_548, (vec3(0.8392157, 0.8588235, 0.827451) * 
        (1.0 - (tmpvar_673 * (tmpvar_673 * (3.0 - 
          (2.0 * tmpvar_673)
        ))))
      )), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    } else {
      highp vec2 uv_674;
      uv_674 = (uv_4 * 0.85);
      highp float n_675;
      highp float nx_676;
      highp vec3 coord_677;
      highp vec3 tmpvar_678;
      tmpvar_678.xy = (uv_674 * 5.0);
      tmpvar_678.z = (u_time * 0.25);
      coord_677 = tmpvar_678;
      highp float tmpvar_679;
      highp float tmpvar_680;
      tmpvar_680 = (min (abs(
        (uv_674.x / uv_674.y)
      ), 1.0) / max (abs(
        (uv_674.x / uv_674.y)
      ), 1.0));
      highp float tmpvar_681;
      tmpvar_681 = (tmpvar_680 * tmpvar_680);
      tmpvar_681 = (((
        ((((
          ((((-0.01213232 * tmpvar_681) + 0.05368138) * tmpvar_681) - 0.1173503)
         * tmpvar_681) + 0.1938925) * tmpvar_681) - 0.3326756)
       * tmpvar_681) + 0.9999793) * tmpvar_680);
      tmpvar_681 = (tmpvar_681 + (float(
        (abs((uv_674.x / uv_674.y)) > 1.0)
      ) * (
        (tmpvar_681 * -2.0)
       + 1.570796)));
      tmpvar_679 = (tmpvar_681 * sign((uv_674.x / uv_674.y)));
      if ((abs(uv_674.y) > (1e-08 * abs(uv_674.x)))) {
        if ((uv_674.y < 0.0)) {
          if ((uv_674.x >= 0.0)) {
            tmpvar_679 += 3.141593;
          } else {
            tmpvar_679 = (tmpvar_679 - 3.141593);
          };
        };
      } else {
        tmpvar_679 = (sign(uv_674.x) * 1.570796);
      };
      highp vec3 tmpvar_682;
      tmpvar_682.z = 0.5;
      tmpvar_682.x = ((tmpvar_679 / 6.2832) + 0.5);
      tmpvar_682.y = (sqrt(dot (uv_674, uv_674)) * 0.4);
      vec3 tmpvar_683;
      tmpvar_683.x = 0.0;
      tmpvar_683.y = (u_time * 0.05);
      tmpvar_683.z = (u_time * 0.01);
      coord_677 = (tmpvar_682 + tmpvar_683);
      highp vec3 uv_684;
      highp vec3 f_685;
      uv_684 = (coord_677 * 16.0);
      highp vec3 tmpvar_686;
      tmpvar_686 = (floor((vec3(mod (uv_684, 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_687;
      tmpvar_687 = (floor((vec3(mod (
        (uv_684 + vec3(1.0, 1.0, 1.0))
      , 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_688;
      tmpvar_688 = fract(uv_684);
      f_685 = ((tmpvar_688 * tmpvar_688) * (3.0 - (2.0 * tmpvar_688)));
      highp vec4 tmpvar_689;
      tmpvar_689.x = ((tmpvar_686.x + tmpvar_686.y) + tmpvar_686.z);
      tmpvar_689.y = ((tmpvar_687.x + tmpvar_686.y) + tmpvar_686.z);
      tmpvar_689.z = ((tmpvar_686.x + tmpvar_687.y) + tmpvar_686.z);
      tmpvar_689.w = ((tmpvar_687.x + tmpvar_687.y) + tmpvar_686.z);
      highp vec4 tmpvar_690;
      tmpvar_690 = fract((sin(
        (tmpvar_689 * 0.1)
      ) * 1000.0));
      highp vec4 tmpvar_691;
      tmpvar_691 = fract((sin(
        (((tmpvar_689 + tmpvar_687.z) - tmpvar_686.z) * 0.1)
      ) * 1000.0));
      highp vec3 uv_692;
      uv_692 = (coord_677 * 2.0);
      highp vec3 f_693;
      uv_692 = (uv_692 * 16.0);
      highp vec3 tmpvar_694;
      tmpvar_694 = (floor((vec3(mod (uv_692, 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_695;
      tmpvar_695 = (floor((vec3(mod (
        (uv_692 + vec3(1.0, 1.0, 1.0))
      , 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_696;
      tmpvar_696 = fract(uv_692);
      f_693 = ((tmpvar_696 * tmpvar_696) * (3.0 - (2.0 * tmpvar_696)));
      highp vec4 tmpvar_697;
      tmpvar_697.x = ((tmpvar_694.x + tmpvar_694.y) + tmpvar_694.z);
      tmpvar_697.y = ((tmpvar_695.x + tmpvar_694.y) + tmpvar_694.z);
      tmpvar_697.z = ((tmpvar_694.x + tmpvar_695.y) + tmpvar_694.z);
      tmpvar_697.w = ((tmpvar_695.x + tmpvar_695.y) + tmpvar_694.z);
      highp vec4 tmpvar_698;
      tmpvar_698 = fract((sin(
        (tmpvar_697 * 0.1)
      ) * 1000.0));
      highp vec4 tmpvar_699;
      tmpvar_699 = fract((sin(
        (((tmpvar_697 + tmpvar_695.z) - tmpvar_694.z) * 0.1)
      ) * 1000.0));
      highp float tmpvar_700;
      tmpvar_700 = (0.5 * abs((
        (mix (mix (mix (tmpvar_698.x, tmpvar_698.y, f_693.x), mix (tmpvar_698.z, tmpvar_698.w, f_693.x), f_693.y), mix (mix (tmpvar_699.x, tmpvar_699.y, f_693.x), mix (tmpvar_699.z, tmpvar_699.w, f_693.x), f_693.y), f_693.z) * 2.0)
       - 1.0)));
      highp vec3 uv_701;
      uv_701 = (coord_677 * 4.0);
      highp vec3 f_702;
      uv_701 = (uv_701 * 16.0);
      highp vec3 tmpvar_703;
      tmpvar_703 = (floor((vec3(mod (uv_701, 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_704;
      tmpvar_704 = (floor((vec3(mod (
        (uv_701 + vec3(1.0, 1.0, 1.0))
      , 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_705;
      tmpvar_705 = fract(uv_701);
      f_702 = ((tmpvar_705 * tmpvar_705) * (3.0 - (2.0 * tmpvar_705)));
      highp vec4 tmpvar_706;
      tmpvar_706.x = ((tmpvar_703.x + tmpvar_703.y) + tmpvar_703.z);
      tmpvar_706.y = ((tmpvar_704.x + tmpvar_703.y) + tmpvar_703.z);
      tmpvar_706.z = ((tmpvar_703.x + tmpvar_704.y) + tmpvar_703.z);
      tmpvar_706.w = ((tmpvar_704.x + tmpvar_704.y) + tmpvar_703.z);
      highp vec4 tmpvar_707;
      tmpvar_707 = fract((sin(
        (tmpvar_706 * 0.1)
      ) * 1000.0));
      highp vec4 tmpvar_708;
      tmpvar_708 = fract((sin(
        (((tmpvar_706 + tmpvar_704.z) - tmpvar_703.z) * 0.1)
      ) * 1000.0));
      highp float tmpvar_709;
      tmpvar_709 = (0.25 * abs((
        (mix (mix (mix (tmpvar_707.x, tmpvar_707.y, f_702.x), mix (tmpvar_707.z, tmpvar_707.w, f_702.x), f_702.y), mix (mix (tmpvar_708.x, tmpvar_708.y, f_702.x), mix (tmpvar_708.z, tmpvar_708.w, f_702.x), f_702.y), f_702.z) * 2.0)
       - 1.0)));
      highp vec3 uv_710;
      uv_710 = (coord_677 * 6.0);
      highp vec3 f_711;
      uv_710 = (uv_710 * 16.0);
      highp vec3 tmpvar_712;
      tmpvar_712 = (floor((vec3(mod (uv_710, 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_713;
      tmpvar_713 = (floor((vec3(mod (
        (uv_710 + vec3(1.0, 1.0, 1.0))
      , 16.0)))) * vec3(1.0, 100.0, 1000.0));
      highp vec3 tmpvar_714;
      tmpvar_714 = fract(uv_710);
      f_711 = ((tmpvar_714 * tmpvar_714) * (3.0 - (2.0 * tmpvar_714)));
      highp vec4 tmpvar_715;
      tmpvar_715.x = ((tmpvar_712.x + tmpvar_712.y) + tmpvar_712.z);
      tmpvar_715.y = ((tmpvar_713.x + tmpvar_712.y) + tmpvar_712.z);
      tmpvar_715.z = ((tmpvar_712.x + tmpvar_713.y) + tmpvar_712.z);
      tmpvar_715.w = ((tmpvar_713.x + tmpvar_713.y) + tmpvar_712.z);
      highp vec4 tmpvar_716;
      tmpvar_716 = fract((sin(
        (tmpvar_715 * 0.1)
      ) * 1000.0));
      highp vec4 tmpvar_717;
      tmpvar_717 = fract((sin(
        (((tmpvar_715 + tmpvar_713.z) - tmpvar_712.z) * 0.1)
      ) * 1000.0));
      highp float tmpvar_718;
      tmpvar_718 = (0.125 * abs((
        (mix (mix (mix (tmpvar_716.x, tmpvar_716.y, f_711.x), mix (tmpvar_716.z, tmpvar_716.w, f_711.x), f_711.y), mix (mix (tmpvar_717.x, tmpvar_717.y, f_711.x), mix (tmpvar_717.z, tmpvar_717.w, f_711.x), f_711.y), f_711.z) * 2.0)
       - 1.0)));
      nx_676 = (abs((
        (mix (mix (mix (tmpvar_690.x, tmpvar_690.y, f_685.x), mix (tmpvar_690.z, tmpvar_690.w, f_685.x), f_685.y), mix (mix (tmpvar_691.x, tmpvar_691.y, f_685.x), mix (tmpvar_691.z, tmpvar_691.w, f_685.x), f_685.y), f_685.z) * 2.0)
       - 1.0)) + ((tmpvar_700 + tmpvar_709) + tmpvar_718));
      highp vec2 uv_719;
      uv_719 = (uv_674 * 3.0);
      highp float tmpvar_720;
      tmpvar_720 = clamp (((
        (abs((sqrt(
          dot (uv_719, uv_719)
        ) - 1.0)) - 0.081)
       - -0.25) / 1.05), 0.0, 1.0);
      highp vec2 uv_721;
      uv_721 = (uv_674 * 3.0);
      highp float tmpvar_722;
      tmpvar_722 = clamp (((
        ((sqrt(dot (uv_721, uv_721)) - 0.3) - 0.011)
       - -0.24645) / 1.52645), 0.0, 1.0);
      highp float tmpvar_723;
      tmpvar_723 = min ((2.0 * (tmpvar_720 * 
        (tmpvar_720 * (3.0 - (2.0 * tmpvar_720)))
      )), (tmpvar_722 * (tmpvar_722 * 
        (3.0 - (2.0 * tmpvar_722))
      )));
      n_675 = ((nx_676 * tmpvar_723) * 94.942);
      n_675 = (n_675 * (tmpvar_723 / 1.105121));
      colx = (vec3(0.05, 0.18125, 0.27) + (vec3(0.2, 0.725, 1.08) * (0.5 + 
        (0.5 * cos(((u_time + uv_674.xyx) + vec3(0.0, 2.0, 4.0))))
      )));
      highp vec3 tmpvar_724;
      tmpvar_724.x = (nx_676 - tmpvar_700);
      tmpvar_724.y = (-(tmpvar_709) + nx_676);
      tmpvar_724.z = (-(tmpvar_718) + nx_676);
      colx = (colx * (0.2 / tmpvar_724));
      highp vec3 tmpvar_725;
      tmpvar_725 = (colx / n_675);
      highp vec3 tmpvar_726;
      tmpvar_726 = (clamp (abs(
        pow ((min (vec3(1.0, 1.0, 1.0), (tmpvar_725 * tmpvar_725)) * (1.0 - (0.9 * tmpvar_723))), vec3(0.24545, 0.24545, 0.24545))
      ), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)) * ppower);
      highp vec3 tmpvar_727;
      tmpvar_727 = clamp ((vec3(0.01678431, 0.01717647, 0.01654902) / abs(
        ((tmpvar_565 + ((tmpvar_567 * tmpvar_726.x) / 4.0)) - 0.5)
      )), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
      mat2 tmpvar_728;
      tmpvar_728[uint(0)].x = cos(rot2_549);
      tmpvar_728[uint(0)].y = -(sin(rot2_549));
      tmpvar_728[1u].x = sin(rot2_549);
      tmpvar_728[1u].y = cos(rot2_549);
      highp vec2 uv_729;
      uv_729 = (uv_547 * tmpvar_728);
      highp float tmpvar_730;
      highp float tmpvar_731;
      tmpvar_731 = (min (abs(
        (uv_729.x / uv_729.y)
      ), 1.0) / max (abs(
        (uv_729.x / uv_729.y)
      ), 1.0));
      highp float tmpvar_732;
      tmpvar_732 = (tmpvar_731 * tmpvar_731);
      tmpvar_732 = (((
        ((((
          ((((-0.01213232 * tmpvar_732) + 0.05368138) * tmpvar_732) - 0.1173503)
         * tmpvar_732) + 0.1938925) * tmpvar_732) - 0.3326756)
       * tmpvar_732) + 0.9999793) * tmpvar_731);
      tmpvar_732 = (tmpvar_732 + (float(
        (abs((uv_729.x / uv_729.y)) > 1.0)
      ) * (
        (tmpvar_732 * -2.0)
       + 1.570796)));
      tmpvar_730 = (tmpvar_732 * sign((uv_729.x / uv_729.y)));
      if ((abs(uv_729.y) > (1e-08 * abs(uv_729.x)))) {
        if ((uv_729.y < 0.0)) {
          if ((uv_729.x >= 0.0)) {
            tmpvar_730 += 3.141593;
          } else {
            tmpvar_730 = (tmpvar_730 - 3.141593);
          };
        };
      } else {
        tmpvar_730 = (sign(uv_729.x) * 1.570796);
      };
      highp vec2 tmpvar_733;
      tmpvar_733.x = ((tmpvar_730 / 3.14158) * 2.0);
      tmpvar_733.y = sqrt(dot (uv_729, uv_729));
      uv_729.y = tmpvar_733.y;
      uv_729.x = (float(mod (tmpvar_733.x, 1.000527)));
      float tmpvar_734;
      tmpvar_734 = clamp (((u_time - 7.5) / -0.5), 0.0, 1.0);
      float tmpvar_735;
      tmpvar_735 = (0.5 * (tmpvar_734 * (tmpvar_734 * 
        (3.0 - (2.0 * tmpvar_734))
      )));
      float edge0_736;
      edge0_736 = -(tmpvar_735);
      highp float tmpvar_737;
      tmpvar_737 = clamp (((uv_729.x - edge0_736) / (
        (0.1 - tmpvar_735)
       - edge0_736)), 0.0, 1.0);
      float edge0_738;
      edge0_738 = (1.000527 + tmpvar_735);
      highp float tmpvar_739;
      tmpvar_739 = clamp (((uv_729.x - edge0_738) / (
        (0.9 + tmpvar_735)
       - edge0_738)), 0.0, 1.0);
      col_548 = (tmpvar_727 * ((tmpvar_737 * 
        (tmpvar_737 * (3.0 - (2.0 * tmpvar_737)))
      ) * (tmpvar_739 * 
        (tmpvar_739 * (3.0 - (2.0 * tmpvar_739)))
      )));
      mat2 tmpvar_740;
      tmpvar_740[uint(0)].x = cos(rot_550);
      tmpvar_740[uint(0)].y = -(sin(rot_550));
      tmpvar_740[1u].x = sin(rot_550);
      tmpvar_740[1u].y = cos(rot_550);
      highp vec2 uv_741;
      uv_741 = (uv_547 * tmpvar_740);
      highp float d_742;
      uv_741 = (uv_741 * mat2(6.5128e-06, -1.0, 1.0, 6.5128e-06));
      highp float tmpvar_743;
      highp float tmpvar_744;
      tmpvar_744 = (min (abs(
        (uv_741.x / uv_741.y)
      ), 1.0) / max (abs(
        (uv_741.x / uv_741.y)
      ), 1.0));
      highp float tmpvar_745;
      tmpvar_745 = (tmpvar_744 * tmpvar_744);
      tmpvar_745 = (((
        ((((
          ((((-0.01213232 * tmpvar_745) + 0.05368138) * tmpvar_745) - 0.1173503)
         * tmpvar_745) + 0.1938925) * tmpvar_745) - 0.3326756)
       * tmpvar_745) + 0.9999793) * tmpvar_744);
      tmpvar_745 = (tmpvar_745 + (float(
        (abs((uv_741.x / uv_741.y)) > 1.0)
      ) * (
        (tmpvar_745 * -2.0)
       + 1.570796)));
      tmpvar_743 = (tmpvar_745 * sign((uv_741.x / uv_741.y)));
      if ((abs(uv_741.y) > (1e-08 * abs(uv_741.x)))) {
        if ((uv_741.y < 0.0)) {
          if ((uv_741.x >= 0.0)) {
            tmpvar_743 += 3.141593;
          } else {
            tmpvar_743 = (tmpvar_743 - 3.141593);
          };
        };
      } else {
        tmpvar_743 = (sign(uv_741.x) * 1.570796);
      };
      highp vec2 tmpvar_746;
      tmpvar_746.x = ((tmpvar_743 / 3.14158) * 2.0);
      tmpvar_746.y = sqrt(dot (uv_741, uv_741));
      uv_741 = tmpvar_746;
      float tmpvar_747;
      float tmpvar_748;
      tmpvar_748 = (u_time / 2.0);
      tmpvar_747 = clamp (((tmpvar_748 - 0.4) / 1.6), 0.0, 1.0);
      float tmpvar_749;
      tmpvar_749 = -((-4.084054 + (6.283159 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_747 * (tmpvar_747 * (3.0 - 
            (2.0 * tmpvar_747)
          ))))
        ))))
      )));
      float tmpvar_750;
      tmpvar_750 = clamp (((tmpvar_748 - 0.4) / 1.4), 0.0, 1.0);
      float tmpvar_751;
      tmpvar_751 = -((-2.293353 + (5.340685 * 
        cos((1.57079 - (1.57079 * sin(
          (1.57079 * (tmpvar_750 * (tmpvar_750 * (3.0 - 
            (2.0 * tmpvar_750)
          ))))
        ))))
      )));
      highp float tmpvar_752;
      tmpvar_752 = clamp (((tmpvar_746.x - tmpvar_749) / (
        (0.1 + tmpvar_749)
       - tmpvar_749)), 0.0, 1.0);
      float edge0_753;
      edge0_753 = (1.52 + tmpvar_751);
      highp float tmpvar_754;
      tmpvar_754 = clamp (((tmpvar_746.x - edge0_753) / (
        (1.6201 + tmpvar_751)
       - edge0_753)), 0.0, 1.0);
      d_742 = ((tmpvar_752 * (tmpvar_752 * 
        (3.0 - (2.0 * tmpvar_752))
      )) * (tmpvar_754 * (tmpvar_754 * 
        (3.0 - (2.0 * tmpvar_754))
      )));
      highp float tmpvar_755;
      tmpvar_755 = clamp (((tmpvar_746.x - 2.003988) / -0.0999999), 0.0, 1.0);
      highp float tmpvar_756;
      tmpvar_756 = min (d_742, (tmpvar_755 * (tmpvar_755 * 
        (3.0 - (2.0 * tmpvar_755))
      )));
      d_742 = tmpvar_756;
      highp vec3 tmpvar_757;
      tmpvar_757 = max (max (clamp (
        max (col_548, (((tmpvar_756 * vec3(0.9960784, 0.4039216, 0.3882353)) * (0.03 + 
          (0.03 * ppower)
        )) / abs((
          (tmpvar_566 + (tmpvar_726.x / 3.5))
         - 0.5))))
      , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), clamp (
        ((((vec3(0.2862745, 0.06666667, 0.6117647) * 
          float((((0.8 * ajcd) - 0.4) >= uv_547.y))
        ) + (vec3(0.09035433, 0.2228155, 0.2318182) * 
          float((((0.8 * ajcd2) - 0.4) >= uv_547.y))
        )) * 0.06) / abs((tmpvar_567 - 0.5)))
      , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0))), ((vec3(0.2862745, 0.06666667, 0.6117647) * 
        (0.08 + (tmpvar_726 / 5.0))
      ) / abs(
        ((tmpvar_568 - ((tmpvar_568 * tmpvar_726) / 10.0)) - 0.5)
      )));
      col_548 = tmpvar_757;
      highp float tmpvar_758;
      highp float tmpvar_759;
      tmpvar_759 = clamp (((
        abs((tmpvar_569 - 0.5))
       - 0.01) / 0.11), 0.0, 1.0);
      tmpvar_758 = (tmpvar_759 * (tmpvar_759 * (3.0 - 
        (2.0 * tmpvar_759)
      )));
      mat2 tmpvar_760;
      tmpvar_760[uint(0)].x = cos((rot2_549 * 2.8));
      tmpvar_760[uint(0)].y = -(sin((rot2_549 * 2.8)));
      tmpvar_760[1u].x = sin((rot2_549 * 2.8));
      tmpvar_760[1u].y = cos((rot2_549 * 2.8));
      highp vec2 uv_761;
      uv_761 = (uv_547 * tmpvar_760);
      uv_761 = (uv_761 * mat2(-1.0, 1.30256e-05, -1.30256e-05, -1.0));
      highp float tmpvar_762;
      highp float tmpvar_763;
      tmpvar_763 = (min (abs(
        (uv_761.x / uv_761.y)
      ), 1.0) / max (abs(
        (uv_761.x / uv_761.y)
      ), 1.0));
      highp float tmpvar_764;
      tmpvar_764 = (tmpvar_763 * tmpvar_763);
      tmpvar_764 = (((
        ((((
          ((((-0.01213232 * tmpvar_764) + 0.05368138) * tmpvar_764) - 0.1173503)
         * tmpvar_764) + 0.1938925) * tmpvar_764) - 0.3326756)
       * tmpvar_764) + 0.9999793) * tmpvar_763);
      tmpvar_764 = (tmpvar_764 + (float(
        (abs((uv_761.x / uv_761.y)) > 1.0)
      ) * (
        (tmpvar_764 * -2.0)
       + 1.570796)));
      tmpvar_762 = (tmpvar_764 * sign((uv_761.x / uv_761.y)));
      if ((abs(uv_761.y) > (1e-08 * abs(uv_761.x)))) {
        if ((uv_761.y < 0.0)) {
          if ((uv_761.x >= 0.0)) {
            tmpvar_762 += 3.141593;
          } else {
            tmpvar_762 = (tmpvar_762 - 3.141593);
          };
        };
      } else {
        tmpvar_762 = (sign(uv_761.x) * 1.570796);
      };
      highp vec2 tmpvar_765;
      tmpvar_765.x = ((tmpvar_762 / 3.14158) * 2.0);
      tmpvar_765.y = sqrt(dot (uv_761, uv_761));
      uv_761 = tmpvar_765;
      float tmpvar_766;
      tmpvar_766 = clamp (((
        (u_time / 2.0)
       - 1.85) / 0.65), 0.0, 1.0);
      highp float tmpvar_767;
      tmpvar_767 = clamp (((
        sqrt(dot (uv_547, uv_547))
       - 0.8) / -0.3), 0.0, 1.0);
      col_548 = (clamp (max (tmpvar_757, 
        (((1.0 - tmpvar_758) * ((
          (float(mod ((abs((tmpvar_765.x - 20.5)) * 6.0), 2.0)))
         * 
          (float(mod (((tmpvar_765.x + 20.5) * 6.0), 2.0)))
        ) * cos(
          (1.57079 - (1.57079 * sin((1.57079 * 
            (tmpvar_766 * (tmpvar_766 * (3.0 - (2.0 * tmpvar_766))))
          ))))
        ))) * (tmpvar_726 + (vec3(0.02517647, 0.02576471, 0.02482353) / abs(
          ((tmpvar_569 - (tmpvar_726.x / 5.0)) - 0.5)
        ))))
      ), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)) * (tmpvar_767 * (tmpvar_767 * 
        (3.0 - (2.0 * tmpvar_767))
      )));
    };
    highp vec4 tmpvar_768;
    tmpvar_768.xyz = col_548;
    tmpvar_768.w = max (max (col_548.x, col_548.y), col_548.z);
    fragColor_1 = (tmpvar_768 * tmpvar_768);
    tmpvar_11 = bool(1);
  };
  if (((u_rtime <= 25.0) && (shape_tile_l_2 != 10))) {
    float tmpvar_769;
    tmpvar_769 = clamp (((u_rtime - 23.0) / 2.0), 0.0, 1.0);
    highp float tmpvar_770;
    tmpvar_770 = clamp (((
      ((sqrt(dot (tmpvar_6, tmpvar_6)) - (2.0 * (tmpvar_769 * 
        (tmpvar_769 * (3.0 - (2.0 * tmpvar_769)))
      ))) + 0.5)
     - 0.5) / 0.012), 0.0, 1.0);
    fragColor_1.xyz = (fragColor_1.xyz * (1.0 - (tmpvar_770 * 
      (tmpvar_770 * (3.0 - (2.0 * tmpvar_770)))
    )));
  };
  glFragColor = fragColor_1;
}

