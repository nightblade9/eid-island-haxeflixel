package entities.map;

import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * A walking, talking person.
 */
class Person extends HelixSprite
{
    private static inline var WALK_SPEED:Int = 200;

    private var destinationX:Int;
    private var destinationY:Int;
    private var random:FlxRandom;

    private var speech = new Array<Speech>();

    /**
     *  Creates a new person from a JSON block, which includes details
     *  such as the NPC sprite, and their text&audio speech.
     */
    public function new(random:FlxRandom, json:Dynamic)
    {
        this.random = random;

        if (json.sprite == null) {
            super(null, {width: 48, height: 48, colour: FlxColor.PINK });
        } else {
            super(json.sprite);
        }

        var speeches:Array<Dynamic> = json.speech;
        for (speech in speeches) {
            this.speech.push(new Speech(speech.text, speech.audio));
        }
        this.onClick(this.playRandomSpeech);
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

    private function playRandomSpeech():Void
    {
        var item = random.getObject(this.speech);
        trace(item.text);
        item.audio.stop();
        item.audio.play();
    }
}

class Speech {
    public var text(default, null):String;
    public var audio(default, null):FlxSound;

    public function new(text:String, audio:String)
    {
        this.text = text;
        this.audio = FlxG.sound.load(audio);
    }
}