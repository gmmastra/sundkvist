class_name InventoryItem
extends Node

var picked_up := false
var used := false
var mesh = null
var item_reference = null

func to_dict() -> Dictionary:
	return {
		"picked_up": picked_up,
		"used": used,
		"mesh": mesh,
		"item_reference": item_reference
	}

static func from_dict(data: Dictionary) -> InventoryItem:
	var item := InventoryItem.new()
	item.picked_up = data.get("picked_up")
	item.used = data.get("used")
	item.mesh = data.get("mesh")
	item.item_reference = data.get("item_reference")
	return item
