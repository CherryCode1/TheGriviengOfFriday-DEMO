var gfsprite:FlxSprite;
static var nose:Bool = false;
function create() {
    //caches de videos para el gameover
    if (!nose) {
        Assets.loadBytes(Paths.video("deathStart"));
        Assets.loadBytes(Paths.video("deathLoop"));
        Assets.loadBytes(Paths.video("deathEnd"));
        nose = false;
    }

    var bg:FlxSprite = new FlxSprite(200,-300).loadGraphic(Paths.image("stages/goanimate/schoolinside"));
    bg.scale.set(2, 2);
    bg.scrollFactor.x = 0.9;
    insert(members.indexOf(gf),bg);
    
    gfsprite = new FlxSprite(800,600);
    gfsprite.frames = Paths.getSparrowAtlas("stages/goanimate/gf");
    gfsprite.scale.set(2,2);
    gfsprite.animation.addByPrefix("idle","gf",24,true);
    gfsprite.animation.play("idle");
    insert(members.indexOf(dad)+1,gfsprite);

    boyfriend.cameraOffset.x -= 200;
    comboGroup.x += 400;
    boyfriend.x += 600;
}

function postCreate() { 
    GameOverSubstate.script = 'data/substates/GameOverSubstate-punished';
    countDownFNF = true;
    FlxG.camera.zoom = defaultCamZoom = 0.75;
}

function onSongEnd() {
    // FlxG.switchState(new ModState("VideoState"));
    video_Path = "punishedend";
    _nextState = FreeplayState;
    endCutscene = "data/states/VideoState";
    trace(endCutscene);
}