function postCreate(){  
    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 
    camGame.zoom = defaultCamZoom = 2;

}
function onSongStart(){
    camHUD.alpha = 0.5;
    defaultCamZoom = 0.6;
}
function stepHit()
{
    switch(curStep)
    {
        case 648:
            iconP1.visible = iconP2.visible = true;
        case 2332:
            camGame.visible = false;    
    }
}
