var preloadedFrames:Map<String, Dynamic> = [];
var preloadedNames:Map<String, Dynamic> = [];
var daPixelZoom = 6;
var isActuallyPixel = false;

var strumAnimPrefix = ["left", "down", "up", "right"];

function create() {
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
				} else {
				
				}
			}
		}
	}
}

function onEvent(eventEvent) {
	if (eventEvent.event.name == "Change Strum Skin") {
		var skin:String = eventEvent.event.params[0];
		var isPixel:Bool = isActuallyPixel = eventEvent.event.params[1];

		if (!preloadedFrames.exists(skin)) {
			var loaded = isPixel
				? Paths.image("game/pixel/" + skin + "/Notes")
				: Paths.getFrames("game/notes/" + skin);
			if (loaded != null) preloadedFrames.set(skin, loaded);
			else {
				return;
			}
		}

		var frame = preloadedFrames[skin];
		if (frame == null) {
			return;
		}

		for (strumLine in strumLines) {
			for (note in strumLine.notes) {
				if (note == null || note.animation == null) continue;

				var oldAnimName:String = note.animation.name;
				var oldAnimFrame:Int = note.animation.curAnim != null ? note.animation.curAnim.curFrame : 0;

				note.frames = frame;
				note.animation.destroyAnimations();
				var dir = switch (note.noteData % 4) {
				case 0: "purple";
				case 1: "blue";
				case 2: "green";
				case 3: "red";
			};
				if (note.isSustainNote) {
					note.animation.addByPrefix('hold', 'green hold piece');
					note.animation.addByPrefix('holdend', 'green hold end');
				} else {
					note.animation.addByPrefix('scroll', dir + "0");
				}

				var animToPlay = note.isSustainNote ? (note.isEnd ? 'holdend' : 'hold') : 'scroll';
				note.animation.play(animToPlay, true);
				note.scale.set(isPixel ? daPixelZoom : 0.7, isPixel ? daPixelZoom : 0.7);
				note.antialiasing = !isPixel;
				note.updateHitbox();
			}
		}

		for (strumLine in strumLines) {
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
		}
	}
}
