function create(){
    FlxG.camera.bgColor = FlxColor.fromString('0xF6E4AF');
    var easterEgg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stages/clown/when'));
    easterEgg.screenCenter();
    easterEgg.scale.set(1.2, 1.2);
    add(easterEgg);

    var message:FunkinText = new FunkinText(0, 0, 0, "Press Enter to continue", 32);
    message.font = Paths.font('Gumball.ttf');
    message.alignment = 'right';
    message.x = FlxG.width - message.width - 10;
    message.y = FlxG.height - message.height;
    message.alpha = 0;
    add(message);

    new FlxTimer().start(3, (_) -> { FlxTween.tween(message, { alpha: 1 }, 0.75 ); });
}

function update() {
    if (controls.ACCEPT)
        FlxG.switchState(new PlayState());
}