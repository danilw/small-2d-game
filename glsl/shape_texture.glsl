#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform float u_time;
uniform float u_rtime;

uniform int shape_type;
uniform int color_t;
uniform float ppower;
uniform float ajcd;
uniform float ajcd2;
uniform int shape_tile;
uniform vec2 shape_size;
uniform vec2 shape_pos;
uniform float shape_rotate_an;
uniform float shape_rotate_Urot;

out vec4 glFragColor;

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iMouse u_mouse

// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw

#define PI (4.0 * atan(1.0))
#define TWO_PI PI*2.
#define MD(a) mat2(cos(a), -sin(a), sin(a), cos(a))

#define B_TRI 0
#define B_RECT 1
#define B_CIRCLE 2

#define TILE_SDF 0
#define TILE_0 1
#define TILE_1 2
#define TILE_2 3
#define TILE_2_2 4
#define TILE_3 5
#define TILE_3_2 6
#define TILE_4 7
#define TILE_4_2 8
#define TILE_SDF_SPAWN 9
#define TILE_PLAYER 10

#define type_RECT_angles  4
#define type_CIRCLE_angles  320
#define type_TRI_angles  3

//uni
float shape_uni(vec2 uv, int N)
{
  float color = 0.0;
  float d = 0.0;
  float a = atan(uv.x,uv.y)+PI;
  float rx = TWO_PI/float(N);
  d = cos(floor(.5+a/rx)*rx-a)*length(uv);
  return (d);
}

// or IQ SDF http://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
float shape_RECT( in vec2 p, in vec2 b)
{
    vec2 d = abs(p)-b;
    return length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)+0.5;
}

float shape_CIRCLE( vec2 p, float r )
{
  return length(p) - r+0.5;
}

float shape_TRI(  in vec2 p )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0/k;
    if( p.x + k*p.y > 0.0 ) p = vec2( p.x - k*p.y, -k*p.x - p.y )/2.0;
    p.x -= clamp( p.x, -2.0, 0.0 );
    return -length(p)*sign(p.y)+0.5;
}

//uni
float shape_u(vec2 uv,int shape_type){
	int angles=0;
	if(shape_type==B_RECT)angles=type_RECT_angles;
	if(shape_type==B_CIRCLE)angles=type_CIRCLE_angles;
	if(shape_type==B_TRI){uv*=2.;angles=type_TRI_angles;}
	return shape_uni(uv,angles);
}

//SDF
float shape(vec2 uv,int shape_type){
	if(shape_type==B_RECT)return shape_RECT(uv,vec2(.5));
	if(shape_type==B_CIRCLE)return shape_CIRCLE(uv,.5);
	if(shape_type==B_TRI)return shape_TRI(uv*2.);
}

vec4 tile_SDF(vec2 uv,float zv){
	vec2 res = iResolution.xy / iResolution.y;
    float d= shape(uv,shape_type);
    //if(d>0.6)discard;
    

    if(shape_type==B_TRI)zv+=4.; //because uv*2.for triangle
    vec3 col = vec3(1.0) - sign(d-0.5)*vec3(0.1,0.4,0.7);
	col *= 1.0 - exp(-2.0*abs(d-0.5));
	col *= 0.8 + 0.2*cos(iTime*2.+(max(120.0-10.*zv,1.))*(d-0.5));
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.025+0.015*zv,abs(d-0.5)) );
	float ss=smoothstep(0.6,0.47,d);
	return vec4(col*ss, ss);
	
}

const vec3 white = vec3(0xdc, 0xe0, 0xd1) / float(0xff);
const vec3 dark = vec3(0x1a, 0x13, 0x21) / float(0xff);

vec3 green = vec3(0x7f, 0xbe, 0x20) / float(0xff);
vec3 green_l = vec3(0x92, 0xdb, 0x26) / float(0xff);
const vec3 rep_gr = vec3(0xe9, 0xdf, 0xc3) / float(0xff);

vec3 ground1 = vec3(0xce, 0x98, 0x69) / float(0xff);
vec3 ground2 = vec3(0xca, 0x8f, 0x5b) / float(0xff);
vec3 ground3 = vec3(0xc1, 0x7f, 0x41) / float(0xff);

//http://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm

float ndot(vec2 a, vec2 b) {
    return a.x * b.x - a.y * b.y;
}

float sdRhombus_o(in vec2 p, in vec2 b) {
    vec2 q = abs(p);

    float h = clamp((-2.0 * ndot(q, b) + ndot(b, b)) / dot(b, b), -1.0, 1.0);
    float d = length(q - 0.5 * b * vec2(1.0 - h, 1.0 + h));
    d *= sign(q.x * b.y + q.y * b.x - b.x * b.y);

    return d + 0.5;
}

float sdRhombus(in vec2 p, in vec2 b) {
    if (p.y < 0.)return 1.;
    vec2 q = abs(p);

    float h = clamp((-2.0 * ndot(q, b) + ndot(b, b)) / dot(b, b), -1.0, 1.0);
    float d = length(q - 0.5 * b * vec2(1.0 - h, 1.0 + h));
    d *= sign(q.x * b.y + q.y * b.x - b.x * b.y);

    return d + 0.5;
}

float w1(vec2 p, float zv) {
    vec2 res = iResolution.xy / iResolution.y;
    p.y *= 1.1;
    float uvi = 1. / 3.;
    p.y += (uvi / 1.2)*1.2;
    if (p.y > uvi / 2.)p.y += uvi / 2.;
    bool bp = mod(p.y + uvi / 10., uvi * 2.) >= uvi;
    if (bp) {
        p.x += uvi / 2.;
    }
    p.x = abs(p.x) - uvi;


    p.y = mod(p.y + uvi / 10., uvi);

    if (bp) {
        p.y = uvi - abs(p.y);
    }

    p *= 3.;
    float d = sdRhombus((p + vec2(uvi * 3., 0.)), vec2(0.5, 0.5));
    d = min(d, sdRhombus(p, vec2(0.5, 0.5)));
    d = min(d, sdRhombus(p - vec2(uvi * 3., 0.), vec2(0.5, 0.5)));
    return 1. - smoothstep(0.0, 0.025 + 0.015 * zv, (d - 0.5));
}

float w2(vec2 p, float zv) {
    vec2 res = iResolution.xy / iResolution.y;
    p.y *= 1.1;
    float uvi = 1. / 3.;
    p.y += -(uvi / 1.2)*1.2;
    if ((p.y) > uvi / 3.5)return 1.;
    if ((p.y)<-uvi / 3.5)return 0.;
    p.y += -(uvi / 1.2) / 2.;
    p.x += uvi / 2.;
    p.x = abs(p.x) - uvi;


    p.y = mod(p.y + uvi / 10., uvi);
    p.y = uvi - abs(p.y);

    p *= 3.;
    float d = sdRhombus((p + vec2(uvi * 3., 0.)), vec2(0.5, 0.5));
    d = min(d, sdRhombus(p, vec2(0.5, 0.5)));
    d = min(d, sdRhombus(p - vec2(uvi * 3., 0.), vec2(0.5, 0.5)));
    return 1. - smoothstep(0.0, 0.025 + 0.015 * zv, (d - 0.5));
}

float w2_2(vec2 p, float zv) {
    vec2 res = iResolution.xy / iResolution.y;

    p.x += 0.035;
    p.y += 0.03;
    p.y *= 1.1;
    float uvi = 1. / 3.;
    p.y += -(uvi / 1.2)*1.2;
    p.y += -(uvi / 1.2) / 2.;
    vec2 op = p;
    bool bp = mod(p.y + uvi / 10., uvi * 2.) >= uvi;



    p.y = mod(p.y + uvi / 10., uvi);

    //if(bp)
    {
        p.y = uvi - abs(p.y);
    }

    p *= 3.;
    float d = 1.; //sdRhombus( (p+vec2(uvi*3.,0.)), vec2(0.5,0.5)) ;
    d = min(d, sdRhombus_o(op * 3. + vec2((uvi)*3., -(uvi / 3. * 3.)*1.2), vec2(0.5, 0.5)));
    d = min(d, sdRhombus_o(op * 3. + vec2((uvi + uvi / 2.)*3., ((uvi / 12.)*3.)*1.2), vec2(0.5, 0.5)));
    //d = min(d,sdRhombus( p, vec2(0.5,0.5) ));
    //d = min(d,sdRhombus( p-vec2(uvi*3.,0.), vec2(0.5,0.5) ));
    return 1. - smoothstep(0.0, 0.025 + 0.015 * zv, (d - 0.5));
}

float w3(vec2 p, float zv) {
    float d = 0.;
    p.y += -0.47;
    d = smoothstep(0.0, 0.0025 + 0.015 * zv, p.y);
    return d;
}

float w4(vec2 p, float zv) {
    float d = 0.;
    p += -0.2879+0.0005*zv;;
    p.y *= 1.105;
    p *= 3.;
    d = sdRhombus_o(p, vec2(0.5, 0.5));
    return (1. - smoothstep(0.0, 0.025 + 0.015 * zv, (d - 0.5)))*1.;
}

float w5(vec2 p, float zv) {
    float d = 0.;
    p.x += -0.375-0.005*zv;
    p.y += -0.178;
    p.y *= 1.1;
    p *= 2.;
    d = sdRhombus_o(p, vec2(0.5, 0.5));
    return 1. - smoothstep(0.0, 0.025 / 2. + 0.015 * zv / 2., (d - 0.5));
}

vec2 box(vec2 uv, float zv) {
    float d = shape_RECT(uv, vec2(.5));
    return vec2(1.-smoothstep(-0.0-0.005*zv,0.015+0.015*zv,(d-0.5)),1.-smoothstep(-0.0-0.015*zv,0.025+0.015*zv,(d-0.5)));
}

vec4 tile0(vec2 uv, float zv) {
    vec4 fragColor;
    vec2 res = iResolution.xy / iResolution.y;


    vec2 ouv = uv;


    float d = w1(uv, zv);


    fragColor = vec4(d);

    vec3 col = ground1;
    col = mix(col, ground2, d);

    fragColor = vec4(col, 1.);

    return fragColor;

}

vec4 tile1(vec2 uv, float zv) {
    vec4 fragColor;
    vec2 res = iResolution.xy / iResolution.y;

    vec2 ouv = uv;

    float d = w1(uv, zv);
    float d2 = w2(uv, zv);
    float d3 = step(1. / 9., uv.y)*(1. - (d2 + d));
    float d4 = w3(uv, zv);
    d3 = max(0., d3);

    fragColor = vec4(d);

    vec3 col = ground1;
    col = mix(col, ground2, d);
    col = mix(col, ground3, d3);
    col = mix(col, green, d2);
    col = mix(col, green_l, d4);

    fragColor = vec4(col, 1.)*smoothstep(0.55,0.52-0.01*zv,uv.y);
    return fragColor;

}

vec4 tile3(vec2 uv, float zv) {
    vec4 fragColor;
    vec2 res = iResolution.xy / iResolution.y;

    vec2 ouv = uv;

    float d = w1(uv, zv);
    float d2 = w2_2(uv, zv)*(smoothstep(-0.235+ 0.001*zv, -.235 - 0.001*zv, uv.x)) ;
    float d3 = (smoothstep(-0.24+ 0.005*zv, -.24 - 0.005*zv, uv.x) 
                * smoothstep(0.64-0.005*zv, .64+0.005*zv, -uv.x + uv.y * 1.1))*(1. - (d2 + d));
    float d4 = w3(uv, zv);
    d3 = max(0., d3);

    fragColor = vec4(d);

    vec3 col = ground1;
    col = mix(col, ground2, d);
    col = mix(col, ground3, d3);
    col = mix(col, green, d2);

    fragColor = vec4(col, 1.)*smoothstep(0.55,0.52-0.01*zv,uv.y);
    return fragColor;

}

vec4 tile4(vec2 uv, float zv) {
    vec4 fragColor;

    vec2 res = iResolution.xy / iResolution.y;
    vec2 ouv = uv;

    float d = w1(uv, zv);
    float d2 = 0. * w2(uv, zv);
    d2 = max(d2, w2(vec2(uv.y, uv.x * (0.77777) + 0.05), zv));
    float d3 = step(1. / 9., uv.y)*(1. - (d2 + d));
    float d4 = 0. * w3(uv, zv);

    float d5 = w5(uv + vec2(-0.1, 0.05), zv);
    d5 = max(d5, w5(uv + vec2(-0.1, -0.29), zv));
    d5 = max(d5, w5(uv + vec2(-0.1, 0.39), zv)); //ZV !!!!
    d5 *= smoothstep(0.0, 0.025 + 0.015 * 1., (uv.x - 0.24)*2.)*(1. - (d2));

    d4 = max(d4, w3(vec2(uv.y, uv.x  - 0.01), zv));
    d3 = max(0., d3);

    fragColor = vec4(d);



    vec3 col = ground1;
    col = mix(col, ground2, d);
    col = mix(col, green, d2);
    col = mix(col, green_l, d4);
    col = mix(col, ground3, d5);

    fragColor = vec4(col, 1.);

    return fragColor;

}

vec4 tile2(vec2 uv, float zv) {
    vec2 res = iResolution.xy / iResolution.y;
    vec2 ouv = uv;

    float d = w1(uv, zv);
    float d2 = w2(uv, zv);
    d2 = max(d2, w2(vec2(uv.y, uv.x * (0.77777) + 0.05), zv));
    d2 = max(w4(uv,  zv), d2);
    float d3 = step(1. / 9., uv.y)*(1. - (d2 + d));
    float d4 = w3(uv, zv);
    float d5 = w5(uv, zv);
    d5 = max(d5, w5(uv + vec2(-0.1, 0.39), zv) *
            smoothstep(0.0, 0.025 + 0.015 * zv, (uv.x - 0.24)*2.))*(1. - (d2));

    d4 = max(d4, w3(vec2(uv.y, uv.x  - 0.01), zv));
    d3 = max(0., d3);

    vec4 fragColor;



    vec3 col = ground1;
    col = mix(col, ground2, d);
    col = mix(col, ground3, d3);
    col = mix(col, green, d2);
    col = mix(col, green_l, d4);
    col = mix(col, ground3, d5);

    fragColor = vec4(col, 1.)*smoothstep(0.55,0.52-0.01*zv,uv.y);

    return fragColor;

}

float spawn(vec2 uv){
    float iTime=mod(iTime,4.);
    if(iTime>2.) return 0.;
    float v=0.6*smoothstep(0.,2.,mod(iTime,2.));
    return smoothstep(v+0.001,v,abs(uv.x));
}


const vec3 white3 = vec3(0xd6, 0xdb, 0xd3) / float(0xff);
const vec3 pink = vec3(0xfe, 0x67, 0x63) / float(0xff);
const vec3 purp = vec3(0x49, 0x11, 0x9c) / float(0xff);


float sdLine( in vec2 p, in vec2 a, in vec2 b )
{
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

float line_time=0.8;

float square_ts=0.2;
float square_te=3.;

float circ1_ts=0.62;
float circ1_te=3.;

float circ2_ts=0.4;
float circ2_te=2.;

float circ3_ts=0.4;
float circ3_te=2.;

float circ4_ts=0.85;
float circ4_te=2.5;

float circ5_ts=01.85;
float circ5_te=2.5;

float circ6_ts=7.;
float circ6_te=7.5;

float timer(float timexs,float timexe,float timex){
    return smoothstep(timexs,timexe,timex);
}

float stimer(float timexs,float timexe,float timex){
    float v=timer(timexs, timexe, timex/2.);
    return cos(PI/2.-(PI/2.)*sin((PI/2.)*v));
}

float shape_RECT_rounded( in vec2 p, in float r , in vec2 b)
{
  return abs(shape_RECT(p,b)) - r;
}

float ranim(vec2 uv){
    uv*=MD(2.5);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float av=-(-PI*1.3+TWO_PI*stimer(square_ts,square_te,iTime));
    float d=smoothstep(0.0+av,0.01+av,uv.x);
    return d;
}

float ranim2(vec2 uv){
    uv*=MD(-PI/2.);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float av=(-PI*1.3+TWO_PI*stimer(circ1_ts,circ1_te,iTime));
    float d=smoothstep(0.01+av,0.0+av,uv.x);
    return d;
}

float ranim3(vec2 uv){
    uv*=MD(PI/2.);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float av=-(-PI*1.3+TWO_PI*stimer(circ2_ts,circ2_te,iTime));
    float av_1=-(-PI*1.3+TWO_PI*stimer(circ2_ts,circ2_te+1.20,iTime));
    float av2=-(-PI*.73+0.85*TWO_PI*stimer(circ2_ts,circ2_te+-.20,iTime));
    float d=smoothstep(0.0+av,0.1+av,uv.x);
    d=d*smoothstep(01.520+av2,01.6201+av2,uv.x);
    d=min(d,smoothstep(PI/1.65+0.1,PI/1.65,uv.x));

    
    return d;
}

float ranim4(vec2 uv){
    uv*=MD(PI);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float av=-(-PI*1.3+TWO_PI*stimer(circ2_ts,circ2_te,iTime));
    float d=smoothstep(0.0+av,0.01+av,uv.x);
    return d;
}

float ranim5(vec2 uv){
    uv*=MD(-PI);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float av=-(-PI*1.3+TWO_PI*stimer(circ4_ts,circ4_te,iTime));
    float d=smoothstep(0.0+av,0.01+av,uv.x);
    d=d*smoothstep(0.01-av,-av,uv.x);
    return d;
}

float ranim6(vec2 uv){
    uv*=MD(-PI);
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float segm=mod((abs(uv.x-20.5))*6.,2.)*(mod((uv.x+20.5)*6.,2.));
    float d=segm*stimer(circ5_ts,circ5_te,iTime);
    return d;
}

float ranim7(vec2 uv){
    
    vec2 res = iResolution.xy / iResolution.y;
    float af = atan(uv.x,uv.y);
    float r = length(uv);
    uv = vec2(af/TWO_PI,r);
    float d;
    uv.x=mod(uv.x,(TWO_PI-0.28)/6.);
    float v=0.5*smoothstep(circ6_te,circ6_ts,iTime);
    return smoothstep(0.-v,0.1-v,uv.x)*smoothstep((TWO_PI-0.28)/6.+v,0.9+v,uv.x);
    
}




const float Power = 5.059;
const float Dumping = 100.0;
vec3 colx=vec3(.20, 0.725, 01.08);




vec3 hash3(vec3 p) {
	p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
			dot(p, vec3(269.5, 183.3, 246.1)),
			dot(p, vec3(113.5, 271.9, 124.6)));

	return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);

	vec3 u = f * f * (3.0 - 2.0 * f);

	float n0 = dot(hash3(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0));
	float n1 = dot(hash3(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0));
	float n2 = dot(hash3(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0));
	float n3 = dot(hash3(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0));
	float n4 = dot(hash3(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0));
	float n5 = dot(hash3(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0));
	float n6 = dot(hash3(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0));
	float n7 = dot(hash3(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0));

	float ix0 = mix(n0, n1, u.x);
	float ix1 = mix(n2, n3, u.x);
	float ix2 = mix(n4, n5, u.x);
	float ix3 = mix(n6, n7, u.x);

	float ret = mix(mix(ix0, ix1, u.y), mix(ix2, ix3, u.y), u.z) * 0.5 + 0.5;
	return ret * 2.0 - 1.0;
}



float snoise(vec3 uv)
{
	const vec3 s = vec3(1e0, 1e2, 1e3);
	
    float res=16.;
	uv *= res;
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      	  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-1)*1e3);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-1.;
}


float circle( in vec2 uv, float r1, float r2,vec2 ab)
{
    float t = r1-r2;
    float r = r1;    
    //return smoothstep(ab.x,ab.y, abs((uv.y) - r) - t/10.0);      // line
    return smoothstep(ab.x,ab.y, abs(length(uv) - r) - t/10.0);        
}

float circle2( in vec2 uv, float r1, float r2,vec2 ab)
{
    float t = r1-r2;
    float r = r1;    
    //return smoothstep(ab.x,ab.y, abs((uv.y) - r) - t/10.0);      // line
    return smoothstep(ab.x,ab.y, (length(uv) - r) - t/10.0);        
}



vec3 color(vec2 p) {
	vec3 coord = vec3(p*5., iTime * 0.25);
    coord=vec3(atan(p.x,p.y)/6.2832+.5, length(p)*.4, .5)+ vec3(0.,iTime*.05, iTime*.01);
	float nx = abs(snoise(coord));
	float nx2 = 0.5 * abs(snoise(coord * 2.0));
	float nx3 = 0.25 * abs(snoise(coord * 4.0));
	float nx4 = 0.125 * abs(snoise(coord * 6.0));
    nx+=nx2+nx3+nx4;

    float vx=min(2.*circle(p*3.,1.,0.19,vec2(-0.25,0.8)),circle2(p*3.,.3,0.19,vec2(-0.24645,01.28)));
    float n=nx*vx;
	n *= (100.001 - Power);
	float dist =vx;
	n *= dist / pow(1.001 , Dumping);
    colx = 0.25*colx+colx*(0.5 + 0.5*cos(iTime+p.xyx+vec3(0,2,4)));
    colx*=.2/vec3(nx-nx2,-nx3+nx,-nx4+nx);
	vec3 col = colx / (n);
    //return col;
	return min(vec3(1.),pow(col, vec3(2.0)))*(1.-.9*vx);
}

vec4 mi(in vec2 uv) {
	vec3 col = color(uv);
	col = pow(col, vec3(0.24545));
    col=clamp(abs(col),vec3(0.),vec3(1.));
    
	return vec4(col, 1.0);
}



vec4 mixss(vec2 uv )
{
	
    float frequency = 3.0;
    
    float index = uv.x + iTime + uv.y;
    
    float red = sin(frequency * index + 0.0) * 0.5 + 0.5;
    float green = sin(frequency * index + 2.0) * 0.5 + 0.5;
    float blue = sin(frequency * index + 4.0) * 0.5 + 0.5;
    
    return vec4(red,green,blue,1.0);
}

vec4 player_mi(in vec2 uv, float zv )
{
    //float zoomx=1.2;
    //uv*=zoomx;
    
    float rot=-0.33;
    if(iTime>7.)rot+=-shape_rotate_Urot;
    float rot2=0.;
    if(iTime>7.)rot2=-shape_rotate_an;
    
    vec2 tuv=uv;
    float asx=sin(PI/2.-PI/2.*smoothstep(01.5,03.5+sin(-PI/2.*smoothstep(01.5,03.5,iTime)),iTime));
    uv.y+=01.4*smoothstep(01.2-sin(-PI/2.*smoothstep(02.,0.,iTime)),0.2,iTime);
    //uv+=0.5;
    //uv*=MD(-.52*asx);
    //uv+=vec2(-0.5,-0.5);
	float timerx=stimer(0.,line_time,iTime);
    float d=sdLine(tuv,vec2(-02.5*timerx,-0.5),vec2(02.5*timerx,-0.5));
    vec3 col ;
    
    float d2=shape_RECT_rounded(uv,0.1,vec2(0.4,0.4));
    float d3=shape_CIRCLE(uv,0.5);
    float d4=shape_CIRCLE(uv,0.43);
    float d5=shape_CIRCLE(uv,0.34);
    float d6=shape_CIRCLE(uv,0.07);
    float d7=shape_CIRCLE(uv,0.13);
    
    if(iTime<7.){
    col = mix(col,white3,(1.-ranim(uv))*(1.0-smoothstep(0.01,0.012,abs(d2-0.5))));
    
    col = mix(col,white3,ranim2(uv)*(1.0-smoothstep(0.01,0.012,abs(d3-0.5))));
    
    col = mix(col,pink,ranim3(uv*MD(rot))*(1.0-smoothstep(0.01,0.012,abs(d4-0.5))));
    
    col = mix(col,purp,ranim4(uv)*(1.0-smoothstep(0.01,0.012,abs(d5-0.5))));
    
    col = mix(col,purp,ranim5(uv)*(1.0-smoothstep(0.01,0.012,abs(d6-0.5))));
    
    col = mix(col,white3,ranim6(uv)*(1.0-smoothstep(0.01,0.012,abs(d7-0.5))));
    col*=smoothstep(-0.5,-0.49,tuv.y);
        
        if(iTime>4.){
            vec3 colx=col;
        col = white3*0.02/(abs(d3-0.5));
        col =max(col,ranim3(uv*MD(rot))*pink*0.03/(abs(d4-0.5)));
        col =max(col,purp*0.06/(abs(d5-0.5)));
        col =max(col,purp*0.08/(abs(d6-0.5)));
        col =max(col,(1.0-smoothstep(0.01,0.12,abs(d7-0.5)))*ranim6(uv)*(white3*0.03/(abs(d7-0.5))));
        col=min(max(vec3(0.),col),vec3(1.));
        col=  max(colx,col*(smoothstep(0.01+smoothstep(4.,6.5,iTime),
                                       0.+0.65*smoothstep(4.,6.5,iTime),length(uv))));
        col*=smoothstep(0.8,0.5,length(uv));
        }
        col = max(col,white3*(1.0-smoothstep(0.01,0.012,abs(d))));
        col=clamp(col,vec3(0.),vec3(1.));
    }
    else{
        vec3 cx=mi(tuv*.85).rgb*ppower;
        col =clamp(white3*0.02/(abs(d3+d5*cx.r/4.-0.5)),vec3(0.),vec3(1.))*ranim7(uv*MD(rot2));
        col =clamp(max(col,ranim3(uv*MD(rot))*pink*(0.03+0.03*ppower)/
                                         (abs(d4+cx.r/3.5-0.5))),vec3(0.),vec3(1.));
        col =max(col,clamp((purp*step(uv.y,0.8*ajcd-0.4)+0.09/pink*step(uv.y,0.8*ajcd2-0.4))*0.06/(abs(d5-0.5)),vec3(0.),vec3(1.)));
        col =max(col,purp*(0.08+cx/5.)/(abs(d6-d6*cx/10.-0.5)));
        col =max(col,(1.0-smoothstep(0.01,0.12,abs(d7-0.5)))*ranim6(uv*MD(rot2*2.8))*(cx+white3*0.03/(abs(d7-cx.r/5.-0.5))));
        col=clamp(col,vec3(0.),vec3(1.));
        col*=smoothstep(0.8,0.5,length(uv));
    }
    return vec4(col,max(max(col.r,col.g),col.b));
}




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 res = iResolution.xy / iResolution.y;
    vec2 uv = (fragCoord.xy) / iResolution.y - res/2.0;
    vec2 tuv=uv;
    uv+=(shape_pos.xy)/iResolution.y-res/2.; //to box2d coords
    
    uv*=iResolution.y/shape_size.y;
    float zv=1080./iResolution.y+50./shape_size.y; //zoom value
    zv+=2.;
    int shape_tile_l=shape_tile;
    if(shape_tile_l>100){shape_tile_l=shape_tile_l-100;green=green_l=mixss(tuv).rgb;ground1=ground1*green;ground2=ground2*green;ground3=ground3*green;}
    else
    if(shape_tile_l>10){shape_tile_l=shape_tile_l-10;green=green_l=rep_gr;}
    if(u_rtime<=15.)fragColor= vec4(0.);
    if((u_rtime<=15.+8.)&&(shape_tile_l!=TILE_PLAYER))fragColor= vec4(0.);
    switch(shape_tile_l){
	case TILE_SDF:uv*=MD(-shape_rotate_an);fragColor = tile_SDF(uv,zv);break;
	case TILE_0:fragColor = tile0(uv, zv);fragColor*=fragColor;break;
    case TILE_1:fragColor = tile1(uv, zv);fragColor*=fragColor;break;

    case TILE_2:fragColor = tile2(uv, zv);fragColor*=fragColor;break;
    case TILE_2_2:fragColor = tile2(vec2(-uv.x, uv.y), zv);fragColor*=fragColor;break; //2.2

    case TILE_3:fragColor = tile3(uv, zv);fragColor*=fragColor;break;
    case TILE_3_2:fragColor = tile3(vec2(-uv.x, uv.y), zv);fragColor*=fragColor;break; //3.2

    case TILE_4:fragColor = tile4(uv, zv);fragColor*=fragColor;break;
    case TILE_4_2:fragColor = tile4(vec2(-uv.x, uv.y), zv);fragColor*=fragColor;break; //4.2
    
    case TILE_SDF_SPAWN:uv*=MD(-shape_rotate_an);fragColor = tile_SDF(uv,zv);fragColor=mix(fragColor.brra*0.6*(step(mod(iTime,4.),2.)+smoothstep(2.,4.,mod(iTime,4.))),fragColor,spawn(uv));break;
    
    case TILE_PLAYER:fragColor = player_mi(uv, zv);fragColor*=fragColor;break;
	
	}
	
	if((u_rtime <= 15.+ 8. + 2.)&&(shape_tile_l!=TILE_PLAYER)){
		float ce = shape_CIRCLE(tuv, 2. * smoothstep(15.+ 8. + 0., 15.+ 8. + 2., u_rtime));
        ce = 1. - (smoothstep(0.0, 0.012, (ce - 0.5)));
        fragColor.rgb *= ce;
	}

}

void main() {
	vec4 ret;
	mainImage(ret,gl_FragCoord.xy);
	glFragColor=ret;
}
