extends Node2D
var BuildingScene = preload("res://Scenes/Building.tscn")
@onready var tilemap = get_node("/root/Main/TileMap")
var BUILDING_POSITIONS = [Vector2i(1,2), Vector2i(5,2),Vector2i(9,2), Vector2i(13,2), Vector2i(17,2),
						 Vector2i(21,2), Vector2i(25,2), Vector2i(29,2), Vector2i(33,2), Vector2i(37,2),
						Vector2i(41,2)]
var currentBuildings = []

func initializeBuildings():
	for b in BUILDING_POSITIONS:
		var building = BuildingScene.instantiate()
		add_child(building)
		building.set_position(tilemap.map_to_local(b - Vector2i(0, 1)) ) 
		currentBuildings.append(b)

func MakeBuilding():
	##chooses buildings position
	randomize()		
	var p = (randi() % BUILDING_POSITIONS.size())
	var check_position = BUILDING_POSITIONS[p]
	print(check_position)

	
	##checks if location is valid
	for b in currentBuildings: 
		if b == check_position:
			print("already a building here")
			return
		
	if check_position != null:
			if tilemap.get_cell_atlas_coords(1, check_position, false) != Tiles.FOUNDATION:
				print("no foundation")
				return
	
	##adds building if location is valid 
	print("building added")
	var building = BuildingScene.instantiate()
	add_child(building)
	building.set_position(tilemap.map_to_local(check_position - Vector2i(0, 1)) ) 
	currentBuildings.append(check_position)
	
