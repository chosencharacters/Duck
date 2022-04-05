package states;

import flixel.FlxState;
import flixel.tweens.misc.NumTween;

class IntroState extends FlxState
{
	var bg:FlxSpriteExt;

	override public function create()
	{
		super.create();
		add(bg = new FlxSpriteExt());
		bg.loadAllFromAnimationSet("intro");
		bg.scrollFactor.set(0, 0);

		FlxG.camera.flash(FlxColor.BLACK);
		FlxG.sound.playMusic(AssetPaths.opening__ogg);
	}

	override function update(elapsed:Float)
	{
		Ctrl.update();
		if (Ctrl.jjump[1])
		{
			if (bg.animation.frameIndex == bg.numFrames - 1)
				FlxG.camera.fade(FlxColor.BLACK, function()
				{
					FlxG.switchState(new PlayState());
				});
			else
				bg.animation.frameIndex++;
		}
		super.update(elapsed);
	}
}
