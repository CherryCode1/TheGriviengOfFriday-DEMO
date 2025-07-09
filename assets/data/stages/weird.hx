import lime.app.Application;
import funkin.backend.utils.NdllUtil;
import funkin.backend.system.framerate.Framerate;
import flixel.util.FlxTimer;

var setTransparency = NdllUtil.getFunction("ndllexample", "ndllexample_set_windows_transparent", 4);

var weird:FlxSprite;

var sat:CustomShader = new CustomShader("weird/saturate");
var vcr:CustomShader = new CustomShader("weird/vcr");

public var saturation:Float = 1.2;
public var mid:Float = .2;
public var grain:Float = 0.05;

public var scary:Bool = false;

var shouldResize:Bool = false;
var shouldFullscreen:Bool = false;

function create()
{
    // Seeing if the application from lime is fullscreened makes more sure that the window gets resized on fullscreen
    if(Application.current.window.fullscreen || FlxG.fullscreen || FlxG.stage.window.maximized)
    {
        shouldResize = FlxG.stage.window.maximized;
        shouldFullscreen = Application.current.window.fullscreen || FlxG.fullscreen;
        FlxG.stage.window.maximized = Application.current.window.fullscreen = FlxG.fullscreen = false;
    }

    FlxG.mouse.visible = false;
    Framerate.codenameBuildField.text = '';
	Framerate.fpsCounter.fpsNum.alpha = 0;
	Framerate.memoryCounter.memoryText.alpha = 0;
	Framerate.memoryCounter.memoryPeakText.alpha = 0;
	Framerate.fpsCounter.fpsLabel.alpha = 0;

    camGame.bgColor = 0xFF140000;

    setTransparency(true, 20, 0, 0);
    FlxG.stage.window.borderless = true;

    weird = new FlxSprite(-400, -300).loadGraphic(Paths.image("stages/weird/Living room"));
    weird.scale.set(1.2, 1.2);
    weird.updateHitbox();
    insert(0, weird);

    dad.x -= 200;
    dad.y += 30;
    dad.cameraOffset.set(150, 0);

    for(sh in [sat, vcr])
        for(i in [camGame, camHUD])
            i.addShader(sh);

    vcr.zoom = 1.02;

    sat.contrast = saturation;
    sat.midpoint = mid;
    sat.grain_amount = grain;
}

function postUpdate() iconP1.flipX = true;

function beatHit()
{
    if(scary)
    {
        executeEvent({name: "Add Camera Zoom", time: 0, params: [0.15, "camGame"]});
        executeEvent({name: "Add Camera Zoom", time: 0, params: [0.10, "camHUD"]});

        saturation = 12.;
        mid = .6;
        grain = .2;

        camGame.shake(0.1, 0.01);
    }
}

function onDadHit(e)
{
    if(health > 0.1)
    {
        if(!e.note.isSustainNote && scary)
            e.healthGain = 0.06;
        else
            e.healthGain = 0.02;
    }
}

function update(elapsed)
{
    var lerpVal:Float = FlxMath.bound(elapsed * 4, 0, 1);

    sat.iTime = elapsed;

    if(curStep > 364)
    {
        saturation = FlxMath.lerp(saturation, 3.2, lerpVal);
        mid = FlxMath.lerp(mid, .4, lerpVal);
        grain = FlxMath.lerp(grain, .15, lerpVal);
    
        sat.contrast = saturation;
        sat.midpoint = mid;
        sat.grain_amount = grain;
    }
}

function destroy()
{
    for(sh in [sat, vcr])
        for(i in [camGame, camHUD])
            i.removeShader(sh);

    FlxG.stage.window.borderless = false;
    setTransparency(false, 255, 5, 55);

    Framerate.fpsCounter.fpsNum.alpha = 0.5;
	Framerate.memoryCounter.memoryText.alpha = 0.5;
	Framerate.memoryCounter.memoryPeakText.alpha = 0.5;
	Framerate.fpsCounter.fpsLabel.alpha = 0.5;

    FlxG.stage.window.maximized = shouldResize;
    Application.current.window.fullscreen = FlxG.fullscreen = shouldFullscreen;
}