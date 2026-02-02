extends Area3D

@onready var ui: Control = get_tree().current_scene.get_node("UI")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:	
	# display dialogue	
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	ui.get_node("Control/reticle").hide()
	await DialogueManager.dialogue_ended
	
	# release player after dialogue end
	player.get_node("head").get_node("RayCast3D").talking_cooldown = true
	await get_tree().create_timer(0.05).timeout
	ui.get_node("Control/reticle").show()
	player.get_node("head").get_node("RayCast3D").player_start()
	player.get_node("head").get_node("RayCast3D").talking = false
	player.get_node("head").get_node("RayCast3D").talking_cooldown = false

func rotate_towards(current_rotation: Vector3, direction: Vector3, lerp_value: float) -> Vector3:
	if direction.length_squared() == 0.0:
		return current_rotation
	var y_rotation := lerp_angle(
		current_rotation.y,
		atan2(direction.x, direction.z),
		lerp_value
	)
	var rotation_smoothed := Vector3(
		current_rotation.x,
		y_rotation,
		current_rotation.z
	)
	return rotation_smoothed
