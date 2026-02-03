extends Node

var inv
var inv_slots
var inv_sprites := []
var open = false


func _ready() -> void:
	inv_slots = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory/slot_container/VBoxContainer/slots")
	inv = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory")

func open_inventory():
	UiListener.manual_pause(true)
	inv.visible = true
	open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close_inventory():
	inv.visible = false
	open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	UiListener.manual_pause(false)

func add_to_inventory(hit):
	var mesh = hit.get_node("item/MeshInstance3D").mesh.get_path()
	PlayerData.inventory[hit.name].picked_up = true
	PlayerData.inventory[hit.name].item_reference = hit
	PlayerData.inventory[hit.name].mesh = mesh
	
	if inv_sprites.size() <= 8:
		inv_sprites.append(mesh)
		add_sprite_to_view(mesh)


func remove_from_inventory(hit):
	var mesh = hit.get_node("item/MeshInstance3D").mesh.get_path()
	var index= inv_sprites.find(mesh)
	
	if index != -1:
		PlayerData.inventory[hit.name].used = true
		inv_sprites.remove_at(index)
		render_array()


func add_sprite_to_view(mesh):
	inv_slots.get_node("slot" + str(inv_sprites.size())).disabled = false
	inv_slots.get_node("slot" + str(inv_sprites.size()) + "/SubViewport/MeshInstance3D").mesh = load(mesh)
	inv_slots.get_node("slot" + str(inv_sprites.size()) + "/SubViewport/MeshInstance3D").visible = true


func remove_sprite_from_view(index):
	inv_slots.get_node("slot" + str(index)).disabled = true
	inv_slots.get_node("slot" + str(index) + "/SubViewport/MeshInstance3D").visible = false


func render_array():
	# clear current inventory sprites
	for i in 9:
		remove_sprite_from_view(i + 1)
	
	# load in still present inventory sprites
	for sprite in inv_sprites:
		add_sprite_to_view(sprite)
	pass
