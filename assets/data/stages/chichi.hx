import flixel.util.FlxTimer;

var floor:FlxSprite;
var bg:FlxSprite;
var light:FlxSprite;
var sofa:FlxSprite;
var sofaFG:FlxSprite;
var cumB:FlxSprite;

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

    bg = new FlxSprite(-660, -100).loadGraphic(Paths.image("stages/copycat/bg"));
    bg.scrollFactor.set(0.85,1);
    bg.scale.set(0.85,0.85);
    insert(members.indexOf(gf),bg);
  

    sofa = new FlxSprite(-780, -100).loadGraphic(Paths.image("stages/copycat/sofa"));
    sofa.scrollFactor.set(1,1);
    sofa.scale.set(0.9,0.85);
    insert(members.indexOf(gf),sofa);
  

    sofaFG = new FlxSprite(-900, 100).loadGraphic(Paths.image("stages/copycat/sofa2"));
    sofaFG.scrollFactor.set(1.4,1.4);
    sofaFG.scale.set(1,0.85);
    insert(members.indexOf(boyfriend)+1,sofaFG);

 
    comboGroup.setPosition(550,700);
    FlxG.camera.zoom = defaultCamZoom = 0.75;


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
    _isRight =  (curCameraTarget == 0) ? false : true;

  

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