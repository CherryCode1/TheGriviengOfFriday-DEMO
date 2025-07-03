import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.backend.MusicBeatState;
import flixel.FlxCamera;
import funkin.menus.credits.CreditsMain;
import funkin.menus.FreeplayState;
import funkin.backend.utils.DiscordUtil;

var camGame:FlxCamera;

var menuGrp:FlxTypedGroup<FlxSprite>;
var menuLocks:FlxTypedGroup<FlxSprite>;

var menuButtons:Array = [
    {name: 'Play',      locked: false},
    {name: 'Freeplay',  locked: false},
    {name: 'Extras',    locked: true},
    {name: 'Options',   locked: false},
    {name: 'Credits',   locked: false},
];
var positionsArray:Array<Array<Int>> = [
    [-50, 35],
    [-50, 260],
    [-10, 480],
    [1050, 130],
    [1050, 380],
];

var bg:FlxSprite = new FlxSprite();
var madera:FlxSprite = new FlxSprite();
var gum:FlxSprite = new FlxSprite();

var grieveSh:CustomShader = new CustomShader("grieveShader");

function create(){
    changePrefix("Main Menu");

    if(!startedMenuMusic){
        startedMenuMusic  = true;
		FlxG.sound.playMusic(Paths.music('freakyMenu'),0,false);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		FlxG.sound.music.play();
	}

    
    FlxG.mouse.visible = true;


    grieveSh.grade_intensity = .3;
    grieveSh.vignette_intensity = 0.3;
    grieveSh.line_intensity = 0.;
    grieveSh.wobble_intensity = 0.;
    if(FlxG.save.data.GriviengShader)FlxG.camera.addShader(grieveSh);


	bg = new FlxSprite();
    bg.loadGraphic(Paths.image('menus/main/menuBG'));
    bg.screenCenter();
    bg.scale.set(1.2, 1.2);
    bg.scrollFactor.set(0.6, 0.6);
    add(bg);

    gum = new FlxSprite(400, 30);
    gum.loadGraphic(Paths.image('menus/main/GumballMenu'));
    gum.scrollFactor.set(1.2, 1.2);
    add(gum);

    madera = new FlxSprite(1120, 180).loadGraphic(Paths.image('menus/main/Wood'));
    madera.scale.set(0.8, 0.8);
    madera.updateHitbox();
    add(madera);

    FlxTween.angle(madera, -2, 2, 4, {type: FlxTween.PINGPONG, ease: FlxEase.smoothStepInOut});
    FlxTween.tween(madera, {y: madera.y + 20}, 7, {type: FlxTween.PINGPONG, ease: FlxEase.elasticInOut});

    menuGrp = new FlxTypedGroup();
    add(menuGrp);

    menuLocks = new FlxTypedGroup();
    add(menuLocks);

    for(b in 0...menuButtons.length){
        var button:FlxSprite = new FlxSprite();
        button.loadGraphic(Paths.image('menus/main/' + menuButtons[b].name + 'Button'));
        button.setPosition(positionsArray[b][0], positionsArray[b][1]);

        button.scale.set(0.8, 0.8);
        button.updateHitbox();

        if(menuButtons[b].locked){
            button.color = 0xFF666666;
            var lockOffsets:Array = [
                [40, 0],
                [40, 0],
                [40, 0],
                [0, 0],
                [0, 0]
            ];
            var buttonLock:FlxSprite = new FlxSprite();
            buttonLock.loadGraphic(Paths.image('menus/main/lock'));
            buttonLock.scale.set(0.6, 0.6);
            buttonLock.setPosition((button.x) + ((button.width - buttonLock.width) / 2) + lockOffsets[b][0], (button.y) + ((button.height - buttonLock.height) / 2) + lockOffsets[b][1]);
            menuLocks.add(buttonLock);

            FlxTween.angle(buttonLock, -2, 2, 4, {type: FlxTween.PINGPONG, ease: FlxEase.smoothStepInOut});
            FlxTween.tween(buttonLock, {y: buttonLock.y + 20}, 7, {type: FlxTween.PINGPONG, ease: FlxEase.elasticInOut});
        }

        button.antialiasing = true;
        button.ID = b;
        menuGrp.add(button);

        FlxTween.angle(button, -2, 2, 4, {type: FlxTween.PINGPONG, ease: FlxEase.smoothStepInOut});
        FlxTween.tween(button, {y: button.y + 20}, 7, {type: FlxTween.PINGPONG, ease: FlxEase.elasticInOut});
    }

    DiscordUtil.changePresenceSince("In the Menu", null);
}

var curButt:Int = 0;
var tiempito:Float = 0;
var selectedShit:Bool = false;

function update(elapsed:Float){
    var lerpVal:Float = Math.exp(-elapsed * 2);
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX - (FlxG.width * .5)) * 0.015, lerpVal / 4);
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY - 6 - (FlxG.height * .5)) * 0.015, lerpVal / 4); // the 6 is very crucial
    
    tiempito += elapsed;
    grieveSh.iTime = tiempito;

    if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

    if(!selectedShit){
        menuGrp.forEach(
            function(butt:FlxSprite) //este puto codigo me va a dar migraña -peppy
            {
                if(FlxG.mouse.overlaps(butt))
                {
                    curButt = butt.ID;
                    FlxTween.tween(butt.scale, {x: 0.9, y: 0.9}, 0.10, {ease: FlxEase.sineIn});

                    if(FlxG.mouse.justPressed){
                        if(!menuButtons[curButt].locked)
                            pressedButt(curButt);
                        else
                            FlxG.camera.shake(0.005, 0.2);
                    }
                }
                else
                {
                    FlxTween.tween(butt.scale, {x: 0.8, y: 0.8}, 0.10, {ease: FlxEase.sineIn});
                } 
            }
        ); 
    }

    if (controls.BACK) {
        FlxG.switchState(new TitleState());
    }

    #if windows
    if (FlxG.keys.justPressed.SEVEN) {
      persistentUpdate = !(persistentDraw = true);
      openSubState(new EditorPicker());
    }
    if (controls.SWITCHMOD) {
      openSubState(new ModSwitchMenu());
      persistentUpdate = !(persistentDraw = true);
    }
    #end
	
	if (FlxG.keys.justPressed.J) {
        FlxG.switchState(new ModState("shh/JukeboxState"));
    }
}

function pressedButt(thing){
    selectedShit = true;
    FlxG.sound.play(Paths.sound('confirmMenu'));

    new FlxTimer().start(0.5, (tmr:FlxTimer) -> {
        switch(menuButtons[thing].name){
            case 'Play':

                var week:Array<Dynamic> = getWeeks();
                var songArray:Array<WeekSong> = [];
                var songs:Array<String> = getSongsFromTheWeeks();

                for(song in songs){
                    trace(song);
                    songArray.push({name: song, hide: false});
                }

                PlayState.loadWeek({
                  name: week.weekName,
                  id: week.weekName,
                  sprite: null,
                  chars: [],
                  songs: songArray,
                  difficulties: ['hard']
                }, "hard");

				PlayState.campaignMisses = PlayState.campaignScore = PlayState.deathCounter = 0;
            
				PlayState.isStoryMode = true;
                
                FlxG.switchState(new PlayState());
            case 'Freeplay':
                FlxG.switchState(new FreeplayState());
            case 'Extras':
                FlxG.switchState(new FreeplayState());
            case 'Options':
                FlxG.switchState(new OptionsMenu());
            case 'Credits':
                FlxG.switchState(new CreditsMain());
        }     
    });
}

function beatHit(curBeat:Int){
    
}