extends Node3D
class_name AudioElement

@export var audio_stream: AudioStreamPlayer3D


func change_audio_stream_pos(pos:Vector3,  listener: CharacterBody3D, player: CharacterBody3D):
	if audio_stream.playing:
		if listener !=player:
			var offset_globale = self.global_position - player.global_position
			var drotazione = listener.global_transform.basis.get_rotation_quaternion() * player.global_transform.basis.get_rotation_quaternion().inverse()
			var offset_ruotato = drotazione * offset_globale
			audio_stream.global_position = listener.global_position + offset_ruotato
		else:
			audio_stream.position = listener.position + Vector3(
			pos.x,
			pos.y,
			pos.z
			)

func get_nearest_player_position(player: CharacterBody3D)-> Vector3:
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
