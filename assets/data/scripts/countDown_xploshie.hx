import haxe.format.JsonParser;

var sprite:FlxSprite;
function postCreate() {
   sprite = new FlxSprite();
   sprite.frames = Paths.getSparrowAtlas("xploshiUI/Jam");
   sprite.animation.addByPrefix("uh","jam start",24,false);
   sprite.screenCenter();
   sprite.x += 200;
   sprite.camera = camHUD;
   add(sprite);
}

function onCountdown(e)
{
    e.spritePath = null;
    var swagCounter = e.swagCounter;
    
    if (swagCounter == 0) {
        sprite.animation.play("uh");
        e.soundPath = "jammers";

        new FlxTimer().start(2, (tmr:FlxTimer) -> {
            remove(sprite);   
            return;        
        });

       
    }else{
        e.soundPath  =null;
    }
}