var preloadedFrames:Map<String, Dynamic> = [];
var preloadedNames:Map<String, Dynamic> = [];
var daPixelZoom = 6;
var isActuallyPixel = false;

var strumAnimPrefix = ["left", "down", "up", "right"];

function create() {
	// Puedes precargar skins desde aquí si lo deseas, pero NO accedas a strumLines aquí.
	for (event in PlayState.SONG.events) {
		if (event.name == "Change Strum Skin") {
			var skin = event.params[0];
			var isPixel = event.params[1];

			if (!preloadedFrames.exists(skin)) {
				var loaded = isPixel
					? Paths.image("game/pixel/" + skin + "/Notes")
					: Paths.getFrames("game/notes/" + skin);
				if (loaded != null) {
					preloadedFrames.set(skin, loaded);
					preloadedNames.set(skin, skin);
				}
			}
		}
	}
}

function onEvent(eventEvent) {
	if (eventEvent.event.name == "Change Strum Skin") {
		var skin:String = eventEvent.event.params[0];
		var isPixel:Bool = isActuallyPixel = eventEvent.event.params[1];

		// Precargar si no existe aún
		if (!preloadedFrames.exists(skin)) {
			var loaded = isPixel
				? Paths.image("game/pixel/" + skin + "/Notes")
				: Paths.getFrames("game/notes/" + skin);
			if (loaded != null)
				preloadedFrames.set(skin, loaded);
			else
				return;
		}

		var frame = preloadedFrames[skin];
		if (frame == null) return;



		for (strumLine in strumLines) {
		    if (strumLine == null || strumLine.notes == null || strumLine.members == null) continue;

			trace("change strum: " + skin);
			

			for (i => strum in strumLine.members) {
				if (strum == null || strum.animation == null) continue;

				var oldAnimName:String = strum.animation.name;
				var oldAnimFrame:Int = strum.animation.curAnim != null ? strum.animation.curAnim.curFrame : 0;

				if (isPixel) {
					strum.loadGraphic(frame, true, 17, 17);
					strum.animation.add("static", [strum.ID]);
					strum.animation.add("pressed", [4 + strum.ID, 8 + strum.ID], 12, false);
					strum.animation.add("confirm", [12 + strum.ID, 16 + strum.ID], 24, false);
					strum.antialiasing = false;
				} else {
					strum.frames = frame;
					strum.animation.destroyAnimations();
					strum.animation.addByPrefix('static', 'arrow' + strumAnimPrefix[i % 4].toUpperCase());
					strum.animation.addByPrefix('pressed', strumAnimPrefix[i % 4] + ' press', 24, false);
					strum.animation.addByPrefix('confirm', strumAnimPrefix[i % 4] + ' confirm', 24, false);
					strum.antialiasing = true;
				}

				strum.scale.set(isPixel ? daPixelZoom : 0.7, isPixel ? daPixelZoom : 0.7);
				strum.updateHitbox();
				strum.playAnim(oldAnimName, true);
				if (strum.animation.curAnim != null)
					strum.animation.curAnim.curFrame = oldAnimFrame;
			}
			
			for (note in strumLine.notes) {
				if (note == null || note.animation == null) continue;
				var oldAnimName:String = 'scroll';
				var oldAnimFrame:Int = 0;

				if (note.animation.curAnim != null) {
					oldAnimName = note.animation.curAnim.name;
					oldAnimFrame = note.animation.curAnim.curFrame;
				}
				
				if (!isPixel) note.frames = frame;
				note.animation.destroyAnimations();
				var dir = switch (note.noteData % 4) {
					case 0: "purple";
					case 1: "blue";
					case 2: "green";
					case 3: "red";
				};
				note.animation.addByPrefix('hold', dir + ' hold piece');
				if (note.noteData == 0) note.animation.addByPrefix('holdend', 'pruple end hold');
				else note.animation.addByPrefix('holdend', dir + ' hold end');
				note.animation.addByPrefix('scroll', dir + "0");
				note.animation.play(oldAnimName);
				note.scale.set(isPixel ? daPixelZoom : 0.7, isPixel ? daPixelZoom : 0.7);
				note.antialiasing = !isPixel;
				note.updateHitbox();
			}
		}
		
	}
}
