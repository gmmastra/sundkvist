extends Node

var current_scene = null
var main_menu = preload("res://scenes/main_menu.tscn")
var level = preload("res://scenes/town.tscn")


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)

func goto_scene(path):
	current_scene = get_tree().current_scene
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func start() -> void:
	get_tree().change_scene_to_file("res://scenes/town.tscn")

func change_scene(scene_path) -> void:
	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
	
	
	await get_tree().process_frame
	Inventory.bind_variables()
	get_tree().change_scene_to_file(scene_path)
