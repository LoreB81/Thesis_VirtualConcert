extends Control

func _on_btnstart_pressed() -> void:
	get_tree().change_scene_to_file("res://baseplate.tscn")
