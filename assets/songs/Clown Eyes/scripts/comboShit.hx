var globes:Array<FlxSprite> = [];

function create()
{
    globes = [];

    for (i in 1...5)
    {
        var sprite = new FlxSprite(i * 350 + 500, 1200).loadGraphic(getPath("globo" + i));
        sprite.scale.set(1.4, 1.4);
        insert(members.indexOf(dad), sprite);
        globes.push(sprite);
    }

   
}
var lastGlobeCombo:Int = -1;

function update(elapsed:Float)
{
    if (combo % 50 == 0 && combo != lastGlobeCombo)
    {
        lastGlobeCombo = combo;
        globeEvent();
    }
}
function getPath(key:String):FlxGraphic
{
    return Paths.image("stages/clown/" + key);
}

function globeEvent()
{
    for (i in 0...globes.length)
    {
        var globo = globes[i];
        globo.setPosition(i * 350 + 500, 1200);
        globo.velocity.y = FlxG.random.int(-250,-450);
        switch(i){
            case 0: globo.velocity.x = FlxG.random.int(-20,-25);
            case 1: globo.velocity.x = FlxG.random.int(0,-10);
            case 2:  globo.velocity.x = FlxG.random.int(0,10);
            case 3: globo.velocity.x = FlxG.random.int(20,40);
        }
    }
}