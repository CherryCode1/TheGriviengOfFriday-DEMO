var bf:Character;
var canPressed:Bool = false;
function new(){
    bf = new Character(600,0,"bf-mic-gameover");
    add(bf);

    bf.playAnim("deathLoop",true);

    

}
function update(elapsed:Float) {
 
    if (controls.ACCEPT & !canPressed){
        bf.playAnim("deathConfirm");
        canPressed = true;
    } 
}