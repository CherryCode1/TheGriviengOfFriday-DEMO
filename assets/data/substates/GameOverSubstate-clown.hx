var gameOverCamera:FlxCamera = new FlxCamera();
var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

function create(event){
    event.cancel();
    FlxG.sound.playMusic(Paths.music('gameOver'));
    if(FlxG.sound.music != null) {
        FlxG.sound.music.volume = 0;
        FlxG.sound.music.fadeIn(4);
    }
    
    gameOverCamera.bgColor = FlxColor.fromString('0xF6E4AF');
    FlxG.cameras.add(gameOverCamera, false);

    var payaso:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stages/clown/mueres'));
    payaso.cameras = [gameOverCamera];
    payaso.screenCenter();
    add(payaso);

    black.cameras = [gameOverCamera];
    add(black);
    
    FlxTween.tween(black, { alpha: 0 }, 4);
}

function update() {
    if (controls.ACCEPT) {
        if(FlxG.sound.music != null) FlxG.sound.music.fadeOut(4);
        FlxTween.tween(black, { alpha: 1 }, 4, { onComplete: () -> { FlxG.resetState(); }});
    }
    else if (controls.BACK) {
        FlxG.switchState(new ModState('FreeplayMenu'));
    }
}