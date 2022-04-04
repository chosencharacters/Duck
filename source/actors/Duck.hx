package actors;

class Duck extends FlxSpriteExt
{
	var p:Int = 1;
	var speed:Int = 75;
	var speed_rate:Int = 15;
	var jumpBoom:Int = 100;
	var jump_run_rate:Float = 1.25;

	var touching_floor:Bool = false;

	var hit_stun:Bool = false;

	public var spike_immunity:Bool = false;
	public var ground_poundable:Bool = true;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y - 23 + 16);

		loadAllFromAnimationSet("duck");

		acceleration.y = 300;
		drag.set(200, 100);
		maxVelocity.set(speed);

		setSize(11, 23);
		offset.set(5, 1);

		sstate("normal");

		PlayState.self.ducks.add(this);

		Lists.setFlagBool("ARMOR_SPIKES", true);
		Lists.setFlagBool("ARMOR_GROUNDPOUND", true);
	}

	override function update(elapsed:Float)
	{
		touching_floor = isTouching(FlxObject.FLOOR);
		hit_stun ? drag.set(100, 100) : drag.set(200, 100);

		switch (state)
		{
			case "normal":
				control();
			case "hit":
				animProtect("hit");
				if (touching_floor && animation.finished)
				{
					sstate("normal");
					hit_stun = false;
				}
			case "ground_pound":
				trail_effect();
				velocity.set(0, 200);
				if (touching_floor)
				{
					sstateAnim("ground_pound_land");
					Utils.shake("light");
				}
			case "ground_pound_land":
				if (animation.finished)
					sstate("normal");
		}

		ground_poundable = Lists.getFlagBool("ARMOR_GROUNDPOUND");
		spike_immunity = Lists.getFlagBool("ARMOR_SPIKES");

		super.update(elapsed);
	}

	public function hit(origin:FlxPoint)
	{
		Utils.shake("damage");
		sstateAnim("hit");
		PlayState.self.hitStop = 5;
		velocity.x = origin.x < getMidpoint().x ? 100 : -100;
		velocity.y = -100;
		hit_stun = true;
	}

	function upgrade()
	{
		if (Lists.getFlagBool("ARMOR_GROUNDPOUND"))
		{
			color = FlxColor.BLUE;
			return;
		}
		if (Lists.getFlagBool("ARMOR_SPIKES"))
		{
			color = FlxColor.RED;
			return;
		}
	}

	function control()
	{
		var RIGHT:Bool = Ctrl.right[p];
		var LEFT:Bool = Ctrl.left[p];
		var JUMP:Bool = Ctrl.jjump[p];
		var DOWN:Bool = Ctrl.down[p];
		var GROUND_POUND:Bool = DOWN && JUMP && !touching_floor;
		var SIT:Bool = DOWN && touching_floor;

		var JUMPING:Bool = !touching_floor;

		if (GROUND_POUND && ground_poundable)
		{
			sstateAnim("ground_pound");
			return;
		}
		if (RIGHT && !SIT)
		{
			velocity.x += speed / speed_rate;
			if (velocity.x < 0)
				velocity.x -= speed / speed_rate;
			flipX = JUMPING ? flipX : false;
		}
		if (LEFT && !SIT)
		{
			velocity.x -= speed / speed_rate;
			if (velocity.x > 0)
				velocity.x -= speed / speed_rate;
			flipX = JUMPING ? flipX : true;
		}

		if (!JUMPING && JUMP)
			velocity.y = -jumpBoom * (Math.abs(velocity.x) > speed / 2 ? jump_run_rate : 1);

		if (!JUMPING)
			if (LEFT || RIGHT)
				anim("move");
			else
				SIT ? anim("sit") : anim("idle");
		else
			anim("jump");
	}

	var rainbowEffect:Int = 0;
	var trail:FlxTypedGroup<TempSprite> = new FlxTypedGroup<TempSprite>();
	var black_trail_mode:Bool = true;

	var rainbow_tick:Int = 0;

	function trail_effect()
	{
		rainbow_tick++;
		if (rainbow_tick % 3 == 1)
		{
			var mirror:TempSprite = new TempSprite(x - offset.x, y - offset.y, 10);
			PlayState.self.miscBack.add(mirror);
			mirror.makeGraphic(Math.floor(frameWidth), Math.floor(frameHeight), FlxColor.TRANSPARENT, true);
			mirror.stamp(this);

			rainbowEffect++;
			switch (rainbowEffect % 3)
			{
				case 0:
					mirror.color = FlxColor.BLUE.getDarkened(.5);
				case 1:
					mirror.color = FlxColor.MAGENTA.getDarkened(.5);
				case 2:
					mirror.color = FlxColor.MAGENTA;
			}

			var to_remove:Array<TempSprite> = [];

			for (t in trail)
			{
				if (black_trail_mode)
					t.color = FlxColor.MAGENTA.getDarkened(.8);
				if (!t.alive)
					to_remove.push(t);
			}
			for (t in to_remove)
				trail.remove(t, true);

			trail.add(mirror);
		}
	}
}
