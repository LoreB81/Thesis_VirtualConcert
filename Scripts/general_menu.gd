extends Control

#Menù principale

#Mette in modalità multiplayer locale
func localmp_button() -> void:
	get_tree().change_scene_to_file("res://Menus/localmpmenu.tscn")

# Mette in modalità peer2peer
func p2p_button() -> void:
	get_tree().change_scene_to_file("res://Menus/pto_p_menu.tscn")

func server_button() -> void:
	get_tree().change_scene_to_file("res://Menus/server_menu.tscn")
