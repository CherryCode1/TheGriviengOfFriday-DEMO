import flixel.addons.display.FlxBackdrop;

var notebook_bg:FlxSprite;
function new() {
	//this.introLength = 0;
	
	//The FlxBackdrop will fix the black edges showing up with that game spin near the end of the song.
	//edit: nvm I want it removed
	//if(!Options.lowMemoryMode) notebook_bg = new FlxBackdrop(Paths.image("stages/notebook/bg"), FlxAxes.XY);

	notebook_bg = new FlxSprite().loadGraphic(Paths.image("stages/notebook/bg"));
	notebook_bg.scrollFactor.set();
	notebook_bg.scale.set(0.7, 0.7);
	notebook_bg.screenCenter();
	add(notebook_bg);
}
function create(){
	skipCounDown = true;


	noteSkin = "NOTE_assetsDOGGY";
	splashSkin = "default-griv";
}
function postCreate() {
	
	time_Txt.visible = boyfriend.visible = gf.visible = false;
	camGame.zoom = defaultCamZoom = 0.6; //idk why it's not setting this in the stage xml :sob:

	for(strum in cpuStrums) strum.visible = false;
	for(i in 0...4) playerStrums.members[i].x = 420 + (110 * i);
}

//function onCountdown(event:CountdownEvent) event.cancel();

//This is very hacky but I kinda like how it looks
var _targetPlayerAlpha:Float = 1;
function onPlayerHit(event:NoteHitEvent) _targetPlayerAlpha = 1;
function onDadHit(event:NoteHitEvent) _targetPlayerAlpha = 0.5;

function stepHit(curStep:Int) {
	if(!Options.lowMemoryMode)
		for(i in 0...4) playerStrums.members[i].alpha = lerp(playerStrums.members[i].alpha, _targetPlayerAlpha, 0.4);
}