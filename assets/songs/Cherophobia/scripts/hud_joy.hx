import flixel.math.FlxRect;

public var leftBar:FlxSprite;
public var rightBar:FlxSprite;
public var new_healBarBG:FlxSprite;
public var corashon:FlxSprite;
public var circle:FlxSprite;
var barOffset:Array<Float> = [3, 3];

function postCreate() {
    remove(healthBarBG);
    healthBar.visible = false;

    leftBar = new FlxSprite().loadGraphic(Paths.image("Joy-UI/joysito"));
    rightBar = new FlxSprite().loadGraphic(Paths.image("Joy-UI/barr"));

    // bar bg
    new_healBarBG = new FlxSprite().loadGraphic(Paths.image("Joy-UI/barrBG"));
    //circle
    circle = new FlxSprite().loadGraphic(Paths.image("Joy-UI/circle"));
    circle.scale.set(0.6,0.6);
    // corashon
    corashon = new FlxSprite();
    corashon.frames = Paths.getSparrowAtlas("Joy-UI/Corazao joy");
    corashon.animation.addByPrefix("1","10",24,false);
    corashon.animation.addByPrefix("2","20",24,false);
    corashon.animation.addByPrefix("3","30",24,false);
    corashon.animation.addByPrefix("3","30",24,false);
    corashon.animation.play("3");
    corashon.scale.set(0.2,0.2);

    //properties
    for (bars in [leftBar, rightBar,new_healBarBG,corashon,circle]) {
        bars.cameras = [camHUD];
        bars.antialiasing = true;
        bars.scrollFactor.set();
        if (bars == rightBar) bars.color = boyfriend.iconColor;

        var offsetDownscroll:Float = 0;
        switch(bars){
            case leftBar: 
                offsetDownscroll = (get_downscroll()) ? 10: 0;
                bars.offset.set(0,offsetDownscroll);
                bars.setPosition(565,650);
            case rightBar: 
                offsetDownscroll = (get_downscroll()) ? 25: 0;
                  bars.offset.set(0,offsetDownscroll);
                bars.setPosition(565,630);
            case new_healBarBG: 
                offsetDownscroll = 0;
                bars.offset.set(0,offsetDownscroll());
                bars.setPosition(550,640);
            case corashon:
                offsetDownscroll =(get_downscroll()) ? 0: 0;
                bars.offset.set(0,offsetDownscroll);
                bars.setPosition(-20,420);
            case circle:
                offsetDownscroll =(get_downscroll()) ? 0: 0;
                bars.offset.set(0,offsetDownscroll);
                bars.setPosition(-100,480);
        }
    }

    leftBar.clipRect = new FlxRect(0, 3, leftBar.width, leftBar.height);
    rightBar.clipRect = new FlxRect(0, 3, rightBar.width, rightBar.height);

    insert(members.indexOf(healthBar)+ 1, leftBar);
    insert(members.indexOf(leftBar) + 1, rightBar);
    insert(members.indexOf(rightBar) + 1, new_healBarBG);
    add(circle);
    add(corashon);
}

function postUpdate(elapsed:Float) { 
    updateValueBars();
}

function beatHit(){
    if (curBeat % camZoomingInterval == 0) {
        if (camZoomingInterval <= 2) {
            corashon.animation.play("1");
        } else if (camZoomingInterval <= 4) {
            corashon.animation.play("2");
        } else {
            corashon.animation.play("3");
        }
    }
   
}

function updateValueBars() {
    var leftBarWidth = leftBar.width;
    var rightBarWidth = rightBar.width;
    var barHeight = rightBar.height;
var percent_ = health * 50; 


    var leftSize:Float = FlxMath.lerp(0, leftBarWidth, 1 - percent_ / 100);
    var rightSize:Float = rightBarWidth - leftSize;

    leftBar.clipRect.set(barOffset[0], barOffset[1], leftSize, barHeight);
    rightBar.clipRect.set(barOffset[0] + leftSize, barOffset[1], rightSize, barHeight);

    // ✅ Forzar actualización visual
    leftBar.clipRect = leftBar.clipRect;
    rightBar.clipRect = rightBar.clipRect;

    // Debug
    trace("leftWidth: " + leftBar.width + " | rightWidth: " + rightBar.width);
    trace("percent: " + percent_);
}
