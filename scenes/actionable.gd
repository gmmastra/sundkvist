extends Area3D

@onready var ui: Control = get_tree().current_scene.get_node("UI")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
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
