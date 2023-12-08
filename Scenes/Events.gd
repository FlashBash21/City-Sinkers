extends Node
@onready var buildingEvent : Node = $MakeBuilding
@onready var foundationEvent : Node = $RepairFoundation
@export var event_list: Array = [] 

func PickEvent():
	var event = pick_random_event() #holds the name of the event
	print(event)
	## Runs the correct event based on the choosen event
	if(event == "MakeBuilding"):
		buildingEvent.MakeBuilding() 
	elif(event == "RepairFoundation"):
		foundationEvent.RepairFoundation()


func pick_random_event(event_array: Array = event_list):
	var choosen_value = null
	if event_list.size() > 0:
		var overall_chance = 0
		for event in event_list:
			if event.PICKABLE:
				overall_chance += event.PICK_CHANCE
		randomize()		
		var random_number = randi() % overall_chance
		var offset = 0
		for event in event_list:
			if event.PICKABLE:
				if random_number < event.PICK_CHANCE + offset:
					choosen_value = event.NAME
					break
				else:
					offset += event.PICK_CHANCE
					
	return choosen_value
