var gameOverCamera:FlxCamera = new FlxCamera();
var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

var secret:Bool = FlxG.random.bool(10);

function create(event){
    event.cancel();
    
    gameOverCamera.bgColor = 0xFF000000;
    FlxG.cameras.add(gameOverCamera, false);

    var stat:FlxSprite = new FlxSprite();
    stat.frames = Paths.getSparrowAtlas('daSTAT');
    stat.animation.addByPrefix('static', 'staticFLASH', 24, true);
    stat.setGraphicSize(FlxG.width, FlxG.height);
    stat.updateHitbox();
    stat.screenCenter();
    stat.cameras = [gameOverCamera];
    add(stat);

    stat.alpha = 0.1;
    stat.animation.play('static');

    var payaso:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stages/clown/' + (secret ? 'when' : 'mueres')));
    payaso.cameras = [gameOverCamera];
    payaso.screenCenter();
    add(payaso);

    black.cameras = [gameOverCamera];
    add(black);
    
    FlxTween.tween(black, { alpha: 0 }, 4);

    FlxG.sound.play(Paths.sound('GameOverClown'));
}

function update() {
    if (controls.ACCEPT && !secret) {
        if(FlxG.sound.music != null) FlxG.sound.music.fadeOut(4);
        FlxTween.tween(black, { alpha: 1 }, 4, { onComplete: () -> { FlxG.resetState(); }});
    }
    else if (controls.BACK) {
        FlxG.switchState(new ModState('FreeplayMenu'));
    }

    if(secret && FlxG.keys.justPressed.R)
    {
        if(FlxG.sound.music != null) FlxG.sound.music.fadeOut(4);
        FlxTween.tween(black, { alpha: 1 }, 4, { onComplete: () -> { FlxG.resetState(); }});
    }
}