import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;


var camGame:FlxCamera;
var logo_title:FlxSprite;
var background:FlxBackdrop;
var backgroundVig:FlxSprite;
var enterText:FlxText;
static var started:Bool = false;
var pressedEnter:Bool = false;

final colorVars = [
    FlxColor.fromString('#398bb8'),
    FlxColor.WHITE
];

var grieveSh:CustomShader = new CustomShader("grieveShader");

function create() {

    changePrefix("Title Menu");

    FlxG.mouse.visible = true;
    grieveSh.grade_intensity = .3;
    grieveSh.vignette_intensity = 0.3;
    grieveSh.line_intensity = 0.;
    grieveSh.wobble_intensity = 0.;

    if (FlxG.save.data.GriviengShader) FlxG.camera.addShader(grieveSh);

    if(!startedMenuMusic){
        startedMenuMusic = true;
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
        FlxG.sound.music.fadeIn(4, 0, 0.7);
		FlxG.sound.music.play();
    }

    background = new FlxBackdrop(Paths.image('menus/title/bgTitle'), FlxAxes.X,FlxG.width,FlxG.height);
    background.setGraphicSize(background.width * 1.5);
    background.updateHitbox();
    background.velocity.set(-10);
    background.screenCenter(FlxAxes.Y);
    add(background);

    logo_title = new FlxSprite();
    logo_title.frames = Paths.getSparrowAtlas('menus/title/log');
    logo_title.animation.addByPrefix('_', 'estatic', 24);
    logo_title.animation.play('_', true);
    logo_title.setGraphicSize(Std.int(logo_title.width * 0.25));
    logo_title.updateHitbox();
    logo_title.screenCenter().y -= 25;
    add(logo_title);

    enterText = new FlxText();
    enterText.setFormat(Paths.font('Gumball.ttf'), 60, colorVars[0], FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    enterText.borderSize = 2;
    enterText.text = 'Press Enter To Begin';
    enterText.updateHitbox();
    enterText.screenCenter().y += 175;
    enterText.x -= 25;
    add(enterText);

    var vig:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/title/bgTitleVig"));
    vig.setGraphicSize(vig.width * 1.5);
    vig.screenCenter();
    add(vig);

    if (started){
        logo_title.y += 1000;
        FlxTween.tween(logo_title,{y: logo_title.y - 1000},0.55,{ease:FlxEase.backInOut});
    }
}

var tiempito:Float = 0;
function update(elapsed:Float) {

    tiempito += elapsed;
    grieveSh.iTime = tiempito;
    if (!pressedEnter && (FlxG.mouse.justPressed || FlxG.keys.justPressed.ANY))
    {
        FlxG.camera.stopFade();
        pressedEnter = true;
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        FlxTween.tween(logo_title,{y: logo_title.y + 1000},0.75,{ease:FlxEase.quadInOut});
        FlxTween.tween(FlxG.camera,{zoom: 1.2},0.9,{ease: FlxEase.backInOut});
        FlxTween.tween(enterText,{alpha: 0},0.8);
        FlxG.camera.fade(FlxColor.BLACK,1);
        new FlxTimer().start(1.1, func -> FlxG.switchState(new MainMenuState()));
        started = true;
    }

    if (pressedEnter) enterText.color = colorVars[FlxG.random.int(0, 1)]; // im lazy mb gang
}