// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

vec4 FADE_COLOR = vec4(0.0, 0.0, 0.0, 1.0f);
float BUFFER = 2.0f;
float SCALE_SPEED = 1.5f;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float onePixelScale = (iResolution.y - 1.0f) / iResolution.y;
    
    float time = mod(iTime * 4.0f, 1.0f / SCALE_SPEED + 1.0f + BUFFER * 2.0f);
    time = clamp(time- BUFFER, 0.0, 1.0f / SCALE_SPEED + 1.0f);
    
    float scaleTime = clamp(time * SCALE_SPEED, 0.0f, onePixelScale);
    float fadeTime = clamp(time - onePixelScale / SCALE_SPEED, 0.0f, 1.0f);
        
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 scaledUV = vec2(
        (uv.x - 0.5f) * (1.0f - scaleTime) + 0.5f,
        (uv.y - 0.5f) / (1.0f - scaleTime) + 0.5f
    );
    
	vec4 textureColor = texture(iChannel0, scaledUV) + vec4(scaleTime, scaleTime, scaleTime, 0);
    float fadeOutLevel = 1.0f - fadeTime;
    float cropPixel = min(
        clamp(
            sign(
                abs(scaleTime / 2.0f - 0.5) 
                - abs(uv.y - 0.5f)
            )
            , 0.0f, 1.0f
        ), 
        clamp(
            sign(
                1.0f - fadeTime
                - abs(uv.x - 0.5f)
            ),
            0.0f, 
            1.0f
        )
    );
    
    fragColor = mix(
        FADE_COLOR, 
        mix(FADE_COLOR, textureColor, fadeOutLevel), 
        cropPixel
    );
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}