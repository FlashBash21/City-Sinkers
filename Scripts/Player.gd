extends CharacterBody2D

signal respawn_me
signal update_player_inv
const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var mine_timer : float
var is_mining := false

@export var inventory_data : Inventory_Data

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func modify_slot_quantity(index : int, f : Callable) -> void:
	if inventory_data.inv.size()-1 < index:
		push_error("Tried to access non-existent inventory tile")
		return
	var slot = inventory_data.inv[index]
	if slot == null: return;
	
	slot.set_quantity(f.call(slot.quantity))
	
	if slot.quantity < 1:
		slot.quantity = 0;


func isSlotPopulated(index : int) -> bool:
	var slot = inventory_data.inv[index]
	if (slot == null): return false
	if (slot.quantity < 1): return false;
	return true
		
func mine_interval(delta : float) -> bool:
	var slot = inventory_data.inv[Globals.SHOVEL]
	if (Input.is_action_pressed("mine")):
		if not is_mining:
			is_mining = true
			mine_timer = 1.0 / (slot.quantity + 1) 
		else:
			mine_timer -= delta
			if mine_timer <= 0: 
				is_mining = false
				return true
	else:
		is_mining = false
	print(mine_timer)
	return false
	
#handle other, less important code
func _process(_delta) -> void:
	pass

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

		pass
	move_and_slide()


func _on_hurtbox_area_entered(area):
	
	if area.is_in_group("building"):
		emit_signal("respawn_me")
	if area.is_in_group("tnt"):
		modify_slot_quantity(Globals.TNT, func(x): return x + 1)
		emit_signal("update_player_inv")
