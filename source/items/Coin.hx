package items;

class Coin extends FlxSpriteExt
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		loadAllFromAnimationSet("coin");
		setSize(8, 10);
		offset.set(5, 3);
	}

	override function update(elapsed:Float)
	{
		for (d in PlayState.self.ducks)
			if (d.overlaps(this))
				collect();
		super.update(elapsed);
	}

	function collect()
	{
		kill();
	}
}
