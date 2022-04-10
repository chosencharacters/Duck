package ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxBitmapText;

class Timer extends FlxTypedSpriteGroup<FlxSprite>
{
	#if html5
	var text:FlxBitmapText;
	#else
	var text:FlxText;
	#end

	public function new()
	{
		super(0, 0);

		#if html5
		var charSize = FlxPoint.get(7, 9);
		var monospaceLetters:String = " 0123456789:x";
		var fontMonospace = FlxBitmapFont.fromMonospace("assets/fonts/CounterText.png", monospaceLetters, charSize);
		text = new FlxBitmapText(fontMonospace);
		text.scrollFactor.set(0, 0);
		text.setPosition(FlxG.width - 6 * 9, FlxG.height - 14);
		text.autoSize = false;
		text.width = text.fieldWidth = 302;
		text.letterSpacing = -1;
		text.multiLine = true;
		#else
		text = new FlxText(FlxG.width - 8 * 12, FlxG.height - 14, 302);
		text = Utils.formatText(text, "left", 0xff503737, false, "assets/fonts/RetroMedievalV3.ttf", 16);
		#end

		add(text);

		visible = false;

		scrollFactor.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		text.text = Utils.toTimer(PlayState.tot_time) + "";
		super.update(elapsed);
	}

	public function flicker()
	{
		visible = !visible;
	}
}
