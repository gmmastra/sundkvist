extends Node


func _ready() -> void:
	get_node("options_panel/ColorRect/close").pressed.connect(_on_options_close_pressed)

# start new game
func _on_new_game_pressed() -> void:
	SceneManager.new_game()


# open load menu
func _on_load_game_pressed() -> void:
	#get_node("default_panel").hide()
	#get_node("load_panel").show()
	if PlayerData.load_player_data() == OK:
		SceneManager.change_scene("res://scenes/" + PlayerData.location + ".tscn")


# open options menu
func _on_options_pressed() -> void:
	get_node("default_panel").hide()
	get_node("options_panel").show()


# exit game
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_close_pressed() -> void:
	get_node("options_panel").hide()
	get_node("default_panel").show()
