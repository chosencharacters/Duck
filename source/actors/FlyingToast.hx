package actors;

class FlyingToast extends FlxSpriteExt
{
	var name:String = "";

	var speed:Int = -50;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X - 20 - 26, Y);

		drag.x = 100;

		loadAllFromAnimationSet('flying-toast');

		sstate("normal");

		PlayState.self.enemies.add(this);
	}

	override function update(elapsed:Float)
	{
		if (!visible || !isOnScreen())
			return;

		switch (state)
		{
			case "normal":
				for (d in PlayState.self.ducks)
					if (d.overlaps(this))
					{
						if (d.state != "ground_pound" && d.state != "dash")
							d.hit(getMidpoint());
						else if (d.state != "ground_pound" || d.state != "dash")
						{
							PlayState.self.hitStop = 5;
							velocity.x = getMidpoint().x < d.getMidpoint().x ? -100 : 100;
							d.dash_reset = true;
							sstate("dying");
						}
					}
			case "dying":
				ttick();
				switch (tick % 16)
				{
					case 1: color = FlxColor.RED.getDarkened(.5);
					case 5: color = FlxColor.WHITE;
				}
				if (tick == 1)
				{
					velocity.y = -100;
					drag.x = 0;
					acceleration.y = 500;
					y--;
				}
				if (tick > 5 && isTouching(FlxObject.FLOOR) || tick > 25)
				{
					var explosion:TempSprite = new TempSprite(getMidpoint().x - 12, getMidpoint().y - 12);
					explosion.loadAllFromAnimationSet("enemy-boom");
					PlayState.self.miscFront.add(explosion);
					PlayState.self.hitStop = 5;
					kill();
				}
		}

		super.update(elapsed);
	}
}