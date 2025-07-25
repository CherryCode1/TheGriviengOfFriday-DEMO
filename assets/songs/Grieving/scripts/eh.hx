import openfl.geom.ColorTransform;
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

function stepHit(){
    switch(curStep){
        case 2176: 
            tweenHud();
            boyfriend.cameraOffset.x += 40;
            FlxTween.color(gf, 1, gf.color, FlxColor.BLACK);
            defaultCamZoom = 1.01;
          
            FlxTween.tween(dad,{
                "colorTransform.redOffset": 3,
                "colorTransform.greenOffset": 99,
                "colorTransform.blueOffset": 252,
                "colorTransform.alphaOffset": 1,
                "colorTransform.redMultiplier": 3,
                "colorTransform.greenMultiplier": 99,
                "colorTransform.blueMultiplier": 252,
                "colorTransform.alphaMultiplier": 1
            },1);

             FlxTween.tween(boyfriend,{
                "colorTransform.redOffset": 3,
                "colorTransform.greenOffset": 7,
                "colorTransform.blueOffset": 252,
                "colorTransform.alphaOffset": 1,
                "colorTransform.redMultiplier": 3,
                "colorTransform.greenMultiplier": 7,
                "colorTransform.blueMultiplier": 252,
                "colorTransform.alphaMultiplier": 1
            },1);

            for (items in [bg,stairs]){
                FlxTween.tween(items, {alpha: 0},1);
            }
    }
}