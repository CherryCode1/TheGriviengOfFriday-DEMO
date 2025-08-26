import Type;
import haxe.Timer;

import openfl.display.FPS;
import openfl.text.TextField;
import openfl.text.TextFormat;

import funkin.backend.utils.MemoryUtil;
import funkin.backend.utils.WindowUtils;

import funkin.backend.system.Main;
import funkin.backend.system.framerate.Framerate;

var fakeFPS:FPS;
var realFPS:FPS;

var memoryPeak:Float = 0;
var lastDebugMode:Int = 0;

var coolDebugMode:Int = 0;
var fpsUpdateTimer:Float = 999999;

function postCreate() {
    fakeFPS = new FPS(-999999, -999999, 0xFFFFFFFF);
    fakeFPS.visible = false;
    //Main.instance.addChild(fakeFPS);

    realFPS = new TextField();
    realFPS.x = 10;
    realFPS.y = 3;
    realFPS.text = "FPS: 0 ° MEM: 0mb / 0mb";
    realFPS.autoSize = 1; // 1 = left

    var format:TextFormat = new TextFormat("_sans", 12, 0xFFFFFFFF);
    format.leading = -4;

    realFPS.defaultTextFormat = format;
    realFPS.addEventListener("enterFrame", onEnterFrame);
   // Main.instance.addChild(realFPS);
    
    lastDebugMode = Framerate.debugMode;
    coolDebugMode = lastDebugMode;

    Framerate.instance.visible = false;
}

function onEnterFrame(e) {
    var lastTime:Float = Timer.stamp();
    fpsUpdateTimer += FlxG.elapsed * 1000;

    var memory:Float = MemoryUtil.currentMemUsage();
    if(memory > memoryPeak)
        memoryPeak = memory;

    if(FlxG.keys.justPressed.F3) {
        lastDebugMode = (Framerate.debugMode + 1) % 3;
        fpsUpdateTimer = 999999;
    }
    if(fpsUpdateTimer > Conductor.stepCrochet) {
        var text:String = "FPS: " + fakeFPS.currentFPS;
        if(Framerate.debugMode > 0)
            text += " ° MEM: " + CoolUtil.getSizeString(memory).toLowerCase() + " / " + CoolUtil.getSizeString(memoryPeak).toLowerCase();
    
        if(Framerate.debugMode > 1) {
            var objCount:Int = 0;
            var state:FlxState = FlxG.state;
            while(state != null) {
                state.forEach((o) -> {
                    objCount++;
                }, true);
                state = state.subState;
            }
            var bitmapCount:Int = 0;
            for(_ in FlxG.bitmap._cache.keys())
                bitmapCount++;
    
            text += "\n---------------------------------------------\nConductor Info:";
            text += "\n- " + Conductor.curBeat + " beat" + (Conductor.curBeat != 1 ? "s" : "");
            text += "\n- " + Conductor.curStep + " step" + (Conductor.curStep != 1 ? "s" : "");
            text += "\n- " + Conductor.curMeasure + " measure" + (Conductor.curMeasure != 1 ? "s" : "");
            text += "\nCurrent BPM: " + Conductor.bpm;
            text += "\nTime Signature: " + Conductor.beatsPerMeasure + "/" + Conductor.stepsPerBeat;
            text += "\n---------------------------------------------\nFlixel Info:";
            text += "\nCurrent State: " + Type.getClassName(Type.getClass(FlxG.state));
            text += "\nTotal Objects: " + objCount;
            text += "\nCached Bitmaps: " + bitmapCount;
            text += "\nCached Sounds: " + FlxG.sound.list.length;
            text += "\nFlxGame Child Count: " + FlxG.game.numChildren;
        }
        realFPS.text = text;
        fpsUpdateTimer = 0;
    }
}

function destroy() {
    Main.instance.removeChild(fakeFPS);

    realFPS.removeEventListener("enterFrame", onEnterFrame);
    Main.instance.removeChild(realFPS);

    Framerate.debugMode = lastDebugMode;
    Framerate.instance.visible = true;
}