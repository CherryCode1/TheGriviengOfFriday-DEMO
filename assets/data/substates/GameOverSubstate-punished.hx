import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite = new FlxVideoSprite();
var camera_Video:FlxCamera = new FlxCamera();
var restarting:Bool = false;
var curVideoName:String = "";

function create(event){
    event.cancel();

    FlxG.sound.music = null;
    camera_Video.bgColor = 0x00000000;
    FlxG.cameras.add(camera_Video, false);
    
    video.bitmap.onFormatSetup.add(() -> {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.camera = camera_Video;
        video.bitmap.volume = 1;
        video.screenCenter();
    });

    video.autoVolumeHandle = true;
    add(video);

    playVideo('deathStart');
}

function update(elapsed:Float) {
    if (controls.ACCEPT && !restarting) {
        restarting = true;
        playVideo('deathEnd');
    }

    if (controls.BACK) FlxG.switchState(new FreeplayState());
}

function playVideo(videoName:String, loop:Bool = false) {
    curVideoName = videoName;

    if (!loop)
        video.load(Assets.getBytes(Paths.video(videoName)));
    else
        video.load(Assets.getBytes(Paths.video(videoName)), ['input-repeat=65545']);

    video.play();

    video.bitmap.onEndReached.add(function() {
        if (!restarting && curVideoName == 'deathStart') {
            playVideo('deathLoop', true);
        } else if (restarting && curVideoName == 'deathEnd') {
            FlxG.switchState(new PlayState());
        }
    });
}
