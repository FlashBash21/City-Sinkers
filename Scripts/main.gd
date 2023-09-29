extends Node2D

var tilemap
var player

var map
var map_width := 18
var map_height := 10

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


func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Vector2i(16,8)):
		tilemap.set_cell(1, tile, 0, Vector2i(-1, -1), -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	#map = init_map(17, 9)
	player = get_node("Player")
	tilemap = get_node("TileMap");
	
	for w in range(map_width):
		for h in range(map_height):
			tilemap.set_cell(0, Vector2i(w, h), 0, Vector2i(0, 2), 0) #background blocks
			tilemap.set_cell(1, Vector2i(w, h), 0, Vector2i(16, 8), 0) #foreground blocks
	for w in range(4, 8):
		for h in range(4, 8):
			tilemap.set_cell(1, Vector2i(w,h), 0, Vector2i(-1, -1), -1) #starting area (air blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("mine")):
		var nearby = tilemap.get_surrounding_cells(tilemap.local_to_map(player.get("position")))
		for i in nearby:
			mine_tile(i)
