extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#print($Area2D.get_overlapping_areas())


func _on_area_2d_body_entered(_body):
	print("Detected")
	queue_free()
