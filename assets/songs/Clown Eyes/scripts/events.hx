var turnOffShader = new CustomShader("tv_off");
var redFilter = new FlxSprite();
var screenSprite = new FlxSprite();
function create(){
camFollowChars  =  dispHudInStart = false;
} 
function postCreate(){
    turnOffShader.uTime = 0;
    camFollow.setPosition(1200,800);
    boyfriend.x += 400;
    FlxG.camera.zoom = 1.1;

    redFilter.makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(255, 55, 0));
    redFilter.blend = 9;
    redFilter.alpha = 0;
    redFilter.cameras = [camOverlay];
    add(redFilter);

   
   camGame.addShader(turnOffShader);
   camHUD.addShader(turnOffShader);  
}

var time_ = 0;
var turnOff_E = 0;
function update(elapsed){
    time_ += elapsed;
    turnOffShader.iTime = turnOff_E;
    if (curStep > 843 && curStep < 850){
        turnOff_E = time_;
    }else{
        turnOff_E = 0;
    }
}
function stepHit(){
    if (curStep == 592){
        redFilter.alpha = 0.6;
        fire_Sprite.visible = true;
    }
    if (curStep == 844){
      
        fire_Sprite.visible = false;
        FlxTween.tween(redFilter,{alpha: 0},0.25);
        desactivateZoom_A = true;
    }
    if (curStep == 848){
        desactivateZoom_A = false;
    }
}
function onSongStart() 
{
    FlxTween.tween(dad,{y:190},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut,onComplete: function(){camFollowChars = true;}});
    FlxTween.tween(boyfriend,{x:boyfriend.x - 400},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut});
    FlxTween.tween(FlxG.camera,{zoom:0.65},Conductor.stepCrochet / 1000 * 8,{ease:FlxEase.quadOut});
}