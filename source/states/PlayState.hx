package states;

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
import ui.CoinCounter;
import ui.Dialogue;

class PlayState extends FlxState
{
	public static var self:PlayState;

	public var lvls:FlxTypedGroup<Level> = new FlxTypedGroup<Level>();
	public var cols:FlxTypedGroup<FlxTilemap> = new FlxTypedGroup<FlxTilemap>();

	public var ducks:FlxTypedGroup<Duck> = new FlxTypedGroup<Duck>();
	public var coins:FlxTypedGroup<Coin> = new FlxTypedGroup<Coin>();
	public var spikes:FlxTypedGroup<Spike> = new FlxTypedGroup<Spike>();

	public var miscBack:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var miscFront:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var emitters:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup<FlxEmitter>();
	public var bonfires:FlxTypedGroup<Bonfire> = new FlxTypedGroup<Bonfire>();

	public var npcs:FlxTypedGroup<NPC> = new FlxTypedGroup<NPC>();
	public var enemies:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();

	public var dlg:Dialogue;
	public var coin_counter:CoinCounter;

	public var coins_collected:Int = 0;

	public var hitStop:Int = 0;
	public var active_bonfire:Bonfire;

	var bgs:FlxTypedGroup<FlxBackdrop> = new FlxTypedGroup<FlxBackdrop>();

	public static var tot_time:Int = 0;

	var current_song:String = "";

	override public function create()
	{
		super.create();

		FlxG.sound.playMusic(AssetPaths.overworld__ogg, 0);
		FlxG.sound.playMusic(AssetPaths.underground__ogg, 0);

		tot_time = 0;

		self = this;

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.camera.pixelPerfectRender = true;
		FlxG.camera.flash(FlxColor.BLACK);

		// add(new FlxText(0, 0, 0, "Duck Safe", 32).screenCenter());

		for (num in 0...LDTKLevel.project.levels.length)
			new Level('Level_${num}', AssetPaths.village__png, "Tiles");

		for (lvl in lvls)
			FlxG.camera.maxScrollX = lvl.x + lvl.width > FlxG.camera.maxScrollX ? lvl.x + lvl.width : FlxG.camera.maxScrollX;
		FlxG.camera.minScrollX = 0;

		FlxG.camera.follow(ducks.getFirstAlive());
		FlxG.camera.targetOffset.set(0, -32);

		FlxG.worldBounds.set(9999, 9999);

		cols.visible = false;

		bgs.add(new FlxBackdrop(AssetPaths.background_1__png, 0.5, 0.1, true, false));
		add(bgs);
		add(cols);
		add(lvls);
		add(miscBack);
		add(spikes);
		add(npcs);
		add(bonfires);
		add(enemies);
		add(ducks);
		add(coins);
		add(miscFront);
		add(emitters);
		add(dlg = new Dialogue());
		add(coin_counter = new CoinCounter());

		bgColor = 0xff87CEEB;
	}

	var sound_switch_cd:Int = 0;

	function sound_manage()
	{
		sound_switch_cd--;
		if (sound_switch_cd > 0)
			return;

		for (d in ducks)
		{
			if (current_song != "underground" && d.y > 336 - 2)
			{
				FlxG.sound.playMusic(AssetPaths.underground__ogg);
				current_song = "underground";
				sound_switch_cd = 15;
			}
			if (current_song != "overworld" && d.y < 336 + 2)
			{
				FlxG.sound.playMusic(AssetPaths.overworld__ogg, 0.5);
				current_song = "overworld";
				sound_switch_cd = 15;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		sound_manage();

		if (FlxG.keys.anyJustPressed(["R"]))
			FlxG.resetState();

		tot_time++;

		hitstop_manager();

		Ctrl.update();
		FlxG.collide(cols, ducks);
		// FlxG.collide(npcs, cols);
		FlxG.collide(enemies, cols);

		super.update(elapsed);
	}

	function hitstop_manager()
	{
		for (g in [ducks, coins])
			g.active = hitStop <= 0;
		hitStop--;
	}

	function create_level() {}
}
