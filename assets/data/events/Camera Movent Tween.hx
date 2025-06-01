// use algunas cosas del event de peppy - alan

/*
 //TOOLS EVENT//
 Strum line - character
 time -steps
 ease -FlxEase
*/

var tween:FlxTween;
var camMoveShit:Bool = false;

function onEvent(e) {
    if (e.event.name != "Camera Movent Tween")
        return;

    var params:Array = e.event.params;
    var strum =  strumLines.members[params[0]].characters[0];
    var steps = params[1];
    var ease:FlxEase = Reflect.field(FlxEase, params[2] + (params[2] == "linear" ? "" : params[3]));
    var snap = params[4];

    curCameraTarget = params[0];


    var strumCameraPos = strum.getCameraPosition();
    var posCamera = FlxPoint.get(strumCameraPos.x,strumCameraPos.y);
    
   
    if(!snap){
        camMoveShit = true;
        camFollowChars = false;
           

        tween = FlxTween.tween(camFollow, {x: posCamera.x, y: posCamera.y}, (Conductor.stepCrochet * steps / 1000), {ease: ease, 
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
    {
        camFollowChars = false;
        camFollow.setPosition(Std.parseFloat(posCamera.x), Std.parseFloat(posCamera.y));
        FlxG.camera.snapToTarget();
    } 
}
function onCameraMove(e)
    if(tween != null && camMoveShit)
        e.cancel();