extends Control

#Sub menù per cambiare la musica in Real time dalle fonti d'audio in Multiplayer

## Lista di indici di fonti d'audio
@onready var audiol: ItemList = $Audiolist

##Lista di indici di canzoni trovate
@onready var musicl: ItemList = $MusicList

##Nodo da impostare con il chiamante per farli settare la musica
@export var caller: Node3D
## Lista di stream effettive
var streams: Array[String]
## Lista di musica effettiva
var music:Array[String]

## In base agli elementi selezionati in [member audiol] inserisce gli elementi in [member streams]
func set_audio_list(array: Array[String]):
	for x: String in array:
		audiol.add_item(x)
		streams.push_back(x)

## In base agli elementi selezionati in [member musicl] inserisce gli elementi in [member music]
func set_music_list():
	var dir := DirAccess.open("res://Components/Sounds/")
	if dir == null: printerr("Cartella non trovata"); return
	dir.list_dir_begin()
	for x: String in dir.get_files():
		if x.get_extension() != "import":
			musicl.add_item(x)
			music.push_back(x)

# Evento di pressione del pulsante che avvia la modifica delle fonti d'audio
func _on_btn_invio_pressed() -> void:
	var lstreams: Array[String]
	var lmus: String
	for x in audiol.get_selected_items():
		lstreams.push_back(streams[x])
	lmus = music[musicl.get_selected_items()[0]]
	caller.global_music_start(lstreams, lmus)
