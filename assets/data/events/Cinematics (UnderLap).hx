//Created by RamenDominoes (Please credit if using this, thanks! <3)
// Ported by EstoyAburridow

var index:Int = 1;

public var upperBar:FlxSprite;
public var lowerBar:FlxSprite;

public var initialYUpperBar:Float;
public var initialYLowerBar:Float;

public var shouldMoveStrum:Bool = true;

function postCreate() {
    upperBar = new FlxSprite(-110, -350);
    upperBar.makeGraphic(1500, 350, 0xFF000000);
    upperBar.camera = camHUD;
    insert(0, upperBar);

    lowerBar = new FlxSprite(-110, 720);
    lowerBar.makeGraphic(1500, 350, 0xFF000000);
    lowerBar.camera = camHUD;
    insert(0, lowerBar);

    initialYUpperBar = upperBar.y;
    initialYLowerBar = lowerBar.y;
    
}
public var initialYStrum:Float;
function onPostGenerateStrums(event) {
    initialYStrum = strumLines.members[0].members[0].y;
}

public var speed:Float;
public var distance:Float;

function onEvent(event) {
    if (event.event.name == "Cinematics (UnderLap)") {
        speed = event.event.params[0];
        distance = event.event.params[1];

        //ENTRANCES

        if (speed > 0 && distance > 0) {
            FlxTween.tween(upperBar, {y: initialYUpperBar + distance}, speed, {ease: FlxEase.quadInOut});
            FlxTween.tween(lowerBar, {y: initialYLowerBar - distance}, speed, {ease: FlxEase.quadInOut});

            if(shouldMoveStrum)
                for (strumLine in strumLines)
                    for (strum in strumLine)
                        FlxTween.tween(strum, {y: initialYStrum + distance - 35}, speed, {ease: FlxEase.quadInOut});
                
            for (sprite in hudAssets){
                FlxTween.tween(sprite, {alpha: 0}, speed - 0.1);
            }
         
        }

        if (distance <= 0) {
            FlxTween.tween(upperBar, {y: initialYUpperBar}, speed, {ease: FlxEase.sineInOut});
            FlxTween.tween(lowerBar, {y: initialYLowerBar}, speed, {ease: FlxEase.sineInOut});

            if(shouldMoveStrum)
                for (strumLine in strumLines)
                    for (strum in strumLine)
                        FlxTween.tween(strum, {y: initialYStrum}, speed, {ease: FlxEase.sineInOut});
                
            for (sprite in hudAssets)
                FlxTween.tween(sprite, {alpha: 1}, speed + 0.1);
            
        }
    }
}