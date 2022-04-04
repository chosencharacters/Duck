package items;

class Coin extends FlxSpriteExt
{
	var collected:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X + 4, Y + 3);
		loadAllFromAnimationSet("coin");
	}

	override function update(elapsed:Float)
	{
		if (!collected)
			for (d in PlayState.self.ducks)
				if (d.coin_collect_hitbox.overlaps(this))
					collect();
		if (animation.name == "collect" && animation.finished)
			kill();

		super.update(elapsed);
	}

	function collect()
	{
		anim("collect");
		collected = true;
		PlayState.self.coins_collected++;
	}
}
