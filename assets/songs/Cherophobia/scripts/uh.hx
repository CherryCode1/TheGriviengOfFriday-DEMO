var cinematic = new FlxSprite();
var spriteMonkey = new FlxSprite();
var pathSimian:Paths;
var turnOffShader = new CustomShader("tv_off");
var time_ = 0;
var intro_BG2:FlxSprite = new FlxSprite();

function create() {
       turnOffShader.iTime = 0;

    intro_BG2 = new FlxSprite();
    intro_BG2.frames = Paths.getSparrowAtlas("daSTAT");
    intro_BG2.animation.addByPrefix("idle","staticFLASH",24,true);
    intro_BG2.animation.play("idle");
    intro_BG2.camera = camHUD;
    intro_BG2.alpha = 0;
    intro_BG2.setGraphicSize(FlxG.width * 1.01);
    intro_BG2.screenCenter();
    add(intro_BG2);

}

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

function update(elapsed){
    turnOffShader.iTime = time_;
    if (curStep > 2328 && curStep < 2345){
        time_ += elapsed;
    }
}

function stepHit()
{
    switch(curStep)
    {
        case 2228: for (strum in strumLines) for(char in strum.characters)
                char.visible = false;
        case 2245:
            FlxTween.tween(intro_BG2, {alpha: 1}, 1,{ease:FlxEase.circInOut});   
        case 2260:
            FlxTween.tween(intro_BG2, {alpha: 0.4}, 0.4,{ease:FlxEase.circInOut});  
        case 2272:
            FlxTween.tween(intro_BG2, {alpha: 1}, 1,{ease:FlxEase.circInOut});
        case 2288:
            FlxTween.tween(intro_BG2, {alpha: 0.4}, 0.4,{ease:FlxEase.circInOut});   
        case 2296:
            FlxTween.tween(intro_BG2, {alpha: 1}, 1,{ease:FlxEase.circInOut});     
        case 2310:
            FlxTween.tween(intro_BG2, {alpha: 0.4}, 0.4,{ease:FlxEase.circInOut});   
        case 2322:
            FlxTween.tween(intro_BG2, {alpha: 1}, 0.2,{ease:FlxEase.circInOut});       
        case 2332:
            camGame.addShader(turnOffShader);
            camHUD.addShader(turnOffShader);
        case 2336:
            intro_BG2.alpha = 0;
            camGame.visible = false;    
            camHUD.visible = false;
    }
}
