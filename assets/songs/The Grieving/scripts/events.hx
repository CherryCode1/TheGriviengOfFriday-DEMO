import flixel.text.FlxText;
import flixel.math.FlxPoint;

//Fake enum
final FadeType = {
	NONE:    0x00,
	FADEIN:  0x01,
	FADEOUT: 0x02
};

//On second thought should've made this an array...
var _ogNotePos:Map<Int, Float> = [
	0 => 92,
	1 => 204,
	2 => 316,
	3 => 428,
	4 => 732,
	5 => 844,
	6 => 956,
	7 => 1068
];

var blackOverlay:FlxSprite;
var dialogueTxt:FlxText;
function create() {
	blackOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	blackOverlay.camera = camHUD;
	add(blackOverlay);

	dialogueTxt = new FlxText(0, 0, FlxG.width - 100, "Hello I am text");
	dialogueTxt.setFormat(Paths.font("Sans.otf"), 43, FlxColor.WHITE, "center");
	dialogueTxt.screenCenter();
	dialogueTxt.camera = camHUD;
	add(dialogueTxt);

	dialogueTxt.alpha = 0;
	dialogueTxt.antialiasing = Options.antialiasing;

	dispHudInStart = false;
}

//[game zoom, hud zoom]
public var ogCamZooms:Array<Float> = [1, 1];
function postCreate() {
	ogCamZoom = [camGame.zoom, camHUD.zoom];
	
	var healthBarColors:Array<Int> = [
		Options.colorHealthBar ? '#A5A5A5' : (opponentMode ? '#66FF33' : '#FF0000'),
		Options.colorHealthBar ? '#FFFFFF' : (opponentMode ? '#FF0000' : '#66FF33')
	];

	iconP1.setIcon('bfdog');
	healthBar.createFilledBar(FlxColor.fromString(healthBarColors[0]), FlxColor.fromString(healthBarColors[1]));
	healthBar.updateBar();
	
	camFollowChars = false;
	
	final opponentMidpoint = dad.getGraphicMidpoint();
	camFollow.setPosition(opponentMidpoint.x / dad.scale.x, opponentMidpoint.y / dad.scale.y / 1.2);
}

//camera bop and tilting, ignore
var beatOptions:Map<String, Dynamic> = [
	"beatPerSection" => 2,
	"canBeat" => false,
	"hudBeat" => 0.03,
	"gameBeat" => 0.015,
	"tilting" => false,
	"sideBySide" => false
];
var _tiltLeft:Bool = false;
var _moveLeft:Bool = false;
var _tiltTweenUNO:FlxTween;
var _tiltTweenDOS:FlxTween;

function stepHit(curStep:Int) {
	if(curStep < 666) {
		beginningTalk(curStep-15);
		return;
	}

	if(curStep == 666 || curStep == 669 || curStep == 671) {
		camHUD.zoom += 0.2;
		return;
	}
	if(curStep == 673) {
		dispHud(true, true, 1, showNotesStart);

		camHUD.zoom = ogCamZoom[1];
		camHUD.flash(FlxColor.WHITE, 1);
		dialogueTxt.visible = blackOverlay.visible = false;
		return;
	}
	
	switch(curStep) {
		case 800:
			beatOptions.set('canBeat', true);
			beatOptions.set('beatPerSection', 2);
		case 864: beatOptions.set('hudBeat', 0.05);
		case 920: beatOptions.set('canBeat', false);
		case 927: 
			beatOptions.set('canBeat', true);
			beatOptions.set('hudBeat', 0.03);
			beatOptions.set('beatPerSection', 1);
			beatOptions.set('tilting', true);
		case 1083 | 1148 | 1852 | 1916: 
			beatOptions.set('canBeat', false);
			camGame.angle = (curStep == 1083 || curStep == 1852) ? 25 : -25;
			setCamZoom(1.2, false);
		case 1088 | 1152 | 1856 | 1920:
			camHUD.flash(FlxColor.WHITE, 1);
			camGame.angle = 0;
			setCamZoom(-1, false);
			beatOptions.set('canBeat', true);
			if(curStep == 1856) {
				beatOptions.set('hudBeat', 0.045);
				beatOptions.set('gameBeat', 0.020);
				beatOptions.set('sideBySide', true);
			}
		case 1184:
			camHUD.flash(FlxColor.GRAY, 1);
			camGame.angle = 0;
			beatOptions.set('canBeat', false);
		case 1568:
			beatOptions.set('canBeat', true);
			beatOptions.set('hudBeat', 0);
			beatOptions.set('gameBeat', 0);
			beatOptions.set('tilting', false);
			beatOptions.set('beatPerSection', 2);
			
			beatOptions.set('sideBySide', true);
		case 1680:
			beatOptions.set('beatPerSection', 1);
		case 1688: beatOptions.set('canBeat', false);
		case 1696: 
			beatOptions.set('canBeat', true);
			beatOptions.set('tilting', true);
			beatOptions.set('sideBySide', false);
			beatOptions.set('hudBeat', 0.035);
			beatOptions.set('gameBeat', 0.017);
		case 1952:
			camHUD.flash(FlxColor.GRAY, 1);
			_tiltTweenDOS = FlxTween.tween(camGame,{angle: 360}, 1, {ease: FlxEase.sineOut});
			beatOptions.set('canBeat', false);
		case 1956:
			FlxTween.tween(camGame, {zoom: 0.8}, 8, {ease: FlxEase.sineIn});
			FlxTween.tween(camHUD, {alpha: 0.4}, 8, {ease: FlxEase.sineIn});
		case 1987: camGame.visible = camHUD.visible = false;
	}
}

function beatHit(curBeat:Int) {
	if(beatOptions.get('canBeat') && (curBeat % beatOptions.get('beatPerSection') == 0)) {
		camHUD.zoom += beatOptions.get('hudBeat');
		FlxG.camera.zoom += beatOptions.get('gameBeat');
		if(beatOptions.get('tilting')) {
			camHUD.angle = _tiltLeft ? 7 : -7;
			camGame.angle = _tiltLeft ? -7 : 7;
			_tiltLeft = !_tiltLeft;

			_tiltTweenUNO = FlxTween.tween(camHUD, {angle: 0}, 0.2, {ease: FlxEase.sineOut});
			_tiltTweenDOS = FlxTween.tween(camGame,{angle: 0}, 0.2, {ease: FlxEase.sineOut});
		}
		if(beatOptions.get('sideBySide')) {
			camHUD.x = _moveLeft ? 40 : -40;
			FlxTween.tween(camHUD, {x: 0}, 0.2, {ease: FlxEase.sineOut});
			_moveLeft = !_moveLeft;
		}
	}
}

function setCamZoom(newZoom:Float, isAddon:Bool = false) {
	if(newZoom == -1) newZoom = ogCamZoom[0];
	if(isAddon) camGame.zoom = defaultCamZoom += newZoom;
	else camGame.zoom = defaultCamZoom = newZoom;
}

function beginningTalk(step:Int) {
	switch(step) {
		case 0: textInsert("Warning", 43, FadeType.FADEIN, 0.5);
		case 10: textInsert("Warning", 43, FadeType.FADEOUT, 0.5);
		case 17: textInsert("Not for the faint hearted", 43, FadeType.FADEIN, 0.5);
		case 40: textInsert("Not for the faint hearted", 43, FadeType.FADEOUT, 0.5);
		
		case 50: textInsert("You are about to see the first real\nfootage from a lost episode called", 43, FadeType.FADEIN, 0.5);
		case 121: textInsert("You are about to see the first real\nfootage from a lost episode called", 43, FadeType.FADEOUT, 0.5);
		
		case 128: textInsert("THE GRIEVING", 73, FadeType.FADEIN, 0.5);
		case 145: textInsert("THE GRIEVING", 73, FadeType.FADEOUT, 0.5);
		
		case 160: textInsert("Most people who have watched it", 43, FadeType.FADEIN, 0.5);
		case 188: textInsert("Most people who have watched it", 43, FadeType.FADEOUT, 0.5);
		
		case 192: textInsert("have never", 43, FadeType.FADEIN, 0.3);
		case 202: textInsert("have never", 43, FadeType.FADEOUT, 0.3);
		case 206: textInsert("been seen", 43, FadeType.FADEIN, 0.3);
		case 217: textInsert("been seen", 43, FadeType.FADEOUT, 0.3);
		case 220: textInsert("again", 43, FadeType.FADEIN, 0.3);
		case 232: textInsert("again", 43, FadeType.FADEOUT, 0.3);
		
		case 240: textInsert("THE GRIEVING", 73, FadeType.FADEIN, 0.3);
		case 258: textInsert("THE GRIEVING", 73, FadeType.FADEOUT, 0.3);
		
		case 261: textInsert("contains scenes that\nsome viewers may find", 43, FadeType.FADEIN, 0.4);
		case 300: textInsert("contains scenes that\nsome viewers may find", 43, FadeType.FADEOUT, 0.4);
		
		case 308: textInsert("extremely", 73, FadeType.FADEIN, 0.3);
		case 323: textInsert("extremely", 73, FadeType.FADEOUT, 0.3);
		case 325: textInsert("upsetting", 73, FadeType.FADEIN, 0.3);
		case 338: textInsert("upsetting", 73, FadeType.FADEOUT, 0.3);
		
		case 343: textInsert("The Amazing World of Gumball", 43, FadeType.FADEIN, 0.4);
		case 370: textInsert("The Amazing World of Gumball", 43, FadeType.FADEOUT, 0.4);
		
		case 373: textInsert("cannot", 43, FadeType.FADEIN, 0.4);
		case 382: textInsert("cannot", 43, FadeType.FADEOUT, 0.4);
		
		case 386: textInsert("and will not", 43, FadeType.FADEIN, 0.4);
		case 403: textInsert("and will not", 43, FadeType.FADEOUT, 0.4);
		
		case 408: textInsert("accept any responsibility\nfor the effects of", 43, FadeType.FADEIN, 0.4);
		case 450: textInsert("what you are about to see", 43, FadeType.NONE, 3.14);
		case 471: textInsert("what you are about to see", 43, FadeType.FADEOUT, 0.5);
		
		case 536-15: textInsert("YOU", 43, FadeType.FADEIN, 0.3);
		case 543-15: textInsert("YOU", 43, FadeType.FADEOUT, 0.3);
		case 546-15: textInsert("HAVE", 53, FadeType.FADEIN, 0.3);
		case 554-15: textInsert("HAVE", 53, FadeType.FADEOUT, 0.3);
		
		case 557-15: textInsert("BEEN", 63, FadeType.FADEIN, 0.3);
		case 568-15: textInsert("BEEN", 63, FadeType.FADEOUT, 0.3);
		case 577-15: textInsert("WARNED", 73, FadeType.FADEIN, 0.7);
		case 594-15: textInsert("WARNED", 73, FadeType.FADEOUT, 1);
	}
}

var _dialogueTweenHandler:FlxTween;
function textInsert(txt:String, txtSize:Float, fadeType:FadeType, duration:Float) {
	dialogueTxt.text = txt;
	if(txtSize != null) dialogueTxt.size = txtSize;
	if(fadeType != null && fadeType != FadeType.NONE) {
		if(_dialogueTweenHandler != null) _dialogueTweenHandler.cancel();
		_dialogueTweenHandler = FlxTween.tween(dialogueTxt, {alpha: (fadeType == FadeType.FADEIN ? 1 : 0)}, duration);
	}
}