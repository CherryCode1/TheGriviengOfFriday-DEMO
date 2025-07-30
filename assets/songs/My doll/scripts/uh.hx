import flixel.math.FlxBasePoint;

var intro_BG:FlxSprite;
var intro_logo:FlxSprite;
var blackie:FlxSprite;

function create() {
    blackie = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	blackie.scrollFactor.set();
	blackie.cameras = [camHUD];
	blackie.alpha = 0;
	add(blackie);

    showNotesStart = false;
    barrVisible = false;
    dispHudInStart = false;
    healthBarDefault = true;
}

function postCreate() {
   
    camFollowChars = false;
    camFollow.x = 350;
    camFollow.y = 200;

   
    for (background in   bg_sprites_P)
     background.visible = true;

    countDown = "pibby";
   
    intro_BG = new FlxSprite();
    intro_BG.frames = Paths.getSparrowAtlas("daSTAT");
    intro_BG.animation.addByPrefix("idle","staticFLASH",24,true);
    intro_BG.animation.play("idle");
    intro_BG.camera = camHUD;
    intro_BG.setGraphicSize(FlxG.width * 1.01);
    intro_BG.screenCenter();
    add(intro_BG);


    intro_logo = new FlxSprite();
    intro_logo.frames = Paths.getSparrowAtlas("songsintro/myDoll");
    intro_logo.animation.addByPrefix("idle","myDollLoop",24,true);
    intro_logo.animation.play("idle");
    intro_logo.camera = camHUD;
    intro_logo.screenCenter();
    intro_logo.alpha = 0;
    add(intro_logo);

}  
function onSongStart() {
    FlxTween.tween(intro_logo, {alpha:1},1,{onComplete:function(){
     FlxTween.tween(intro_logo.scale,{x:1.2,y:1.2},4,{ease:FlxEase.sineInOut,onComplete:function(){
      
        FlxTween.tween(intro_BG, {alpha:0},1,{onComplete:function(){
            remove(intro_BG);
            FlxTween.tween(intro_logo, {alpha:0},1,{onComplete:function(){
                remove(intro_logo);

            }});
        }});
        FlxTween.tween(FlxG.camera,{zoom:0.55},5,{ease: FlxEase.quadInOut});
        FlxTween.tween(camFollow,{x:350,y:600},5,{ease:FlxEase.cubeInOut,onComplete:function(){camFollowChars = true;}});  
     }});
    }});
 
    FlxG.camera.zoom = defaultCamZoom = 1.1;
   
}
function stepHit(){
    switch(curStep){
        case 118:
           
            setWarpCroma("2.0");
        case 260: //255
        for (strums in cpuStrums) 
            strums.shader = distortShader_2;
         
        case 308:   setWarpCroma("1.0");
        case 396:   setWarpCroma("2.0");
       // case 830:setCamZoom(-1, false); ???
        case 384:
            blackie.alpha = 0.6;
        case 472:
            FlxTween.tween(blackie, {alpha: 0}, 0.8, {ease: FlxEase.quartInOut});   
        case 1151:  
            for (stage in bg_sprites_P) {
                FlxTween.color(stage, 1.0, stage.color, FlxColor.BLACK);
            }
            for (colorsChars in [boyfriend,dad,gf]) {
                colorsChars.shader = null;
                FlxTween.tween(colorsChars,{
                "colorTransform.redOffset": 255,
                "colorTransform.greenOffset": 255,
                "colorTransform.blueOffset": 255,
                "colorTransform.alphaOffset": 1,

                "colorTransform.redMultiplier": 255,
                "colorTransform.greenMultiplier": 255,
                "colorTransform.blueMultiplier": 255,
                "colorTransform.alphaMultiplier": 1
                },1);
            }
        case 1408:
            for (stage in bg_sprites_P) {
                stage.color = FlxColor.WHITE;
            }

            for (colorsChars in [boyfriend,dad,gf]) {
                colorsChars.colorTransform = null;
            }

            camGame.alpha = 0;
        case 1424:
            camGame.alpha = 1;   
        case 2448:
            camGame.alpha = 0;
        case 2464:
            camGame.alpha = 1;    
        case 2720:
            camGame.alpha = 0;
        case 2736:
            camGame.alpha = 1;      
        case 2984:
            camGame.alpha = 0;
        case 2992:
            camGame.alpha = 1;    
        case 3634:
            camGame.alpha = 0; 
    }
}
function onDadHit(event){
    if (health > 0.1)
       health -= 0.025;
}
function postUpdate(elapsed:Float){
    if (curStep >895){
        for (i in [0,1,2,3]){
         
            var currentBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm/60) * 2;
          

            if (defaultOpponentStrum != null){
                var strumOpp = strumLines.members[0];
                strumOpp.members[i].x = defaultOpponentStrum[i].x + 8 * Math.sin(currentBeat + i);
                strumOpp.members[i].y = defaultOpponentStrum[i].y +  4 * Math.sin(currentBeat + i);
                
            }
          
           if (defaultPlayerStrum != null){
            var strumPlayer = strumLines.members[1];
            strumPlayer.members[i].x = defaultPlayerStrum[i].x + 8 * Math.sin(currentBeat + i);
            strumPlayer.members[i].y = defaultPlayerStrum[i].y+  4 * Math.sin(currentBeat + i);

           }
         
           
        }
    }
   
}