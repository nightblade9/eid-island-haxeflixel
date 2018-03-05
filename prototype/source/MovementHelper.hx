package;

import helix.core.HelixSprite;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;

class MovementHelper {
    private static var random:FlxRandom = new FlxRandom();

    public static function tweenToNewDestination(sprite:HelixSprite, dx:Void->Int, dy:Void->Float,
        travelSpeed:Float, minWaitDelay, maxWaitDelay):Void
    {
        var destinationX = dx();
        var destinationY = dy();
        var distance = Math.sqrt(Math.pow(destinationX - sprite.x, 2) + Math.pow(destinationY - sprite.y, 2));
        var duration = distance / travelSpeed;
        
        // Wait a few seconds, then move
        var waitSeconds = random.float(minWaitDelay, maxWaitDelay);

        FlxTween.tween(sprite, {}, waitSeconds).then(
            FlxTween.tween(sprite, {x: destinationX, y: destinationY}, duration,
                {
                    onComplete: function(t) {         
                        MovementHelper.tweenToNewDestination(sprite, dx, dy, travelSpeed,
                            minWaitDelay, maxWaitDelay);
                    }
                })            
        );
    }
}