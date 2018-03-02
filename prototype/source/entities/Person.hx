package entities;

import helix.core.HelixSprite;
import helix.data.Config;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Person extends HelixSprite
{
    private static inline var WALK_SPEED:Int = 200;

    private var destinationX:Int;
    private var destinationY:Int;
    private var random:FlxRandom;

    public function new(random:FlxRandom)
    {
        super(null, {width: 48, height: 48, colour: FlxColor.PINK });
        this.random = random;
    }

    public function walkToNewDestination():Void
    {
        this.destinationX = this.random.int(0, Std.int(FlxG.width - this.width));
        this.destinationY = this.random.int(0, Std.int(FlxG.height - this.height));
        var distance = Math.sqrt(Math.pow(this.destinationX - this.x, 2) + Math.pow(this.destinationY - this.y, 2));
        var duration = distance / Person.WALK_SPEED;
        
        // Wait a few seconds, then move
        var waitSeconds = this.random.float(
            Config.get("npcs").walkMinDelaySeconds, Config.get("npcs").walkMaxDelaySeconds);

        FlxTween.tween(this, {}, waitSeconds).then(
            FlxTween.tween(this, {x: this.destinationX, y: this.destinationY}, duration,
                {
                    onComplete: function(t) {                    
                        this.walkToNewDestination();
                    }
                })            
        );
    }
}