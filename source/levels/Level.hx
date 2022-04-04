package levels;

import flixel.tile.FlxTilemap;

class Level extends LDTKLevel
{
	public var col:FlxTilemap;

	var project:LdtkProject;
	var level_name:String;

	public function new(project:LdtkProject, level_name:String, graphic:String)
	{
		super(project, level_name, graphic);
	}

	override function generate(Project:LdtkProject, LevelName:String, Graphic:String)
	{
		project = Project;
		level_name = LevelName;

		super.generate(project, level_name, Graphic);

		for (i in 0..._tileObjects.length)
			setTileProperties(i, FlxObject.NONE);

		var data = get_level_by_name(project, level_name);

		col = new FlxTilemap();
		col.loadMapFromArray([for (i in 0...array_len) 1], lvl_width, lvl_height, graphic, tile_size, tile_size);

		for (key in data.l_AutoSource.intGrid.keys())
			col.setTileByIndex(key, data.l_AutoSource.intGrid.get(key));
		for (i in [0, 3, 4])
			col.setTileProperties(i, FlxObject.NONE);
	}

	public function place_entities()
	{
		var data = get_level_by_name(project, level_name);
		/**put entity iterators here**/
		/* 
			example:
				for (entity in data.l_Entities.all_Boy.iterator())
					new Boy(entity.cx, entity.cy);
		 */
	}
}