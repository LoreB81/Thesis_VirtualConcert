extends Control

@onready var outs: OptionButton = $ColorRect/OutputSelect
@onready var ins: OptionButton = $ColorRect/InputSelect
var input_devices: PackedStringArray
var output_devices: PackedStringArray


signal finished

# Rende visibile il mouse, effettua il prelievo dei dispositivi audio di ingresso 
# e di uscita del dispositivo r li aggiunge alla lista del menu
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	input_devices = AudioServer.get_input_device_list()
	output_devices = AudioServer.get_output_device_list()
	for x in input_devices:
		ins.add_item(x)
	for x in output_devices:
		outs.add_item(x)
	ins.selected = Impostazioni.input_selected
	outs.selected = Impostazioni.output_selected

#Chiude la connessione e ritorna al menù principale
func _on_btn_exit_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://Menus/general_menu.tscn")


func _on_btn_riprendi_pressed() -> void:
	pause_stop()
#finisce la modalità pausa e chiude il menù
func pause_stop():
	finished.emit()
	self.queue_free()

# entrambi i tasti prelevano il dispositivo selezionato dalla lista e lo impostano come dispositivo audio
func _on_btn_confirm_out_pressed() -> void:
	Impostazioni.output_selected = outs.get_selected_id()
	AudioServer.output_device = output_devices[outs.get_selected_id()]

func _on_btn_confirm_in_pressed() -> void:
	Impostazioni.input_selected = ins.get_selected_id()
	AudioServer.input_device = input_devices[ins.get_selected_id()]
