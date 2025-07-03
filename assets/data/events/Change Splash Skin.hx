var skin_Splash:String = "default";
function onEvent(eventEvent) {
	if (eventEvent.event.name == "Change Splash Skin") {
	   skin_Splash = eventEvent.event.params[0];
	}
}
function onNoteHit(event){
	event.note.splash = skin_Splash;
}