extends Node
class_name VOIP_controller

@onready var input: AudioStreamPlayer = $Input
var idx : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
var mute = false
@export var output: AudioStreamPlayer3D
var pending_frames= []
func _enter_tree() -> void:
	set_multiplayer_authority(get_parent().name.to_int()) 
	
func _ready() -> void:
	if is_multiplayer_authority():
		input.stream = AudioStreamMicrophone.new()
		input.play()
		idx = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(idx, 3)
	playback = output.get_stream_playback()
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event.is_action_pressed("az_mute"):
		mute = !mute
		print(get_multiplayer_authority(), "Mute: ", mute)

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		var buffer_length = effect.get_frames_available()
		if not mute and effect.can_get_buffer(buffer_length):
			var data = effect.get_buffer(buffer_length)
			send_data.rpc(data)
			effect.clear_buffer()
	else:
		var frames_available = playback.get_frames_available()
		if frames_available > 0 and pending_frames.size() > 0:
			var to_push = min(frames_available, pending_frames.size())
			var chunk = pending_frames.slice(0, to_push)
			for frame in chunk:
				playback.push_frame(frame)
			pending_frames = pending_frames.slice(to_push)

@rpc("any_peer", "call_remote", "unreliable")
func send_data(data : PackedVector2Array):
	pending_frames.append_array(data)
