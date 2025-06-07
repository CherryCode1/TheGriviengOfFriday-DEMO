
//fake enum
final BeatType:T = {
	NONE: 0x00,
	IN_OUT: 0x01,
	NORMAL: 0x02
}

var beatThing:Dynamic = BeatType.NONE;
var camerasAffected:Array<Bool> = [true, true]; //[camGame affected, camHUD affected]
var beatInterval:Int = 2;

var ogCamZoom:Float = 1;

function postCreate() {
	time_Txt.font = score_Txt.font = Paths.font("chinese.ttf");

	ogCamZoom = camGame.zoom;
	camGame.alpha = 0;
	camGame.zoom += 0.5;
}

//Making this a map for easier access.
var activeTweens:Map<String, FlxTween> = [];
function onSongStart() {
	activeTweens.set('introTween', FlxTween.tween(camGame, {alpha: 1, zoom: ogCamZoom}, 8, {ease: FlxEase.bounceOut}));
}

function stepHit(curStep:Int) {
	switch(curStep) {
		case 66:
			_stopTween('introTween');
			camGame.alpha = 1;
			activeTweens.set('Tween_1', FlxTween.tween(camGame, {zoom: ogCamZoom + 0.5}, 0.15, {ease: FlxEase.sineOut}));
		case 72:
			activeTweens.set('Tween_1', FlxTween.tween(camGame, {zoom: ogCamZoom}, 0.1, {ease: FlxEase.bounceOut, onComplete:
				function(twn:FlxTween) {
					activeTweens.remove('Tween_1');
				}
			}));
		case 215:
			beatThing = BeatType.IN_OUT;
			beatInterval = 2;
		case 432:
			camerasAffected[0] = false;
			activeTweens.set('Tween_2', FlxTween.tween(camGame, {zoom: ogCamZoom + 0.6}, 8, {ease: FlxEase.sineIn}));
		case 484:
			_stopTween('Tween_2');
			activeTweens.set('Tween_2', FlxTween.tween(camGame, {zoom: ogCamZoom}, 0.2, {ease: FlxEase.bounceOut}));

			beatThing = BeatType.NONE;
			camerasAffected = [false, false];
		
		case 2024:
			
	}
}

var _beatDirection:Bool = false;
var _beatTweenUNO:FlxTween;
var _beatTweenDOS:FlxTween;
function beatHit(curBeat:Int) {
	if(beatThing != BeatType.NONE && (curBeat % beatInterval == 0)) {
		switch(beatThing) {
			case BeatType.IN_OUT:
				if(_beatDirection) {
					camGame.zoom += (camerasAffected[0] ? 0.013 : 0);
					camHUD.zoom += (camerasAffected[1] ? 0.1 : 0);
				} else {
					camGame.zoom -= (camerasAffected[0] ? 0.013 : 0);
					camHUD.zoom -= (camerasAffected[1] ? 0.1 : 0);
				}
				if(camerasAffected[0])
					_beatTweenUNO = FlxTween.tween(camGame, {zoom: ogCamZoom}, 0.3, {ease: FlxEase.sineIn});
				if(camerasAffected[1])
					_beatTweenDOS = FlxTween.tween(camHUD, {zoom: 1}, 0.5, {ease: FlxEase.sineIn});

				_beatDirection = !_beatDirection;
		}
	}
}

//Helper functions//

function _stopTween(tweenTag:String) {
	if(!activeTweens.exists(tweenTag)) return false;

	activeTweens.get(tweenTag).cancel();
	activeTweens.get(tweenTag).destroy();
	activeTweens.remove(tweenTag);

	return true;
}