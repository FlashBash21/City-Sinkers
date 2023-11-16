extends PanelContainer

@onready var texture : TextureRect = $MarginContainer/TextureRect
@onready var quantity_label : Label = $QuantityLabel

func set_slot_data(slot_data : Slot_Data) -> void:
	var item_data = slot_data.item_data
	texture.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.desc]
	
	if slot_data.quantity > -1 and item_data.stackable:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
