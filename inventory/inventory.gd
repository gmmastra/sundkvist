extends Node

var inv_slots
var inv_size = 0

func _ready() -> void:
	inv_slots = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory/slot_container/VBoxContainer/slots")

func add_to_inventory(hit):
	var mesh = hit.get_node("item/MeshInstance3D").mesh.get_path()
	PlayerData.inventory[hit.name].picked_up = true
	PlayerData.inventory[hit.name].item_reference = hit
	PlayerData.inventory[hit.name].mesh = mesh
	inv_size += 1
	if inv_size <= 9:
		inv_slots.get_node("slot" + str(inv_size)).disabled = false
		inv_slots.get_node("slot" + str(inv_size) + "/SubViewport/MeshInstance3D").mesh = load(mesh)
		inv_slots.get_node("slot" + str(inv_size) + "/SubViewport/MeshInstance3D").visible = true

func remove_from_inventory(hit):
	pass
