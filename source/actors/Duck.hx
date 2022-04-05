package actors;

class Duck extends FlxSpriteExt
{
	var p:Int = 1;
	var speed:Int = 75;
	var speed_rate:Int = 15;
	var jumpBoom:Int = 100;
	var jump_run_rate:Float = 1.25;
	var dash_speed:Int = 125;

	var touching_floor:Bool = false;

	public var hit_stun:Bool = false;

	public var dashable:Bool = false;
	public var spike_immunity:Bool = false;
	public var ground_poundable:Bool = false;

	public var dash_reset:Bool = false;

	var dash_up:Bool = false;

	public static var active_bonfire:Bonfire;

	var explosion:TempSprite;

	public var coin_collect_hitbox:FlxSpriteExt;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y - 23 + 16);

		loadAllFromAnimationSet("duck");

		acceleration.y = 300;
		drag.set(200, 100);
		maxVelocity.set(speed);

		coin_collect_hitbox = new FlxSpriteExt();
		coin_collect_hitbox.makeGraphic(Math.floor(width), Math.floor(height) + 4);
		coin_collect_hitbox.visible = false;

		setSize(11, 22);
		offset.set(5, 2);

		sstate("normal");

		PlayState.self.ducks.add(this);
		PlayState.self.miscBack.add(coin_collect_hitbox);
	}

	override function update(elapsed:Float)
	{
		touching_floor = isTouching(FlxObject.FLOOR);
		hit_stun ? drag.set(100, 100) : drag.set(200, 100);
		maxVelocity.set(speed);
		switch (state)
		{
			case "normal":
				control();
			case "hit":
				animProtect("hit");
				if (touching_floor && animation.finished)
				{
					explode();
					sstate("exploding");
					// sstate("normal");
					// hit_stun = false;
				}
			case "ground_pound":
				trail_effect();
				velocity.set(0, 200);
				if (touching_floor)
				{
					sstateAnim("ground_pound_land");
					SoundPlayer.play_sound(AssetPaths.groundpound_land__ogg);
					Utils.shake("light");
				}
			case "ground_pound_land":
				if (animation.finished)
					sstate("normal");
			case "dash":
				trail_effect();
				maxVelocity.set(dash_speed);
				velocity.x = !flipX ? dash_speed : -dash_speed;
				velocity.y = dash_up ? -dash_speed / 2 : 0;
				animProtect("dash");
				if (animation.finished)
					sstate("normal");
			case "scared_start":
				if (isTouching(FlxObject.FLOOR))
					sstate("scared_walk");
			case "scared_walk":
				anim("move");
				flipX = true;
				velocity.x = -50;
				ttick();
				if (tick > 15)
					sstate("scared_nope");
			case "scared_nope":
				animProtect("nope");
				if (animation.finished)
					sstate("normal");
		}

		dashable = Lists.getFlagBool("ARMOR_DASH");
		ground_poundable = Lists.getFlagBool("ARMOR_GROUNDPOUND");
		spike_immunity = Lists.getFlagBool("ARMOR_SPIKES");

		coin_collect_hitbox.setPosition(x - offset.x, y - offset.y);
		super.update(elapsed);
	}

	public function hit(origin:FlxPoint)
	{
		if (hit_stun)
			return;
		SoundPlayer.play_sound(AssetPaths.hurt__ogg);
		Utils.shake("damage");
		sstateAnim("hit");
		PlayState.self.hitStop = 5;
		velocity.x = origin.x < getMidpoint().x ? 100 : -100;
		velocity.y = -100;
		hit_stun = true;
	}

	public function recolor(tier:Int)
	{
		var save_anim:String = animation.name;
		loadAllFromAnimationSet("duck_t" + tier);
		setSize(11, 22);
		offset.set(5, 2);
		anim(save_anim);
	}

	function explode()
	{
		explosion = new TempSprite(x - 30, y - 17);
		explosion.loadAllFromAnimationSet("explosion");
		explosion.anim("explode");
		SoundPlayer.play_sound(AssetPaths.boom__ogg);
		PlayState.self.miscFront.add(explosion);

		explosion.on_update = function()
		{
			if (explosion.animation.frameIndex == 2)
				Utils.shake("groundpound");
			if (explosion.animation.frameIndex == 3)
				visible = false;
		}

		explosion.on_end = function()
		{
			FlxG.camera.flash(0);
			PlayState.self.active_bonfire.respawn();
			visible = true;
			sstate("normal");
			hit_stun = false;
		}
	}

	function control()
	{
		var JUMPING:Bool = !touching_floor;

		var RIGHT:Bool = Ctrl.right[p];
		var LEFT:Bool = Ctrl.left[p];
		var JUMP:Bool = Ctrl.jjump[p];
		var DOWN:Bool = Ctrl.down[p];
		var UP:Bool = Ctrl.up[p];
		var GROUND_POUND:Bool = DOWN && JUMP && !touching_floor;
		var DASH:Bool = JUMPING && JUMP && !GROUND_POUND && dash_reset;
		var SIT:Bool = DOWN && touching_floor;

		if (touching_floor)
			dash_reset = true;

		if (GROUND_POUND && ground_poundable)
		{
			sstateAnim("ground_pound");
			SoundPlayer.play_sound(AssetPaths.groundpound__ogg);
			return;
		}
		if (DASH && dashable)
		{
			dash_reset = false;
			dash_up = UP;
			sstateAnim("dash");
			if (LEFT)
				flipX = true;
			if (RIGHT)
				flipX = false;
			SoundPlayer.play_sound(AssetPaths.dash__ogg);
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
		{
			velocity.y = -jumpBoom * (Math.abs(velocity.x) > speed / 2 ? jump_run_rate : 1);
			SoundPlayer.play_sound(AssetPaths.jump__ogg);
		}

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
			if (state == "dash")
			{
				switch (rainbowEffect % 3)
				{
					case 0:
						mirror.color = FlxColor.BLUE;
					case 1:
						mirror.color = FlxColor.CYAN.getDarkened(0.5);
					case 2:
						mirror.color = FlxColor.PURPLE;
				}
			}
			else
			{
				switch (rainbowEffect % 3)
				{
					case 0:
						mirror.color = FlxColor.BLUE.getDarkened(.5);
					case 1:
						mirror.color = FlxColor.MAGENTA.getDarkened(.5);
					case 2:
						mirror.color = FlxColor.MAGENTA;
				}
			}

			var to_remove:Array<TempSprite> = [];

			for (t in trail)
			{
				if (black_trail_mode)
					t.color = state == "dash" ? FlxColor.CYAN.getDarkened(.8) : FlxColor.MAGENTA.getDarkened(.8);
				if (!t.alive)
					to_remove.push(t);
			}
			for (t in to_remove)
				trail.remove(t, true);

			trail.add(mirror);
		}
	}
}
