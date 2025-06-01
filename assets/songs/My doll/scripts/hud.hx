import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var barr:FlxSprite;
var barrBG:FlxSprite;
var barrBG_1:FlxSprite;

var _iconP1:FlxSprite;
var _iconP2:FlxSprite;
var logo:FlxSprite;

function postCreate() {
 remove(healthBarBG);
 remove(iconP1);
 remove(iconP2);

 healthBar.visible  = false;

 barr = new FlxSprite();
 barr.loadGraphic(Paths.image("healthBars/pibbyHealthbar2"));
 barr.camera = camHUD;
 insert(members.indexOf(healthBar),barr);

 barr.color = boyfriend.iconColor;
 barr.x = healthBar.x-40;
 barr.y = healthBar.y-25- 40;


 barrBG_1 = new FlxSprite();
 barrBG_1.frames = Paths.getSparrowAtlas("healthBars/Glitch_Health_Bar");
 barrBG_1.animation.addByPrefix("idle","Glitch",24,true);
 barrBG_1.animation.play("idle");
 barrBG_1.camera = camHUD;
 insert(members.indexOf(healthBar),barrBG_1);

 barrBG_1.x = healthBar.x-30;
 barrBG_1.y = healthBar.y- 40;


 barrBG = new FlxSprite();
 barrBG.loadGraphic(Paths.image("healthBars/pibbyHealthbar"));
 barrBG.camera = camHUD;
 insert(members.indexOf(healthBar),barrBG);
 barrBG.color = boyfriend.iconColor;
 barrBG.x = healthBar.x-40;
 barrBG.y = healthBar.y-25 - 40;


 if (get_downscroll()){
    barr.y -= 20;
    barrBG.y -= 20;
 }

 _iconP1 = new FlxSprite(0,540);
 _iconP1.frames = Paths.getSparrowAtlas("icons/pibby/icon-pibby");
 _iconP1.animation.addByPrefix("_lose","Lose Icon instancia 1",24,false);
 _iconP1.animation.addByPrefix("normal","Normal Icon instancia 1",24,false);
 _iconP1.scale.set(0.65,0.65);
 _iconP1.camera = camHUD;
 insert(members.indexOf(healthBar),_iconP1);

 _iconP2 = new FlxSprite(0,540);
 _iconP2.frames = Paths.getSparrowAtlas("icons/pibby/icon-pibbygumball");
 _iconP2.animation.addByPrefix("_lose","Lose Icon instancia 1",24,false);
 _iconP2.animation.addByPrefix("normal","Normal Icon instancia 1",24,false);
 _iconP2.scale.set(0.65,0.65);
 _iconP2.camera = camHUD;
 insert(members.indexOf(healthBar),_iconP2);


 logo = new FlxSprite(25,350).loadGraphic(Paths.image("logos/adultswim"));
 logo.alpha = 0.3;
 logo.scale.set(0.2,0.2);
 logo.camera = camHUD;
 add(logo);
}
function postUpdate(elapsed:Float){
  
    var scaleValue = FlxMath.bound(2 - health, 0.1, 1.75);
    barrBG_1.scale.x = scaleValue;

    barrBG_1.origin.set(0, 0);
    barrBG_1.x = barrBG.x + barrBG.width / 2 - 308;

   
    setPosIcons();
   
    if (health > 0.3)_iconP1.animation.play("normal");
    else _iconP1.animation.play("_lose");
    
    if(health < 1.3){
        _iconP2.animation.play("normal");
        _iconP2.angle = FlxMath.lerp(_iconP2.angle, FlxG.random.float(-8.0,8.0),0.5);
    } 
    else {
        _iconP2.animation.play("_lose");
        _iconP2.angle = FlxG.random.float(-8.0,8.0);
    } 
       
     
   
    for (items in [barr,barrBG,barrBG_1,_iconP1,_iconP2])
        items.alpha = healthBar.alpha;
}
function setPosIcons(){

    var iconOffset:Int = 26;
    var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0);

    _iconP1.x = center - iconOffset;
    _iconP2.x = center - (_iconP2.width - iconOffset);
}