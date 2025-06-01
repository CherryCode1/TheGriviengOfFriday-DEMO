// This script was going to be used in Red Mist but there is only 1 strum note in the 
// spritesheet and I would rather have the notes exported again than having to modify 
// the spritesheet myself or having to add an exception for this kind of notes, although 
// the latter doesn't sound so bad, it might result in a rather messy code in the end -EstoyAburridow


public var noteSkin:String = "default";
public var splashSkin:String = "default";

function create() {
	if (stage != null && stage.stageXML != null) {
		if (stage.stageXML.exists("noteSkin")) noteSkin = stage.stageXML.get("noteSkin");
		if (stage.stageXML.exists("splashSkin")) splashSkin = stage.stageXML.get("splashSkin");
	}
}

function onStrumCreation(strumEvent) strumEvent.sprite = "game/notes/" + noteSkin;
function onNoteCreation(e) {
	if (e.noteType != null && Assets.exists(Paths.image("game/notes/types/" + e.noteType)))
		e.noteSprite = "game/notes/types/" + e.noteType;
	else e.noteSprite = "game/notes/" + noteSkin;
	e.note.splash = splashSkin;
}
function onPostNoteCreation(e) {
	e.note.useAntialiasingFix = true;
	if(e.note.gapFix != null)
		e.note.gapFix = 2;
}
