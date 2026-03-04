extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var saves = FileHandler.get_files_in_folder(PlayerData.save_path)
	
	# create new slot in ui bound to each save file
	for save in saves:
		var slot := Button.new()
		slot.text = _convert_label(save)
		slot.alignment = HORIZONTAL_ALIGNMENT_LEFT
		slot.pressed.connect(_on_file_button_pressed.bind(save))
		$MarginContainer/VBoxContainer/Control/MarginContainer/save_slots.add_child(slot)

# parses json data to apply to slot label
func _convert_label(save: String) -> String:
	# load day and playtime from save files
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(PlayerData.save_path + save, save_data)
	if err != OK:
		push_error("Could not load player data: ", error_string(err))
		return ""
	var label = "Day %d\n" % [save_data["day"]]
	label += _time_convert(save_data["playtime"])

	var index = save.find("_") + 1
	save = save.substr(0, index-1) + "T" + save.substr(index).replace("-", ":").replace(".json", "")
	var format = Time.get_datetime_dict_from_datetime_string(save, false)
	var am_pm = "AM"
	if format.hour >= 12:
		am_pm = "PM"
		if format.hour > 12:
			format.hour -= 12
		elif format.hour == 0:
			format.hour = 12
	label += "%02d/%02d/%04d %d:%02d%s" % [format.month, format.day, format.year, format.hour, format.minute, am_pm]
	return label

func _time_convert(time_s):
	var sec = int(time_s) % 60
	var minute = int(time_s / 60) % 60
	var hour = int(time_s / 3600)
	return "%02d:%02d:%02d\n" % [hour, minute, sec]

func _on_file_button_pressed(file_name: String) -> void:
	SceneManager.load_game(file_name)
