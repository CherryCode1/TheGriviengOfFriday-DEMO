// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

vec4 rgb2yiq(vec4 c){   
    return vec4(
        (0.2989*c.r + 0.5959*c.g + 0.2115*c.b),
        (0.5870*c.r - 0.2744*c.g - 0.5229*c.b),
        (0.1140*c.r - 0.3216*c.g + 0.3114*c.b),
        1.0
    );
}

vec4 yiq2rgb(vec4 c){				
    return vec4(
        (	 1.0*c.r +	  1.0*c.g + 	1.0*c.b),
        ( 0.956*c.r - 0.2720*c.g - 1.1060*c.b),
        (0.6210*c.r - 0.6474*c.g + 1.7046*c.b),
        c.a
    );
}

vec2 Circle(float Start, float Points, float Point) {
    float Rad = (3.141592 * 2.0 * (1.0 / Points)) * (Point + Start);
    return vec2(-(.3 + Rad), cos(Rad));
}

vec4 Blur(vec2 uv, float f, float d){
    float t = 0.0;
    vec2 PixelOffset = vec2(d + .0005 * t, 0);
    
    float Start = 2.0 / 14.0;
    vec2 Scale = 0.66 * 4.0 * 2.0 * PixelOffset.xy;
    
    vec4 N0 = texture(iChannel0, uv + Circle(Start, 14.0, 0.0) * Scale);
    vec4 N1 = texture(iChannel0, uv + Circle(Start, 14.0, 1.0) * Scale);
    vec4 N2 = texture(iChannel0, uv + Circle(Start, 14.0, 2.0) * Scale);
    vec4 N3 = texture(iChannel0, uv + Circle(Start, 14.0, 3.0) * Scale);
    vec4 N4 = texture(iChannel0, uv + Circle(Start, 14.0, 4.0) * Scale);
    vec4 N5 = texture(iChannel0, uv + Circle(Start, 14.0, 5.0) * Scale);
    vec4 N6 = texture(iChannel0, uv + Circle(Start, 14.0, 6.0) * Scale);
    vec4 N7 = texture(iChannel0, uv + Circle(Start, 14.0, 7.0) * Scale);
    vec4 N8 = texture(iChannel0, uv + Circle(Start, 14.0, 8.0) * Scale);
    vec4 N9 = texture(iChannel0, uv + Circle(Start, 14.0, 9.0) * Scale);
    vec4 N10 = texture(iChannel0, uv + Circle(Start, 14.0, 10.0) * Scale);
    vec4 N11 = texture(iChannel0, uv + Circle(Start, 14.0, 11.0) * Scale);
    vec4 N12 = texture(iChannel0, uv + Circle(Start, 14.0, 12.0) * Scale);
    vec4 N13 = texture(iChannel0, uv + Circle(Start, 14.0, 13.0) * Scale);
    vec4 N14 = texture(iChannel0, uv);
    
    float W = 1.0 / 15.0;
    
    vec4 clr = 
        (N0 * W) +
        (N1 * W) +
        (N2 * W) +
        (N3 * W) +
        (N4 * W) +
        (N5 * W) +
        (N6 * W) +
        (N7 * W) +
        (N8 * W) +
        (N9 * W) +
        (N10 * W) +
        (N11 * W) +
        (N12 * W) +
        (N13 * W) +
        (N14 * W);

    return vec4(clr.rgb, clr.a);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float d = .1 * iMouse.x / 50.0;
    vec2 uv = fragCoord.xy / iResolution.xy;

    float s = (texture(iChannel1, fragCoord).r);
    float e = min(.30, pow(max(0.0, cos(uv.y * 4.0 + .3) - .75) * (s + 0.5) * 1.0, 3.0)) * 25.0;
    s -= pow(texture(iChannel1, vec2(0.01 + (uv.y * 32.0) / 32.0, 1.0)).r, 1.0);
    uv.x += e * abs(s * 3.0);
    float r = texture(iChannel2, vec2(mod(iTime * 10.0, mod(iTime * 10.0, 256.0) * (1.0 / 256.0)), 0.0)).r * (2.0 * s);
    uv.x += abs(r * pow(min(.003, (uv.y - .15)) * 6.0, 2.0));
    
    d = .051 + abs(sin(s / 4.0));
    float c = max(0.0001, .002 * d);
    
    vec2 uvo = uv;
    fragColor = Blur(uv, 0.0, c + c * (uv.x));
    float y = rgb2yiq(fragColor).r;

    uv.x += .01 * d;
    c *= 6.0;
    fragColor = Blur(uv, .333, c);
    float i = rgb2yiq(fragColor).g;

    uv.x += .005 * d;
    c *= 2.50;
    fragColor = Blur(uv, .666, c);
    float q = rgb2yiq(fragColor).b;

    fragColor = yiq2rgb(vec4(y, i, q, fragColor.a)) - pow(s + e * 2.0, 3.0);
    fragColor.rgb *= smoothstep(1.0, .999, uv.x - .1);
}


void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}