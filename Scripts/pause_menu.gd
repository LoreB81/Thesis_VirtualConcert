extends Control

signal finished

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_btn_exit_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://Menus/general_menu.tscn")



func _on_btn_riprendi_pressed() -> void:
	pause_stop()

func pause_stop():
	finished.emit()
	self.queue_free()
