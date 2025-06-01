function create() camFollowChars  =  dispHudInStart = false;
function postCreate(){

    camFollow.setPosition(1200,800);
    boyfriend.x += 400;
    FlxG.camera.zoom = 1.1;

   
}
function onSongStart() 
{
    FlxTween.tween(dad,{y:190},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut,onComplete: function(){camFollowChars = true;}});
    FlxTween.tween(boyfriend,{x:boyfriend.x - 400},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut});
    FlxTween.tween(FlxG.camera,{zoom:0.65},Conductor.stepCrochet / 1000 * 8,{ease:FlxEase.quadOut});
}