function create() 
{
    grade_intensity = 1;
    blueness.alpha = 0.8;

    camGame.fade(FlxColor.BLACK,4,true);
  
}
function postCreate(){
    logo.alpha = 0.2;

    gf.cameraOffset.x -= 250;
    gf.cameraOffset.y += 50;
 
}