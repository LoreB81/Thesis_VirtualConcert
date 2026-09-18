extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_btn_accept_pressed() -> void:
	self.queue_free()
	
func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
