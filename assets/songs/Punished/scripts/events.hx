var canMove:Bool = false;
var canMove1:Bool = false;

function postCreate() { 
    camGame.alpha = 0;
   
}

function postUpdate(elapsed:Float){
    for (strumLine in strumLines){
        for (strum in strumLine){
            strum.scale.set(
                    lerp(strum.scale.x, 0.6, 0.2),
                    lerp(strum.scale.y, 0.6, 0.2)
                );
             strum.y = lerp(strum.y, 75, 0.2);
        }
    }
    for (strumLine in strumLines){
        for (note in strumLine.notes){
                note.noteAngle = 0;
        }
    }

    if(canMove){
        boyfriend.velocity.x = -35;
        boyfriend.x += boyfriend.velocity.x * elapsed;
    }
    else {
        boyfriend.velocity.x = 0;
    }

    if(canMove1){
        gf.velocity.x = 20;
        gf.x += gf.velocity.x * elapsed;
    }
    else {
        gf.velocity.x = 0;
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
        case 1: camHUD.height = FlxG.height + 15;     camGame.alpha = 1;
        case 255: camGame.fade(FlxColor.BLACK,0.00001,true);
        case 512:
            camGame.flash(0xFFFFFFFF, 3);

            boyfriend.cameras = [camHUD];
            boyfriend.setPosition(FlxG.width, 195);
            canMove = true;
            boyfriend.scale.set(4, 4);
            boyfriend.alpha = 0.4;
            FlxTween.tween(camFollow, {x: 115}, 0.0001);

            FlxG.camera.zoom = defaultCamZoom = 0.95;
            camFollowChars = false;
        case 640:
            boyfriend.cameras = [camGame];
            boyfriend.setPosition(610, 65);
            boyfriend.scale.set(1.5, 1.5);
            boyfriend.alpha = 1;
            canMove = false;
            camGame.flash(0xFFFFFFFF, 2);

            gf.cameras = [camHUD];
            gf.setPosition(-400, -200);
            canMove1 = true;
            gf.scale.set(3.8, 3.8);
            gf.alpha = 0.4;   
            FlxTween.tween(camFollow, {x: 625}, 0.0001);
        case 768:
            camGame.flash(0xFFFFFFFF, 2);

            gf.cameras = [camGame];
            gf.setPosition(-350, 90);
            gf.scale.set(1.3, 1.3);
            gf.alpha = 1;
            canMove1 = false;
            FlxG.camera.zoom = defaultCamZoom = 0.8;
            camFollowChars = true;

           FlxTween.tween(camFollow, {x: 515}, 0.0001);
        case 786:
            dad.playAnim('speak');
        case 854:
            dad.playAnim('idle');
        case 866:
            gf.playAnim('speak');
        case 1652:
            camFollowChars = false;
            FlxTween.tween(camGame, {zoom: 0.73}, 1.5, {ease: FlxEase.sineInOut, onUpdate: function(value) {defaultCamZoom = FlxG.camera.zoom; }});
            FlxTween.tween(camFollow, {x: 330, y: 410}, 1.5, {ease: FlxEase.sineInOut});
        case 1676:
            camGame.fade(FlxColor.BLACK,2,false);
        case 1716:
            FlxTween.tween(camFollow, {x: 115}, 0.0001);
            FlxG.camera.zoom = defaultCamZoom = 1;
        case 1727: 
            camGame.fade(FlxColor.BLACK,0.00001,true);
            FlxTween.tween(dad,{"scale.x": dad.scale.x + 1, angle: 10}, 2,{ease: FlxEase.sineIn});
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
                    strum.scale.set(0.6,0.4);
                
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