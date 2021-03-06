/***This is default animation sets associated with a particular spritesheet***/

import haxe.DynamicAccess;

typedef AnimSetData =
{
	var image:String;
	var animations:Array<AnimDef>;
	var dimensions:FlxPoint;
	var offset:FlxPoint;
	var flipOffset:FlxPoint;
	var hitbox:FlxPoint;
	var maxFrame:Int;
	var path:String;
}

/***This an animation definition to be used with AnimSetData***/
typedef AnimDef =
{
	var name:String;
	var frames:String;
	var fps:Int;
	var looping:Bool;
	var linked:String;
}

class Lists
{
	/**Every anim file*/
	static var anim_files:Array<String> = ["general_anims"];

	/** All the animation data*/
	public static var animSets:Map<String, AnimSetData> = new Map<String, AnimSetData>();

	static var base_animation_fps:Int = 12;

	/***misc save data***/
	public static var flags:Map<String, Dynamic>;

	function new() {}

	public static function init()
	{
		flags = new Map<String, Dynamic>();
		loadAnimationSets();
	}

	/***
	 * Animation Set Loading and Usage
	***/
	/**Loads all the animations from several xml files**/
	static function loadAnimationSets()
	{
		for (file in ["general_anims"])
		{
			loadAnimationSet("assets/data/anims/" + file + ".xml");
		}
	}

	static function loadAnimationSet(path:String)
	{
		var xml:Xml = Utils.XMLloadAssist(path);
		for (root in xml.elementsNamed("root"))
		{
			for (sset in root.elementsNamed("animSet"))
			{
				var allFrames:String = "";
				var animSet:AnimSetData = {
					image: "",
					animations: [],
					dimensions: new FlxPoint(),
					offset: new FlxPoint(-999, -999),
					flipOffset: new FlxPoint(-999, -999),
					hitbox: new FlxPoint(),
					maxFrame: 0,
					path: ""
				};

				for (aanim in sset.elementsNamed("anim"))
				{
					var animDef:AnimDef = {
						name: "",
						frames: "",
						fps: base_animation_fps,
						looping: true,
						linked: ""
					};

					if (aanim.get("fps") != null)
						animDef.fps = Std.parseInt(aanim.get("fps"));
					if (aanim.get("looping") != null)
						animDef.looping = aanim.get("looping") == "true";
					if (aanim.get("linked") != null)
						animDef.linked = aanim.get("linked");
					if (aanim.get("link") != null)
						animDef.linked = aanim.get("link");

					animDef.name = aanim.get("name");
					animDef.frames = aanim.firstChild().toString();
					allFrames = allFrames + animDef.frames + ",";

					animSet.animations.push(animDef);
				}

				animSet.image = sset.get("image");
				animSet.path = StringTools.replace(sset.get("path"), "\\", "/");

				if (sset.get("x") != null)
					animSet.offset.x = Std.parseFloat(sset.get("x"));
				if (sset.get("y") != null)
					animSet.offset.y = Std.parseFloat(sset.get("y"));

				if (sset.get("width") != null)
					animSet.dimensions.x = Std.parseFloat(sset.get("width"));
				if (sset.get("height") != null)
					animSet.dimensions.y = Std.parseFloat(sset.get("height"));

				if (sset.get("hitbox") != null)
				{
					var hitbox:Array<String> = sset.get("hitbox").split(",");
					animSet.hitbox.set(Std.parseFloat(hitbox[0]), Std.parseFloat(hitbox[1]));
				}

				if (sset.get("flipOffset") != null)
				{
					var flipOffset:Array<String> = sset.get("flipOffset").split(",");
					animSet.flipOffset.set(Std.parseFloat(flipOffset[0]), Std.parseFloat(flipOffset[1]));
				}

				var maxFrame:Int = 0;

				allFrames = StringTools.replace(allFrames, "t", ",");

				for (frame in allFrames.split(","))
				{
					if (frame.indexOf("h") > -1)
						frame = frame.substring(0, frame.indexOf("h"));

					var compFrame:Int = Std.parseInt(frame);

					if (compFrame > maxFrame)
					{
						maxFrame = compFrame;
					}
				}
				animSet.maxFrame = maxFrame;

				animSets.set(animSet.image, animSet);
			}
		}
	}

	public static function getAnimationSet(image:String):AnimSetData
	{
		return animSets.get(image);
	}

	/***flag methods***/
	public static function getFlag(key:String):Dynamic
	{
		return flags.get(key);
	}

	public static function getFlagInt(key:String):Int
	{
		if (flags.get(key) != null)
		{
			return cast(getFlag(key), Int);
		}
		else
		{
			return 0;
		}
	}

	public static function getFlagBool(key:String):Bool
	{
		if (flags.get(key) != null)
		{
			return cast(getFlag(key), Bool);
		}
		else
		{
			return false;
		}
	}

	public static function getFlagString(key:String):String
	{
		if (flags.get(key) != null)
		{
			return cast(getFlag(key), String);
		}
		else
		{
			return "";
		}
	}

	public static function setFlag(key:String, value:Dynamic):Dynamic
	{
		flags.set(key, value);
		return getFlag(key);
	}

	public static function addFlagInt(key:String, value:Int):Int
	{
		if (flags.get(key) == null)
			return setFlagInt(key, value);
		flags.set(key, getFlagInt(key) + value);
		return getFlagInt(key);
	}

	public static function setFlagInt(key:String, value:Int):Int
	{
		setFlag(key, value);
		return getFlagInt(key);
	}

	public static function setFlagBool(key:String, value:Bool):Bool
	{
		setFlag(key, value);
		return getFlagBool(key);
	}

	public static function setFlagString(key:String, value:String):String
	{
		setFlag(key, value);
		return getFlagString(key);
	}
}
