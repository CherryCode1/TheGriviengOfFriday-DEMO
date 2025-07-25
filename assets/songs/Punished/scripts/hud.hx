import flixel.math.FlxRect;

var healthBar_1:FlxSprite;
var healthBar_2:FlxSprite;
var barOffset:Array<Float> = [3, 3];

function postCreate() {
  healthBarBG.visible = false;
  healthBar.visible = false;

  healthBar_1 = new FlxSprite(250,600).loadGraphic(Paths.image("healthBars/Punished2"));
  healthBar_1.camera = camHUD;
  healthBar_1.scale.set(0.8,0.8);
  insert(members.indexOf(healthBar),healthBar_1);

  healthBar_2 = new FlxSprite(250,600).loadGraphic(Paths.image("healthBars/Punished"));
  healthBar_2.camera = camHUD;
   healthBar_2.scale.set(0.8,0.8);
 insert(members.indexOf(healthBar),healthBar_2);


  healthBar_1.clipRect = new FlxRect(0, 3, healthBar_1.width, healthBar_1.height);
  healthBar_2.clipRect = new FlxRect(0, 3, healthBar_2.width, healthBar_2.height);
}

function postUpdate(elapsed:Float) { 
    updateValueBars();
}

function updateValueBars() {
    for(items in [healthBar_1,healthBar_2]) 
		items.alpha = healthBar.alpha;

    var leftBarWidth = healthBar_1.width;
    var rightBarWidth = healthBar_2.width;
    var barHeight = healthBar_2.height;
    var percent_ = health * 50; 


    var leftSize:Float = FlxMath.lerp(0, leftBarWidth, 1 - percent_ / 100);
    var rightSize:Float = rightBarWidth - leftSize;

    healthBar_1.clipRect.set(barOffset[0], barOffset[1], leftSize, barHeight);
    healthBar_2.clipRect.set(barOffset[0] + leftSize, barOffset[1], rightSize, barHeight);

    healthBar_1.clipRect = healthBar_1.clipRect;
    healthBar_2.clipRect = healthBar_2.clipRect;
}