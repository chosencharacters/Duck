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

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		bg = new FlxSpriteExt(AssetPaths.dialogue__png);
		text = new FlxText(9, 152 - 2, 302);
		text.color = 0xff503737;
		// text = Utils.formatText(text, "left", FlxColor.BLACK, false, "assets/fonts/Silverling.ttf");

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
					visible = false;
					state = "";
				}
		}
		super.update(elapsed);
	}

	public function load_text(new_text:String)
	{
		loaded_text = new_text;
		index = 0;
		state = "in";
		offset.set(0, -FlxG.height / 4);
		text.text = "";
		trace(new_text);
	}

	function collect()
	{
		kill();
	}
}
