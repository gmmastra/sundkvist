extends Node3D

var open = false

func toggle_door():
	if $AnimationPlayer.current_animation != "open" and $AnimationPlayer.current_animation != "close":
		open = !open
		if !open:
			$AnimationPlayer.play("open")
		if open:
			$AnimationPlayer.play("close")
