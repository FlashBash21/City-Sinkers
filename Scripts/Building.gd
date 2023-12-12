extends RigidBody2D
var area
var resting_y = 0
var moving_y = 0

var coinspawn = preload("res://Scenes/coin.tscn")

func _ready():
	area = get_node("Area2D")


func _process(_delta):
	# when the building is not moving it won't interact with the player and when it falls to far it breaks
	var tiles_building_falls = 2
	if get_linear_velocity() == Vector2(0,0):
		if abs(resting_y - moving_y) > Tiles.TILE_SIZE.y * tiles_building_falls:
			var coin = coinspawn.instantiate()
			get_tree().current_scene.add_child(coin)
			coin.set_position(position)
			queue_free()
		resting_y = position.y
		area.set_monitorable(false)
	else:
		moving_y = position.y
		area.set_monitorable(true)
