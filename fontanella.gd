extends Node3D
@onready var Sprite: Node3D = $"8-WayAnimatedSprite"
signal finished
func interaz()-> void:
	if Sprite.get_action() == "_Idle":
		Sprite.set_action("_Running")
	else: Sprite.set_action("_Idle")
	finished.emit()
