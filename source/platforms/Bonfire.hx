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
		nurse = new NPC(x - width - 4, y + height - 16, "nurse_duck");
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
	}

	public function deactivate()
	{
		ACTIVE = false;
		anim("inactive");
	}

	public function respawn()
	{
		trace("respawn");
		for (d in PlayState.self.ducks)
		{
			d.setPosition(x + 8, y + height - d.height);
			nurse.visible = true;
		}
	}

	function collect()
	{
		kill();
	}
}
