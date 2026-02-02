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

func _on_hour_timer_timeout() -> void:
	if hour_hand.rotation < deg_to_rad(89):
		hour_hand.rotation += deg_to_rad(15)
	else:
		hour_timer.stop()

func _on_min_timer_timeout() -> void:
	minute_hand.rotation += deg_to_rad(6)
