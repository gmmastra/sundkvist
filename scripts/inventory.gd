extends Node

signal item_check

var inv
var inv_slots
var inv_sprites := []
var open = false
var item_target = ""
var was_submitted = false

# bind paths at main scene runtime
func bind_variables():
	inv_slots = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory/slot_container/VBoxContainer/slots")
	inv = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory")
	load_inventory()
	bind_signals()

# connects mouse_events on inventory slots
func bind_signals():
	for i in 8:
		# binds slot clicked signal
		inv_slots.get_node("slot" + str(i+1)).focus_entered.connect(slot_focus_entered.bind(str(i+1)))
		#binds slot hovered signal
		inv_slots.get_node("slot" + str(i+1)).mouse_entered.connect(slot_mouse_entered.bind(str(i+1)))
		inv_slots.get_node("slot" + str(i+1)).mouse_exited.connect(slot_mouse_exited)



# handle item use per slot
func slot_focus_entered(slot_index):
	# handle use item in dialogue
	if !inv_slots.get_node("slot" + slot_index).disabled:
		if get_node("/root/" + get_tree().current_scene.name + "/Viewport/game/player/head/RayCast3D").talking:
			if inv_sprites[int(slot_index) - 1]._name == item_target:
				remove_from_inventory(inv_sprites[int(slot_index) - 1])
				was_submitted = true
				
			item_check.emit()
		# handle use item out of dialogue
		else:
			match slot_index:
				"1":
					pass
				"2":
					pass

# handle hover text per slot
func slot_mouse_entered(slot_index):
	if !inv_slots.get_node("slot" + slot_index).disabled:
		inv.get_node("item_name").text = inv_sprites[int(slot_index) - 1]._name
		inv.get_node("item_desc").text = inv_sprites[int(slot_index) - 1].description

func slot_mouse_exited():
	inv.get_node("item_name").text = ""
	inv.get_node("item_desc").text = ""



func open_inventory():
	if inv == null:
		bind_variables()
	UiListener.manual_pause(true)
	inv.visible = true
	open = true
	was_submitted = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_node("/root/" + get_tree().current_scene.name + "/UI/dim").show()

func close_inventory():
	inv.visible = false
	open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	item_check.emit()
	UiListener.manual_pause(false)
	get_node("/root/" + get_tree().current_scene.name + "/UI/dim").hide()

func add_to_inventory(hit):
	if inv == null:
		bind_variables()
	var item_mesh = hit.get_node("item/MeshInstance3D").mesh.get_path()
	PlayerData.inventory_items[hit.name].picked_up = true
	PlayerData.inventory_items[hit.name]._name = hit.name
	PlayerData.inventory_items[hit.name].mesh = item_mesh
	
	inv_sprites.append(PlayerData.inventory_items[hit.name])
	PlayerData.held_inventory.append(hit.name)
	add_sprite_to_view(hit.name)
	hit.queue_free()

func remove_from_inventory(hit):
	if inv == null:
		bind_variables()
	var index = inv_sprites.find(PlayerData.inventory_items[hit._name])
	var held_index = PlayerData.held_inventory.find(hit._name)
	
	if index != -1:
		PlayerData.inventory_items[hit._name].used = true
		PlayerData.held_inventory.remove_at(held_index)
		inv_sprites.remove_at(index)
		
		render_array()

# handles item submission
func query_item(item_name):
	item_target = item_name
	open_inventory()
	await item_check
	close_inventory()
	return was_submitted


func add_sprite_to_view(item_name):
	var item_mesh = PlayerData.inventory_items[item_name].mesh
	var held_index = PlayerData.held_inventory.find(item_name) + 1
	inv_slots.get_node("slot" + str(held_index)).disabled = false
	inv_slots.get_node("slot" + str(held_index) + "/SubViewport/MeshInstance3D").mesh = load(item_mesh)
	inv_slots.get_node("slot" + str(held_index) + "/SubViewport/MeshInstance3D").visible = true


func remove_sprite_from_view(index):
	inv_slots.get_node("slot" + str(index)).disabled = true
	inv_slots.get_node("slot" + str(index) + "/SubViewport/MeshInstance3D").visible = false


func load_inventory():
	for item in PlayerData.held_inventory:
		inv_sprites.append(PlayerData.inventory_items[item])
	print(inv_sprites)
	render_array()


func render_array():
	# clear current inventory sprites
	for i in 9:
		remove_sprite_from_view(i + 1)
		
	# load in still present inventory sprites
	for sprite in inv_sprites:
		add_sprite_to_view(sprite._name)
