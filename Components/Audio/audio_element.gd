extends Node3D
class_name AudioElement

@export var audio_stream: AudioStreamPlayer3D


func change_audio_stream_pos(pos:Vector3, listener: CharacterBody3D):
	audio_stream.position = listener.position + pos
	audio_stream.rotation = listener.modello.global_rotation

func get_nearest_player_distance(player: CharacterBody3D)-> Vector3:
		return Vector3(self.global_position.x - player.position.x, 
		self.global_position.y - player.position.y, self.global_position.z - player.position.z,)
	
func get_nearest_player(array: Array[CharacterBody3D])->CharacterBody3D:
	var closest: CharacterBody3D = null
	var closest_distance : float = INF
	var to_position : Vector3 = self.global_position

	for node : CharacterBody3D in array:
		var distance : float = to_position.distance_squared_to(node.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = node
	return closest
