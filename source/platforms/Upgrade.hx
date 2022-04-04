package platforms;

class Upgrade extends FlxSpriteExt
{
	var costs:Array<Int> = [10, 50, 150, 600];
	var upgrade_level:Int = 0;

	var talk_cd:Int = 0;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		loadAllFromAnimationSet("armor-upgrade");
		PlayState.self.miscFront.add(this);
		immovable = true;
	}

	override function update(elapsed:Float)
	{
		talk_cd--;
		if (upgrade_level <= 3)
		{
			anim("t" + upgrade_level);
		}
		else
		{
			visible = false;
		}

		for (d in PlayState.self.ducks)
		{
			if (d.overlaps(this))
				if (PlayState.self.coins_collected < costs[upgrade_level])
					no_money_dlg();
				else
					upgrade_up();
		}
		super.update(elapsed);
	}

	function no_money_dlg()
	{
		if (talk_cd < 0)
		{
			PlayState.self.dlg.load_text('Quacksmith: Not enough coins m8. Ye need ${costs[upgrade_level]}');
			talk_cd = 120;
		}
	}

	function upgrade_up()
	{
		if (upgrade_level > 3)
			return;
		switch (upgrade_level)
		{
			case 0:
				Lists.setFlagBool("ARMOR_DASH", true);
				PlayState.self.dlg.load_text('Quacksmith: Ay, fine armor, ye can now dash by pressing jump midair.', true);
			case 1:
				Lists.setFlagBool("ARMOR_GROUNDPOUND", true);
				PlayState.self.dlg.load_text('Quacksmith: Ay, groundpound by pressing down and jump midair. It breaks blocks.', true);
			case 2:
				PlayState.self.dlg.load_text('Quacksmith: Ay, spikes will be causin\' ye no trouble anymore.', true);
				Lists.setFlagBool("ARMOR_SPIKES", true);
			case 3:
				PlayState.self.dlg.load_text('Quacksmith: Ay, that be Endgame Armor. You can now face anything. Ye should leave already.', true);
				Lists.setFlagBool("ARMOR_ENDGAME", true);
		}
		FlxG.camera.flash();
		PlayState.self.coins_collected -= costs[upgrade_level];
		PlayState.self.coin_counter.collect();
		for (d in PlayState.self.ducks)
			d.recolor(upgrade_level);
		upgrade_level++;
	}

	function collect()
	{
		kill();
	}
}
