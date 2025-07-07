var cinematic = new FlxSprite();
var spriteMonkey = new FlxSprite();
var pathSimian:Paths;
function postCreate(){  
    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 
    camGame.zoom = defaultCamZoom = 2;


    pathSimian = Paths.getSparrowAtlas("stages/joy/Miss-Simian");
    spriteMonkey.frames = pathSimian;
    spriteMonkey.animation.addByPrefix("loop", "simian idle", 24, true);
    spriteMonkey.animation.play("loop");
    spriteMonkey.camera = camHUD;
    spriteMonkey.screenCenter();
    spriteMonkey.y += 50;

    cinematic.loadGraphic(Paths.image("stages/joy/Ecena1"));
    cinematic.camera = camHUD;
    cinematic.scale.set(0.5501,0.5501);
    cinematic.screenCenter();
    add(cinematic);
    add(spriteMonkey);

    spriteMonkey.visible = false;
    cinematic.visible = false;

}
function onGameOver(event){
    event.gameOverSong = "GameOver_joy";
    event.retrySFX = "gameOver_joyEND";
    event.lossSFX = "";
}
/*
function onDadHit(event){
    if (event.note.isSustainNote) return;
    if (health > 0.1)
       health -= 0.025;
}
*/
function onSongStart() {
    camHUD.alpha = 0.5;
    defaultCamZoom = 0.6;
}

function stepHit()
{
    switch(curStep)
    {
        case 2332:
            camGame.visible = false;    
    }
}
