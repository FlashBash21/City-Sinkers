extends Node2D

@onready var player : CharacterBody2D = $Player
@onready var inventory_interface : Control = $UI/InventoryInterface


var tilemap

var map_width := 36
var map_height := 22

#breaks foreground tiles
func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)

func explode_at(tile:Vector2i):
	var surrounding_tiles = tilemap.get_surrounding_cells(tile)
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
	for t in surrounding_tiles:
		var s_tiles2 = tilemap.get_surrounding_cells(t)
		for t2 in s_tiles2:
			if (tilemap.get_cell_atlas_coords(1, t2) == Tiles.DIRT):
				tilemap.set_cell(1, t2, 0, Tiles.EMPTY, -1)
		if (tilemap.get_cell_atlas_coords(1, t) == Tiles.DIRT):
				tilemap.set_cell(1, t, 0, Tiles.EMPTY, -1)



# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	tilemap = get_node("TileMap");
	
	player.set_position(tilemap.map_to_local(Vector2i(6,6)))
	
	for w in range(map_width):
		for h in range(map_height):
			#		set_cell(layer, cell_coord, source_id (0), Tile, alt tile (0))
			tilemap.set_cell(0, Vector2i(w, h), 0, Tiles.BACKGROUND_DIRT, 0) #background blocks
			tilemap.set_cell(1, Vector2i(w, h), 0, Tiles.DIRT, 0) #foreground blocks
	for w in range(4, 8):
		for h in range(4, 8):
			tilemap.set_cell(1, Vector2i(w,h), 0, Tiles.EMPTY, -1) #starting area (air blocks)
			
	#setup inventory
	inventory_interface.set_player_inventory_data(player.inventory_data)


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
	
	if (Input.is_action_just_pressed("right_click") && player.isSlotPopulated(player.selected_slot)):
		var tile = tilemap.local_to_map(get_global_mouse_position())
		explode_at(tile)
		player.modify_slot(player.selected_slot)
		inventory_interface.set_player_inventory_data(player.inventory_data)
