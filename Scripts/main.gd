extends Node2D


var tilemap
var player

var map
var map_width := 18
var map_height := 11

#returns a 2D array of Vector3.ZERO's X wide and Y tall
#The vectors populating the returned map represent (i, x, y), where
#i is the id of the tilemap to access
#x is the x_pos of the tile in the tilemap
#y is the y_pos of the tile in the tilemap
func init_map(x:int, y:int):
	var map = []
	
	for w in range(x):
		var col: Array[Vector3] = []
		col.resize(y)
		col.fill(Vector3.ZERO)
		map.append(col)
		
	return map


#breaks foreground tiles
func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	#map = init_map(17, 9)
	player = get_node("Player")
	tilemap = get_node("TileMap");
	
	for w in range(map_width):
		for h in range(map_height):
			tilemap.set_cell(0, Vector2i(w, h), 0, Tiles.BACKGROUND_DIRT, 0) #background blocks
			tilemap.set_cell(1, Vector2i(w, h), 0, Tiles.DIRT, 0) #foreground blocks
	for w in range(4, 8):
		for h in range(4, 8):
			tilemap.set_cell(1, Vector2i(w,h), 0, Tiles.EMPTY, -1) #starting area (air blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile_to_mine = -1; #check CellNeighbor Enum on https://docs.godotengine.org/en/stable/classes/class_tileset.html#enum-tileset-cellneighbor
	if (Input.is_action_just_pressed("mine_right")):
		tile_to_mine = 0;
	if (Input.is_action_just_pressed("mine_left")):
		tile_to_mine = 8;
	if (Input.is_action_just_pressed("mine_up")):
		tile_to_mine = 12;
	if (Input.is_action_just_pressed("mine_down")):
		tile_to_mine = 4;
			
	if (tile_to_mine > -1):	
		var tile = tilemap.get_neighbor_cell(tilemap.local_to_map(player.get("position")), tile_to_mine)
		mine_tile(tile)
		
