/*var originalX_GF:Float;
var originalX_Dad:Float;
var minX_GF:Float = -400;
var maxX_GF:Float = 1000;

var minX_Dad:Float = -300;
var maxX_Dad:Float = 750;
function jumpCharacter(char:FlxSprite) {
    var originalY = char.y;
    var jumpHeight = 80; 
    var duration = 0.2; 

    FlxTween.tween(char, { y: originalY - jumpHeight}, duration, {
        ease: FlxEase.quadInOut,
        onComplete: function(_) {
            FlxTween.tween(char, { y: originalY }, duration, {
                ease: FlxEase.sineInOut
            });
        }
    });
}

function postCreate(){
    originalX_GF = gf.x;
    originalX_Dad = dad.x;

}

function onNoteHit(event){
    if (!event.animCancelled){
        for (char in event.characters){
            if (char == gf || char == dad){
                switch(event.direction){
                    case 0, 3: char.velocity.x = (event.direction == 0) ? -200 : 200;
                }
            }
        }
    }
}
function beatHit(){
    if (curBeat % 4 == 2) jumpCharacter(boyfriend);
}
function update(elapsed:Float){
    for (char in [gf, dad]){
       
        char.x += char.velocity.x * elapsed;

        var minX = (char == gf) ? minX_GF : minX_Dad;
        var maxX = (char == gf) ? maxX_GF : maxX_Dad;

       
        if (char.x < minX) char.x = minX;
        if (char.x > maxX) char.x = maxX;

        if (Math.abs(char.velocity.x) < 0.1){
            var targetX = (char == gf) ? originalX_GF : originalX_Dad;
            char.x = lerp(char.x, targetX, elapsed * 5);
        } else {
           
            char.velocity.x *= 0.9;
        }
    }
}
