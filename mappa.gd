extends Node3D
## Dizionario contenente gli audiostream e il momento a cui sono arrivati di riproduzione
var timestamps: Dictionary[String,float]

## Lista di stringhe che contiene tutti gli [AudioStreamPlayer3D]
@export var audiostreams : Array[String]

## Nodi audio contenuti in [member self]
@onready var audios: Node = $Audios


func _ready() -> void:
	if multiplayer.is_server():
		for x in audios.get_children():
			if x is AudioStreamPlayer3D:
				timestamps.set(x.name, 0)
				x.play()
		audiostreams = timestamps.keys()
		
## Ritorna il nodo [param AudioStreamPlayer3D] con lo stesso nome di [param audio]
func get_audio_node(audio: String)-> AudioStreamPlayer3D:
	return audios.get_node(audio)
