import haxe.format.JsonParser;
import flixel.math.FlxPoint;
import flixel.text.FlxTextAlign;
import flixel.util.FlxAxes;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxBasePoint;
import funkin.backend.utils.CoolUtil;
import hxvlc.flixel.FlxVideoSprite;
/**

 //Structure Json File - Cherry//
 
 {
 "sections": [
    {
      "section": "Musicians",
      "credits": [
        {
          "image": "",
          "name": "",
          "position": { "x": 100, "y": 200 },
          "scale": 1.0,
          "angle": 0,
          "link": ""
        }
      ]
    }
  ]
}

**/
var creditsData:Array<Dynamic>;
var camHUD:FlxCamera;

var bg:FlxSprite;
var bg_section:FlxSprite;
var decoration:FlxSprite;
var overlay:FlxSprite;
var light_:FlxSprite;
var grpSection:FlxTypedGroup<FlxSprite>;
var log_youtubbe:FlxSprite;
var log_twiiter:FlxSprite;
var mainAttach:FlxSprite;
var grpCredit_sprite:Array<FlxTypedGroup<FlxSprite>> = [];
public static var curSelected:Int = 0;
public static var curSection:Int = 0;

var scale_Credts:Array<Array<Float>> = [];
var box_Info:FlxSprite;
var textCredit:FlxText;
//
var blinkTimer:Float = 0;
var nextBlinkTime:Float = 0;
var blinkCount:Int = 0;
var maxBlinks:Int = 0;
var isBlinking:Bool = false;
var particles;
var nextBlinkTime;

var breatheTween:FlxTween;

var videoPlaying:Bool = false;
var savedMusicTime:Float = 0;
//funny things
var byroxMeme:FlxSprite;
var momxonix:FlxSprite;
var yosoydios:FlxSprite;
var okangel:FlxSprite;
var cherry:FlxSprite;

var video:FlxVideoSprite = new FlxVideoSprite();
function create(){
   

    changePrefix("Credits");

    creditsData = [];
    creditsData = daShitJson('info/credits');
    trace(creditsData);

    bg = new FlxSprite().loadGraphic(Paths.image("menus/credits/background"));
    add(bg);

    bg_section = new FlxSprite().loadGraphic(Paths.image("menus/credits/section/bg"));
    add(bg_section);

    decoration = new FlxSprite().loadGraphic(Paths.image("menus/credits/decoration"));
    add(decoration);


    mainAttach = new FlxSprite().loadGraphic(Paths.image("menus/credits/main"));
    mainAttach.scale.set(0.5,0.5);
    mainAttach.screenCenter();
    mainAttach.y -= 50;
    add(mainAttach);
    
    grpSection = new FlxTypedGroup();
    add(grpSection);


    
    for (i in 0...creditsData.sections.length){
        if (creditsData == null) return;
        trace("Section.. " + i);
        

        var item = new FlxSprite().loadGraphic(Paths.image("menus/credits/section/" + creditsData.sections[i].section));
        item.scale.set(0.5,0.5);
        item.updateHitbox();
        item.screenCenter();
        item.ID = i;
        item.visible = (i == curSection) ? true : false; 
        grpSection.add(item);
      

        var group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
        add(group);
        group.visible = (i == curSection) ? true : false; 
        grpCredit_sprite.push(group);

        for (o in 0...creditsData.sections[i].credits.length){
            if (scale_Credts[i] == null)
                 scale_Credts[i] = [];
            var sprite = new FlxSprite().loadGraphic(Paths.image("menus/credits/portraits/" + creditsData.sections[i].credits[o].image));
            var sexy_position:Array<Float> = (creditsData.sections[i].credits[o].position == null) ? [0,0] : [creditsData.sections[i].credits[o].position.x,creditsData.sections[i].credits[o].position.y];
            var sexy_scale:Float = (creditsData.sections[i].credits[o].scale == null) ? 1 : creditsData.sections[i].credits[o].scale;
            scale_Credts[i][o] = sexy_scale;
            sprite.scale.set(sexy_scale,sexy_scale);
            sprite.updateHitbox();
            sprite.setPosition(sexy_position[0],sexy_position[1]);
            sprite.angle = (creditsData.sections[i].credits[o].angle == null) ? 0 : creditsData.sections[i].credits[o].angle;
            sprite.ID = o;
            grpCredit_sprite[i].add(sprite);
      
        }

    }

    box_Info = new FlxSprite().makeGraphic(200,210,FlxColor.BLACK);
    box_Info.alpha = 0;
    add(box_Info);


    textCredit = new FlxText(box_Info.x, box_Info.y, box_Info.width - 15, "");
    textCredit.setFormat(Paths.font('CascadiaMonoPL-Bold.otf'), 14, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    textCredit.borderSize = 0;
    textCredit.wordWrap = true;
    add(textCredit);

    log_youtubbe = new FlxSprite(810,60).loadGraphic(Paths.image("menus/credits/youtube"));
    log_youtubbe.scale.set(0.5,0.5);
    log_youtubbe.color = FlxColor.fromRGB(64, 64, 64);
    log_youtubbe.updateHitbox();
    add(log_youtubbe);

    log_twiiter = new FlxSprite(990,60).loadGraphic(Paths.image("menus/credits/twiiter"));
    log_twiiter.scale.set(0.5,0.5);
    log_twiiter.color = FlxColor.fromRGB(64, 64, 64);
    log_twiiter.updateHitbox();
    add(log_twiiter);



    overlay = new FlxSprite().loadGraphic(Paths.image("menus/credits/overlay"));
    add(overlay);


    light_ = new FlxSprite().loadGraphic(Paths.image("menus/credits/Lights"));
    add(light_);

    startBreatheTween();

  
    switch(creditsData.sections[curSection].section){
        case "artist":  changeMusic("creditsState-AnimatorsStem");
        case "animators": changeMusic("creditsState-AnimatorsStem");
        case "musicians": changeMusic("creditsState-AnimatorsStem");
        case "programmers": changeMusic("creditsState-CodersStem");
        case "voice_actor": changeMusic("creditsState-VoiceActorsStem");
        case "chroms_maker": changeMusic("creditsState-VoiceActorsStem");
        case "charters": changeMusic("creditsState-ChartersStem");
    }

    byroxMeme = new FlxSprite().loadGraphic(Paths.image("byrox"));
    byroxMeme.screenCenter();
    byroxMeme.scrollFactor.set(0,0);
    add(byroxMeme);
    byroxMeme.alpha = 0;

    
    momxonix = new FlxSprite().loadGraphic(Paths.image("lamamadexonix"));
    momxonix.screenCenter();
    momxonix.scrollFactor.set(0,0);
    add(momxonix);
    momxonix.alpha = 0;

    yosoydios = new FlxSprite().loadGraphic(Paths.image("yosoydios"));
    yosoydios.screenCenter();
    yosoydios.scrollFactor.set(0,0);
    yosoydios.alpha = 0;
    add(yosoydios);


    okangel = new FlxSprite().loadGraphic(Paths.image("angel"));
    okangel.screenCenter();
    okangel.scrollFactor.set(0,0);
    okangel.alpha = 0;
    add(okangel);

    cherry = new FlxSprite().loadGraphic(Paths.image("cherriada"));
    cherry.screenCenter();
    cherry.scrollFactor.set(0,0);
    cherry.alpha = 0;
    cherry.scale.set(0.5,0.5);
    add(cherry);


  
   
    video.autoVolumeHandle = true;
    add(video);
    particles = createParticles();
    for (sprites in [bg,overlay,light_,bg_section,decoration])
    {
        sprites.scale.set(0.5,0.5);
        sprites.updateHitbox();
        sprites.screenCenter();
    }


    nextBlinkTime = FlxG.random.float(1.0, 2.5);

}
function playVideo(video_Path:String) {
    if (FlxG.sound.music != null && FlxG.sound.music.playing) {
        savedMusicTime = FlxG.sound.music.time;
        FlxG.sound.music.pause();
    }

    video.load(Assets.getBytes(Paths.video(video_Path)));
    video.autoVolumeHandle = true;
    videoPlaying = true;

    video.bitmap.onFormatSetup.add(() -> {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.scrollFactor.set(0, 0);
        video.screenCenter();
        video.bitmap.volume = 1;
    });

    video.bitmap.onEndReached.add(() -> {
        endVideo();
    });

    video.play();
    video.visible = true;
}
function endVideo() {
    if (videoPlaying) {
        video.destroy();
        video.visible = false;
        videoPlaying = false;

        if (FlxG.sound.music != null) {
            FlxG.sound.music.play();
            FlxG.sound.music.time = savedMusicTime;
        }
    }
}

function startBreatheTween() {
    breatheTween = FlxTween.tween(light_, {alpha: 0.5}, 1.4, {
        type: FlxTween.PINGPONG,
        ease: FlxEase.quadInOut
    });
}

function createParticles():Dynamic {
    var particles:Array<FlxSprite> = [];
    
    function emit(num:Int, x:Float, y:Float) {
        for (i in 0...num) {
            var particle = new FlxSprite(x, y);
            particle.makeGraphic(7, 7, FlxG.random.color()); 
            particle.velocity.set(FlxG.random.float(-100, 100), FlxG.random.float(-10, -150));
            particle.acceleration.y = 300;
            particle.angularVelocity = FlxG.random.float(-360, 360); 
            particle.elasticity = 0.4;
            particle.scrollFactor.set(0,0);
            particle.alpha = 1;
            particle.ID = 1; 
            add(particle);
            particles.push(particle);
        }
    }

    return {
        emit: emit,
        update: function() {
            
            for (particle in particles) {
                if (particle.exists) {
                    particle.scale.x -= FlxG.elapsed * 0.6;
                    particle.scale.y -= FlxG.elapsed * 0.6;
                    particle.alpha -= FlxG.elapsed * 0.5;
                    if (particle.alpha <= 0) {
                        particle.kill();
                    }
                }
            }
        }
    };
}

var pressedInfo:Bool = false;
var targetMove:Bool = false;
var defaultCamZoom = 1;

var blinkTimer:Float = 0;
var nextBlinkTime:Float = 0;
var blinkStateOn:Bool = true; // True si está encendido


function update(elapsed:Float){
    FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX - FlxG.width / 2) * 0.015, 0.05);
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY - 6 - FlxG.height / 2) * 0.015, 0.05);
    
    FlxG.camera.zoom = lerp(FlxG.camera.zoom,defaultCamZoom,0.05);

    particles.update();
   blinkTimer += elapsed;

   if (videoPlaying && FlxG.keys.justPressed.ENTER) {
    endVideo(); 
   }

if (!isBlinking) {
    if (blinkTimer >= nextBlinkTime) {
        blinkTimer = 0;
        isBlinking = true;

       light_.alpha = 1;
        if (breatheTween != null) {
            breatheTween.cancel();
        }

        FlxTween.tween(light_, {alpha: 0}, 0.05, {
            ease: FlxEase.quadInOut,
            onComplete: function(_) {
                new FlxTimer().start(0.015, function(_) {
                    FlxTween.tween(light_, {alpha: 1}, 0.04, {
                        ease: FlxEase.sineInOut,
                        onComplete: function(_) {
                            isBlinking = false;
                            nextBlinkTime = FlxG.random.float(2.0, 5.0);
                            startBreatheTween(); 
                        }
                    });
                });
            }
        });
    }
}


    grpCredit_sprite[curSection].forEach(
        function(spriteCred:FlxSprite) 
        {
            if (FlxG.mouse.overlaps(spriteCred)){
           
                textCredit.x = box_Info.x + (box_Info.width - textCredit.width) / 2;
                textCredit.y = box_Info.y + 10;

                if (!pressedInfo && !targetMove) {
                   
                    box_Info.x = spriteCred.x + (spriteCred.width - box_Info.width) / 2 - 120;
                    box_Info.y = spriteCred.y + (spriteCred.height - box_Info.height) / 2 + 25;

                    curSelected = spriteCred.ID;
                    var scale_ = scale_Credts[curSection][spriteCred.ID] + 0.025;
                    var shitLerp = lerp(spriteCred.scale.x, scale_, 0.1);
                    spriteCred.scale.set(shitLerp, shitLerp);

                    if (FlxG.mouse.justPressed) {
                        updateText();
                    }
                }
            }
            else
            {
                  
                if (!pressedInfo){
                    
                    var scale_ = scale_Credts[curSection][spriteCred.ID]; 
                    var shitLerp = lerp(spriteCred.scale.x, scale_, 0.1);
                    spriteCred.scale.set(shitLerp, shitLerp);
                }
               
            }

    
        }
    );

    if (box_Info.alpha == 0){
        if (controls.BACK)
        {
            startedMenuMusic = false;
            FlxG.switchState(new MainMenuState());
        }
        if (controls.LEFT_P){
            changeSection(-1);
        }
        if (controls.RIGHT_P){
            changeSection(1);
        }
    }else{
        if (FlxG.mouse.overlaps(log_twiiter) && FlxG.mouse.justPressed){
            if (creditsData.sections[curSection].credits[curSelected].twitter != null) {
                CoolUtil.openURL(creditsData.sections[curSection].credits[curSelected].twitter);

            }else{
                FlxG.camera.shake(0.002,0.25);

            }
        }
         if (FlxG.mouse.overlaps(log_youtubbe) && FlxG.mouse.justPressed){
            
            if (creditsData.sections[curSection].credits[curSelected].youtube != null) {
                CoolUtil.openURL(creditsData.sections[curSection].credits[curSelected].youtube);

            }else{
                FlxG.camera.shake(0.002,0.25);
            }

        }
        if (controls.BACK && targetMove)
        {
            hideInfo();
        }
    }
   
}
var currentMusic:String = "";

function changeMusic(song:String, vol:Float = 1) {
    if (currentMusic == song && FlxG.sound.music != null && FlxG.sound.music.playing)
        return;

    currentMusic = song;
    FlxG.sound.playMusic(Paths.music(song), vol);
}



function changeSection(uh:Int = 0){
    curSection = FlxMath.wrap(curSection + uh, 0, grpSection.length - 1);
    switch(creditsData.sections[curSection].section){
        case "artist":  changeMusic("creditsState-AnimatorsStem");
        case "animators": changeMusic("creditsState-AnimatorsStem");
        case "musicians": changeMusic("creditsState-AnimatorsStem");
        case "programmers": changeMusic("creditsState-CodersStem");
        case "voice_actor": changeMusic("creditsState-VoiceActorsStem");
        case "chroms_maker": changeMusic("creditsState-VoiceActorsStem");
        case "charters": changeMusic("creditsState-ChartersStem");
    }
  
    for (i in 0...grpSection.length){
        grpSection.members[i].visible = false;          
        grpCredit_sprite[i].visible = false;           
    }
  
    grpSection.members[curSection].visible = true;
    grpCredit_sprite[curSection].visible = true;   


    var offsetCamera = uh * 10;
    FlxG.camera.scroll.x += offsetCamera;

    FlxG.camera.zoom += 0.005;
    FlxTween.tween(FlxG.camera,{"scroll.x": FlxG.camera.scroll.x - offsetCamera}, 0.25,{ease:FlxEase.cubeInOut});

    for (renders in grpCredit_sprite[curSection]){
        renders.scale.x += 0.015;
        renders.scale.y += 0.015;
        renders.color = FlxColor.fromRGB(64, 64, 64);


        FlxTween.color(renders, 1.0, renders.color, FlxColor.WHITE);
    }

}

function hideInfo() {
    for (shit in [log_twiiter,log_youtubbe]){
        FlxTween.color(shit, 1.0, shit.color, FlxColor.fromRGB(64, 64, 64));
    }
   
    textCredit.text = "";
    FlxTween.tween(box_Info,{"scale.y": 0,alpha: 0}, 0.45, {ease:FlxEase.cubeInOut,onComplete: function(){
        pressedInfo = false;
        targetMove = false;
        defaultCamZoom = 1;
         switch(creditsData.sections[curSection].section){
        case "artist":  changeMusic("creditsState-AnimatorsStem");
        case "animators": changeMusic("creditsState-AnimatorsStem");
        case "musicians": changeMusic("creditsState-AnimatorsStem");
        case "programmers": changeMusic("creditsState-CodersStem");
        case "voice_actor": changeMusic("creditsState-VoiceActorsStem");
        case "chroms_maker": changeMusic("creditsState-VoiceActorsStem");
        case "charters": changeMusic("creditsState-ChartersStem");
    }
    }});


}

function updateText() {
    targetMove = false;
    pressedInfo = true; 

    var final_text:String = 
    "Name: " + creditsData.sections[curSection].credits[curSelected].name + "\nDescription: " 
    + creditsData.sections[curSection].credits[curSelected].fun_text;
    textCredit.text = final_text;
    textCredit.calcFrame();
    if (creditsData.sections[curSection].credits[curSelected].isMain){
        particles.emit(60,950,300);

        changeMusic("creditsState-Main");
    }


    if (creditsData.sections[curSection].credits[curSelected].name == "Byrox"){

        FlxG.sound.play(Paths.sound("nos-destruiran-a-todos-nos-destruiran-a-todos-_1_"));
        FlxG.camera.shake(0.005,1);
        FlxTween.tween(byroxMeme,{"scale.x": 2,"scale.y": 2,alpha: 1},1,{ease:FlxEase.backInOut,onComplete: function(){
             FlxTween.tween(byroxMeme,{alpha: 0},2);
        }});
    }else if(creditsData.sections[curSection].credits[curSelected].name == "CherryCode"){
        FlxG.sound.play(Paths.sound("yippee_"));
        cherry.alpha = 1;
        new FlxTimer().start(1, function(t:FlxTimer) {
         FlxTween.tween(cherry,{alpha: 0},1,{ease:FlxEase.backInOut});
        });


    }else if(creditsData.sections[curSection].credits[curSelected].name == "NightmareXoNIX"){
        FlxG.sound.play(Paths.sound("BOOM-sound-effect"));
        FlxG.camera.shake(0.005,0.1);
        FlxTween.tween(momxonix,{"scale.x": 1,"scale.y": 1,alpha: 1},1,{ease:FlxEase.backInOut,onComplete: function(){
            new FlxTimer().start(1, function(t:FlxTimer) {
                 FlxTween.tween(momxonix,{alpha: 0},2);
            });
            
        }});

    }else if (creditsData.sections[curSection].credits[curSelected].name == "Peppy"){
        new FlxTimer().start(2, function(t:FlxTimer) {
        FlxG.sound.play(Paths.sound("Sonic.exe-laugh"));
        FlxG.camera.shake(0.005,0.1);
        yosoydios.alpha = 1;
          new FlxTimer().start(1, function(t:FlxTimer) {
             FlxTween.tween(yosoydios,{alpha: 0},2);
          });
        });
    }else if(creditsData.sections[curSection].credits[curSelected].name == "Angel [Owner]"){
        FlxG.sound.play(Paths.sound("fart-sound"));
        okangel.alpha = 1;
        new FlxTimer().start(2, function(t:FlxTimer) {
            FlxTween.tween(okangel,{y: okangel.y + 2000},3,{ease:FlxEase.sineInOut,onComplete: function(){
                okangel.y -= 2000;
                okangel.alpha = 0;
            }});
        });
    }else if (creditsData.sections[curSection].credits[curSelected].name == "handy"){
        playVideo("robachambas");
    }

    var twitterCred:Bool = (creditsData.sections[curSection].credits[curSelected].twitter == null) ? false : true;
    var youtubeCred:Bool = (creditsData.sections[curSection].credits[curSelected].youtube == null) ? false : true;


    for (shit in [log_twiiter,log_youtubbe]){
       var color_:FlxColor = switch (shit) {
          case log_twiiter: twitterCred ? FlxColor.WHITE : FlxColor.fromRGB(64, 64, 64);
          case log_youtubbe: youtubeCred ? FlxColor.WHITE : FlxColor.fromRGB(64, 64, 64);
        };
        FlxTween.color(shit, 1.0, shit.color, color_);
    }

    var padding:Int = 20;
    var realWidth = textCredit.textField.textWidth + padding;
    var realHeight = textCredit.textField.textHeight + padding;
    realWidth = Math.max(realWidth, 200);
    realHeight = Math.max(realHeight, 100);


    box_Info.makeGraphic(Std.int(realWidth), Std.int(realHeight), FlxColor.BLACK);
    box_Info.alpha = 0;
    box_Info.scale.y = 0;
    textCredit.setPosition(box_Info.x + padding / 2, box_Info.y + padding / 2);
    textCredit.text = "";   


    FlxTween.tween(box_Info, {"scale.y": 1, alpha: 0.8}, 0.45, {
        ease: FlxEase.cubeInOut,
        onComplete: function(_) {
            var currentText:String = "";
            var textIndex:Int = 0;

            new FlxTimer().start(0.03, function(t:FlxTimer) {
                if (textIndex < final_text.length) {
                    currentText += final_text.charAt(textIndex);
                    textCredit.text = currentText;
                    textIndex++;
                    t.reset();
                }else targetMove = true;
                
                
            });
        }
    });
}