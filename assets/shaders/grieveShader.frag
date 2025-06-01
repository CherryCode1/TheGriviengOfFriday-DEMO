#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define iChannel2 bitmap
#define iChannelResolution bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform vec4 iMouse;

const float PI = 3.14159265; // no touches !!

// yes touches !!
uniform float wobble_intensity = 0.;
uniform float grade_intensity = 0.2;
uniform float line_intensity = 0.;
uniform float vignette_intensity = 0.3;

// no touches !!
float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float sample_noise(vec2 fragCoord)
{
	vec2 uv = mod(fragCoord + vec2(0, 100. * iTime), 200);
	float value = texture(iChannel1, uv / iResolution.xy).r;
	return pow(value, 7.); //  sharper ramp
}

void main()
{
	vec2 uv = fragCoord / iResolution.xy;
	
	//  wobble
	vec2 wobbl = vec2(wobble_intensity * rand(vec2(iTime, fragCoord.y)), 0.);
	
	//  band distortion
	float t_val = tan(0.25 * iTime + uv.y * PI * .67);
	vec2 tan_off = vec2(wobbl.x * min(0., t_val), 0.);
	
	//  chromab
	vec4 color1 = texture(iChannel0, uv + wobbl + tan_off);
	vec4 color2 = texture(iChannel0, (uv + (wobbl * 1.5) + (tan_off * 1.3)) * 1.005);
	//  combine + grade
	vec4 color = vec4(color2.rg, pow(color1.b, .67), 1.);
	color.rgb = mix(texture(iChannel0, uv + tan_off).rgb, color.rgb, grade_intensity);
	
	//  scanline sim
	float s_val = ((sin(2. * PI * uv.y + iTime * 20.) + sin(2. * PI * uv.y)) / 2.) * .015 * sin(iTime);
	color += s_val;
	
	//  noise lines
	float ival = iResolution.y / 4.;
	float r = rand(vec2(iTime, fragCoord.y));
	//  dirty hack to avoid conditional
	float on = floor(mod(float(int(fragCoord.y + (iTime * r * 1000.))), ival + line_intensity) / ival);
	float wh = sample_noise(fragCoord) * on;
	color = vec4(min(1., color.r + wh), 
					min(1., color.g + wh),
					min(1., color.b + wh), 1.);
	
	float vig = 1. - sin(PI * uv.x) * sin(PI * uv.y);
	
	fragColor = color - (vig * vignette_intensity);
	fragColor.a = flixel_texture2D(bitmap, uv).a;
}