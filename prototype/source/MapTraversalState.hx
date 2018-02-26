package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
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
	private var walls = new FlxGroup();

	override public function create():Void
	{
		super.create();

		this.player = 
			new HelixSprite(null, {width: 48, height: 48, colour: FlxColor.WHITE })
			.moveWithKeyboard(Config.get("player").velocity);
		
		this.player.move((FlxG.width - player.width) / 2, (FlxG.height - player.height) / 2);
		
		var wallThickness = Config.get("wallThickness");

		this.addWall(0, 0, FlxG.width, wallThickness);
		this.addWall(0, 0, wallThickness, FlxG.height);
		this.addWall(0, FlxG.height - wallThickness, FlxG.width, wallThickness);
		this.addWall(FlxG.width - wallThickness, 0, wallThickness, FlxG.height);

		this.player.collideResolve(this.walls);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function addWall(x:Float, y:Float, width:Int, height:Int):Void
	{
		var wall = new HelixSprite(null, {width: width, height:height, colour: FlxColor.BROWN });
		wall.move(x, y);
		wall.collisionImmovable();
		this.walls.add(wall);
	}
}
