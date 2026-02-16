extends Node

var tabs
var options

var current_res
var fullscreen = true
var resolutions = {
	"2048x1536 ": Vector2i(2048,1536),
	"1600x1200 ": Vector2i(1600,1200),
	"1280x960 ": Vector2i(1280,960),
	"1024x768 ": Vector2i(1024,768),
	"800x600 ": Vector2i(800,600)
}

func _ready() -> void:
	tabs = OptionsPanel.get_node("MarginContainer/VBoxContainer/tabs/MarginContainer/VBoxContainer")
	options = OptionsPanel.get_node("MarginContainer/VBoxContainer/tabs/options")
	_add_resolutions()
	if OptionsPanel.current_res == null:
		OptionsPanel.current_res = _get_maximum_resolution()


func set_resolution(res):
	OptionsPanel.current_res = resolutions[res]
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_window().size = OptionsPanel.current_res
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		get_window().size = OptionsPanel.current_res
		_center_window()

func set_fullscreen(mode):
	if mode:
		OptionsPanel.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		OptionsPanel.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	options.get_node("video/fullscreen/CheckButton").set_pressed_no_signal(OptionsPanel.fullscreen)

# populate list of supported resolutions
func _add_resolutions():
	options.get_node("video/resolution/OptionButton").clear()
	for res in resolutions:
		options.get_node("video/resolution/OptionButton").add_item(res)

# sets largest resolution possible on initial startup
func _get_maximum_resolution():
	var screen_size = DisplayServer.screen_get_size()
	for res in resolutions:
		if resolutions[res].y < screen_size.y:
			get_window().size = resolutions[res]
			_center_window()
			return resolutions[res]
	return Vector2i(1280,960)

# set current resolution in options menu
func _update_resolution_values():
	var window_size = str(get_window().size.x, "x", get_window().size.y, " ")
	var index = resolutions.keys().find(window_size)
	options.get_node("video/resolution/OptionButton").selected = index

# center window after changing resolution (windowed only)
func _center_window():
	@warning_ignore("integer_division")
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	@warning_ignore("integer_division")
	get_window().set_position(screen_center - window_size / 2)

# change resolution
func _on_resolution_selected(index: int) -> void:
	var key = options.get_node("video/resolution/OptionButton").get_item_text(index)
	set_resolution(key)

# change windowed/fullscreen
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	set_fullscreen(toggled_on)

func _on_video_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO   ▮"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME"
	options.get_node("video").show()
	options.get_node("audio").hide()
	options.get_node("keybind").hide()
	options.get_node("game").hide()


func _on_audio_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO   ▮"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME"
	options.get_node("video").hide()
	options.get_node("audio").show()
	options.get_node("keybind").hide()
	options.get_node("game").hide()


func _on_keybind_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND ▮"
	tabs.get_node("game_tab").text = "GAME"
	options.get_node("video").hide()
	options.get_node("audio").hide()
	options.get_node("keybind").show()
	options.get_node("game").hide()


func _on_game_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME    ▮"
	options.get_node("video").hide()
	options.get_node("audio").hide()
	options.get_node("keybind").hide()
	options.get_node("game").show()
