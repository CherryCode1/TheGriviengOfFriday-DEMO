// This script only works in debug mode of a build, if you want, you could remove the 
// conditional compilation but try to remove these files in the final build. -EstoyAburridow

import funkin.editors.charter.Charter;
import funkin.game.PlayState;

public var enabled:Bool = true;

public var curSpeed:Float = 1;
static var curBotplay:Bool = false;
static var devControlBotplay:Bool = true;
var curZoom:Float;
function postCreate() curZoom = defaultCamZoom;

function postUpdate() {

    if(!enabled) return;
    
    if (FlxG.keys.justPressed.ONE && generatedMusic) endSong();
    if (FlxG.keys.justPressed.TWO) curSpeed -= 0.1;
    if (FlxG.keys.justPressed.THREE) curSpeed = 1;
    if (FlxG.keys.justPressed.FOUR) curSpeed += 0.1;
    if (FlxG.keys.justPressed.Q) curZoom -= 0.1;
    if (FlxG.keys.justPressed.E) curZoom += 0.1;

    //defaultCamZoom = curZoom;
    //trace(curZoom);
    curZoom = FlxMath.bound(curZoom,0.01,4);
    curSpeed = FlxMath.bound(curSpeed, 0.1, 2);
    
    if (FlxG.keys.justPressed.SIX) curBotplay = !curBotplay;
    if (devControlBotplay){
        for(strumLine in strumLines) {
            if(!strumLine.opponentSide){
                strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
            }
        }
    } 
    updateSpeed(FlxG.keys.pressed.FIVE ? 20 : curSpeed);

    if (scripts.contains("assets/data/scripts/VideoHandler.hx") && VideoHandler.curVideo != null) VideoHandler.curVideo.bitmap.rate = FlxG.timeScale;

    if (FlxG.keys.justPressed.SEVEN)
        FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, true));
}

function onNoteHit(event) {
    if (!curBotplay || event.character != boyfriend || !enabled) return;
    
    event.player = true;
    event.countAsCombo = true;
    event.showSplash = !event.note.isSustainNote;
    event.healthGain = 0.023;
    event.rating = "sick";
    event.countScore = true;
    event.score = 300;
    event.accuracy = 1;
}

function updateSpeed(speed:Float){
    if(!enabled) return;

    FlxG.timeScale = inst.pitch = vocals.pitch = speed;
}
function onGamePause() {
    if(!enabled) return;

    updateSpeed(1);
}
function onSongEnd() {
    if(!enabled) return;

    updateSpeed(1);
}
function destroy() {
    FlxG.timeScale = 1;
    FlxG.sound.muted = false;
}