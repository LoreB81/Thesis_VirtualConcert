extends Node3D
## Classe che gestisce i vari elementi [class AudioElement] associati per le partite in splitscreen 
class_name SplitScreenAudioManager


## Lista giocatori istanziati
var player_list: Array[CharacterBody3D]

## Variabile per indicare se il componente è attivo o meno
@export var active: bool
## [class AudioElement] da gestire
var audioelements: Array[AudioElement]

## Ultimo player istanziato che rappresenta l'ascoltatore de facto
var last_player: CharacterBody3D = null

#prende la lista di elementi audio che ha come figli
func _ready() -> void:
	for child in get_children():
		if child is AudioElement:
			audioelements.push_back(child)

## Copia la lista di giocatori da [param list] e ne estrae l'ultimo membro istanziato che viene messo in [member last_player]
func set_playerlist(list: Array[CharacterBody3D]):
	player_list = list
	last_player = player_list[-1]

# Prende il giocatore più vicino e cambia la posizione relativa al giocatore
func _process(delta: float) -> void:
	if active && last_player != null:
		for x in audioelements:
			var player = x.get_nearest_player(player_list)
			x.change_audio_stream_pos(x.get_difference_player_position(player),last_player, player)
