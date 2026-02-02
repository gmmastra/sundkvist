extends RayCast3D

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")

var talking = false
var talking_cooldown = false

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		# interactable npc/item dialogue
		if hit.get_collision_layer() != null and hit.get_collision_layer() == 17:
			if Input.is_action_just_pressed("interact") and !talking and !talking_cooldown:
				talking = true
				talking_cooldown = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				player_stop()
				hit.get_node("actionable").action()
				return
		# interactable door
		if hit.name == "door":
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_door()

func player_stop():
	player.SPEED = 0
	player.velocity = Vector3(0, 0, 0)
	player.get_node("head").sensitivity = 0.0
	
func player_start():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.SPEED = player.SPEED_DEFAULT
	player.get_node("head").sensitivity = 0.2
