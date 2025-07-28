import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import funkin.backend.utils.Paths;

var preloadedFrames:Map<String, Dynamic> = [];
var pendingSkin:String = null;
var pendingPixel:Bool = false;

var daPixelZoom:Int = 6;
var isActuallyPixel:Bool = false;
var strumAnimPrefix = ["left", "down", "up", "right"];

function onEvent(eventEvent) {
	if (eventEvent.event.name == "Change Strum Skin") {
		var skin:String = eventEvent.event.params[0];
		var isPixel:Bool = eventEvent.event.params[1];

		trace("Change Strum Skin triggered: " + skin + ", isPixel: " + isPixel);

		isActuallyPixel = isPixel;
		pendingSkin = skin;
		//pendingPixel = isPixel;
	}
}

function update(elapsed:Float) {
	if (pendingSkin != null) {
		var skin:String = pendingSkin;
		var isPixel:Bool = pendingPixel;

		if (!preloadedFrames.exists(skin)) {
			var loaded = isPixel
				? Paths.image("game/pixel/" + skin + "/Notes")
				: Paths.getSparrowAtlas("game/notes/" + skin);

			if (loaded != null) {
				preloadedFrames.set(skin, loaded);
				trace("Loaded frames for skin: " + skin);
			} else {
				trace("Frames not yet loaded for skin: " + skin + ", will retry next update");
				return;
			}
		}

		var frame = preloadedFrames.get(skin);
		if (frame == null) {
			trace("Frame still null for skin: " + skin + ", will retry next update");
			return;
		}

		trace("Applying strum skin change: " + skin);

		for (strumLine in strumLines) {
			if (strumLine == null || strumLine.notes == null || strumLine.members == null) continue;

			for (i => strum in strumLine.members) {
				if (strum == null || strum.animation == null) continue;

				var oldAnimName = strum.animation.name;
				var oldAnimFrame = strum.animation.curAnim != null ? strum.animation.curAnim.curFrame : 0;

				if (isPixel) {
					strum.loadGraphic(frame, true, 17, 17);
					strum.animation.add("static", [strum.ID]);
					strum.animation.add("pressed", [4 + strum.ID, 8 + strum.ID], 12, false);
					strum.animation.add("confirm", [12 + strum.ID, 16 + strum.ID], 24, false);
					strum.antialiasing = false;
				} else {
					strum.frames = frame;
					strum.animation.destroyAnimations();
					strum.animation.addByPrefix("static", "arrow" + strumAnimPrefix[i % 4].toUpperCase());
					strum.animation.addByPrefix("pressed", strumAnimPrefix[i % 4] + " press", 24, false);
					strum.animation.addByPrefix("confirm", strumAnimPrefix[i % 4] + " confirm", 24, false);
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

				var oldAnimName = 'scroll';
				var oldAnimFrame = 0;

				if (note.animation.curAnim != null) {
					oldAnimName = note.animation.curAnim.name;
					oldAnimFrame = note.animation.curAnim.curFrame;
				}

				if (!isPixel)
					note.frames = frame;

				note.animation.destroyAnimations();

				var dir = switch (note.noteData % 4) {
					case 0: "purple";
					case 1: "blue";
					case 2: "green";
					case 3: "red";
				};

				note.animation.addByPrefix("hold", dir + " hold piece");
				note.animation.addByPrefix("holdend", (dir == "purple") ? "pruple end hold0" : dir + " hold end");

				note.animation.addByPrefix("scroll", dir + "0");
				
				note.animation.play(oldAnimName);
				if (note.animation.curAnim != null)
					note.animation.curAnim.curFrame = oldAnimFrame;

				note.scale.set(isPixel ? daPixelZoom : 0.7, isPixel ? daPixelZoom : 0.7);
				note.antialiasing = !isPixel;
				note.updateHitbox();
			}
		}

		pendingSkin = null;
	}
}
