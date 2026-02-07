class_name InventoryItem
extends Node

var _name := ""
var description := ""
var picked_up := false
var used := false
var mesh = null
var inv_slot = 0

func to_dict() -> Dictionary:
	return {
		"name": _name,
		"description": description,
		"picked_up": picked_up,
		"used": used,
		"mesh": mesh,
		"inv_slot": inv_slot
	}

static func from_dict(data: Dictionary) -> InventoryItem:
	var item := InventoryItem.new()
	item._name = data.get("name")
	item.description = data.get("description")
	item.picked_up = data.get("picked_up")
	item.used = data.get("used")
	item.mesh = data.get("mesh")
	item.inv_slot = data.get("inv_slot")
	return item
