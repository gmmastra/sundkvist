extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in PlayerData.inventory_items:
		if item == self.name:
			if PlayerData.inventory_items[item].picked_up:
				queue_free()
