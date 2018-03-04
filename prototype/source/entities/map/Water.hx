package entities.map;

import helix.core.HelixSprite;

class Water extends HelixSprite
{
    public function new(width:Int, height:Int)
    {
        super(null, {width: height, height: height, colour: FlxColor.CYAN });
    }
} 