import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;

var isTransition:Bool = false;
var _isTransition:Bool = false;
static var _isDancing:Bool = false;
static var _isRight:Bool = false;
var _timerTrans:FlxTimer; 
var _animationsMike:Array<String> = [
    "anim right turn", "anim left turn",
    "idle right", "idle left"
];

static var isDancing:Bool = false;
static var isRight:Bool = false;

var timerTrans:FlxTimer; 
var previousFocus:Bool = false;
var _previousFocus:Bool = false;
var animationsGf:Array<String> = [
    "trans-right", "trans-left",
    "_idle-right", "_idle-left"
];


var techo:FlxSprite;
var back:FlxSprite;
var lockers:FlxSprite;
var luz:FlxSprite;
var shade:FlxSprite;
var shit:FlxTween;
var yoshi:FlxSprite;

var filter_:FlxSprite = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(15, 28, 48));
var filter_2:FlxSprite = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);

var path_2:String = "stages/the-void/"; 
var bgSprites_:Array<FlxSprite> = [];

var sky:FlxSprite;
var plataform_1:FlxSprite;
var plataform_2:FlxSprite;
var mononoise:Character;
var rocks:FlxTypedGroup<FlxSprite>;
var blur:CustomShader = new CustomShader("blur");
var old_Bg:FlxSprite;
var viggn:FlxSprite;
var viggn2:FlxSprite;
function create(){
 
    isTransition = _isTransition = false;
    timerTrans = new FlxTimer();
    _timerTrans = new FlxTimer();
    noteSkin = "NOTE_assetsEXTRAS";
    splashSkin = "default-griv";
  


    techo = new FlxSprite(-1100,-900).loadGraphic(getPath("techo"));
    techo.scrollFactor.set(0.45,0.45);
    techo.scale.set(0.75,0.75);
    bgSprites_.push(techo);
    insert(members.indexOf(gf), techo);
 
    back = new FlxSprite(-1100,-900).loadGraphic(getPath("back"));
    back.scrollFactor.set(0.45,0.45);
    back.scale.set(0.75,0.75);
    bgSprites_.push(back);
    insert(members.indexOf(gf), back);
 
    piso = new FlxSprite(-1200,-800).loadGraphic(getPath("piso"));
    piso.scale.set(0.75,0.75);
    bgSprites_.push(piso);
    insert(members.indexOf(gf), piso);

    yoshi = new FlxSprite(120,0);
    yoshi.frames = Paths.getSparrowAtlas("stages/alley/Yoshi");
    yoshi.animation.addByPrefix("idle","Idle",24,false);
    yoshi.animation.play("idle");
    yoshi.visible = false;
    bgSprites_.push(yoshi);
    insert(members.indexOf(gf), yoshi);

    lockers = new FlxSprite(-1200,-800).loadGraphic(getPath("lockers"));
    lockers.scale.set(0.75,0.75);
    insert(members.indexOf(gf), lockers);
    bgSprites_.push(lockers);

    sombras = new FlxSprite(-1200,-800).loadGraphic(getPath("sombras"));
    sombras.scale.set(0.75,0.75);
    insert(members.indexOf(gf), sombras);
    bgSprites_.push(sombras);

    luz = new FlxSprite(-1200,-800).loadGraphic(getPath("luz"));
    luz.scale.set(0.75,0.8);
    luz.alpha = 0.5;
    bgSprites_.push(luz);
    insert(members.indexOf(gf), luz);

    shade = new FlxSprite().loadGraphic(getPath("shading eejekrrjaisdpipai"));
    shade.scrollFactor.set(0,0);
    shade.screenCenter();
    bgSprites_.push(shade);
    add(shade);

    shade_2 = new FlxSprite().loadGraphic(getPath("mas sombras"));
    shade_2.scrollFactor.set(0,0);
    shade_2.screenCenter();
    bgSprites_.push(shade_2);
    add(shade_2);

    filter_.scrollFactor.set();
    filter_.scale.set(1.1,1.1);
    filter_.screenCenter();
    filter_.alpha = 0.35;
    filter_.blend = 10;
    filter_.camera = camHUD;
    insert(0,filter_);

    filter_2.scrollFactor.set();
    filter_2.scale.set(1.1,1.1);
    filter_2.screenCenter();
    filter_2.alpha = 0.75;
    filter_2.blend = 12;
    filter_2.camera = camHUD;
    insert(members.indexOf(filter_),filter_2);

    gf.setPosition(450,220);
    gf.scrollFactor.set(1,1);
    boyfriend.setPosition(920,320);
    dad.setPosition(-220,250);

    dad.cameraOffset.x += 100;
    boyfriend.cameraOffset.x -= 200;
  
    luzPenis(); 
    defaultCamZoom = 0.62;
    var songs:Array<String> = getSongs();

    switch(PlayState.SONG.meta.name){
        case "Mistery":
            yoshi.visible = false;
            var mike = strumLines.members[2].characters[0];
            mike.visible = false;

            old_Bg = new FlxSprite().loadGraphic(Paths.image("stages/alley/alley"));
            old_Bg.visible = false;
            insert(members.indexOf(gf), old_Bg);
            strumLines.members[2].characters[3].visible = false;

            
            viggn = new FlxSprite().loadGraphic(Paths.image("stages/alley/shading"));
            insert(members.indexOf(boyfriend) + 1,viggn);   
            
            viggn2 = new FlxSprite().loadGraphic(Paths.image("stages/alley/shading"));
            viggn2.flipX = true;
            insert(members.indexOf(boyfriend) + 1,viggn2);    

            viggn.visible = viggn2.visible = false;
        case "Enigma" | "enigma":
            var mike = strumLines.members[2].characters[0];
            mike.cameraOffset.set(-550,200);
            yoshi.visible = true;

            if (strumLines.members[3].characters[0] != null){
                var mononoise = strumLines.members[3].characters[0];
                mononoise.x -= 650;
                mononoise.y += 180;
                mononoise.visible = false;
            }

            sky = new FlxSprite(-800,-700);
            sky.frames = Paths.getSparrowAtlas(path_2 + 'the-void');
            sky.animation.addByPrefix('idle','the-void idle',24,true);
            sky.animation.play('idle');
            sky.scale.set(2,2);
            sky.scrollFactor.set(0.6,0);
            sky.updateHitbox();
            insert(members.indexOf(gf),sky);

            rocks = new FlxTypedGroup();
            insert(members.indexOf(gf),rocks);

            var rock_1:FlxSprite = new FlxSprite(250,-100).loadGraphic(Paths.image(path_2 + 'Rocas/_roc1'));
            rock_1.scrollFactor.set(0.6,1);
            rock_1.updateHitbox();
            rocks.add(rock_1);

            FlxTween.tween(rock_1,{angle: 1.1,y:rock_1.y + 25},(Conductor.stepCrochet / 1000) * 10,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});
            
            var _yolo:FlxSprite = new FlxSprite(1950,200).loadGraphic(Paths.image(path_2 + 'Rocas/_yolo'));
            _yolo.scrollFactor.set(0.6,1);
            _yolo.updateHitbox();
            rocks.add(_yolo);
            FlxTween.tween(_yolo,{angle: 1.1,y:_yolo.y + 25},(Conductor.stepCrochet / 1000) * 10,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            var rock_2:FlxSprite = new FlxSprite(1850,-100).loadGraphic(Paths.image(path_2 + 'Rocas/_roc2'));
            rock_2.scrollFactor.set(0.6,1);
            rock_2.updateHitbox();
            rocks.add(rock_2);
            FlxTween.tween(rock_2,{angle: 1.1,y:rock_2.y + 25},(Conductor.stepCrochet / 1000) * 10,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            var _ndea:FlxSprite = new FlxSprite(-400,0).loadGraphic(Paths.image(path_2 + 'Rocas/_ndea'));
            _ndea.scrollFactor.set(0.6,1);
            _ndea.updateHitbox();
            rocks.add(_ndea);
            FlxTween.tween(_ndea,{angle: 1.1,y:_ndea.y + 25},(Conductor.stepCrochet / 1000) * 10,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            var rock_7:FlxSprite = new FlxSprite(1900,400).loadGraphic(Paths.image(path_2 + 'Rocas/_roc5'));
            rock_7.scrollFactor.set(0.6,1);
            rock_7.updateHitbox();
            rock_7.flipX = true;
            rocks.add(rock_7);
            FlxTween.tween(rock_7,{angle: 1.1,y:rock_7.y + 25},(Conductor.stepCrochet / 1000) * 10,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            var rock_6:FlxSprite = new FlxSprite(500,400).loadGraphic(Paths.image(path_2 + 'Rocas/_roc6'));
            rock_6.scrollFactor.set(0.6,1);
            rock_6.updateHitbox();
            rocks.add(rock_6);
            FlxTween.tween(rock_6,{angle: 1.1,y:rock_6.y + 45},(Conductor.stepCrochet / 1000) * 25,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            var autobus:FlxSprite = new FlxSprite(750,-50).loadGraphic(Paths.image(path_2 + 'Rocas/autobus'));
            autobus.scrollFactor.set(0.6,1);
            autobus.updateHitbox();
            rocks.add(autobus);
            FlxTween.tween(autobus,{angle: 1.1,y:autobus.y + 50},(Conductor.stepCrochet / 1000) * 25,{type: FlxTween.PINGPONG,ease:FlxEase.sineInOut});

            plataform_1 = new FlxSprite(-900,0).loadGraphic(Paths.image(path_2 + 'plataform_1'));
            plataform_1.updateHitbox();
            insert(members.indexOf(gf),plataform_1);

            plataform_2 = new FlxSprite(-600,0).loadGraphic(Paths.image(path_2 + 'plataform_2'));
            plataform_2.updateHitbox();
            insert(members.indexOf(gf),plataform_2);

            sky.visible = plataform_1.visible = plataform_2.visible = rocks.visible = false;
    }

    comboGroup.x += 800;
    comboGroup.y += 100;
}
public static function showOldBG()
{
    old_Bg.visible = true;
    filter_.visible = false;
    filter_2.visible = false;

    strumLines.members[0].characters[1].visible = false;
    strumLines.members[1].characters[1].visible = false;
    strumLines.members[2].characters[3].visible = true;
    strumLines.members[2].characters[1].visible = false;
    strumLines.members[2].characters[2].visible = false;
    viggn.visible = viggn2.visible = true;
    blur.effectiveness = 0.5;
    camGame.addShader(blur);

}
public static function hideOldBG()
{
    old_Bg.visible = false;
    filter_.visible = true;
    filter_2.visible = true;
    viggn.visible = viggn2.visible = false;
    camGame._filters = [];

    strumLines.members[0].characters[1].visible = true;
    strumLines.members[1].characters[1].visible = true;
    strumLines.members[2].characters[3].visible = false;
    strumLines.members[2].characters[1].visible = true;
    strumLines.members[2].characters[2].visible = true;   
}
function postCreate(){
    camGame.zoom =  defaultCamZoom;
}
public static function changeBG(){
    for (items in bgSprites_)items.visible = false;

    sky.visible = plataform_1.visible = plataform_2.visible =rocks.visible = true;
    filter_.visible = filter_2.visible = false;
  
    
    remove(yoshi);
    var mike = strumLines.members[2].characters[0];
    remove(mike);


    if (!FlxG.save.data.Shadows){
        var dad = strumLines.members[0].characters[1];
        var boyfriend = strumLines.members[1].characters[1];
        var gf = strumLines.members[2].characters[2];

        remove(gf);


        dad.setPosition(500,900);

        dad.cameraOffset.y += 700;
        dad.cameraOffset.x += 150;

        boyfriend.setPosition(2350,900);

        boyfriend.cameraOffset.y -= 300;
        boyfriend.cameraOffset.x -= 1500;

        dad.alpha = 1;
        dad.color = FlxColor.WHITE;
    }
    else{

        var gf = strumLines.members[2].characters[1];
        remove(gf);

        var gf_s = strumLines.members[2].characters[2];
        remove(gf_s);
     
        var bf_s = strumLines.members[1].characters[1];
        remove(bf_s);

        var dad_s = strumLines.members[0].characters[1];
        remove(dad_s);


        dad.flipX = false;
        dad.angle = 0;

        dad.setPosition(500,900);
        dad.cameraOffset.y += 1500;
        dad.cameraOffset.x += 200;
      
     
        boyfriend.setPosition(2350,900);
        boyfriend.cameraOffset.y += 3000;
        boyfriend.cameraOffset.x += 450;
        
        dad.alpha = 1;
        dad.color = FlxColor.WHITE;

    }
    comboGroup.x += 450;
    comboGroup.y += 250;
}

public static function mononoiseVisible(){
    if (!FlxG.save.data.Shadows){
        var dad = strumLines.members[0].characters[1];
        var mononoise = strumLines.members[3].characters[0];
        mononoise.y = dad.y + 50;
        mononoise.x += 550;
        mononoise.visible = true;
    }
    else
    {
        var mononoise = strumLines.members[3].characters[0];
        mononoise.y = dad.y + 50;
        mononoise.x += 550;
        mononoise.visible = true;

    }
   

    var strum =  strumLines.members[3]; 
    strum.visible = true;

    //FlxTween.tween(time_Txt,{x: time_Txt.x - 400},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.circInOut});
    for (notes in [0,1,2,3]) {
        if (!FlxG.save.data.Shadows){
         var strum  = strumLines.members[3].members[notes];
         strum.x += 550;
         strum.y += 710;
         strum.alpha = 0.55;
        }else{
            var strum  = strumLines.members[3].members[notes];
            strum.x += 550;
            strum.y += 710;
            strum.alpha = 0.55;
        }


        var strumSplatty = strumLines.members[0];
        strumSplatty.camera = camGame;
        strumSplatty.members[notes].alpha = 0.55;
       
      
        var strum  = strumLines.members[0].members[notes];
        strum.x = -500;
        strum.x += notes * 100; 
        strum.y = 120;
        strum.scrollFactor.set(1, 1);
        strum.x += 1005;
        strum.y += 650;


        //var strumPlayer = strumLines.members[1].members[notes];
        //FlxTween.tween(strumPlayer,{x: strumPlayer.x -300},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.circInOut});

    }
    for (shit in strumLines.members[0].notes)  {
        shit.alpha = 0.3;
    }
    for (shit in strumLines.members[3].notes)  {
        shit.alpha = 0.3;
    }
}
function beatHit() {
    if (curBeat % 2 == 0 && yoshi != null) yoshi.animation.play('idle');

    if (isRight) daOffsetAnim = 2;
    else daOffsetAnim = 3;

    if (_isRight) _daOffsetAnim = 2;
    else _daOffsetAnim = 3;

    if (!isTransition) {
        isDancing = true;
        if (curBeat % 2 == 0) {
            for (strum in strumLines)
                for (char in strum.characters)
                    switch (char.curCharacter) {
                        case "Mike": char.playAnim(_animationsMike[daOffsetAnim], true);
                    }
        }
    }
    if (!_isTransition) {
        _isDancing = true;
        if (curBeat % 2 == 0) {
            for (strum in strumLines)
                for (char in strum.characters)
                    switch (char.curCharacter) {
                        case "gf-enigma": char.playAnim(animationsGf[_daOffsetAnim], true);
                    }
        }
    }
}
var time:Float = 0;
function postUpdate(elapsed:Float){
    time += elapsed;
  
    isRight = (curCameraTarget == 0) ? false : true;
    _isRight = isRight;

    if (isRight != previousFocus && !isTransition) {
        previousFocus = isRight;
      
        if (!isRight) changeAnimGf(1);
        if (isRight) changeAnimGf(0);
    }

    if (_isRight != _previousFocus && !_isTransition) {
        _previousFocus = _isRight;
        if (!_isRight) changeAnimMike(1);
        if (_isRight) changeAnimMike(0);
    }
    if (blur != null){
        blur.iTime = time;
    }

}
function changeAnimMike(changed:Int) {
    if (_isTransition) return;
    _isTransition = true;

    for (strum in strumLines) {
        for (char in strum.characters) {
            if (char.curCharacter == "Mike") {
                char.playAnim(_animationsMike[changed], true);
            }
        }
    }
    _timerTrans.start(0.6, function(timer:FlxTimer) {
        _isTransition = false; 
    });
}

function changeAnimGf(changed:Int) {
    if (isTransition) return;
    isTransition = true;

   
    for (strum in strumLines) {
        for (char in strum.characters) {
            if (char.curCharacter == "gf-enigma") {
                char.playAnim(animationsGf[changed], true);
            }
        }
    }

    timerTrans.start(0.6, function(timer:FlxTimer) {
        isTransition = false; 
    });
}

function luzPenis() {
    var targetAlpha = Math.random() > 0.5 ? 0.0 : 0.3 + Math.random() * 0.7; 
    FlxTween.tween(luz, {alpha: targetAlpha}, 0.5 + Math.random() * 1.0, { 
        ease: FlxEase.elasticeaseInOut, 
        onComplete: luzPenis 
    });
}
function getPath(key:String) {
    return Paths.image('stages/alley/' + key);
}