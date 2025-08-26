var iconDarwi:HealthIcon;

function postCreate(){
    iconDarwi = new HealthIcon(gf.getIcon(),false);
    iconDarwi.camera = camHUD;
    iconDarwi.visible = true;
    iconDarwi.active = true;
    insert(members.indexOf(iconP2),iconDarwi);

    iconP2.y -= 60;
    iconP1.y -= 20;
}
function onNoteHit(event){
    if (event.note.isSustainNote) return;
   
    if (!event.animCancelled){
        for(char in event.characters){
        
            if (char == gf){
                iconDarwi.scale.set(1.2,1.2);

                healthBar.createFilledBar(gf.iconColor, boyfriend.iconColor);
                healthBar.updateBar();
            }
            if (char == dad){
                healthBar.createFilledBar(dad.iconColor, boyfriend.iconColor);
                healthBar.updateBar();
            }
        }
    }
}


function postUpdate(elapsed:Float){
    iconDarwi.scale.set(
       lerp(iconDarwi.scale.x,1,0.1),
       lerp(iconDarwi.scale.y,1,0.1)
    );
    iconDarwi.x = iconP2.x + 5;
    iconDarwi.health = iconP2.health;
    iconDarwi.y = iconP2.y + 80;
	iconDarwi.alpha = iconP2.alpha;
}