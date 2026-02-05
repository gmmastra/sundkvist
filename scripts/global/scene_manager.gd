extends Node

var current_scene = null
var main_menu = preload("res://scenes/main_menu.tscn")
var level = preload("res://scenes/town.tscn")


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)

func change_scene(scene_path) -> void:
	get_tree().change_scene_to_file(scene_path)
