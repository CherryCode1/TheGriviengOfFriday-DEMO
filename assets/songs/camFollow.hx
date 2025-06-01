import funkin.backend.utils.WindowUtils;
import flixel.math.FlxBasePoint;
import openfl.Lib;

public var camMoveOffset:Float = 20;
public var camFollowChars:Bool = true;
public var cammove = 10; 
public var angleMoveSpeed = 0.025; 
public var angleVar = 2; 

var movement = new FlxBasePoint();
function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        camMoveEvent.cancelled = false;
       
        for(char in strumLines.members[curCameraTarget].characters)
            switch (char.getAnimName()) {
                    case "singLEFT": movement.set(-camMoveOffset, 0);
                    FlxG.camera.angle = (lerp(FlxG.camera.angle, -angleVar, angleMoveSpeed));
                    case "singDOWN": movement.set(0, camMoveOffset);
                    FlxG.camera.angle = (lerp(FlxG.camera.angle, 0, angleMoveSpeed));
                    case "singUP": movement.set(0, -camMoveOffset);
                    FlxG.camera.angle = (lerp(FlxG.camera.angle, 0, angleMoveSpeed));
                    case "singRIGHT": movement.set(camMoveOffset, 0);
                    FlxG.camera.angle = (lerp(FlxG.camera.angle, angleVar, angleMoveSpeed));
                    default: movement.set(0,0);
                    FlxG.camera.angle = (lerp(FlxG.camera.angle, 0, 0.01));
            };
		 
		camMoveEvent.position.x += movement.x;
		camMoveEvent.position.y += movement.y;
        
    } else   camMoveEvent.cancelled = true;
}