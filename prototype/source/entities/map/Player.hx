package entities.map;

import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;

import flixel.util.FlxColor;

class Player extends HelixSprite
{
    public function new()
    {
        super(null, {width: 48, height: 48, colour: FlxColor.WHITE });
        this.moveWithKeyboard(Config.get("player").velocity);
    }
}