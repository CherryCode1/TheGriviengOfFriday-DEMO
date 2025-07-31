var bloom:CustomShader = new CustomShader("Bloom");
var crom:CustomShader = new CustomShader("cromaticAberration");
var tvctr:CustomShader = new CustomShader("tvcrt");
var intensityBloom:Float = 0.1;
var sizeBlur:Float = 0;
var bg:FlxSprite = new FlxSprite();
var bg1:FlxSprite = new FlxSprite();
var simian:FlxSprite = new FlxSprite();
var gumaballecen:FlxSprite = new FlxSprite();
var scene2:FlxSprite = new FlxSprite();
var scene1:FlxSprite = new FlxSprite();

function create() {
    simian = new FlxSprite(0,0);
    simian.frames = Paths.getSparrowAtlas("stages/joy/Miss-Simian");
    simian.animation.addByPrefix("ada","simian idle",24,true);
    simian.animation.play("ada");
    simian.camera = camOverlay;
    simian.scale.set(1.2,1.2);
    simian.alpha = 0;
    simian.screenCenter();
    add(simian);

    gumaballecen.loadGraphic(Paths.image("stages/joy/Ecenaguball"));
    gumaballecen.scale.set(0.5,0.5);
    gumaballecen.screenCenter();
    gumaballecen.camera = camHUD;
    gumaballecen.visible = false;
    gumaballecen.screenCenter();
    add(gumaballecen);

    scene1.loadGraphic(Paths.image("stages/joy/Ecena1"));
    scene1.scale.set(0.5,0.5);
    scene1.camera = camHUD;
    scene1.screenCenter();
    scene1.visible = false;
    scene1.screenCenter();
    add(scene1);

    scene2.loadGraphic(Paths.image("stages/joy/Ecena2"));
    scene2.scale.set(0.5,0.5);
    scene2.screenCenter();
    scene2.camera = camHUD;
    scene2.visible = false;
    scene2.screenCenter();
    add(scene2);

    bg1.loadGraphic(Paths.image("stages/joy/piso"));
    bg1.scale.set(0.7,0.7);
    bg1.scrollFactor.set(0.9,1);
    bg1.screenCenter();
    bg1.visible = false;
    bg1.y -= 200;
    insert(members.indexOf(gf),bg1);

    bg.loadGraphic(Paths.image("stages/joy/librerias"));
    bg.scale.set(0.7,0.7);
    bg.scrollFactor.set(0.9,1);
    bg.screenCenter();
    bg.visible = false;
    bg.y -= 200;
    insert(members.indexOf(gf),bg);

    crom.greenOff = [-0.0015,0.0015];
    crom.blueOff = [-0.0015,0.0015];

    camGame.addShader(crom);
    camHUD.addShader(crom);
    camGame.addShader(bloom);
    camHUD.addShader(bloom);
    countDownFNF = false;
    healthBarDefault = true;
    
    countDown = "joy";
    noteSkin = "NOTE_assets";
    splashSkin = "default-griv";  

    FlxG.camera.zoom = defaultCamZoom = 0.6;
    dispHudInStart = false;   
}

var overlay_Sprites:Array<Dynamic> =[];

function beatHit(){
    if(curBeat % camZoomingInterval == 0){
       intensityBloom += 0.25;
       sizeBlur += 0.015;
    }
}
var time_:Float = 0;
function update(elapsed:Float){
    bloom.intensity = intensityBloom;
    bloom.blurSize = sizeBlur;

    sizeBlur = lerp(sizeBlur,0,0.08);
    intensityBloom = lerp(intensityBloom,0.1, 0.08);
    time_ += elapsed;
    tvctr.iTime = time_; 
}
function postCreate(){
    var shade = new FlxSprite().loadGraphic(Paths.image("joy-ui/put_shane_effect_13"));
    shade.camera = camHUD;
    shade.scale.set(0.7,0.7);
    shade.screenCenter();
    overlay_Sprites.push(shade);
    add(shade);

    var shade_2 = new FlxSprite(-1000,-800).loadGraphic(Paths.image("joy-ui/put_shiny_effect_here"));
    shade_2.scale.set(0.7,0.7);
    shade_2.scrollFactor.set(0.45,0.45);
    overlay_Sprites.push(shade_2);
    add(shade_2);

    var puntero = new FlxSprite().loadGraphic(Paths.image("joy-ui/puntero"));
    puntero.camera = camHUD;
    puntero.setGraphicSize(FlxG.width, FlxG.height);
    puntero.updateHitbox();
    puntero.screenCenter();
    overlay_Sprites.push(puntero);
    add(puntero);

    for (uh in overlay_Sprites) uh.visible =false;
    //strumLines.members[0].camera = camGame;
    boyfriend.cameraOffset.y = 170;
    iconP1.visible = iconP2.visible = false;

    var strum = strumLines.members[2];
    strum.visible = false;

    comboGroup.x = 1500;
}
public function showBanana(){
    gf.visible = true;
}

public function showBananaNotes()
{
    for (i in [0,1,2,3]){
        var strum = strumLines.members[2];
        strum.visible = true;
        strum.members[i].alpha = 0;
    }
    for (strum in strumLines.members[2].notes){
        strum.alpha = 0.45;
    }
}
function stepHit(){
    if (curStep > 1332 && curStep < 1774){
        for (i in [0,1,2,3]){
            var strum = strumLines.members[2];
            strum.visible = true;
            strum.members[i].alpha = lerp(strum.members[i].alpha,0.3,0.1);
        }
        for (strum in strumLines.members[2].notes){
            strum.alpha = lerp(strum.alpha,0.35,0.1);
        }
    }
 
    if (curStep == 1790) {
        gf.visible = false;
    }

    if (curStep == 1790) {
        for (i in [0,1,2,3]){
         var strum = strumLines.members[2];
         strum.visible = false;
        }
    }
}

public function GumballJoyPantalla() {
    gumaballecen.visible = true;
}

public function Escena1() {
    scene1.visible = true;
    gumaballecen.visible = false;
}
public function Escena2() {
    scene2.visible = true;
    scene1.visible = false;
    gumaballecen.visible = false;
}

public function ShowSimian() {
    FlxTween.tween(simian, {alpha: 0.4}, 1,{ease:FlxEase.circInOut});
}

function postUpdate(){
    camOverlay.alpha = camHUD.alpha;
    score_Txt.x = 230;
}
public function showBG(){
    
    camOverlay.flash(FlxColor.BLACK,5);
    camHUD.alpha = 1;
    for (overlay in overlay_Sprites)
        overlay.visible = true;
    bg.visible = true;
    bg1.visible = true;
    dad.cameraOffset.x -= 700;

    strumLines.members[1].characters[1].x += 250;
    strumLines.members[1].characters[1].cameraOffset.y = -530;
    strumLines.members[0].characters[1].cameraOffset.x -= 540;

    strumLines.members[1].characters[0].visible = true;
    strumLines.members[0].characters[0].visible = true;

    boyfriend.cameraOffset.y = -100;
   
    defaultCamZoom = 0.75;  
    comboGroup.x = 1400;
}