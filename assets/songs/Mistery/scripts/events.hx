function create()
{
    camGame.alpha = 0;
}
function stepHit(curSetp:Int)
{
    	switch(curStep) {
            case 1:
                camGame.alpha = 1;
                camGame.flash(FlxColor.BLACK, 18.525);
            case 640:
                FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBarBG_1, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {
					ease: FlxEase.cubeOut, onComplete: function sex(tk:FlxTween){defaultCamZoom = FlxG.camera.zoom;}
					});    
            case 768:
                FlxTween.tween(FlxG.camera, {zoom: 0.62}, 1, {
					ease: FlxEase.cubeOut, onComplete: function sex(tk:FlxTween){defaultCamZoom = FlxG.camera.zoom;}
					});   
            case 1184:
                FlxTween.tween(iconP1, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(iconP2, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBar, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBarBG, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
                FlxTween.tween(healthBarBG_1, {alpha: 1}, 1, {ease: FlxEase.quartInOut});

            case 1744:
                camGame.fade(FlxColor.BLACK,10,false);    
        }
}