extends Node


func _ready() -> void:
	get_node("options_panel/ColorRect/close").pressed.connect(_on_options_close_pressed)
	get_node("LoadMenu/MarginContainer/VBoxContainer/close").pressed.connect(_on_load_close_pressed)

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
	$options_panel.show()

func _on_options_close_pressed() -> void:
	$options_panel.hide()
	$default_panel.show()


# exit game
func _on_exit_pressed() -> void:
	get_tree().quit()
