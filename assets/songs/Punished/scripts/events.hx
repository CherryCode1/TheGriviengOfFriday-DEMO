function postUpdate(elapsed:Float){
    for (strumLine in strumLines){
        for (strum in strumLine){
            strum.scale.set(
                    lerp(strum.scale.x, 0.7, 0.2),
                    lerp(strum.scale.y, 0.7, 0.2)
                );
             strum.y = lerp(strum.y, 50, 0.2);
        }
    }
    for (strumLine in strumLines){
for (note in strumLine.notes){
          note.noteAngle = 0;
		}
    }
		
      
                
   
    /*
    if (curStep > 255){
        if (curStep % 4 == 0)
            FlxTween.tween(camHUD, {y: -15}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
        if (curStep % 4 == 2)
            FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
    } */ 
}
var pirueta;
function stepHit(){
    switch(curStep){
        case 1: camHUD.height = FlxG.height + 15;
        case 248: camGame.fade(FlxColor.BLACK,0.35,false);
        case 255: camGame.fade(FlxColor.BLACK,0.00001,true);
        case 1727: FlxTween.tween(dad,{"scale.x": dad.scale.x + 1, angle: 10}, 2,{ease: FlxEase.sineIn});
        FlxTween.color(dad,1.4,dad.color, FlxColor.RED);
        case 1737:
        pirueta = FlxTween.tween(gf,{angle: gf.angle + 360}, 0.1,{onComplete: resetTween});
        
    }
}
function beatHit(){
    if (curStep > 255){
        if (curBeat % 4 == 0){
              for (strumLine in strumLines){

                for (strum in strumLine){
                    strum.scale.set(1,0.8);
                
                    makeStrumsJump(50);
                    
                }
              }
               
               

        }else if (curBeat%2==0){
            rotateStrums();
        }
    }
}
var firstUp:Bool = false;
function makeStrumsJump(gap:Int) {
    for (strumLine in strumLines)
        for (strum in strumLine)
            strum.y = 50 + (strum.ID % 2 == (firstUp ? 0 : 1) ? gap : -gap);

    firstUp = !firstUp;
}

function rotateStrums() {
    for (strumLine in strumLines)
        for (strum in strumLine)
            FlxTween.tween(strum, { angle: strum.angle + 360 }, Conductor.crochet / 1000, { ease: FlxEase.cubeOut });
}
function resetTween(){
     pirueta = FlxTween.tween(gf,{angle: gf.angle + 360}, 0.1,{onComplete: resetTween});
}