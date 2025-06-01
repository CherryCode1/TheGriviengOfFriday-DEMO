//yo ise esto jejejej -peppy
var tween:FlxTween;
var camMoveShit:Bool = false;
function onEvent(e) {
    if (e.event.name != "Tween Camera")
        return;

    var params:Array = e.event.params;

    var type = params[0];
    var args:Array<Dynamic> = params[1].split(',');
    var steps = params[2];
    var ease:FlxEase = Reflect.field(FlxEase, params[3] + (params[3] == "linear" ? "" : params[4]));
    var snap = params[5];

    if(!snap)
        switch(type)
        {
            case 'Angle':
                if(args.length > 1){ trace("Angle tween takes ONE parameter"); return; }

                tween = FlxTween.tween(camGame, {angle: args[0]}, (Conductor.stepCrochet * steps / 1000), {ease: ease, onComplete: (_) -> { tween = null; }});
            case 'Zoom':
                if(args.length > 2){ trace("Zoom tween takes TWO parameters"); return; }
        
            
                tween = FlxTween.tween(camGame, {zoom: args[0]}, (Conductor.stepCrochet * steps / 1000), {ease: ease,
                    onUpdate:
                    (_) -> {if(args[1] == "true") defaultCamZoom = Std.parseFloat(args[0]);},
                    onComplete:
                    (_) -> {
                        tween = null;
                    }
                });
            
            default:
                camMoveShit = true;
                camFollowChars = false;
                if(args.length != 2){ trace("Position tween needs TWO parameters"); return; }
                trace(args);
                tween = FlxTween.tween(camFollow, {x: args[0], y: args[1]}, (Conductor.stepCrochet * steps / 1000), {ease: ease, 
                onUpdate:
                (_) -> {
                    FlxG.camera.snapToTarget();
                },
                onComplete: 
                (_) -> {
                    tween = null;
                    camFollowChars = true;
                    camMoveShit = false;
                }});
        }
    else
        switch(type)
        {
            case 'Angle':
                if(args.length > 1){ trace("Angle tween takes ONE parameter"); return; }

                camGame.angle = Std.parseFloat(args[0]);
            case 'Zoom':
                if(args.length > 2){ trace("Zoom tween takes TWO parameters"); return; }

                camGame.zoom = defaultCamZoom = Std.parseFloat(args[0]);
            default:
                if(args.length != 2){ trace("Position tween needs TWO parameters"); return; }
                camFollowChars = false;
                camFollow.setPosition(Std.parseFloat(args[0]), Std.parseFloat(args[1]));
                FlxG.camera.snapToTarget();
        }
}

function onCameraMove(e)
    if(tween != null && camMoveShit)
        e.cancel();