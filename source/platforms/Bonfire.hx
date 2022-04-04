package platforms;

class Bonfire extends FlxSpriteExt
{
	public var ACTIVE:Bool = false;

	var nurse:FlxSpriteExt;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X + 3, Y + 5);
		loadAllFromAnimationSet("bonfire");
		immovable = true;
		PlayState.self.bonfires.add(this);
		nurse = new NPC(x - width - 8, y + height - 16, "nurse_duck");
		nurse.visible = false;
	}

	override function update(elapsed:Float)
	{
		for (d in PlayState.self.ducks)
			if (d.overlaps(this) && !ACTIVE)
				activate();
		if (nurse.visible && !isOnScreen())
			nurse.visible = false;
		super.update(elapsed);
	}

	function activate()
	{
		for (b in PlayState.self.bonfires)
			b.deactivate();
		anim("active");
		ACTIVE = true;
		FlxG.camera.flash(FlxColor.ORANGE);
		Utils.shake("light");
		PlayState.self.active_bonfire = this;

		var bonfire_lit:TempSprite = new TempSprite(0, 0, 90, AssetPaths.bonfire_lit__png);
		bonfire_lit.on_update = function()
		{
			bonfire_lit.alpha -= 1 / 90;
		}
		bonfire_lit.scrollFactor.set(0, 0);
		PlayState.self.add(bonfire_lit);
	}

	public function deactivate()
	{
		ACTIVE = false;
		anim("inactive");
	}

	public function respawn()
	{
		for (d in PlayState.self.ducks)
		{
			velocity.set(0, 0);
			d.setPosition(x + 28, y + height - d.height - 16);
			nurse.visible = true;
		}
	}

	function collect()
	{
		kill();
	}
}
