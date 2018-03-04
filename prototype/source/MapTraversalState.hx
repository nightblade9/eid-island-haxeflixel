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
import helix.core.HelixText;
using helix.core.HelixSpriteFluentApi;
import helix.data.Config;

import entities.map.Person;
import entities.map.Player;
import entities.map.Water;

class MapTraversalState extends HelixState
{
	private static inline var FONT_SIZE:Int = 36;

	private var player:HelixSprite;
	private var walls = new FlxGroup();
	private var people = new FlxGroup();
	private var waters = new FlxGroup();

	private var random = new FlxRandom();
	private var speechText:HelixText;

	override public function create():Void
	{
		super.create();
		this.speechText = new HelixText(0, 0, "", FONT_SIZE);

		this.player = new Player();
		this.player.move((FlxG.width - player.width) / 2, (FlxG.height - player.height) / 2);
		
		var wallThickness = Config.get("wallThickness");

		// this.addWall(0, 0, FlxG.width, wallThickness);
		// this.addWall(0, 0, wallThickness, FlxG.height);
		// this.addWall(0, FlxG.height - wallThickness, FlxG.width, wallThickness);
		// this.addWall(FlxG.width - wallThickness, 0, wallThickness, FlxG.height);

		this.player.collideResolve(this.walls);
		this.player.collideResolve(this.waters);
		this.player.collideResolve(this.people);		

		var npcsJson = haxe.Json.parse(openfl.Assets.getText("assets/data/npcs.json"));

		this.addPerson(npcsJson.iq);
		this.addPerson(npcsJson.as);
		this.addPerson(npcsJson.kh);
		this.addPerson(npcsJson.z);

		//this.generateWater();
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

	private function addWater(x:Float, y:Float, width:Int, height:Int):Void
	{
		var water = new Water(width, height);
		water.move(x, y);
		water.collisionImmovable();
		this.waters.add(water);
	}

	private function addPerson(data:Dynamic):Void
	{
		var person = new Person(this.random, data, this.speechText);
		person.x = random.int(0, Std.int(FlxG.width - person.width));
		person.y = random.int(0, Std.int(FlxG.height - person.height));
		person.collisionImmovable();
		person.walkToNewDestination();
		this.people.add(person);
	}

	private function generateWater():Void
	{
		var waterThickness = Config.get("waterThickness");
		this.addWater(0, 0, FlxG.width, waterThickness);
		this.addWater(0, 0, waterThickness, FlxG.height);
		this.addWater(0, FlxG.height - waterThickness, FlxG.width, waterThickness);
		this.addWater(FlxG.width - waterThickness, 0, waterThickness, FlxG.height);
	}
}
