package actors;

class Toast extends FlxSpriteExt
{
	var name:String = "";

	var speed:Int = -50;

	var org:FlxPoint;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		acceleration.y = 300;
		drag.x = 100;

		loadAllFromAnimationSet('toast');

		sstate("normal");

		PlayState.self.enemies.add(this);

		org = new FlxPoint(x, y);
	}

	override function update(elapsed:Float)
	{
		if (state != "wait-respawn" && (!visible || !isOnScreen()))
			return;

		var overlapping:Bool = false;

		switch (state)
		{
			case "normal":
				turnOnWall();
				velocity.x = speed;
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
					drag.x = 0;
					velocity.y = -100;
					acceleration.y = 500;
					y--;
				}
				if (tick > 5 && isTouching(FlxObject.FLOOR) || tick > 25)
				{
					var explosion:TempSprite = new TempSprite(getMidpoint().x - 12, getMidpoint().y - 12);
					explosion.loadAllFromAnimationSet("enemy-boom");
					PlayState.self.miscFront.add(explosion);
					PlayState.self.hitStop = 5;
					sstate("wait-respawn");
				}
			case "wait-respawn":
				velocity.set(0, 0);
				acceleration.set(0, 0);
				visible = false;
				setPosition(org.x, org.y);
				if (!isOnScreen())
				{
					kill();
					new Toast(org.x, org.y);
				}
		}

		super.update(elapsed);
	}

	function turnOnWall(swapSpeed:Bool = true, flipMe:Bool = true, ignoreOnInv:Bool = true):Bool
	{
		if (isTouching(FlxObject.WALL))
		{
			turn(swapSpeed, flipMe);
			return true;
		}
		return false;
	}

	function turn(changeSpeed:Bool = true, flipMe:Bool = true, pushDist:Int = 2)
	{
		if (!flipX)
		{
			x += pushDist;
		}
		else
		{
			x -= pushDist;
		}
		if (changeSpeed)
			speed = -speed;
		if (flipMe)
			flipX = !flipX;
	}
}
