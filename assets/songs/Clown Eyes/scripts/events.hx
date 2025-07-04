var turnOffShader = new CustomShader("tv_off");
var redFilter = new FlxSprite();
var screenSprite = new FlxSprite();
var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
var blackBG:FlxSprite = new FlxSprite().makeGraphic(3000, 2000, FlxColor.BLACK);
function create() camFollowChars = dispHudInStart = false;

function postCreate(){
    black.cameras = [camHUD];
    black.visible = false;
    add(black);

    turnOffShader.uTime = 0;
    camFollow.setPosition(1200,800);
    FlxG.camera.zoom = 1.1;

    redFilter.makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(255, 55, 0));
    redFilter.blend = 9;
    redFilter.alpha = 0;
    redFilter.cameras = [camOverlay];
    add(redFilter);
   
   camGame.addShader(turnOffShader);
   camHUD.addShader(turnOffShader);
   
    black.cameras = [camHUD];
    black.visible = false;
    add(black);

    blackBG.visible = false;
    insert(members.indexOf(dad) - 1, blackBG);

    for (strumLine in strumLines)
        for (note in strumLine.notes)
            note.copyStrumAngle = false;

    camFollow.setPosition(1000, 700);
    boyfriend.x += 1000;
    FlxG.camera.zoom = 0.9;
}


function onStartCountdown() {
    var sound = FlxG.sound.play(Paths.sound('clownIntro'));
    FlxTween.tween(dad, { y: 190 }, sound.length / 1000 - 0.1, { ease:FlxEase.quadOut, onComplete: function(){
        black.visible = camFollowChars = true;
    }});
}

function onSongStart() 
{
    // FlxTween.tween(dad,{y:190},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut,onComplete: function(){camFollowChars = true;}});
    // FlxTween.tween(boyfriend,{x:boyfriend.x - 400},Conductor.stepCrochet / 1000 * 10,{ease:FlxEase.quadOut});
    // FlxTween.tween(FlxG.camera,{zoom:0.65},Conductor.stepCrochet / 1000 * 8,{ease:FlxEase.quadOut});

    dispHud(true, false, 1, true);
    boyfriend.x -= 1000;
    FlxG.camera.zoom = 0.65;
    FlxTween.tween(black, { alpha: 0 }, Conductor.stepCrochet / 1000 * 16, { ease: FlxEase.quadOut });
}

var time_ = 0;
var turnOff_E = 0;
function update(elapsed){
    time_ += elapsed;
    turnOffShader.iTime = turnOff_E;
    if (curStep > 843 && curStep < 850){
        turnOff_E = time_;
    }else{
        turnOff_E = 0;
    }

    if (Math.abs(strumLines.members[0].members[0].y - 50) >= 0.1 && (curBeat < 124 || curBeat >= 132)) 
        for (strumLine in strumLines)
            for (strum in strumLine)
                strum.y = lerp(strum.y, 50, 0.2);

    if (Math.abs(camHUD.angle) >= 0.1) camHUD.angle = lerp(camHUD.angle, 0, 0.05);
}

var num:Int = 0;
function stepHit(){
        switch(curStep) {
        case 468: makeStrumsJump(20);
        case 476: makeStrumsJump(20);
        case 484: makeStrumsJump(20);
        case 492: makeStrumsJump(20);
        case 528: rotateStrums();
        case 560: rotateStrums();
        case 578: makeStrumsJump(20 + 10 * (num++) / 16);
        case 582: makeStrumsJump(20 + 10 * (num++) / 16);
        case 588:
            rotateStrums();
            makeStrumsJump(30);
        case 590: makeStrumsJump(30);
        case 592:
            redFilter.alpha = 0.6;
            fire_Sprite.visible = true;
        case 604: rotateStrums();
        case 620: rotateStrums();
        case 622: makeStrumsJump(30);
        case 636: rotateStrums();
        case 652: rotateStrums();
        case 654: makeStrumsJump(30);
        case 684: rotateStrums();
        case 686: makeStrumsJump(30);
        case 716: rotateStrums();
        case 718: makeStrumsJump(30);
        case 750: makeStrumsJump(30);
        case 780: rotateStrums();
        case 782: makeStrumsJump(30);
        case 796: rotateStrums();
        case 808: rotateStrums();
        case 814: makeStrumsJump(30);
        case 828: rotateStrums();
        case 844:
            fire_Sprite.visible = false;
            FlxTween.tween(redFilter, { alpha: 0 }, 0.25);
            desactivateZoom_A = true;
            rotateStrums();
            
            // FlxTween.tween(score_Txt, { alpha: 0 }, Conductor.crochet / 1000);
            // FlxTween.tween(black, { alpha: 1 }, Conductor.crochet / 1000, { onComplete: () -> {
            //     dispHud(false, true, 1, true);
            //     blackBG.visible = true;
            //     black.alpha = 0;
            // }});
        case 848:
            dispHud(false, true, 1, true);
            blackBG.visible = true;
            desactivateZoom_A = false;
            strAlpha(1, Conductor.stepCrochet / 1000 * 6, 0);
        case 904: strAlpha(1, Conductor.stepCrochet / 1000 * 8, 1);
        case 912: strAlpha(0, Conductor.stepCrochet / 1000 * 6, 0);
        case 976:
            strAlpha(1, Conductor.stepCrochet / 1000 * 4, 0);
            strAlpha(0, Conductor.stepCrochet / 1000 * 6, 1);
        case 1024: strAlpha(1, Conductor.stepCrochet / 1000 * 8, 1);
        case 1040: strAlpha(0, Conductor.stepCrochet / 1000 * 6, 0);
        case 1104:
            dispHud(true, true, 1, false);
            strAlpha(1, 0.001, 0);
            blackBG.visible = false;  
        case 1360:
            FlxTween.tween(score_Txt, { alpha: 0 }, Conductor.crochet / 1000 * 4); // puta madre
            FlxTween.tween(black, { alpha: 1 }, Conductor.crochet / 1000 * 4);
    }

    if (curStep >= 1110 && curStep < 1360) {
        if ((curStep - 6) % 16 == 0) makeStrumsJump(20);
        if ((curStep - 11) % 32 == 0) makeStrumsJump(20);
        if ((curStep - 14) % 32 == 0) makeStrumsJump(20);
    }

    // if (curStep == 1359){
    //     gumballCamera.fade(FlxColor.BLACK,1,false);
    // }
}

function beatHit() {
    if (curBeat >= 276 && curBeat < 340 && curBeat % 2 == 0) makeStrumsJump(20);
    if (curBeat >= 68 && curBeat < 124 && curBeat % 2 == 0) makeStrumsJump(20);
    if (curBeat >= 132 && curBeat < 146) makeStrumsJump(20 + 10 * (num++) / 16);

    if (curBeat >= 148 && curBeat < 212) {
        FlxTween.cancelTweensOf(camHUD);
        camHUD.angle = curBeat % 2 == 0 ? -7 : 7;
        makeStrumsJump(30);
    }

}

var firstUp:Bool = false;
function makeStrumsJump(gap:Int) {
    for (strumLine in strumLines)
        for (strum in strumLine)
            strum.y = 50 + (strum.ID % 2 == (firstUp ? 0 : 1) ? gap : -gap);

    firstUp = !firstUp;
}

function rotateStrums() {
    for (strumLine in strumLines)
        for (strum in strumLine)
            FlxTween.tween(strum, { angle: strum.angle + 360 }, Conductor.crochet / 1000, { ease: FlxEase.cubeOut });
}