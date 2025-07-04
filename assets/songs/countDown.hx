import haxe.format.JsonParser;

public var countDown:String = "default";
public var countDownFNF:Bool = false;
public var skipCounDown:Bool = false;
public var soundsVanilla:Bool = false;
var spriteCountDown:FlxSprite;
var jsonCD;
function create() {
    if (PlayState.SONG.meta.name == "Affiliation" || PlayState.SONG.meta.name== "affiliation") countDownFNF = true;
}

function postCreate() {
    if (countDownFNF || skipCounDown) return;

    if (daShitJson("countdowns/" + countDown) != null) jsonCD = daShitJson("countdowns/" + countDown);
    else  jsonCD = daShitJson("countdowns/countDown");

    spriteCountDown = new FlxSprite(jsonCD.position[0],jsonCD.position[1]);
    spriteCountDown.frames = Paths.getSparrowAtlas(jsonCD.image);
    spriteCountDown.scale.set(jsonCD.scale,jsonCD.scale);
    spriteCountDown.camera = camHUD;
    for (uh in 0...jsonCD.animations.length) {
        var animName:String = jsonCD.animations[uh].name;
        spriteCountDown.animation.addByPrefix(animName,animName,24,false);
    }
    if (countDown == "joy" && downscroll) spriteCountDown.y = -200;
      
    add(spriteCountDown);
    spriteCountDown.visible = false;
}

function onCountdown(e)
{
    if (countDownFNF) return;
    if (skipCounDown){
        startTimer.finished = true;
        e.cancel();
    } 
    var swagCounter = e.swagCounter - introLength + 5;
    if (!soundsVanilla){

        var suffix:String = "-gum";
        var prefix:String = "";
        switch(swagCounter){
            case 0: prefix = "intro3";
            case 1: prefix = "intro2";
            case 2: prefix = "intro1";
            case 3: prefix = "introGo";

        }
        e.soundPath = "gumball/" + prefix + suffix;
        if (e.soundPath == "gumball/-gum") e.soundPath = "";
        // trace("gumball/" + prefix + suffix);
        e.volume = 1;
    }
  
    e.spritePath = null;
    
    if (swagCounter == 4) 
        FlxTween.tween(spriteCountDown,{ alpha: 0 }, 0.4, { ease:FlxEase.sineInOut, onComplete: function uh(){
            remove(spriteCountDown);
        }});       
    else if (swagCounter >= 0)
    {
        spriteCountDown.visible = true;
        var animName:String = jsonCD.animations[swagCounter]?.name;
        var pos:Array<Float> = jsonCD.animations[swagCounter]?.offsets;
        spriteCountDown.offset.set(pos[0],pos[1]);
        spriteCountDown.animation.play(animName);
    }
}

function onStartCountdown(e)
{
    introLength = PlayState.SONG.meta.displayName == "Clown Eyes" || PlayState.SONG.meta.displayName == "clown eyes" ? 7 : 5; // it doesn't work on createPost() (no funciona en createPost())

    if (skipCounDown) {
        e.cancel();
        startedCountdown = true;
        Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * introLength - Conductor.songOffset;
        new FlxTimer().start(0.2, daStart -> {PlayState.instance.startSong();});     
    } 
}