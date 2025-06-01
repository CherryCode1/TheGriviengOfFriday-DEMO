import hxvlc.flixel.FlxVideoSprite;

var camera_Video:FlxCamera = new FlxCamera(); 

function postCreate() {

    FlxG.sound.music.destroy();
    camera_Video.bgColor = 0x00000000;
    FlxG.cameras.add(camera_Video, false);
   
    var video = new FlxVideoSprite();
    video.load(Assets.getBytes(Paths.video(video_Path)));
    video.bitmap.onFormatSetup.add(() -> 
    {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.camera = camera_Video;
        video.bitmap.volume = 1;    
        video.screenCenter();
    });
    video.bitmap.onEndReached.add(() -> 
    {
        video.destroy();
        FlxG.sound.music.pitch = 1;
        FlxG.switchState(new _nextState());
        if (video_Path == "xploshiIntro")  resizeGame(1024, 768);
    });
    video.autoVolumeHandle = true;
    video.play();
   
    add(video);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ENTER) {
        FlxG.switchState(new _nextState());
        if (video_Path == "xploshiIntro")  resizeGame(1024, 768);
    }
}