extends SubViewport


var _window_size: Vector2i

@onready var _root := get_tree().root
@onready var _rid: RID = get_viewport_rid()


func _ready() -> void:
	_update()


func _process(_delta: float) -> void:
	if _root.size != _window_size:
		_window_size = _root.size
		_update()


func _update() -> void:
	size = _root.size
	RenderingServer.viewport_attach_to_screen(_rid, Rect2(Vector2.ZERO, _root.size))
