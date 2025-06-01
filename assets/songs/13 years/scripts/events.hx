function postCreate(){
    camFollowChars = false;
    camFollow.setPosition(1100,-200);

    dad.cameraOffset.x += 100;
}

function onStartSong(){
    FlxTween.tween(camFollow,{x:500,y:300},4,{ease:FlxEase.quadInOut,onComplete: function(){camFollowChars = true;}});
}