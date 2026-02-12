extends Node

func _ready() -> void:
	OptionsPanel.get_node("MarginContainer/VBoxContainer/close").pressed.connect(_on_options_close_pressed)
	get_node("LoadMenu/MarginContainer/VBoxContainer/close").pressed.connect(_on_load_close_pressed)
	PlayerData.config_loaded.connect(_update_config)
	PlayerData.load_player_config()

# load player settings
func _update_config():
	OptionsPanel.set_resolution(OptionsPanel.current_res)
	OptionsPanel.set_fullscreen(OptionsPanel.fullscreen)
	OptionsPanel._update_resolution_values()

# start new game
func _on_new_game_pressed() -> void:
	SceneManager.new_game()

# open load menu
func _on_load_game_pressed() -> void:
	$LoadMenu.show()
	$default_panel.hide()

func _on_load_close_pressed() -> void:
	$LoadMenu.hide()
	$default_panel.show()


# open options menu
func _on_options_pressed() -> void:
	$default_panel.hide()
	OptionsPanel.show()

func _on_options_close_pressed() -> void:
	PlayerData.save_player_config()
	OptionsPanel.hide()
	$default_panel.show()


# exit game
func _on_exit_pressed() -> void:
	get_tree().quit()
