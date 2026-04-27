extends Node3D
@onready var Sprite: Node3D = $"8-WayAnimatedSprite"


@rpc("any_peer","call_remote", "reliable")
func interaz()-> void:
	if Sprite.get_action() == "_Idle":
		Sprite.set_action("_Running")
	else: Sprite.set_action("_Idle")
