extends PanelContainer

const Slot = preload("res://Scenes/Slot.tscn")

@onready var item_grid : GridContainer = $MarginContainer/ItemGrid

func _ready() -> void:
	var inv_data = preload()

func populate_item_grid(slot_datas : Array[Slot_Data]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		item_grid.add(slot)
