var penny:FlxSprite;
var parents_gumball:FlxSprite;

function create() 
{
  camGame._fxFadeColor = FlxColor.BLACK;
  camGame._fxFadeAlpha = 1;
  dispHudInStart = false;
}
var sprites:Array<FlxSprite> = [];
function postCreate()
{
    camGame.zoom = defaultCamZoom = 1.1;

    var shit:Int = -1;
    var arrayPath:Array<String> = ["stages/class/denial/penny_","stages/class/denial/nicole_and_richard"];
   
    for (items in [penny,parents_gumball])
    {
        shit ++;

        items = new FlxSprite(-150,0).loadGraphic(Paths.image(arrayPath[shit]));
        items.scrollFactor.set(1.1,1);
        items.scale.set(0.8,0.8);
        items.alpha = 0;
        add(items);
        sprites.push(items);
    }
   
}

public static function showSprite(numer:String) {
    var sprite = (numer == "0") ? sprites[0] : sprites[1];
    FlxTween.tween(sprite,{alpha: 1},1);
}

public static function fadeSprite(numer:String) {
    var sprite = (numer == "0") ? sprites[0] : sprites[1];
    FlxTween.tween(sprite,{alpha: 0},1);
}

function postUpdate(elapsed:Float){
    if (strumLines.members[0] != null && songStarted){
        for (i in [0,1,2,3]){
            strumLines.members[0].members[i].setPosition(
                defaultOpponentStrum[i].x + FlxG.random.float(-1,1),defaultOpponentStrum[i].y + FlxG.random.float(-1,1)
            );
        }
    }
}