var preloadedCharacters:Map<String, Character> = [];
var preloadedIcons:Map<String, FlxSprite> = [];

function postCreate() {
    for (icon in [iconP1, iconP2]) {
        if (icon.animation == null || icon.animation.name == null) continue;
        
        preloadedIcons.set(icon.animation.name + (icon == iconP1 ? "-player" : ""), icon);
    }
    for (event in PlayState.SONG.events) {
        if (event.name != "Change Character") continue;

        var preExistingCharacter:Bool = false;
        for (strum in strumLines)
            for (char in strum.characters)
                if (char.curCharacter == event.params[1]) {
                    preloadedCharacters.set(event.params[1], char);
                    preExistingCharacter = true;
                    break;
                }

        var oldCharacter = strumLines.members[event.params[0]].characters[0];
        // Create New Character
        if (!preExistingCharacter) {
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, event.params[1], oldCharacter.isPlayer);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera); // Push to GPU
            preloadedCharacters.set(event.params[1], newCharacter);
            
            //Adjust Camera Offset to Accomedate Stage Offsets
            if(newCharacter.isGF) {
                newCharacter.cameraOffset.x += stage.characterPoses["gf"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["gf"].camyoffset;
            } else if(newCharacter.playerOffsets){
                newCharacter.cameraOffset.x += stage.characterPoses["boyfriend"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["boyfriend"].camyoffset;
            } else {
                newCharacter.cameraOffset.x += stage.characterPoses["dad"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["dad"].camyoffset;
            }
        }
        
        // Create New Icon
        var character:Character = preloadedCharacters.get(event.params[1]) ?? oldCharacter;
        var iconName:String = character.getIcon() + (character.isPlayer ? "-player" : "");
        if (preloadedIcons.exists(iconName)) continue;

        var newIcon:HealthIcon = new HealthIcon(character.getIcon(), character.isPlayer);
        newIcon.y = healthBar.y - (newIcon.height / 2);
        newIcon.active = newIcon.visible = false;
        newIcon.drawComplex(FlxG.camera); // Push to GPU
        newIcon.cameras = [camHUD];
        preloadedIcons.set(iconName, newIcon);
    }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Change Character") {
        // Change Character
        var oldCharacter;
        oldCharacter = strumLines.members[params[0]].characters[0];

        if (!FlxG.save.data.Shadows) {
            trace("esto esta funcionando");
            oldCharacter = strumLines.members[params[0]].characters[1];
        }

        var newCharacter = preloadedCharacters.get(params[1]);
        if (oldCharacter.curCharacter == newCharacter.curCharacter) return;

        insert(members.indexOf(oldCharacter), newCharacter);
        newCharacter.active = newCharacter.visible = true;
        remove(oldCharacter);

        newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
        newCharacter.playAnim(oldCharacter.animation.name);
        newCharacter.animation?.curAnim?.curFrame = oldCharacter.animation?.curAnim?.curFrame;
        strumLines.members[params[0]].characters[0] = newCharacter;
        if (params[2]){
        // Change Icon
        var oldIcon = oldCharacter.isPlayer ? iconP1 : iconP2;
        var newIcon = preloadedIcons.get(newCharacter.getIcon() + (oldCharacter.isPlayer ? "-player" : ""));

        if (oldIcon.animation?.name == newIcon.animation?.name) return;
     
            insert(members.indexOf(oldIcon), newIcon);
            newIcon.active = true;
            newIcon.visible =  oldIcon.visible;
            newIcon.alpha = oldIcon.alpha;
           
            remove(oldIcon);
            if (oldCharacter.isPlayer) iconP1 = newIcon;
            else iconP2 = newIcon;
    
       
     
         var leftColor:Int = dad != null && dad.visible && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : 0xFF000000;
         var rightColor:Int = boyfriend != null && boyfriend.visible && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : 0xFF000000;
         healthBar.createFilledBar(leftColor, rightColor);
         healthBar.updateBar();
        }
    }
}