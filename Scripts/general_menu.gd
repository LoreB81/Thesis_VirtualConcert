extends Control


func localmp_button() -> void:
	get_tree().change_scene_to_file("res://Menus/localmpmenu.tscn")


func p2p_button() -> void:
	get_tree().change_scene_to_file("res://Menus/pto_p_menu.tscn")
