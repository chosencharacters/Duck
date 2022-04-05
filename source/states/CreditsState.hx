package states;

import flixel.FlxState;

class CreditsState extends FlxState
{
	var bg:FlxSpriteExt;

	var wait:Int = 60 * 3;

	override public function create()
	{
		super.create();
		add(bg = new FlxSpriteExt());
		bg.loadAllFromAnimationSet("credits");
	}

	override function update(elapsed:Float)
	{
		wait--;
		if (wait == 0)
		{
			FlxG.camera.fade(FlxColor.BLACK, function()
			{
				FlxG.switchState(new MenuState());
			});
		}
		super.update(elapsed);
	}
}
