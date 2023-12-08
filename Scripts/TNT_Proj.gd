extends RigidBody2D

#@onready var player : CharacterBody2D = $Player

#spawn on player
#give a vector velocity to position of mouse
#when it hits a block it sticks to it?
#have a timer that causes an explosion 1-2sec after velocity is zero
#frees object
@onready var tntTimer : Timer = $Timer
@onready var tilemap = get_node("/root/Main/TileMap")
var velocity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var tile
var no_Collision = true

func set_vel(v, t):
	velocity = v.normalized() * 800
	tile = t
# Called when the node enters the scene tree for the first time.


func _ready():
	tntTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(no_Collision):
		velocity.y += gravity / 60
	var x = move_and_collide(velocity * delta)
	if x != null:
		no_Collision = false
		velocity = Vector2(0, 0)



func _on_timer_timeout():
	tile = tilemap.local_to_map(get("position"))
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
	queue_free()

