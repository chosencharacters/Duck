package platforms;

class Exit extends FlxSpriteExt
{
	var GAME_ENDING:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X + 8, Y - 16);
		makeGraphic(16, 999);
		visible = false;
		immovable = true;
		PlayState.self.miscFront.add(this);
	}

	override function update(elapsed:Float)
	{
		if (GAME_ENDING)
			return;
		for (d in PlayState.self.ducks)
			if (overlaps(d))
			{
				if (Lists.getFlagBool("ARMOR_ENDGAME"))
				{
					PlayState.self.hitStop = 999;
					GAME_ENDING = true;
					FlxG.camera.fade(function()
					{
						FlxG.switchState(new EndState());
					});
				}
				else
				{
					FlxG.collide(d, this);
					if (d.state != "scared_start")
						d.sstate("scared_start");
				}
			}
		super.update(elapsed);
	}

	function collect()
	{
		kill();
	}
}
