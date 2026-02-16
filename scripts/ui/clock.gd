extends Control

@export var time_scale := 1.0
@export var start_time := 0.0

@onready var hour_hand := $hour_hand
@onready var minute_hand := $minute_hand
@onready var hour_timer: Timer = $hour_timer
@onready var min_timer: Timer = $min_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hour_timer.start()
	min_timer.start()
	_load_time()

func _load_time() -> void:
	hour_hand.rotation = deg_to_rad(15) * PlayerData.day_time[0]
	minute_hand.rotation = deg_to_rad(6) * PlayerData.day_time[1]

func _on_hour_timer_timeout() -> void:
	if !SceneManager.day_start and !get_node("/root/" + get_tree().current_scene.name + "/Viewport/game/player/head/RayCast3D").talking:
		if hour_hand.rotation < deg_to_rad(89):
			hour_hand.rotation += deg_to_rad(15)
			PlayerData.day_time[0] += 1
		else:
			hour_timer.stop()

func _on_min_timer_timeout() -> void:
	if !SceneManager.day_start and !get_node("/root/" + get_tree().current_scene.name + "/Viewport/game/player/head/RayCast3D").talking:
		if PlayerData.day_time[0] < 12:
			minute_hand.rotation += deg_to_rad(6)
			if PlayerData.day_time[1] < 60:
				PlayerData.day_time[1] += 1
			else:
				PlayerData.day_time[1] = 0
