var bloom:CustomShader = new CustomShader("Bloom");
var crom:CustomShader = new CustomShader("cromaticAberration");
var tvctr:CustomShader = new CustomShader("tvcrt");
var intensityBloom:Float = 0.1;
var sizeBlur:Float = 0;
var bg:FlxSprite = new FlxSprite();
function create() {
    bg.loadGraphic(Paths.image("stages/joy/bg"));
    bg.scale.set(0.7,0.7);
    bg.scrollFactor.set(0.9,1);
    bg.screenCenter();
    bg.y -= 200;
    bg.visible = false;
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
    shade.camera = camOverlay;
    shade.scale.set(0.5,0.5);
    shade.screenCenter();
    overlay_Sprites.push(shade);
    add(shade);

    var shade_2 = new FlxSprite(-1000,-800).loadGraphic(Paths.image("joy-ui/put_shiny_effect_here"));
    shade_2.scale.set(1,1);
    shade_2.scrollFactor.set(0,0);
    overlay_Sprites.push(shade_2);
    add(shade_2);

    var puntero = new FlxSprite().loadGraphic(Paths.image("joy-ui/puntero"));
    puntero.camera = camOverlay;
    puntero.scale.set(0.3,0.3);
    puntero.updateHitbox();
    puntero.screenCenter();
    overlay_Sprites.push(puntero);
    add(puntero);


    var camara_ = new FlxSprite(600,0).loadGraphic(Paths.image("joy-ui/cam"));
    camara_.camera = camOverlay;
    camara_.scale.set(0.3,0.3);
    camara_.updateHitbox();
    overlay_Sprites.push(camara_);
    add(camara_);

    for (uh in overlay_Sprites) uh.visible =false;
    time_Txt.visible = false;
    //strumLines.members[0].camera = camGame;
    boyfriend.cameraOffset.y = 100;
    defaultHudZoom = 0.9;
    iconP1.visible = iconP2.visible = false;

    var strum = strumLines.members[2];
    strum.visible = false;
    healthBar.createFilledBar(FlxColor.WHITE, FlxColor.BLACK);
    healthBar.updateBar();
    healthBarBG.setColorTransform(0,0,0,0,
        255,255,255,1
    );
    comboGroup.x = 1500;
    boyfriend.setColorTransform(
        255,255,255, 1
    );
   
}
public function showBanana(){
    gf.visible = true;
    gf.x -=120;
    gf.y +=100;
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

function postUpdate(){
    camOverlay.alpha = camHUD.alpha;
}
public function showBG(){
    
    FlxG.camera.addShader(tvctr);
    camHUD.addShader(tvctr);
    camOverlay.flash(FlxColor.BLACK,5);
    camHUD.alpha = 1;
    for (overlay in overlay_Sprites)
        overlay.visible = true;
    healthBar.createFilledBar(dad.iconColor, boyfriend.iconColor);
    healthBar.updateBar();
    healthBarBG.setColorTransform();
    boyfriend.setColorTransform();
    bg.visible = true;
    boyfriend.cameraOffset.y = 100;
    defaultCamZoom = 0.75;
    boyfriend.x += 250;
    dad.cameraOffset.x -= 700;
    comboGroup.x = 1400;
}