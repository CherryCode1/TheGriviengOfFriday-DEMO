import hxvlc.flixel.FlxVideoSprite;

function create() 
{
    grade_intensity = 1;
    blueness.alpha = 0.8;

    camGame.fade(FlxColor.BLACK,4,true);
  
}
function postCreate(){
    logo.alpha = 0.2;

    gf.cameraOffset.x += 150;
    gf.cameraOffset.y -= 120;
 
    var video = new FlxVideoSprite(0, 0);
    video.load(Assets.getPath(Paths.video('cutcene_MAS')), [':no-audio']);
    video.play();
    video.visible = false;
    add(video);
}

function stepHit()
{
    switch(curStep)
    {
        case 2140:
            var video = new FlxVideoSprite(0, 0);
            video.load(Assets.getPath(Paths.video('cutcene_MAS')));
            video.bitmap.onFormatSetup.add(function():Void {
                if (video.bitmap != null && video.bitmap.bitmapData != null) {	
                    video.antialiasing = false;
                    video.setGraphicSize(FlxG.width, FlxG.height);
                    video.updateHitbox();
                    video.screenCenter();
                    video.alpha = 0;
                    video.camera = camHUD;
                    FlxTween.tween(video, {alpha: 1}, 1);
                }
            });

            video.bitmap.onEndReached.add(function() {
                video.destroy();  
            });
            video.play();

            insert(members.indexOf(strumLines), video);
    }
}