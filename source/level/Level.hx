package level;

import ldtk.Layer_Entities;

using StringTools;

/**
 * ...
 * @author
 */
class Level extends LDTKLevel
{
	public var name:String = "";
	public var id:Int = 0;

	static var ids:Int = 0;

	public var imageName:String;

	public var reversed:Bool = false;

	public function new(level_name:String, graphic:String, layer_name:String, tile_size:Int = 16)
	{
		PlayState.self.lvls.add(this);
		super(level_name, graphic, layer_name, tile_size);
		name = level_name;
		id = ids;
		ids++;
	}

	override public function destroy():Void
	{
		ids = 0;
		super.destroy();
	}

	override function generate(level_name:String, graphic:String, layer_name:String)
	{
		super.generate(level_name, graphic, layer_name);
		place_entities(level_name);
	}

	public function place_entities(level_name:String)
	{
		var data = get_level_by_name(level_name);
		var entities = data.l_Entities;

		for (entity in entities.all_Duck.iterator())
			new Duck(entity.pixelX + x, entity.pixelY + y);
		for (entity in entities.all_Bonfire.iterator())
			new Bonfire(entity.pixelX + x, entity.pixelY + y);
		for (entity in entities.all_NPC.iterator())
			new NPC(entity.pixelX + x, entity.pixelY + y, entity.f_name);
		for (entity in entities.all_Upgrade.iterator())
			new Upgrade(entity.pixelX + x, entity.pixelY + y);
		for (entity in entities.all_Upgrade.iterator())
			new Toast(entity.pixelX + x, entity.pixelY + y);
		for (entity in entities.all_Upgrade.iterator())
			new FlyingToast(entity.pixelX + x, entity.pixelY + y);
	}

	static function first_to_lowercase(s:String):String
		return s.charAt(0).toLowerCase() + s.substr(1);
}
