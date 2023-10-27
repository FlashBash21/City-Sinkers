extends Node2D

var tilemap
var player

var map_width := 36
var map_height := 22

var buildings = []
var Building = preload("res://Scenes/Building.tscn")

# allows mining to destroy DIRT
func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)


# allows explode to destroy DIRT and FOUNDATION
func explode_at(tile:Vector2i):
	var surrounding_tiles = tilemap.get_surrounding_cells(tile)
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, tile) == Tiles.FOUNDATION): 
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
	for t in surrounding_tiles:
		var s_tiles2 = tilemap.get_surrounding_cells(t)
		for t2 in s_tiles2:
			if (tilemap.get_cell_atlas_coords(1, t2) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, t2) == Tiles.FOUNDATION):
				tilemap.set_cell(1, t2, 0, Tiles.EMPTY, -1)
		if (tilemap.get_cell_atlas_coords(1, t) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, t) == Tiles.FOUNDATION):
				tilemap.set_cell(1, t, 0, Tiles.EMPTY, -1)


# find the nearest empty tile that is outside the building
func nearest_empty_tile():
	# 1. get buildings location and size (using pixles?) and find all the tiles it is in and store them in an array (buildings_tiles)
	# 2. use players position and get_surrounding_cells as an array of possible new locations to respawn
	# 3. check each new location to see if it == Tile.EMPTY && != buildings_tiles
	# 4. if true change the players location and break from function
	# 5. if false call get_surround_cells on one of the previous surrounding cells and repeat from step 3 
	#     (should this be recursive or a loop?)
	pass


#respawns the player 4 tiles to the left
func respawn():
	var new_location = tilemap.map_to_local(tilemap.local_to_map(player.get("position")) - Vector2i(4,0))
	player.set_position(new_location)
	tilemap.set_cell(1, tilemap.local_to_map(player.get("position")), 0, Tiles.EMPTY, -1)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = $Player
	player.respawn_me.connect(respawn)
	tilemap = get_node("TileMap")
	player.set_position(tilemap.map_to_local(Vector2i(6,6)))
	
	
	# sets main tiles
	for w in range(map_width):
		for h in range(map_height):
			#		set_cell(layer, cell_coord, source_id (0), Tile, alt tile (0))
			
			tilemap.set_cell(0, Vector2i(w, h), 0, Tiles.BACKGROUND_DIRT, 0) #background blocks
			tilemap.set_cell(1, Vector2i(w, h+2), 0, Tiles.DIRT, 0) #foreground blocks
			tilemap.set_cell(1, Vector2i(w, 2), 0, Tiles.FOUNDATION, 0) #foundation block the buildings sit on
			
	# sets spawn point		
	for w in range(4, 8):
		for h in range(4, 8):
			tilemap.set_cell(1, Vector2i(w,h), 0, Tiles.EMPTY, -1) #starting area (air blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	
	if (Input.is_action_just_pressed("right_click")):
		var tile = tilemap.local_to_map(get_global_mouse_position())
		explode_at(tile)


