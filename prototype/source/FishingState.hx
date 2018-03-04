package;

import helix.core.HelixState;
import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class FishingState extends HelixState
{
    override public function create() {
        var bar = new HelixSprite(null, 
            {
                width: Config.get("fishing").bar.width,
                height: Config.get("fishing").bar.height,
                colour: FlxColor.PINK });

        bar.move((FlxG.width - bar.width) / 2, (FlxG.height - bar.height) / 2);

        var hook = new FishingHook();
        hook.move(bar.x, bar.y + (bar.height / 2) - hook.height);

        var fish = new Fish();
        fish.move(bar.x, bar.y + (bar.height / 2) - fish.height);

        Fish.constrain(bar.y, bar.y + bar.height - fish.height);        
    }
}

class Fish extends HelixSprite {

    private static var random = new FlxRandom();
    private static var minY(default, null):Float;
    private static var maxY(default, null):Float;

    public static function constrain(minY:Float, maxY:Float):Void
    {
        Fish.minY = minY;
        Fish.maxY = maxY;
    }

    public function new() {
        super(null, { 
            width: Config.get("fishing").fish.width, 
            height: Config.get("fishing").fish.height,
            colour: FlxColor.ORANGE });
    }

    override public function update(elapsedSeconds:Float):Void
    {
        var velocity = Config.get("fishing").fish.moveVelocity;
        var moveAmount = Fish.random.int(-velocity, velocity);
        this.y += (moveAmount * elapsedSeconds);

        if (this.y < Fish.minY) {
            this.y = Fish.minY;
        } else if (this.y > Fish.maxY) {
            this.y = Fish.maxY;
        }
    }
}

class FishingHook extends HelixSprite {
    public function new() {
        super(null, {
                width: Config.get("fishing").hook.width,
                height: Config.get("fishing").hook.height,
                colour: FlxColor.RED });
    }
}