var turnOffShader = new CustomShader("tv_off");
var time_ = 0;

function create()
{
   camGame.alpha = 0;
   turnOffShader.iTime = 0;
}

function update(elapsed){
    turnOffShader.iTime = time_;
    if (curStep > 902 && curStep < 920){
        time_ += elapsed;
    }
    if (curStep > 1179 && curStep < 1193){
        time_ += elapsed;
    }
}

function stepHit()
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

            case 910:   time = 0;
            case 920: camHUD.flash(FlxColor.BLACK,4);
            case 904:
                strumLines.members[0].characters[0].playAnim("anim o si o si",true);
                strumLines.members[0].characters[1].playAnim("anim o si o si",true);
                trace("la anim del mononoisas");
            case 907: camGame.addShader(turnOffShader);
            camHUD.addShader(turnOffShader);
            case 768:
                FlxTween.tween(FlxG.camera, {zoom: 0.62}, 1, {
					ease: FlxEase.cubeOut, onComplete: function sex(tk:FlxTween){defaultCamZoom = FlxG.camera.zoom;}
					});   
            case 1183:
                strumLines.members[2].characters[0].visible = yoshi.visible = true;
        
            case 1186:
                camHUD.flash(FlxColor.BLACK,2);
                camGame._filters = [];
                camHUD._filters = [];
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