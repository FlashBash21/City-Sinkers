extends PanelContainer

const Slot = preload("res://Scenes/Slot.tscn")

@onready var item_grid : GridContainer = $MarginContainer/ItemGrid

var shovel_types = ["res://Assets/Sprites/DirtShovel.png",
					"res://Assets/Sprites/IronShovel.png",
					"res://Assets/Sprites/DiamondShovel.png",
					"res://Assets/Sprites/PurpleShovel.png"]

func set_inventory_data(inventory_data : Inventory_Data) -> void:
	populate_item_grid(inventory_data.inv)

func populate_item_grid(slot_datas : Array[Slot_Data]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in slot_datas:
		if slot_data.item_data.name == "Shovel":
			slot_data.item_data.texture.set_atlas(load(shovel_types[slot_data.quantity]))
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)
