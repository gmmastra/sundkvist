extends Node

var paused = false

func _process(_delta: float) -> void:
	
	# handles pause menu
	if Input.is_action_just_pressed("pause_menu") and !Inventory.open and get_tree().current_scene.name == "level":
		if paused:
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_node("/root/" + get_tree().current_scene.name + "/UI/pause_menu").hide()
			get_node("/root/" + get_tree().current_scene.name + "/UI/dim").hide()
		else:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_node("/root/" + get_tree().current_scene.name + "/UI/pause_menu").show()
			get_node("/root/" + get_tree().current_scene.name + "/UI/dim").show()
		paused = !paused

	# handles inventory pause
	if Input.is_action_just_pressed("inventory"):
		if Inventory.open:
			Inventory.close_inventory()
		paused = !paused


# manual pause override
func manual_pause(want_paused) -> void:
	if want_paused:
		get_tree().paused = true
	else:
		get_tree().paused = false
	paused = !paused

# exits to main menu
func _on_quit_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/main_menu.tscn")
