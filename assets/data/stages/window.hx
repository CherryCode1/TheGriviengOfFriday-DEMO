import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;

var houseStuff:Array<String> = ['overworld', 'outsidehouse', 'house'];
var path = 'stages/clown/';

var house:FlxSprite;
var globos:Array<FlxSprite> = [];
var showComboNum:FunkinText = new FunkinText(0, 0, 0, '0', 200);
var showComboTxt:FunkinText = new FunkinText(0, 0, 0, 'COMBO', 100);

public var gumballCamera:FlxCamera = new FlxCamera();
public var shader_fire = new CustomShader("fire_");
public var fire_Sprite = new FlxSprite(490,100);
public var desactivateZoom_A = false;
var viggnete = new FlxSprite().loadGraphic(Paths.image("stages/class/fog_class"));
var houseFilter:BlurFilter = FlxG.save.data.BlurShade ? new BlurFilter(10, 10, 2) : null;
var gumballFilter:BlurFilter = FlxG.save.data.BlurShade ? new BlurFilter(0, 0, 2) : null;
var blurEffect:CustomShader = FlxG.save.data.blurEffect ? new CustomShader('blur') : null;

function create() {
    healthBarDefault = true;
    noteSkin = "NOTE_assetsEXTRAS";
    splashSkin = "default-griv";
}

function postCreate() {
    score_Txt.x = 150;
    iconP1.flipX = true;
    gumballCamera.bgColor = FlxColor.TRASPARENT;
    FlxG.cameras.insert(gumballCamera, 1, false);

    if (houseFilter != null && gumballFilter != null) {
        FlxG.camera.setFilters([houseFilter]);
        gumballCamera.setFilters([gumballFilter]);
    }

    if (blurEffect != null) {
        blurEffect.iTime = 0;
        blurEffect.effectiveness = 0;
        camGame.addShader(blurEffect);
        camHUD.addShader(blurEffect);
    }

    for (i in 0...houseStuff.length) {
        var asset:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path + houseStuff[i]));
        if (i == 2) house = asset;
        insert((i < 2) ? i : members.indexOf(dad) + 1, asset);
    }

    fire_Sprite.makeGraphic(FlxG.width * 1.4, FlxG.height * 1.4, FlxColor.TRASPARENT);
    fire_Sprite.shader = FlxG.save.data.FireShader ? shader_fire : null;  
    fire_Sprite.flipY = true;
    fire_Sprite.visible = false;
    insert(members.indexOf(dad),fire_Sprite);

    viggnete.camera = camOverlay;
    viggnete.blend = 'alpha'; //lul
    viggnete.alpha = 0;
    insert(0, viggnete);

    for (i in 0...20) {
        var baloon:FlxSprite = new FlxSprite(0, 1100).loadGraphic(Paths.image(path + 'globo' + FlxG.random.int(1, 4)));
        globos.push(baloon);
        insert(1, baloon);
    }

    for (i => text in [showComboNum, showComboTxt]) {
        text.font = Paths.font('Gumball.ttf');
        text.color = FlxColor.GRAY;
        text.borderColor = FlxColor.WHITE;
        text.borderSize = 3;
        text.alignment = 'center';
        text.cameras = [camHUD];
        text.setPosition(-text.width, FlxG.height / 2 + (i == 0 ?  75 - text.height : 25));
        insert(i, text);
    }

    dad.setPosition(600, 890);
    boyfriend.setPosition(650, 230);
    boyfriend.cameras = [gumballCamera];

    comboGroup.x += 450;
    comboGroup.y += 200;
}

var moveComboNum:Bool = false;
var moveComboText:Bool = false;
var curShakeIntensity:Float = 0;

var time_Elapsed:Float = 0;
var frameRate:Int = 0;
function update(elapsed) {
    if (healthBar.percent >= 80) iconP2.angle = FlxG.random.int(-3, 3);
    else iconP2.angle = 0;

    time_Elapsed += elapsed;
    frameRate++;

    if (FlxG.save.data.FireShader)
        if (frameRate % Std.int(FlxG.save.data.FrameRateFireShader) == 0 && fire_Sprite.visible) shader_fire.iTime = time_Elapsed;

    gumballCamera.focusOn(FlxG.camera.scroll);
    gumballCamera.angle = FlxG.camera.angle;
    gumballCamera.zoom = FlxG.camera.zoom + 0.2;

    if (curCameraTarget != 0) {
        setCamerasFilter(10, 0);
        blurEffect?.effectiveness = lerp(blurEffect?.effectiveness, 0, 0.05);
        viggnete.alpha = lerp(viggnete.alpha, 0, 0.05);
        curShakeIntensity = lerp(curShakeIntensity, 0, 0.05);
    } else {
        setCamerasFilter(0, 10);
        if((curBeat >= 4 && curBeat < 212) || curBeat >= 276) {
            blurEffect?.effectiveness = lerp(blurEffect?.effectiveness, 0.1, 0.05);
            viggnete.alpha = lerp(viggnete.alpha, 1, 0.05);
        }
        curShakeIntensity = lerp(curShakeIntensity, 0.001, 0.05);
    }

    if (blurEffect != null && blurEffect.effectiveness > 0.01) blurEffect.iTime += elapsed;
    if (moveComboNum) showComboNum.x += elapsed * 20;
    if (moveComboText) showComboTxt.x += elapsed * 20;

     //no se si ponerlo lul
    // comboGroup.cameras = [camHUD];
    // comboGroup.setPosition(120, FlxG.height - 150);
}

function postUpdate(elapsed)  comboGroup.cameras = [gumballCamera];
function setCamerasFilter(houseBlur:Int, gumballBlur:Int) {
    houseFilter.blurX = FlxMath.lerp(houseFilter.blurX, houseBlur, 0.05);
    houseFilter.blurY = FlxMath.lerp(houseFilter.blurY, houseBlur, 0.05);
    gumballFilter.blurX = FlxMath.lerp(gumballFilter.blurX, gumballBlur, 0.05);
    gumballFilter.blurY = FlxMath.lerp(gumballFilter.blurY, gumballBlur, 0.05);
}

function beatHit() {
    if (curBeat == 212) {
        house.colorTransform.redOffset = house.colorTransform.greenOffset = house.colorTransform.blueOffset = -255;
        dad.colorTransform.redOffset = dad.colorTransform.greenOffset = dad.colorTransform.blueOffset = 255;
        boyfriend.colorTransform.redOffset = boyfriend.colorTransform.greenOffset = boyfriend.colorTransform.blueOffset = 255;
        activeMechanic = false;
    }
    if (curBeat == 276) {
        house.colorTransform.redOffset = house.colorTransform.greenOffset = house.colorTransform.blueOffset = 0;
        dad.colorTransform.redOffset = dad.colorTransform.greenOffset = dad.colorTransform.blueOffset = 0;
        boyfriend.colorTransform.redOffset = boyfriend.colorTransform.greenOffset = boyfriend.colorTransform.blueOffset = 0;
        activeMechanic = true;
    }
}

function onDadHit() {
    FlxG.camera.shake(curShakeIntensity, 0.5);
    gumballCamera.shake(curShakeIntensity, 0.5);
}

function onPlayerHit() {

    // "showComboNum.text != Std.string(combo)" is needed in case this is repeated with sustain notes or multiple notes at the same time
    if (combo > 0 && combo % 50 == 0 && showComboNum.text != Std.string(combo)) {
        var globosNum = FlxG.random.int(10, 20);
        for (i in 0...globosNum) {
            globos[i].setPosition(FlxG.random.int(300, 2300), 1100);
            globos[i].velocity.x = FlxG.random.int(-200, 200);
            globos[i].velocity.y = FlxG.random.int(-150, -350);
        }

        showComboNum.text = combo;
        showComboNum.x = -showComboNum.width;
        showComboTxt.x = -showComboTxt.width;
        FlxTween.tween(showComboNum, { x: (FlxG.width - showComboNum.width) / 2 - 20 }, 0.5, { ease: FlxEase.quadOut,  onComplete: (_) -> {
            moveComboNum = true;
            new FlxTimer().start(2.5, (_) -> {
                moveComboNum = false;
                FlxTween.tween(showComboNum, { x: FlxG.width }, 0.5, { ease: FlxEase.quadIn });
            });
        }});

        FlxTween.tween(showComboTxt, { x: (FlxG.width - showComboTxt.width) / 2 - 14 }, 0.5, { startDelay: 0.3, ease: FlxEase.quadOut, onComplete: (_) -> {
            moveComboText = true;
            new FlxTimer().start(2, (_) -> {
                moveComboText = false;
                FlxTween.tween(showComboTxt, { x: FlxG.width }, 0.5, { ease: FlxEase.quadIn });
            });
        }});
    }
}

function onCameraMove()
{
    if (desactivateZoom_A) return;
    if(curCameraTarget == 0) defaultCamZoom = 0.8;
    else defaultCamZoom = 0.65;
}

function onGameOver() {
    GameOverSubstate.script = 'data/substates/GameOverSubstate-clown';
    gumballCamera._filters = FlxG.camera._filters = [];
}