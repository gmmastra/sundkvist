extends Node

var paused = false
var preview = false
var save_slot_img

func _process(_delta: float) -> void:
	
	# handles pause menu
	if Input.is_action_just_pressed("pause_menu") and !Inventory.open and !get_tree().current_scene.name == "main_menu":
		if paused:
			get_tree().paused = false
			get_node("/root/" + get_tree().current_scene.name + "/UI/pause_menu").hide()
			get_node("/root/" + get_tree().current_scene.name + "/UI/dim").hide()
			if !get_node("/root/" + get_tree().current_scene.name + "/Viewport/game/player/head/RayCast3D").talking:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			get_tree().paused = true
			save_slot_img = get_viewport().get_texture().get_image()
			save_slot_img.resize(120, 120)
			
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_node("/root/" + get_tree().current_scene.name + "/UI/pause_menu").show()
			get_node("/root/" + get_tree().current_scene.name + "/UI/dim").show()
		paused = !paused

	# handles map pause
	if Input.is_action_just_pressed("map") and !Inventory.open and !get_tree().current_scene.name == "main_menu":
		PlayerData.save_player_data()

	# handles inventory pause
	if Input.is_action_just_pressed("inventory"):
		if Inventory.open:
			Inventory.close_inventory()
		paused = !paused
	
	# handles closing item pickup
	if Input.is_action_just_pressed("interact") and UiListener.preview and !get_tree().current_scene.name == "main_menu":
		paused = !paused
		UiListener.preview = false
		get_tree().paused = false
		get_node("/root/" + get_tree().current_scene.name + "/UI/item_popup").hide()
		get_node("/root/" + get_tree().current_scene.name + "/UI/item_popup/AnimationPlayer").stop()
		get_node("/root/" + get_tree().current_scene.name + "/UI/dim").hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# handles item pickup ui
func item_preview(hit) -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var item_popup = get_node("/root/" + get_tree().current_scene.name + "/UI/item_popup")
	item_popup.get_node("name").text = "PICKED UP: " + PlayerData.inventory_items[hit]._name
	item_popup.get_node("description").text = PlayerData.inventory_items[hit].description
	item_popup.get_node("item_preview/SubViewportContainer/SubViewport/item_mesh").mesh = load(PlayerData.inventory_items[hit].mesh)
	item_popup.get_node("AnimationPlayer").play("item_preview")
	item_popup.show()
	get_node("/root/" + get_tree().current_scene.name + "/UI/dim").show()
	await get_tree().create_timer(0.5).timeout
	UiListener.preview = true

# toggles visibility meter based on player visibility
func visibility_update(hidden) -> void:
	var tex = get_node("/root/" + get_tree().current_scene.name + "/UI/visibility").texture
	if hidden and tex.current_frame == 2:
		tex.speed_scale = -1
		tex.pause = false
	elif !hidden and tex.current_frame == 0:
		tex.speed_scale = 1
		tex.pause = false

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
