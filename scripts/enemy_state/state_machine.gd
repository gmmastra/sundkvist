extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State = null
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
	
	if initial_state:
		current_state = initial_state
		initial_state.enter()


func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func on_child_transitioned(state, new_state):
	if state != current_state:
		return
	
	var to_state = states[new_state.to_lower()]
	if current_state:
		current_state.exit()
	
	current_state = to_state
	to_state.enter()
