var beatInterval:Int = 2;
var _timerTrans:FlxTimer; 

function create()
{
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

	debugText.cameras = [camHUD];
	debugText.visible = false;
	add(debugText);
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

function update() {
	debugStuff();
}

var debugText:FunkinText = new FunkinText(10, 10, FlxG.width, "", 32);
var mult:Int = 1;
var selectedSplash:Int = 0;
var splashesOffsets:Array<Array<Int>> = [
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0]
	// [-7, 23],
	// [-6, 24],
	// [-4, 25],
	// [0, 25],
	// [-9, 16],
	// [-8, 14],
	// [-5, 13],
	// [-4, 21]
];

function debugStuff() {
	if (FlxG.keys.justPressed.NINE) debugText.visible = !debugText.visible;
	if (debugText.visible) {
		if (FlxG.keys.justPressed.SHIFT) mult = mult == 1 ? 10 : 1;
		if (FlxG.keys.justPressed.TAB) selectedSplash++;
		if (selectedSplash >= splashesOffsets.length) selectedSplash = 0;

		if (FlxG.keys.justPressed.T) splashesOffsets[selectedSplash][1] -= mult;
		if (FlxG.keys.justPressed.F) splashesOffsets[selectedSplash][0] -= mult;
		if (FlxG.keys.justPressed.G) splashesOffsets[selectedSplash][1] += mult;
		if (FlxG.keys.justPressed.H) splashesOffsets[selectedSplash][0] += mult;

		debugText.text = 'splash n.' + selectedSplash + ' offsets: [' + splashesOffsets[selectedSplash][0] + ', ' + splashesOffsets[selectedSplash][1] + '], mult: ' + mult;
	}
	else if(splashHandler.members[selectedSplash] == null) trace('the splash n.' + selectedSplash + ' is null!!!');

	if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.O || FlxG.keys.justPressed.L || FlxG.keys.justPressed.K) {
		var num = FlxG.keys.justPressed.P ? 0 : FlxG.keys.justPressed.O ? 1 : FlxG.keys.justPressed.L ? 2 : 3;
		if (playerStrums.members[num] != null) {
			splashHandler.showSplash('miracle', playerStrums.members[num]);
			while (splashHandler.members.length > 1) splashHandler.remove(splashHandler.members[0], true);
			splashHandler.members[splashHandler.members.length - 1].x += splashesOffsets[num][0];
			splashHandler.members[splashHandler.members.length - 1].y += splashesOffsets[num][1];
		}
		else trace('The player strum n.' + num  + ' is null!');
	}
}