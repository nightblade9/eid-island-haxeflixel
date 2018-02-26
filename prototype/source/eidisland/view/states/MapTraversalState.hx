package eidisland.view.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import helix.core.HelixState;
import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;

class MapTraversalState extends HelixState
{
	private var player:HelixSprite;

	override public function create():Void
	{
		super.create();
		this.player = 
			new HelixSprite(null, {width: 48, height: 48, colour: FlxColor.WHITE })
			.moveWithKeyboard(Config.get("player").velocity);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
