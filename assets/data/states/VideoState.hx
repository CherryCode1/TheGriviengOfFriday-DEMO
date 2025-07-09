import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite = new FlxVideoSprite();
var camera_Video:FlxCamera = new FlxCamera(); 

function create() {
    FlxG.sound.music.destroy();
    camera_Video.bgColor = 0x00000000;
    FlxG.cameras.add(camera_Video, false);
   
    video.load(Assets.getBytes(Paths.video(video_Path)));
    video.bitmap.onFormatSetup.add(() -> 
    {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.camera = camera_Video;
        video.bitmap.volume = 1;    
        video.screenCenter();
    });
    video.bitmap.onEndReached.add(skipVideo);
    video.autoVolumeHandle = true;
    video.play();
   
    add(video);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ENTER) skipVideo();
}

function skipVideo() {
    video.destroy();
    FlxG.sound.music.pitch = 1;
    FlxG.switchState(new _nextState());
}