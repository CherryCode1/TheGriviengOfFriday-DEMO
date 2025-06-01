public var bg:FlxSprite;
public var stairs:FlxSprite;
public var blueness:FlxSprite;

public static var grieveSh:CustomShader = new CustomShader("grieveShader");
var sombra:FlxSprite;

var items_:Array<FlxSprite> = [];
var class_bg:Array<FlxSprite> = [];
var denial_bg:Array<FlxSprite> = [];
var baseStage:FlxSprite;
var ghost_darwin:FlxSprite;
var ghost_anais:FlxSprite;

public var wobble_intensity = 0.;
public var grade_intensity = 0.2;
public var line_intensity = 0.;
public var vignette_intensity = 0.2;
public var logo:FlxSprite;
function create(){
    camGame.addShader(grieveSh);
    camHUD.addShader(grieveSh);

    noteSkin = "NOTE_assetsGUMBALL";
	splashSkin = "default-griv";

    bg = new FlxSprite(-200, 50).loadGraphic(Paths.image('stages/class/classroom'));
    bg.scale.set(0.75, 0.75);
    bg.updateHitbox();
    insert(0, bg);
    class_bg.push(bg);

    stairs = new FlxSprite(-300, 200).loadGraphic(Paths.image('stages/class/stair_class'));
    stairs.scale.set(0.8, 0.8);
    stairs.scrollFactor.set(1.2, 1.2);
    stairs.updateHitbox();
    add(stairs);
    class_bg.push(stairs);

    blueness = new FlxSprite(-400, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000221);
    blueness.cameras = [camGame];
    blueness.blend = 9;
    blueness.alpha = 0.2;
    blueness.scrollFactor(0, 0);
    blueness.updateHitbox();
    add(blueness);
    class_bg.push(blueness);

    if (PlayState.SONG.meta.name == "My Amazing Sadness" || PlayState.SONG.meta.name == "my amazing sadness"){
        ghost_anais = new FlxSprite(dad.x + 250,dad.y+ 350);
        ghost_anais.frames = Paths.getSparrowAtlas("stages/class/anais");
        ghost_anais.animation.addByPrefix("idle","Idle",24,true);
        ghost_anais.animation.play("idle");
        ghost_anais.antialiasing = false;
        insert(members.indexOf(dad),ghost_anais);
    
        ghost_anais.alpha = 0.85;
        FlxTween.tween(ghost_anais,{x: ghost_anais.x - 35,},Conductor.stepCrochet/1000 * 30,{ease:FlxEase.sineInOut,type:FlxTween.PINGPONG});
        FlxTween.tween(ghost_anais,{y: ghost_anais.y + 40},Conductor.stepCrochet/1000 * 35,{ease:FlxEase.sineInOut,type:FlxTween.PINGPONG});
    
        ghost_darwin = new FlxSprite(dad.x - 200,dad.y+ 450);
        ghost_darwin.frames = Paths.getSparrowAtlas("stages/class/darwin");
        ghost_darwin.animation.addByPrefix("idle","Idle",24,true);
        ghost_darwin.animation.play("idle");
        ghost_darwin.antialiasing = false;
        insert(members.indexOf(dad) + 1,ghost_darwin);
        ghost_darwin.alpha = 0.85;
        FlxTween.tween(ghost_darwin,{x: ghost_darwin.x + 45,},Conductor.stepCrochet/1000 * 30,{ease:FlxEase.sineInOut,type:FlxTween.PINGPONG});
        FlxTween.tween(ghost_darwin,{y: ghost_darwin.y + 50},Conductor.stepCrochet/1000 * 35,{ease:FlxEase.sineInOut,type:FlxTween.PINGPONG});
    
        ghost_darwin.visible = ghost_anais.visible = false; 
    }

   
    comboGroup.setPosition(1300,600);
    gf.x += 250;
    gf.y += 250;

    dad.y += 400;

    boyfriend.x += 100;
    boyfriend.y += 350;

    boyfriend.cameraOffset.set(-50, 0);
    dad.cameraOffset.set(0, 50);   


    logo = new FlxSprite(750,350).loadGraphic(Paths.image("logos/cartoon"));
    logo.camera = camOverlay;
    logo.scale.set(0.325,0.325);
    logo.alpha = 0.5;
    add(logo);
    
    GameOverSubstate.script = "data/substates/GameOverSubstate-gumball";
}
function onPostGameOver(){
	persistentDraw = true;
	removeGameAssets();
}
function removeGameAssets(){
	boyfriend.visible = false;
	stairs.visible = false;
	FlxTween.tween(camHUD,{alpha:0},0.25);
	FlxTween.tween(camOverlay,{alpha:0},0.25);
}
var gumball_suelo:FlxSprite;
function postCreate()
{
    if (PlayState.SONG.meta.name == "Denial" || PlayState.SONG.meta.name == "denial") {

        gumball_suelo = new FlxSprite(dad.x,dad.y-20).loadGraphic(Paths.image("stages/class/gumball_pose"));
        gumball_suelo.visible = false;
        gumball_suelo.scale.set(0.9,0.9);
        insert(members.indexOf(dad) + 1, gumball_suelo);

        var shit:String = "stages/class/denial/";

        var arbusto:FlxSprite = new FlxSprite(-100,200);
        arbusto.frames = Paths.getSparrowAtlas(shit + "Arbustos");
        arbusto.animation.addByPrefix("idle","Arbustos",24,true);
        arbusto.animation.play("idle");
        arbusto.scrollFactor.set(0.5,1);
        insert(members.indexOf(dad),arbusto);
        denial_bg.push(arbusto);


        var Caja:FlxSprite = new FlxSprite(600,470);
        Caja.frames = Paths.getSparrowAtlas(shit + "Caja");
        Caja.animation.addByPrefix("idle","Caja",24,true);
        Caja.animation.play("idle");
        Caja.scrollFactor.set(0.5,1);
        insert(members.indexOf(dad),Caja);
        denial_bg.push(Caja);

        var Arboles:FlxSprite = new FlxSprite(-350,-50);
        Arboles.frames = Paths.getSparrowAtlas(shit + "Arboles");
        Arboles.animation.addByPrefix("idle","Arboles",24,true);
        Arboles.animation.play("idle");
        Arboles.scrollFactor.set(0.5,1);
        insert(members.indexOf(dad),Arboles);
        denial_bg.push(Arboles);


        var Suelo:FlxSprite = new FlxSprite(-400,640);
        Suelo.frames = Paths.getSparrowAtlas(shit + "Suelo");
        Suelo.animation.addByPrefix("idle","Suelo",24,true);
        Suelo.animation.play("idle");
        Suelo.scrollFactor.set(1,1);
        insert(members.indexOf(dad),Suelo);
        denial_bg.push(Suelo);


        for (frames in [1,2,3,4,5,6]){
            var Hojas:FlxSprite = new FlxSprite(-400,200);
            Hojas.x = FlxG.random.int(-400,-300); 
            Hojas.frames = Paths.getSparrowAtlas(shit + "Hojas");
            Hojas.animation.addByPrefix("idle","Hoja" + frames,24,true);
            Hojas.animation.play("idle");
           
            if (frames == 1) insert(members.indexOf(dad),Hojas);
            else  add(Hojas);


            denial_bg.push(Hojas);
        }
        for (frames in [1,2,3,4,5,6]){
            var Hojas:FlxSprite = new FlxSprite(800,200);
            Hojas.x = FlxG.random.int(800,700); 
            Hojas.frames = Paths.getSparrowAtlas(shit + "Hojas");
            Hojas.animation.addByPrefix("idle","Hoja" + frames,24,true);
            Hojas.animation.play("idle");
            Hojas.flipX = true;
            if (frames == 1) insert(members.indexOf(dad),Hojas);
            else  add(Hojas);
            denial_bg.push(Hojas);
        }


        for (bg in denial_bg)
            bg.visible = false;
    }
    camOverlay.addShader(grieveSh);

 

    grieveSh.wobble_intensity = wobble_intensity;
    grieveSh.line_intensity = line_intensity;
    grieveSh.vignette_intensity = vignette_intensity;
    grieveSh.grade_intensity = grade_intensity;
}

var bg_2:FlxSprite;
var my_family:FlxSprite;
public static function setBg_2(){
 score_Txt.color = time_Txt.color = FlxColor.ORANGE;
 camGame._filters = [];
 camHUD._filters = [];
 camOverlay._filters = [];


 var velocity:Float = (Conductor.stepCrochet / 1000) * 25;
 FlxG.camera.bgColor = FlxColor.WHITE;
 gf.visible = false;

 bg_2 = new FlxSprite(-1450,-350).loadGraphic(Paths.image("stages/class/memory/mindfloor"));
 bg_2.scrollFactor.set(1,1);
 insert(members.indexOf(dad),bg_2);

 scissors = new FlxSprite(-1100,-220).loadGraphic(Paths.image("stages/class/memory/scissors"));
 insert(members.indexOf(dad),scissors);
 scissors.scrollFactor.set(0.55,1);
 scissors.scale.set(0.85,0.85);
 FlxTween.tween(scissors,{y:scissors.y + 20,angle:scissors.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});
 items_.push(scissors);

 daisy = new FlxSprite(-400,-150).loadGraphic(Paths.image("stages/class/memory/daisy"));
 insert(members.indexOf(dad),daisy);
 daisy.scrollFactor.set(0.55,1);
 daisy.scale.set(0.85,0.85);
 items_.push(daisy);
 FlxTween.tween(daisy,{y:daisy.y + 20,angle:daisy.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 
 cap = new FlxSprite(0,-150).loadGraphic(Paths.image("stages/class/memory/cap"));
 insert(members.indexOf(dad), cap);
 cap.scrollFactor.set(0.55,1);
 cap.scale.set(0.85,0.85);
 items_.push(cap);
 FlxTween.tween(cap,{y:cap.y + 20,angle:cap.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

  
 unicorn = new FlxSprite(700,0).loadGraphic(Paths.image("stages/class/memory/unicorn"));
 insert(members.indexOf(dad), unicorn);
 unicorn.scrollFactor.set(0.55,1);
 unicorn.scale.set(0.85,0.85);
 items_.push(unicorn);
 FlxTween.tween(unicorn,{y:unicorn.y + 20,angle:unicorn.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 her = new FlxSprite(1100,-200).loadGraphic(Paths.image("stages/class/memory/her"));
 insert(members.indexOf(dad), her);
 her.scrollFactor.set(0.55,1);
 her.scale.set(0.85,0.85);
 items_.push(her);
 FlxTween.tween(her,{y:her.y + 20,angle:her.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});


 dodjdjar = new FlxSprite(1450,-200).loadGraphic(Paths.image("stages/class/memory/dodjdjar"));
 insert(members.indexOf(dad), dodjdjar);
 dodjdjar.scrollFactor.set(0.55,1);
 dodjdjar.scale.set(0.85,0.85);
 items_.push(dodjdjar);
 FlxTween.tween(dodjdjar,{y:dodjdjar.y + 20,angle:dodjdjar.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 gamechild = new FlxSprite(1450,100).loadGraphic(Paths.image("stages/class/memory/gamechild"));
 insert(members.indexOf(dad), gamechild);
 gamechild.scrollFactor.set(0.55,1);
 gamechild.scale.set(0.85,0.85);
 items_.push(gamechild);
 FlxTween.tween(gamechild,{y:gamechild.y + 20,angle:gamechild.angle - 2}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 sofa = new FlxSprite(0,100).loadGraphic(Paths.image("stages/class/memory/sofa"));
 insert(members.indexOf(dad),sofa);
 sofa.scrollFactor.set(0.75,1);
 sofa.scale.set(0.85,0.85);
 items_.push(sofa);
 //FlxTween.tween(sofa,{y:sofa.y + 25,angle:sofa.angle - 2.5}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});


 tv = new FlxSprite(-1000,200).loadGraphic(Paths.image("stages/class/memory/tv"));
 insert(members.indexOf(dad),tv);
 tv.scrollFactor.set(0.75,1);
 tv.scale.set(0.85,0.85);
 items_.push(tv);

 FlxTween.tween(tv,{y:tv.y - 30,angle:tv.angle - 2.5}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 wand = new FlxSprite(-1100,0).loadGraphic(Paths.image("stages/class/memory/wand"));
 insert(members.indexOf(dad),wand);
 wand.scrollFactor.set(0.75,1);
 wand.scale.set(0.85,0.85);
 items_.push(wand);
 FlxTween.tween(wand,{y:wand.y + 25,angle:wand.angle - 2.5}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});


 calculator = new FlxSprite(-900,600).loadGraphic(Paths.image("stages/class/memory/calculator"));
 insert(members.indexOf(dad),calculator);
 calculator.scrollFactor.set(0.75,1);
 calculator.scale.set(0.85,0.85);
 items_.push(calculator);
 FlxTween.tween(calculator,{y:calculator.y + 25,angle:calculator.angle - 2.5}, velocity,{type:FlxTween.PINGPONG,ease:FlxEase.sineInOut});

 my_family = new FlxSprite(-1550,-450).loadGraphic(Paths.image("stages/class/memory/my_family"));
 my_family.scrollFactor.set(1,1);
 my_family.scale.set(0.85,0.85);
 add(my_family);

 dad.cameraOffset.set(-200,-100);
 
 defaultCamZoom = FlxG.camera.zoom = 0.75;
 boyfriend.setPosition(650,450);
 camFollowChars = false;
 camFollow.setPosition(450,200);
 camGame._fxFadeAlpha = 1;
 camGame._fxFadeColor = FlxColor.BLACK;
 new FlxTimer().start(0.25, (tmr:FlxTimer) -> {
 camGame.fade(FlxColor.BLACK,5,true);
 });
 FlxTween.tween(FlxG.camera,{zoom:0.55},5,{ease:FlxEase.quadInOut});
 FlxTween.tween(camFollow,{x:0,y:500},5,{ease:FlxEase.quadInOut,onComplete:function eh(){
    camFollowChars = true;
    defaultCamZoom = 0.55;
 }});
 comboGroup.setPosition(1100,600);
 boyfriend.cameraOffset.set(-250, -100);
 for (items in class_bg) items.visible = false;
 for (hudsito in [healthBar,healthBarBG_1,iconP1,iconP2,missesTxt])
    hudsito.visible = false;
 angleMoveSpeed = 0; 
}
public static function setBg_1(){
    if(PlayState.SONG.meta.name == "My Amazing Sadness" || PlayState.SONG.meta.name == "my amazing sadness") {
        score_Txt.color = time_Txt.color = FlxColor.fromRGB(61, 122, 191);
        camGame.addShader(grieveSh);
        camHUD.addShader(grieveSh);
        camOverlay.addShader(grieveSh);

        for (items2 in items_) items2.visible = false;
        bg_2.visible = false;

        boyfriend.x += 280;
   
        boyfriend.cameraOffset.set(-120, 150);
         dad.cameraOffset.set(0, 50);   
         angleMoveSpeed = 0.025; 
         gf.visible = true;
         FlxG.camera.bgColor = FlxColor.BLACK;
         my_family.visible = false;

    }
    if (PlayState.SONG.meta.name == "Denial" || PlayState.SONG.meta.name == "denial"){
        for (bg in denial_bg) bg.visible = false;
        gf.visible = true;
    }
     defaultCamZoom = 0.75;
    comboGroup.setPosition(1300,600);
  

    for (items in class_bg) items.visible = true;
  
 

    for (hudsito in [healthBar,healthBarBG_1,iconP1,iconP2,missesTxt])
        hudsito.visible = true;
}
var penis:Bool = true;
public static function tweenHud(){
    penis = !penis;
    trace("tween hud: " + penis);
    if (penis)
        for (items in [healthBar,healthBarBG_1,iconP1,iconP2])
            FlxTween.tween(items,{y:items.y  - 250},1,{ease:FlxEase.circInOut});    
    else
        for (items in [healthBar,healthBarBG_1,iconP1,iconP2])
            FlxTween.tween(items,{y:items.y  + 250},1,{ease:FlxEase.circInOut});    
  
  
}
public static function hideGhosts(){
    for (ghost in [ghost_anais,ghost_darwin])
        FlxTween.tween(ghost, {alpha: 0},0.6);

}
public static function bgDenial(){
  
  
    for (items in class_bg) items.visible = false;
    for (bg in denial_bg) bg.visible = true;
    gf.visible = false;

    defaultCamZoom = 0.68;
    
}
public static function gumballcolgado(){
    var pathThing = "characters/Gumball_is_dead";
    var sprite:FlxSprite = new FlxSprite(600,400);
    sprite.frames = Paths.getSparrowAtlas(pathThing);
    sprite.animation.addByPrefix("idle","Gumball_dead",24,true);
    sprite.animation.play("idle");
    insert(members.indexOf(dad),sprite);

    for (items in [dad,gf,boyfriend])
        items.visible = false;


}
var gumaballs:Bool = false;
public static function showGumcalShit() {
    gumaballs = !gumaballs;
    gumball_suelo.visible = gumaballs;
    dad.visible =(gumaballs) ? false: true;
    trace("gumaballs: " + gumaballs);
}

public static function changeAlphaStairs(alphaS:String = "",timeS:String = "") {
    FlxTween.tween(stairs,{alpha: Std.parseFloat(alphaS)}, Std.parseFloat(timeS));
    trace("alpha: " + alphaS + " time: " + timeS);
}

public static function showGhost(){
    ghost_darwin.visible = ghost_anais.visible = true; 
}
var time_:Float = 0.0;
function update(elapsed:Float){
    time_ += elapsed;
    grieveSh.iTime = time_;

    if (PlayState.SONG.meta.name == "My Amazing Sadness" || PlayState.SONG.meta.name == "my amazing sadness"){
        if (curStep >-1  && curStep < 1471){
            for (i in [0,1,2,3]){
                strumLines.members[0].members[i].setPosition(
                    defaultOpponentStrum[i].x + FlxG.random.float(-1,1),defaultOpponentStrum[i].y + FlxG.random.float(-1,1)
                );
            }
        }
      
        if (curStep> 1532 && curStep < 1760){
            for (i in [0,1,2,3]){
         
                var currentBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm/60);
              
                if (defaultOpponentStrum != null){
                    var strumOpp = strumLines.members[0];
                    strumOpp.members[i].x = defaultOpponentStrum[i].x + 8 * Math.sin(currentBeat + i);
                    strumOpp.members[i].y = defaultOpponentStrum[i].y +  4 * Math.sin(currentBeat + i);
                    
                }  
               
            }
            for (strum in cpuStrums)
             strum.alpha = FlxMath.lerp(strum.alpha,0.6,0.8);

            for (strum in cpuStrums.notes)
                strum.alpha = FlxMath.lerp(strum.alpha,0.4,0.1);
            
         
        }
        if (curStep == 1760){
            time_Txt.alpha = 0;
            for (strum in cpuStrums){
                FlxTween.tween(strum,{alpha:0},0.01);
               
            }
         
            for (strum in cpuStrums.notes){
                FlxTween.tween(strum,{alpha:0},0.01);


            }
            for (notes in [0,1,2,3]) {
                var strumPlayer = strumLines.members[1].members[notes];
                FlxTween.tween(strumPlayer,{x: strumPlayer.x -350},1,{ease:FlxEase.quadInOut});
            }
        }
        if (curStep == 2164){
            for (notes in [0,1,2,3]) {

                var strumPlayer = strumLines.members[1].members[notes];
                FlxTween.tween(strumPlayer,{x: defaultPlayerStrum[notes].x},1,{ease:FlxEase.quadInOut});

            }
            FlxTween.tween(time_Txt,{alpha: 1},1);
        }
        if (curStep > 2163 && curStep < 2779){
            for (i in [0,1,2,3]){
                strumLines.members[0].members[i].setPosition(
                    defaultOpponentStrum[i].x + FlxG.random.float(-3,3),defaultOpponentStrum[i].y + FlxG.random.float(-3,3)
                );
            }
        }
        if (curStep > 2778 && curStep < 2843) {
            for (i in [0,1,2,3]){
                strumLines.members[1].members[i].setPosition(
                    defaultPlayerStrum[i].x + FlxG.random.float(-2,2), defaultPlayerStrum[i].y + FlxG.random.float(-2,2)
                );
            }
        }

        if (curStep == 2779) {
            penis = true;
            tweenHud();
            FlxG.camera.shake(0.01, 5.05);
          
            for (i in [0,1,2,3]){
                var notes =  strumLines.members[0].members[i];
                var shit:Int = 10;
                shit ++; 

                FlxTween.tween(notes, {y: notes.y + 2000}, Conductor.stepCrochet * shit / 1000, {ease: FlxEase.quadInOut});
            }
          
        }

    }
 
}