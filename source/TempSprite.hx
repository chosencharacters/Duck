package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Lasts until animation is over then kills itself :(
 * @author Squidly
 */
class TempSprite extends FlxSpriteExt
{
	var tickSet:Int = 0;

	public var on_end:Void->Void;
	public var on_update:Void->Void;

	public function new(?X:Float = 0, ?Y:Float = 0, tickSET:Int = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		tick = tickSET;
		tickSet = tickSET;
	}

	override public function update(elapsed:Float):Void
	{
		trailUpdate();
		tick--;
		if (on_update != null)
			on_update();
		if (animation.finished && tickSet <= 0 || tick <= 0 && tickSet > 0)
		{
			kill();
			if (on_end != null)
				on_end();
		}
		super.update(elapsed);
	}

	override public function kill():Void
	{
		FlxG.state.remove(this, true);
		PlayState.self.miscFront.remove(this, true);
		PlayState.self.miscBack.remove(this, true);
		super.kill();
	}

	var trailTarget:FlxSprite;
	var trailInt:Int = 0;
	var frameMode:Bool = false;
	var trailOffset:FlxPoint;

	// frame mode to toggle between trailSet being for time or frames
	public function setTrail(trailTargetSet:FlxSprite, trailIntSet:Int, frameModeSet:Bool = false)
	{
		trailTarget = trailTargetSet;
		trailInt = trailIntSet;
		frameMode = frameModeSet;
		trailOffset = new FlxPoint(x - trailTarget.x, y - trailTarget.y);
	}

	function trailUpdate()
	{
		if (trailTarget == null)
			return;
		if (!frameMode)
			trailInt--;
		if (frameMode && animation.frameIndex < trailInt || !frameMode && trailInt > 0)
		{
			setPosition(trailTarget.x + trailOffset.x, trailTarget.y + trailOffset.y);
		}
	}

	override public function isOnScreen(?Camera:FlxCamera):Bool
	{
		return true;
	}
}
