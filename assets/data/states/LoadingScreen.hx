import funkin.options.OptionsMenu;

var blackScreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("LOADING_SCREEN"));
var barr:FlxSprite = new FlxSprite(0,700).makeGraphic(800,10,FlxColor.fromRGB(196, 18, 140));

function create() {
    blackScreen.screenCenter();
    add(blackScreen);
 
    bg.scale.set(0.5,0.5);
    bg.screenCenter();
    add(bg);
 
 
    barr.screenCenter(FlxAxes.X); 
    add(barr);
 
    new FlxTimer().start(1, loading);
}

function loading()
{
    FlxTween.tween(bg,{alpha:0},0.6);
    barr.scale.x = 1;
    FlxTween.tween(barr,{"scale.x":0,"alpha":0},0.5,{ease:FlxEase.cubeOut});
        
    new FlxTimer().start(0.65, ()-> {nextState();});
}
function nextState() {
    switch(_nextState_loading)
    {
        case ModState:
            FlxG.switchState(new ModState("videoState"));
        case OptionsMenu:
            FlxG.switchState(new _nextState_loading());
            _nextState_loading = MainMenuState; //fix de pacotilla pero hace su trabajo igual
        default:
            FlxG.switchState(new _nextState_loading());
    }
}