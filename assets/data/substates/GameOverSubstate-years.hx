import flixel.FlxObject;
import funkin.editors.charter.Charter;
import funkin.menus.StoryMenuState;
import funkin.menus.FreeplayState;
import funkin.backend.MusicBeatState;
import flixel.FlxBasic;
import funkin.backend.utils.NativeAPI;
import Sys;

public var lossSFX:FlxSound;
var stabSFX:FlxSound;

var killSpr:FlxSprite;
var gameoverCam:FlxCamera;

var game = PlayState.instance;
var character:Character;

var isEnding = false;

function create(event) {
    event.cancel(); // cancels out initializing characters and stuff

    x = event.x;
    y = event.y;
    characterName = event.character;
    player = event.player;
    gameOverSong = event.gameOverSong;
    gameOverSongBPM = event.bpm;
    lossSFXName = event.lossSFX;
    retrySFX = event.retrySFX;

    FlxTween.cancelTweensOf(FlxG.camera);

    FlxG.camera.zoom = 0.6;
    FlxG.camera.alpha = 1;

    killSpr = new FlxSprite(0, 100);
    killSpr.frames = Paths.getSparrowAtlas('stages/17bucks/killer');
    killSpr.animation.addByPrefix('kill', 'MUERTE', 24, false);
    killSpr.scrollFactor.set();
    killSpr.scale.set(2.4, 2);
	killSpr.centerOffsets();
    add(killSpr);

    killSpr.animation.play('kill');

    character = new Character(x, y - 20, 'gameover-17', player);
    character.danceOnBeat = false;
    character.playAnim('firstDeath');
    add(character);

    var camPos = character.getCameraPosition();
    camFollow = new FlxObject(camPos.x + 70, camPos.y + 50, 1, 1);
    add(camFollow);
    FlxG.camera.target = camFollow;
    FlxG.camera.snapToTarget();

    lossSFX = FlxG.sound.play(Paths.sound('17sounds/amongKill'));
    Conductor.changeBPM(100);

    new FlxTimer().start(0.3, () -> {
        stabSFX = FlxG.sound.play(Paths.sound('17sounds/killSounds'));
    });
}

function update(elapsed:Float)
{
    if (controls.ACCEPT && !isEnding)
    {
        endBullshit();
    }

    if (controls.BACK)
    {
        if (PlayState.chartingMode && Charter.undos.unsaved)
            PlayState.instance.saveWarn(false);
        else {
            PlayState.resetSongInfos();
            if (Charter.instance != null) Charter.instance.__clearStatics();

            if (FlxG.sound.music != null)
                FlxG.sound.music.stop();
            FlxG.sound.music = null;

            if (PlayState.isStoryMode)
                FlxG.switchState(new StoryMenuState());
            else
                FlxG.switchState(new FreeplayState());
        }

    }

    if (!isEnding && ((!lossSFX.playing) || (character.getAnimName() == "firstDeath" && character.isAnimFinished())) && (FlxG.sound.music == null || !FlxG.sound.music.playing))
    {
        CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true, 100);
        camFollow.x += 70;
    }

    if (killSpr.animation.curAnim.name == 'kill' && killSpr.animation.curAnim.finished && killSpr != null)
		remove(killSpr);
}

var beatCount = 0;
var curTempo = 4;
var done = false;

function beatHit(curBeat:Int)
{
    if (FlxG.sound.music != null && FlxG.sound.music.playing){
        character.playAnim("deathLoop", true);
    }
}

function endBullshit():Void
{
    isEnding = true;

    character.playAnim('deathConfirm', true);
    var sound = FlxG.sound.play(Paths.sound(retrySFX));
    
    lossSFX.stop();
    stabSFX.stop();

    remove(killSpr);
    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

    FlxG.sound.music = null;

    var secsLength:Float = sound.length / 1000;
    var waitTime = 0.7;
    var fadeOutTime = secsLength - 0.7;

    if (fadeOutTime < 0.5)
    {
        fadeOutTime = secsLength;
        waitTime = 0;
    }

    new FlxTimer().start(waitTime, function(tmr:FlxTimer)
    {
        FlxG.camera.fade(FlxColor.BLACK, fadeOutTime, false, function()
        {
            MusicBeatState.skipTransOut = true;
            FlxG.switchState(new PlayState());
        });
    });
}