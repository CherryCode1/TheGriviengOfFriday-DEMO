var enabled:Bool;
var angleshit:Float = 1;
var anglevar:Float = 1;
function postCreate()
    enabled = false;
function onEvent(event) {
    if (event.event.name == "camera_bounce") {
        enabled = event.event.params[0];
    }
}
function beatHit(curBeat){
    if (enabled == true)
		if (curBeat < 388){
         
            if (curBeat % 2 == 0)
				angleshit = anglevar;
			else
				angleshit = -anglevar;

            camHUD.angle = angleshit*3;
            camGame.angle = angleshit*3;

            FlxTween.tween(camHUD, {angle: angleshit}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
            FlxTween.tween(camHUD, {x: -angleshit*8}, Conductor.crochet*0.001, {ease: FlxEase.linear});
    
            FlxTween.tween(camGame, {angle: angleshit}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
            FlxTween.tween(camGame, {x: -angleshit*8}, Conductor.crochet*0.001, {ease: FlxEase.linear});
    
        }else{
            FlxTween.tween(camHUD, {angle: 0}, Conductor.stepCrochet*0.2, {ease: FlxEase.circOut});
            FlxTween.tween(camHUD, {x: 0}, Conductor.crochet*0.2, {ease: FlxEase.linear});
    
            FlxTween.tween(camGame, {angle: 0}, Conductor.stepCrochet*0.2, {ease: FlxEase.circOut});
            FlxTween.tween(camGame, {x: 0}, Conductor.crochet*0.2, {ease: FlxEase.linear});
        }
    else{
        FlxTween.tween(camHUD, {angle: 0}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
        FlxTween.tween(camHUD, {x: 0}, Conductor.crochet*0.001, {ease: FlxEase.linear});

        FlxTween.tween(camGame, {angle: 0}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
        FlxTween.tween(camGame, {x: 0}, Conductor.crochet*0.001, {ease: FlxEase.linear});
    }
}