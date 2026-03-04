extends Node

var current_scene = null
var scene_path = ""
var main_menu = preload("res://scenes/main_menu.tscn")
var level = preload("res://scenes/town.tscn")

var progress_bar
var loading = false

var day_start = true
var should_save = true

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
	should_save = true
	start_day()

func load_game(save_slot) -> void:
	PlayerData.clear_data()
	if PlayerData.load_player_data(save_slot) == OK:
		should_save = false
		start_day()

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
		var player = get_tree().get_nodes_in_group("player")[0]
		var ui = get_tree().get_nodes_in_group("ui")[0]
		
		player.global_transform.origin = PlayerData.spawn
		player.look_at(Vector3(0, 0, 0))
		player.rotation.x = 0
		
		ui.get_node("day").text = "DAY " + str(PlayerData.day)
		ui.get_node("health/RichTextLabel").text = "HP: " + str(PlayerData.health) + "/100 "
		ui.get_node("health/HSlider").value = PlayerData.health
		
		if day_start:
			get_tree().get_nodes_in_group("player")[0].hidden = true
			PlayerData.health = 100
			if should_save:
				PlayerData.save_player_data()
			should_save = true

func start_day():
	day_start = true
	PlayerData.day_time = [0,0]
	PlayerData.spawn = Vector3(5,1.5,0)
	PlayerData.location = "player_house"
	change_scene("res://scenes/home.tscn")

# player doesn't survive day; load last save
func reset_day():
	# show game over screen, reload from last checkpoint/quit to title
	should_save = false
	if PlayerData.last_save != "":
		load_game(PlayerData.last_save)
	else:
		change_scene("res://scenes/main_menu.tscn")

# player survives day
func end_of_day():
	#play eod screen, saving symbol
	PlayerData.day += 1
	start_day()
