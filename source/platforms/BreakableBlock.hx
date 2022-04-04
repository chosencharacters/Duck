package platforms;

import flixel.*;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

/**
 * ...
 * @author Squidly
 */
class BreakableBlock extends FlxSpriteExt
{
	var lvl:Level;
	var col:FlxTilemapExt;

	public function new(?X:Float = 0, ?Y:Float = 0, source:Int)
	{
		super(X, Y);
		loadGraphic(AssetPaths.village__png, true, 16, 16);
		animation.frameIndex = source;
		color = FlxColor.YELLOW;

		for (l in PlayState.self.lvls)
			if (x >= l.x && x <= l.x + l.width && y >= l.y && y <= l.y + l.height)
				lvl = l;
		col = lvl.col;

		col.setTile(Math.floor((x - col.x) / 16), Math.floor((y - col.y) / 16), 2);
		immovable = true;

		PlayState.self.miscFront.add(this);
	}

	override public function update(elapsed:Float):Void
	{
		for (d in PlayState.self.ducks)
			if (FlxG.overlap(d.coin_collect_hitbox, this) && d.state == "ground_pound")
				shatter();
			else
				FlxG.collide(d, this);
		super.update(elapsed);
	}

	function shatter()
	{
		// SoundPlayer.play_sound("blockbreak");
		Utils.shake("light");
		PlayState.self.hitStop = 10;
		col.setTile(Math.floor((x - col.x) / 16), Math.floor((y - col.y) / 16), 0);
		lvl.setTile(Math.floor((x - lvl.x) / 16), Math.floor((y - lvl.y) / 16), 0);
		var f:FlxEmitter = new FlxEmitter();
		f.x = x + width / 2;
		f.y = y + height / 2;
		f.speed.set(-200, -200, 200, 200);
		f.acceleration.set(0, 100, 0, 400);
		f.lifespan.set(8, 16);
		// var clr:Int = 0xffC68892;
		// f.color.set(clr, clr, clr, clr);
		f.loadParticles(AssetPaths.breakableParticles__png, 4, 0, true, false);
		f.allowCollisions = FlxObject.ANY;
		f.start(true);
		PlayState.self.emitters.add(f);
		kill();
	}
}
