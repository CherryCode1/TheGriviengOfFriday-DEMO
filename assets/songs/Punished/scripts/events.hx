function postUpdate(elapsed:Float){
    if (curStep > 255){
        if (curStep % 4 == 0)
            FlxTween.tween(camHUD, {y: -15}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
        if (curStep % 4 == 2)
            FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
    }  
}
function stepHit(){
    switch(curStep){
        case 1: camHUD.height = FlxG.height + 15;
        case 248: camGame.fade(FlxColor.BLACK,0.35,false);
        case 255: camGame.fade(FlxColor.BLACK,0.00001,true);
    }
}