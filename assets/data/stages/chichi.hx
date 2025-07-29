import flixel.util.FlxTimer;

var floor:FlxSprite;
var bg:FlxSprite;
var light:FlxSprite;
var sofa:FlxSprite;
var sofaFG:FlxSprite;
var yellow:FlxSprite;
var cumB:FlxSprite;
var platafor1:FlxSprite;
var platafor2:FlxSprite;
var platafor3:FlxSprite;
var lamp:FlxSprite;
var logo:FlxSprite;
var _timerTrans:FlxTimer; 
var _isTransition:Bool = false;
static var _isDancing:Bool = false;
static var _isRight:Bool = false;
var _previousFocus:Bool = false;
var _animationsRibbit:Array<String> = [
    "transR", "transL",
    "right", "left"
];

var fase_1:Bool = true;
function create()
{
    _timerTrans = new FlxTimer();
    noteSkin = "NOTE_assetsEXTRAS";
    splashSkin = "default-griv";

    floor = new FlxSprite(-720, -100).loadGraphic(Paths.image("stages/copycat/floor"));
    floor.scrollFactor.set(1,1);
    floor.scale.set(0.9,0.85);
    insert(members.indexOf(gf),floor);

  

    yellow = new FlxSprite(-530, -100).loadGraphic(Paths.image("stages/copycat/yellow"));
    yellow.scrollFactor.set(0.85,1);
    yellow.scale.set(20,20);
    yellow.visible = false;
    insert(members.indexOf(gf),yellow);

    platafor1 = new FlxSprite(470, 730).loadGraphic(Paths.image("stages/copycat/shitstain"));
    platafor1.scrollFactor.set(1,1);
    platafor1.visible = false;
    insert(members.indexOf(gf), platafor1);

    platafor2 = new FlxSprite(1200, 900).loadGraphic(Paths.image("stages/copycat/shitstain"));
    platafor2.scrollFactor.set(1,1);
    platafor2.visible = false;
    insert(members.indexOf(gf),platafor2);

    platafor3 = new FlxSprite(-270, 900).loadGraphic(Paths.image("stages/copycat/shitstain"));
    platafor3.scrollFactor.set(1,1);
    platafor3.visible = false;
    insert(members.indexOf(gf),platafor3);

    bg = new FlxSprite(-660, -100).loadGraphic(Paths.image("stages/copycat/bg"));
    bg.scrollFactor.set(0.85,1);
    bg.scale.set(0.85,0.85);
    insert(members.indexOf(gf),bg);

    lamp = new FlxSprite(-720, -100).loadGraphic(Paths.image("stages/copycat/lamp"));
    lamp.scrollFactor.set(1,1);
    lamp.scale.set(0.9,0.85);
    insert(members.indexOf(gf), lamp);

    sofa = new FlxSprite(-780, -100).loadGraphic(Paths.image("stages/copycat/sofa"));
    sofa.scrollFactor.set(1,1);
    sofa.scale.set(0.9,0.85);
    insert(members.indexOf(gf),sofa);

    sofaFG = new FlxSprite(-900, 100).loadGraphic(Paths.image("stages/copycat/sofa2"));
    sofaFG.scrollFactor.set(1.4,1.4);
    sofaFG.scale.set(1,0.85);
    insert(members.indexOf(boyfriend)+1,sofaFG);

    logo = new FlxSprite(860,350).loadGraphic(Paths.image("logos/sany"));
    logo.scale.set(0.4,0.4);
    logo.camera = camHUD;
    add(logo);
 
    comboGroup.setPosition(550,700);
    FlxG.camera.zoom = defaultCamZoom = 0.75;
    GameOverSubstate.script = "data/substates/GameOverSubstate-miracle";
}

function postCreate(){
    cumB = new FlxSprite(0,0);
    cumB.frames = Paths.getSparrowAtlas("stages/copycat/cumBorder");
    cumB.animation.addByPrefix("instance","cumBorderLoop",14,true);
    cumB.animation.play("instance");
    cumB.camera = camOverlay;
    cumB.scale.set(1,1);
    cumB.alpha = 0;
    cumB.screenCenter();
    add(cumB);
}

function beatHit() {
    if (_isRight) _daOffsetAnim = 2;
    else _daOffsetAnim = 3;

 
    if (!_isTransition) {
        _isDancing = true;
        if (curBeat % 2 == 0) {
            gf.playAnim(_animationsRibbit[_daOffsetAnim], true);
        }
    }
}

function postUpdate(elapsed:Float){
    _isRight = curCameraTarget != 0;

    if (_isRight != _previousFocus && !_isTransition) {
        _previousFocus = _isRight;
      
        if (!_isRight) changeAnimGf(1);
        if (_isRight) changeAnimGf(0);
    }
}

function changeAnimGf(changed:Int) {
    if (_isTransition) return;
    _isTransition = true;

    gf.playAnim(_animationsRibbit[changed], true);

    _timerTrans.start(0.6, function(timer:FlxTimer) {
        _isTransition = false; 
    });
}

public function hideChichiStage()
{
    floor.visible = false;
    bg.visible = false;
    sofa.visible = false;
    sofaFG.visible = false;
    yellow.visible = true;
    platafor1.visible = true;
    platafor2.visible = true;
    platafor3.visible = true;
    lamp.visible = false;
}

public function showChichiStage()
{
    floor.visible = true;
    bg.visible = true;
    sofa.visible = true;
    sofaFG.visible = true;
    yellow.visible = false;
    platafor1.visible = false;
    platafor2.visible = false;
    platafor3.visible = false;
    lamp.visible = true;
}