package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import helix.core.HelixState;
import helix.core.HelixSprite;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;

import entities.map.Person;
import entities.map.Player;

class MapTraversalState extends HelixState
{
	private var player:HelixSprite;
	private var walls = new FlxGroup();
	private var people = new FlxGroup();
	private var random = new FlxRandom();

	override public function create():Void
	{
		super.create();

		this.player = new Player();
		this.player.move((FlxG.width - player.width) / 2, (FlxG.height - player.height) / 2);
		
		var wallThickness = Config.get("wallThickness");

		this.addWall(0, 0, FlxG.width, wallThickness);
		this.addWall(0, 0, wallThickness, FlxG.height);
		this.addWall(0, FlxG.height - wallThickness, FlxG.width, wallThickness);
		this.addWall(FlxG.width - wallThickness, 0, wallThickness, FlxG.height);

		this.player.collideResolve(this.walls);
		this.player.collideResolve(this.people);

		for (i in 0 ... 5)
		{
			this.addPerson();
		}
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

	private function addPerson():Void
	{
		var person = new Person(this.random);
		person.x = random.int(0, Std.int(FlxG.width - person.width));
		person.y = random.int(0, Std.int(FlxG.height - person.height));
		person.collisionImmovable();
		person.walkToNewDestination();
		this.people.add(person);
	}
}
