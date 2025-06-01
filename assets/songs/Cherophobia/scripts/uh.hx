function postCreate(){  
    camGame._fxFadeAlpha = 1;
    camGame._fxFadeColor = FlxColor.BLACK; 
    camGame.zoom = defaultCamZoom = 2;

}
function onSongStart(){
    camHUD.alpha = 0.5;
    defaultCamZoom = 0.6;
}
