extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func process(_delta: float):
	enemy.navigation_agent.set_target_position(player.global_position)
	
	if enemy.global_position.distance_to(player.global_position) > enemy.chase_distance || player.hidden:
		emit_signal("transitioned", self, "EnemyWander")
	
	if enemy.global_position.distance_to(player.global_position) < enemy.attack_reach:
		emit_signal("transitioned", self, "EnemyAttack")

func physics_process(_delta: float) -> void:
	if enemy.navigation_agent.is_navigation_finished():
		return
	
	var next_pos: Vector3 = enemy.navigation_agent.get_next_path_position()
	enemy.velocity = enemy.global_position.direction_to(next_pos) * enemy.chase_speed
