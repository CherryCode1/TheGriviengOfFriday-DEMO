import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite = new FlxVideoSprite();
var camera_Video:FlxCamera = new FlxCamera();
var restarting:Bool = false;

function create(event){
    event.cancel();

    FlxG.sound.music = null;
    camera_Video.bgColor = 0x00000000;
    FlxG.cameras.add(camera_Video, false);
    
    video.bitmap.onFormatSetup.add(() -> 
    {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.camera = camera_Video;
        video.bitmap.volume = 1;    
        video.screenCenter();
    });

    video.bitmap.onEndReached.add(function() {
        if (!restarting) {
            if (FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('gameOver'));
            playVideo('deathLoop');
        }
        else FlxG.switchState(new PlayState());
    });

    video.autoVolumeHandle = true;
    add(video);

    playVideo('deathStart');
}

function update(elapsed:Float) {
    if (controls.ACCEPT && !restarting) {
        restarting = true;
        FlxG.sound.music.volume = 0;
        FlxG.sound.play(Paths.sound('gameOverEnd'));
        playVideo('deathEnd');
    }

    if (controls.BACK) FlxG.switchState(new FreeplayState());
}

function playVideo(videoName:String) {
    video.load(Assets.getBytes(Paths.video(videoName)));
    video.play();
}