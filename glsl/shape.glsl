#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform float u_time;

uniform int shape_type;
uniform vec2 shape_size;
uniform vec2 shape_pos;
uniform float shape_rotate_an;

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

#define type_RECT_angles  4
#define type_CIRCLE_angles  320
#define type_TRI_angles  3

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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 res = iResolution.xy / iResolution.y;
    vec2 uv = (fragCoord.xy) / iResolution.y - res/2.0;
    uv+=shape_pos.xy/iResolution.y-res/2.; //to box2d coords
    uv*=iResolution.y/shape_size.y;
    uv*=MD(-shape_rotate_an);
    
    float d= shape(uv,shape_type);
    //if(d>0.52)discard;

	fragColor = vec4(vec3(1.),smoothstep(0.6,0.4,d));

}

void main() {
	vec4 ret;
	mainImage(ret,gl_FragCoord.xy);
	glFragColor=ret;
}
