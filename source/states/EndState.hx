package states;

import flixel.FlxState;
import ui.Timer;

class EndState extends FlxState
{
	var bg:FlxSpriteExt;

	var timer:Timer;

	var tick:Int = 29;

	var FLICKER:Bool = true;

	override public function create()
	{
		super.create();
		add(bg = new FlxSpriteExt());
		bg.loadAllFromAnimationSet("ending");
		bg.scrollFactor.set(0, 0);

		SoundPlayer.play_sound(AssetPaths.congratulations__ogg);
		FlxG.sound.playMusic(AssetPaths.opening__ogg, 0.5);

		add(timer = new Timer());
		timer.y -= 16 * 10;

		#if newgrounds
		NewgroundsHandler.post_score(PlayState.tot_time, 11730);
		#end
	}

	override function update(elapsed:Float)
	{
		FLICKER = bg.animation.finished;
		if (FLICKER)
		{
			tick++;
			if (tick % 30 == 0)
				timer.flicker();
		}
		super.update(elapsed);
	}
}
