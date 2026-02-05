extends Node

var tabs

func _ready() -> void:
	tabs = get_node("ColorRect/VBoxContainer")


func _on_video_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO  ▮"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME"
	tabs.get_node("video_tab/options").show()
	tabs.get_node("audio_tab/options").hide()
	tabs.get_node("keybind_tab/options").hide()
	tabs.get_node("game_tab/options").hide()


func _on_audio_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO  ▮"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME"
	tabs.get_node("video_tab/options").hide()
	tabs.get_node("audio_tab/options").show()
	tabs.get_node("keybind_tab/options").hide()
	tabs.get_node("game_tab/options").hide()


func _on_keybind_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND▮"
	tabs.get_node("game_tab").text = "GAME"
	tabs.get_node("video_tab/options").hide()
	tabs.get_node("audio_tab/options").hide()
	tabs.get_node("keybind_tab/options").show()
	tabs.get_node("game_tab/options").hide()


func _on_game_tab_pressed() -> void:
	tabs.get_node("video_tab").text = "VIDEO"
	tabs.get_node("audio_tab").text = "AUDIO"
	tabs.get_node("keybind_tab").text = "KEYBIND"
	tabs.get_node("game_tab").text = "GAME   ▮"
	tabs.get_node("video_tab/options").show()
	tabs.get_node("audio_tab/options").hide()
	tabs.get_node("keybind_tab/options").hide()
	tabs.get_node("game_tab/options").hide()
