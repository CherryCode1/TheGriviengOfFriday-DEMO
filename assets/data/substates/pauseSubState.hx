import funkin.options.OptionsMenu;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTweenType;
import flixel.text.FlxTextAlign;
import flixel.util.FlxAxes;
import openfl.display.BlendMode;
import funkin.options.TreeMenu;
import funkin.backend.system.Conductor;
import funkin.backend.utils.FunkinParentDisabler;
import funkin.editors.charter.Charter;
import funkin.options.keybinds.KeybindsOptions;

var options:Array<String> = ["resume", "restart", "options", "exit"];
var offsetHand_:Array<Float> = [-25, 100, 200, 300];

var blockedOptions:Array<String> = [];

//fake enum, you get it by now
final CharacterPortrait:T = {
	THE_GRIEVING: 0,
	DISCARDED: 1,
	MIRACLE_STAR: 8,
	GRIEVING_CANON: 3,
	MURDER: 4,
	THE_KIDS: 9,
	THE_JOY: 2,
	PIBBY: 7,
	CASTIGADO: 5,
	PROCRASTINATION: 6,
	XPLOSHI: 10
};

final charPortraitImages:Array<String> = [
	"gumball", "discarded", "the-joy", "the-grievieng",
	"murder", "punished", "clown", "pibby", "chichi", "13_years",
	"gumball_normal"
];
var pauseCam:FlxCamera = new FlxCamera();

var menu_items:Array<FlxSprite> = [];
var board:FlxSprite;
var hand1:FlxSprite;
var hand2:FlxSprite;
var portait:FlxSprite;
var textPause:FlxText;
var bgBackdrop:FlxBackdrop;

var curChar:Int = CharacterPortrait.THE_GRIEVING;
var curSong:Int = 0;

var canPressed:Bool = false;

var composersArray:Array<String> = [];
var songsArray:Array<String> = [];
var prevSuffix:String;

var timeGame = PlayState.instance.curStep;
var color:FlxColor = FlxColor.BLACK;

//song specific bools
final isAffiliation:Bool = false;
final isAmazingSadness:Bool = false;

function create(event) {
	//Initialize
	event.cancel(); 
	event.music = "Pause Theme - The Grieving Of Friday";
	cameras = [];
	curSelected = 0;

	composersArray = getCredits();

	prevSuffix = getWindowSuffix();
	changePrefix(prevSuffix + ' - (PAUSED)');

	FlxG.cameras.add(pauseCam, false);
	pauseCam.bgColor = 0x88000000;
	pauseCam.alpha = 0;
	pauseCam.zoom = 1.25;

	isAffiliation = (PlayState.SONG.meta.name != null && PlayState.SONG.meta.name.toLowerCase() == "affiliation");
	isAmazingSadness = (PlayState.SONG.meta.name != null && PlayState.SONG.meta.name.toLowerCase() == "my amazing sadness");

	if(isAffiliation) pauseCam.scroll.y -= 100;
	FlxTween.tween(pauseCam, {alpha: 1, zoom: (isAffiliation ? 0.75 : 0.95)}, .5, {ease: FlxEase.circOut});

	//Actually adding stuff

	if(!Options.lowMemoryMode) {
		if(isAmazingSadness) {
			color = FlxColor.fromRGB(15, 41, 82);
			if ((timeGame > -1 && timeGame < 1500) || timeGame > 1759) color = FlxColor.fromRGB(15, 41, 82);
			if (timeGame > 1499 && timeGame < 1759) color = FlxColor.BLACK;
		}

		bgBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, color, 0x0));
		bgBackdrop.velocity.set(-40, 40);
		bgBackdrop.alpha = 0;
		bgBackdrop.scrollFactor.set();
		FlxTween.tween(bgBackdrop, {alpha: 0}, 0.5, {ease: FlxEase.linear});
		add(bgBackdrop);
	}

	board = new FlxSprite(0, 0, Paths.image('menus/pause/board'));
	board.scale.set(1.15, 1.15);
	board.updateHitbox();
	board.screenCenter();
	add(board);

	for (i in 0...options.length) {
		var item:FlxSprite = new FlxSprite();
		item.frames = Paths.getSparrowAtlas('menus/pause/OptionSHEETZ');
		item.animation.addByPrefix('static', options[i] + '0', 24, false);
		item.animation.addByPrefix('select', options[i]+ '_select', 24, false);
		item.animation.play('static');
		item.scale.set(0.55, 0.55);
		item.updateHitbox();
		item.screenCenter();
		item.antialiasing = Options.antialiasing;
		item.ID = i;
		add(item);
		menu_items.push(item);
	}
	updateSelectionVisuals();

	portait = new FlxSprite(0, 0, getRenderChar());
	switch(curChar) {
		case CharacterPortrait.THE_GRIEVING | CharacterPortrait.DISCARDED:
			portait.scale.set(1.15,1.15);
		default:
			portait.scale.set(0.55,0.55);
	}
	portait.updateHitbox();
	portait.screenCenter();
	add(portait);
    
	hand1 = new FlxSprite(0, 0, Paths.image('menus/pause/hand1'));
	hand1.scale.set(1.15,1.15);
	hand1.updateHitbox();
	hand1.screenCenter();
	add(hand1);

	hand2 = new FlxSprite(0, 0, Paths.image('menus/pause/hand2'));
	hand2.scale.set(1.15,1.15);
	hand2.updateHitbox();
	hand2.screenCenter();
	add(hand2);

	textPause = new FlxText(pauseCam.width, 10, FlxG.width / 2, PlayState.SONG.meta.name + "\nby: " + composersArray.get(PlayState.SONG.meta.name.toLowerCase()), 35);
	textPause.setFormat(Paths.font((PlayState.SONG.meta.name == "Miracle" ? "chinese.ttf" : "vcr.ttf")), 35, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textPause.scrollFactor.set(1, 1);
	textPause.borderSize = 1.4;
	textPause.alpha = 0;
	if(isAmazingSadness) textPause.color = FlxColor.fromRGB(0, 48, 255);
	add(textPause);

	if (isAmazingSadness) {
		var filter = new FlxSprite().makeGraphic(pauseCam.width+ 200,pauseCam.height + 200, FlxColor.BLACK);
		filter.screenCenter();
		filter.alpha = 0.1;
		filter.blend = BlendMode.fromString("difference");
		add(filter);

		var filter_2 = new FlxSprite().makeGraphic(pauseCam.width+ 200,pauseCam.height + 200, FlxColor.fromRGB(2, 39, 199));
		filter_2.screenCenter();
		filter_2.alpha = 0.5;
		filter_2.blend = BlendMode.fromString("multiply");
		add(filter_2);

		pauseCam.addShader(grieveSh);
	
		if (timeGame > -1 && timeGame < 1500){
			pauseCam.addShader(grieveSh);
		}
		if (timeGame > 1499 && timeGame < 1759){
			pauseCam._filters = [];
			textPause.color = FlxColor.ORANGE;
			filter.alpha = filter_2.alpha = 0;
		}
		if (timeGame > 1759){
			filter.alpha = 0.1;
			filter_2.alpha = 0.5;
			pauseCam.addShader(grieveSh);
			textPause.color = FlxColor.fromRGB(2, 39, 199);
		}
	}
	if(isAffiliation) {
		textPause.y -= 200;
		textPause.font = "Arial";	
	} 
	cameras = [pauseCam];

	for(item in [hand2, hand1, board]) item.antialiasing = Options.antialiasing;

	FlxTween.tween(textPause, {x: 650, alpha: 1}, 0.8, {startDelay: 0.3, ease: FlxEase.circInOut, onComplete:
		function(twn:FlxTween) {
			if(!Options.lowMemoryMode)
				FlxTween.tween(textPause, {y: textPause.y + 15}, FlxG.random.float(5, 10), {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
		}
	});

	canPressed = true;
}

function updateSelectionVisuals() {
	for (i in 0...menu_items.length) {
		menu_items[i].animation.play((i == curSelected ? "select" : "static"));
	}
}

function getRenderChar():FlxGraphic {
	if(PlayState.SONG.meta.name == null) curChar = CharacterPortrait.THE_GRIEVING;
	else {
		switch(PlayState.SONG.meta.name.toLowerCase()) {
			case "loss", "grivieng", "denial", "my amazing sadness": curChar = CharacterPortrait.THE_GRIEVING;
			case "mistery", "enigma": curChar = CharacterPortrait.DISCARDED;
			case "miracle": curChar = CharacterPortrait.MIRACLE_STAR;
			case "the grieving": curChar = CharacterPortrait.GRIEVING_CANON;
			case "13 years": curChar = CharacterPortrait.THE_KIDS;
			case "cherophobia": curChar = CharacterPortrait.THE_JOY;
			case "my doll": curChar = CharacterPortrait.PIBBY;
			case "punished": curChar = CharacterPortrait.CASTIGADO;
			case "clown eyes": curChar = CharacterPortrait.PROCRASTINATION;
			case "affiliation": curChar = CharacterPortrait.XPLOSHI;
			case "murder": curChar = CharacterPortrait.MURDER;
		}
	}

	return Paths.image('menus/pause/characters/' + charPortraitImages[curChar]);
}

function update(elapsed:Float) {
	if(canPressed) {
		hand2.y = lerp(hand2.y, offsetHand_[curSelected], 0.2);

	    if (controls.DOWN_P) changeSelection(1);
	    if (controls.UP_P) changeSelection(-1);
		
		if (controls.ACCEPT) {
			var option = options[curSelected];
			canPressed = false;

			if(blockedOptions.contains(option)) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.shake(menu_items[curSelected], 0.004, 0.2, FlxAxes.XY, {
					onComplete: function(twn:FlxTween) {
						canPressed = true;
					}
				});
				return;
			}

			FlxG.sound.play(Paths.sound((option == "exit" ? 'cancelMenu' : 'confirmMenu')));
			
			if(textPause != null) {
				FlxTween.cancelTweensOf(textPause);
				FlxTween.tween(textPause, {alpha: 0}, 0.5);
			}
			if(bgBackdrop != null) FlxTween.tween(bgBackdrop, {alpha: 0}, 0.5, {ease: FlxEase.linear});

			new FlxTimer().start(.5, function(tmr:FlxTimer) comeOnDoSomething(option));
		}
	}
}

function changeSelection(change){
	FlxG.sound.play(Paths.sound('scrollMenu'));

	curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
	updateSelectionVisuals();
	//trace(curSelected);
}

function comeOnDoSomething(option:String) {
	FlxTween.tween(pauseCam, {alpha: 0, zoom: (isAffiliation ? 0.95 : 1.2)}, 0.5, {ease: FlxEase.cubeOut});

	new FlxTimer().start(.5, function(tmr:FlxTimer) {
		switch(option) {
			case 'resume':
				close();
			case 'restart':
				game.registerSmoothTransition();
				FlxG.resetState();
			case "options": 
				TreeMenu.lastState = PlayState;
				FlxG.switchState(new OptionsMenu());
			case "exit":
				if (PlayState.chartingMode && Charter.undos.unsaved)
					game.saveWarn(false);
				else {
					PlayState.resetSongInfos();
					if (Charter.instance != null) Charter.instance.__clearStatics();

					// prevents certain notes to disappear early when exiting  - Nex
					game.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

					CoolUtil.playMenuSong();
					FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
				}
		}
	});
}

function destroy() changePrefix(prevSuffix);