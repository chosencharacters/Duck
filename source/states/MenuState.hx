package states;

import flixel.FlxState;
import ng.NGMedalPopup.NGMedalPopUp;

class MenuState extends FlxState
{
	var bg:FlxSpriteExt;
	var logo:FlxSpriteExt;

	var hold:Int = 30;

	var STARTED:Bool = false;

	override public function create()
	{
		super.create();
		add(bg = new FlxSpriteExt());
		bg.loadAllFromAnimationSet("menu");
		bg.scrollFactor.set(0, 0);
		add(logo = new FlxSpriteExt(AssetPaths.logo__png));
		FlxG.camera.flash(FlxColor.BLACK);

		FlxG.sound.playMusic(AssetPaths.opening__ogg, 0.5);
	}

	override function update(elapsed:Float)
	{
		Ctrl.update();
		hold--;
		if (hold <= 0 && Ctrl.jjump[1] && !STARTED)
		{
			STARTED = true;
			SoundPlayer.play_sound(AssetPaths.upgrade__ogg);
			bg.animProtect("start");
			FlxG.camera.fade(FlxColor.BLACK, function()
			{
				FlxG.switchState(new IntroState());
			});
		}
		super.update(elapsed);
	}
}
