import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite;
var camVideos:FlxCamera;
var neat:FunkinSprite;

var prevAutoPause:Bool;
var videoStartTime:Float = -1;

function postCreate() {

    neat = new FunkinSprite().loadGraphic(Paths.image("stages/xploshi/Affiliation"));
    neat.camera = camVideos;
    neat.scale.x = 0.58;
    neat.scale.y = 0.58;
    neat.updateHitbox();
    neat.visible = false;
    neat.screenCenter();
    add(neat);
    neat.alpha = 0;

    prevAutoPause = FlxG.autoPause;
    FlxG.autoPause = false;

    video = new FlxVideoSprite();
    video.load(Assets.getPath(Paths.video("xploshiCut")));
    video.cameras = [camVideos];
    video.bitmap.onFormatSetup.add(function()
    {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.screenCenter();
    });
    video.alpha = 0;
    add(video);
}

function onSubstateOpen(event)
    if (video != null && paused)
        video.pause();

function onSubstateClose(event)
    if (video != null && paused)
        video.resume();

function focusGained()
    if (video != null && !paused)
        video.resume();

function create() {

    camVideos = new FlxCamera();
    camVideos.bgColor = 0x00000000;
    var camCinematics:FlxCamera = new FlxCamera();
    camCinematics.bgColor = 0;

    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(camVideos, false);
    FlxG.cameras.add(camHUD, false);
    FlxG.cameras.add(camCinematics, false);
    
    camGame.visible = false;
    barBottom = new FlxSprite(1100, 0).makeSolid(FlxG.width, FlxG.height * 2, FlxColor.BLACK);
    barBottom.cameras = [camCinematics];
    barBottom.screenCenter(FlxAxes.Y);
    add(barBottom);
    
    barTop = new FlxSprite(-1100, 0).makeSolid(FlxG.width, FlxG.height * 2, FlxColor.BLACK);
    barTop.cameras = [camCinematics];
    barTop.screenCenter(FlxAxes.Y);
    add(barTop);

    countDownFNF = true;
    noteSkin = "Xploshi_Notes_Tgof";
    splashSkin = "xploshies";
    importScript("data/scripts/countDown_xploshie");

    camHUD.zoom = defaultHudZoom = 0.9;

    strumLines.members[0].characters[0].visible = true;
    strumLines.members[0].characters[1].visible = false;
    strumLines.members[0].characters[2].visible = false;
    strumLines.members[0].characters[3].visible = false;
}

function postUpdate() {
    FlxG.autoPause = prevAutoPause;

    if (FlxG.autoPause) {
        if (!FlxG.signals.focusLost.has(video.pause))
            FlxG.signals.focusLost.add(video.pause);

        if (!FlxG.signals.focusGained.has(focusGained))
            FlxG.signals.focusGained.add(focusGained);
    }
    
    if (video != null && video.playing && videoStartTime >= 0) {
        var expectedTime = (Conductor.songPosition / 1000) - videoStartTime;
        var difference = Math.abs(video.time - expectedTime);
        if (difference > 0.05) {
            video.time = expectedTime;
        }
    }

    for (strum in strumLines) {
        for (i in [0, 1, 2, 3]) {
            strum.members[i].y = 0;
        }
    }
}

function stepHit(step) {

    switch (step) {
        case 16: 
            camGame.visible = true;
            neat.visible = true;
            FlxTween.tween(neat, {alpha: 1}, 0.4);
            FlxTween.tween(neat.scale, {x: 0.8, y: 0.8}, 4);
            FlxTween.tween(neat, {alpha: 0}, 1, {startDelay: 3});

        case 1040:
            FlxTween.tween(camHUD, {alpha: 0}, 1);

        case 1050:
            video.play();
            video.alpha = 1;
            videoStartTime = Conductor.songPosition / 1000;

        case 1168:
            video.destroy();
            video.alpha = 0;
            camHUD.alpha = 1;
            videoStartTime = -1;
            strumLines.members[1].characters[0].visible = false;
            strumLines.members[1].characters[1].visible = true;
        

        case 2320:
            FlxTween.tween(camGame, {zoom: 1.2}, (Conductor.stepCrochet / 1000) * 16, {
                ease: FlxEase.sineInOut,
                onComplete: function() {
                    defaultCamZoom = camGame.zoom;
                }
            });

        case 2336:
            FlxTween.tween(camGame, {zoom: 1.4}, (Conductor.stepCrochet / 1000) * 4, {
                ease: FlxEase.quadOut,
                onComplete: function() {
                    defaultCamZoom = 1.4;
                    new FlxTimer().start((Conductor.stepCrochet / 1000) * 5, () -> {
                        for (cams in [camHUD, camGame]) {
                            cams.shake(0.02, (Conductor.stepCrochet / 1000) * 8);
                        }
                    });
                    FlxTween.tween(camGame, {zoom: 0.95}, (Conductor.stepCrochet / 1000) * 8, {
                        ease: FlxEase.circInOut,
                        onComplete: function() {
                            defaultCamZoom = 0.95;
                            FlxTween.tween(camGame, {zoom: 2}, (Conductor.stepCrochet / 1000) * 4, {
                                ease: FlxEase.expoIn,
                                onComplete: function() {
                                    defaultCamZoom = 0.6;
                                    camGame.zoom = 0.6;
                                }
                            });
                        }
                    });
                }
            });
    }
}
