var songCard = new FlxSprite();
var barCam:FlxCamera;

function postCreate(){
    barCam = new FlxCamera();
    barCam.bgColor = 0x0;

    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(barCam, false);
    FlxG.cameras.add(camHUD, false);

    camFollowChars = false;
    camFollow.setPosition(1100,-200);

    dad.cameraOffset.x += 100;

    songCard.frames = Paths.getSparrowAtlas("songsIntro/13Years");
    songCard.animation.addByPrefix("anim","songCardLoop",24,false);
    songCard.screenCenter();
    songCard.camera = camHUD;
    songCard.scale.set(0.6,0.6);
    add(songCard);

    for(i in [upperBar, lowerBar])
      i.cameras = [barCam];
    
    GameOverSubstate.script = "data/substates/GameOverSubstate-years";
}

function onStartSong(){
      
    FlxTween.tween(camFollow,{x:500,y:300},4,{ease:FlxEase.quadInOut,onComplete: function(){camFollowChars = true;}});
}
function stepHit(){
   switch(curStep){
     case 20: songCard.animation.play("anim");
     case 50: FlxTween.tween(songCard,{alpha:0, "scale.x": 0,"scale.y": 0},1,{ease:FlxEase.quadInOut});
   }
}