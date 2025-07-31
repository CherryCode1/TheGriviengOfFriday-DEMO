
#pragma header

/*
 * Mildly modified by Peppy
 * Credits to:
 * https://www.shadertoy.com/view/M3KGRG
 * https://www.shadertoy.com/view/3ssSz2
 */

uniform float iTime; // esto no lo tengo que explicar xdxd
uniform float contrast; // esto es la saturacion o contraste
uniform float midpoint; // esto es la oscuridad de la imagen
uniform float grain_amount; // esto es que tanta grain o noise se usa

#define IMAGE_EFFECT originalSigmoidContrast

#define remap(v, a, b) (((v) - (a)) / ((b) - (a)))

float rand(vec2 uv){
    return fract(sin(dot(uv, vec2(21.9132, 87.435))) * 51816.9134);
}

float originalSigmoidContrast(float color, float contrast, float mid)
{	
    // rescaling contrast to more easily compare with optimized version:
    contrast = contrast < 1.0 ? 0.5 + contrast * 0.5 : contrast;
    
	// original version:
    float scale_l = 1.0 / mid;
    float scale_h = 1.0 / (1.0 - mid);
    float lower = mid * pow(scale_l * color, contrast);
    float upper = 1.0 - (1.0 - mid) * pow(scale_h - scale_h * color, contrast);    
	return color < mid ? lower : upper;
}

vec4 originalSigmoidContrast(vec4 color, float contrast, float midpoint)
{
    return vec4(
        originalSigmoidContrast(color.r, contrast, midpoint),
    	originalSigmoidContrast(color.g, contrast, midpoint),
        originalSigmoidContrast(color.b, contrast, midpoint),
        originalSigmoidContrast(color.a, contrast, midpoint)
    );
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    vec2 pix_size = 1.0/iResolution.xy;
    vec2 image_uv = uv;
    
    vec4 col = flixel_texture2D(bitmap, image_uv);

    float noise = (rand(uv+fract(iTime)) - 0.5) * 2.0;
    float grain_size = 1.;

    col = IMAGE_EFFECT(col, contrast, midpoint);

    col += noise * grain_amount * grain_size;

    gl_FragColor = col;
}