var notebook_bg:FlxSprite;
public var paperGF:FlxSprite;
public var paperBF:FlxSprite;

function new() {
	notebook_bg = new FlxSprite().loadGraphic(Paths.image("stages/notebook/bg"));
	notebook_bg.scrollFactor.set();
	notebook_bg.scale.set(0.7, 0.7);
	notebook_bg.screenCenter();
	add(notebook_bg);
}
function create(){
	skipCounDown = true;


	noteSkin = "NOTE_assetsDOGGY";
	splashSkin = "default-griv";


}
function postCreate() {
	
	paperBF = new FlxSprite(-300,-300).loadGraphic(Paths.image("stages/notebook/boyfriend"));
	paperBF.scale.set(0.4,0.4);
	paperBF.camera = camOverlay;
	add(paperBF);


	paperGF = new FlxSprite(600,-300).loadGraphic(Paths.image("stages/notebook/gf"));
	paperGF.scale.set(0.4,0.4);
	paperGF.camera = camOverlay;
	add(paperGF);


	paperBF.y = 2000;
	paperGF.y = 2000;

	camGame.zoom = defaultCamZoom = 0.6; //idk why it's not setting this in the stage xml :sob:

	for(strum in cpuStrums) strum.visible = false;
	for(i in 0...4) playerStrums.members[i].x = 420 + (110 * i);

}
public function showPapers() {
	paperBF.angle = -90;
	paperGF.angle = 90;
	for (papers in [paperBF,paperGF]){
		FlxTween.tween(papers, {y: -280,angle: 0},1.4,{ease:FlxEase.circInOut,onComplete: function(){
			new FlxTimer().start(0.4, function(t:FlxTimer) {
				FlxTween.tween(papers, {y: 2000}, 0.6,{ease:FlxEase.circInOut});
			});
		}});
	}
	

}
var _targetPlayerAlpha:Float = 1;
function onPlayerHit(event:NoteHitEvent) _targetPlayerAlpha = 1;
function onDadHit(event:NoteHitEvent) _targetPlayerAlpha = 0.5;
function stepHit(curStep:Int) {
	if(!Options.lowMemoryMode)
		for(i in 0...4) playerStrums.members[i].alpha = lerp(playerStrums.members[i].alpha, _targetPlayerAlpha, 0.4);
}