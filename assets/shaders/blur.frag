    #pragma header
    uniform float iTime;
    uniform float effectiveness;
    void main()
    {

      vec2 fragCoord = gl_FragCoord.xy;
      vec2 iResolution = openfl_TextureSize;

      float focusPower = (20.0 + sin(iTime*4.)*3.) * effectiveness;
      int focusDetail = 12;


      vec2 uv = fragCoord.xy / iResolution.xy;
      vec2 focus = uv - vec2(0.5, 0.5);



      vec4 outColor = vec4(0, 0, 0, 0);



      for (int i=0; i<focusDetail; i++) {
        float power = 1.0 - focusPower * (1.0/iResolution.x) * (float(i)*0.75);
        outColor += flixel_texture2D(bitmap, focus * power + vec2(0.5));
      }

      outColor.rgba *= 1.0 / float(focusDetail);

      gl_FragColor = outColor;
    }