package entities.map;

import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import flixel.util.FlxColor;
import flixel.FlxG;

class Water extends HelixSprite
{
    public function new(width:Int, height:Int)
    {
        super(null, {width: width, height: height, colour: FlxColor.CYAN });

        this.onClick(function() {
            FlxG.switchState(new FishingState());
        });
    }
} 