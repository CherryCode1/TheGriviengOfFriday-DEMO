var iconMononoise:HealthIcon;

function postCreate(){
    iconMononoise = new HealthIcon("mononoise",false);
    iconMononoise.camera = camHUD;
    iconMononoise.visible = false;
    iconMononoise.active = true;
    insert(members.indexOf(iconP2),iconMononoise);
}

function onNoteHit(event){
    if (event.note.isSustainNote) return;
   
    if (curStep > 271) {
        if (!event.animCancelled){
            for(char in event.characters){
                if (char == strumLines.members[3].characters[0]){
                    iconMononoise.scale.set(1.2,1.2);
                    iconMononoise.visible = true;
                    iconP2.visible = false;
                    healthBar.createFilledBar(strumLines.members[3].characters[0].iconColor, boyfriend.iconColor);
                    healthBar.updateBar();
                }
                if (char == dad){
                    iconMononoise.visible = false;
                    iconP2.visible = true;
                    healthBar.createFilledBar(dad.iconColor, boyfriend.iconColor);
                    healthBar.updateBar();
                }
            }
        }
    }
}

function postUpdate(elapsed:Float){
    iconMononoise.scale.set(
       lerp(iconMononoise.scale.x,1,0.1),
       lerp(iconMononoise.scale.y,1,0.1)
    );
    iconMononoise.x = iconP2.x;
    iconMononoise.health = iconP2.health;
    iconMononoise.y = iconP2.y;
	iconMononoise.alpha = iconP2.alpha;
}