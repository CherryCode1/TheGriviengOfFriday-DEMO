var image:FlxSprite;
var iconDarwin:HealthIcon;
function create() {
    FlxG.camera.bgColor = FlxColor.WHITE;

    noteSkin = "default";
    splashSkin = "default";  
    countDown = "13years";
    countDownFNF = false;
}

function postCreate(){
    iconDarwin = new HealthIcon(gf.getIcon(),false);
    iconDarwin.camera = camHUD;
    iconDarwin.visible = false;
    insert(members.indexOf(iconP2),iconDarwin);


    image = new FlxSprite().loadGraphic(Paths.image("caca"));
    image.screenCenter();
    image.camera = camOverlay;
    image.visible = false;
    image.scale.set(1.1,1.1);
    add(image);

    boyfriend.x += 700;
    boyfriend.y += 90;

    gf.x -=5;
    gf.cameraOffset.x += 550;
    gf.y += 8;

    dad.cameraOffset.x += 200;
    iconP1.flipX = true;

    if (strumLines.members[2].characters[0] != null){
        var girl = strumLines.members[3].characters[0];
        girl.x += 950;
   
        girl.beatInterval = 2;
  
    }
    
    comboGroup.x += 1300;
}
function onNoteHit(event){
    if (event.note.isSustainNote) return;
   
    if (!event.animCancelled){
        for(char in event.characters){
            if (char == gf){
                iconDarwin.scale.set(1.2,1.2);

                iconDarwin.visible = true;
                iconP2.visible = false;
                healthBar.createFilledBar(gf.iconColor, boyfriend.iconColor);
                healthBar.updateBar();
            }
            if (char == dad){
                iconDarwin.visible = false;
                iconP2.visible = true;
                healthBar.createFilledBar(dad.iconColor, boyfriend.iconColor);
                healthBar.updateBar();
            }
        }
    }
}
function stepHit(){
    if (curStep == 20){
        var strumDarwing = strumLines.members[2];
        strumDarwing.visible = true;
      
        for (i in [0,1,2,3]) strumDarwing.members[i].alpha = 0.0;
        for (uh in strumDarwing.notes) uh.alpha = 0.6;
    }
    if (curStep == 196) image.visible = true;
    if (curStep == 198) FlxTween.tween(image,{alpha:0},0.65);
}

function onDadHit(event){
	if (event.isSustainNote) return;
	if (health > 0.1) health -= 0.014;
}

function postUpdate(elapsed:Float){
    iconDarwin.scale.set(
       lerp(iconDarwin.scale.x,1,0.1),
       lerp(iconDarwin.scale.y,1,0.1)
    );
    iconDarwin.x = iconP2.x;
    iconDarwin.health = iconP2.health;
    iconDarwin.y = iconP2.y;
	iconDarwin.alpha = iconP2.alpha;

    if (curStep > 127){
		if (curStep % 4 == 0) FlxTween.tween(camHUD, {y: -15}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
		if (curStep % 4 == 2) FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
    }
}
function onCameraMove() {
	if(curCameraTarget == 2)
		defaultCamZoom = 0.9;
	else
		defaultCamZoom = 0.7;
}