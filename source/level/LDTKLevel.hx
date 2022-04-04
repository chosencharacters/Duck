package level;

import flixel.addons.tile.FlxTilemapExt;
import flixel.tile.FlxTilemap;
import items.Coin;

class LDTKLevel extends FlxTilemapExt
{
	public static var project:LdtkProject = new LdtkProject();

	var tile_size:Int = 16;

	var lvl_width:Int = 0;
	var lvl_height:Int = 0;
	var array_len:Int = 0;

	public var col_map:Array<Int> = [];
	public var col:FlxTilemapExt;

	public function new(level_name:String, graphic:String, layer_name:String, tile_size:Int = 16)
	{
		super();
		this.tile_size = tile_size;
		generate(level_name, graphic, layer_name);
	}

	function generate(level_name:String, graphic:String, layer_name:String)
	{
		var data:LdtkProject_Level = get_level_by_name(level_name);
		setPosition(data.worldX, data.worldY);

		var layer = data.resolveLayer(layer_name);

		lvl_width = layer.cWid;
		lvl_height = layer.cHei;
		var int_grid:Array<Int> = [];

		for (x in 0...lvl_width)
			for (y in 0...lvl_height)
			{
				var tile = switch (layer_name)
				{
					case "Tiles":
						data.l_Tiles.getTileStackAt(x, y);
					default:
						null;
				}

				var index:Int = Math.floor(x + y * lvl_width);
				int_grid[index] = tile.length > 0 ? tile[0].tileId : 0;
			}
		array_len = int_grid.length;
		loadMapFromArray(int_grid, lvl_width, lvl_height, graphic, tile_size, tile_size);

		for (x in 0...lvl_width)
			for (y in 0...lvl_height)
				col_map[Math.floor(x + y * lvl_width)] = data.l_Collision.getInt(x, y);

		col = new FlxTilemapExt();

		col.loadMapFromArray(col_map, lvl_width, lvl_height, AssetPaths.collision__png, tile_size, tile_size);
		col.setTileProperties(1, FlxObject.NONE);
		col.setTileProperties(2, FlxObject.ANY);
		col.setTileProperties(3, FlxObject.UP);
		col.setTileProperties(4, FlxObject.NONE);
		col.setTileProperties(5, FlxObject.NONE);
		col.setTileProperties(8, FlxObject.NONE);
		col.setSlopes([6], [7]);

		for (c in 0...col_map.length)
		{
			if (col_map[c] == 4)
				PlayState.self.coins.add(new Coin(getTileCoordsByIndex(c, false).x, getTileCoordsByIndex(c, false).y));
			if (col_map[c] == 5)
				PlayState.self.spikes.add(new Spike(getTileCoordsByIndex(c, false).x, getTileCoordsByIndex(c, false).y));
			if (col_map[c] == 8)
			{
				new BreakableBlock(col.getTileCoordsByIndex(c, false).x + x, col.getTileCoordsByIndex(c, false).y + y, getTileByIndex(c));
				col_map[c] = 2;
			}
		}

		col.alpha = 0.5;

		col.setPosition(x, y);

		PlayState.self.cols.add(col);
	}

	function get_level_by_name(level_name:String):LdtkProject_Level
	{
		for (data in project.levels)
		{
			if (data.identifier == level_name)
			{
				return data;
			}
		}
		throw "level does not exist by the name of '" + level_name + "'";
	}
}
