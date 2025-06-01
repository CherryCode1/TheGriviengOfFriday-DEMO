function create() {
    dispHudInStart = true;
    skipCounDown = true;


    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 

    camGame.zoom = defaultCamZoom = 1;
}


function onSongStart(){
    for (strum in playerStrums){
        strum.y = -2500;
      
    }
    
    camGame.fade(FlxColor.BLACK,5,true);
}
public static function spawnPlayerStrums() {

   
    for (i in [0,1,2,3]){
         
        var shit:Int = 1;
        FlxTween.tween(strumLines.members[1].members[i],{y:defaultPlayerStrum[i].y},(Conductor.stepCrochet / 1000) * i + shit ,{ease:FlxEase.quadInOut});
   
    }
}