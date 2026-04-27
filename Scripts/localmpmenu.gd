extends Control

# Script del menù del giocatore locale

## Variabile [bool] che indica se il numero di giocatori inseriti è valido
var valid = true

# Evento quando viene premuto il tasto start
func _on_btnstart_pressed() -> void:
	var text = %txt_players.text
	if text =="":
		valid = true
	elif text.is_valid_int():
		valid = true
		InfoPartita.changecount(int(text))
	else:
		valid = false
	if valid:
		get_tree().change_scene_to_file("res://Components/local_mp/local_mp.tscn")


# Eventi quando vengono selezionate le check boxes
func _on_check_box_toggled(toggled_on: bool) -> void:
	InfoPartita.set_splitscreen(toggled_on)

func _controller_toggle(toggled_on: bool) -> void:
	InfoPartita.set_controller(toggled_on)
