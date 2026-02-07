extends Node
var save_path_json: String = "user://save_files/savegame.json"

var spawn = Vector3(0,1.5,0)

var day: int = 1
var inventory_items:= {
	"key": InventoryItem.new(),
	"sword": InventoryItem.new()
}

var held_inventory:= []

func _ready() -> void:
	inventory_items["key"].name = "key"
	inventory_items["key"].description = "could open something..."
	inventory_items["sword"].name = "sword"
	inventory_items["sword"].description = "what is this for?"

# convert InventoryItems to Dictionaries for json
func inventory_items_to_dict() -> Dictionary:
	var result := {}
	for item_id in inventory_items.keys():
		result[item_id] = inventory_items[item_id].to_dict()
	return result


func save_player_data() -> void:
	print("Game saved.")
	var save_data: Dictionary = {
		"day": day,
		"spawn": spawn,
		"held_inventory": held_inventory,
		"inventory_items": inventory_items_to_dict()
	}
	var err: Error = FileHandler.store_json_file(save_data, save_path_json, true)
	if err != OK:
		push_error("Could not save player data: ", error_string(err))
		


func load_player_data() -> Error:
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(save_path_json, save_data)
	if err != OK:
		push_error("Could not load player data: ", error_string(err))
		return err
	
	err = verify_save_data(save_data)
	if err != OK:
		push_error("Invalid save file structure")
		return err
	
	# parse back variables from json
	day = save_data["day"]
	var spawn_vec = save_data["spawn"].replace("(", "").replace(")", "").split(",")
	spawn = Vector3(int(spawn_vec[0]), int(spawn_vec[1]), int(spawn_vec[2]))
	held_inventory = save_data["held_inventory"]
	print(held_inventory)
	
	inventory_items.clear()
	for item_id in save_data["inventory_items"].keys():
		inventory_items[item_id] = InventoryItem.from_dict(save_data["inventory_items"][item_id])
	return OK


func verify_save_data(save_data: Dictionary) -> Error:
	if !save_data.has("day"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("spawn"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("inventory_items"):
		return ERR_DOES_NOT_EXIST
	return OK
