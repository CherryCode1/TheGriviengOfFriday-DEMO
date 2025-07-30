import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.Transition;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;


function create(e) {
    e.cancelled = true;

    if(!nextFrameSkip) {
        var out = e.transOut;

        var circleTiles:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileCircle);
        circleTiles.persist = true;
        circleTiles.destroyOnNoUse = false;

        var data = new TransitionData(
            "tiles",                 
            FlxColor.BLACK,        
            0.5,                     
            FlxPoint.get(-1, -1),     
            { asset: circleTiles, width: 32, height: 32}, 
            FlxRect.get(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4) 
        );

        var _trans = new Transition(data);
        if(_trans._effect != null)
            _trans._effect.cameras = [transitionCamera];

        _trans.setStatus(out ? 2 : 3);
        openSubState(_trans);
        _trans.finishCallback = done;
        _trans.start(out ? 0 : 1);

        transitionCamera.scroll.y = 0;
    }
    else {
        done();
    }
}

function done()
{
	if (newState != null)
		FlxG.switchState(newState);

	new FlxTimer().start(0.7, ()-> {close();});
}