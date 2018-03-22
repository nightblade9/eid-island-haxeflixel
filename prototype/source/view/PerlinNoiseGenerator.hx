package view;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import hxnoise.Perlin;

class PerlinNoiseGenerator {
    public static function generateNoise(width:Int, height:Int):FlxSprite {
        var perlin = new Perlin();

        var toReturn = new FlxSprite();
        toReturn.makeGraphic(width, height);

        var color:FlxColor;
        // 5-10
        var magicConstantOne = 5 + Std.int(Math.random() * 5);

        for(x in 0...width) {
            for(y in 0...height) {                
                var c = perlin.OctavePerlin(x / magicConstantOne, y / magicConstantOne, 0.1,
                    5, 0.5, 0.25);
                
                // https://gamedev.stackexchange.com/questions/80548/fast-simple-procedural-2d-island-generation
                if (c > 0.3 + (0.4 * distance_squared(x, y, width, height))) {
                    color = FlxColor.WHITE;
                } else {
                    color = FlxColor.BLACK;
                }
                
                toReturn.pixels.setPixel(x, y, color);
            }
        }

        return toReturn;
    }

    private static function distance_squared(x, y, width, height) {
        var dx = 2 * x / width - 1;
        var dy = 2 * y / height - 1;
        // at this point 0 <= dx <= 1 and 0 <= dy <= 1
        return dx*dx + dy*dy;
    }
}