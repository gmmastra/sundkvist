extends Node
var save_path_json: String = "user://save_files/savegame.json"

const KEY_DAY: String = "day"
const KEY_INVENTORY: String = "inventory"

var day: int = 1
var inventory:= {
	"key": InventoryItem.new(),
	"sword": InventoryItem.new()
}

func _ready() -> void:
	inventory["key"].name = "key"
	inventory["key"].description = "could open something..."
	inventory["sword"].name = "sword"
	inventory["sword"].description = "what is this for?"

# convert InventoryItems to Dictionaries for json
func inventory_to_dict() -> Dictionary:
	var result := {}
	for item_id in inventory.keys():
		result[item_id] = inventory[item_id].to_dict()
	return result


func save_player_data() -> void:
	print("here")
	var save_data: Dictionary = {
		"day": day,
		"inventory": inventory_to_dict()
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
	
	# parse back to InventoryItem from json
	day = save_data[KEY_DAY]
	inventory.clear()
	for item_id in save_data["inventory"].keys():
		inventory[item_id] = InventoryItem.from_dict(save_data["inventory"][item_id])
	return OK


func verify_save_data(save_data: Dictionary) -> Error:
	if !save_data.has(KEY_DAY):
		return ERR_DOES_NOT_EXIST
	if !save_data.has(KEY_INVENTORY):
		return ERR_DOES_NOT_EXIST
	return OK
