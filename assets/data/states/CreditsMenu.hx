import haxe.format.JsonParser;
import flixel.math.FlxPoint;
import flixel.text.FlxTextAlign;
import flixel.util.FlxAxes;
import flixel.text.FlxTextBorderStyle;

/**

 //Structure Json File -- uh maybe changes on release mod - Alan//
 
 {
 "sections": [
    {
      "section": "Musicians",
      "credits": [
        {
          "image": "",
          "name": "",
          "position": { "x": 100, "y": 200 },
          "scale": 1.0,
          "angle": 0,
          "link": ""
        }
      ]
    }
  ]
}

**/
var creditsData:Array<Dynamic>;
var camHUD:FlxCamera;

var bg:FlxSprite;
var bg_section:FlxSprite;
var decoration:FlxSprite;
var overlay:FlxSprite;
var light_:FlxSprite;
var grpSection:FlxTypedGroup<FlxSprite>;
var grpCredit_sprite:Array<FlxTypedGroup<FlxSprite>> = [];
public static var curSelected:Int = 0;
public static var curSection:Int = 0;

var scale_Credts:Array<Array<Float>> = [];
var box_Info:FlxSprite;
var textCredit:FlxText;

function create(){
    changePrefix("Credits");

    creditsData = [];
    creditsData = daShitJson('info/credits');
    trace(creditsData);

    bg = new FlxSprite().loadGraphic(Paths.image("menus/credits/background"));
    add(bg);

    bg_section = new FlxSprite().loadGraphic(Paths.image("menus/credits/section/bg"));
    add(bg_section);

    decoration = new FlxSprite().loadGraphic(Paths.image("menus/credits/decoration"));
    add(decoration);
    
    grpSection = new FlxTypedGroup();
    add(grpSection);


    
    for (i in 0...creditsData.sections.length){
        if (creditsData == null) return; // its return if value creditsData is null
        trace("Section.. " + i);
        

        var item = new FlxSprite().loadGraphic(Paths.image("menus/credits/section/" + creditsData.sections[i].section));
        item.scale.set(0.5,0.5);
        item.updateHitbox();
        item.screenCenter();
        item.ID = i;
        item.visible = (i == curSection) ? true : false; 
        grpSection.add(item);
      

        var group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
        add(group);
        group.visible = (i == curSection) ? true : false; 
        grpCredit_sprite.push(group);

        for (o in 0...creditsData.sections[i].credits.length){
            if (scale_Credts[i] == null)
                 scale_Credts[i] = [];
            var sprite = new FlxSprite().loadGraphic(Paths.image("menus/credits/portraits/" + creditsData.sections[i].credits[o].image));
            var sexy_position:Array<Float> = (creditsData.sections[i].credits[o].position == null) ? [0,0] : [creditsData.sections[i].credits[o].position.x,creditsData.sections[i].credits[o].position.y];
            var sexy_scale:Float = (creditsData.sections[i].credits[o].scale == null) ? 1 : creditsData.sections[i].credits[o].scale;
            scale_Credts[i][o] = sexy_scale;
            sprite.scale.set(sexy_scale,sexy_scale);
            sprite.updateHitbox();
            sprite.setPosition(sexy_position[0],sexy_position[1]);
            sprite.angle = (creditsData.sections[i].credits[o].angle == null) ? 0 : creditsData.sections[i].credits[o].angle;
            sprite.ID = o;
            grpCredit_sprite[i].add(sprite);
           
            //grpCredit_sprite.add(sprite);
        }

    }

    box_Info = new FlxSprite().makeGraphic(200,210,FlxColor.BLACK);
    box_Info.alpha = 0;
    add(box_Info);


    textCredit = new FlxText(box_Info.x, box_Info.y, box_Info.width - 15, "");
    textCredit.setFormat(Paths.font('CascadiaMonoPL-Bold.otf'), 14, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    textCredit.borderSize = 0;
    textCredit.wordWrap = true;
    add(textCredit);

    overlay = new FlxSprite().loadGraphic(Paths.image("menus/credits/overlay"));
    add(overlay);


    light_ = new FlxSprite().loadGraphic(Paths.image("menus/credits/Lights"));
    add(light_);


    for (sprites in [bg,overlay,light_,bg_section,decoration])
    {
        sprites.scale.set(0.5,0.5);
        sprites.updateHitbox();
        sprites.screenCenter();
       // sprites.x += 20;
    }
}

var pressedInfo:Bool = false;
var targetMove:Bool = false;
function update(elapsed:Float){
 
    grpCredit_sprite[curSection].forEach(
        function(spriteCred:FlxSprite) 
        {
            if (FlxG.mouse.overlaps(spriteCred)){
           
                textCredit.x = box_Info.x + (box_Info.width - textCredit.width) / 2;
                textCredit.y = box_Info.y + 10;

                if (!pressedInfo && !targetMove) {
                    box_Info.x = spriteCred.x + (spriteCred.width - box_Info.width) / 2 - 120;
                    box_Info.y = spriteCred.y + (spriteCred.height - box_Info.height) / 2 + 25;

                    curSelected = spriteCred.ID;
                    var scale_ = scale_Credts[curSection][spriteCred.ID] + 0.025;
                    var shitLerp = lerp(spriteCred.scale.x, scale_, 0.1);
                    spriteCred.scale.set(shitLerp, shitLerp);

                    if (FlxG.mouse.justPressed) {
                        updateText();
                    }
                }
            }
            else
            {
                if (!pressedInfo){
                    var scale_ = scale_Credts[curSection][spriteCred.ID]; 
                    var shitLerp = lerp(spriteCred.scale.x, scale_, 0.1);
                    spriteCred.scale.set(shitLerp, shitLerp);
                }
               
            }

    
        }
    );

    if (box_Info.alpha == 0){
        if (controls.BACK)
        {
            FlxG.switchState(new MainMenuState());
        }
        if (controls.LEFT_P){
            changeSection(-1);
        }
        if (controls.RIGHT_P){
            changeSection(1);
        }
    }else{
        if (controls.BACK && targetMove)
        {
            hideInfo();
        }
    }
   
}
function changeSection(uh:Int = 0){
    curSection = FlxMath.wrap(curSection + uh, 0, grpSection.length - 1);

    for (i in 0...grpSection.length){
        grpSection.members[i].visible = false;           // ocultar todas las secciones
        grpCredit_sprite[i].visible = false;             // ocultar todos los grupos de créditos
    }
    
    // mostrar solo la sección actual
    grpSection.members[curSection].visible = true;
    grpCredit_sprite[curSection].visible = true;   
}

function hideInfo() {
    textCredit.text = "";
    FlxTween.tween(box_Info,{"scale.y": 0,alpha: 0}, 0.45, {ease:FlxEase.cubeInOut,onComplete: function(){
        pressedInfo = false;
        targetMove = false;
    }});
}
function updateText() {
    targetMove = false;
    pressedInfo = true;

    var final_text:String = 
    "Name: " + creditsData.sections[curSection].credits[curSelected].name + "\nDescription: " 
    + creditsData.sections[curSection].credits[curSelected].fun_text
    + "\nFollow me on: " + creditsData.sections[curSection].credits[curSelected].link;
    textCredit.text = final_text;
    textCredit.calcFrame();

    var padding:Int = 20;
    var realWidth = textCredit.textField.textWidth + padding;
    var realHeight = textCredit.textField.textHeight + padding;
    realWidth = Math.max(realWidth, 200);
    realHeight = Math.max(realHeight, 100);


    box_Info.makeGraphic(Std.int(realWidth), Std.int(realHeight), FlxColor.BLACK);
    box_Info.alpha = 0;
    box_Info.scale.y = 0;
    textCredit.setPosition(box_Info.x + padding / 2, box_Info.y + padding / 2);
    textCredit.text = "";

    FlxTween.tween(box_Info, {"scale.y": 1, alpha: 0.8}, 0.45, {
        ease: FlxEase.cubeInOut,
        onComplete: function(_) {
            var currentText:String = "";
            var textIndex:Int = 0;

            new FlxTimer().start(0.03, function(t:FlxTimer) {
                if (textIndex < final_text.length) {
                    currentText += final_text.charAt(textIndex);
                    textCredit.text = currentText;
                    textIndex++;
                    t.reset();
                }else targetMove = true;
                
                
            });
        }
    });
}
