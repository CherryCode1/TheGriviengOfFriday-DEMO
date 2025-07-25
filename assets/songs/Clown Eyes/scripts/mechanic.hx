import flixel.math.FlxRect;

var TIME_SPACEPRESSED:Float = 8;
var minTime:Float = 3;
var maxTime:Float = 6;

var darwingDraw = new FlxSprite();
var barr_mechanic_ = new FlxSprite(-200, 330);
var barr_mechanicBG = new FlxSprite(-200, 330);

var spaceBlock:Bool = false;
var AMOUNT_ANXIETY:Float = 0.1;
var TOTAL_ANXIETY:Float = 0.0;
var MAX_ANXIETY:Float = 5.0;
public var activeMechanic = true;

var spaceCooldown:Float = 0;         
var spaceCooldownTime:Float = 3.5;

function postCreate() {
    if (!FlxG.save.data.clownMechanic) return;


    barr_mechanic_.loadGraphic(Paths.image("stages/clown/barr_clown_"));
    barr_mechanic_.camera = camHUD;
    barr_mechanic_.scale.set(0.5, 0.5);
    barr_mechanic_.alpha = 0;
    barr_mechanic_.clipRect = new FlxRect(0, 3, barr_mechanic_.width, barr_mechanic_.height);
    insert(members.indexOf(healthBar),barr_mechanic_);

    barr_mechanicBG.loadGraphic(Paths.image("stages/clown/barr_clown"));
    barr_mechanicBG.camera = camHUD;
    barr_mechanicBG.scale.set(0.5, 0.5);
    barr_mechanicBG.alpha = 0;
    insert(members.indexOf(healthBar),barr_mechanicBG);

    darwingDraw.loadGraphic(Paths.image("stages/clown/darwingDraw"));
    darwingDraw.screenCenter();
    darwingDraw.y += 1000;
    darwingDraw.scale.set(0.5, 0.5);
    darwingDraw.camera = camOverlay;
    insert(members.indexOf(strumLines) + 10,darwingDraw);

    healthBarBG.x += 150;
    healthBar.x += 150;
    if (get_downscroll()) {
        barr_mechanic_.y += 70;
        barr_mechanicBG.y += 70;
    }
}

function onDadHit(event) {
    if (!FlxG.save.data.clownMechanic) return;

    if (!event.isSustainNote && !FlxG.keys.pressed.SPACE) {
        TOTAL_ANXIETY += AMOUNT_ANXIETY;
        if (TOTAL_ANXIETY > MAX_ANXIETY)
            TOTAL_ANXIETY = MAX_ANXIETY;
    }
}

function postUpdate(elapsed:Float) {
    if (!FlxG.save.data.clownMechanic) return;

    if (curStep > 0 && activeMechanic) {
       
        if (spaceCooldown > 0)
            spaceCooldown -= elapsed;

        if (FlxG.keys.pressed.SPACE && !spaceBlock && spaceCooldown <= 0) {
            TIME_SPACEPRESSED -= 0.04;
            darwingDraw.y = FlxMath.lerp(darwingDraw.y, -360, 0.1);

            TOTAL_ANXIETY -= 0.015;
            if (TOTAL_ANXIETY < 0) TOTAL_ANXIETY = 0;

            if (TIME_SPACEPRESSED <= 0) {
                TIME_SPACEPRESSED = 0;
                spaceBlock = true;
                spaceCooldown = spaceCooldownTime; 
            }
        }

        if (spaceBlock) {
            darwingDraw.y = FlxMath.lerp(darwingDraw.y, 1020, 0.1);

            if (!FlxG.keys.pressed.SPACE && darwingDraw.y >= 1010) {
                TIME_SPACEPRESSED = FlxMath.lerp(TIME_SPACEPRESSED, maxTime, 0.05);
                if (TIME_SPACEPRESSED >= minTime) {
                    spaceBlock = false;
                }
            }
        }

        if (!spaceBlock && !FlxG.keys.pressed.SPACE) {
            darwingDraw.y = FlxMath.lerp(darwingDraw.y, 1020, 0.05);
            TIME_SPACEPRESSED = FlxMath.lerp(TIME_SPACEPRESSED, maxTime, 0.01);
        }

        if (TOTAL_ANXIETY >= MAX_ANXIETY) {
            health = FlxMath.lerp(health, -0.1, 0.007);
        }

        var anxietyRatio:Float = FlxMath.bound(TOTAL_ANXIETY / MAX_ANXIETY, 0, 1);
        updateValueBars(anxietyRatio);
    }else{

        darwingDraw.y = FlxMath.lerp(darwingDraw.y, 1020, 0.1);
    }
    for (item in [barr_mechanic_, barr_mechanicBG])
        item.alpha = healthBar.alpha;
}

function updateValueBars(anxietyRatio:Float) {
   

    var barWidth = barr_mechanic_.width;
    var barHeight = barr_mechanic_.height;
    var visibleWidth = barWidth * anxietyRatio;

    barr_mechanic_.clipRect.set(0, 0, visibleWidth, barHeight);
    barr_mechanic_.clipRect = barr_mechanic_.clipRect;
}
