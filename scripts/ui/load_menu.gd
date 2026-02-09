extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var saves = FileHandler.get_files_in_folder(PlayerData.save_path)
	
	# create new slot in ui bound to each save file
	for save in saves:
		var slot := Button.new()
		var index = save.find("_") + 1
		var label = save.substr(0, index-1) + " " + save.substr(index).replace("-", ":").replace(".json", "")
		slot.text = label
		slot.pressed.connect(_on_file_button_pressed.bind(save))
		$MarginContainer/VBoxContainer/Control/MarginContainer/save_slots.add_child(slot)

func _on_file_button_pressed(file_name: String) -> void:
	SceneManager.load_game(file_name)
