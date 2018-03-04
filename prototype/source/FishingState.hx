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
    private static inline var PADDING:Int = 8;

    public static var minY(default, null):Float;
    public static var maxY(default, null):Float;

    override public function create() {
        var bar = new HelixSprite(null, 
            {
                width: Config.get("fishing").bar.width,
                height: Config.get("fishing").bar.height,
                colour: FlxColor.PINK });

        bar.move((FlxG.width - bar.width) / 2, (FlxG.height - bar.height) / 2);

        var hook = new FishingHook();
        hook.move(bar.x, bar.y + (bar.height / 2) - hook.height);

        FishingState.minY = bar.y;
        FishingState.maxY = bar.y + bar.height;

        var fish = new Fish();
        fish.move(bar.x, bar.y + (bar.height / 2) - fish.height);

        var reel = new ReelBar(bar, fish, hook);
        reel.move(bar.x + bar.width + PADDING, 0);
        reel.setProgress(0); // Moves Y position
    }
}

class Fish extends HelixSprite {

    private static var random = new FlxRandom();

    public function new() {
        super(null, { 
            width: Config.get("fishing").fish.width, 
            height: Config.get("fishing").fish.height,
            colour: FlxColor.ORANGE });
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);

        var velocity = Config.get("fishing").fish.moveVelocity;
        var moveAmount = Fish.random.int(-velocity, velocity);
        this.y += (moveAmount * elapsedSeconds);

        if (this.y < FishingState.minY) {
            this.y = FishingState.minY;
        } else if (this.y > FishingState.maxY - this.height) {
            this.y = FishingState.maxY - this.height;
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

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        
        if (FlxG.mouse.pressed)
        {
            this.y -= Config.get("fishing").hook.buoyancy * elapsedSeconds;
        } else {
            this.y += Config.get("fishing").hook.gravity * elapsedSeconds;
        }

        if (this.y < FishingState.minY) {
            this.y = FishingState.minY;
        } else if (this.y > FishingState.maxY - this.height) {
            this.y = FishingState.maxY - this.height;
        }
    }
}

class ReelBar extends HelixSprite {
    
    public var progress(default, null):Int;
    private var bar:HelixSprite;
    private var fish:Fish;
    private var hook:FishingHook;

    public function new(bar:HelixSprite, fish:Fish, hook:FishingHook) {
        this.bar = bar;
        this.fish = fish;
        this.hook = hook;

        super(null, {
            width: Config.get("fishing").reel.width,
            height: 1,
            colour: FlxColor.MAGENTA
        });

        this.progress = 0;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        if (this.fish.y >= this.hook.y && this.fish.y <= this.hook.y + this.hook.height)
        {
            this.setProgress(this.progress + Config.get("fishing").reel.catchAmount);
        } else {
            this.setProgress(this.progress - Config.get("fishing").reel.intertiaAmount);
        }
    }

    public function setProgress(progress:Float)
    {
        this.progress = Std.int(Math.min(progress, this.bar.height));
        this.setGraphicSize(Std.int(Config.get("fishing").reel.width), this.progress);
        this.y = this.bar.y + this.bar.height - (0.5 * progress);
        this.progress = Std.int(Math.max(this.progress, 0)); // minimum zero
    }
}