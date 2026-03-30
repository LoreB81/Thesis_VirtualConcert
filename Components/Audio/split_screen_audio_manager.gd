extends Node3D
class_name SplitScreenAudioManager
var player_list: Array[CharacterBody3D]
@export var active: bool

var audioelements: Array[AudioElement]
var last_player: CharacterBody3D = null


func _ready() -> void:
	for child in get_children():
		if child is AudioElement:
			audioelements.push_back(child)
	
func set_playerlist(list: Array[CharacterBody3D]):
	player_list = list
	last_player = player_list[-1]
	
func _process(delta: float) -> void:
	if active && last_player != null:
		for x in audioelements:
			var player = x.get_nearest_player(player_list)
			x.change_audio_stream_pos(x.get_nearest_player_position(player),last_player, player)
