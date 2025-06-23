var shadowGf;
var shadowBf;
var shadowDad;
function postCreate() {
    strumLines.members[0].characters[2].visible = false;
     strumLines.members[0].characters[2].x += 100;
    gf.x -=120;
    gf.y +=100;
   
    //assing values strums characters
    shadowDad = strumLines.members[0].characters[0];
    shadowBf = strumLines.members[1].characters[0];
    shadowGf = strumLines.members[2].characters[1];
    // setPosition strum clone
    strumLines.members[0].characters[1].setPosition(dad.x,dad.y);
    strumLines.members[0].characters[1].cameraOffset.set(dad.cameraOffset.x,dad.cameraOffset.y- 400);


    strumLines.members[1].characters[1].setPosition(boyfriend.x,boyfriend.y);
    strumLines.members[1].characters[1].cameraOffset.set(boyfriend.cameraOffset.x,boyfriend.cameraOffset.y - 100);

    strumLines.members[2].characters[1].setPosition(gf.x,gf.y);
    strumLines.members[2].characters[1].cameraOffset.set(gf.cameraOffset.x,gf.cameraOffset.y - 400);
    // position shadows

    for (shadow in [shadowDad,shadowBf,shadowGf]) {
        shadow.scale.y -= 0.05;
        shadow.alpha = 0.35;
        shadow.color = FlxColor.fromRGB(193, 199, 159);
        shadow.visible = false;

        switch(shadow) {
            case shadowDad: shadow.setPosition(dad.x + 145,dad.y + 520);
             shadow.angle = 180;
             shadow.flipX = true;
            case shadowBf: shadow.setPosition(boyfriend.x + 250,boyfriend.y + 600);
                   shadow.angle = 180;
             shadow.flipX = true;
            case shadowGf:  shadow.setPosition(gf.x,gf.y + 250);
          
                   shadow.angle = 180;
             shadow.flipX = true;
        }
    }
  
}
function update(){
    shadowGf.visible = gf.visible;
}
public static function changeCumBall(){
    remove(strumLines.members[0].characters[1]);
    strumLines.members[0].characters[2].visible = true;
}
