extends Node
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		sub_viewport.add_child(preload("res://pto_p.tscn").instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
