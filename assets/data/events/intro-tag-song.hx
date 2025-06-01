//todos tontos menos yo - alan
import flixel.tweens.FlxEase;

var initialTime:Float = 0;
var deleteTime:Float = 0;
function onEvent(event) {
  if (event.event.name != "intro-tag-song") return;

 
    var shit:FlxSprite = new FlxSprite().loadGraphic(Paths.image('songsIntro/' + event.event.params[0]));
    shit.scale.set(0.5,0.5);
    shit.screenCenter();
    shit.camera = camHUD;
    shit.scrollFactor.set();
    shit.alpha = 0;
    add(shit);
  
  

  
  initialTime = event.event.params[1];
  deleteTime = event.event.params[2];
  FlxTween.tween(shit,{alpha:1,"scale.x":1,"scale.y":1} ,initialTime, {ease:FlxEase.cubeInOut,onComplete: function deleteShit(tween:FlxTween) {
      new FlxTimer().start(0.25, (_) -> {
        FlxTween.tween(shit,{alpha: 0,"scale.x": 0.8,"scale.y": 0.8},deleteTime,{ease:FlxEase.cubeInOut,onComplete: function uh(_){
          shit.destroy();
          remove(shit,true);
        }});
      });
    }
  });


}