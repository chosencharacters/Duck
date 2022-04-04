package platforms;

import ldtk.Entity;

class Spike extends FlxSpriteExt
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		loadAllFromAnimationSet("spike");
		immovable = true;
	}

	override function update(elapsed:Float)
	{
		for (d in PlayState.self.ducks)
		{
			if (!d.spike_immunity && d.overlaps(this))
				d.hit(getMidpoint());
			if (d.spike_immunity && d.overlaps(this))
				FlxG.collide(d, this);
		}
		super.update(elapsed);
	}

	function collect()
	{
		kill();
	}
}
