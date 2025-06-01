#pragma header

uniform float zoom;
void main()
{
    vec2 uv = openfl_TextureCoordv;
    uv = (uv - 0.5) * 2.0;
    uv *= zoom;

    uv.x *= 1.0 + pow(abs(uv.y / 2.0), 3.0);
    uv.y *= 1.0 + pow(abs(uv.x / 2.0), 3.0);
    uv = (uv + 1.0) * 0.5;

    vec4 tex = vec4(
        texture2D(bitmap, uv + 0.001).r,
        texture2D(bitmap, uv).g,
        texture2D(bitmap, uv - 0.001).b,
        flixel_texture2D(bitmap, uv).a
    );

    tex *= smoothstep(uv.x, uv.x + 0.02, 1.005) * smoothstep(uv.y, uv.y + 0.08, 1.02) * smoothstep(-0.01, 0.022, uv.x) * smoothstep(-0.01, 0.02, uv.y);

    float avg = (tex.r + tex.g + tex.b) / 3.0;

    vec3 bgColor = vec3(20.0 / 255.0, 0., 0.); // Background color in normalized RGB
    gl_FragColor = mix(vec4(bgColor, 1.0), tex + pow(avg, 3.0), step(0.0, uv.x) * step(0.0, uv.y) * step(uv.x, 1.0) * step(uv.y, 1.0));
}