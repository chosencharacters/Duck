package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var DISABLE_SCREENSHAKE:Bool = false;

	public static var REVERSE_MENU_CONTROLS:Bool = false;

	public function new()
	{
		super();
		Lists.init();
		addChild(new FlxGame(320, 180, CreditsState, 1, 60, 60, true));
		FlxG.mouse.visible = false;
	}
}
