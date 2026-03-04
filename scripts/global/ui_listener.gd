extends Node

var paused = false
var preview = false

var player: CharacterBody3D = null
var ui: CanvasLayer = null

func _process(_delta: float) -> void:
	
	if !get_tree().current_scene.name == "main_menu":
		
		player = get_tree().get_nodes_in_group("player")[0]
		ui = get_tree().get_nodes_in_group("ui")[0]
		
		# handles pause menu
		if Input.is_action_just_pressed("pause_menu") and !Inventory.open:
			if paused:
				get_tree().paused = false
				ui.get_node("pause_menu").hide()
				ui.get_node("dim").hide()
				if !player.get_node("head/RayCast3D").talking:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				get_tree().paused = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				ui.get_node("pause_menu").show()
				ui.get_node("dim").show()
			paused = !paused

		# handles map pause
		if Input.is_action_just_pressed("map") and !Inventory.open:
			PlayerData.save_player_data()

		# handles inventory pause
		if Input.is_action_just_pressed("inventory"):
			if Inventory.open:
				Inventory.close_inventory()
			paused = !paused
	
		# handles closing item pickup
		if Input.is_action_just_pressed("interact") and UiListener.preview:
			paused = !paused
			UiListener.preview = false
			get_tree().paused = false
			ui.get_node("item_popup").hide()
			ui.get_node("item_popup/AnimationPlayer").stop()
			ui.get_node("dim").hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# handles item pickup ui
func item_preview(hit) -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var item_popup = ui.get_node("item_popup")
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
	var tex = ui.get_node("visibility").texture
	if hidden:
		tex.speed_scale = -1
		tex.pause = false
	elif !hidden:
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
