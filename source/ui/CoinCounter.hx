package ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxBitmapText;

class CoinCounter extends FlxTypedSpriteGroup<FlxSprite>
{
	#if html5
	var text:FlxBitmapText;
	#else
	var text:FlxText;
	#end

	var coin:FlxSpriteExt;

	var shake_tick:Int = 0;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		coin = new FlxSpriteExt(4, 4);
		coin.loadAllFromAnimationSet("coin_gold");
		coin.anim("spin_once");

		#if html5
		var charSize = FlxPoint.get(7, 9);
		var monospaceLetters:String = " 0123456789:x";
		var fontMonospace = FlxBitmapFont.fromMonospace("assets/fonts/CounterText.png", monospaceLetters, charSize);
		text = new FlxBitmapText(fontMonospace);
		text.scrollFactor.set(0, 0);
		text.setPosition(coin.x + 9, coin.y);
		text.autoSize = false;
		text.width = text.fieldWidth = 302;
		text.letterSpacing = -1;
		text.multiLine = true;
		text.text = "x000";
		#else
		text = new FlxText(coin.x + 6, coin.y - 6, 302, "x000");
		text = Utils.formatText(text, "left", FlxColor.BLACK, true, "assets/fonts/RetroMedievalV3.ttf", 16);
		#end

		add(coin);
		add(text);

		scrollFactor.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		shake_part();
		super.update(elapsed);
	}

	public function shake_part()
	{
		coin.ttick();

		if (shake_tick >= 0 && coin.tick % 2 == 0)
			shake_tick--;

		switch (shake_tick)
		{
			case 0:
				offset.set();
			case 1:
				offset.set(-1, 0);
			case 2:
				offset.set(0, -1);
			case 3:
				offset.set(1, 0);
			case 4:
				offset.set(0, 1);
		}
	}

	public function collect()
	{
		shake_tick = 4;

		coin.anim("idle");
		coin.anim("spin_once");

		text.text = "x" + PlayState.self.coins_collected;
		if (PlayState.self.coins_collected < 100)
			text.text = "x0" + PlayState.self.coins_collected;
		if (PlayState.self.coins_collected < 10)
			text.text = "x00" + PlayState.self.coins_collected;
	}
}
