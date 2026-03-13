extends Control

var valid = true

func _on_btnstart_pressed() -> void:
	var text = %txt_players.text
	if text =="":
		valid = true
	elif text.is_valid_int():
		valid = true
		PlayerCount.changecount(int(text))
	else:
		valid = false
	if valid:
		get_tree().change_scene_to_file("res://baseplate.tscn")
