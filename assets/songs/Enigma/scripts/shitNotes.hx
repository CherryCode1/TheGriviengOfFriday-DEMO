function onNoteCreation(noteCreateEvent) {
    if (noteCreateEvent.strumID >= 0){
        noteCreateEvent.note.forceIsOnScreen = false;
    }
}

function onPostStrumCreation(event:StrumCreationEvent){
   
    for (notes in [0,1,2,3]) {
        var strum  = strumLines.members[3].members[notes];
        strum.x = -500;
        strum.x += notes * 100; 
        strum.y = 120;
        strum.scrollFactor.set(1, 1);
      
    }
  
    var strum  =  strumLines.members[3]; 
    strum.cameras = camGame;
    strum.visible = false;
}


function postCreate(){
    if (strumLines.members[3] != null) {
        for (shit in strumLines.members[3].notes)  {
           shit.alpha = 0.5;
        }
    }
}