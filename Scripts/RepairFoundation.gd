extends Node2D

@onready var tilemap = get_node("/root/Main/TileMap")

func RepairFoundation():
	var map_width = 36
	for w in range(map_width):
			tilemap.set_cell(1, Vector2i(w, 2), 0, Tiles.FOUNDATION, 0) #foundation block the buildings sit on

