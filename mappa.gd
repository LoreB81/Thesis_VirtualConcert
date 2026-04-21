extends Node3D
var timestamps: Dictionary[String,float]
@export var audiostreams : Array[String]
@onready var audios: Node = $Audios


func _ready() -> void:
	if multiplayer.is_server():
		for x in audios.get_children():
			if x is AudioStreamPlayer3D:
				timestamps.set(x.name, 0)
				x.play()
		audiostreams = timestamps.keys()

func get_audio_node(audio: String)-> AudioStreamPlayer3D:
	return audios.get_node(audio)
