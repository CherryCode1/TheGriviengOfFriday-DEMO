function postCreate(){  
    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 
    camGame.zoom = defaultCamZoom = 2;

}
function onDadHit(event){
    if (event.note.isSustainNote) return;
    
    if (health > 0.1)
       health -= 0.025;
}
function onSongStart(){
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
