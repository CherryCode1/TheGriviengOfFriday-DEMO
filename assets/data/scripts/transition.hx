import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.Transition;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;
import funkin.options.OptionsMenu;

var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("LOADING_SCREEN"));
var bar:FlxSprite = new FlxSprite(0,700).makeGraphic(800,10,FlxColor.fromRGB(196, 18, 140));

function create(e) {
    e.cancel();

    bg.scale.set(0.5,0.5);
    bg.screenCenter();
    add(bg);

    bar.screenCenter(FlxAxes.X); 
    add(bar);

    if (e.transOut) {
        finish();
        return;
    }

    FlxTween.tween(bg,{alpha:0},1,{startDelay: 0.2});
    bar.scale.x = 1;
    FlxTween.tween(bar,{"scale.x":0,"alpha":0},1,{ease:FlxEase.cubeOut, onComplete: () ->{
        new FlxTimer().start(.4, ()-> {
            if (newState != null)
                FlxG.switchState(newState);

            finish();
        });
    }});
}