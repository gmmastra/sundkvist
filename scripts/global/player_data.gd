extends Node
var save_path: String = "user://save_files/"
var img_save_path: String = "user://save_files/previews/"
signal config_loaded

var spawn = Vector3(5,1.5,0)
var location = "town"

var day: int = 1
var day_time = [0,0]
var inventory_items:= {
	"key": InventoryItem.new(),
	"sword": InventoryItem.new()
}

var held_inventory:= []

func _ready() -> void:
	clear_data()

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
		"spawn": get_node("/root/" + get_tree().current_scene.name + "/Viewport/game/player").global_position,
		"location": location,
		"held_inventory": held_inventory,
		"inventory_items": inventory_items_to_dict()
	}
	var save_name = Time.get_datetime_string_from_system().replace("T", "_").replace(":", "-")
	var err: Error = FileHandler.store_json_file(save_data, save_path + save_name + ".json", true)
	FileHandler._check_and_create_directory(img_save_path, true)
	UiListener.save_slot_img.save_png(img_save_path + save_name + ".png")
	if err != OK:
		push_error("Could not save player data: ", error_string(err))

func save_player_config() -> void:
	var config: Dictionary = {
		"resolution": OptionsPanel.current_res,
		"fullscreen": OptionsPanel.fullscreen,
	}
	
	var err: Error = FileHandler.store_json_file(config, "user://config.json", true)
	if err != OK:
		push_error("Could not save settings config: ", error_string(err))


func load_player_data(save_slot) -> Error:
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(save_path + save_slot, save_data)
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
	location = save_data["location"]
	held_inventory = save_data["held_inventory"]
	inventory_items.clear()
	for item_id in save_data["inventory_items"].keys():
		inventory_items[item_id] = InventoryItem.from_dict(save_data["inventory_items"][item_id])
	return OK

func load_player_config() -> Error:
	var config: Dictionary = {}
	var err: Error = FileHandler.open_json_file("user://config.json", config)
	if err == ERR_FILE_NOT_FOUND:
		save_player_config()
		err = OK
	if err != OK:
		push_error("Could not load settings config: ", error_string(err))
		return err
	
	var res = config["resolution"].replace("(", "").replace(")", " ").replace(", ", "x")
	OptionsPanel.current_res = res
	OptionsPanel.fullscreen = config["fullscreen"]
	config_loaded.emit()
	return OK

func verify_save_data(save_data: Dictionary) -> Error:
	if !save_data.has("day"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("spawn"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("location"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("held_inventory"):
		return ERR_DOES_NOT_EXIST
	if !save_data.has("inventory_items"):
		return ERR_DOES_NOT_EXIST
	return OK

# resets player information
func clear_data():
	day = 1
	spawn = Vector3(5,1.5,0)
	location = "town"
	held_inventory = []
	inventory_items = {
		"key": InventoryItem.new(),
		"sword": InventoryItem.new()
	}
	inventory_items["key"].name = "key"
	inventory_items["key"].description = "could open something..."
	inventory_items["sword"].name = "sword"
	inventory_items["sword"].description = "what is this for?"
