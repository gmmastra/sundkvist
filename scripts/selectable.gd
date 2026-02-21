extends Node3D

@onready var outline_mesh = $MeshInstance3D/outline

var selected = false
var hide_outline = false
var outline_width = 0.05

var player_ray: RayCast3D = null

func _ready() -> void:
	player_ray = get_tree().get_nodes_in_group("player")[0].get_node("head/RayCast3D")
	player_ray.interact_object.connect(_set_selected)
	outline_mesh.visible = false


func _process(_delta: float) -> void:
	outline_mesh.visible = selected and !hide_outline
	if player_ray.talking:
		hide_outline = true
	else:
		hide_outline = false

func _set_selected(object):
	selected = get_parent() == object
