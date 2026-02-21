extends CharacterBody3D

@export var walk_speed: float = 1.5
@export var chase_speed: float = 3.5
@export var chase_distance: float = 10.0
@export var attack_reach: float = 1.5

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var player: CharacterBody3D = null


func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(_delta: float) -> void:
	move_and_slide()
