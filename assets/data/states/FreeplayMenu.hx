import hxvlc.flixel.FlxVideoSprite;
import sys.io.File;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxTextAlign;
import flixel.util.FlxAxes;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxRect;
import funkin.savedata.FunkinSave;

static var isStarted:Bool = false;
static var curWeek:Int = 0;
static var curSong:Int = 0;
static var curOldWeek:Int = 0;

var blackMonitor:FlxSprite;
var bg:FlxSprite;
var scoreSpr:FlxSprite;
var monitor:FlxSprite;
var monitor_down:FlxSprite;
var intendedScore:Int = 0;

var blackPenis:FlxSprite;
var selector:FlxText;
var cameraScroll:Bool = false;
var vig:FlxSprite;
var LB:FlxSprite; 
var RB:FlxSprite;

var keySequence:Array<String> = ["T", "H", "E", "V", "O", "I", "D"];
var curIndex:Int = 0;

// arrays
var grpSongs:Array<FlxTypedGroup<FlxText>> = [];
var grpSongs_old:Array<FlxTypedGroup<FlxText>> = [];

var grpTitles:FlxTypedGroup<FlxSprite>;
var rockGroup:FlxTypedGroup<FlxSprite>;
var title_secret:FlxSprite;
var scoreText:FlxText;
var camHUD:FlxCamera;
var thevoidsito:FlxSprite;
static var isSelectingWeek:Bool = true;
var rockTimer:FlxTimer;
var nata = new FlxSprite();

function create() {
    changePrefix("Freeplay - select week");
   
    camHUD = new FlxCamera();
	camHUD.bgColor = 0x00000000;
	FlxG.cameras.add(camHUD, false);

    startedFreeplayMusic = true;
    startedMenuMusic = false;

    if(startedFreeplayMusic) {
        FlxG.sound.playMusic(Paths.music('Freeplay-theme'), 0);
        FlxG.sound.music.fadeIn(5);
    }
   
    // bg
    bg = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/bg'));
    bg.setGraphicSize(Std.int(bg.width * 0.55));
    bg.scrollFactor.set(.6, 1.2);
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    blackPenis = new FlxSprite().makeGraphic(600, 500, FlxColor.BLACK);
    blackPenis.screenCenter();
    blackPenis.y -= 40;
    add(blackPenis);

    starsVideo = new FlxVideoSprite(0, 0);
	starsVideo.load(Assets.getBytes(Paths.video('stars')), ['input-repeat=65545']);
	starsVideo.bitmap.onFormatSetup.add(function():Void
	{
		if (starsVideo.bitmap != null && starsVideo.bitmap.bitmapData != null)
		{	
			starsVideo.scale.set(0.55,0.55);
			starsVideo.updateHitbox();
			starsVideo.screenCenter();
			starsVideo.y -= 40;
	    }
	});
    starsVideo.play();
    add(starsVideo);
  
    thevoidsito = new FlxSprite();
    thevoidsito.frames = Paths.getSparrowAtlas("stages/the-void/the-void");
    thevoidsito.animation.addByPrefix('idle','the-void idle0',24,true);
    thevoidsito.animation.play('idle');
    thevoidsito.screenCenter();
    thevoidsito.visible = false;
    add(thevoidsito);

    title_secret = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/weekName/finalBattle"));
    title_secret.setGraphicSize(Std.int(title_secret.width * 0.45));
    title_secret.screenCenter();
    title_secret.visible = false;
    title_secret.y -= 40;
    add(title_secret);
      
    grpTitles = new FlxTypedGroup();
   
    for (i in 0...WeekDataOld.length) {
        var textGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup();
        grpSongs_old.push(textGrp);

        for (songI_2 in 0...WeekDataOld[i].songs.length) {

            var songText = new FlxText(0,180, 450, WeekDataOld[i].songs[songI_2], 35);
            songText.setFormat(Paths.font("Gumball.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            songText.borderSize = 1.25;
            songText.scrollFactor.set(1, 1);
            songText.visible = false;
            songText.ID = songI_2;
            shitWeek(songText, songI_2, WeekDataOld[i].songs.length);
			songText.y = songText.y + (songI_2 * 40);
            songText.screenCenter(FlxAxes.X);
            textGrp.add(songText);
        }
        add(textGrp);
    }
    
    for (i in 0...WeekData.length) {
        var title = new FlxSprite();
        var imgPath = 'menus/freeplay/weekName/' + WeekData[i].image_key;
       
        if (WeekData[i].isXml) {
            title.frames = Paths.getSparrowAtlas('menus/freeplay/weekName/' + WeekData[i].image_key);
            title.animation.addByPrefix('idle', 'idle', 6, true);
            title.animation.play('idle');
            title.setGraphicSize(Std.int(title.width * 0.45));
            title.screenCenter();
            title.y -= 40;
            title.ID = i;
            title.visible = false;
            grpTitles.add(title);
        } else {
            title.loadGraphic(Paths.image(imgPath));
            title.setGraphicSize(Std.int(title.width * 0.45));
            title.screenCenter();
            title.y -= 40;
            title.ID = i;
            title.visible = false;
            grpTitles.add(title);
        }   

        // Lista de canciones
        var group:FlxTypedGroup<FlxText> = new FlxTypedGroup();
        grpSongs.push(group);

        for (songI in 0...WeekData[i].songs.length) {
            var songText = new FlxText(0,180, 450, WeekData[i].songs[songI], 35);
            songText.setFormat(Paths.font("Gumball.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            songText.borderSize = 1.25;
            songText.scrollFactor.set(1, 1);
            songText.visible = false;
            songText.ID = songI;
            shitWeek(songText, songI, WeekData[i].songs.length);
			songText.y = songText.y + (songI * 40);
            songText.screenCenter(FlxAxes.X);
            group.add(songText);
        }
        add(group);
    }
    add(grpTitles);

    blackMonitor = new FlxSprite().makeGraphic(600,500,FlxColor.BLACK);
	blackMonitor.scrollFactor.set(1, 1);
	blackMonitor.screenCenter();
	blackMonitor.y -= 40;
	blackMonitor.alpha = (isStarted) ? 0: 1;
    blackMonitor.blend = 10;
	add(blackMonitor);

    nata.frames = Paths.getSparrowAtlas("daSTAT");
    nata.setPosition(445,150);
    nata.scale.set(1.405,1.4);
    nata.animation.addByPrefix("loop","staticFLASH",24,true);
    nata.animation.play("loop");
    nata.scrollFactor.set(1,1);
    nata.alpha = (isStarted) ? 0 : 1;
    add(nata);

	monitor_down = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/monitor_down'));
	monitor_down.setGraphicSize(Std.int(monitor_down.width * 0.55));
	monitor_down.scrollFactor.set(1, 1);
    monitor_down.updateHitbox();
	monitor_down.screenCenter();
    add(monitor_down);

	monitor = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/monitor'));
	monitor.setGraphicSize(Std.int(monitor.width * 0.55));
	monitor.scrollFactor.set(1, 1);
    monitor.updateHitbox();
	monitor.screenCenter();
    add(monitor);

	scoreSpr = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/box-score'));
	scoreSpr.setGraphicSize(Std.int(scoreSpr.width * 0.48));
	scoreSpr.scrollFactor.set(1, 1);
    scoreSpr.updateHitbox();
	scoreSpr.screenCenter();
	scoreSpr.alpha = 0;
    scoreSpr.camera = camHUD;
    add(scoreSpr);

	scoreText = new FlxText(610,10, FlxG.width/2, "Score: 19282109", 35);
	scoreText.setFormat(Paths.font("Gumball.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	scoreText.scrollFactor.set(1,1);
	scoreText.borderSize = 1.25;
	scoreText.visible = false;
    scoreText.offset.set(0,0);
	scoreText.camera = camHUD;
	add(scoreText);

	LB = new FlxSprite(80,(isStarted)?300 :-1000).loadGraphic(Paths.image('menus/freeplay/left-button'));
	LB.setGraphicSize(Std.int(LB.width * 0.38));
	LB.scrollFactor.set(1, 1);
    LB.updateHitbox();
	LB.camera = camHUD;
    add(LB);
		
	RB = new FlxSprite(1100,(isStarted)?290 :-1000).loadGraphic(Paths.image('menus/freeplay/right-button'));
	RB.setGraphicSize(Std.int(RB.width * 0.38));
	RB.scrollFactor.set(1, 1);
	RB.updateHitbox();
	RB.camera = camHUD;	
    add(RB);

	vig = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/vig'));
	vig.setGraphicSize(Std.int(LB.width * 12));
	vig.scrollFactor.set(1, 1);
	vig.updateHitbox();
    vig.screenCenter();  
	vig.camera = camHUD;
    add(vig);

	changeWeek();

    FlxG.mouse.visible = true;
    isSelectingWeek = true;

    rockGroup = new FlxTypedGroup();
    rockGroup.camera = camHUD;
    add(rockGroup);
}

var daSongsWeek:Array<{name:String,hide:Bool}>= [];

function shitWeek(text:FlxText,uh:Int,max:Int):Void {
    if (uh >= max) text.y = 180;
}

function changeWeek(uh:Int = 0){
    curWeek = FlxMath.wrap(curWeek + uh, 0, WeekData.length - 1);

    var sprite:FlxSprite = (uh == 1) ? RB : LB;
    sprite.scale.set(0.45,0.45);
    nata.alpha = 1;

    for (i in 0...WeekData.length) {
        grpTitles.members[i].visible = false;
        
        switch(WeekData[curWeek].weekName)
        {
            case 'Chichi' | 'Murder':
                starsVideo.visible = false;
            default:
                starsVideo.visible = true;
        }
    }
    grpTitles.members[curWeek].visible = true;	

    for (i in 0 ...WeekData[curWeek].songs.length){
        daSongsWeek[i] = {name: WeekData[curWeek].songs[i], hide: false};
    }

    PlayState.loadWeek({
        name: WeekData[curWeek].weekName,
        id: WeekData[curWeek].weekName,
        sprite: null,
        chars: [null, null, null],
        songs: daSongsWeek,
        difficulties: ['hard']
    }, "hard");
    PlayState.isStoryMode = false;

}

var lerpScore:Int;
static var uh:Bool = true;
var isMouse:Bool = false;
var noPressed:Bool = true;
var ahorasiprecionaxd:Bool = false;
var ogSongsMenu:Bool = false;
var spawnCooldown:Float = 0;
var selectingSong_old:Bool = false;

function update(elapsed:Float) {
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX - FlxG.width / 2 ) * 0.015, 8 * elapsed); //mario madres
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY - 6 - FlxG.height / 2) * 0.015, 8 * elapsed);

    if (!isStarted && uh && !ogSongsMenu){
		
        if (controls.ACCEPT || FlxG.mouse.justPressed) {
            uh = false;
            FlxTween.tween(blackMonitor, {alpha:0}, 1,{onComplete: function penis(tween:FlxTween):Void{
                FlxTween.tween(FlxG.camera,{zoom:1.1},0.7,{ease:FlxEase.cubeInOut, onComplete: function sex(tween:FlxTween){
                    isStarted = true;
                    FlxTween.tween(LB,{y:300},1,{ease:FlxEase.backInOut});
                    FlxTween.tween(RB,{y:295},1,{ease:FlxEase.backInOut});
                }});
            }});
        }	
    }
    nata.alpha = lerp(nata.alpha,0, 0.1);
   
    if (isSelectingWeek && isStarted && !ogSongsMenu) {
        LB.scale.set(
            FlxMath.lerp(LB.scale.x, 0.38, 0.1),
            FlxMath.lerp(LB.scale.y, 0.38, 0.1)
        );

        RB.scale.set(
            FlxMath.lerp(RB.scale.x, 0.38, 0.1),
            FlxMath.lerp(RB.scale.y, 0.38, 0.1)
        );
      
        if (controls.LEFT_P || (FlxG.mouse.overlaps(LB) && FlxG.mouse.justPressed)) {
           changeWeek(-1);
        }
        if (controls.RIGHT_P || (FlxG.mouse.overlaps(RB) && FlxG.mouse.justPressed)) {
            changeWeek(1);
        }

        if (controls.ACCEPT || (FlxG.mouse.overlaps(blackPenis) && FlxG.mouse.justPressed))
        {
            if(WeekData[curWeek].weekName == 'Murder')
            {
                curSong = 0;
                gotoPlayState();
                return;
            }

            goToSongs();
        }
            

        if (controls.BACK){
            FlxG.sound.play(Paths.sound('cancelMenu'));
            new FlxTimer().start(0.2, (tmr:FlxTimer) -> {
                FlxG.switchState(new MainMenuState());
            });
        }

        if (curIndex < keySequence.length && isKeyPressed(keySequence[curIndex])) curIndex++;

        if (curIndex == keySequence.length)
			changeMenuSecret();
    }
    if (ogSongsMenu) {
        spawnCooldown -= elapsed;

        if (spawnCooldown <= 0)
        {
            spawnCooldown = FlxG.random.float(5,7); 
            spawnRock(1);
        }
        
        for (rock in rockGroup.members)
        {
            if (rock != null && rock.x + rock.width < 0)
            {
                rock.kill(); 
            }
        }
        if (controls.ACCEPT && !selectingSong_old){
            if(WeekData[curWeek].weekName == 'Murder')
            {
                curSong = 0;

                gotoPlayState();
                return;
            }

            goToSongs();
        }
    
        if (selectingSong_old && ahorasiprecionaxd){

            lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
            if (Math.abs(lerpScore - intendedScore) <= 10)
                lerpScore = intendedScore;

            scoreText.text = 'Score: '+ lerpScore;
            positionHighscore();

            if (noPressed) {
                if (controls.UP_P && noPressed) changeSong(-1);
                if (controls.DOWN_P && noPressed) changeSong(1);            
                if (controls.ACCEPT) {
                    gotoPlayState();
                    noPressed = false;
                }
            }
        }
    }

    if (!isSelectingWeek && !ogSongsMenu){

        lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
        if (Math.abs(lerpScore - intendedScore) <= 10)
            lerpScore = intendedScore;

        scoreText.text = 'Score: '+ lerpScore;
        positionHighscore();
     
        if (ahorasiprecionaxd){

            if (controls.UP_P && noPressed)
                changeSong(-1);
            if (controls.DOWN_P && noPressed)
                changeSong(1);
            
            if (controls.ACCEPT && noPressed) {
                // trace("pdlaf");

                gotoPlayState();
                noPressed = false;
            }

        }
        if (controls.BACK) backWeeks();
    }
}

var selectRock:Int = -1;
function spawnRock(uh:Int = 0):Void
{
    selectRock = FlxMath.wrap(selectRock + uh, 0, 10);
    var rock = new FlxSprite();
    rock.loadGraphic(Paths.image("stages/the-void/Rocas/_roc" + (selectRock + 2)));
    rock.scale.set(0.6, 0.6);
    rock.x = FlxG.width - 2200;
    rock.screenCenter(FlxAxes.Y);
    rock.origin.set(rock.width / 2 - 200, rock.height / 2 + 300);
    rock.angularVelocity = FlxG.random.int(15, 18); 
    rock.velocity.x = FlxG.random.int(100, 200);
    rockGroup.add(rock);
}

function changeMenuSecret() {
    camHUD.fade(FlxColor.BLACK, 1.4, true);
    FlxTween.tween(FlxG.camera,{zoom: 1.4},0.45,{ease:FlxEase.circInOut,onComplete: function shit(_){
        FlxTween.tween(FlxG.camera,{zoom:1.1},0.55,{ease:FlxEase.backInOut});
    }});
    isSelectingWeek = false;
    ogSongsMenu = true;
    thevoidsito.visible = title_secret.visible = true;
    for (i in 0...grpTitles.length) grpTitles.members[i].visible = false;	
    LB.visible = false;
    RB.visible = false;
}

function isKeyPressed(key:String):Bool
{
	switch (key)
	{
		case "T": return FlxG.keys.justReleased.T;
		case "H": return FlxG.keys.justReleased.H;
		case "E": return FlxG.keys.justReleased.E;
		case "V": return FlxG.keys.justReleased.V;
		case "O": return FlxG.keys.justReleased.O;
		case "I": return FlxG.keys.justReleased.I;
		case "D": return FlxG.keys.justReleased.D;
		default: return false;
	}
}

function goToSongs(){
    changePrefix("Freeplay - select Song");

    if (ogSongsMenu){
        curSong = 0;
        ahorasiprecionaxd = false;
        changeSong();
        FlxTween.tween(scoreSpr,{alpha:1},1,{ease:FlxEase.cubeInOut,onComplete: function penis(_){ahorasiprecionaxd = true;}});
        scoreText.visible = true;
        title_secret.visible = false;
        selectingSong_old = true;
        for (i in 0...grpSongs_old[0].length) grpSongs_old[0].members[i].visible = true;
    }else{
        curSong = 0;
        ahorasiprecionaxd = false;
        changeSong();

        FlxTween.tween(LB,{y:-1000},1,{ease:FlxEase.backInOut});
        FlxTween.tween(RB,{y:-1000},1,{ease:FlxEase.backInOut});
        FlxTween.tween(scoreSpr,{alpha:1},1,{ease:FlxEase.cubeInOut,onComplete: function penis(_){ahorasiprecionaxd = true;}});
        isSelectingWeek = false;
        scoreText.visible = true;
        for (i in 0...grpTitles.length) grpTitles.members[i].visible = false;	
        for (i in 0...grpSongs[curWeek].length) grpSongs[curWeek].members[i].visible = true;
    }
}

function gotoPlayState() {
    // trace("Ola");

    if (ogSongsMenu){
        isVoidWeek = true;
        PlayState.loadSong(WeekDataOld[curOldWeek].songs[curSong],'hard');
        FlxG.switchState(new PlayState());
    }else{
        isVoidWeek = false;
        PlayState.loadSong(WeekData[curWeek].songs[curSong],'hard');
       
        FlxG.switchState(new PlayState());
    }
}

function backWeeks() {
    changePrefix("Freeplay - Week Select");
    changeWeek();
    FlxTween.tween(LB,{y:300},1,{ease:FlxEase.backInOut});
            FlxTween.tween(RB,{y:295},1,{ease:FlxEase.backInOut});
    FlxTween.tween(scoreSpr,{alpha:0},1,{ease:FlxEase.cubeInOut});
    isSelectingWeek = true;
    isStarted = true;
    scoreText.visible = false;
    ahorasiprecionaxd = false;

    for (i in 0...grpTitles.length) grpTitles.members[i].visible = false;	
    grpTitles.members[curWeek].visible = true;	
    for (i in 0...grpSongs[curWeek].length) grpSongs[curWeek].members[i].visible = false;

}

var shit:Float;
function positionHighscore() {
	if (intendedScore == 0) shit = 605;
	else shit = FlxG.width - scoreText.width + 5;
	
	scoreText.x = shit;
}

function changeSong(uh:Int = 0){
    if (ogSongsMenu) {
        curSong = FlxMath.wrap(curSong + uh, 0, WeekDataOld[curOldWeek].songs.length - 1);
    
        for (i in 0...grpSongs_old[curOldWeek].length)
            grpSongs_old[curOldWeek].members[i].alpha = 0.5;	
    
        grpSongs_old[curOldWeek].members[curSong].alpha = 1;
        intendedScore = FunkinSave.getSongHighscore(WeekDataOld[curOldWeek].songs[curSong], 'hard').score;   
    }else {
        curSong = FlxMath.wrap(curSong + uh, 0, WeekData[curWeek].songs.length - 1);    
        for (i in 0...grpSongs[curWeek].length)
            grpSongs[curWeek].members[i].alpha = 0.5;	
    
        grpSongs[curWeek].members[curSong].alpha = 1;
        intendedScore = FunkinSave.getSongHighscore(WeekData[curWeek].songs[curSong], 'hard').score;   
    }
}