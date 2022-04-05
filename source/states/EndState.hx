package states;

import flixel.FlxState;

class EndState extends FlxState
{
	var bg:FlxSpriteExt;

	override public function create()
	{
		super.create();
		add(bg = new FlxSpriteExt());
		bg.loadAllFromAnimationSet("ending");
		bg.scrollFactor.set(0, 0);

		SoundPlayer.play_sound(AssetPaths.congratulations__ogg);
		FlxG.sound.playMusic(AssetPaths.opening__ogg, 0.5);
	}
}
