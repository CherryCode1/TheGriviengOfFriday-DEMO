var stickers:Array<FlxSprite> = [];
var target:Int = -1;

function postCreate() {
	for (i in 0...100) {
		var heightSprite = 274;
		var widthSprite = 550;
		var framesW = 3;
		var framesH = 2;
		var maxFrames = 6;

		var sticker:FlxSprite = new FlxSprite();
		sticker.loadGraphic(Paths.image("stages/copycat/stickers/bf_"), true, widthSprite / framesW, heightSprite / framesH); 

		sticker.animation.add("anim" + i, [i % maxFrames], 0, false);
		sticker.animation.play("anim" + i);

		sticker.camera = camHUD;
		sticker.scale.set(1.4, 1.4);
		sticker.antialiasing = false;
		sticker.updateHitbox();
		sticker.alpha = 0;
		add(sticker);
		stickers.push(sticker);
	}
}

function onPlayerMiss(event) shitSticker();

function shitSticker() {
	target ++;
    if (target > stickers.length)
        target = -1;
	var sticker = stickers[target];

	sticker.alpha = 1;
    
    final randomScale = FlxG.random.float(1.55,1.75);
    sticker.scale.set(randomScale,randomScale);

	var xPos = FlxG.random.int(0, FlxG.width - Std.int(sticker.width));
	var yPos = FlxG.random.int(0, FlxG.height - Std.int(sticker.height));
	sticker.angle = FlxG.random.int(-30, 30);
	sticker.setPosition(xPos, yPos);

	new FlxTimer().start(0.5, function(_) {
		var timeToFade = FlxG.random.float(0.5, 1.5);
        FlxTween.tween(sticker, {"scale.x": 1.4,"scale.y": 1.4,angle: 0}, timeToFade + 0.5,{ease:FlxEase.quadInOut});
		FlxTween.tween(sticker, {alpha: 0}, timeToFade, {ease: FlxEase.linear});
	});
}