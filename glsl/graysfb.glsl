#version 300 es
#ifdef GL_ES
 precision highp float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture1;
uniform float u_time;
out vec4 glFragColor;

#define iTime u_time
#define iResolution u_resolution
#define iChannel0 u_texture1
#define iMouse u_mouse

// License Creative Commons Attribution-NonCommercial-ShareAlike
// original source github.com/danilw
vec3 sun( vec2 uv, vec2 p ) 
{
    vec3 res;
    vec2 resx = iResolution.xy / iResolution.y;
    float di = distance(uv, p);
    res.x =  di <= .23333 ? sqrt(1. - di*3.) : 0.;
    
    res.x =  1.;
    
    res.yz = p;

    res.yz = res.yz/resx+0.5;
    
    return res;
}

float circle( vec2 pos, float r, vec2 uv )
{
    return distance(uv, pos) < r ? 1. : 0.;
}

float map(vec2 uv)
{
	vec2 res = iResolution.xy / iResolution.y;
    float occluders = 0.;
    vec3 texturex=texture(iChannel0,uv/res+0.5).rgb;
    occluders=max(occluders,smoothstep(0.,0.1,max(max(texturex.r,texturex.g),texturex.b))); //for colors
    return (occluders);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 res = iResolution.xy / iResolution.y;
    vec2 uv = (fragCoord.xy) / iResolution.y - res/2.0;
    
    vec3 light = min(sun(uv, vec2(0.0, 0.0)), vec3(1.));
    float occluders = map(uv);
    float col = max(light.x - occluders, 0.);
        
    fragColor = vec4(col,occluders,light.yz);
}

void main() {
	vec4 ret;
	mainImage(ret,gl_FragCoord.xy);
	glFragColor=ret;
}
