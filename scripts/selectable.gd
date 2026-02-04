extends Node3D

@onready var item = $item
@onready var outline_mesh = $item/MeshInstance3D/outline

var selected = false
var hide_outline = false
var outline_width = 0.05

func _ready() -> void:
	get_tree().current_scene.get_node("player/head/RayCast3D").interact_object.connect(_set_selected)
	outline_mesh.visible = false


func _process(_delta: float) -> void:
	outline_mesh.visible = selected and !hide_outline
	if get_node("/root/" + get_tree().current_scene.name + "/player/head/RayCast3D").talking:
		hide_outline = true
	else:
		hide_outline = false

func _set_selected(object):
	selected = self == object
