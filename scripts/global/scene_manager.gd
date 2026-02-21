extends Node

var current_scene = null
var scene_path = ""
var main_menu = preload("res://scenes/main_menu.tscn")
var level = preload("res://scenes/town.tscn")

var progress_bar
var loading = false

var day_start = true

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)
	progress_bar = SceneTransition.get_node("ProgressBar")

func _process(_delta: float) -> void:
	if loading:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
		progress_bar.show()
		
		match status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
				progress_bar.value = progress[0] * 100
				print("Loading progress: %s" % (progress[0] * 100))
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				loading = false
				progress_bar.hide()
				load_scene(ResourceLoader.load_threaded_get(scene_path))

func new_game() -> void:
	PlayerData.clear_data()
	SceneManager.day_start = true
	scene_path = "res://scenes/home.tscn"
	change_scene(scene_path)

func load_game(save_slot) -> void:
	if PlayerData.load_player_data(save_slot) == OK:
		SceneManager.change_scene("res://scenes/" + PlayerData.location + ".tscn")

func change_scene(new_scene_path) -> void:
	scene_path = new_scene_path
	ResourceLoader.load_threaded_request(scene_path)
	SceneTransition.get_node("AnimationPlayer").play("dissolve")
	await SceneTransition.get_node("AnimationPlayer").animation_finished
	loading = true

# change_scene helper function
func load_scene(scene):
	get_tree().change_scene_to_packed(scene)
	SceneTransition.get_node("AnimationPlayer").play_backwards("dissolve")
	await get_tree().process_frame
	
	if get_tree().current_scene.name != "main_menu":
		get_tree().get_nodes_in_group("player")[0].global_transform.origin = PlayerData.spawn
		get_tree().get_nodes_in_group("player")[0].look_at(Vector3(0, 0, 0))
		get_tree().get_nodes_in_group("player")[0].rotation.x = 0

func end_of_day():
	#play eod screen, saving symbol
	PlayerData.day += 1
	PlayerData.day_time = [0,0]
	PlayerData.spawn = Vector3(5,1.5,0)
	PlayerData.location = "player_house"
	get_tree().get_nodes_in_group("player")[0].hidden = true
	UiListener.save_slot_img = get_viewport().get_texture().get_image()
	UiListener.save_slot_img.resize(120, 120)
	#update enemy spawns
	day_start = true
	PlayerData.save_player_data()
	change_scene("res://scenes/home.tscn")
