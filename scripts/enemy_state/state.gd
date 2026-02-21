extends Node
class_name State
@warning_ignore("unused_signal")
signal transitioned(state: State, new_state: String)

func enter():
	pass

func exit():
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
