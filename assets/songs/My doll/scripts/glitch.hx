var distortShader:CustomShader = new CustomShader("distort_shader");
var distortIntensity:Float = 0;

public static var distortShader_2:CustomShader = new CustomShader("distort_shader");
var distortIntensity_2:Float = 0;

var distort_shader_Dad:CustomShader = new CustomShader("distort_shader");
var distortIntensity_3:Float = 0;
var pibby_Shader:CustomShader = new CustomShader("Pibbified");

function create(){
    noteSkin = "NOTE_assetsGUMBALL";
	splashSkin = "default";


    pibby_Shader.uTime = 0;
    pibby_Shader.glitchMultiply = 0;
    pibby_Shader.NUM_SAMPLES = 3;
    pibby_Shader.iMouseX = 500;

    camGame.addShader(pibby_Shader);
    camHUD.addShader(pibby_Shader);
    dad.shader = distort_shader_Dad;
}
function postCreate() {
    distortShader.binaryIntensity = 1000.0; 
    distortShader.negativity = 0;
    distortShader_2.binaryIntensity = 1000.0; 
    distortShader_2.negativity = 0;
    distort_shader_Dad.binaryIntensity = 1000.0;
    distort_shader_Dad.negativity = 0;

    dad.shader = distort_shader_Dad;
    iconP2.shader = distortShader;  

}
var time:Float = 0;
var glitchShaderIntensity:Float = 0;
function update(elapsed:Float) {
    glitchShaderIntensity = lerp(glitchShaderIntensity, 0, 0.1);
    pibby_Shader.glitchMultiply = glitchShaderIntensity;
    pibby_Shader.uTime += elapsed;
    distort_shader_Dad.binaryIntensity = distortIntensity_3;
    distortShader.negativity = 0;
    distortShader_2.negativity = 0;
  

    time -= elapsed;
    if(time < 0)time = 0;
    if(time == 0){
        distort_shader_Dad.negativity = 0;
    }
    distortIntensity_3 = lerp(distortIntensity_3,1000.0,0.1);

    distortShader.binaryIntensity = distortIntensity;
    distortShader_2.binaryIntensity = distortIntensity_2;
}
function stepHit(){
    distortIntensity = FlxG.random.float(0, 4);
    distortIntensity_2 = FlxG.random.float(1, 4);
}


function onDadHit(event) {
    if(!event.isSustainNote) {

        if (FlxG.random.int(0, 1) == 0) {
           
            glitchShaderIntensity = FlxG.random.float(0.2, 0.7);
        }
    }
   
    
    if (event.noteType == "glitch_note")  {
        if(dad.shader == null)dad.shader = distort_shader_Dad;
        distortIntensity_3 = FlxG.random.float(0, 1);
		distort_shader_Dad.negativity = 1.0;
		time = (event.sustainLength > 0 ? event.sustainLength/1000 : 0) + FlxG.random.float(0.0475, 0.085);		
    }
}