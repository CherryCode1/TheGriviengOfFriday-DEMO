import funkin.backend.util.CoolUtil;

var fragie:FlxSprite;
var _hide:Bool = true;
var fragieOnCooldown:Bool = false;
var stepCooldown:Int = 60; 
var lastFragieStep:Int = -stepCooldown; 
var randomTimeAparition:Int;
var fragieAlreadyAppeared:Bool = false;

function postCreate() {
    strumLines.members[0].characters[1].color = CoolUtil.getColorFromDynamic('#08080a');
    iconP2.color = CoolUtil.getColorFromDynamic('#000000');


    var rightColor:Int = boyfriend != null && boyfriend.visible && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : 0xFF000000;
    healthBar.createFilledBar(FlxColor.BLACK,rightColor);
    healthBar.updateBar();

    angleCamera = false;

    fragie = new FlxSprite(-150,600);
    fragie.frames = Paths.getSparrowAtlas("stages/alley/Fragie");
    fragie.animation.addByPrefix("Idle","Idle",24,true);
    fragie.animation.addByPrefix("aparition","aparition",24,false);
    fragie.animation.addByPrefix("desaparece","desaparece",24,false);
    fragie.camera = camOverlay;
    add(fragie);

    fragie.visible = false;
    randomTimeAparition = FlxG.random.int(600,1000);
}

function fragieEvent(hide:Bool) {
    trace("fragie hide:" + hide);
    fragie.offset.set(FlxG.random.int(-150,-200),350);
    fragie.animation.play(hide ? "desaparece" : "aparition");
    fragie.visible = true;

    fragie.animation.finishCallback = function(name:String) {
            switch(name){
                case "desaparece": fragie.visible = false;
                case "aparition":  fragie.animation.play("Idle");
                fragie.offset.set(-165,290);

            }
    }
}

public static function changeGf(){
    var gfOld = strumLines.members[2].characters[2];
   

    var newCharacter = new Character(gfOld.x, gfOld.y, "gf-enigma", false);
    newCharacter.active = newCharacter.visible = true;
    newCharacter.drawComplex(FlxG.camera); 
    newCharacter.playAnim(gfOld.animation.name);
    newCharacter.animation?.curAnim?.curFrame = gfOld.animation?.curAnim?.curFrame;    
    insert(members.indexOf(gfOld), newCharacter);
    remove(gfOld);

    strumLines.members[2].characters[2] = newCharacter;



    var shadowgfOld = strumLines.members[2].characters[1];
  
    var newCharacter = new Character(shadowgfOld.x, shadowgfOld.y, "gf-enigma", false);
    newCharacter.active = newCharacter.visible = true;
    newCharacter.drawComplex(FlxG.camera); 
    newCharacter.playAnim(shadowgfOld.animation.name);
    newCharacter.animation?.curAnim?.curFrame = shadowgfOld.animation?.curAnim?.curFrame; 
    newCharacter.scale.y -= 0.05;
    newCharacter.alpha = 0.35;
    newCharacter.color = FlxColor.fromRGB(161, 170, 199);   
    insert(members.indexOf(shadowgfOld), newCharacter);
    newCharacter.angle = 180;
    newCharacter.flipX = true;


    remove(shadowgfOld);

    strumLines.members[2].characters[1] = newCharacter;
}

public static function showShits(){
    healthBar.visible = true;
    healthBarBG.visible = true;
    strumLines.members[0].characters[0].color = CoolUtil.getColorFromDynamic('#FFFFFF');
    strumLines.members[0].characters[1].color = FlxColor.fromRGB(161, 170, 199);
    iconP2.color = CoolUtil.getColorFromDynamic('#FFFFFF');

    var leftColor:Int = dad != null && dad.visible && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : 0xFF000000;
    var rightColor:Int = boyfriend != null && boyfriend.visible && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : 0xFF000000;
    healthBar.createFilledBar(leftColor, rightColor);
    healthBar.updateBar();

}

function stepHit() {
  
    if (!fragieAlreadyAppeared && curStep > randomTimeAparition && curStep % 20 == 0) {
        if (FlxG.random.bool(35)) {
            fragieAlreadyAppeared = true;
            fragieEvent(false); 

            new FlxTimer().start(20, function(_) {
                fragieEvent(true);
            });
        }
    }

    if (curStep >= 1039) {
        comboGroup.cameras = [camHUD];
        comboGroup.screenCenter();
        comboGroup.x -= 100;
        comboGroup.y += 100;
        boyfriend.cameraOffset.set(600, 1000);
    }
}