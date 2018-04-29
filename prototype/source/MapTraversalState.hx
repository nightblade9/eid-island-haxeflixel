package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
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

import view.PerlinNoiseGenerator;

import MovementHelper;

class MapTraversalState extends HelixState
{
	private static inline var FONT_SIZE:Int = 36;
	private static inline var TILE_WIDTH:Int = 48;
	private static inline var TILE_HEIGHT:Int = 48;

	private static var TILE_INDICIES:Map<String, Int> = [
		WATER_TILE => 1,
		GRASS_TILE => 2
	];
	private static inline var WATER_TILE:String = "water";
	private static inline var GRASS_TILE:String = "grass";

	private var player:HelixSprite;
	private var walls = new FlxGroup();
	private var people = new FlxGroup();
	private var waters = new FlxGroup();

	private var random = new FlxRandom();
	private var speechText:HelixText;

	override public function create():Void
	{
		super.create();
		this.generateTiles();
		
		this.speechText = new HelixText(0, 0, "", FONT_SIZE);

		this.player = new Player();
		this.player.move((FlxG.width - player.width) / 2, (FlxG.height - player.height) / 2);
		
		var wallThickness = Config.get("wallThickness");

		this.player.collideResolve(this.walls);
		this.player.collideResolve(this.waters);
		this.player.collideResolve(this.people);

		// Follow in top-down mode, LERP for smooth transitions
		// https://haxeflixel.com/documentation/zoom-and-cameras/
		FlxG.camera.follow(this.player, TOPDOWN, 1);

		var npcsJson:Array<Dynamic> = haxe.Json.parse(openfl.Assets.getText("assets/data/npcs.json"));

		for (rawData in Reflect.fields(npcsJson)) {
    		var npcData = Reflect.field(npcsJson, rawData);
			this.addPerson(npcData);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (this.isKeyPressed(flixel.input.keyboard.FlxKey.M)) {
			FlxG.camera.zoom = 0.1;
		} else {
			FlxG.camera.zoom = 1;
		}
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

		MovementHelper.tweenToNewDestination(person,
			function() { return this.random.int(0, Std.int(FlxG.width - person.width)); },
			function() { return this.random.int(0, Std.int(FlxG.height - person.height)); },
			Config.get("npcs").walkSpeed,
			Config.get("npcs").walkMinDelaySeconds,
			Config.get("npcs").walkMaxDelaySeconds);

		this.people.add(person);
	}

	private function generateTiles():Void
	{
		var width = 25;
		var height = 25;

		var map = PerlinNoiseGenerator.generateNoise(width, height);
		var tileIndicies = new Array<Int>();

		for (y in 0 ... height) {
			for (x in 0 ... width) {
				var c = map.pixels.getPixel(x, y);
				var tileType = c > 0 ? GRASS_TILE : WATER_TILE;
				var tileId = TILE_INDICIES[tileType];
				tileIndicies.push(tileId);
			}
		}
		trace(tileIndicies);
		var tileMap = new FlxTilemap();
		tileMap.loadMapFromArray(tileIndicies, width, height, "assets/images/tiles.png", TILE_WIDTH, TILE_HEIGHT);
		this.add(tileMap);
	}
}
