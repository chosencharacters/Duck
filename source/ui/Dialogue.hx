package ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class Dialogue extends FlxTypedSpriteGroup<FlxSprite>
{
	var text:FlxText;
	var bg:FlxSpriteExt;

	var loaded_text:String = "";
	var index:Int = 0;

	var text_rate:Int = 4;

	var dismiss_time:Int = 4;

	var state:String = "";
	var tick:Int = 0;

	var important_playing:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		bg = new FlxSpriteExt(AssetPaths.dialogue__png);
		text = new FlxText(9, 152 - 6, 302);
		text = Utils.formatText(text, "left", 0xff503737, false, "assets/fonts/RetroMedievalV3.ttf", 16);

		add(bg);
		add(text);

		visible = false;

		scrollFactor.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		switch (state)
		{
			case "in":
				visible = true;
				tick = 0;
				if (offset.y < 0)
					offset.y += 5;
				if (offset.y == 0)
					state = "active";
			case "active":
				if (index < loaded_text.length)
				{
					index++;
					text.text = loaded_text.substr(0, index);
					if (index % 10 == 1)
						SoundPlayer.play_sound(AssetPaths.duckspeak__ogg);
				}
				else
				{
					tick++;
					if (tick > 180)
						state = "out";
				}
			case "out":
				offset.y -= 5;
				if (offset.y <= -FlxG.height / 4)
				{
					important_playing = false;
					visible = false;
					state = "";
				}
		}
		super.update(elapsed);
	}

	public function load_text(new_text:String, important:Bool = false)
	{
		if (!important && important_playing)
			return;
		if (important)
			important_playing = true;
		loaded_text = new_text;
		index = 0;
		state = "in";
		offset.set(0, -FlxG.height / 4);
		text.text = "";
	}

	function collect()
	{
		kill();
	}
}
