import Utils.Cloner;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;

class SoundPlayer
{
	public static var MUSIC_ALREADY_PLAYING:String = "";
	public static var MUSIC_VOLUME:Float = .6;
	public static var SOUND_VOLUME:Float = 1;

	public static function play_sound(sound_asset:FlxSoundAsset, vol:Float = 1):FlxSound
	{
		return FlxG.sound.play(sound_asset, SOUND_VOLUME * vol);
	}

	static var slots:Array<Array<String>> = [];

	public static function altSound(slot:Int, sounds:Array<String>, vol:Float = 1):FlxSound
	{
		#if nomusic
		return;
		#end
		if (slots[slot] == null || slots[slot] == [] || slots[slot].length == 0)
		{
			slots[slot] = sounds;
		}

		var f:FlxRandom = new FlxRandom();
		f.shuffle(slots[slot]);

		var soundToPlay:String = slots[slot].pop();

		return play_sound(soundToPlay, vol);
	}
}
