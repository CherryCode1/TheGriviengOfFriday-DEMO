import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite = new FlxVideoSprite();
var camera_Video:FlxCamera = new FlxCamera();
function create(event){
    event.cancel();

    FlxG.sound.music = null;
    camera_Video.bgColor = 0x00000000;
    FlxG.cameras.add(camera_Video, false);
    video.load(Assets.getBytes(Paths.video("Saxophone_Chihuahua")), ['input-repeat=65545']);

    video.play();
  

    video.bitmap.onFormatSetup.add(() -> {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.camera = camera_Video;
        video.bitmap.volume = 1;
        video.screenCenter();
    });

    video.autoVolumeHandle = true;
    add(video);
}
var canPressed:Bool = false;
function update(elapsed:Float) {
    if (controls.ACCEPT && !canPressed) {
      canPressed = true;
      FlxG.switchState(new PlayState()); 
    }
    if (controls.BACK && !canPressed) {
        canPressed = true;
        FlxG.switchState(new FreeplayState());
    }
}