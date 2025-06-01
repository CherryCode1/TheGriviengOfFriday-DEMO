import funkin.backend.util.CoolUtil;

public static var angleCamera:Bool = false;

function postCreate() {
    dad.color = CoolUtil.getColorFromDynamic('#000000');
    iconP2.color = CoolUtil.getColorFromDynamic('#000000');


    angleCamera = false;
   
}

public static function changeGf(){
    var gfOld = strumLines.members[2].characters[1];
  

    var newCharacter = new Character(gfOld.x, gfOld.y, "gf-enigma", false);
    newCharacter.active = newCharacter.visible = true;
    newCharacter.drawComplex(FlxG.camera); 
    newCharacter.playAnim(gfOld.animation.name);
    newCharacter.animation?.curAnim?.curFrame = gfOld.animation?.curAnim?.curFrame;    
    insert(members.indexOf(gfOld), newCharacter);
    remove(gfOld);

    strumLines.members[2].characters[1] = newCharacter;
       
}
var speedAngle:Float = 1;
function postUpdate(elapsed:Float) {

    if (angleCamera) {
        defaultHudZoom = 0.95;
        var currentBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm/60)* speedAngle;
	
        camHUD.angle = 2 * Math.sin(currentBeat / 2);
        camHUD.x = 16 * Math.sin(currentBeat / 2);
     
    }else{
        camHUD.angle = FlxMath.lerp(camHUD.angle, 0 ,0.1);
        camHUD.x = FlxMath.lerp(camHUD.x, 0 ,0.1);
        defaultHudZoom = 1;
    }
}
public static function setangleCamera() {
 angleCamera = !angleCamera; 
 trace('camera angle: '+ angleCamera);
}
public static function changeSpeedAngleCamera(speed:String) {
   speedAngle = Std.int(speed);
}
public static function showShits(){
    healthBar.visible = true;
    healthBarBG.visible = true;
    dad.color = CoolUtil.getColorFromDynamic('#FFFFFF');
    iconP2.color = CoolUtil.getColorFromDynamic('#FFFFFF');

}
var bfTrailEffectActive:Bool = false;
var dadTrailEffectActive:Bool = false;

public static function setTrailBf(){
    bfTrailEffectActive = !bfTrailEffectActive;
}
 
public static function setTrailDad(){
    dadTrailEffectActive = !dadTrailEffectActive;
}
 
function onPlayerHit(n){
    if (bfTrailEffectActive)
        if (!n.isSustainNote) makeTrailEffect(boyfriend,n.direction);
}
  
    
function onDadHit(n){
    if (dadTrailEffectActive)
        if (!n.isSustainNote) makeTrailEffect(dad,n.direction);
}
    


var trailEffectArray:Array<Dynamic> = [];
var singAnims:Array<String> = ['singLEFT','singDOWN','singUP','singRIGHT'];

public static function makeTrailEffect(char:Dynamic = dad,singAnim:Int = 0 ) {
    var trail:Character = new Character(char.x, char.y, char.curCharacter, char.isPlayer);
    insert(members.indexOf(char), trail);
    trailEffectArray.push(trail);
    trail.beatInterval = 1000;
    trail.scale.set(char.scale.x,char.scale.y);
    trail.playSingAnim(singAnim);
    trail.holdTime = 0;
    trail.color = char.iconColor;
 
    trail.__lockAnimThisFrame = true;
    trail.debugMode = true;
  
    FlxTween.tween(trail,{alpha: alphashit()}, timeShit());

    switch(singAnims[singAnim]) {
        case'singLEFT': FlxTween.tween(trail,{x: trail.x - 70}, 0.5,{ease:FlxEase.cubeInOut});
        case'singDOWN': FlxTween.tween(trail,{y: trail.y + 70}, 0.5,{ease:FlxEase.cubeInOut});
        case'singUP': FlxTween.tween(trail,{y: trail.y - 70}, 0.5,{ease:FlxEase.cubeInOut});
        case'singRIGHT': FlxTween.tween(trail,{x: trail.x + 70}, 0.5,{ease:FlxEase.cubeInOut});
    } 
    
}
public static function alphashit() {
    var alpha_sprite_ekis:Float = 0.25;
    alpha_sprite_ekis +=  0.05;
    if (alpha_sprite_ekis > 0.75) alpha_sprite_ekis = 0.25;

    return alpha_sprite_ekis;
}
public static function timeShit() {
    var time_alpha:Float = 0.25;
    time_alpha +=  0.05;
    if (time_alpha > 0.75) time_alpha = 0.25;
    return time_alpha;
}
var timeShitString:Float = 0;
public static function destroyTrailEffect(time:String) {
    timeShitString = Std.int(time);
    new FlxTimer().start(0.1, function sexito(_):Void
    {
            for (i in 0...trailEffectArray.length){
                FlxTween.tween(trailEffectArray[i],{alpha: 0},timeShitString,{onComplete: function pene(_){
                    for (sprites in trailEffectArray)
                     sprites.destroy();
                    trailEffectArray = [];
                }});
            }
    
    });
}