package actors;

class NPC extends FlxSpriteExt
{
	var name:String = "";

	var BEING_TALKED_TO:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0, name:String)
	{
		super(X, Y);
		this.name = name;

		if (Lists.animSets.exists(name))
			loadAllFromAnimationSet(name);
		else
			loadAllFromAnimationSet('generic_duck');

		PlayState.self.npcs.add(this);
		setPosition(x + 8 - width / 2, y + 16 - height);
	}

	override function update(elapsed:Float)
	{
		if (!visible)
			return;

		var overlapping:Bool = false;

		for (d in PlayState.self.ducks)
			if (d.overlaps(this))
				overlapping = true;

		if (overlapping && !BEING_TALKED_TO)
			PlayState.self.dlg.load_text(load_text());

		BEING_TALKED_TO = overlapping;

		super.update(elapsed);
	}

	function load_text():String
	{
		switch (name)
		{
			case "rad_duck":
				return "Rad Duck: Yo dude what's up? You ready to go on a totally radical quest to save us and stuff?";
			case "nurse_duck":
				return nurse_quips();
			case "exit_duck":
				return "Exit Duck: This is the village exit. You alright dude? You look a little... scared.";
			case "blacksmith":
				return "Quacksmith: Unlock new abilities with better armor here. Ye must collect coins first.";
			case "bread_npc":
				return "Mal: That bread gives me the creeps. It used to be delicious... now it hurts :(";
			default:
				return "";
		}
	}

	function nurse_quips()
	{
		return "Nurse Duck: " + FlxG.random.getObject([
			"Tough break getting killed in the first town. But no medical care is too good for our Hero!",
			"Our Hero should be a lot more careful!",
			"Really be careful around spikes and other stuff that hurts, Hero!"
		]);
	}
}
