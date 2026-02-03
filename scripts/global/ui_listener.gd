extends Node

var paused = false

func _process(_delta: float) -> void:
	# handles pause menu
	if Input.is_action_just_pressed("pause_menu") and !Inventory.open:
		if paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
		paused = !paused

	# handles inventory pause
	if Input.is_action_just_pressed("inventory"):
		if Inventory.open:
			Inventory.close_inventory()
		elif !get_node("/root/" + get_tree().current_scene.name + "/player/head/RayCast3D").talking:
			Inventory.open_inventory()
		paused = !paused


# manual pause override
func manual_pause(want_paused) -> void:
	if want_paused:
		get_tree().paused = true
	else:
		get_tree().paused = false
	paused = !paused
