package entities;

import helix.core.HelixSprite;
import flixel.util.FlxColor;

class Person extends HelixSprite
{
    public function new()
    {
        super(null, {width: 48, height: 48, colour: FlxColor.PINK });
    }
}