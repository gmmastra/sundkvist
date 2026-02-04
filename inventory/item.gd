class_name InventoryItem
extends Node

var _name := ""
var description := ""
var picked_up := false
var used := false
var mesh = null
var item_reference = null

func to_dict() -> Dictionary:
	return {
		"name": _name,
		"description": description,
		"picked_up": picked_up,
		"used": used,
		"mesh": mesh,
		"item_reference": item_reference
	}

static func from_dict(data: Dictionary) -> InventoryItem:
	var item := InventoryItem.new()
	item._name = data.get("name")
	item.description = data.get("description")
	item.picked_up = data.get("picked_up")
	item.used = data.get("used")
	item.mesh = data.get("mesh")
	item.item_reference = data.get("item_reference")
	return item
