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

    var bg:FlxSprite = new FlxSprite(-227, 7).loadGraphic(Paths.image("stages/goanimate/schoolinside"));
    bg.scale.set(1.52, 1.52);
    insert(members.indexOf(gf),bg);
    
    gfsprite = new FlxSprite(378, 728);
    gfsprite.frames = Paths.getSparrowAtlas("stages/goanimate/gf");
    gfsprite.scale.set(1.4,1.4);
    gfsprite.animation.addByPrefix("idle","gf",24,true);
    gfsprite.animation.play("idle");
    gfsprite.flipX = true;
    insert(members.indexOf(dad)+1,gfsprite);

    comboGroup.x -= 220;
    PlayState.instance.comboGroup.visible = false;


camGameZoomLerp = 0.1;
}

function postCreate() { 
   
    GameOverSubstate.script = 'data/substates/GameOverSubstate-punished';
    countDownFNF = true;
    FlxG.camera.zoom = defaultCamZoom = 0.8;

    strumLines.members[1].members[0].x = strumLines.members[1].members[0].x + 30;     strumLines.members[0].members[0].x = strumLines.members[0].members[0].x + 30;
    strumLines.members[1].members[1].x = strumLines.members[1].members[1].x + 15;     strumLines.members[0].members[1].x = strumLines.members[0].members[1].x + 15;
    strumLines.members[1].members[2].x = strumLines.members[1].members[2].x - 5;     strumLines.members[0].members[2].x = strumLines.members[0].members[2].x - 5;
    strumLines.members[1].members[3].x = strumLines.members[1].members[3].x - 25;    strumLines.members[0].members[3].x = strumLines.members[0].members[3].x - 25;
   
}

var tweenHealth:Bool = false;
function beatHit() {
    if (curBeat == 432) {
        tweenHealth = true;
    }
}
function onDadHit(e)
{
    if (curStep >=  895 && curStep < 1663)   {
        if(health > 0.1)
        {
            e.healthGain = 0.03;
        }
    }
}

function onCountdown(event:CountdownEvent) event.cancel();
function onStrumCreation(_) _.__doAnimation = false;

function postUpdate(elapsed:Float){
        for (strumLine in strumLines){
            for (strum in strumLine){
                strum.scale.set(0.6,0.6);
            }
        }
        for (strum in cpuStrums.notes) {
            strum.scale.set(0.6,0.6);
        }
         for (strum in playerStrums.notes) {
            strum.scale.set(0.6,0.6);
        }
    if (tweenHealth) {
        health += 0.85 * elapsed;  
    }
}