var beatInterval:Int = 2;
var _timerTrans:FlxTimer; 

function create()
{
	splashSkin = "default-griv";
	_timerTrans = new FlxTimer();

	cumTrans = new FlxSprite(0,0);
    cumTrans.frames = Paths.getSparrowAtlas("stages/copycat/milkTransition");
    cumTrans.animation.addByPrefix("instance", "milkSeq", 24, true);
    cumTrans.camera = camOverlay;
    cumTrans.scale.set(1,1);
    cumTrans.alpha = 0;
    cumTrans.screenCenter();
    add(cumTrans);

	camGame.fade(FlxColor.BLACK,0.0001,false);
}

function onStartSong(){
	camGame.fade(FlxColor.BLACK,1,true);
}

function stepHit(curStep:Int) {
	switch(curStep) {
		case 66:
			camGame.alpha = 1;
	
		case 2016:
			cumTrans.alpha = 1; 
			cumTrans.animation.play("instance");
		    _timerTrans.start(2.1, function(timer:FlxTimer) {
            cumTrans.alpha = 0; 
            });
		case 2034:
			time_Txt.font = score_Txt.font = Paths.font("chinese.ttf");
			FlxG.camera.zoom = defaultCamZoom = 0.4;
		case 2610:
			time_Txt.font = score_Txt.font = Paths.font("Gumball.ttf");
			FlxG.camera.zoom = defaultCamZoom = 0.75;
		case 2935:
			camGame.alpha = 0;	
	}
}