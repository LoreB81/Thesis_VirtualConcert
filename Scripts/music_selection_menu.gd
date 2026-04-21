extends Control

@onready var audiol: ItemList = $Audiolist
@onready var musicl: ItemList = $MusicList
@export var caller: Node3D
var streams: Array[String]
var music:Array[String]

func set_audio_list(array: Array[String]):
	for x: String in array:
		audiol.add_item(x)
		streams.push_back(x)

func set_music_list():
	var dir := DirAccess.open("res://Components/Sounds/")
	if dir == null: printerr("Cartella non trovata"); return
	dir.list_dir_begin()
	for x: String in dir.get_files():
		if x.get_extension() != "import":
			musicl.add_item(x)
			music.push_back(x)

func _on_btn_invio_pressed() -> void:
	var lstreams: Array[String]
	var lmus: String
	for x in audiol.get_selected_items():
		lstreams.push_back(streams[x])
	lmus = music[musicl.get_selected_items()[0]]
	caller.global_music_start(lstreams, lmus)
