extends Node

var current_scene = null
var main_menu = preload("res://scenes/main_menu.tscn")
var level = preload("res://scenes/town.tscn")


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)

func new_game() -> void:
	PlayerData.clear_data()
	change_scene("res://scenes/town.tscn")
	await get_tree().process_frame
	await get_tree().process_frame

func change_scene(scene_path) -> void:
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await get_tree().process_frame
	if get_tree().current_scene.name != "main_menu":
		get_tree().current_scene.get_node("Viewport/game/player").global_transform.origin = PlayerData.spawn
		get_tree().current_scene.get_node("Viewport/game/player").look_at(Vector3(0, 0, 0))
		get_tree().current_scene.get_node("Viewport/game/player").rotation.x = 0
