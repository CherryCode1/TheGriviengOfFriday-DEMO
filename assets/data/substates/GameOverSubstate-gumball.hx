var time_:Float = 0.0;

function create(){
    FlxG.camera.zoom = 0.7;
    var sprite = new FlxSprite().makeGraphic(cameras[0].width + 400,cameras[0].height + 400,FlxColor.BLACK);
    sprite.screenCenter();
    sprite.alpha = 0;
    sprite.scrollFactor.set(0,0);
    add(sprite);

    FlxTween.tween(sprite, {alpha: 1}, 1.1, {startDelay: 0.3});
    FlxTween.tween(FlxG.camera,{zoom:0.9},1.5,{startDelay:0.3,ease:FlxEase.backInOut});

}
function update(elapsed:Float) {
    time_ += elapsed;
    grieveSh.iTime = time_;
}