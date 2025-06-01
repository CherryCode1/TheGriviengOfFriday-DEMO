import flixel.math.FlxBasePoint;

function create() dispHudInStart = false;

function postCreate() {  
    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 
}
function onSongStart(){
    for (strum in strumLines)
        for (note in [0,1,2,3])strum.members[note].y = -2500;
    
    camGame.fade(FlxColor.BLACK,10,true);
}

public static function spawnCpuStrums() {
    for (i in [0,1,2,3]){
        var shit:Int = 1; 
        FlxTween.tween(strumLines.members[0].members[i],{y: defaultOpponentStrum[i].y}, (Conductor.stepCrochet / 1000) *  i + shit ,{ease:FlxEase.quadInOut});
    }
}
public static function spawnPlayerStrums() {
    for (i in [0,1,2,3]){
         
        var shit:Int = 1;
        FlxTween.tween(strumLines.members[1].members[i],{y:defaultPlayerStrum[i].y},(Conductor.stepCrochet / 1000) * i + shit ,{ease:FlxEase.quadInOut});
    }
}