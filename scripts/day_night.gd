extends Node3D

@export var start_time = 0
@export var day_length:int = 12

@export var morning_color_top: Color = Color("8eb9fd")
@export var morning_color_horiz: Color = Color("d3916b")

@export var day_color_top: Color = Color("d4e5fe")
@export var day_color_horiz: Color = Color("8eb9fd")

@export var evening_color_top: Color = Color("3d6fcd")
@export var evening_color_horiz: Color = Color("e98174")

@onready var world_environment: WorldEnvironment = $Viewport/game/WorldEnvironment
@onready var animation_player: AnimationPlayer = $Viewport/game/AnimationPlayer
@onready var viewport = $Viewport/game

var day_duration = 12
var dayColorList = [
	{"top": morning_color_top, "horizon": morning_color_horiz, "start_time": 0},
	{"top": day_color_top, "horizon": day_color_horiz, "start_time": 2},
	{"top": evening_color_top, "horizon": evening_color_horiz, "start_time": 10},
]
var current_day_state = 0
var duration_multiplier = 1


func _input(event: InputEvent) -> void:
	viewport.push_input(event)

func _ready() -> void:
	_change_duration()
	_set_sun()
	_set_current_state()
	_refresh_day_state()
	_day_change_animation()
	
func _change_duration():
	duration_multiplier = day_length * 5
	animation_player.speed_scale = 1.0 / duration_multiplier
	
func _set_sun():
	animation_player.play("day_night")
	animation_player.seek(start_time)
	
func _set_current_state():
	for i in dayColorList.size():
		if start_time < dayColorList[i].start_time:
			current_day_state = i - 1
			return

func _refresh_day_state():
	var new_state = false
	
	for i in dayColorList.size():
		var same_state = i == current_day_state
		if !same_state and animation_player.current_animation_position > dayColorList[i].start_time:
			current_day_state = i
			new_state = true
			
		if new_state:
			_day_change_animation()

func _day_change_animation():
	var top_color = dayColorList[current_day_state]["top"]
	var horizon_color = dayColorList[current_day_state]["horizon"]
	var tween = create_tween()
	
	var duration = duration_multiplier
	
	tween.tween_property(world_environment, "environment:sky:sky_material:sky_top_color", top_color, duration)
	tween.parallel()
	tween.tween_property(world_environment, "environment:sky:sky_material:sky_horizon_color", horizon_color, duration)
	tween.parallel()
	tween.tween_property(world_environment, "environment:sky:sky_material:ground_bottom_color", top_color, duration)
	tween.parallel()
	tween.tween_property(world_environment, "environment:sky:sky_material:ground_horizon_color", horizon_color, duration)

func _process(_delta: float) -> void:
	_refresh_day_state()
	if $Viewport/game/player/head/RayCast3D.talking:
		animation_player.speed_scale = 0
	else:
		animation_player.speed_scale = 1.0 / duration_multiplier
