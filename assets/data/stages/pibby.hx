public static var bg_sprites_P:Array<FlxSprite> = [];
function create() {

    noteSkin = "NOTE_assets";
    splashSkin = "default-griv";  

    var sky:FlxSprite = new FlxSprite(-700,-900).loadGraphic(Paths.image('stages/pibby/SkyBg'));
    sky.scrollFactor.set(0.05,0.05);
    insert(members.indexOf(gf),sky);
    bg_sprites_P.push(sky);

    var sun:FlxSprite = new FlxSprite(100,-250);
  
    sun.frames = Paths.getSparrowAtlas('stages/pibby/Corrupted_Sun');
    sun.animation.addByPrefix('idle', 'Idle',24,true);
    sun.animation.play('idle');
    sun.scrollFactor.set(0.3,0.5);
    sun.scale.set(0.8,0.8);
    insert(members.indexOf(gf),sun);
    bg_sprites_P.push(sun);

    var mountain:FlxSprite = new FlxSprite(-900,-600).loadGraphic(Paths.image('stages/pibby/mountain'));
    mountain.scrollFactor.set(0.3,0.8);
    insert(members.indexOf(gf),mountain);

    bg_sprites_P.push(mountain);

    var background:FlxSprite = new FlxSprite(-1200,-800).loadGraphic(Paths.image('stages/pibby/background'));
    background.scrollFactor.set(0.5,0.8);
    insert(members.indexOf(gf),background);
    bg_sprites_P.push(background);

    var ground:FlxSprite = new FlxSprite(-1200,-800).loadGraphic(Paths.image('stages/pibby/ground'));
    insert(members.indexOf(gf),ground);
    bg_sprites_P.push(ground);
}

function postCreate() {
    
    iconP1.flipX = true;
    dad.setPosition(-500,400);
    gf.setPosition(250,500);
    gf.beatInterval = 2;
    boyfriend.setPosition(800,500);
    comboGroup.x += 600;
    comboGroup.y += 200;
    FlxG.camera.zoom = defaultCamZoom = 0.65;
}