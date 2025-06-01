import haxe.format.JsonParser;
import flixel.math.FlxPoint;
import flixel.text.FlxTextAlign;
import flixel.util.FlxAxes;
import flixel.text.FlxTextBorderStyle;

/**
 * 0 - rol
 * 1 - imagen
 * 2 - nombre y eso
 * 3 - quote
 * 4 - link de twitter
 * 5 - link de youtube
 * 6 - X de la imagen por que la sociedad es mierda
 * 7 - la X pero con Y
 * 8 - tamaño de la imagen
 * 9 - por si alguien se le ocurre hacer una quote larga
 */

var devs:Array<Dynamic> = [];

public static var creditArray:Array<Dynamic>;
var curSelected:Int = 0;
var bg:FlxSprite;
var exitB:FlxSprite;
var creditIconSprite:FlxSprite;
var creditDescText:FlxText;
var creditRolText:FlxText;
var creditNameText:FlxText;
var path:String;
var daJson:String = null;
var creditThing:CreditStuff;
var camHUD:FlxCamera;

function create(){
    changePrefix("Credits");

    //

	creditThing = jsonStuff();
	creditArray = creditThing.devs;
    // 

    camHUD = new FlxCamera();
	camHUD.bgColor = 0x00000000;
	FlxG.cameras.add(camHUD, false);

    FlxG.mouse.visible = true;

    bg = new FlxSprite(-650, -400).loadGraphic(Paths.image('menus/credits/bg'));
    bg.setGraphicSize(Std.int(bg.width * 0.6));
    bg.updateHitbox();
	bg.scrollFactor.set(.6, 1.2);
	bg.screenCenter();
    add(bg);


    exitB = new FlxSprite(30, 30).loadGraphic(Paths.image('menus/credits/ExitButton'));
    exitB.setGraphicSize(Std.int(exitB.width * 0.4));
    exitB.scrollFactor.set(0.9, 0.9);
    exitB.updateHitbox();
    exitB.cameras = [camHUD]; 
    add(exitB);

    var boardd = new FlxSprite(-270, -130).loadGraphic(Paths.image('menus/credits/board'));
    boardd.scrollFactor.set(0.8, 0.8);
    boardd.updateHitbox();
    boardd.screenCenter();
    add(boardd);

    creditDescText = new FlxText(0, FlxG.height * 0.6, 500, creditArray[curSelected][3]);
    creditDescText.setFormat(Paths.font('CascadiaMonoPL-Bold.otf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    creditDescText.borderSize = 0;
    //creditDescText.cameras = [camHUD];
    add(creditDescText);

    creditRolText = new FlxText(-300, FlxG.height * 0.28, FlxG.width, creditArray[curSelected][0]);
    creditRolText.setFormat(Paths.font('Gumball.ttf'), 70, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    creditRolText.borderSize = 0;
   // creditRolText.cameras = [camHUD];
    add(creditRolText);

    creditNameText = new FlxText(90, FlxG.height * 0.41, 500, creditArray[curSelected][2]);
    creditNameText.setFormat(Paths.font('CascadiaMonoPL-Bold.otf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    creditNameText.borderSize = 0;
  //  creditNameText.cameras = [camHUD];
    add(creditNameText);

    creditIconSprite = new FlxSprite(creditArray[curSelected][6],
        creditArray[curSelected][7]).loadGraphic(Paths.image('menus/credits/portraits/' + creditArray[curSelected][1]));
    creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditArray[curSelected][6]));
    creditIconSprite.scrollFactor.set(0.8, 0.8);
    add(creditIconSprite);
    
    var gradient = new FlxSprite(-270, -130).loadGraphic(Paths.image('menus/credits/gradient'));
    gradient.setGraphicSize(1280, 720);
    gradient.updateHitbox();
    gradient.cameras = [camHUD];
    gradient.screenCenter();
    add(gradient);

    
    changeSelection();    
}

function jsonStuff() {
	daJson = Assets.getBytes(Paths.json('info/credits'));
	if (daJson != null && daJson.length > 0)
		return JsonParser.parse(daJson);

	return null;
}

var holdTime:Float = 0;

function update(elapsed:Float) {
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX-(FlxG.width/2)) * 0.015, (1/30)*240*elapsed); //mario madres
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY-6-(FlxG.height/2)) * 0.015, (1/30)*240*elapsed);
  
    
    if (FlxG.mouse.overlaps(exitB)) {
        exitB.scale.set(
            FlxMath.lerp(exitB.scale.x,0.42,0.1),
            FlxMath.lerp(exitB.scale.y,0.42,0.1)
           );
    }else{
        exitB.scale.set(
            FlxMath.lerp(exitB.scale.x,0.4,0.1),
            FlxMath.lerp(exitB.scale.y,0.4,0.1)
           );
    }
    if (controls.UP_P)
	{
		changeSelection(-1);
		holdTime = 0;
	}
	else if (controls.DOWN_P)
	{
		changeSelection(1);
		holdTime = 0;
	}

	if(controls.DOWN || controls.UP)
	{
		var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
		holdTime += elapsed;
		var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

		if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
		{
			changeSelection((checkNewHold - checkLastHold));
			
		}
	}


    if(FlxG.mouse.wheel != 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
		changeSelection(FlxG.mouse.wheel);
	}

    if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(exitB)) {
        FlxG.switchState(new MainMenuState());
    }
    if (controls.BACK)
	{
        FlxG.switchState(new MainMenuState());
	}
}


var currentIndex:Int = 0;
function changeSelection(newSelect:Int = 0)
{
    curSelected = FlxMath.wrap(curSelected + newSelect, 0, creditArray.length - 1);
	
	creditRolText.text = creditArray[curSelected][0] != null ? creditArray[curSelected][0] : 'unknown';
	creditDescText.text = creditArray[curSelected][3] != null ? creditArray[curSelected][3] : 'unknown';
	creditNameText.text = creditArray[curSelected][2] != null ? creditArray[curSelected][2] : 'has not worked';
	creditIconSprite.loadGraphic(Paths.image('menus/credits/portraits/'+creditArray[curSelected][1]));
	creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditArray[curSelected][8]));
	creditIconSprite.setPosition(creditArray[curSelected][6], creditArray[curSelected][7]);

	FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);

	reloadText(creditArray[curSelected][9]);

}

function reloadText(long)
{
	if (long)
	{
		creditRolText.y = FlxG.height * 0.1;
        creditNameText.y = FlxG.height * 0.21;
        creditDescText.fieldWidth = 1000;
        creditDescText.x = 70;
        creditDescText.y = FlxG.height * 0.16;
        creditDescText.scale.set(0.6, 0.6);
	}
	else
	{
		creditDescText.fieldWidth = 500;
        creditDescText.x = 90;
        creditDescText.y = FlxG.height * 0.6;
        creditDescText.scale.set(1, 1);
        creditRolText.y = FlxG.height * 0.28;
        creditNameText.y = FlxG.height * 0.39;
    }
}