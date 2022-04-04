package;

import actors.Duck;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxAssets.FlxShader;
import items.Coin;
import level.Level;
import openfl.display.StageQuality;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

class PlayState extends FlxState
{
	public static var self:PlayState;

	public var lvls:FlxTypedGroup<Level> = new FlxTypedGroup<Level>();
	public var cols:FlxTypedGroup<FlxTilemapExt> = new FlxTypedGroup<FlxTilemapExt>();

	public var ducks:FlxTypedGroup<Duck> = new FlxTypedGroup<Duck>();
	public var coins:FlxTypedGroup<Coin> = new FlxTypedGroup<Coin>();
	public var spikes:FlxTypedGroup<Spike> = new FlxTypedGroup<Spike>();

	public var miscBack:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var miscFront:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var emitters:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup<FlxEmitter>();

	static var coins_collected:Int = 0;

	var num_levels:Int = 2;

	public var hitStop:Int = 0;

	var bgs:FlxTypedGroup<FlxBackdrop> = new FlxTypedGroup<FlxBackdrop>();

	override public function create()
	{
		super.create();

		self = this;

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.camera.pixelPerfectRender = true;

		//add(new FlxText(0, 0, 0, "Duck Safe", 32).screenCenter());

		for (num in 0...num_levels)
			new Level('Level_${num}', AssetPaths.village__png, "Tiles");

		FlxG.camera.follow(ducks.getFirstAlive());
		FlxG.camera.targetOffset.set(0, -32);

		FlxG.worldBounds.set(9999, 9999);

		bgs.add(new FlxBackdrop(AssetPaths.background_1__png, 0.5, 0, true));
		add(bgs);
		add(lvls);
		add(miscBack);
		add(spikes);
		add(ducks);
		add(coins);
		add(miscFront);
		add(emitters);

		bgColor = 0xff87CEEB;
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed(["R"]))
			FlxG.resetState();

		hitstop_manager();

		Ctrl.update();
		super.update(elapsed);
		FlxG.collide(cols, ducks);
	}

	function hitstop_manager()
	{
		for (g in [ducks, coins])
			g.active = hitStop <= 0;
		hitStop--;
	}

	function create_level() {}
}
