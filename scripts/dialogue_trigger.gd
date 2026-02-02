#extends Node3D
#
#@onready var dialogue_ui = get_tree().current_scene.get_node("dialogue_ui/canvas")
#@onready var dialogue_anim: AnimationPlayer = get_tree().current_scene.get_node("dialogue_ui/canvas/AnimationPlayer")
#@onready var speaker_name: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/speaker_name")
#@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/dialogue_text")
#@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
#
#@export var speaker_names: Array[String]
#@export var dialogues: Array[String]
#@export var speaker: Node3D
#
#var current_dialogue = -1
#var started = false
#
#func _ready() -> void:
	#dialogue_ui.get_node("next").connect("pressed", Callable(self, "continue_dialogue"))
#
#func start_dialogue(body):
	#if body == player and !started:
		#started = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#player.SPEED = 0
		#player.get_node("head").sensitivity = 0.0
		#dialogue_ui.visible = true
		#
		## dialogue rotation to look at each other
		#speaker.look_at(player.global_transform.origin)
		#speaker.rotation_degrees.x = 0
		#speaker.rotation_degrees.z = 0
		#player.look_at(speaker.global_transform.origin)
		#player.rotation_degrees.x = 0
		#player.rotation_degrees.z = 0
		#player.get_node("head").look_at(speaker.get_node("head").global_transform.origin)
		#player.get_node("head").rotation_degrees.y = 0
		#player.get_node("head").rotation_degrees.z = 0
		#
		#continue_dialogue()
#
#func end_dialogue():
	#player.SPEED = player.SPEED_DEFAULT
	#player.get_node("head").sensitivity = 0.2
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#dialogue_ui.visible = false
#
#func continue_dialogue():
	#current_dialogue += 1
	#if current_dialogue < dialogues.size():
		#dialogue_text.text = dialogues[current_dialogue]
		#speaker_name.text = speaker_names[current_dialogue]
		#dialogue_anim.play("RESET")
		#dialogue_anim.play("type")
	#else:
		#end_dialogue()
