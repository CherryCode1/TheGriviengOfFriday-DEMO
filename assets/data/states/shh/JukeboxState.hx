import source.funkin.backend.utils.CoolUtil;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
#if DISCORD_RPC
import funkin.backend.utils.DiscordUtil;
#end
#if VIDEO_CUTSCENES
import hxvlc.flixel.FlxVideoSprite;
#end

final IMAGE_PREFIX:String = "menus/freeplay/";
final GLOBAL_SCALE:Float = 0.5;

var bg:FlxSprite;
var topPortion:FlxSprite;
var composerTxt:FlxTypeText;
var selectionTxts:Array<FlxText> = [];
var starsVideo:FlxVideoSprite;
var moniterParts:Array<FlxSprite> = [];

var songList:Array<Dynamic> = [];
var selectionId:Int = 0;

var intervalTime:Float = 2;
var _ogAutoPause:Bool = true;
//

var vocalBGM:FlxSound;
var instBGM:FlxSound;
function create() {
	_ogAutoPause = FlxG.autoPause;
	FlxG.mouse.visible = false;
	
	changePrefix("Jukebox");
	#if DISCORD_RPC
	DiscordUtil.changePresenceSince("In the Jukebox Menu", null);
	#end

	bg = new FlxSprite(0, 0, Paths.image(IMAGE_PREFIX + "bg"));
	bg.scale.set(GLOBAL_SCALE, GLOBAL_SCALE);
	bg.scrollFactor.set(.6, 1.2);
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);
	
	#if VIDEO_CUTSCENES
	starsVideo = new FlxVideoSprite();
	starsVideo.load(Assets.getBytes(Paths.video('stars')), ['input-repeat=65545']);
	starsVideo.bitmap.onFormatSetup.add(function() {
		if(starsVideo.bitmap != null && starsVideo.bitmap.bitmapData != null) {	
			starsVideo.scale.set(0.46, 0.46);
			starsVideo.updateHitbox();
			starsVideo.screenCenter();
			starsVideo.y -= 40;
		}
	});
	add(starsVideo);
	starsVideo.play();
	#else
	var screen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	screen.scale.set(600, 350);
	screen.updateHitbox();
	screen.screenCenter();
	screen.y -= 40;
	add(screen);
	#end

	for(item in ['monitor_down', 'vig', 'monitor']) {
		var _monitorPart = new FlxSprite(0, 0, Paths.image(IMAGE_PREFIX + item));
		if(item == 'vig') _monitorPart.scale.set(GLOBAL_SCALE / 2.3, GLOBAL_SCALE / 2.3);
		else _monitorPart.scale.set(GLOBAL_SCALE, GLOBAL_SCALE);
		_monitorPart.updateHitbox();
		_monitorPart.screenCenter();
		if(item == 'vig') _monitorPart.y -= 30;
		add(_monitorPart);
		moniterParts.push(_monitorPart);
	}
	
	for(week in WeekData) {
		for(song in week.songs) songList.push([song, week.weekName, week.composers]);
	}
	
	//trace(songList);
	
	var selectionTxt:FlxText = new FlxText(0, 0, 500, "< SONGNAME >", 25);
	selectionTxt.screenCenter();
	selectionTxt.setFormat(Paths.font("Gumball.ttf"), 25, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	insert(2, selectionTxt);
	selectionTxts.push(selectionTxt);

	var titleTxt:FlxText = new FlxText(0, 0, 500, "WEEK NAME", 35);
	titleTxt.screenCenter();
	titleTxt.y -= 100;
	titleTxt.setFormat(Paths.font("Gumball.ttf"), 35, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	insert(2, titleTxt);
	selectionTxts.push(titleTxt);
	
	composerTxt = new FlxTypeText(0, 0, 1000, "Composers:", 25);
	composerTxt.prefix = "Composers:\n";
	composerTxt.delay = 0.017;
	composerTxt.screenCenter();
	composerTxt.y = (moniterParts[0].y + moniterParts[0].height) - 200;
	composerTxt.setFormat(Paths.font("Gumball.ttf"), 25, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	composerTxt.borderSize = 0.5;
	add(composerTxt);
	
	//
	
	topPortion = new FlxSprite(0, 0, Paths.image(IMAGE_PREFIX + "box-score"));
	topPortion.alpha = 0.6;
	topPortion.scale.set(GLOBAL_SCALE / 1.5, GLOBAL_SCALE / 1.5);
	topPortion.updateHitbox();
	topPortion.flipX = true;
	add(topPortion);
	
	var stateTxt:FlxText = new FlxText(topPortion.x + 90, topPortion.y + 15, 500, "JUKEBOX", 55);
	stateTxt.setFormat(Paths.font("Gumball.ttf"), 35, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(stateTxt);
	selectionTxts.push(stateTxt);
	
	topPortion.x -= 200;
	stateTxt.x -= 200;

	setAntialiasing(Options.antialiasing, [topPortion, moniterParts[0], moniterParts[1], moniterParts[2], #if VIDEO_CUTSCENES starsVideo, #end bg]);

	FlxTween.tween(topPortion, {x: 0}, 1, {ease: FlxEase.sineOut});
	FlxTween.tween(stateTxt, {x: 90}, 1, {ease: FlxEase.sineOut});

	changeSong();
	intervalTime = 0;

	endSong();
}

function update(elapsed:Float) {
	if(intervalTime > 0) intervalTime -= 0.04;
	if(intervalTime <= 0) {
		if(controls.LEFT || controls.RIGHT) 
			changeSong((controls.LEFT ? -1 : 1));
		if(FlxG.keys.justPressed.TAB)
			starsVideo.autoPause = FlxG.autoPause = !FlxG.autoPause;
	}
	if(FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER) playSong();
	if (controls.BACK) {
        FlxG.switchState(new ModState("MainMenuScreen"));
    }

	if(vocalBGM != null) vocalBGM.volume = FlxG.sound.music.volume;
}

function playSong() {
	endSong();
	
	final curSong:String = songList[selectionId][0];
	changePrefix("Jukebox - Now playing: " + curSong);
	#if DISCORD_RPC
	DiscordUtil.changePresenceSince("In the Jukebox Menu", "Currently playing: " + curSong);
	#end

	vocalBGM = new FlxSound().loadEmbedded(Paths.voices(curSong));
	FlxG.sound.playMusic(Paths.inst(curSong), 1, false);
	vocalBGM.persist = FlxG.sound.music.persist = false;

	vocalBGM.play();
	FlxG.sound.music.play();
}

function endSong() {
	if(FlxG.sound.music != null) {
		FlxG.sound.music.stop();
		FlxG.sound.music.destroy();
	}
	if(vocalBGM != null) {
		vocalBGM.volume = 0;
		vocalBGM.stop();
		vocalBGM.destroy();
	}

	vocalBGM = null;
	FlxG.sound.music = null;
}

function changeSong(delta:Int = 0) {
	selectionId = FlxMath.wrap(selectionId + delta, 0, songList.length - 1);

	selectionTxts[0].applyMarkup("$4$<$4$ " + songList[selectionId][0] + " $4$>$4$", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GRAY, false, false, 0xFF404040), "$4$")]);
	selectionTxts[1].applyMarkup("Track #<BLUE>" + StringTools.lpad(Std.string(selectionId), "0", 2) + "<BLUE>\n<OG>" + songList[selectionId][1] + "<OG>", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF5F87B5, false, false, FlxColor.BLUE), "<BLUE>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFB6513A, false, false, 0xFF682E21), "<RED>"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xDED99BDE, false, false, 0xFFFFE2FF), "<OG>"),
	]);
	
	setComposerText(songList[selectionId][2]);
	intervalTime = 2;
}

function setComposerText(composerList:Array<String>) {
	var finalStr = "";
	for(item in composerList)
		finalStr += item + "\n";

	composerTxt.resetText(finalStr);
	composerTxt.start();
}

function setAntialiasing(newAnti:Bool, group:Array<Dynamic>) {
	for(item in group)
		if(Reflect.field(item, 'antialiasing') != null) item.antialiasing = newAnti;
}

function onFocus() {
	if(FlxG.autoPause) {
		vocalBGM?.resume();
		FlxG.sound.music?.resume();
	}
}
function onFocusLost() {
	if(FlxG.autoPause) {
		vocalBGM?.pause();
		FlxG.sound.music?.pause();
	}
}

function destroy() {
	endSong();
	FlxG.autoPause = _ogAutoPause;
	startedMenuMusic = false;
	FlxG.mouse.visible = true;
}