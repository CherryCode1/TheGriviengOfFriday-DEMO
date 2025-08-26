import flixel.util.FlxGradient;
import flixel.math.FlxBasePoint;
import funkin.backend.FunkinText;
import flixel.util.FlxStringUtil;
import flixel.util.FlxAxes;
import flixel.text.FlxTextAlign;
import hxvlc.flixel.FlxVideoSprite;
import funkin.editors.charter.Charter;

public static var hudAssets:Array<Dynamic> = [];

public var camOverlay:FlxCamera = new FlxCamera();
public var defaultOpponentStrum:Array<FlxBasePoint> = [];
public var defaultPlayerStrum:Array<FlxBasePoint> = [];
public var healthBarDefault:Bool = false;
public var barrVisible = true;
public var healthBarBG_1:FlxSprite;
public var showNotesStart:Bool = true;
public var dispHudInStart:Bool = true;
public var distortion_Croma:Float = 0.0;
public var score_Txt:FunkinText;
public var time_Txt:FunkinText;
public var timeBarr:FlxSprite;
public var timeBarrBG:FlxSprite;
public var timeBarrBG_2:FlxSprite;
public var songStarted:Bool = false;
public var respectMouseVisibility:Bool = false; //Determines if the cursor is hidden during a song -TBar
public var timeBarrWidth:Float = 0;
var healthBarBG_Offset:Array<Float> = [];
public var creditsArray:Array<String> = [];
var songsArray:Array<String> = [];
var curSong_:Int = 0;
var prevStrAlpha:Map<Int, Float> = [];
var warpCroma_Shader:CustomShader = new CustomShader("chromaticWarp");
var songLength:Float = 0.0;

function create() { 
    allowGitaroo = false;

    score_Txt = new FunkinText(0, 0, FlxG.width, "Score: 0 | Misses: 0 | Accuracy:  % 0 [?]", 20, true);
    score_Txt.alignment = FlxTextAlign.CENTER;
    score_Txt.screenCenter(FlxAxes.X);
    score_Txt.camera = camHUD;
	score_Txt.font = getFont("Gumball.ttf");
    score_Txt.borderSize = 1.4;
    if (PlayState.SONG.meta.name == "My Amazing Sadness" || PlayState.SONG.meta.name == "my amazing sadness") score_Txt.color = FlxColor.fromRGB(61, 122, 191);
	if (PlayState.SONG.meta.name == "Punished") {
		score_Txt.font = getFont("CascadiaMonoPL-Bold.otf");
		score_Txt.color = FlxColor.BLACK;
		score_Txt.borderSize = 0;
		score_Txt.size = 15;
	}
    add(score_Txt);  

    time_Txt = new FunkinText(0, 20, FlxG.width/2, "0:00", 30, true);
    time_Txt.alignment = FlxTextAlign.CENTER;
    time_Txt.screenCenter(FlxAxes.X);

    time_Txt.camera = camHUD;
	time_Txt.font = getFont("Gumball.ttf");
    time_Txt.borderSize = 1.4;

    if (PlayState.SONG.meta.name == "My Amazing Sadness" || PlayState.SONG.meta.name == "my amazing sadness") time_Txt.color = FlxColor.fromRGB(61, 122, 191);

	
	timeBarrBG_2 = new FlxSprite().makeGraphic(280,20,FlxColor.BLACK);
	timeBarrBG_2.screenCenter(FlxAxes.X);
	timeBarrBG_2.setPosition(510 ,25);
	timeBarrBG_2.camera = camHUD;

	timeBarrBG = new FlxSprite();
	timeBarrBG = FlxGradient.createGradientFlxSprite(300, 30, [FlxColor.fromRGB(0,0,0)],1,-90);
	timeBarrBG.screenCenter(FlxAxes.X);
	timeBarrBG.setPosition(500 ,20);
	timeBarrBG.camera = camHUD;
	
	
	var colors:Array<FlxColor> = switch(PlayState.SONG.meta.name){
		case "My Amazing Sadness", "my amazing sadness", "Grieving", "Grieving - old", "grieving",
	     "Denial - old", "daniel", "denial", "Denial", "Loss", "loss","My doll", "My Doll": [FlxColor.fromRGB(57, 126, 204),FlxColor.fromRGB(43, 80, 122)];
		case "Enigma", "enigma","Affiliation", "affiliation": [FlxColor.fromRGB(68, 137, 171),FlxColor.fromRGB(48, 98, 122)];
	    case "Miracle": [FlxColor.fromRGB(214, 168, 103),FlxColor.fromRGB(150, 118, 72)];
		case "Cherophobia": [FlxColor.fromRGB(86, 166, 184),FlxColor.fromRGB(156, 184, 86), FlxColor.fromRGB(86, 184, 163)];
		default: [FlxColor.fromRGB(168, 168, 168),FlxColor.fromRGB(266,266,266)];
	}
	timeBarr = new FlxSprite();
   
	timeBarr.camera = camHUD;

	 if (PlayState.SONG.meta.name != "Punished") {
		timeBarrWidth = timeBarr.width;
		timeBarr = FlxGradient.createGradientFlxSprite(280, 20, colors,1,90);
		timeBarr.setPosition(timeBarrBG.x + 10, timeBarrBG.y + 5);
	 }


    if (PlayState.SONG.meta.name == "Punished" || PlayState.SONG.meta.name == "13 years") healthBarDefault = true;

}
function getFont(key:String = "Gumball.ttf")
	return Paths.font(key);
function onStrumCreation(event:StrumCreationEvent){
    event.__doAnimation = false;
}

function onNoteHit(event){
	switch(PlayState.SONG.meta.name){
		case "Clown Eyes" , "clown eyes":  event.ratingPrefix = "game/score/clown/";
		case "My Amazing Sadness", "my amazing sadness", "Grieving", "Grieving - old", "grieving",
	     "Denial - old", "daniel", "denial", "Denial", "Loss", "loss":
		event.ratingPrefix = "game/score/grivieng/";
		case "My Doll": event.ratingPrefix = "game/score/clown/"; // placeHolder
		case "Affiliation", "affiliation": event.ratingPrefix = "xploshiUI/";

	}
	//trace(event.ratingPrefix);
	
    if (event.note.isSustainNote) return;

    if (!event.animCancelled)
        for(char in event.characters)
			if (char == dad) iconP2.scale.set(1.2,1.2);
}

function onPlayerHit(event){
    if (event.note.isSustainNote) return;
    iconP1.scale.set(1.2,1.2);

	if (PlayState.SONG.meta.name != "Punished") score_Txt.scale.set(1.1,1);
}

function postCreate() {
	camOverlay.bgColor = 0x00000000;
    FlxG.cameras.add(camOverlay, false);
   
	if (PlayState.instance.isStoryMode) trace(PlayState.instance.storyPlaylist);

    insert(0, time_Txt);
	insert(members.indexOf(time_Txt), timeBarrBG);
	insert(members.indexOf(timeBarrBG) + 1,timeBarrBG_2);
    insert(members.indexOf(timeBarrBG) + 2,timeBarr);


    for (i in [0,1,2,3]) {
        var strum = strumLines.members[0].members[i];
        defaultOpponentStrum.push(new FlxBasePoint().set(strum.x,strum.y));

        var strum = strumLines.members[1].members[i];
        defaultPlayerStrum.push(new FlxBasePoint().set(strum.x,strum.y));
    }

    for (i in [scoreTxt, accuracyTxt,missesTxt]) remove(i);

    creditsArray = getCredits();
    songsArray = getSongs();

    for (i in 0...songsArray.length){
        if (PlayState.SONG.meta.name == songsArray[i]) curSong_ = i;
    }

    doIconBop = false;
	if(!respectMouseVisibility) FlxG.mouse.visible = false;

    if (!healthBarDefault){
        remove(healthBarBG);

        healthBarBG_1 = new FlxSprite();
        healthBarBG_1.loadGraphic(getBarrPath());
        healthBarBG_1.offset.set(healthBarBG_Offset[0],healthBarBG_Offset[1]);
        healthBarBG_1.camera = camHUD;
        healthBarBG_1.setPosition(healthBar.x,healthBar.y);
        insert(members.indexOf(healthBar) + 1,healthBarBG_1);
      
    }
  
    if (PlayState.SONG.meta.name == "Punished") score_Txt.y = 55; else score_Txt.y = healthBar.y + 35;
    dispHud(false,true,0.1,true);

    changePrefix(PlayState.SONG.meta.name + ' - by: ' + creditsArray.get(PlayState.SONG.meta.name.toLowerCase()));
	PauseSubState.script = "data/substates/pauseSubState";

    FlxG.game.addShader(warpCroma_Shader);
}
function onGameOver(){
	camHUD.visible = false;
	FlxG.camera.stopFade();
	FlxG.camera.fade(FlxColor.BLACK,0.0001,true);
}
public function changeColorTimeBarr(colors:Array<FlxColor>) {
    var newGfx = FlxGradient.createGradientBitmapData(280, 20, colors, 1, 90);
    timeBarr.pixels = newGfx;
    timeBarr.dirty = true;
    trace("la barra cambio de color");
}
function getBarrPath():Void{
    var path:String = "default";
	switch(PlayState.SONG.meta.name){
		case "Mistery": 
			path = "Mistery";
			healthBar.scale.set(1.05,4.04);
			if(get_downscroll()){
				healthBarBG_Offset[0] = 95;
				healthBarBG_Offset[1] = -32;
			} else {
				healthBarBG_Offset[0] = 95;
				healthBarBG_Offset[1] = 32;
			}
		case "Enigma": 
			path = "enigma";
			if(get_downscroll()){
				healthBarBG_Offset[0] = 95;
				healthBarBG_Offset[1] = -32;
			} else {
				healthBarBG_Offset[0] = 95;
				healthBarBG_Offset[1] = 32;
			}
			healthBar.scale.set(1.05,4.04);
        case "Miracle": 
			path = "Miracle";
			if(get_downscroll()){
				healthBarBG_Offset[0] = 90;
				healthBarBG_Offset[1] = -35;
			} else {
				healthBarBG_Offset[0] = 90;
				healthBarBG_Offset[1] = 35;
			}
			healthBar.scale.set(1.07,1.8);
		case "Affiliation", "affiliation":
			path = "Affiliation";
			if(get_downscroll()){
				healthBarBG_Offset[0] = 90;
				healthBarBG_Offset[1] = -35;
			} else {
				healthBarBG_Offset[0] = 85;
				healthBarBG_Offset[1] = 35;
			}
			healthBar.scale.set(1.1,1.36);
		case "The Grieving" | "the-grieving":
			path = "the-grieving";
			if(get_downscroll()){
				healthBarBG_Offset[0] = 90;
				healthBarBG_Offset[1] = -35;
			} else {
				healthBarBG_Offset[0] = 90;
				healthBarBG_Offset[1] = 35;
			}
			healthBar.scale.set(1.04, 1.8);
        default: 
			if(get_downscroll()){
				healthBarBG_Offset[0] = 35;
				healthBarBG_Offset[1] = -32;
			} else {
				healthBarBG_Offset[0] = 35;
				healthBarBG_Offset[1] = 30;
			}
    }
    return Paths.image('healthBars/' + path);
    
}   
function onStartSong() {
    songStarted = true;   
    songLength = inst.length;

    if(dispHudInStart) dispHud(true, false, 1, showNotesStart);
}

function destroy(){
    FlxG.game._filters = [];
	if(!respectMouseVisibility) FlxG.mouse.visible = true;
}

var camerasFixed:Bool = false;

function postUpdate() {   

    if (songStarted && timeBarr != null && songLength > 0 && !paused) {
     var curTime:Float = Math.max(0, Conductor.songPosition);
     var ratio:Float = FlxMath.bound(curTime / songLength, 0, 1); 

     timeBarr.scale.x = ratio;
     timeBarr.updateHitbox();
    }
	
	if (iconP1 != null && iconP2 != null) {
		for (icon in [iconP1,iconP2])
			icon.scale.set( FlxMath.lerp(icon.scale.x,1,0.1), FlxMath.lerp(icon.scale.y,1,0.1));
	}

    if(songScore > 0 || misses > 0 && accuracy != - 100) {
		if (PlayState.SONG.meta.name != "Punished") {
			score_Txt.scale.set(
			lerp(score_Txt.scale.x,1,0.1),
			lerp(score_Txt.scale.y,1,0.1)
			);
		}

		if (score_Txt != null){
			if (PlayState.SONG.meta.name == "Miracle" || PlayState.SONG.meta.name == "miracle"){
				if (curStep >=  2034 && curStep < 2609) score_Txt.text = "句読点: "+ FlxStringUtil.formatMoney(songScore,false,true) + "   失敗: "  + misses + "   失敗: "+ CoolUtil.quantize(accuracy * 100, 100) + "% ["+ curRating.rating + "]";
				else score_Txt.text = "Score: "+ FlxStringUtil.formatMoney(songScore,false,true) + " | Misses: "  + misses + " | Accuracy: "+ CoolUtil.quantize(accuracy * 100, 100) + "% ["+ curRating.rating + "]";
				
			}else{
				score_Txt.text = "Score: "+ FlxStringUtil.formatMoney(songScore,false,true) + " | Misses: "  + misses + " | Accuracy: "+ CoolUtil.quantize(accuracy * 100, 100) + "% ["+ curRating.rating + "]";
			}

		}
		
       
      
    }
	
    if(songStarted) {
        var curTime:Float = Math.max(0, Conductor.songPosition);

        var songCalc:Float = (curTime);
        var secondsTotal:Int = Math.floor(songCalc / 1000);

        if (time_Txt != null) time_Txt.text = FlxStringUtil.formatTime(secondsTotal, false);
    }

    warpCroma_Shader.distortion = distortion_Croma;
    distortion_Croma = lerp(distortion_Croma,0 ,0.02);
}

function onGameOver(e) if(PlayState.chartingMode) e.cancel();

// BACKEND //

public static function updateHudAssets() {
    hudAssets = [];

	for(item in [iconP1, iconP2, healthBar, healthBarBG, healthBarBG_1, score_Txt, time_Txt,timeBarr,timeBarrBG,timeBarrBG_2]) 
		if(item != null && item.exists) hudAssets.push(item);

}

public static function dispHud(show:Bool, instant:Bool = false, tweenTime:Float = 1,strumsDisp:Bool = true) {
    updateHudAssets();

    if (instant) tweenTime = 0.001;
    if (strumsDisp) strAlpha(show ? 1 : 0, tweenTime);

	for (hS in hudAssets) {   
		FlxTween.tween(hS, {alpha: (show ? 1 : 0)}, tweenTime);
	}
}
    
public function strAlpha(alpha:Null<Float> = null, tweenTime:Float = 1, ?str:Int) {
	final show:Bool = (alpha == null || alpha != 0);

	if (str != null) {
		_tweenAlphaOnStr(alpha, str, strumLines.members[str], tweenTime, show);
		return;
	}
	for (i=>s in strumLines.members) _tweenAlphaOnStr(alpha, i, s, tweenTime, show);
}
    
function _tweenAlphaOnStr(alpha:Null<Float>, strId:Int, str:StrumLine, tweenTime:Float, tweenIn:Bool) {
	if (!tweenIn) prevStrAlpha.set(strId, str.members[0].alpha);
	final goalAlpha:Float = tweenIn ? (alpha ?? prevStrAlpha[strId]) : 0.0001;
    
	for (s in str) {
		s.shader = null;
		FlxTween.tween(s, {alpha: goalAlpha}, tweenTime);
	}
	for (n in str.notes) {
		final nGoalAlpha:Float = n.isSustainNote ? goalAlpha / 1.6 : goalAlpha;
		FlxTween.tween(n, {alpha: nGoalAlpha}, tweenTime);
	}
}

public static function changeSpeedAngleCamera(speed:String) {
	//speedAngle = Std.float(speed);
}

public static function desactivateZoom(){
	camZoomingStrength = 0.0;
}
    

public static function changeSpeedLerp(speed:String) {
	var shit:Float = Std.parseFloat(speed);
	camGame.followLerp = speed * 0.1;  
}

public static function showHud() {
	dispHud(true, false, 1,true);
}
public static function hideHud(){
    dispHud(false, false, 1,true);
}
public function fadeCam(){
	camGame.stopFade();
	camGame.fade(FlxColor.BLACK,1,false);
} 

public function deFadeCam(){
	camGame.stopFade();
	camGame.fade(FlxColor.BLACK,1,true);
}

var activeCroma:Bool = false;
var amounBeat_:String = "";
function beatHit(){
	if(curBeat % camZoomingInterval == 0 && activeCroma) setWarpCroma(amounBeat_);
}
public static function flashCamOverlay(time:String) camOverlay.flash(FlxColor.WHITE, Std.parseFloat(time));
public static function setAmountBeat(amountBeat:String) amounBeat_ = amounBeat;
public static function activeWarpCroma() activeCroma = !activeCroma;
public static function setWarpCroma(amount:String) distortion_Croma += Std.parseFloat(amount);
public static function desactivateZoom() camZoomingStrength = 0.0;