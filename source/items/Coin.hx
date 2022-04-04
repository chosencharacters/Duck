package items;

class Coin extends FlxSpriteExt
{
	var collected:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0, value:Int = 0)
	{
		super(X + 4, Y + 3);
		switch (value)
		{
			case 1:
				loadAllFromAnimationSet("coin_silver");
			case 5:
				loadAllFromAnimationSet("coin_gold");
			case 10:
				loadAllFromAnimationSet("coin_green");
			case 25:
				loadAllFromAnimationSet("coin_pink");
		}
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
		PlayState.self.coin_counter.collect();
	}
}
