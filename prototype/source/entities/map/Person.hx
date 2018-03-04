package entities.map;

import helix.core.HelixSprite;
import helix.core.HelixText;
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
    private var speechText:HelixText;
    private var destinationX:Int;
    private var destinationY:Int;
    private var random:FlxRandom;

    private var speech = new Array<Speech>();

    /**
     *  Creates a new person from a JSON block, which includes details
     *  such as the NPC sprite, and their text&audio speech.
     */
    public function new(random:FlxRandom, json:Dynamic, speechText:HelixText)
    {
        this.random = random;
        this.speechText = speechText;

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

    private function playRandomSpeech():Void
    {
        var item = random.getObject(this.speech);
        this.speechText.x = this.x;
        this.speechText.y = this.y - this.speechText.height;
        this.speechText.text = item.text;
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