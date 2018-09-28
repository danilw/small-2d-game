#version 300 es
#ifdef GL_ES
precision highp float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform float u_time;
uniform int QUALITY;
out vec4 glFragColor;
uniform float ppower;
uniform float ppowerhitr;
uniform vec2 xshape_size;
uniform vec2 xshape_pos;

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iChannel1 u_texture2
#define iMouse u_mouse

// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw

#define DECAY  .974
#define EXPOSURE .24

int SAMPLES = 8;
float DENSITY = .8;
float WEIGHT = .38;
float ilval = 1.5;

#define iterBayerMat 1
#define bayer2x2(a) (4-(a).x-((a).y<<1))%4
//return bayer matris (bitwise operands for speed over compatibility)

float GetBayerFromCoordLevel(vec2 pixelpos) {
    ivec2 p = ivec2(pixelpos);
    int a = 0
            ;
    for (int i = 0; i < iterBayerMat; i++
            ) {
        a += bayer2x2(p >> (iterBayerMat - 1 - i)&1) << (2 * i);
    }
    return float(a) / float(2 << (iterBayerMat * 2 - 1));
}

float bayer2(vec2 a) {
    a = floor(a);
    return fract(dot(a, vec2(.5, a.y * .75)));
}

float bayer4(vec2 a) {
    return bayer2(.5 * a)*.25 + bayer2(a);
}

float bayer8(vec2 a) {
    return bayer4(.5 * a)*.25 + bayer2(a);
}

float bayer16(vec2 a) {
    return bayer4(.25 * a)*.0625 + bayer4(a);
}

float bayer32(vec2 a) {
    return bayer8(.25 * a)*.0625 + bayer4(a);
}

float bayer64(vec2 a) {
    return bayer8(.125 * a)*.015625 + bayer8(a);
}

float bayer128(vec2 a) {
    return bayer16(.125 * a)*.015625 + bayer8(a);
}
#define dither2(p)   (bayer2(  p)-.375      )
#define dither4(p)   (bayer4(  p)-.46875    )
#define dither8(p)   (bayer8(  p)-.4921875  )
#define dither16(p)  (bayer16( p)-.498046875)
#define dither32(p)  (bayer32( p)-.499511719)
#define dither64(p)  (bayer64( p)-.49987793 )
#define dither128(p) (bayer128(p)-.499969482)

float iib(vec2 u) {
    return dither128(u); //analytic bayer, base2
    return GetBayerFromCoordLevel(u * 999.); //iterative bayer 
    //optionally: instad just use bitmap of a bayer matrix: (LUT approach)
    //return texture(iChannel1,u/iChannelResolution[1].xy).x;
}

void init() {
    if (QUALITY == 1) {
        SAMPLES = 16;
        DENSITY = .93;
        WEIGHT = .38;
        ilval = .8;
    } else
        if (QUALITY == 3) {
        SAMPLES = 64;
        DENSITY = .97;
        WEIGHT = .25;
        ilval = .4;
    } else
        if (QUALITY == 2) {
        SAMPLES = 32;
        DENSITY = .95;
        WEIGHT = .25;
        ilval = .67;
    } else {
        SAMPLES = 8;
        DENSITY = .8;
        WEIGHT = .38;
        ilval = 1.35;
    }

}

vec3 textured_col(vec2 uv) {
    return texture(iChannel1, uv).rgb;
}

float dist(in vec2 uv, in vec2 p, in float level) {
    float h = level;
    uv = pow(abs(uv - p), vec2(h));
    return pow(uv.x + uv.y, 1. / h);
}

vec4 star(vec2 xy, vec2 point) {

    // Color
    vec3 col = vec3(0.0);
    float speed = 20.0;
    //point=vec2(0.);
    col = mix(vec3(0.0), vec3((sin(iTime / 2.) * 0.5 + 0.65), 0.5, 1.0), 2.0 / dist(xy, point, 5.0 * (0.5 * sin(iTime) + 0.55)) / 5.0);

    // Output to screen
    return vec4(col, 1.0);
}

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.

const vec3 white = vec3(0xdc, 0xe0, 0xd1) / float(0xff);
const vec3 dark = vec3(0x1a, 0x13, 0x21) / float(0xff);

const vec3 green = vec3(0x7f, 0xbe, 0x20) / float(0xff);
const vec3 green_l = vec3(0x92, 0xdb, 0x26) / float(0xff);

const vec3 ground1 = vec3(0xce, 0x98, 0x69) / float(0xff);
const vec3 ground2 = vec3(0xca, 0x8f, 0x5b) / float(0xff);
const vec3 ground3 = vec3(0xc1, 0x7f, 0x41) / float(0xff);

float circle(in vec2 uv, float r1, float r2, bool disk) {
    float w = 2.0 * fwidth(uv.x);
    float t = r1 - r2;
    float r = r1;

    if (!disk)
        return smoothstep(-w / 2.0, w / 2.0, abs(length(uv) - r) - t / 2.0);
    else
        return smoothstep(-w / 3.0, w / 3.0, (length(uv) - r));

}

float shape_CIRCLE(vec2 p, float r) {
    return length(p) - r + 0.5;
}

vec4 mi_sunwbg(vec2 uv) {
    float rayCount = 12.25;
    vec3 color1 = white * 1.5;
    vec3 color2 = dark;
    vec2 c = uv;
    c *= 1.;
    //c+=vec2(-0.2,-0.2);
    float iTime = iTime * 0.00152 + 0.018 * sin(iTime * 0.152);

    float angle = atan(c.y, c.x);
    float dist = length(c);

    angle /= (2. * PI);
    float mask = 1.;

    float distRound = (1.65 - ceil(dist * rayCount * .5 + .25)*.1);

    float time2 = (fract((dist) * rayCount * .5 + .25) > 0.5 ? -iTime : iTime) * (rayCount * 2. + 2. * distRound);
    float ngfract = fract(angle * round(rayCount / (distRound * distRound)) + time2 * .6);
    ngfract = abs(ngfract * 2. - 1.);
    ngfract *= fract(dist * rayCount) > .5 ? -1. : 1.;
    mask -= ceil(dist * rayCount + .5 + ngfract * .5)*.1;



    float b = 1. - circle(uv + vec2(0., 0.), 0.2242, 0.22, true);
    return vec4(max(dark, mix(vec3(0.5 * mix(vec3(.17, .0, .9)*.3, mix(color2, color1, mask), distRound))
            * smoothstep(01., 0.4, length(c)), white, b)), 1.);
}




// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#define res_          iResolution
#define time_         iTime
#define detail_steps_ 13

#define mod3_      vec3(.1031, .11369, .13787)

vec3 hash3_3(vec3 p3) {
    p3 = fract(p3 * mod3_);
    p3 += dot(p3, p3.yxz + 19.19);
    return -1. + 2. * fract(vec3((p3.x + p3.y) * p3.z, (p3.x + p3.z) * p3.y, (p3.y + p3.z) * p3.x));
}

float perlin_noise3(vec3 p) {
    vec3 pi = floor(p);
    vec3 pf = p - pi;

    vec3 w = pf * pf * (3. - 2. * pf);

    return mix(
            mix(
            mix(
            dot(pf - vec3(0, 0, 0), hash3_3(pi + vec3(0, 0, 0))),
            dot(pf - vec3(1, 0, 0), hash3_3(pi + vec3(1, 0, 0))),
            w.x),
            mix(
            dot(pf - vec3(0, 0, 1), hash3_3(pi + vec3(0, 0, 1))),
            dot(pf - vec3(1, 0, 1), hash3_3(pi + vec3(1, 0, 1))),
            w.x),
            w.z),
            mix(
            mix(
            dot(pf - vec3(0, 1, 0), hash3_3(pi + vec3(0, 1, 0))),
            dot(pf - vec3(1, 1, 0), hash3_3(pi + vec3(1, 1, 0))),
            w.x),
            mix(
            dot(pf - vec3(0, 1, 1), hash3_3(pi + vec3(0, 1, 1))),
            dot(pf - vec3(1, 1, 1), hash3_3(pi + vec3(1, 1, 1))),
            w.x),
            w.z),
            w.y);
}

float noise_sum_abs3(vec3 p) {
    float f = 0.;
    p = p * 3.;
    f += 1.0000 * abs(perlin_noise3(p));
    p = 2. * p;
    f += 0.5000 * abs(perlin_noise3(p));
    p = 3. * p;
    f += 0.2500 * abs(perlin_noise3(p));
    p = 4. * p;
    f += 0.1250 * abs(perlin_noise3(p));
    p = 5. * p;
    f += 0.0625 * abs(perlin_noise3(p));
    p = 6. * p;

    return f;
}

vec4 mi_expl(vec2 p) {
    //p*=4.2;

    float electric_density = .9;
    float electric_radius = length(p) - .4;

    float moving_coord = iTime / 15.; //+sin(velocity * time_) / .2 * cos(velocity * time_)
    vec3 electric_local_domain = vec3(p, moving_coord);
    float electric_field = electric_density * noise_sum_abs3(electric_local_domain);

    vec3 col = vec3(107, 148, 196) / 255.;
    col += (1. - (electric_field + electric_radius));

    col += 1. - 4.2 * electric_field;
    col = clamp(col,vec3(0.),vec3(1.));

    float alpha = 1.;
    return vec4(col, alpha);
}

vec4 exlp(vec2 uv) {
    if (ppowerhitr < 0.1)return vec4(0.);
    vec2 res = iResolution.xy / iResolution.y;
    uv += (xshape_pos.xy) / iResolution.y - res / 2.; //to box2d coords
    uv *= iResolution.y / xshape_size.y;
    float ce = shape_CIRCLE(uv, .5);
    ce = (smoothstep(0.0, 0.012, (ce - 0.5)));
    return ppowerhitr * ce * mi_expl(uv);
}

vec3 saturate(vec3 a) {
    return clamp(a, 0., 1.);
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float xRandom(float x) {
    return mod(x * 7241.6465 + 2130.465521, 64.984131);
}

float hash2(in vec2 p) {
    return fract(dot(sin(p.x * 591.32 + p.y * 154.077), cos(p.x * 391.32 + p.y * 49.077)));
}

float hash(vec2 p) {
    vec2 pos = fract(p / 128.) * 128. + vec2(-64.340622, -72.465622);
    return fract(dot(pos.xyx * pos.xyy, vec3(20.390625, 60.703125, 2.4281209)));
}

float noise(float y, float t) {
    vec2 fl = vec2(floor(y), floor(t));
    vec2 fr = vec2(fract(y), fract(t));
    float a = mix(hash(fl + vec2(0.0, 0.0)), hash(fl + vec2(1.0, 0.0)), fr.x);
    float b = mix(hash(fl + vec2(0.0, 1.0)), hash(fl + vec2(1.0, 1.0)), fr.x);
    return mix(a, b, fr.y);
}

float noise2(float y, float t) {
    vec2 fl = vec2(floor(y), floor(t));
    vec2 fr = vec2(fract(y), fract(t));
    float a = mix(hash2(fl + vec2(0.0, 0.0)), hash2(fl + vec2(1.0, 0.0)), fr.x);
    float b = mix(hash2(fl + vec2(0.0, 1.0)), hash2(fl + vec2(1.0, 1.0)), fr.x);
    return mix(a, b, fr.y);
}

float line(vec2 uv, float width, float center) {
    float b = (1. - smoothstep(.0, width / 2., (uv.y - center)))*1.; //abs
    float b2 = (1. - smoothstep(.0, 5. * width, (uv.y - center)))*.8; //abs
    return b; //+b2;
}



const vec3 red = vec3(0xa6, 0x36, 0x2c) / float(0xff);
const vec3 redw = vec3(0xfd, 0x8c, 0x77) / float(0xff);

#define MD(a) mat2(cos(a), -sin(a), sin(a), cos(a))
float animstart = 2.5;

vec3 strucb(vec2 uv) {
    float d = step(-0.14, uv.y) * step(uv.y, -0.127) * step(abs(uv.x + 0.19), 0.02);
    vec3 ret = vec3(0.);
    d = max(d, step(-0.14, uv.y)*(1. - circle(uv + vec2(0.225, 0.14), 0.02270, 0.35, true)));
    d = max(d, step(-0.14, uv.y)*(1. - circle(uv + vec2(0.165, 0.14), 0.02970, 0.35, true)));
    d = max(d, step(uv.y, -0.094) * step(-0.14, uv.y) * smoothstep(0.0031, 0.0008, abs(uv.x + 0.12)));
    d = max(d, step(uv.y, -0.115) * step(-0.14, uv.y) * smoothstep(0.0031, 0.0008, abs(uv.x + 0.1075)));
    ret = d*red;
    float tuvx = mod(uv.x, 0.006) - 0.003;
    d = step(-0.132, uv.y);
    d = step(abs(uv.x + 0.225), 0.015) * d * smoothstep(0.0031, 0.0005, abs(tuvx))*(1. - circle(uv + vec2(0.225, 0.143), 0.021970, 0.35, true));
    ret = mix(ret, redw * 1.25, d);
    tuvx = mod(uv.x - 0.093, 0.012) - 0.006;
    d = smoothstep(0.0061, 0.0035, abs(tuvx)) * step(abs(uv.y + 0.122), 0.00182);
    ret = mix(ret, white, d * step(abs(uv.x + 0.165), 0.0165));
    return ret * smoothstep(animstart + 2.2, animstart + 3.2, iTime); //anim sruct

}

vec3 postfx(vec2 uv, vec3 col, float reg) {
    vec3 ret = col + 1.5 * reg * ((rand(uv) - .5)*.07);
    ret = saturate(1.5 * ret);
    return ret;
}
#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.

float animendfade() {
    return smoothstep(animstart + 11.5, animstart + 9.5, iTime);
}

float animendfades() {
    return step(animstart + 9.5, iTime);
}

vec3 map(vec2 uv, float lt) {
    float d = (circle(uv, 0.32 * smoothstep(animstart - 1., animstart + 0.35, iTime), 0., true));

    vec3 tcol = d*dark;
    float a = 1. - circle(uv, 0.3542, 0.35, false);
    vec2 tuv = uv;
    float af = atan(tuv.x, tuv.y);
    float r = length(tuv)*0.75;
    tuv = vec2(af / TWO_PI, r);
    a *= step(tuv.x, -PI / 2. + PI * smoothstep(animstart + 2.5, animstart + 4.8, iTime)); //anim circle
    vec3 ret = max(tcol, a * (1. - lt) * redw);
    ret = max(ret, lt * dark);
    ret = max(ret, (1. - lt)*(1. - d) * red) * smoothstep(animstart - 1., animstart + 0.35, iTime);
    float b = 1. - circle(uv + vec2(0., 0.225 * smoothstep(animstart, animstart - 2., iTime)), 0.2242, 0.22, true);
    tuv = uv;
    //tuv*=MD(-0.05-0.2*smoothstep(-0.25,0.85,uv.x));;
    //tuv.y+= ((cos(.85*tuv.x))-.975);
    float tuvy = mod(tuv.y, 0.015) - 0.0075;
    float e = 1. - max(smoothstep(0.0005, 0.0031, abs(tuvy)), step(0.195, tuv.y) + step(tuv.y, 0.185) * step(0.165, tuv.y) +
            step(tuv.y, 0.14) * step(0.06, tuv.y) + step(tuv.y, 0.03) * step(0.015, tuv.y));
    //anim 1
    /*float di=floor(animstart+iTime*1.5); //anim
    di+=di>1.?1.:0.;
    di+=di>4.?5.:0.;
    di+=di>11.?1.:0.;
    float ir=mod(animstart+iTime*1.5,1.); //anim
    e*=1.-(max(step((-uv.y+di*(1.*0.015)+0.0075),0.0075),
           step(ir-0.5,uv.x)*step(abs(uv.y-di*(1.*0.015)+0.0075),0.0075)));*/

    //anim 2
    float di = smoothstep(animstart + 4.5, animstart + 6.5, iTime); //anim
    float di2 = smoothstep(animstart + 8.5, animstart + 9.5, iTime);
    e *= step(uv.x + 1.5 * uv.y * (1. - di), di - 0.5);
    e *= step(di2 - .5, uv.x - 2. * uv.y * (1. - di2));

    e = (1. - e)*(b);
    ret = max(ret, (1. - lt) * e * white);
    float c = 1. - circle(uv, 0.3542, 0.35, true);
    tuvy = (mod(uv.y, 0.026 + 0.1 * smoothstep(-.5, 0.5, uv.y)) - 0.013 - 0.05 * smoothstep(-.5, 0.5, uv.y));
    e = smoothstep(0.001, 0.0051, abs(tuvy));
    e = ((step(uv.y, -0.109)) * c * (1. - e * step(uv.y, -0.109)));
    e *= step(abs(uv.x), 0.5 * smoothstep(animstart + 1.5, animstart + 3., iTime)); //anim bot lines
    ret = max(ret, red * e);
    tuv = uv;
    tuv *= MD(3.3 - sin(01.0 - cos(2.0 * smoothstep(animstart + 4.25, animstart + 5.5, iTime)))); //anim pl2
    tuv += vec2(0.35521, 0.);
    float f = 1. - circle(tuv, 0.0270, 0.35, true);
    ret = max(ret, f * redw * (1. - lt));
    tuv = uv;
    tuv *= MD(-0.3 + 01. * smoothstep(animstart + 2., animstart + 4.8, iTime));
    tuv += vec2(0.2242, 0.);
    //float fa=f;
    f = 1. - circle(tuv, 0.0570, 0.35, true);
    ret = max(ret * (1. - (1. - lt) * f), (1. - lt) * f * dark * (1. - lt));
    ret = max(ret, strucb(uv));
    //ret=postfx(uv,ret,max(c,fa));
    f *= animendfade();
    return max(dark, max(ret * animendfade(),
            max((1. - f) * b * white * (1. - animendfade()), max((1. - f) * b * white * (1. - lt) * animendfades(),
            (1. - f) * b * white * (lt)*(1. - animendfade()))))); //anim
}

float animm() {
    return smoothstep(animstart, animstart + 1.5, iTime);
}

vec4 mi_anim(in vec2 uv) {
    float Range = 10.;
    //anim
    float Line_Smooth = animm() *
            pow(smoothstep(Range, Range - .05, 2. * Range * (abs(smoothstep(.0, Range, uv.x + .5) - .5))), .2);


    float rndx = iTime;
    rndx = 100.;
    rndx *= 20.;
    float Factor_T = floor(rndx);
    float Factor_X = xRandom(uv.x * .0021);
    float Amplitude1 = 0.5000 * noise(Factor_X, Factor_T)
            + 0.2500 * noise(Factor_X, Factor_T)
            + 0.1250 * noise(Factor_X, Factor_T)
            + 0.0625 * noise(Factor_X, Factor_T);
    Factor_X = xRandom(uv.x * .0031 + .0005);
    float Amplitude2 = 0.5000 * noise2(Factor_X, Factor_T)
            + 0.2500 * noise2(Factor_X, Factor_T)
            + 0.1250 * noise2(Factor_X, Factor_T)
            + 0.0625 * noise2(Factor_X, Factor_T);

    vec2 p = uv;
    p.y += ((cos(.5 * p.x - 0.15)) - .975) * animm(); //anim
    float Light_Track = line(vec2(p.x, p.y * 2. + (Amplitude2 - .5)*.12 * Line_Smooth), .005, .0);
    float Light_Track2 = line(vec2(uv.x, uv.y + (Amplitude2 - .5)*.16 * Line_Smooth), .005, .0);

    vec3 line1 = Light_Track*dark;
    //vec4 line2 =  vec4(Light_Track2)*Light_Color2;

    vec3 retcol = vec3(0.);
    retcol = map(uv, Light_Track);
    return vec4(retcol, 1.);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    init();
    vec2 uv = fragCoord.xy / iResolution.xy;

    vec2 coord = uv;
    vec2 res = iResolution.xy / iResolution.y;
    vec2 tuv = (fragCoord.xy) / iResolution.y - res / 2.0;
    vec2 lightpos = texture(iChannel0, uv).zw;

    float occ = texture(iChannel0, uv).x; //light
    float obj = texture(iChannel0, uv).y; //objects
    vec3 obj_col = textured_col(uv);
    //fragColor = vec4(obj);return;
    float dither = iib(fragCoord);

    vec2 dtc = (coord - lightpos) * (1. / float(SAMPLES) * DENSITY);
    float illumdecay = ilval;

    if (QUALITY + 1 > 0) {
        for (int i = 0; i < SAMPLES; i += 4) {
            coord -= dtc;
            float s = texture(iChannel0, coord + (dtc * dither)).x;
            coord -= dtc;
            s += texture(iChannel0, coord + (dtc * dither)).x;
            coord -= dtc;
            s += texture(iChannel0, coord + (dtc * dither)).x;
            coord -= dtc;
            s += texture(iChannel0, coord + (dtc * dither)).x;
            s *= illumdecay * WEIGHT;
            occ += s;
            illumdecay *= DECAY;
        }

        //fragColor = vec4(vec3(0., 0., obj * .6333) + occ*EXPOSURE/1., 1.0)/1.;
        //fragColor = vec4(mix(obj.rgb*objx,vec3(1.),occ*EXPOSURE/1.), 1.0);

        fragColor = obj * vec4((obj_col + smoothstep(.85, .0, length(tuv)) * vec3(.78) * occ * EXPOSURE / 1.), 1.0);
        //fragColor+=(1.-obj)*mi_sunwbg(tuv);
        fragColor += (1. - obj) * mi_sunwbg(tuv) * occ * EXPOSURE / 1.;
        //fragColor= (fragColor)*star(tuv, vec2(0.15, -0.25+0.2*sin(iTime/2.)));
        
        
    } else {
        fragColor = max((mi_sunwbg(tuv)*(1. - obj)), vec4(obj_col, 1.));
    }

    fragColor = abs(fragColor);
    fragColor += clamp(exlp(tuv),vec4(0.),vec4(1.));
    if (iTime <= 15.) {
		fragColor =mi_anim(tuv);
    }else
    if (iTime <= 15.+ 8. + 2.) {
        vec3 oc = mix(dark, white, 1. - circle(tuv + vec2(0., 0.), 0.2242, 0.22, true));
        float ce = shape_CIRCLE(tuv, 2. * smoothstep(15.+ 8. + 0., 15.+ 8. + 2., iTime));
        ce = 1. - (smoothstep(0.0, 0.012, (ce - 0.5)));
        fragColor.rgb *= ce;
        fragColor.rgb = max(fragColor.rgb, (1. - obj) *oc.rgb+obj_col);
    }
    fragColor.a = 1.;
    //fragColor=vec4(obj);
}

void main() {
    vec4 ret;
    mainImage(ret, gl_FragCoord.xy);
    glFragColor = ret;
}
