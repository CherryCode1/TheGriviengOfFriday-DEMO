import openfl.filters.BlurFilter;

var houseStuff:Array<String> = ['overworld', 'outsidehouse', 'house'];
var path = 'stages/clown/';

var sprites:Array<Strings> = ['bf', 'dad', 'overworld', 'outsidehouse', 'house'];
var debugTxt:FunkinText = new FunkinText(10, 10, FlxG.width, '', 40);
var daRealSprites:Array<FlxSprite> = [];
var selectedSprite:Int = 0;
var mult:Int = 1;

var gumballCamera:FlxCamera = new FlxCamera();
var houseFilter:BlurFilter = new BlurFilter(10, 10, 2);
var gumballFilter:BlurFilter = new BlurFilter(0, 0, 2);
function create() {
    healthBarDefault = true;
    noteSkin = "NOTE_assetsEXTRAS";
    splashSkin = "default-griv";
  
}
function postCreate() {
    
    gumballCamera.bgColor = FlxColor.TRASPARENT;
    gumballCamera.zoom = FlxG.camera.zoom + 0.2;
    FlxG.cameras.insert(gumballCamera, 1,false);

   
    FlxG.camera.setFilters([houseFilter]);
    gumballCamera.setFilters([gumballFilter]);

    for (i in 0...houseStuff.length) {
        var asset:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path + houseStuff[i]));
        insert((i < 2) ? i : members.indexOf(dad) + 1, asset);
        daRealSprites.push(asset);
    }

    debugTxt.cameras = [camHUD];
    debugTxt.visible = false;
    add(debugTxt);

    dad.setPosition(600, 890);// 190
    boyfriend.setPosition(650, 230);
    boyfriend.cameras = [gumballCamera];

    iconP1.flipX  = true;

    comboGroup.x += 450;
    comboGroup.y += 200;

}

function onGameOver() {
    gumballCamera._filters = FlxG.camera._filters = [];
}

function update(elapsed) {
   

    if (FlxG.keys.justPressed.NINE) debugTxt.visible = !debugTxt.visible;

    if (debugTxt.visible) {
        if (FlxG.keys.justPressed.TAB) {
            selectedSprite++;
            if (selectedSprite >= sprites.length) selectedSprite = 0;
        }

        if (FlxG.keys.justPressed.SHIFT)
            mult = (mult == 1)? 10 : 1;

        var sprite:FlxSprite = (selectedSprite == 0) ? boyfriend : (selectedSprite == 1) ? dad : daRealSprites[selectedSprite];
        if (FlxG.keys.justPressed.T)
            sprite.y -= mult;
        if (FlxG.keys.justPressed.F)
            sprite.x -= mult;
        if (FlxG.keys.justPressed.G)
            sprite.y += mult;
        if (FlxG.keys.justPressed.H)
            sprite.x += mult;

        debugTxt.text = sprites[selectedSprite] + ' pos: [' + sprite.x + ', ' + sprite.y + '], mult: ' + mult;
    }

    gumballCamera.focusOn(FlxG.camera.scroll);
    gumballCamera.angle = FlxG.camera.angle;
    var zoomCamera = FlxG.camera.zoom + 0.2;
    gumballCamera.zoom = zoomCamera;
    if (curCameraTarget != 0) setCamerasFilter(10, 0)
    else setCamerasFilter(0, 10);
}
function postUpdate(elapsed)  comboGroup.cameras = [gumballCamera];
function setCamerasFilter(houseBlur:Int, gumballBlur:Int) {
    houseFilter.blurX = FlxMath.lerp(houseFilter.blurX, houseBlur, 0.05);
    houseFilter.blurY = FlxMath.lerp(houseFilter.blurY, houseBlur, 0.05);
    gumballFilter.blurX = FlxMath.lerp(gumballFilter.blurX, gumballBlur, 0.05);
    gumballFilter.blurY = FlxMath.lerp(gumballFilter.blurY, gumballBlur, 0.05);
}

function onCameraMove()
{
    if(curCameraTarget == 0) defaultCamZoom = 0.8;
    else defaultCamZoom = 0.65;
}