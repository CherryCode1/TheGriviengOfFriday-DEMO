import flixel.math.FlxBasePoint;

var glitchShaderIntensity:Float = 0;

function onNoteHit(event) {
 if (event.noteType != "glitch_note")  return;
   
 for (i in [0,1,2,3]){
    strumLines.members[0].members[i].setPosition(defaultOpponentStrum[i].x + FlxG.random.int(-8,8),defaultOpponentStrum[i].y + FlxG.random.int(-8,8));
    strumLines.members[1].members[i].setPosition(defaultPlayerStrum[i].x + FlxG.random.int(-8,8),defaultPlayerStrum[i].y + FlxG.random.int(-8,8));
   
  }
}