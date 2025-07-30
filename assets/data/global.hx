import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;
import funkin.menus.BetaWarningState;
import openfl.ui.Mouse;
import funkin.backend.utils.WindowUtils;
import openfl.Lib;
import lime.graphics.Image;
import funkin.backend.MusicBeatTransition;
import haxe.format.JsonParser;
import funkin.menus.credits.CreditsMain;
import funkin.backend.system.framerate.Framerate;
import Type;
import hxvlc.flixel.FlxVideoSprite;
import hxvlc.util.Handle;

static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;
public static var video_Path:String = "";
public static var _nextState:FlxState;
public static var _nextState_loading:FlxState;

static var windowTitle:String = "The Grieving Of Friday";
public static var window_suffix:String = "";
static var modInfo:Dynamic;

static var redirectStates:Map<FlxState, String> = [
    MainMenuState => "MainMenuScreen",
    StoryMenuState => "MainMenuScreen",
    TitleState => "TitleMenu",
    FreeplayState => "FreeplayMenu",
    CreditsMain => "CreditsMenu"
];
public static var startedFreeplayMusic:Bool = false;
public static var startedMenuMusic:Bool = false;
public static var isVoidWeek:Bool = false;
var sprite_:FlxSprite;
var sprite_2:FlxSprite;

public static var WeekData:Array<{songs:Array<String>, image_key:String, difficulties:String, weekName:String, isXml:Bool, numSongs:Int,composers:Array<String>}> = [];
public static var WeekDataOld:Array<{songs:Array<String>, image_key:String, difficulties:String, weekName:String}> = [];

function new() {
    Handle.init([]);
    // confing Stuff
	modInfo = daShitJson('data');
	windowTitle = Std.string(modInfo.title);
    // settings Mechanics
    if (FlxG.save.data.joyMechanic == null) FlxG.save.data.joyMechanic = true;
    if (FlxG.save.data.clownMechanic == null) FlxG.save.data.clownMechanic = true;
    // settings Gameplay
    if (FlxG.save.data.FireShader == null) FlxG.save.data.FireShader = true;
    if (FlxG.save.data.FrameRateFireShader == null) FlxG.save.data.FrameRateFireShader = 0;
    if (FlxG.save.data.BlurShade == null) FlxG.save.data.BlurShade = true;
    if (FlxG.save.data.GriviengShader == null) FlxG.save.data.GriviengShader = true;
    if (FlxG.save.data.Shadows == null) FlxG.save.data.Shadows = true;

    MusicBeatTransition.script = "data/scripts/transition";

}
 
function update(elapsed:Float){
    if (FlxG.mouse.pressed && FlxG.mouse.visible) {
        FlxG.mouse.load(sprite_2.pixels, 0.9, 1, -11);
    }

    if (FlxG.mouse.justReleased && FlxG.mouse.visible) {
        FlxG.mouse.load(sprite_.pixels, 0.9, 1, -11);
    }
    if (FlxG.keys.justPressed.F5) FlxG.resetState();
    if(FlxG.keys.justPressed.F11) FlxG.fullscreen = !FlxG.fullscreen;
}
   

function preStateSwitch() {
    Framerate.codenameBuildField.text = '';
    
    WindowUtils.resetTitle();
   
  
    sprite_ = new FlxSprite().loadGraphic(Paths.image('mouse/default'));
    sprite_2 = new FlxSprite().loadGraphic(Paths.image('mouse/onHold'));
   
    FlxG.mouse.useSystemCursor = false;
    FlxG.mouse.load(sprite_.pixels, 0.9, 1, -11);
    
    FlxG.camera.bgColor = FlxColor.BLACK;

    // json shits
    WeekDataOld = daShitJson('info/weeksVoid').weeks;
    WeekData = daShitJson('info/weeks').weeks;

    FlxG.bitmap.add(Paths.video('stars'));
  
	if (Std.isOfType(FlxG.game._requestedState, Type.getClass(FlxG.state))) return;

    @:privateAccess
	if (_nextResolution != null && (FlxG.initialWidth != _nextResolution.width || FlxG.initialHeight != _nextResolution.height)) {
		Main.scaleMode.updateGameSize(FlxG.initialWidth = _nextResolution.width, FlxG.initialHeight = _nextResolution.height);
		_nextResolution = {width: 1280, height: 720};
	}
   
    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

var _nextResolution = {width: 1280, height: 720}; //1280, 720

public static function resizeGame(width:Int, height:Int) {
	_nextResolution = {width: width, height: height}
}

public static function daShitJson(data) {
    var daJson = Assets.getBytes(Paths.json(data));
    return JsonParser.parse(daJson);
}


public static function getSongs() {
    var songArray:Array<String> = [];
    if (isVoidWeek){
       
        for (i in 0...WeekDataOld.length) {
            for (j in 0...WeekDataOld[i].songs.length) {       
                songArray.push(WeekDataOld[i].songs[j]);
            }
        }
    }else{
        for (i in 0...WeekData.length) {
            for (j in 0...WeekData[i].songs.length) {       
                songArray.push(WeekData[i].songs[j]);
            }
        }
    }
    
    return songArray;
}

public static function getWeeks(weekNum:Int = 0){
    var daWeek:Array<String> = [];
    if (isVoidWeek){
       
        for (i in 0...WeekDataOld.length){
            daWeek.push(WeekDataOld[i]);
        }
    }else{
        
        for (i in 0...WeekData.length){
            daWeek.push(WeekData[i]);
        }
    }
   
    return daWeek[weekNum];
}
public static function getSongsFromTheWeeks(weekNum:Int = 0)
{
    var songArray:Array<String> = [];
    if (isVoidWeek){
        for (song in 0...WeekDataOld[weekNum].songs.length){
            songArray.push(WeekDataOld[weekNum].songs[song]);
        }
    }
    else
    {
        for (song in 0...WeekData[weekNum].songs.length){
            songArray.push(WeekData[weekNum].songs[song]);
        }
    }
        
    return songArray;
    

}

public static function getCredits() {
    var composers:Map<String, String> = [];
    if (isVoidWeek){
       

        for (i in 0...WeekDataOld.length) 
            for(j in 0...WeekDataOld[i].songs.length)
                composers.set(WeekDataOld[i].songs[j].toLowerCase(), WeekDataOld[i].composers[j]);
    
    }else{
      
        for (i in 0...WeekData.length) 
            for(j in 0...WeekData[i].songs.length)
                composers.set(WeekData[i].songs[j].toLowerCase(), WeekData[i].composers[j]);
    
    }
   
    return composers;
}

public static function changePrefix(suffix:String){
    window_suffix = suffix;
    WindowUtils.resetTitle();
    window.title = windowTitle + " - " + window_suffix;
}
public static function getWindowSuffix(){
    var daName:String = window_suffix;
    return daName;
}