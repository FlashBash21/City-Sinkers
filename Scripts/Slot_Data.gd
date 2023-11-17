extends Resource
class_name Slot_Data

const MAX_STACK_SIZE: int = 99

@export var item_data: Item_Data
@export_range(0, MAX_STACK_SIZE) var quantity: int = 1 : set = set_quantity

func set_quantity(value: int) -> void:
	quantity = value;
