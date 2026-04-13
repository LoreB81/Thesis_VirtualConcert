extends Node3D
var timestamps: Dictionary[String,float]
@export var audiostreams : Array[String]


func _ready() -> void:
	if multiplayer.is_server():
		for x in get_children(true):
			if x is AudioStreamPlayer3D:
				timestamps.set(x.name, 0)
				x.play()
		audiostreams = timestamps.keys()


func get_audio_pos(audio:String)-> float:
	return get_node(audio).get_playback_position()
