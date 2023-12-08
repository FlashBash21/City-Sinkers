extends Node2D

@onready var player : CharacterBody2D = $Player
@onready var inventory_interface : Control = $UI/InventoryInterface
@onready var tilemap : TileMap = $TileMap
@onready var eventTimer : Timer = $EventTimer
@onready var Events : Node = $Events
@onready var makeBuildings : Node = $Events/MakeBuilding




var TNT
var Throwable_tnt = preload("res://Scenes/tnt_proj.tscn")

var map_width := 36
var map_height := 22

var buildings = []
var Building = preload("res://Scenes/Building.tscn")

var BUILDING_POSITIONS = [Vector2i(3,2), Vector2i(6,2),Vector2i(9,2), Vector2i(12,2), Vector2i(15,2),
						 Vector2i(18,2), Vector2i(21,2), Vector2i(24,2), Vector2i(27,2), Vector2i(30,2),
						Vector2i(33,2)]



var resources = 10;
var last_input


# allows mining to destroy DIRT
#breaks foreground tiles
func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
		resources += 0.1

func place_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.EMPTY):
		tilemap.set_cell(1, tile, 0, Tiles.DIRT, 0)


# allows explode to destroy DIRT and FOUNDATION
func explode_at(tile:Vector2i):    #target == tilemap.map_to_local(tile)
	var tnt = Throwable_tnt.instantiate()
	add_child(tnt)
	tnt.set_position((player.get("position")) - Vector2(0,5))
	tnt.set_vel(tilemap.map_to_local(tile) - tnt.get("position"), tile)

	#tnt.set_velocity(1,1)
	
#	var surrounding_tiles = tilemap.get_surrounding_cells(tile)
#	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, tile) == Tiles.FOUNDATION): 
#		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
#	for t in surrounding_tiles:
#		var s_tiles2 = tilemap.get_surrounding_cells(t)
#		for t2 in s_tiles2:
#			if (tilemap.get_cell_atlas_coords(1, t2) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, t2) == Tiles.FOUNDATION):
#				tilemap.set_cell(1, t2, 0, Tiles.EMPTY, -1)
#		if (tilemap.get_cell_atlas_coords(1, t) == Tiles.DIRT || tilemap.get_cell_atlas_coords(1, t) == Tiles.FOUNDATION):
#				tilemap.set_cell(1, t, 0, Tiles.EMPTY, -1)

#respawns the player 4 tiles to the left
func respawn():
	var new_location = tilemap.map_to_local(tilemap.local_to_map(player.get("position")) - Vector2i(4,0))
	player.set_position(new_location)
	tilemap.set_cell(1, tilemap.local_to_map(player.get("position")), 0, Tiles.EMPTY, -1)



# Called when the node enters the scene tree for the first time.
func _ready():
	#sets timer
	eventTimer = $EventTimer
	eventTimer.start()
	
	#sets player 
	player = $Player
	player.respawn_me.connect(respawn)
	player.set_position(tilemap.map_to_local(Vector2i(6,6)))

	TNT = get_node("TNT")
	TNT.set_position(tilemap.map_to_local(Vector2i(5, 7)))
	
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
			
	#setup inventory
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	makeBuildings.initializeBuildings() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	#print(eventTimer.time_left)
	var tile_to_mine = -1; #check CellNeighbor Enum on https://docs.godotengine.org/en/stable/classes/class_tileset.html#enum-tileset-cellneighbor
	var mousePosition = tilemap.local_to_map(get_global_mouse_position())
	var playerPosition = tilemap.local_to_map(player.get_position())
	
	if(Input.is_action_pressed("mine")):
		print("mine")
		
	if (Input.is_action_pressed("move_right") && Input.is_action_pressed("mine")):
		tile_to_mine = 0;
#		print("success")
	
#	if (Input.is_action_just_pressed("mine")):
#		if(last_input < 0):
#			tile_to_mine = 8
#		else:
#			tile_to_mine = 0
		#figure out what data type "direction" is because that's what you set last_input to, then somehow get last_input to dictate which block gets
		#mined WITHIN this funciton. Then figure out why godot doesn't take mouse click input after keyboard input
		#but does take keyboard input simultaneously (you set M to mine).
#	
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("move_left")):
		tile_to_mine = 8;
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("jump")):
		tile_to_mine = 12;
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("move_down")):
		tile_to_mine = 4;

	if (tile_to_mine > -1):
		var tile = tilemap.get_neighbor_cell(tilemap.local_to_map(player.get("position")), tile_to_mine)
		mine_tile(tile)

	if (Input.is_action_just_pressed("explode") && player.isSlotPopulated(player.selected_slot)):
		var tile = tilemap.local_to_map(get_global_mouse_position())
		explode_at(tile)
		player.modify_slot(player.selected_slot)
		inventory_interface.set_player_inventory_data(player.inventory_data)

	
	#if (Input.is_action_just_pressed("explode")):
	#	var tile = tilemap.local_to_map(get_global_mouse_position())
	#	explode_at(tile)
		
	if (Input.is_action_just_pressed("place_block") && resources >= 1):
		resources = resources - 1
		if ((mousePosition - playerPosition).length_squared()) <= 1:
			place_tile(mousePosition)

#	print(tilemap.local_to_map(get_global_mouse_position()))
#	print(tilemap.local_to_map(player.get_position()))
#	print(tilemap.local_to_map(get_global_mouse_position()) - tilemap.local_to_map(player.get_position()))
#	print((mousePosition - playerPosition).length_squared())


func _on_event_timer_timeout():
	Events.PickEvent()	
	eventTimer.start()	
