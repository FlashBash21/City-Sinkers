extends CharacterBody2D

signal respawn_me
const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@export var inventory_data : Inventory_Data

var selected_slot : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func modify_slot(index : int) -> void:
	if inventory_data.inv.size()-1 < index:
		push_error("Tried to access non-existent inventory tile")
		return
	var slot = inventory_data.inv[index]
	if slot == null: return;
	if slot.quantity > 1:
		slot.quantity -= 1
	else:
		inventory_data.inv[index] = null;

func isSlotPopulated(index : int) -> bool:
	var slot = inventory_data.inv[index]
	if (slot == null): return false
	if (slot.quantity < 1): return false;
	return true
		
#handle other, less important code
func _process(_delta) -> void:
	if(Input.is_action_just_pressed("use_item")):
		print("Boom!")
		modify_slot(selected_slot)
	if(Input.is_action_just_pressed("select_left")
		 || Input.is_action_just_pressed("select_right")):
			var i = Input.get_action_strength("select_right") - Input.get_action_strength("select_left")
			selected_slot += int(i)
			if (selected_slot > inventory_data.inv.size()-1):
				selected_slot = 0
			elif (selected_slot < 0):
				selected_slot = inventory_data.inv.size()-1
			print("Selected Slot: " + str(selected_slot))

#handle physics code
func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("building"):
		emit_signal("respawn_me")
