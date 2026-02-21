extends State
class_name EnemyAttack

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null
var time_elapsed: float = 0.0

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= 0.5:
		player.health -= 5.0
		time_elapsed -= 0.5
	
	if enemy.global_position.distance_to(player.global_position) > enemy.attack_reach:
		emit_signal("transitioned", self, "EnemyChase")
	
	if player.hidden:
		emit_signal("transitioned", self, "EnemyWander")

func physics_process(_delta: float) -> void:
	pass
