extends RigidBody2D
var area
var resting_y = 0
var moving_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# when the building is not moving it won't interact with the player 
	if get_linear_velocity() == Vector2(0,0):
		if abs(resting_y - moving_y) > Tiles.TILE_SIZE.y * 8:
			queue_free()
		resting_y = position.y
		area.set_monitorable(false)
	else:
		moving_y = position.y
		area.set_monitorable(true)
