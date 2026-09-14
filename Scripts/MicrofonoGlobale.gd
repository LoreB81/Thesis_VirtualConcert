extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.get_multiplayer_authority() != self.get_multiplayer_authority():
		body.get_node("ProximityChat").max_distance = 0


func _on_body_exited(body: Node3D) -> void:
	if body.get_multiplayer_authority() != self.get_multiplayer_authority():
		body.get_node("ProximityChat").max_distance = 15
